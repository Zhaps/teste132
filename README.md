RAVEN CONTROL CENTER
AUDITORIA 6.5.3.1 - API E POSTGRESQL
Data UTC: 2026-11-20T19:50:25.4294632Z
Projeto: C:\RavenRP\ControlCenter
API: C:\RavenRP\ControlCenter\API

AUDITORIA SOMENTE DE LEITURA.
Nenhum arquivo foi modificado.
Nenhuma migracao foi executada.
Nenhuma conexao ou escrita no PostgreSQL foi realizada.

===== 1. INVENTARIO =====
backups\incidents\20261118-214700\src\routes\health.js
backups\incidents\20261118-214700\src\server.js
backups\killfeed-integration-retry-20261118_211814\server.js
backups\shutdown-20261118-200552\server.js
migrations\001_initial_schema.sql
migrations\002_priority_integrity.sql
migrations\003_system_incidents.sql
package.json
src\db.js
src\middleware\require-auth.js
src\middleware\require-role.js
src\routes\audit.js
src\routes\auth.js
src\routes\health.js
src\routes\incidents.js
src\routes\killfeed.js
src\routes\logs.js
src\routes\players.js
src\routes\priority.js
src\server.js
src\services\audit.js
src\services\auth.js
src\services\incident-monitor.js
src\services\migrate.js
src\services\priority-format.js
src\services\priority-scheduler.js
src\services\priority-status.js
src\services\priority-sync.js
src\services\priority-sync.test.js
src\services\priority-sync-guard.js
src\services\priority-sync-guard.test.js
src\services\transaction.js

===== 2. CONTEUDO DOS ARQUIVOS =====

========================================
ARQUIVO: backups\incidents\20261118-214700\src\routes\health.js
========================================
'use strict';

const express = require('express');
const { pool } = require('../db');
const { killfeedPool } = require('../killfeed-db');

const router = express.Router();

async function checkDatabase(databasePool, req, label) {
    const start = process.hrtime.bigint();

    try {
        await databasePool.query('SELECT 1 AS result');

        const latencyMs = Number(
            process.hrtime.bigint() - start
        ) / 1_000_000;

        return {
            status: 'connected',
            latencyMs: Number(latencyMs.toFixed(2))
        };
    } catch (error) {
        req.log.error(
            { code: error.code, component: label },
            'Health check de banco falhou'
        );

        return {
            status: 'disconnected'
        };
    }
}

router.get('/', async (req, res) => {
    const [primaryDatabase, killfeedDatabase] = await Promise.all([
        checkDatabase(pool, req, 'postgresql'),
        checkDatabase(killfeedPool, req, 'killfeed')
    ]);

    const primaryConnected = primaryDatabase.status === 'connected';
    const killfeedConnected = killfeedDatabase.status === 'connected';

    const status = !primaryConnected
        ? 'degraded'
        : killfeedConnected
            ? 'ok'
            : 'degraded';

    const memory = process.memoryUsage();

    const response = {
        status,
        service: 'raven-control-api',
        timestamp: new Date().toISOString(),
        uptimeSeconds: Math.floor(process.uptime()),
        process: {
            memory: {
                rssMb: Number((memory.rss / 1024 / 1024).toFixed(2)),
                heapUsedMb: Number((memory.heapUsed / 1024 / 1024).toFixed(2)),
                heapTotalMb: Number((memory.heapTotal / 1024 / 1024).toFixed(2))
            }
        },
        databases: {
            primary: primaryDatabase,
            killfeed: killfeedDatabase
        }
    };

    if (!primaryConnected) {
        return res.status(503).json(response);
    }

    return res.status(200).json(response);
});

router.get('/live', (req, res) => {
    return res.status(200).json({
        status: 'alive',
        service: 'raven-control-api',
        timestamp: new Date().toISOString(),
        uptimeSeconds: Math.floor(process.uptime())
    });
});

module.exports = router;

========================================
ARQUIVO: backups\incidents\20261118-214700\src\server.js
========================================
'use strict';

const path = require('path');

require('dotenv').config({
    path: path.resolve(__dirname, '..', '.env')
});

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const pinoHttp = require('pino-http');

const logger = require('./logger');
const { pool } = require('./db');
const healthRoutes = require('./routes/health');
const authRoutes = require('./routes/auth');
const playersRoutes = require('./routes/players');
const priorityRoutes = require('./routes/priority');
const auditRoutes = require('./routes/audit');
const killfeedRoutes = require('./routes/killfeed');
const { startPriorityScheduler, stopPriorityScheduler } = require('./services/priority-scheduler');

const app = express();

const HOST = process.env.API_HOST || '127.0.0.1';
const PORT = Number(process.env.API_PORT || 3100);

const allowedOrigins = new Set(
    (process.env.CORS_ORIGINS || '')
        .split(',')
        .map(value => value.trim())
        .filter(Boolean)
);

app.disable('x-powered-by');

app.use(pinoHttp({ logger }));

app.use(helmet());

app.use(cors({
    origin: (origin, callback) => {
        if (!origin || allowedOrigins.has(origin)) {
            return callback(null, true);
        }

        return callback(null, false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
}));

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: false, limit: '1mb' }));

app.use(rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 300,
    standardHeaders: 'draft-8',
    legacyHeaders: false
}));

app.get('/', (req, res) => {
    res.json({
        name: 'Raven Control Center API',
        version: '1.0.0',
        status: 'running'
    });
});

app.use('/api/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/players', playersRoutes);
app.use('/api/priority', priorityRoutes);
app.use('/api/audit', auditRoutes);
app.use('/api/killfeed', killfeedRoutes);

app.use((req, res) => {
    res.status(404).json({
        error: 'ROUTE_NOT_FOUND'
    });
});

app.use((error, req, res, next) => {
    if (res.headersSent) {
        return next(error);
    }

    req.log.error({ error }, 'Erro na requisicao');

    res.status(error.status || 500).json({
        error: 'INTERNAL_SERVER_ERROR',
        message: 'Erro interno da API.'
    });
});

let server;

async function startServer() {
    await pool.query('SELECT 1');
    startPriorityScheduler();

    server = app.listen(PORT, HOST, () => {
        logger.info({
            host: HOST,
            port: PORT,
            database: process.env.DB_NAME
        }, 'Raven Control Center API iniciada');
    });

    server.on('error', (error) => {
        logger.error({ error }, 'Falha no servidor HTTP');
        process.exitCode = 1;
    });
}

let shuttingDown = false;

async function shutdown(signal) {
    if (shuttingDown) return;
    shuttingDown = true;

    logger.info({ signal }, 'Encerramento seguro da API iniciado');

    let shutdownError = null;

    try {
        await stopPriorityScheduler();
    } catch (error) {
        shutdownError = error;
        logger.error({ error }, 'Falha ao aguardar o agendador');
    }

    if (server) {
        try {
            await new Promise((resolve, reject) => {
                server.close((error) => {
                    if (error) reject(error);
                    else resolve();
                });

                if (typeof server.closeIdleConnections === 'function') {
                    server.closeIdleConnections();
                }
            });
        } catch (error) {
            shutdownError = shutdownError || error;
            logger.error({ error }, 'Falha ao encerrar servidor HTTP');
        }
    }

    try {
        await pool.end();
    } catch (error) {
        shutdownError = shutdownError || error;
        logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
    }

    if (shutdownError) {
        logger.error('API encerrada com erro durante o desligamento');
        process.exitCode = 1;
        return;
    }

    logger.info('API encerrada com seguranca');
    process.exitCode = 0;
}

process.on('SIGINT', () => {
    void shutdown('SIGINT');
});

process.on('SIGTERM', () => {
    void shutdown('SIGTERM');
});

startServer().catch(async (error) => {
    logger.fatal({ error }, 'Nao foi possivel iniciar a API');
    await pool.end();
    process.exit(1);
});

========================================
ARQUIVO: backups\killfeed-integration-retry-20261118_211814\server.js
========================================
'use strict';

const path = require('path');

require('dotenv').config({
    path: path.resolve(__dirname, '..', '.env')
});

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const pinoHttp = require('pino-http');

const logger = require('./logger');
const { pool } = require('./db');
const healthRoutes = require('./routes/health');
const authRoutes = require('./routes/auth');
const playersRoutes = require('./routes/players');
const priorityRoutes = require('./routes/priority');
const auditRoutes = require('./routes/audit');
const { startPriorityScheduler, stopPriorityScheduler } = require('./services/priority-scheduler');

const app = express();

const HOST = process.env.API_HOST || '127.0.0.1';
const PORT = Number(process.env.API_PORT || 3100);

const allowedOrigins = new Set(
    (process.env.CORS_ORIGINS || '')
        .split(',')
        .map(value => value.trim())
        .filter(Boolean)
);

app.disable('x-powered-by');

app.use(pinoHttp({ logger }));

app.use(helmet());

app.use(cors({
    origin: (origin, callback) => {
        if (!origin || allowedOrigins.has(origin)) {
            return callback(null, true);
        }

        return callback(null, false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
}));

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: false, limit: '1mb' }));

app.use(rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 300,
    standardHeaders: 'draft-8',
    legacyHeaders: false
}));

app.get('/', (req, res) => {
    res.json({
        name: 'Raven Control Center API',
        version: '1.0.0',
        status: 'running'
    });
});

app.use('/api/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/players', playersRoutes);
app.use('/api/priority', priorityRoutes);
app.use('/api/audit', auditRoutes);

app.use((req, res) => {
    res.status(404).json({
        error: 'ROUTE_NOT_FOUND'
    });
});

app.use((error, req, res, next) => {
    if (res.headersSent) {
        return next(error);
    }

    req.log.error({ error }, 'Erro na requisicao');

    res.status(error.status || 500).json({
        error: 'INTERNAL_SERVER_ERROR',
        message: 'Erro interno da API.'
    });
});

let server;

async function startServer() {
    await pool.query('SELECT 1');
    startPriorityScheduler();

    server = app.listen(PORT, HOST, () => {
        logger.info({
            host: HOST,
            port: PORT,
            database: process.env.DB_NAME
        }, 'Raven Control Center API iniciada');
    });

    server.on('error', (error) => {
        logger.error({ error }, 'Falha no servidor HTTP');
        process.exitCode = 1;
    });
}

let shuttingDown = false;

async function shutdown(signal) {
    if (shuttingDown) return;
    shuttingDown = true;

    logger.info({ signal }, 'Encerramento seguro da API iniciado');

    let shutdownError = null;

    try {
        await stopPriorityScheduler();
    } catch (error) {
        shutdownError = error;
        logger.error({ error }, 'Falha ao aguardar o agendador');
    }

    if (server) {
        try {
            await new Promise((resolve, reject) => {
                server.close((error) => {
                    if (error) reject(error);
                    else resolve();
                });

                if (typeof server.closeIdleConnections === 'function') {
                    server.closeIdleConnections();
                }
            });
        } catch (error) {
            shutdownError = shutdownError || error;
            logger.error({ error }, 'Falha ao encerrar servidor HTTP');
        }
    }

    try {
        await pool.end();
    } catch (error) {
        shutdownError = shutdownError || error;
        logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
    }

    if (shutdownError) {
        logger.error('API encerrada com erro durante o desligamento');
        process.exitCode = 1;
        return;
    }

    logger.info('API encerrada com seguranca');
    process.exitCode = 0;
}

process.on('SIGINT', () => {
    void shutdown('SIGINT');
});

process.on('SIGTERM', () => {
    void shutdown('SIGTERM');
});

startServer().catch(async (error) => {
    logger.fatal({ error }, 'Nao foi possivel iniciar a API');
    await pool.end();
    process.exit(1);
});

========================================
ARQUIVO: backups\shutdown-20261118-200552\server.js
========================================
'use strict';

const path = require('path');

require('dotenv').config({
    path: path.resolve(__dirname, '..', '.env')
});

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const pinoHttp = require('pino-http');

const logger = require('./logger');
const { pool } = require('./db');
const healthRoutes = require('./routes/health');
const authRoutes = require('./routes/auth');
const playersRoutes = require('./routes/players');
const priorityRoutes = require('./routes/priority');
const auditRoutes = require('./routes/audit');
const { startPriorityScheduler, stopPriorityScheduler } = require('./services/priority-scheduler');

const app = express();

const HOST = process.env.API_HOST || '127.0.0.1';
const PORT = Number(process.env.API_PORT || 3100);

const allowedOrigins = new Set(
    (process.env.CORS_ORIGINS || '')
        .split(',')
        .map(value => value.trim())
        .filter(Boolean)
);

app.disable('x-powered-by');

app.use(pinoHttp({ logger }));

app.use(helmet());

app.use(cors({
    origin: (origin, callback) => {
        if (!origin || allowedOrigins.has(origin)) {
            return callback(null, true);
        }

        return callback(null, false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
}));

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: false, limit: '1mb' }));

app.use(rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 300,
    standardHeaders: 'draft-8',
    legacyHeaders: false
}));

app.get('/', (req, res) => {
    res.json({
        name: 'Raven Control Center API',
        version: '1.0.0',
        status: 'running'
    });
});

app.use('/api/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/players', playersRoutes);
app.use('/api/priority', priorityRoutes);
app.use('/api/audit', auditRoutes);

app.use((req, res) => {
    res.status(404).json({
        error: 'ROUTE_NOT_FOUND'
    });
});

app.use((error, req, res, next) => {
    if (res.headersSent) {
        return next(error);
    }

    req.log.error({ error }, 'Erro na requisicao');

    res.status(error.status || 500).json({
        error: 'INTERNAL_SERVER_ERROR',
        message: 'Erro interno da API.'
    });
});

let server;

async function startServer() {
    await pool.query('SELECT 1');
    startPriorityScheduler();

    server = app.listen(PORT, HOST, () => {
        logger.info({
            host: HOST,
            port: PORT,
            database: process.env.DB_NAME
        }, 'Raven Control Center API iniciada');
    });

    server.on('error', (error) => {
        logger.error({ error }, 'Falha no servidor HTTP');
        process.exitCode = 1;
    });
}

async function shutdown(signal) {
    logger.info({ signal }, 'Encerrando API');
    stopPriorityScheduler();

    if (server) {
        server.close();
    }

    await pool.end();
    process.exit(0);
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

startServer().catch(async (error) => {
    logger.fatal({ error }, 'Nao foi possivel iniciar a API');
    await pool.end();
    process.exit(1);
});

========================================
ARQUIVO: migrations\001_initial_schema.sql
========================================
CREATE TABLE public.players (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    steam64 VARCHAR(17) NOT NULL UNIQUE
        CHECK (steam64 ~ '^[0-9]{17}$'),
    display_name VARCHAR(64),
    first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.admin_users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(64) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    access_role VARCHAR(20) NOT NULL DEFAULT 'admin'
        CHECK (access_role IN ('owner','admin','moderator','viewer')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.priority_categories (
    id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL,
    description TEXT,
    display_order SMALLINT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.priority_grants (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id BIGINT NOT NULL REFERENCES public.players(id),
    category_id SMALLINT NOT NULL REFERENCES public.priority_categories(id),
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('scheduled','active','revoked','expired')),
    grant_source VARCHAR(20) NOT NULL DEFAULT 'web'
        CHECK (grant_source IN ('web','discord','system')),
    reason TEXT,
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    granted_by_admin_id BIGINT REFERENCES public.admin_users(id),
    revoked_by_admin_id BIGINT REFERENCES public.admin_users(id),
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (expires_at IS NULL OR expires_at > starts_at)
);

CREATE TABLE public.discord_accounts (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id BIGINT NOT NULL UNIQUE REFERENCES public.players(id),
    discord_user_id VARCHAR(20) NOT NULL UNIQUE
        CHECK (discord_user_id ~ '^[0-9]{17,20}$'),
    discord_username VARCHAR(100),
    verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.audit_logs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    actor_type VARCHAR(20) NOT NULL
        CHECK (actor_type IN ('admin','discord','system')),
    actor_identifier VARCHAR(100),
    actor_admin_id BIGINT REFERENCES public.admin_users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(60),
    entity_id VARCHAR(100),
    details JSONB NOT NULL DEFAULT '{}'::JSONB,
    source_ip INET,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.system_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    setting_value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.queue_sync_runs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('running','success','failed')),
    players_count INTEGER NOT NULL DEFAULT 0
        CHECK (players_count >= 0),
    file_checksum VARCHAR(64),
    target_path TEXT,
    error_message TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ
);

CREATE INDEX idx_priority_grants_player
    ON public.priority_grants(player_id);

CREATE INDEX idx_priority_grants_category
    ON public.priority_grants(category_id);

CREATE INDEX idx_priority_grants_status_expiration
    ON public.priority_grants(status, expires_at);

CREATE INDEX idx_audit_logs_created
    ON public.audit_logs(created_at DESC);

CREATE INDEX idx_audit_logs_entity
    ON public.audit_logs(entity_type, entity_id);

CREATE INDEX idx_queue_sync_runs_started
    ON public.queue_sync_runs(started_at DESC);

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_players_updated_at
BEFORE UPDATE ON public.players
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_admin_users_updated_at
BEFORE UPDATE ON public.admin_users
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_priority_categories_updated_at
BEFORE UPDATE ON public.priority_categories
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_priority_grants_updated_at
BEFORE UPDATE ON public.priority_grants
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_system_settings_updated_at
BEFORE UPDATE ON public.system_settings
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

INSERT INTO public.priority_categories
    (code, name, description, display_order)
VALUES
    ('staff', 'Staff', 'Equipe administrativa do Raven RP', 1),
    ('supporters', 'Apoiadores', 'Apoiadores da comunidade', 2),
    ('events', 'Eventos', 'Vencedores e convidados de eventos', 3),
    ('creators', 'Criadores', 'Criadores de conteudo e parceiros', 4);

========================================
ARQUIVO: migrations\002_priority_integrity.sql
========================================
-- Corrigir concessoes cuja validade ja terminou
UPDATE public.priority_grants
SET status = 'expired',
    updated_at = NOW()
WHERE status IN ('active', 'scheduled')
  AND expires_at IS NOT NULL
  AND expires_at <= NOW();

-- Uma concessao aberta por jogador e categoria.
-- O mesmo jogador pode possuir categorias diferentes.
CREATE UNIQUE INDEX uq_priority_grants_player_category_open
ON public.priority_grants (player_id, category_id)
WHERE status IN ('active', 'scheduled');

-- Pesquisa de jogadores por nome
CREATE INDEX idx_players_display_name_lower
ON public.players (LOWER(display_name))
WHERE display_name IS NOT NULL;

-- Pesquisa de concessoes por validade
CREATE INDEX idx_priority_grants_expiration
ON public.priority_grants (expires_at)
WHERE status IN ('active', 'scheduled')
  AND expires_at IS NOT NULL;

-- Pesquisa de auditoria por administrador
CREATE INDEX idx_audit_logs_actor_admin
ON public.audit_logs (actor_admin_id, created_at DESC)
WHERE actor_admin_id IS NOT NULL;

========================================
ARQUIVO: migrations\003_system_incidents.sql
========================================
CREATE TABLE public.system_incidents (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    component VARCHAR(32) NOT NULL
        CHECK (component IN ('postgresql', 'killfeed')),
    severity VARCHAR(16) NOT NULL
        CHECK (severity IN ('warning', 'critical')),
    details JSONB NOT NULL DEFAULT '{}'::JSONB,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (resolved_at IS NULL OR resolved_at >= started_at)
);

CREATE UNIQUE INDEX uq_system_incidents_open_component
ON public.system_incidents (component)
WHERE resolved_at IS NULL;

CREATE INDEX idx_system_incidents_started
ON public.system_incidents (started_at DESC);

CREATE INDEX idx_system_incidents_resolved
ON public.system_incidents (resolved_at DESC)
WHERE resolved_at IS NOT NULL;


========================================
ARQUIVO: package.json
========================================
{
    "name": "raven-control-api",
    "version": "1.0.0",
    "description": "API central do Raven Control Center",
    "main": "src/server.js",
    "scripts": {
        "test": "node --test",
        "start": "node src/server.js",
        "dev": "node --watch src/server.js",
        "db:migrate": "node src/services/migrate.js"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "type": "commonjs",
    "private": true,
    "dependencies": {
        "bcryptjs": "3.0.3",
        "cors": "2.8.6",
        "dotenv": "18.0.10",
        "express": "5.3.0",
        "express-rate-limit": "8.7.4",
        "helmet": "8.3.0",
        "jose": "6.2.17",
        "pg": "8.23.1",
        "pino": "10.4.0",
        "pino-http": "11.0.0",
        "zod": "4.6.7"
    }
}


========================================
ARQUIVO: src\db.js
========================================
'use strict';

const { Pool } = require('pg');
const logger = require('./logger');

if (!process.env.DB_PASSWORD_B64) {
    throw new Error('DB_PASSWORD_B64 nao configurado.');
}

const password = Buffer
    .from(process.env.DB_PASSWORD_B64, 'base64')
    .toString('utf8');

const pool = new Pool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 5432),
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password,
    max: Number(process.env.DB_POOL_MAX || 5),
    connectionTimeoutMillis: Number(
        process.env.DB_CONNECTION_TIMEOUT || 5000
    ),
    idleTimeoutMillis: 10000,
    application_name: 'raven-control-api',
    ssl: false
});

pool.on('error', (error) => {
    logger.error({ error }, 'Erro inesperado no pool PostgreSQL');
});

module.exports = { pool };

========================================
ARQUIVO: src\middleware\require-auth.js
========================================
'use strict';

const { verifyAccessToken } = require('../services/auth');
const { pool } = require('../db');

async function requireAuth(req, res, next) {
    const authorization = req.get('authorization') || '';
    const match = authorization.match(/^Bearer\s+(.+)$/i);

    if (!match) {
        return res.status(401).json({
            error: 'AUTHENTICATION_REQUIRED'
        });
    }

    try {
        const payload = await verifyAccessToken(match[1]);
        const adminId = Number(payload.sub);

        if (!Number.isSafeInteger(adminId) || adminId <= 0) {
            return res.status(401).json({
                error: 'INVALID_TOKEN_SUBJECT'
            });
        }

        const result = await pool.query(
            `SELECT id, username, access_role, is_active
             FROM public.admin_users
             WHERE id = $1`,
            [adminId]
        );

        const admin = result.rows[0];

        if (!admin || !admin.is_active) {
            return res.status(401).json({
                error: 'ADMIN_INACTIVE'
            });
        }

        req.admin = {
            id: admin.id,
            username: admin.username,
            role: admin.access_role
        };

        return next();

    } catch (error) {
        if (
            error.code === 'ECONNREFUSED' ||
            error.code === '57P01'
        ) {
            req.log.error({ error }, 'PostgreSQL indisponivel');

            return res.status(503).json({
                error: 'AUTHENTICATION_SERVICE_UNAVAILABLE'
            });
        }

        if (error.name === 'JWTExpired') {
            return res.status(401).json({
                error: 'TOKEN_EXPIRED'
            });
        }

        if (
            error.code === 'ERR_JWS_INVALID' ||
            error.code === 'ERR_JWT_INVALID' ||
            error.code === 'ERR_JWT_EXPIRED' ||
            error.code === 'ERR_JWS_SIGNATURE_VERIFICATION_FAILED'
        ) {
            return res.status(401).json({
                error: 'INVALID_OR_EXPIRED_TOKEN'
            });
        }

        req.log.error({ error }, 'Falha na autenticacao');

        return res.status(500).json({
            error: 'AUTHENTICATION_ERROR'
        });
    }
}

module.exports = requireAuth;

========================================
ARQUIVO: src\middleware\require-role.js
========================================
'use strict';

module.exports = (...allowedRoles) => {
    return (req, res, next) => {
        if (!req.admin) {
            return res.status(401).json({ error: 'AUTHENTICATION_REQUIRED' });
        }

        if (!allowedRoles.includes(req.admin.role)) {
            return res.status(403).json({ error: 'INSUFFICIENT_PERMISSIONS' });
        }

        return next();
    };
};

========================================
ARQUIVO: src\routes\audit.js
========================================
'use strict';

const express = require('express');
const { z } = require('zod');

const { pool } = require('../db');
const requireAuth = require('../middleware/require-auth');
const requireRole = require('../middleware/require-role');

const router = express.Router();

router.use(requireAuth);
router.use(requireRole('owner', 'admin'));

const querySchema = z.object({
    action: z.string().trim().max(100).optional(),
    entityType: z.string().trim().max(60).optional(),
    entityId: z.string().trim().max(100).optional(),
    page: z.coerce.number().int().min(1).max(100000).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(50)
}).strict();

router.get('/', async (req, res) => {
    const parsed = querySchema.safeParse(req.query);

    if (!parsed.success) {
        return res.status(400).json({ error: 'INVALID_AUDIT_QUERY' });
    }

    const { action, entityType, entityId, page, limit } = parsed.data;

    const conditions = [];
    const values = [];

    if (action) {
        values.push(action);
        conditions.push(`action = $${values.length}`);
    }

    if (entityType) {
        values.push(entityType);
        conditions.push(`entity_type = $${values.length}`);
    }

    if (entityId) {
        values.push(entityId);
        conditions.push(`entity_id = $${values.length}`);
    }

    const where = conditions.length
        ? `WHERE ${conditions.join(' AND ')}`
        : '';

    try {
        const count = await pool.query(
            `SELECT COUNT(*)::integer AS total
             FROM public.audit_logs ${where}`,
            values
        );

        const queryValues = [
            ...values,
            limit,
            (page - 1) * limit
        ];

        const result = await pool.query(
            `SELECT
                id::text,
                actor_type,
                actor_identifier,
                actor_admin_id::text,
                action,
                entity_type,
                entity_id,
                details,
                source_ip,
                created_at
             FROM public.audit_logs
             ${where}
             ORDER BY created_at DESC
             LIMIT $${values.length + 1}
             OFFSET $${values.length + 2}`,
            queryValues
        );

        return res.json({
            page,
            limit,
            total: count.rows[0].total,
            entries: result.rows
        });
    } catch (error) {
        req.log.error({ error }, 'Falha ao consultar auditoria');

        return res.status(500).json({
            error: 'AUDIT_QUERY_ERROR'
        });
    }
});

module.exports = router;

========================================
ARQUIVO: src\routes\auth.js
========================================
'use strict';

const express = require('express');
const bcrypt = require('bcryptjs');
const { z } = require('zod');
const rateLimit = require('express-rate-limit');

const { pool } = require('../db');
const { createAccessToken } = require('../services/auth');
const requireAuth = require('../middleware/require-auth');

const router = express.Router();

const loginLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 5,
    skipSuccessfulRequests: true,		
    standardHeaders: 'draft-8',
    legacyHeaders: false,
    message: {
        error: 'TOO_MANY_LOGIN_ATTEMPTS'
    }
});

const loginSchema = z.object({
    username: z.string()
        .trim()
        .toLowerCase()
        .min(3)
        .max(64)
        .regex(/^[a-z0-9._-]+$/),

    password: z.string().min(14).max(72)
}).strict();

const dummyHash = bcrypt.hashSync(
    'raven-invalid-account-credential',
    12
);

router.post('/login', loginLimiter, async (req, res) => {
    const parsed = loginSchema.safeParse(req.body);

    if (!parsed.success) {
        return res.status(400).json({
            error: 'INVALID_LOGIN_DATA'
        });
    }

    const { username, password } = parsed.data;

    if (Buffer.byteLength(password, 'utf8') > 72) {
        return res.status(400).json({
            error: 'INVALID_LOGIN_DATA'
        });
    }

    try {
        const result = await pool.query(
            `SELECT id, username, password_hash,
                    access_role, is_active
             FROM public.admin_users
             WHERE username = $1`,
            [username]
        );

        const admin = result.rows[0];

        const passwordValid = await bcrypt.compare(
            password,
            admin ? admin.password_hash : dummyHash
        );

        if (!admin || !admin.is_active || !passwordValid) {
            return res.status(401).json({
                error: 'INVALID_CREDENTIALS'
            });
        }

        await pool.query(
            `UPDATE public.admin_users
             SET last_login_at = NOW()
             WHERE id = $1`,
            [admin.id]
        );

        const accessToken = await createAccessToken(admin);

        return res.status(200).json({
            accessToken,
            tokenType: 'Bearer',
            expiresIn: Number(
                process.env.AUTH_ACCESS_TTL_SECONDS || 900
            ),
            admin: {
                id: admin.id,
                username: admin.username,
                role: admin.access_role
            }
        });

    } catch (error) {
        req.log.error({ error }, 'Falha no login');

        return res.status(500).json({
            error: 'LOGIN_SERVICE_ERROR'
        });
    }
});

router.get('/me', requireAuth, (req, res) => {
    return res.json({
        admin: req.admin
    });
});

module.exports = router;

========================================
ARQUIVO: src\routes\health.js
========================================
'use strict';

const express = require('express');
const { pool } = require('../db');
const { killfeedPool } = require('../killfeed-db');
const { recordHealthSnapshot } = require('../services/incident-monitor');

const router = express.Router();

async function checkDatabase(databasePool, req, label) {
    const start = process.hrtime.bigint();

    try {
        await databasePool.query('SELECT 1 AS result');

        const latencyMs = Number(
            process.hrtime.bigint() - start
        ) / 1_000_000;

        return {
            status: 'connected',
            latencyMs: Number(latencyMs.toFixed(2))
        };
    } catch (error) {
        req.log.error(
            { code: error.code, component: label },
            'Health check de banco falhou'
        );

        return {
            status: 'disconnected'
        };
    }
}

router.get('/', async (req, res) => {
    const [primaryDatabase, killfeedDatabase] = await Promise.all([
        checkDatabase(pool, req, 'postgresql'),
        checkDatabase(killfeedPool, req, 'killfeed')
    ]);

    const primaryConnected = primaryDatabase.status === 'connected';
    const killfeedConnected = killfeedDatabase.status === 'connected';

    await recordHealthSnapshot({
        primary: primaryDatabase.status,
        killfeed: killfeedDatabase.status
    }, req.log);

    const status = !primaryConnected
        ? 'degraded'
        : killfeedConnected
            ? 'ok'
            : 'degraded';

    const memory = process.memoryUsage();

    const response = {
        status,
        service: 'raven-control-api',
        timestamp: new Date().toISOString(),
        uptimeSeconds: Math.floor(process.uptime()),
        process: {
            memory: {
                rssMb: Number((memory.rss / 1024 / 1024).toFixed(2)),
                heapUsedMb: Number((memory.heapUsed / 1024 / 1024).toFixed(2)),
                heapTotalMb: Number((memory.heapTotal / 1024 / 1024).toFixed(2))
            }
        },
        databases: {
            primary: primaryDatabase,
            killfeed: killfeedDatabase
        }
    };

    if (!primaryConnected) {
        return res.status(503).json(response);
    }

    return res.status(200).json(response);
});

router.get('/live', (req, res) => {
    return res.status(200).json({
        status: 'alive',
        service: 'raven-control-api',
        timestamp: new Date().toISOString(),
        uptimeSeconds: Math.floor(process.uptime())
    });
});

module.exports = router;


========================================
ARQUIVO: src\routes\incidents.js
========================================
'use strict';

const express = require('express');
const { z } = require('zod');

const { pool } = require('../db');
const requireAuth = require('../middleware/require-auth');
const requireRole = require('../middleware/require-role');

const router = express.Router();

router.use(requireAuth);
router.use(requireRole('owner', 'admin'));

const querySchema = z.object({
    page: z.coerce.number().int().min(1).max(100000).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(50)
}).strict();

router.get('/', async (req, res) => {
    const parsed = querySchema.safeParse(req.query);

    if (!parsed.success) {
        return res.status(400).json({
            error: 'INVALID_INCIDENT_QUERY'
        });
    }

    const { page, limit } = parsed.data;

    try {
        const count = await pool.query(
            `SELECT COUNT(*)::integer AS total
             FROM public.system_incidents`
        );

        const result = await pool.query(
            `SELECT
                id::text,
                component,
                severity,
                details,
                started_at,
                resolved_at,
                CASE
                    WHEN resolved_at IS NULL
                    THEN EXTRACT(EPOCH FROM (NOW() - started_at))::integer
                    ELSE EXTRACT(EPOCH FROM (resolved_at - started_at))::integer
                END AS duration_seconds,
                resolved_at IS NULL AS is_open
             FROM public.system_incidents
             ORDER BY started_at DESC
             LIMIT $1 OFFSET $2`,
            [limit, (page - 1) * limit]
        );

        return res.json({
            page,
            limit,
            total: count.rows[0].total,
            incidents: result.rows
        });
    } catch (error) {
        req.log.error(
            { code: error.code },
            'Falha ao consultar incidentes'
        );

        return res.status(500).json({
            error: 'INCIDENT_QUERY_ERROR'
        });
    }
});

module.exports = router;


========================================
ARQUIVO: src\routes\killfeed.js
========================================
'use strict';

const express = require('express');
const { z } = require('zod');
const { killfeedPool } = require('../killfeed-db');
const requireAuth = require('../middleware/require-auth');

const router = express.Router();
router.use(requireAuth);

const querySchema = z.object({
    search: z.string().trim().max(64).optional(),
    page: z.coerce.number().int().min(1).max(100000).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(50)
}).strict();

router.get('/', async (req, res) => {
    const parsed = querySchema.safeParse(req.query);

    if (!parsed.success) {
        return res.status(400).json({ error: 'INVALID_KILLFEED_QUERY' });
    }

    const { search, page, limit } = parsed.data;
    const offset = (page - 1) * limit;

    try {
        const values = [];
        let where = '';

        if (search) {
            values.push(`%${search}%`);
            where = 'WHERE (killer_name ILIKE $1 OR victim_name ILIKE $1 OR weapon ILIKE $1)';
        }

        const count = await killfeedPool.query(
            `SELECT COUNT(*)::integer AS total
             FROM public.pvp_kills ${where}`,
            values
        );

        const result = await killfeedPool.query(
            `SELECT id::text, occurred_at, killer_name, victim_name, weapon, distance_m
             FROM public.pvp_kills
             ${where}
             ORDER BY occurred_at DESC, id DESC
             LIMIT $${values.length + 1}
             OFFSET $${values.length + 2}`,
            [...values, limit, offset]
        );

        return res.json({
            page,
            limit,
            total: count.rows[0].total,
            kills: result.rows
        });
    } catch (error) {
        req.log.error({ code: error.code }, 'Falha ao consultar historico KillFeed');
        return res.status(503).json({ error: 'KILLFEED_DATABASE_UNAVAILABLE' });
    }
});

module.exports = router;

========================================
ARQUIVO: src\routes\logs.js
========================================
'use strict';

const express = require('express');
const fs = require('fs');
const path = require('path');
const { z } = require('zod');

const requireAuth = require('../middleware/require-auth');
const requireRole = require('../middleware/require-role');

const router = express.Router();

const logDir = path.resolve(__dirname, '..', '..', 'logs');

const MAX_FILES = 100;
const MAX_SCAN_BYTES = 100 * 1024 * 1024;
const MAX_LINE_LENGTH = 1024 * 1024;

router.use(requireAuth);
router.use(requireRole('owner', 'admin'));

const querySchema = z.object({
    level: z.enum([
        'trace', 'debug', 'info', 'warn', 'error', 'fatal'
    ]).optional(),

    component: z.string().trim().max(80).optional(),
    search: z.string().trim().max(200).optional(),

    from: z.string().datetime({ offset: true }).optional(),
    to: z.string().datetime({ offset: true }).optional(),

    page: z.coerce.number().int().min(1).max(100000).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(50)
}).strict().superRefine((value, context) => {
    if (
        value.from &&
        value.to &&
        new Date(value.from) > new Date(value.to)
    ) {
        context.addIssue({
            code: 'custom',
            path: ['from'],
            message: 'FROM_AFTER_TO'
        });
    }
});

const levelNames = {
    10: 'trace',
    20: 'debug',
    30: 'info',
    40: 'warn',
    50: 'error',
    60: 'fatal'
};

function normalizeLevel(value) {
    if (typeof value === 'string') {
        const normalized = value.toLowerCase();

        if ([
            'trace', 'debug', 'info',
            'warn', 'error', 'fatal'
        ].includes(normalized)) {
            return normalized;
        }

        if (/^\d+$/.test(value)) {
            return levelNames[Number(value)] || 'unknown';
        }
    }

    if (typeof value === 'number') {
        return levelNames[value] || 'unknown';
    }

    return 'unknown';
}

function redactValue(value, key = '') {
    const sensitiveKey =
        /(authorization|cookie|password|passwd|token|secret|api.?key|DB_PASSWORD_B64)/i;

    if (sensitiveKey.test(key)) {
        return '[REDACTED]';
    }

    if (Array.isArray(value)) {
        return value.map(item => redactValue(item));
    }

    if (value && typeof value === 'object') {
        const output = {};

        for (const [childKey, childValue] of Object.entries(value)) {
            output[childKey] = redactValue(childValue, childKey);
        }

        return output;
    }

    if (typeof value === 'string') {
        return value
            .replace(
                /(Bearer\s+)[A-Za-z0-9._~+/-]+=*/gi,
                '$1[REDACTED]'
            )
            .replace(
                /((?:password|passwd|token|secret|api[_-]?key)\s*[:=]\s*)[^,\s;]+/gi,
                '$1[REDACTED]'
            );
    }

    return value;
}

function getLogTimestamp(entry) {
    const value = entry.time || entry.timestamp || entry.datetime;
    const timestamp = typeof value === 'number'
        ? value
        : Date.parse(value);

    if (!Number.isFinite(timestamp)) {
        return null;
    }

    return timestamp;
}

function getComponent(entry) {
    return String(
        entry.component ||
        entry.name ||
        entry.event ||
        'general'
    );
}

function matchesFilters(entry, filters) {
    const level = normalizeLevel(entry.level);
    const component = getComponent(entry);
    const message = String(entry.msg || entry.message || '');

    if (filters.level && level !== filters.level) {
        return false;
    }

    if (
        filters.component &&
        !component.toLowerCase().includes(filters.component.toLowerCase())
    ) {
        return false;
    }

    if (
        filters.search &&
        !JSON.stringify(entry)
            .toLowerCase()
            .includes(filters.search.toLowerCase())
    ) {
        return false;
    }

    const timestamp = getLogTimestamp(entry);

    if (filters.from) {
        if (timestamp === null || timestamp < Date.parse(filters.from)) {
            return false;
        }
    }

    if (filters.to) {
        if (timestamp === null || timestamp > Date.parse(filters.to)) {
            return false;
        }
    }

    return true;
}

function publicEntry(entry) {
    const safe = redactValue(entry);

    return {
        time: safe.time || safe.timestamp || safe.datetime || null,
        level: normalizeLevel(safe.level),
        component: getComponent(safe),
        message: String(safe.msg || safe.message || ''),
        pid: safe.pid ?? null,
        hostname: safe.hostname ?? null,
        event: safe.event ?? null,
        details: safe
    };
}

router.get('/', async (req, res) => {
    const parsed = querySchema.safeParse(req.query);

    if (!parsed.success) {
        return res.status(400).json({
            error: 'INVALID_LOG_QUERY'
        });
    }

    const filters = parsed.data;
    const { page, limit } = filters;

    try {
        if (!fs.existsSync(logDir)) {
            return res.json({
                page,
                limit,
                total: 0,
                logs: [],
                filesScanned: 0
            });
        }

        const pattern = /^api-\d{4}-\d{2}-\d{2}-\d{3}\.log$/;

        let files = fs.readdirSync(logDir, { withFileTypes: true })
            .filter(item => item.isFile() && pattern.test(item.name))
            .map(item => item.name)
            .sort()
            .reverse();

        if (filters.from || filters.to) {
            const lower = filters.from
                ? Date.parse(filters.from)
                : -Infinity;

            const upper = filters.to
                ? Date.parse(filters.to)
                : Infinity;

            files = files.filter(name => {
                const match = name.match(/^api-(\d{4}-\d{2}-\d{2})-/);

                if (!match) return false;

                const dayStart = Date.parse(`${match[1]}T00:00:00.000Z`);
                const dayEnd = dayStart + 86400000 - 1;

                return dayEnd >= lower && dayStart <= upper;
            });
        }

        if (files.length > MAX_FILES) {
            return res.status(413).json({
                error: 'LOG_FILE_LIMIT_EXCEEDED',
                message: 'Reduza o periodo da consulta.'
            });
        }

        const selected = [];
        let total = 0;
        let scannedBytes = 0;
        let filesScanned = 0;

        const offset = (page - 1) * limit;
        const end = offset + limit;

        for (const filename of files) {
            const fullPath = path.join(logDir, filename);
            const stat = fs.statSync(fullPath);

            if (!stat.isFile()) continue;

            scannedBytes += stat.size;

            if (scannedBytes > MAX_SCAN_BYTES) {
                return res.status(413).json({
                    error: 'LOG_SCAN_LIMIT_EXCEEDED',
                    message: 'Reduza o periodo ou os filtros da consulta.'
                });
            }

            const content = await fs.promises.readFile(fullPath, 'utf8');
            const lines = content.split(/\r?\n/);

            filesScanned++;

            for (let index = lines.length - 1; index >= 0; index--) {
                const line = lines[index];

                if (!line || line.length > MAX_LINE_LENGTH) continue;

                let entry;

                try {
                    entry = JSON.parse(line);
                } catch {
                    continue;
                }

                if (!matchesFilters(entry, filters)) continue;

                if (total >= offset && total < end) {
                    selected.push(publicEntry(entry));
                }

                total++;
            }
        }

        return res.json({
            page,
            limit,
            total,
            logs: selected,
            filesScanned
        });

    } catch (error) {
        req.log.error(
            { code: error.code },
            'Falha ao consultar arquivos de log'
        );

        return res.status(500).json({
            error: 'LOG_QUERY_ERROR'
        });
    }
});

module.exports = router;

========================================
ARQUIVO: src\routes\players.js
========================================
'use strict';

const express = require('express');
const { z } = require('zod');

const { pool } = require('../db');
const { withTransaction } = require('../services/transaction');
const { writeAudit } = require('../services/audit');
const requireAuth = require('../middleware/require-auth');
const requireRole = require('../middleware/require-role');

const router = express.Router();

router.use(requireAuth);

const listSchema = z.object({
    search: z.string().trim().max(64).optional(),
    page: z.coerce.number().int().min(1).max(100000).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(25)
}).strict();

const createSchema = z.object({
    steam64: z.string().regex(/^[0-9]{17}$/),
    displayName: z.string().trim().min(1).max(64).nullable().optional()
}).strict();

router.get('/', async (req, res) => {
    const parsed = listSchema.safeParse(req.query);

    if (!parsed.success) {
        return res.status(400).json({ error: 'INVALID_QUERY' });
    }

    const { search, page, limit } = parsed.data;
    const offset = (page - 1) * limit;

    try {
        const values = [];
        let where = '';

        if (search) {
            values.push(search, `%${search}%`);
            where = 'WHERE (steam64 = $1 OR display_name ILIKE $2)';
        }

        const count = await pool.query(
            `SELECT COUNT(*)::integer AS total
             FROM public.players ${where}`,
            values
        );

        const paginationValues = [...values, limit, offset];
        const limitPosition = values.length + 1;
        const offsetPosition = values.length + 2;

        const result = await pool.query(
            `SELECT id::text, steam64, display_name,
                    first_seen_at, last_seen_at, created_at, updated_at
             FROM public.players
             ${where}
             ORDER BY created_at DESC
             LIMIT $${limitPosition} OFFSET $${offsetPosition}`,
            paginationValues
        );

        return res.json({
            page,
            limit,
            total: count.rows[0].total,
            players: result.rows
        });
    } catch (error) {
        req.log.error({ error }, 'Falha ao listar jogadores');

        return res.status(500).json({
            error: 'PLAYER_LIST_ERROR'
        });
    }
});

router.post(
    '/',
    requireRole('owner', 'admin', 'moderator'),
    async (req, res) => {
        const parsed = createSchema.safeParse(req.body);

        if (!parsed.success) {
            return res.status(400).json({
                error: 'INVALID_PLAYER_DATA',
                details: parsed.error.issues.map(issue => ({
                    field: issue.path.join('.'),
                    message: issue.message
                }))
            });
        }

        const { steam64, displayName } = parsed.data;

        try {
            const player = await withTransaction(async client => {
                const result = await client.query(
                    `INSERT INTO public.players
                        (steam64, display_name)
                     VALUES ($1, $2)
                     RETURNING id::text, steam64, display_name, created_at`,
                    [steam64, displayName || null]
                );

                const created = result.rows[0];

                await writeAudit(client, {
                    actorType: 'admin',
                    actorIdentifier: req.admin.username,
                    actorAdminId: req.admin.id,
                    action: 'player.created',
                    entityType: 'player',
                    entityId: created.id,
                    details: {
                        steam64,
                        displayName: displayName || null
                    },
                    sourceIp: req.ip
                });

                return created;
            });

            return res.status(201).json({ player });
        } catch (error) {
            if (error.code === '23505') {
                return res.status(409).json({
                    error: 'PLAYER_ALREADY_EXISTS'
                });
            }

            req.log.error({ error }, 'Falha ao cadastrar jogador');

            return res.status(500).json({
                error: 'PLAYER_CREATE_ERROR'
            });
        }
    }
);

module.exports = router;

========================================
ARQUIVO: src\routes\priority.js
========================================
'use strict';

const express = require('express');
const { z } = require('zod');

const { pool } = require('../db');
const { withTransaction } = require('../services/transaction');
const { writeAudit } = require('../services/audit');
const { refreshGrantStatuses } = require('../services/priority-status');
const requireAuth = require('../middleware/require-auth');
const requireRole = require('../middleware/require-role');

const router = express.Router();

router.use(requireAuth);

const grantSchema = z.object({
    steam64: z.string().regex(/^[0-9]{17}$/),
    categoryCode: z.string().trim().toLowerCase()
        .regex(/^[a-z0-9_-]{1,32}$/),
    startsAt: z.string().datetime({ offset: true }).optional(),
    expiresAt: z.union([
        z.string().datetime({ offset: true }),
        z.null()
    ]).optional(),
    reason: z.string().trim().max(500).nullable().optional()
}).strict();

const renewSchema = z.object({
    expiresAt: z.string().datetime({ offset: true }),
    reason: z.string().trim().max(500).nullable().optional()
}).strict();

const revokeSchema = z.object({
    reason: z.string().trim().max(500).nullable().optional()
}).strict();

const listSchema = z.object({
    status: z.enum(['active','scheduled','expired','revoked']).optional(),
    steam64: z.string().regex(/^[0-9]{17}$/).optional(),
    category: z.string().trim().toLowerCase()
        .regex(/^[a-z0-9_-]{1,32}$/).optional(),
    page: z.coerce.number().int().min(1).max(100000).default(1),
    limit: z.coerce.number().int().min(1).max(100).default(25)
}).strict();

function validId(value) {
    return typeof value === 'string' &&
        /^[1-9][0-9]{0,18}$/.test(value);
}

function sendOperationError(req, res, error, context) {
    if (error.statusCode) {
        return res.status(error.statusCode).json({
            error: error.codeName || 'OPERATION_REJECTED',
            message: error.message
        });
    }

    if (error.code === '23505') {
        return res.status(409).json({
            error: 'PRIORITY_ALREADY_EXISTS'
        });
    }

    req.log.error({ error }, context);

    return res.status(500).json({
        error: 'PRIORITY_OPERATION_ERROR'
    });
}

function operationError(statusCode, codeName, message) {
    const error = new Error(message);
    error.statusCode = statusCode;
    error.codeName = codeName;
    return error;
}

/* CATEGORIAS */

router.get('/categories', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT id, code, name, description, display_order
             FROM public.priority_categories
             WHERE is_active = TRUE
             ORDER BY display_order`
        );

        return res.json({ categories: result.rows });
    } catch (error) {
        req.log.error({ error }, 'Falha ao listar categorias');

        return res.status(500).json({
            error: 'CATEGORY_LIST_ERROR'
        });
    }
});

/* PRIORIDADES EFETIVAS */

router.get('/effective', async (req, res) => {
    try {
        const players = await withTransaction(async client => {
            await refreshGrantStatuses(client);

            const result = await client.query(`
                SELECT DISTINCT
                    p.steam64,
                    p.display_name
                FROM public.priority_grants g
                JOIN public.players p ON p.id = g.player_id
                WHERE g.status = 'active'
                  AND g.starts_at <= NOW()
                  AND (g.expires_at IS NULL OR g.expires_at > NOW())
                ORDER BY p.steam64
            `);

            return result.rows;
        });

        return res.json({
            count: players.length,
            players
        });
    } catch (error) {
        req.log.error({ error }, 'Falha ao consultar fila efetiva');

        return res.status(500).json({
            error: 'EFFECTIVE_QUEUE_ERROR'
        });
    }
});

/* LISTAR CONCESSOES */

router.get('/grants', async (req, res) => {
    const parsed = listSchema.safeParse(req.query);

    if (!parsed.success) {
        return res.status(400).json({ error: 'INVALID_QUERY' });
    }

    const { status, steam64, category, page, limit } = parsed.data;

    try {
        await withTransaction(refreshGrantStatuses);

        const conditions = [];
        const values = [];

        if (status) {
            values.push(status);
            conditions.push(`g.status = $${values.length}`);
        }

        if (steam64) {
            values.push(steam64);
            conditions.push(`p.steam64 = $${values.length}`);
        }

        if (category) {
            values.push(category);
            conditions.push(`c.code = $${values.length}`);
        }

        const where = conditions.length
            ? `WHERE ${conditions.join(' AND ')}`
            : '';

        const count = await pool.query(
            `SELECT COUNT(*)::integer AS total
             FROM public.priority_grants g
             JOIN public.players p ON p.id = g.player_id
             JOIN public.priority_categories c ON c.id = g.category_id
             ${where}`,
            values
        );

        const offset = (page - 1) * limit;
        const queryValues = [...values, limit, offset];
        const limitPosition = values.length + 1;
        const offsetPosition = values.length + 2;

        const result = await pool.query(
            `SELECT
                g.id::text,
                p.steam64,
                p.display_name,
                c.code AS category_code,
                c.name AS category_name,
                g.status,
                g.grant_source,
                g.reason,
                g.starts_at,
                g.expires_at,
                g.created_at,
                g.updated_at
             FROM public.priority_grants g
             JOIN public.players p ON p.id = g.player_id
             JOIN public.priority_categories c ON c.id = g.category_id
             ${where}
             ORDER BY g.created_at DESC
             LIMIT $${limitPosition} OFFSET $${offsetPosition}`,
            queryValues
        );

        return res.json({
            page,
            limit,
            total: count.rows[0].total,
            grants: result.rows
        });
    } catch (error) {
        req.log.error({ error }, 'Falha ao listar prioridades');

        return res.status(500).json({
            error: 'GRANT_LIST_ERROR'
        });
    }
});

/* CONCEDER PRIORIDADE */

router.post(
    '/grants',
    requireRole('owner', 'admin', 'moderator'),
    async (req, res) => {
        const parsed = grantSchema.safeParse(req.body);

        if (!parsed.success) {
            return res.status(400).json({
                error: 'INVALID_GRANT_DATA',
                details: parsed.error.issues.map(issue => ({
                    field: issue.path.join('.'),
                    message: issue.message
                }))
            });
        }

        const input = parsed.data;
        const startsAt = input.startsAt
            ? new Date(input.startsAt)
            : new Date();

        const expiresAt = input.expiresAt
            ? new Date(input.expiresAt)
            : null;

        if (expiresAt && expiresAt <= startsAt) {
            return res.status(400).json({
                error: 'INVALID_EXPIRATION_DATE'
            });
        }

        const status = startsAt > new Date()
            ? 'scheduled'
            : 'active';

        try {
            const grant = await withTransaction(async client => {
                await refreshGrantStatuses(client);

                const playerResult = await client.query(
                    `SELECT id FROM public.players
                     WHERE steam64 = $1`,
                    [input.steam64]
                );

                if (playerResult.rowCount === 0) {
                    throw operationError(
                        404,
                        'PLAYER_NOT_FOUND',
                        'Cadastre o jogador antes de conceder prioridade.'
                    );
                }

                const categoryResult = await client.query(
                    `SELECT id, code
                     FROM public.priority_categories
                     WHERE code = $1 AND is_active = TRUE`,
                    [input.categoryCode]
                );

                if (categoryResult.rowCount === 0) {
                    throw operationError(
                        404,
                        'CATEGORY_NOT_FOUND',
                        'Categoria inexistente ou inativa.'
                    );
                }

                const result = await client.query(
                    `INSERT INTO public.priority_grants
                        (player_id, category_id, status,
                         grant_source, reason, starts_at, expires_at,
                         granted_by_admin_id)
                     VALUES ($1,$2,$3,'web',$4,$5,$6,$7)
                     RETURNING id::text, status, starts_at, expires_at`,
                    [
                        playerResult.rows[0].id,
                        categoryResult.rows[0].id,
                        status,
                        input.reason || null,
                        startsAt,
                        expiresAt,
                        req.admin.id
                    ]
                );

                const created = result.rows[0];

                await writeAudit(client, {
                    actorType: 'admin',
                    actorIdentifier: req.admin.username,
                    actorAdminId: req.admin.id,
                    action: 'priority.granted',
                    entityType: 'priority_grant',
                    entityId: created.id,
                    details: {
                        steam64: input.steam64,
                        category: input.categoryCode,
                        status: created.status,
                        expiresAt: created.expires_at
                    },
                    sourceIp: req.ip
                });

                return created;
            });

            return res.status(201).json({ grant });
        } catch (error) {
            return sendOperationError(
                req, res, error, 'Falha ao conceder prioridade'
            );
        }
    }
);

/* RENOVAR PRIORIDADE */

router.post(
    '/grants/:id/renew',
    requireRole('owner', 'admin', 'moderator'),
    async (req, res) => {
        if (!validId(req.params.id)) {
            return res.status(400).json({ error: 'INVALID_GRANT_ID' });
        }

        const parsed = renewSchema.safeParse(req.body);

        if (!parsed.success) {
            return res.status(400).json({
                error: 'INVALID_RENEWAL_DATA'
            });
        }

        const newExpiry = new Date(parsed.data.expiresAt);

        try {
            const grant = await withTransaction(async client => {
                await refreshGrantStatuses(client);

                const current = await client.query(
                    `SELECT g.id, g.status, g.starts_at, g.expires_at,
                            p.steam64, c.code AS category_code
                     FROM public.priority_grants g
                     JOIN public.players p ON p.id = g.player_id
                     JOIN public.priority_categories c ON c.id = g.category_id
                     WHERE g.id = $1
                     FOR UPDATE OF g`,
                    [req.params.id]
                );

                if (current.rowCount === 0) {
                    throw operationError(404, 'GRANT_NOT_FOUND', 'Concessao nao encontrada.');
                }

                const old = current.rows[0];

                if (!['active', 'scheduled'].includes(old.status)) {
                    throw operationError(409, 'GRANT_NOT_RENEWABLE', 'Concessao nao esta ativa ou agendada.');
                }

                if (old.expires_at === null) {
                    throw operationError(409, 'GRANT_IS_PERMANENT', 'Concessao permanente nao precisa de renovacao.');
                }

                if (
                    newExpiry <= new Date(old.expires_at) ||
                    newExpiry <= new Date(old.starts_at)
                ) {
                    throw operationError(400, 'INVALID_RENEWAL_DATE', 'A nova validade deve ser posterior a validade atual.');
                }

                const result = await client.query(
                    `UPDATE public.priority_grants
                     SET expires_at = $1,
                         reason = COALESCE($2, reason),
                         status = CASE
                             WHEN starts_at > NOW() THEN 'scheduled'
                             ELSE 'active'
                         END
                     WHERE id = $3
                     RETURNING id::text, status, starts_at, expires_at`,
                    [
                        newExpiry,
                        parsed.data.reason || null,
                        req.params.id
                    ]
                );

                const updated = result.rows[0];

                await writeAudit(client, {
                    actorType: 'admin',
                    actorIdentifier: req.admin.username,
                    actorAdminId: req.admin.id,
                    action: 'priority.renewed',
                    entityType: 'priority_grant',
                    entityId: updated.id,
                    details: {
                        steam64: old.steam64,
                        category: old.category_code,
                        previousExpiry: old.expires_at,
                        newExpiry: updated.expires_at
                    },
                    sourceIp: req.ip
                });

                return updated;
            });

            return res.json({ grant });
        } catch (error) {
            return sendOperationError(
                req, res, error, 'Falha ao renovar prioridade'
            );
        }
    }
);

/* REVOGAR PRIORIDADE */

router.patch(
    '/grants/:id/revoke',
    requireRole('owner', 'admin', 'moderator'),
    async (req, res) => {
        if (!validId(req.params.id)) {
            return res.status(400).json({ error: 'INVALID_GRANT_ID' });
        }

        const parsed = revokeSchema.safeParse(req.body || {});

        if (!parsed.success) {
            return res.status(400).json({
                error: 'INVALID_REVOCATION_DATA'
            });
        }

        try {
            const grant = await withTransaction(async client => {
                await refreshGrantStatuses(client);

                const current = await client.query(
                    `SELECT g.id, g.status, p.steam64, c.code AS category_code
                     FROM public.priority_grants g
                     JOIN public.players p ON p.id = g.player_id
                     JOIN public.priority_categories c ON c.id = g.category_id
                     WHERE g.id = $1
                     FOR UPDATE OF g`,
                    [req.params.id]
                );

                if (current.rowCount === 0) {
                    throw operationError(404, 'GRANT_NOT_FOUND', 'Concessao nao encontrada.');
                }

                const old = current.rows[0];

                if (!['active', 'scheduled'].includes(old.status)) {
                    throw operationError(409, 'GRANT_NOT_REVOCABLE', 'Concessao nao esta ativa ou agendada.');
                }

                const result = await client.query(
                    `UPDATE public.priority_grants
                     SET status = 'revoked',
                         revoked_at = NOW(),
                         revoked_by_admin_id = $1,
                         reason = COALESCE($2, reason)
                     WHERE id = $3
                     RETURNING id::text, status, revoked_at`,
                    [
                        req.admin.id,
                        parsed.data.reason || null,
                        req.params.id
                    ]
                );

                const revoked = result.rows[0];

                await writeAudit(client, {
                    actorType: 'admin',
                    actorIdentifier: req.admin.username,
                    actorAdminId: req.admin.id,
                    action: 'priority.revoked',
                    entityType: 'priority_grant',
                    entityId: revoked.id,
                    details: {
                        steam64: old.steam64,
                        category: old.category_code,
                        reason: parsed.data.reason || null
                    },
                    sourceIp: req.ip
                });

                return revoked;
            });

            return res.json({ grant });
        } catch (error) {
            return sendOperationError(
                req, res, error, 'Falha ao revogar prioridade'
            );
        }
    }
);

module.exports = router;

========================================
ARQUIVO: src\server.js
========================================
'use strict';

const path = require('path');

require('dotenv').config({
    path: path.resolve(__dirname, '..', '.env')
});

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const pinoHttp = require('pino-http');

const logger = require('./logger');
const { pool } = require('./db');
const healthRoutes = require('./routes/health');
const authRoutes = require('./routes/auth');
const playersRoutes = require('./routes/players');
const priorityRoutes = require('./routes/priority');
const auditRoutes = require('./routes/audit');
const killfeedRoutes = require('./routes/killfeed');
const incidentsRoutes = require('./routes/incidents');
const logsRoutes = require('./routes/logs');
const { startPriorityScheduler, stopPriorityScheduler } = require('./services/priority-scheduler');

const app = express();

const HOST = process.env.API_HOST || '127.0.0.1';
const PORT = Number(process.env.API_PORT || 3100);

const allowedOrigins = new Set(
    (process.env.CORS_ORIGINS || '')
        .split(',')
        .map(value => value.trim())
        .filter(Boolean)
);

app.disable('x-powered-by');

app.use(pinoHttp({ logger }));

app.use(helmet());

app.use(cors({
    origin: (origin, callback) => {
        if (!origin || allowedOrigins.has(origin)) {
            return callback(null, true);
        }

        return callback(null, false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
}));

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: false, limit: '1mb' }));

app.use(rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 300,
    standardHeaders: 'draft-8',
    legacyHeaders: false
}));

app.get('/', (req, res) => {
    res.json({
        name: 'Raven Control Center API',
        version: '1.0.0',
        status: 'running'
    });
});

app.use('/api/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/players', playersRoutes);
app.use('/api/priority', priorityRoutes);
app.use('/api/audit', auditRoutes);
app.use('/api/killfeed', killfeedRoutes);
app.use('/api/incidents', incidentsRoutes);
app.use('/api/logs', logsRoutes);

app.use((req, res) => {
    res.status(404).json({
        error: 'ROUTE_NOT_FOUND'
    });
});

app.use((error, req, res, next) => {
    if (res.headersSent) {
        return next(error);
    }

    req.log.error({ error }, 'Erro na requisicao');

    res.status(error.status || 500).json({
        error: 'INTERNAL_SERVER_ERROR',
        message: 'Erro interno da API.'
    });
});

let server;

async function startServer() {
    await pool.query('SELECT 1');
    startPriorityScheduler();

    server = app.listen(PORT, HOST, () => {
        logger.info({
            host: HOST,
            port: PORT,
            database: process.env.DB_NAME
        }, 'Raven Control Center API iniciada');
    });

    server.on('error', (error) => {
        logger.error({ error }, 'Falha no servidor HTTP');
        process.exitCode = 1;
    });
}

let shuttingDown = false;

async function shutdown(signal) {
    if (shuttingDown) return;
    shuttingDown = true;

    logger.info({ signal }, 'Encerramento seguro da API iniciado');

    let shutdownError = null;

    try {
        await stopPriorityScheduler();
    } catch (error) {
        shutdownError = error;
        logger.error({ error }, 'Falha ao aguardar o agendador');
    }

    if (server) {
        try {
            await new Promise((resolve, reject) => {
                server.close((error) => {
                    if (error) reject(error);
                    else resolve();
                });

                if (typeof server.closeIdleConnections === 'function') {
                    server.closeIdleConnections();
                }
            });
        } catch (error) {
            shutdownError = shutdownError || error;
            logger.error({ error }, 'Falha ao encerrar servidor HTTP');
        }
    }

    try {
        await pool.end();
    } catch (error) {
        shutdownError = shutdownError || error;
        logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
    }

    if (shutdownError) {
        logger.error('API encerrada com erro durante o desligamento');
        process.exitCode = 1;
        return;
    }

    logger.info('API encerrada com seguranca');
    process.exitCode = 0;
}

process.on('SIGINT', () => {
    void shutdown('SIGINT');
});

process.on('SIGTERM', () => {
    void shutdown('SIGTERM');
});

startServer().catch(async (error) => {
    logger.fatal({ error }, 'Nao foi possivel iniciar a API');
    await pool.end();
    process.exit(1);
});


========================================
ARQUIVO: src\services\audit.js
========================================
'use strict';

async function writeAudit(client, data) {
    await client.query(
        `INSERT INTO public.audit_logs
        (actor_type, actor_identifier, actor_admin_id,
         action, entity_type, entity_id, details, source_ip)
         VALUES ($1,$2,$3,$4,$5,$6,$7::jsonb,$8)`,
        [
            data.actorType || 'admin',
            data.actorIdentifier || null,
            data.actorAdminId || null,
            data.action,
            data.entityType || null,
            data.entityId ? String(data.entityId) : null,
            JSON.stringify(data.details || {}),
            data.sourceIp || null
        ]
    );
}

module.exports = { writeAudit };

========================================
ARQUIVO: src\services\auth.js
========================================
'use strict';

const secret = Buffer.from(
    process.env.AUTH_JWT_SECRET_B64 || '',
    'base64'
);

if (secret.length !== 32) {
    throw new Error('Chave JWT invalida.');
}

const issuer = 'raven-control-api';
const audience = 'raven-control-dashboard';

async function createAccessToken(admin) {
    const { SignJWT } = await import('jose');

    const ttl = Number(
        process.env.AUTH_ACCESS_TTL_SECONDS || 900
    );

    if (!Number.isInteger(ttl) || ttl < 60 || ttl > 3600) {
        throw new Error('Validade JWT invalida.');
    }

    return new SignJWT({
        role: admin.access_role
    })
        .setProtectedHeader({ alg: 'HS256', typ: 'JWT' })
        .setSubject(String(admin.id))
        .setIssuer(issuer)
        .setAudience(audience)
        .setIssuedAt()
        .setExpirationTime(`${ttl}s`)
        .sign(secret);
}

async function verifyAccessToken(token) {
    const { jwtVerify } = await import('jose');

    const result = await jwtVerify(token, secret, {
        issuer,
        audience,
        algorithms: ['HS256']
    });

    return result.payload;
}

module.exports = {
    createAccessToken,
    verifyAccessToken
};

========================================
ARQUIVO: src\services\incident-monitor.js
========================================
'use strict';

const { pool } = require('../db');

let primaryOutageStartedAt = null;

async function recordHealthSnapshot(snapshot, logger) {
    const now = new Date();

    try {
        if (snapshot.primary === 'disconnected') {
            if (!primaryOutageStartedAt) {
                primaryOutageStartedAt = now;
            }
        } else if (primaryOutageStartedAt) {
            await pool.query(
                `INSERT INTO public.system_incidents
                    (component, severity, details, started_at, resolved_at)
                 VALUES ('postgresql', 'critical', $1::jsonb, $2, $3)`,
                [
                    JSON.stringify({
                        description: 'Indisponibilidade do PostgreSQL principal',
                        detection: 'health-check'
                    }),
                    primaryOutageStartedAt,
                    now
                ]
            );

            primaryOutageStartedAt = null;
        }

        if (snapshot.primary === 'connected') {
            if (snapshot.killfeed === 'disconnected') {
                await pool.query(
                    `INSERT INTO public.system_incidents
                        (component, severity, details)
                     VALUES (
                        'killfeed',
                        'warning',
                        $1::jsonb
                     )
                     ON CONFLICT (component)
                     WHERE resolved_at IS NULL
                     DO NOTHING`,
                    [JSON.stringify({
                        description: 'Banco KillFeed indisponível',
                        detection: 'health-check'
                    })]
                );
            } else {
                await pool.query(
                    `UPDATE public.system_incidents
                     SET resolved_at = NOW(),
                         details = details || $1::jsonb
                     WHERE component = 'killfeed'
                       AND resolved_at IS NULL`,
                    [JSON.stringify({
                        recovery: 'Banco KillFeed restabelecido'
                    })]
                );
            }

            await pool.query(
                `DELETE FROM public.system_incidents
                 WHERE resolved_at IS NOT NULL
                   AND resolved_at < NOW() - INTERVAL '90 days'`
            );
        }
    } catch (error) {
        if (logger && typeof logger.error === 'function') {
            logger.error(
                { code: error.code, message: error.message },
                'Falha ao registrar histórico de incidentes'
            );
        }
    }
}

module.exports = {
    recordHealthSnapshot
};


========================================
ARQUIVO: src\services\migrate.js
========================================
'use strict';

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

require('dotenv').config({
    path: path.resolve(__dirname, '..', '..', '.env')
});

const logger = require('../logger');
const { pool } = require('../db');

const MIGRATIONS_DIR = path.resolve(__dirname, '..', '..', 'migrations');

async function main() {
    let client;
    let lockAcquired = false;

    try {
        client = await pool.connect();

        await client.query(
            'SELECT pg_advisory_lock($1::integer, $2::integer)',
            [741923, 1]
        );

        lockAcquired = true;

        await client.query(`
            CREATE TABLE IF NOT EXISTS public.schema_migrations (
                version VARCHAR(20) PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                checksum VARCHAR(64) NOT NULL,
                execution_ms INTEGER NOT NULL DEFAULT 0,
                applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            )
        `);

        const files = fs.readdirSync(MIGRATIONS_DIR)
            .filter(file => /^\d+_.+\.sql$/i.test(file))
            .sort();

        if (files.length === 0) {
            throw new Error('Nenhuma migration encontrada.');
        }

        let applied = 0;

        for (const file of files) {
            const version = file.match(/^(\d+)_/)[1];

            const sql = fs.readFileSync(
                path.join(MIGRATIONS_DIR, file),
                'utf8'
            );

            const checksum = crypto
                .createHash('sha256')
                .update(sql)
                .digest('hex');

            const existing = await client.query(
                'SELECT checksum FROM public.schema_migrations WHERE version = $1',
                [version]
            );

            if (existing.rowCount > 0) {
                if (existing.rows[0].checksum !== checksum) {
                    throw new Error(`Checksum divergente: ${file}`);
                }

                logger.info({ version, file }, 'Migration ja aplicada');
                continue;
            }

            const startedAt = Date.now();

            await client.query('BEGIN');

            try {
                await client.query(sql);

                const executionMs = Date.now() - startedAt;

                await client.query(
                    `INSERT INTO public.schema_migrations
                    (version, name, checksum, execution_ms)
                    VALUES ($1, $2, $3, $4)`,
                    [version, file, checksum, executionMs]
                );

                await client.query('COMMIT');

                applied++;

                logger.info(
                    { version, file, executionMs },
                    'Migration aplicada'
                );
            } catch (error) {
                await client.query('ROLLBACK');
                throw error;
            }
        }

        logger.info(
            { applied, total: files.length },
            'Migrations concluidas'
        );
    } finally {
        if (client) {
            if (lockAcquired) {
                await client.query(
                    'SELECT pg_advisory_unlock($1::integer, $2::integer)',
                    [741923, 1]
                );
            }

            client.release();
        }

        await pool.end();
    }
}

main().catch(error => {
    logger.fatal({ error }, 'Falha nas migrations');
    process.exitCode = 1;
});

========================================
ARQUIVO: src\services\priority-format.js
========================================
'use strict';

function buildPriorityFileContent(rows) {
    if (!Array.isArray(rows)) {
        throw new TypeError('Lista de jogadores invalida.');
    }

    const ids = new Set();

    for (const row of rows) {
        const steam64 = row.steam64;

        if (typeof steam64 !== 'string' || !/^[0-9]{17}$/.test(steam64)) {
            throw new Error('Steam64 invalido encontrado na fila efetiva.');
        }

        ids.add(steam64);
    }

    return [...ids].sort().join(';');
}

module.exports = { buildPriorityFileContent };


========================================
ARQUIVO: src\services\priority-scheduler.js
========================================
'use strict';

const logger = require('../logger');
const { withTransaction } = require('./transaction');
const { refreshGrantStatuses } = require('./priority-status');
const { runPrioritySync } = require('./priority-sync');

let timer = null;
let runningPromise = null;
let stopping = false;

function runPriorityScheduler() {
    if (stopping) return Promise.resolve();
    if (runningPromise) return runningPromise;

    runningPromise = (async () => {
        try {
            const result = await withTransaction(refreshGrantStatuses);

            if (result.expired || result.activated) {
                logger.info(result, 'Concessoes prioritarias atualizadas');
            }

            if (process.env.PRIORITY_SYNC_ENABLED === 'true') {
                await runPrioritySync({
                    dryRun: process.env.PRIORITY_SYNC_DRY_RUN !== 'false'
                });
            }
        } catch (error) {
            logger.error({ error }, 'Falha no agendador de prioridades');
        }
    })().finally(() => {
        runningPromise = null;
    });

    return runningPromise;
}

function startPriorityScheduler() {
    if (timer) return;

    stopping = false;

    void runPriorityScheduler();

    timer = setInterval(() => {
        void runPriorityScheduler();
    }, 60 * 1000);

    if (typeof timer.unref === 'function') {
        timer.unref();
    }

    logger.info('Agendador de prioridades iniciado');
}

async function stopPriorityScheduler() {
    stopping = true;

    if (timer) {
        clearInterval(timer);
        timer = null;
    }

    if (runningPromise) {
        await runningPromise;
    }

    logger.info('Agendador de prioridades encerrado');
}

module.exports = {
    startPriorityScheduler,
    stopPriorityScheduler,
    runPriorityScheduler
};

========================================
ARQUIVO: src\services\priority-status.js
========================================
'use strict';

async function refreshGrantStatuses(client) {
    const expired = await client.query(`
        WITH changed AS (
            UPDATE public.priority_grants
            SET status = 'expired'
            WHERE status IN ('active','scheduled')
              AND expires_at IS NOT NULL
              AND expires_at <= NOW()
            RETURNING id, player_id, category_id
        )
        INSERT INTO public.audit_logs
        (actor_type, actor_identifier, action,
         entity_type, entity_id, details)
        SELECT
            'system',
            'priority-scheduler',
            'priority.expired',
            'priority_grant',
            id::text,
            jsonb_build_object(
                'player_id', player_id,
                'category_id', category_id
            )
        FROM changed
        RETURNING id
    `);

    const activated = await client.query(`
        WITH changed AS (
            UPDATE public.priority_grants
            SET status = 'active'
            WHERE status = 'scheduled'
              AND starts_at <= NOW()
              AND (expires_at IS NULL OR expires_at > NOW())
            RETURNING id, player_id, category_id
        )
        INSERT INTO public.audit_logs
        (actor_type, actor_identifier, action,
         entity_type, entity_id, details)
        SELECT
            'system',
            'priority-scheduler',
            'priority.activated',
            'priority_grant',
            id::text,
            jsonb_build_object(
                'player_id', player_id,
                'category_id', category_id
            )
        FROM changed
        RETURNING id
    `);

    return {
        expired: expired.rowCount,
        activated: activated.rowCount
    };
}

module.exports = { refreshGrantStatuses };

========================================
ARQUIVO: src\services\priority-sync.js
========================================
'use strict';

const fs = require('node:fs/promises');
const fsConstants = require('node:fs').constants;
const path = require('node:path');
const crypto = require('node:crypto');

const { pool } = require('../db');
const logger = require('../logger');
const { buildPriorityFileContent } = require('./priority-format');
const { shouldBlockEmptyPriorityWrite } = require('./priority-sync-guard');

const TARGET_DIR = path.resolve(__dirname, '../../../../DayZServer');
const TARGET_FILE = path.join(TARGET_DIR, 'priority.txt');

const LOCK_A = 1380013138;
const LOCK_B = 1346458195;

function sha256(content) {
    return crypto.createHash('sha256').update(content, 'utf8').digest('hex');
}

async function validateTargetDirectory() {
    const stat = await fs.lstat(TARGET_DIR);

    if (!stat.isDirectory() || stat.isSymbolicLink()) {
        throw new Error('Diretorio de destino invalido ou simbolico.');
    }
}

async function backupExistingFile() {
    let stat;

    try {
        stat = await fs.lstat(TARGET_FILE);
    } catch (error) {
        if (error.code === 'ENOENT') return null;
        throw error;
    }

    if (!stat.isFile() || stat.isSymbolicLink()) {
        throw new Error('O destino priority.txt nao e um arquivo regular.');
    }

    const stamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backup = `${TARGET_FILE}.bak-${stamp}`;

    await fs.copyFile(TARGET_FILE, backup, fsConstants.COPYFILE_EXCL);
    return backup;
}

async function writePriorityFile(content) {
    await validateTargetDirectory();

    let existing = null;

    try {
        const stat = await fs.lstat(TARGET_FILE);

        if (!stat.isFile() || stat.isSymbolicLink()) {
            throw new Error('O destino priority.txt nao e um arquivo regular.');
        }

        existing = await fs.readFile(TARGET_FILE, 'utf8');
    } catch (error) {
        if (error.code !== 'ENOENT') throw error;
    }

    if (existing === content) {
        return { changed: false, backup: null };
    }

    const backup = await backupExistingFile();

    if (content.length === 0) {
        try {
            await fs.unlink(TARGET_FILE);
        } catch (error) {
            if (error.code !== 'ENOENT') throw error;
        }

        return { changed: true, backup };
    }

    const temp = `${TARGET_FILE}.tmp-${process.pid}-${crypto.randomBytes(6).toString('hex')}`;

    try {
        await fs.writeFile(temp, content, {
            encoding: 'utf8',
            flag: 'wx'
        });

        await fs.rename(temp, TARGET_FILE);
    } catch (error) {
        try {
            await fs.unlink(temp);
        } catch (_) {}

        throw error;
    }

    return { changed: true, backup };
}

async function runPrioritySync(options = {}) {
    const dryRun = options.dryRun !== false;
    const client = await pool.connect();

    let locked = false;
    let runId = null;

    try {
        const lock = await client.query(
            'SELECT pg_try_advisory_lock($1, $2) AS acquired',
            [LOCK_A, LOCK_B]
        );

        locked = lock.rows[0].acquired;

        if (!locked) {
            return { status: 'skipped', reason: 'SYNC_ALREADY_RUNNING' };
        }

        const started = await client.query(
            `INSERT INTO public.queue_sync_runs
                (status, players_count, target_path)
             VALUES ('running', 0, $1)
             RETURNING id`,
            [TARGET_FILE]
        );

        runId = started.rows[0].id;

        const result = await client.query(`
            SELECT DISTINCT p.steam64
            FROM public.priority_grants g
            JOIN public.players p ON p.id = g.player_id
            WHERE g.status = 'active'
              AND g.starts_at <= NOW()
              AND (g.expires_at IS NULL OR g.expires_at > NOW())
            ORDER BY p.steam64
        `);

        const content = buildPriorityFileContent(result.rows);
        const checksum = sha256(content);

        let fileResult = { changed: false, backup: null };
        let emptyListProtected = false;

        if (!dryRun) {
            const allowEmpty = process.env.PRIORITY_SYNC_ALLOW_EMPTY === 'true';

            if (shouldBlockEmptyPriorityWrite(content, allowEmpty)) {
                emptyListProtected = true;

                logger.warn({
                    runId: String(runId),
                    mode: 'LIVE',
                    playersCount: 0,
                    targetPath: TARGET_FILE
                }, 'Sincronizacao LIVE bloqueada: lista vazia protegida');
            } else {
                fileResult = await writePriorityFile(content);
            }
        }

        await client.query(
            `UPDATE public.queue_sync_runs
             SET status = 'success',
                 players_count = $1,
                 file_checksum = $2,
                 finished_at = NOW()
             WHERE id = $3`,
            [result.rows.length, checksum, runId]
        );

        const response = {
            status: 'success',
            mode: dryRun ? 'DRY_RUN' : 'LIVE',
            runId: String(runId),
            playersCount: result.rows.length,
            checksum,
            targetPath: TARGET_FILE,
            fileChanged: fileResult.changed,
            backup: fileResult.backup,
            emptyListProtected,
            writeBlockedReason: emptyListProtected
                ? 'EMPTY_PRIORITY_LIST_PROTECTED'
                : null
        };

        logger.info(response, 'Sincronizacao de prioridades concluida');

        return response;
    } catch (error) {
        if (runId !== null) {
            try {
                await client.query(
                    `UPDATE public.queue_sync_runs
                     SET status = 'failed',
                         error_message = $1,
                         finished_at = NOW()
                     WHERE id = $2`,
                    [String(error.message).slice(0, 2000), runId]
                );
            } catch (recordError) {
                logger.error({ error: recordError }, 'Falha ao registrar erro da sincronizacao');
            }
        }

        logger.error({ error }, 'Falha na sincronizacao de prioridades');
        throw error;
    } finally {
        if (locked) {
            try {
                await client.query(
                    'SELECT pg_advisory_unlock($1, $2)',
                    [LOCK_A, LOCK_B]
                );
            } catch (error) {
                logger.error({ error }, 'Falha ao liberar lock da sincronizacao');
            }
        }

        client.release();
    }
}

module.exports = {
    buildPriorityFileContent,
    runPrioritySync,
    TARGET_FILE
};


========================================
ARQUIVO: src\services\priority-sync.test.js
========================================
'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');

const { buildPriorityFileContent } = require('./priority-format');

test('gera lista ordenada e sem duplicidades', () => {
    const result = buildPriorityFileContent([
        { steam64: '76561198000000002' },
        { steam64: '76561198000000001' },
        { steam64: '76561198000000002' }
    ]);

    assert.equal(result, '76561198000000001;76561198000000002');
});

test('lista vazia gera conteudo vazio', () => {
    assert.equal(buildPriorityFileContent([]), '');
});

test('rejeita Steam64 invalido', () => {
    assert.throws(
        () => buildPriorityFileContent([{ steam64: '12345' }]),
        /Steam64 invalido/
    );
});

test('rejeita entrada que nao seja uma lista', () => {
    assert.throws(
        () => buildPriorityFileContent(null),
        /Lista de jogadores invalida/
    );
});


========================================
ARQUIVO: src\services\priority-sync-guard.js
========================================
'use strict';

function shouldBlockEmptyPriorityWrite(content, allowEmpty) {
    if (typeof content !== 'string') {
        throw new TypeError('Conteudo da lista de prioridades invalido.');
    }

    return content.length === 0 && allowEmpty !== true;
}

module.exports = {
    shouldBlockEmptyPriorityWrite
};

========================================
ARQUIVO: src\services\priority-sync-guard.test.js
========================================
'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');

const {
    shouldBlockEmptyPriorityWrite
} = require('./priority-sync-guard');

test('bloqueia escrita de lista vazia por padrao', () => {
    assert.equal(shouldBlockEmptyPriorityWrite('', false), true);
});

test('bloqueia escrita de lista vazia quando autorizacao esta ausente', () => {
    assert.equal(shouldBlockEmptyPriorityWrite('', undefined), true);
});

test('permite lista vazia somente com autorizacao explicita', () => {
    assert.equal(shouldBlockEmptyPriorityWrite('', true), false);
});

test('permite escrita quando existe conteudo', () => {
    assert.equal(
        shouldBlockEmptyPriorityWrite('76561198000000001', false),
        false
    );
});

test('rejeita conteudo que nao seja texto', () => {
    assert.throws(
        () => shouldBlockEmptyPriorityWrite(null, false),
        /Conteudo da lista/
    );
});

========================================
ARQUIVO: src\services\transaction.js
========================================
'use strict';

const { pool } = require('../db');

async function withTransaction(callback) {
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        const result = await callback(client);

        await client.query('COMMIT');
        return result;
    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
}

module.exports = { withTransaction };

===== 3. ESTRUTURA DE DIRETORIOS =====
backups\
logs\
migrations\
node_modules\
scripts\
src\
backups\empty-list-protection-20261118-202749\
backups\incidents\
backups\killfeed-integration-20261118_211705\
backups\killfeed-integration-retry-20261118_211814\
backups\logging\
backups\logs-diagnostics\
backups\monitoring\
backups\priority-sync-20261118-194214\
backups\priority-sync-fix-20261118-194353\
backups\shutdown-20261118-200552\
backups\incidents\20261118-214700\
backups\incidents\20261118-215606\
backups\incidents\20261118-214700\src\
backups\incidents\20261118-214700\src\routes\
src\middleware\
src\routes\
src\services\

===== 4. RESUMO =====
Arquivos analisados: 32
Relatorio: C:\Users\Nasdara\Desktop\RAVEN_AUDITORIA_6.5.3.1.txt
FIM DA AUDITORIA
