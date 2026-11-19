========== C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql ==========
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

========== C:\RavenRP\ControlCenter\API\migrations\003_system_incidents.sql ==========
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


========== C:\RavenRP\ControlCenter\API\src\db.js ==========
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

========== C:\RavenRP\ControlCenter\API\src\server.js ==========
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


========== C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js ==========
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

========== C:\RavenRP\ControlCenter\API\src\middleware\require-role.js ==========
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

========== C:\RavenRP\ControlCenter\API\src\routes\health.js ==========
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


========== C:\RavenRP\ControlCenter\API\src\routes\incidents.js ==========
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


========== C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js ==========
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


========== DASHBOARD: ESTRUTURA E PONTOS DE INTEGRAÇÃO ==========

--- PADRÃO: overview ---
imary" type="submit" id="loginButton">Entrar no sistema</button>
    <div id="loginMessage" class="error" role="alert"></div>
  </form>
</section>

<div id="app" class="app hidden">
  <aside class="sidebar">
    <div class="brand">RAVEN<span>.</span></div>
    <div class="nav-label">GERENCIAMENTO</div>
    <button class="nav-btn active" data-page="overview">â—ˆ VisÃ£o geral</button>
    <button class="nav-btn" data-page="players">â™™ Jogadores</button>
    <button class="nav-btn" data-page="priorities">â—† Prioridades</button>
    <button class="nav-btn" data-page="audit" id="auditNav">â–¤ Auditoria</button>
    <button class="nav-btn" data-page="killfeed">âš” KillFeed</button>
    <button class="nav-btn" data-page="incidents" id="incidentsNav">â—· Incidentes</button>
    <button class="nav-btn" data-page="logs" id="logsNav">Logs e Diagnosticos</button>
    <div class="sidebar-bottom">
      <div class="user-name" id="sideUsername">Administrador</div>
      <div class="user-role" id="sideRole">Perfil</div>
      <button class="btn btn-small" id="logoutButton" style="margin-top:15px;
ENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
})[c]);

function notify(message, type = '') {
  $('globalMessage').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (token) headers.Authorization = `Bearer ${token}`;
  if (options.body !== undefined) headers['Content-Type'] = 'application/json';

  const response = await fetch(API + path, {
    ...options,
    headers,
    body: optio
me:$('username').value.trim(),
        password:$('password').value
      }
    });
    token = result.accessToken;
    sessionStorage.setItem(TOKEN_KEY, token);

    const me = await api('/auth/me');
    admin = me.admin;
    sessionStorage.setItem(ADMIN_KEY, JSON.stringify(admin));
    $('password').value = '';
    showApp();
    await navigate('overview');
  } catch (error) {
    message.textContent = error.message;
  } finally {
    button.disabled = false;
  }
});

$('logoutButton').addEventListener('click', logout);

document.querySelectorAll('.nav-btn').forEach(button => {
  button.addEventListener('click', () => navigate(button.dataset.page));
});

function titleFor(page) {
  return ({
    overview:'VisÃ£o geral',
    players:'Jogadores',
    priorities:'Prioridades',
    audit:'Auditoria',
    killfeed:'KillFeed',
    incidents:'Incidentes',
    logs:'Logs e Diagnosticos'
  })[page] || 'Raven Control Center';
}

async function navigate(page) {
  if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
    return notify('Seu perfil nÃ£o possui acesso Ã  auditori
w');
  } catch (error) {
    message.textContent = error.message;
  } finally {
    button.disabled = false;
  }
});

$('logoutButton').addEventListener('click', logout);

document.querySelectorAll('.nav-btn').forEach(button => {
  button.addEventListener('click', () => navigate(button.dataset.page));
});

function titleFor(page) {
  return ({
    overview:'VisÃ£o geral',
    players:'Jogadores',
    priorities:'Prioridades',
    audit:'Auditoria',
    killfeed:'KillFeed',
    incidents:'Incidentes',
    logs:'Logs e Diagnosticos'
  })[page] || 'Raven Control Center';
}

async function navigate(page) {
  if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
    return notify('Seu perfil nÃ£o possui acesso Ã  auditoria.', 'error');
  }
  if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {
    return notify('Acesso restrito.', 'error');
  }
  currentPage = page;
  document.querySelectorAll('.nav-btn').forEach(button => {
    button.classList.toggle('active', button.dataset.page === page);
  });
  $('topTitle').textContent = titleFor(p
s(page) && !['owner','admin'].includes(admin?.role)) {
    return notify('Acesso restrito.', 'error');
  }
  currentPage = page;
  document.querySelectorAll('.nav-btn').forEach(button => {
    button.classList.toggle('active', button.dataset.page === page);
  });
  $('topTitle').textContent = titleFor(page);
  notify('');
  try {
    if (page === 'overview') await renderOverview();
    if (page === 'players') await renderPlayers();
    if (page === 'priorities') await renderPriorities();
    if (page === 'audit') await renderAudit();
    if (page === 'incidents') await renderIncidents();
    if (page === 'logs') await renderLogs();
    if (page === 'killfeed') await renderKillfeed();
  } catch (error) {
    $('pageContent').innerHTML = `<div class="panel message error">${esc(error.message)}</div>`;
  }
}

async function checkHealth() {
  const setMonitorState = (id, connected, label) => {
    const element = $(id);
    if (!element) return;

    element.textContent = label;
    element.classList.toggle('bad', !connected);
  };

  const setMonitorText = (id, value) => {
    const e
dmin'].includes(admin?.role)) {
    return notify('Acesso restrito.', 'error');
  }
  currentPage = page;
  document.querySelectorAll('.nav-btn').forEach(button => {
    button.classList.toggle('active', button.dataset.page === page);
  });
  $('topTitle').textContent = titleFor(page);
  notify('');
  try {
    if (page === 'overview') await renderOverview();
    if (page === 'players') await renderPlayers();
    if (page === 'priorities') await renderPriorities();
    if (page === 'audit') await renderAudit();
    if (page === 'incidents') await renderIncidents();
    if (page === 'logs') await renderLogs();
    if (page === 'killfeed') await renderKillfeed();
  } catch (error) {
    $('pageContent').innerHTML = `<div class="panel message error">${esc(error.message)}</div>`;
  }
}

async function checkHealth() {
  const setMonitorState = (id, connected, label) => {
    const element = $(id);
    if (!element) return;

    element.textContent = label;
    element.classList.toggle('bad', !connected);
  };

  const setMonitorText = (id, value) => {
    const element = $(id);
    if
PI');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo operacional do Raven Control Center.</p>
    <div class="panel monitor-panel">
      <div class="panel-head">
        <h3>Monitoramento da infraestrutura</h3>
        <span class="muted" id="monitorOverall">Verificando...</span>
      </div>
      <div class="monitor-grid">
        <div class="monitor-card">
          <div class="monitor-card-title">PostgreSQL principal</div>
          <div class="monitor-state" id="monitorPrimary">Verificando</div>
          <div class="monitor-detail" id="monitorPrimaryLatency">Aguardando verificacao</div>
        </div>
        <div class="monitor-card">
          <div class="monitor
dades vigentes</div></div>
      <div class="stat"><div class="stat-label">CONCESSÃ•ES AGENDADAS</div><div class="stat-value" id="statScheduled">â€”</div><div class="stat-note">AtivaÃ§Ãµes futuras</div></div>
    </div>
    <div class="panel">
      <div class="panel-head"><h3>Fila efetiva de prioridade</h3><button class="btn btn-small" id="refreshOverview">Atualizar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th
 id="statScheduled">â€”</div><div class="stat-note">AtivaÃ§Ãµes futuras</div></div>
    </div>
    <div class="panel">
      <div class="panel-head"><h3>Fila efetiva de prioridade</h3><button class="btn btn-small" id="refreshOverview">Atualizar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr
at-note">AtivaÃ§Ãµes futuras</div></div>
    </div>
    <div class="panel">
      <div class="panel-head"><h3>Fila efetiva de prioridade</h3><button class="btn btn-small" id="refreshOverview">Atualizar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr>`).join('')}</tbody></table></div>`
    :
alse;
    }
  });
}

function formatDate(value) {
  if(!value) return 'â€”';
  const date=new Date(value);
  return Number.isNaN(date.getTime()) ? 'â€”' : date.toLocaleString('pt-BR');
}

async function initialize() {
  if(!token) return showLogin();
  try {
    const me=await api('/auth/me');
    admin=me.admin;
    showApp();
    await navigate('overview');
  } catch {
    logout();
  }
}

initialize();
checkHealth();
setInterval(checkHealth,30000);
</script>
</body>
</html>


--- PADRÃO: api ---
 text-transform:uppercase;
}
.monitor-metric-value {
    font-size:15px;
    font-weight:800;
    margin-top:4px;
}
.monitor-updated {
    color:var(--muted);
    font-size:10px;
    margin-top:12px;
}
.status-dot {
    display:inline-block; width:8px; height:8px; border-radius:50%;
    background:var(--green); margin-right:7px;
}
@keyframes ravenApiPulseGreen {
    0%, 100% {
        opacity: 1;
        box-shadow: 0 0 0 0 rgba(34,197,94,.75);
        filter: brightness(1);
    }
    50% {
        opacity: .35;
        box-shadow: 0 0 0 7px rgba(34,197,94,0);
        filter: brightness(1.5);
    }
}

@keyframes ravenApiPulseRed {
    0%, 100% {
        opacity: 1;
        box-shadow: 0 0 0 0 rgba(239,68,68,.8);
        filter: brightness(1);
    }
    50% {
        opacity: .35;
        box-shadow: 0 0 0 7px rgba(239,68,68,0);
        filter: brightness(1.5);
    }
}

.status-dot:not(.bad) {
    background: #22c55e;
    animation: ravenApiPulseGreen 1.2s ease-in-out infinite;
}

.status-dot.bad {
    background: #ef4444;
    animation: ravenApiPulseRed 1.2s ease-in-out infinite;
}

ius:50%;
    background:var(--green); margin-right:7px;
}
@keyframes ravenApiPulseGreen {
    0%, 100% {
        opacity: 1;
        box-shadow: 0 0 0 0 rgba(34,197,94,.75);
        filter: brightness(1);
    }
    50% {
        opacity: .35;
        box-shadow: 0 0 0 7px rgba(34,197,94,0);
        filter: brightness(1.5);
    }
}

@keyframes ravenApiPulseRed {
    0%, 100% {
        opacity: 1;
        box-shadow: 0 0 0 0 rgba(239,68,68,.8);
        filter: brightness(1);
    }
    50% {
        opacity: .35;
        box-shadow: 0 0 0 7px rgba(239,68,68,0);
        filter: brightness(1.5);
    }
}

.status-dot:not(.bad) {
    background: #22c55e;
    animation: ravenApiPulseGreen 1.2s ease-in-out infinite;
}

.status-dot.bad {
    background: #ef4444;
    animation: ravenApiPulseRed 1.2s ease-in-out infinite;
}
.message {
    padding:12px 14px; border-radius:8px; margin:12px 0;
    background:#202936; color:#cbd5e1; font-size:13px;
}
.message.error { background:#3a2027; color:#ffabb3; }
.message.success { background:#17372e; color:#8ae0bd; }
.modal-backdrop {
    position:fixed; ins
   }
}

@keyframes ravenApiPulseRed {
    0%, 100% {
        opacity: 1;
        box-shadow: 0 0 0 0 rgba(239,68,68,.8);
        filter: brightness(1);
    }
    50% {
        opacity: .35;
        box-shadow: 0 0 0 7px rgba(239,68,68,0);
        filter: brightness(1.5);
    }
}

.status-dot:not(.bad) {
    background: #22c55e;
    animation: ravenApiPulseGreen 1.2s ease-in-out infinite;
}

.status-dot.bad {
    background: #ef4444;
    animation: ravenApiPulseRed 1.2s ease-in-out infinite;
}
.message {
    padding:12px 14px; border-radius:8px; margin:12px 0;
    background:#202936; color:#cbd5e1; font-size:13px;
}
.message.error { background:#3a2027; color:#ffabb3; }
.message.success { background:#17372e; color:#8ae0bd; }
.modal-backdrop {
    position:fixed; inset:0; background:#000a; z-index:5;
    display:grid; place-items:center; padding:20px;
}
.modal {
    width:min(500px,100%); max-height:90vh; overflow:auto;
    background:var(--panel); border:1px solid var(--line);
    border-radius:13px; padding:23px;
}
.modal h3 { margin:0 0 18px; }
.modal-actions { display:flex; justify-
39,68,68,.8);
        filter: brightness(1);
    }
    50% {
        opacity: .35;
        box-shadow: 0 0 0 7px rgba(239,68,68,0);
        filter: brightness(1.5);
    }
}

.status-dot:not(.bad) {
    background: #22c55e;
    animation: ravenApiPulseGreen 1.2s ease-in-out infinite;
}

.status-dot.bad {
    background: #ef4444;
    animation: ravenApiPulseRed 1.2s ease-in-out infinite;
}
.message {
    padding:12px 14px; border-radius:8px; margin:12px 0;
    background:#202936; color:#cbd5e1; font-size:13px;
}
.message.error { background:#3a2027; color:#ffabb3; }
.message.success { background:#17372e; color:#8ae0bd; }
.modal-backdrop {
    position:fixed; inset:0; background:#000a; z-index:5;
    display:grid; place-items:center; padding:20px;
}
.modal {
    width:min(500px,100%); max-height:90vh; overflow:auto;
    background:var(--panel); border:1px solid var(--line);
    border-radius:13px; padding:23px;
}
.modal h3 { margin:0 0 18px; }
.modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }
.footer-note { color:#647184; font-size:11px; margin-top:24px
inistrador</div>
      <div class="user-role" id="sideRole">Perfil</div>
      <button class="btn btn-small" id="logoutButton" style="margin-top:15px;width:100%">Sair da conta</button>
    </div>
  </aside>

  <main class="main">
    <header class="topbar">
      <strong id="topTitle">VisÃ£o geral</strong>
      <small><span class="status-dot" id="apiDot"></span><span id="apiLabel">Verificando API</span></small>
    </header>
    <section class="content">
      <div id="pageContent"></div>
      <div id="globalMessage"></div>
      <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => Stri
iv class="user-role" id="sideRole">Perfil</div>
      <button class="btn btn-small" id="logoutButton" style="margin-top:15px;width:100%">Sair da conta</button>
    </div>
  </aside>

  <main class="main">
    <header class="topbar">
      <strong id="topTitle">VisÃ£o geral</strong>
      <small><span class="status-dot" id="apiDot"></span><span id="apiLabel">Verificando API</span></small>
    </header>
    <section class="content">
      <div id="pageContent"></div>
      <div id="globalMessage"></div>
      <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/
d="sideRole">Perfil</div>
      <button class="btn btn-small" id="logoutButton" style="margin-top:15px;width:100%">Sair da conta</button>
    </div>
  </aside>

  <main class="main">
    <header class="topbar">
      <strong id="topTitle">VisÃ£o geral</strong>
      <small><span class="status-dot" id="apiDot"></span><span id="apiLabel">Verificando API</span></small>
    </header>
    <section class="content">
      <div id="pageContent"></div>
      <div id="globalMessage"></div>
      <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  '
e">VisÃ£o geral</strong>
      <small><span class="status-dot" id="apiDot"></span><span id="apiLabel">Verificando API</span></small>
    </header>
    <section class="content">
      <div id="pageContent"></div>
      <div id="globalMessage"></div>
      <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
})[c]);

function notify(message, type = '') {
  $('globalMessage').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(pat
Verificando API</span></small>
    </header>
    <section class="content">
      <div id="pageContent"></div>
      <div id="globalMessage"></div>
      <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
})[c]);

function notify(message, type = '') {
  $('globalMessage').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (token) headers.Authorizatio
>
    </header>
    <section class="content">
      <div id="pageContent"></div>
      <div id="globalMessage"></div>
      <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
    </section>
  </main>
</div>

<div id="modalRoot"></div>

<script>
'use strict';

const API = 'http://127.0.0.1:3100/api';
const TOKEN_KEY = 'raven_access_token';
const ADMIN_KEY = 'raven_admin';

let token = sessionStorage.getItem(TOKEN_KEY);
let admin = null;
let currentPage = 'overview';
let playersPage = 1;
let grantsPage = 1;
let auditPage = 1;
let playerSearchTimer = null;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
})[c]);

function notify(message, type = '') {
  $('globalMessage').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (token) headers.Authorization = `Bearer ${token}`;
  if (
l;

const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
})[c]);

function notify(message, type = '') {
  $('globalMessage').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (token) headers.Authorization = `Bearer ${token}`;
  if (options.body !== undefined) headers['Content-Type'] = 'application/json';

  const response = await fetch(API + path, {
    ...options,
    headers,
    body: options.body === undefined ? undefined : JSON.stringify(options.body)
  });

  let data = {};
  try { data = await response.json(); } catch {}

  if (response.status === 401) {
    logout();
    throw new Error('SessÃ£o expirada. Entre novamente.');
  }

  if (!response.ok) {
    const messages = {
      INVALID_CREDENTIALS:'UsuÃ¡rio ou senha invÃ¡lidos.',
      TOO_MANY_LOGIN_ATTEMPTS:'Muitas tentativas. Aguarde antes de tentar novamente.',
      P
').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (token) headers.Authorization = `Bearer ${token}`;
  if (options.body !== undefined) headers['Content-Type'] = 'application/json';

  const response = await fetch(API + path, {
    ...options,
    headers,
    body: options.body === undefined ? undefined : JSON.stringify(options.body)
  });

  let data = {};
  try { data = await response.json(); } catch {}

  if (response.status === 401) {
    logout();
    throw new Error('SessÃ£o expirada. Entre novamente.');
  }

  if (!response.ok) {
    const messages = {
      INVALID_CREDENTIALS:'UsuÃ¡rio ou senha invÃ¡lidos.',
      TOO_MANY_LOGIN_ATTEMPTS:'Muitas tentativas. Aguarde antes de tentar novamente.',
      PLAYER_ALREADY_EXISTS:'Este Steam64 jÃ¡ estÃ¡ cadastrado.',
      PLAYER_NOT_FOUND:'Jogador nÃ£o encontrado.',
      CATEGORY_NOT_FOUND:'Categoria nÃ£o encontrada.',
      PRIORITY_ALREADY_EXISTS:'JÃ¡ existe uma concessÃ£o equivalente.',
      G
nStorage.removeItem(TOKEN_KEY);
  sessionStorage.removeItem(ADMIN_KEY);
  showLogin();
}

$('loginForm').addEventListener('submit', async event => {
  event.preventDefault();
  const button = $('loginButton');
  const message = $('loginMessage');
  button.disabled = true;
  message.textContent = 'Autenticando...';

  try {
    const result = await api('/auth/login', {
      method:'POST',
      body:{
        username:$('username').value.trim(),
        password:$('password').value
      }
    });
    token = result.accessToken;
    sessionStorage.setItem(TOKEN_KEY, token);

    const me = await api('/auth/me');
    admin = me.admin;
    sessionStorage.setItem(ADMIN_KEY, JSON.stringify(admin));
    $('password').value = '';
    showApp();
    await navigate('overview');
  } catch (error) {
    message.textContent = error.message;
  } finally {
    button.disabled = false;
  }
});

$('logoutButton').addEventListener('click', logout);

document.querySelectorAll('.nav-btn').forEach(button => {
  button.addEventListener('click', () => navigate(button.dataset.page));
});

function titleFo
on.disabled = true;
  message.textContent = 'Autenticando...';

  try {
    const result = await api('/auth/login', {
      method:'POST',
      body:{
        username:$('username').value.trim(),
        password:$('password').value
      }
    });
    token = result.accessToken;
    sessionStorage.setItem(TOKEN_KEY, token);

    const me = await api('/auth/me');
    admin = me.admin;
    sessionStorage.setItem(ADMIN_KEY, JSON.stringify(admin));
    $('password').value = '';
    showApp();
    await navigate('overview');
  } catch (error) {
    message.textContent = error.message;
  } finally {
    button.disabled = false;
  }
});

$('logoutButton').addEventListener('click', logout);

document.querySelectorAll('.nav-btn').forEach(button => {
  button.addEventListener('click', () => navigate(button.dataset.page));
});

function titleFor(page) {
  return ({
    overview:'VisÃ£o geral',
    players:'Jogadores',
    priorities:'Prioridades',
    audit:'Auditoria',
    killfeed:'KillFeed',
    incidents:'Incidentes',
    logs:'Logs e Diagnosticos'
  })[page] || 'Raven Control Center';
onds) => {
    const total = Math.max(0, Number(seconds) || 0);
    const days = Math.floor(total / 86400);
    const hours = Math.floor((total % 86400) / 3600);
    const minutes = Math.floor((total % 3600) / 60);
    const secs = Math.floor(total % 60);

    return `${days}d ${hours}h ${minutes}m ${secs}s`;
  };

  try {
    const health = await api('/health');

    const primary = health.databases?.primary;
    const killfeed = health.databases?.killfeed;

    const primaryOK = primary?.status === 'connected';
    const killfeedOK = killfeed?.status === 'connected';
    const overallOK = health.status === 'ok';

    $('apiDot').classList.toggle('bad', !overallOK);
    $('apiLabel').textContent = overallOK
      ? 'API operacional'
      : 'API com degradacao';

    setMonitorState(
      'monitorPrimary',
      primaryOK,
      primaryOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorState(
      'monitorKillfeed',
      killfeedOK,
      killfeedOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorText(
      'monitorPrimaryLatency',
      primaryOK ? `Latencia: ${primar
hours}h ${minutes}m ${secs}s`;
  };

  try {
    const health = await api('/health');

    const primary = health.databases?.primary;
    const killfeed = health.databases?.killfeed;

    const primaryOK = primary?.status === 'connected';
    const killfeedOK = killfeed?.status === 'connected';
    const overallOK = health.status === 'ok';

    $('apiDot').classList.toggle('bad', !overallOK);
    $('apiLabel').textContent = overallOK
      ? 'API operacional'
      : 'API com degradacao';

    setMonitorState(
      'monitorPrimary',
      primaryOK,
      primaryOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorState(
      'monitorKillfeed',
      killfeedOK,
      killfeedOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorText(
      'monitorPrimaryLatency',
      primaryOK ? `Latencia: ${primary.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorKillfeedLatency',
      killfeedOK ? `Latencia: ${killfeed.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorOverall',
      overallOK ? 'Todos os servicos operacionais
t health = await api('/health');

    const primary = health.databases?.primary;
    const killfeed = health.databases?.killfeed;

    const primaryOK = primary?.status === 'connected';
    const killfeedOK = killfeed?.status === 'connected';
    const overallOK = health.status === 'ok';

    $('apiDot').classList.toggle('bad', !overallOK);
    $('apiLabel').textContent = overallOK
      ? 'API operacional'
      : 'API com degradacao';

    setMonitorState(
      'monitorPrimary',
      primaryOK,
      primaryOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorState(
      'monitorKillfeed',
      killfeedOK,
      killfeedOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorText(
      'monitorPrimaryLatency',
      primaryOK ? `Latencia: ${primary.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorKillfeedLatency',
      killfeedOK ? `Latencia: ${killfeed.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorOverall',
      overallOK ? 'Todos os servicos operacionais' : 'Estado degradado'
    );

    setMonitorText(

primary = health.databases?.primary;
    const killfeed = health.databases?.killfeed;

    const primaryOK = primary?.status === 'connected';
    const killfeedOK = killfeed?.status === 'connected';
    const overallOK = health.status === 'ok';

    $('apiDot').classList.toggle('bad', !overallOK);
    $('apiLabel').textContent = overallOK
      ? 'API operacional'
      : 'API com degradacao';

    setMonitorState(
      'monitorPrimary',
      primaryOK,
      primaryOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorState(
      'monitorKillfeed',
      killfeedOK,
      killfeedOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorText(
      'monitorPrimaryLatency',
      primaryOK ? `Latencia: ${primary.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorKillfeedLatency',
      killfeedOK ? `Latencia: ${killfeed.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorOverall',
      overallOK ? 'Todos os servicos operacionais' : 'Estado degradado'
    );

    setMonitorText(
      'monitorUptime',
      formatUptime(heal
?.primary;
    const killfeed = health.databases?.killfeed;

    const primaryOK = primary?.status === 'connected';
    const killfeedOK = killfeed?.status === 'connected';
    const overallOK = health.status === 'ok';

    $('apiDot').classList.toggle('bad', !overallOK);
    $('apiLabel').textContent = overallOK
      ? 'API operacional'
      : 'API com degradacao';

    setMonitorState(
      'monitorPrimary',
      primaryOK,
      primaryOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorState(
      'monitorKillfeed',
      killfeedOK,
      killfeedOK ? 'Conectado' : 'Desconectado'
    );

    setMonitorText(
      'monitorPrimaryLatency',
      primaryOK ? `Latencia: ${primary.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorKillfeedLatency',
      killfeedOK ? `Latencia: ${killfeed.latencyMs} ms` : 'Banco indisponivel'
    );

    setMonitorText(
      'monitorOverall',
      overallOK ? 'Todos os servicos operacionais' : 'Estado degradado'
    );

    setMonitorText(
      'monitorUptime',
      formatUptime(health.uptimeSeconds)
    );



      'monitorHeap',
      health.process?.memory?.heapUsedMb != null
        ? `${health.process.memory.heapUsedMb} / ${health.process.memory.heapTotalMb} MB`
        : 'Indisponivel'
    );

    setMonitorText(
      'monitorUpdated',
      `Ultima verificacao: ${new Date(health.timestamp).toLocaleTimeString('pt-BR')}`
    );
  } catch {
    $('apiDot').classList.add('bad');
    $('apiLabel').textContent = 'API indisponivel';

    setMonitorState('monitorPrimary', false, 'Indisponivel');
    setMonitorState('monitorKillfeed', false, 'Indisponivel');

    setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo opera
cess?.memory?.heapUsedMb != null
        ? `${health.process.memory.heapUsedMb} / ${health.process.memory.heapTotalMb} MB`
        : 'Indisponivel'
    );

    setMonitorText(
      'monitorUpdated',
      `Ultima verificacao: ${new Date(health.timestamp).toLocaleTimeString('pt-BR')}`
    );
  } catch {
    $('apiDot').classList.add('bad');
    $('apiLabel').textContent = 'API indisponivel';

    setMonitorState('monitorPrimary', false, 'Indisponivel');
    setMonitorState('monitorKillfeed', false, 'Indisponivel');

    setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo operacional do Raven Control Center.</p>

= null
        ? `${health.process.memory.heapUsedMb} / ${health.process.memory.heapTotalMb} MB`
        : 'Indisponivel'
    );

    setMonitorText(
      'monitorUpdated',
      `Ultima verificacao: ${new Date(health.timestamp).toLocaleTimeString('pt-BR')}`
    );
  } catch {
    $('apiDot').classList.add('bad');
    $('apiLabel').textContent = 'API indisponivel';

    setMonitorState('monitorPrimary', false, 'Indisponivel');
    setMonitorState('monitorKillfeed', false, 'Indisponivel');

    setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo operacional do Raven Control Center.</p>
    <div class="panel monito
Date(health.timestamp).toLocaleTimeString('pt-BR')}`
    );
  } catch {
    $('apiDot').classList.add('bad');
    $('apiLabel').textContent = 'API indisponivel';

    setMonitorState('monitorPrimary', false, 'Indisponivel');
    setMonitorState('monitorKillfeed', false, 'Indisponivel');

    setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo operacional do Raven Control Center.</p>
    <div class="panel monitor-panel">
      <div class="panel-head">
        <h3>Monitoramento da infraestrutura</h3>
        <span class="muted" id="monitorOverall">Verificando...</span>
      </div>
      <div class="monitor-grid">

 {
    $('apiDot').classList.add('bad');
    $('apiLabel').textContent = 'API indisponivel';

    setMonitorState('monitorPrimary', false, 'Indisponivel');
    setMonitorState('monitorKillfeed', false, 'Indisponivel');

    setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo operacional do Raven Control Center.</p>
    <div class="panel monitor-panel">
      <div class="panel-head">
        <h3>Monitoramento da infraestrutura</h3>
        <span class="muted" id="monitorOverall">Verificando...</span>
      </div>
      <div class="monitor-grid">
        <div class="monitor-card">
          <div class="monitor-card-
$('apiLabel').textContent = 'API indisponivel';

    setMonitorState('monitorPrimary', false, 'Indisponivel');
    setMonitorState('monitorKillfeed', false, 'Indisponivel');

    setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
    setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
    setMonitorText('monitorOverall', 'API indisponivel');
    setMonitorText('monitorUptime', 'â€”');
    setMonitorText('monitorRss', 'â€”');
    setMonitorText('monitorHeap', 'â€”');
    setMonitorText('monitorUpdated', 'Falha na verificacao');
  }
}

async function renderOverview() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">VisÃ£o geral</h1>
    <p class="page-desc">Resumo operacional do Raven Control Center.</p>
    <div class="panel monitor-panel">
      <div class="panel-head">
        <h3>Monitoramento da infraestrutura</h3>
        <span class="muted" id="monitorOverall">Verificando...</span>
      </div>
      <div class="monitor-grid">
        <div class="monitor-card">
          <div class="monitor-card-title">PostgreSQL principal</div>
          <
"monitor-card-title">PostgreSQL KillFeed</div>
          <div class="monitor-state" id="monitorKillfeed">Verificando</div>
          <div class="monitor-detail" id="monitorKillfeedLatency">Aguardando verificacao</div>
        </div>
      </div>
      <div class="monitor-metrics">
        <div>
          <div class="monitor-metric-label">Uptime da API</div>
          <div class="monitor-metric-value" id="monitorUptime">â€”</div>
        </div>
        <div>
          <div class="monitor-metric-label">Memoria RSS</div>
          <div class="monitor-metric-value" id="monitorRss">â€”</div>
        </div>
        <div>
          <div class="monitor-metric-label">Heap utilizado</div>
          <div class="monitor-metric-value" id="monitorHeap">â€”</div>
        </div>
      </div>
      <div class="monitor-updated" id="monitorUpdated">Aguardando primeira verificacao</div>
    </div>
    <div class="grid">
      <div class="stat"><div class="stat-label">JOGADORES CADASTRADOS</div><div class="stat-value" id="statPlayers">â€”</div><div class="stat-note">Registros na base</div></div>
      <d
v class="panel-head"><h3>Fila efetiva de prioridade</h3><button class="btn btn-small" id="refreshOverview">Atualizar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr>`).join('')}</tbody></table></div>`
    : '<div class="empty">Nenhum jogador na fila efetiva.</div>';
}

async function renderP
 efetiva de prioridade</h3><button class="btn btn-small" id="refreshOverview">Atualizar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr>`).join('')}</tbody></table></div>`
    : '<div class="empty">Nenhum jogador na fila efetiva.</div>';
}

async function renderPlayers() {
  $('pageContent')
on class="btn btn-small" id="refreshOverview">Atualizar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr>`).join('')}</tbody></table></div>`
    : '<div class="empty">Nenhum jogador na fila efetiva.</div>';
}

async function renderPlayers() {
  $('pageContent').innerHTML = `
    <h1 class="pa
izar</button></div>
      <div id="effectiveTable" class="muted">Carregando...</div>
    </div>`;
  $('refreshOverview').addEventListener('click', renderOverview);
  const [players, effective, active, scheduled] = await Promise.all([
    api('/players?limit=1'),
    api('/priority/effective'),
    api('/priority/grants?status=active&limit=1'),
    api('/priority/grants?status=scheduled&limit=1')
  ]);
  $('statPlayers').textContent = players.total;
  $('statQueue').textContent = effective.count;
  $('statActive').textContent = active.total;
  $('statScheduled').textContent = scheduled.total;
  $('effectiveTable').innerHTML = effective.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr>`).join('')}</tbody></table></div>`
    : '<div class="empty">Nenhum jogador na fila efetiva.</div>';
}

async function renderPlayers() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">Jogadores</h1>
    <p class="page-desc">C
-;loadPlayers();} });
  $('playersNext').addEventListener('click', () => { playersPage++;loadPlayers(); });
  await loadPlayers();
}

async function loadPlayers() {
  const search = $('playerSearch')?.value.trim() || '';
  const query = new URLSearchParams({page:playersPage,limit:25});
  if (search) query.set('search',search);
  const data = await api('/players?' + query);
  const pages = Math.max(1,Math.ceil(data.total/data.limit));
  if (playersPage > pages) playersPage = pages;
  $('playersInfo').textContent = `PÃ¡gina ${playersPage} de ${pages} Â· ${data.total} registros`;
  $('playersPrev').disabled = playersPage <= 1;
  $('playersNext').disabled = playersPage >= pages;
  $('playersTable').innerHTML = data.players.length
    ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th><th>Primeiro registro</th><th>Ãšltima atividade</th></tr></thead><tbody>${data.players.map(p=>`<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td><td>${formatDate(p.first_seen_at || p.created_at)}</td><td>${formatDate(p.last_seen_at)}</td></tr>`).join('')}</tbody></t
class="field"><label>NOME DO JOGADOR (OPCIONAL)</label><input id="modalName" maxlength="64"></div>`,
    async () => {
      const steam64 = $('modalSteam').value.trim();
      const displayName = $('modalName').value.trim() || null;
      if (!/^[0-9]{17}$/.test(steam64)) throw new Error('Steam64 deve conter exatamente 17 nÃºmeros.');
      await api('/players',{method:'POST',body:{steam64,displayName}});
      await renderPlayers();
      notify('Jogador cadastrado com sucesso.','success');
    });
}

async function renderPriorities() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">Prioridades</h1>
    <p class="page-desc">Gerencie concessÃµes, renovaÃ§Ãµes e revogaÃ§Ãµes.</p>
    <div class="panel">
      <div class="toolbar">
        <select id="grantStatus"><option value="">Todos os status</option><option value="active">Ativas</option><option value="scheduled">Agendadas</option><option value="expired">Expiradas</option><option value="revoked">Revogadas</option></select>
        <input id="grantSearch" placeholder="Filtrar por Steam64" maxlength="17">
        <butto
er('click',()=>{grantsPage++;loadGrants();});
  await loadGrants();
}

async function loadGrants() {
  const query = new URLSearchParams({page:grantsPage,limit:25});
  if ($('grantStatus').value) query.set('status',$('grantStatus').value);
  if ($('grantSearch').value.trim()) query.set('steam64',$('grantSearch').value.trim());
  const data = await api('/priority/grants?' + query);
  const pages = Math.max(1,Math.ceil(data.total/data.limit));
  if (grantsPage > pages) grantsPage = pages;
  $('grantsInfo').textContent = `PÃ¡gina ${grantsPage} de ${pages} Â· ${data.total} concessÃµes`;
  $('grantsPrev').disabled = grantsPage <= 1;
  $('grantsNext').disabled = grantsPage >= pages;
  $('grantsTable').innerHTML = data.grants.length
    ? `<div class="table-wrap"><table><thead><tr><th>Jogador</th><th>Categoria</th><th>Status</th><th>Validade</th><th>Origem</th><th>AÃ§Ãµes</th></tr></thead><tbody>${data.grants.map(g=>`<tr><td>${esc(g.display_name || g.steam64)}<br><span class="muted">${esc(g.steam64)}</span></td><td>${esc(g.category_name)}</td><td><span class="pill ${esc(g.status)}">${esc(g.
s="empty">Nenhuma concessÃ£o encontrada.</div>';
  document.querySelectorAll('[data-renew]').forEach(b=>b.addEventListener('click',()=>openRenewModal(b.dataset.renew)));
  document.querySelectorAll('[data-revoke]').forEach(b=>b.addEventListener('click',()=>revokeGrant(b.dataset.revoke)));
}

async function openGrantModal() {
  const result = await api('/priority/categories');
  const options = result.categories.map(c=>`<option value="${esc(c.code)}">${esc(c.name)}</option>`).join('');
  openModal('Conceder prioridade',`
    <div class="field"><label>STEAM64 DO JOGADOR</label><input id="grantSteam" maxlength="17" placeholder="7656119..."></div>
    <div class="field"><label>CATEGORIA</label><select id="grantCategory">${options}</select></div>
    <div class="field"><label>INÃCIO (OPCIONAL)</label><input id="grantStart" type="datetime-local"></div>
    <div class="field"><label>VALIDADE (VAZIO = PERMANENTE)</label><input id="grantExpiry" type="datetime-local"></div>
    <div class="field"><label>MOTIVO (OPCIONAL)</label><textarea id="grantReason" maxlength="500"></textarea></div>`,

=>{
      const steam64=$('grantSteam').value.trim();
      if(!/^[0-9]{17}$/.test(steam64)) throw new Error('Steam64 invÃ¡lido.');
      const startsAt=$('grantStart').value ? new Date($('grantStart').value).toISOString() : undefined;
      const expiresAt=$('grantExpiry').value ? new Date($('grantExpiry').value).toISOString() : null;
      await api('/priority/grants',{method:'POST',body:{
        steam64,categoryCode:$('grantCategory').value,startsAt,expiresAt,
        reason:$('grantReason').value.trim() || null
      }});
      await renderPriorities();
      notify('Prioridade concedida com sucesso.','success');
    });
}

function openRenewModal(id) {
  openModal('Renovar prioridade',`
    <div class="field"><label>NOVA DATA E HORA DE EXPIRAÃ‡ÃƒO</label><input id="renewExpiry" type="datetime-local" required></div>
    <div class="field"><label>MOTIVO (OPCIONAL)</label><textarea id="renewReason" maxlength="500"></textarea></div>`,
    async()=>{
      const value=$('renewExpiry').value;
      if(!value) throw new Error('Informe a nova validade.');
      await api(`/priority/gra
NOVA DATA E HORA DE EXPIRAÃ‡ÃƒO</label><input id="renewExpiry" type="datetime-local" required></div>
    <div class="field"><label>MOTIVO (OPCIONAL)</label><textarea id="renewReason" maxlength="500"></textarea></div>`,
    async()=>{
      const value=$('renewExpiry').value;
      if(!value) throw new Error('Informe a nova validade.');
      await api(`/priority/grants/${encodeURIComponent(id)}/renew`,{method:'POST',body:{
        expiresAt:new Date(value).toISOString(),
        reason:$('renewReason').value.trim() || null
      }});
      await renderPriorities();
      notify('Prioridade renovada com sucesso.','success');
    });
}

async function revokeGrant(id) {
  if(!confirm('Confirma a revogaÃ§Ã£o desta prioridade?')) return;
  const reason=prompt('Motivo da revogaÃ§Ã£o (opcional):');
  if(reason === null) return;
  try {
    await api(`/priority/grants/${encodeURIComponent(id)}/revoke`,{
      method:'PATCH',body:{reason:reason.trim() || null}
    });
    await renderPriorities();
    notify('Prioridade revogada.','success');
  } catch(error) { notify(error.message,'error');
ason').value.trim() || null
      }});
      await renderPriorities();
      notify('Prioridade renovada com sucesso.','success');
    });
}

async function revokeGrant(id) {
  if(!confirm('Confirma a revogaÃ§Ã£o desta prioridade?')) return;
  const reason=prompt('Motivo da revogaÃ§Ã£o (opcional):');
  if(reason === null) return;
  try {
    await api(`/priority/grants/${encodeURIComponent(id)}/revoke`,{
      method:'PATCH',body:{reason:reason.trim() || null}
    });
    await renderPriorities();
    notify('Prioridade revogada.','success');
  } catch(error) { notify(error.message,'error'); }
}

async function renderAudit() {
  $('pageContent').innerHTML=`
    <h1 class="page-title">Auditoria</h1>
    <p class="page-desc">HistÃ³rico de operaÃ§Ãµes administrativas registradas pela API.</p>
    <div class="panel">
      <div class="toolbar">
        <input id="auditAction" placeholder="AÃ§Ã£o (ex.: priority.granted)" maxlength="100">
        <input id="auditEntity" placeholder="Tipo de entidade" maxlength="60">
        <button class="btn" id="auditFilter">Filtrar</button>
      </div>
reason.trim() || null}
    });
    await renderPriorities();
    notify('Prioridade revogada.','success');
  } catch(error) { notify(error.message,'error'); }
}

async function renderAudit() {
  $('pageContent').innerHTML=`
    <h1 class="page-title">Auditoria</h1>
    <p class="page-desc">HistÃ³rico de operaÃ§Ãµes administrativas registradas pela API.</p>
    <div class="panel">
      <div class="toolbar">
        <input id="auditAction" placeholder="AÃ§Ã£o (ex.: priority.granted)" maxlength="100">
        <input id="auditEntity" placeholder="Tipo de entidade" maxlength="60">
        <button class="btn" id="auditFilter">Filtrar</button>
      </div>
      <div id="auditTable">Carregando...</div>
      <div class="toolbar" style="justify-content:space-between;margin-top:15px">
        <button class="btn btn-small" id="auditPrev">Anterior</button>
        <span class="muted" id="auditInfo"></span>
        <button class="btn btn-small" id="auditNext">PrÃ³xima</button>
      </div>
    </div>`;
  $('auditFilter').addEventListener('click',()=>{auditPage=1;loadAudit();});
  $('auditPrev')
ick',()=>{auditPage++;loadAudit();});
  await loadAudit();
}

async function loadAudit() {
  const query=new URLSearchParams({page:auditPage,limit:50});
  if($('auditAction').value.trim()) query.set('action',$('auditAction').value.trim());
  if($('auditEntity').value.trim()) query.set('entityType',$('auditEntity').value.trim());
  const data=await api('/audit?'+query);
  const pages=Math.max(1,Math.ceil(data.total/data.limit));
  if(auditPage>pages) auditPage=pages;
  $('auditInfo').textContent=`PÃ¡gina ${auditPage} de ${pages} Â· ${data.total} registros`;
  $('auditPrev').disabled=auditPage<=1;
  $('auditNext').disabled=auditPage>=pages;
  $('auditTable').innerHTML=data.entries.length
    ? `<div class="table-wrap"><table><thead><tr><th>Data</th><th>ResponsÃ¡vel</th><th>AÃ§Ã£o</th><th>Entidade</th><th>ID</th></tr></thead><tbody>${data.entries.map(e=>`<tr><td>${formatDate(e.created_at)}</td><td>${esc(e.actor_identifier)}</td><td>${esc(e.action)}</td><td>${esc(e.entity_type)}</td><td>${esc(e.entity_id)}</td></tr>`).join('')}</tbody></table></div>`
    : '<div class="empty">Nenhum regi
Page > 1) {
      incidentsPage--;
      loadIncidents();
    }
  });
  $('incidentsNext').addEventListener('click', () => {
    incidentsPage++;
    loadIncidents();
  });

  await loadIncidents();
}

async function loadIncidents() {
  const query = new URLSearchParams({
    page: incidentsPage,
    limit: 50
  });

  try {
    const data = await api('/incidents?' + query);
    const pages = Math.max(1, Math.ceil(data.total / data.limit));

    if (incidentsPage > pages) {
      incidentsPage = pages;
      return loadIncidents();
    }

    $('incidentsInfo').textContent =
      `Pagina ${incidentsPage} de ${pages} - ${data.total} incidentes`;

    $('incidentsPrev').disabled = incidentsPage <= 1;
    $('incidentsNext').disabled = incidentsPage >= pages;

    $('incidentsTable').innerHTML = data.incidents.length
      ? `<div class="table-wrap"><table>
          <thead>
            <tr>
              <th>Inicio</th>
              <th>Componente</th>
              <th>Severidade</th>
              <th>Descricao</th>
              <th>Duracao</th>
              <th>Resolucao</th>

nerHTML =
      `<div class="message error">${esc(error.message)}</div>`;
    $('incidentsInfo').textContent = 'Falha ao consultar incidentes';
  }
}


let logsPage = 1;

async function renderLogs() {
  $('pageContent').innerHTML = `
    <h1 class="page-title">Logs e Diagnosticos</h1>
    <p class="page-desc">Consulta operacional dos registros da API Raven.</p>

    <div class="panel">
      <div class="toolbar">
        <select id="logsLevel">
          <option value="">Todos os niveis</option>
          <option value="trace">Trace</option>
          <option value="debug">Debug</option>
          <option value="info">Info</option>
          <option value="warn">Warning</option>
          <option value="error">Error</option>
          <option value="fatal">Fatal</option>
        </select>

        <input id="logsComponent" placeholder="Componente" maxlength="80">
        <input id="logsSearch" placeholder="Pesquisar nos registros" maxlength="200">
        <button class="btn" id="logsFilter">Filtrar</button>
        <button class="btn" id="logsRefresh">Atualizar</button>
      </div>
onst from = $('logsFrom').value;
  const to = $('logsTo').value;

  if (level) query.set('level', level);
  if (component) query.set('component', component);
  if (search) query.set('search', search);

  if (from) query.set('from', new Date(from).toISOString());
  if (to) query.set('to', new Date(to).toISOString());

  try {
    const data = await api('/logs?' + query);
    const pages = Math.max(1, Math.ceil(data.total / data.limit));

    if (logsPage > pages) {
      logsPage = pages;
      return loadLogs();
    }

    $('logsInfo').textContent =
      `Pagina ${logsPage} de ${pages} Â· ${data.total} registros Â· ${data.filesScanned} arquivos`;

    $('logsPrev').disabled = logsPage <= 1;
    $('logsNext').disabled = logsPage >= pages;

    $('logsTable').innerHTML = data.logs.length
      ? `<div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Data</th>
                <th>Nivel</th>
                <th>Componente</th>
                <th>Mensagem</th>
              </tr>
            </thead>
            <tbody>
              ${da
lfeedNext').addEventListener('click', () => {
    killfeedPage++;
    loadKillfeed();
  });

  await loadKillfeed();
}

async function loadKillfeed() {
  const query = new URLSearchParams({ page: killfeedPage, limit: 50 });
  const search = $('killfeedSearch').value.trim();
  if (search) query.set('search', search);

  try {
    const data = await api('/killfeed?' + query);
    const pages = Math.max(1, Math.ceil(data.total / data.limit));

    if (killfeedPage > pages) killfeedPage = pages;

    $('killfeedInfo').textContent =
      `PÃ¡gina ${killfeedPage} de ${pages} Â· ${data.total} eliminaÃ§Ãµes`;

    $('killfeedPrev').disabled = killfeedPage <= 1;
    $('killfeedNext').disabled = killfeedPage >= pages;

    $('killfeedTable').innerHTML = data.kills.length
      ? `<div class="table-wrap"><table>
          <thead><tr><th>Data</th><th>Atacante</th><th>VÃ­tima</th><th>Arma</th><th>DistÃ¢ncia</th></tr></thead>
          <tbody>${data.kills.map(k => {
            const distance = k.distance_m == null ||
              !Number.isFinite(Number(k.distance_m))
              ? 'â€”' : `$
      $('modalError').textContent=error.message;
      button.disabled=false;
    }
  });
}

function formatDate(value) {
  if(!value) return 'â€”';
  const date=new Date(value);
  return Number.isNaN(date.getTime()) ? 'â€”' : date.toLocaleString('pt-BR');
}

async function initialize() {
  if(!token) return showLogin();
  try {
    const me=await api('/auth/me');
    admin=me.admin;
    showApp();
    await navigate('overview');
  } catch {
    logout();
  }
}

initialize();
checkHealth();
setInterval(checkHealth,30000);
</script>
</body>
</html>


--- PADRÃO: setInterval ---
';
  const date=new Date(value);
  return Number.isNaN(date.getTime()) ? 'â€”' : date.toLocaleString('pt-BR');
}

async function initialize() {
  if(!token) return showLogin();
  try {
    const me=await api('/auth/me');
    admin=me.admin;
    showApp();
    await navigate('overview');
  } catch {
    logout();
  }
}

initialize();
checkHealth();
setInterval(checkHealth,30000);
</script>
</body>
</html>


--- PADRÃO: function navigate ---
n.addEventListener('click', () => navigate(button.dataset.page));
});

function titleFor(page) {
  return ({
    overview:'VisÃ£o geral',
    players:'Jogadores',
    priorities:'Prioridades',
    audit:'Auditoria',
    killfeed:'KillFeed',
    incidents:'Incidentes',
    logs:'Logs e Diagnosticos'
  })[page] || 'Raven Control Center';
}

async function navigate(page) {
  if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
    return notify('Seu perfil nÃ£o possui acesso Ã  auditoria.', 'error');
  }
  if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {
    return notify('Acesso restrito.', 'error');
  }
  currentPage = page;
  document.querySelectorAll('.nav-btn').forEach(button => {
    button.classList.toggle('active', button.dataset.page === page);
  });
  $('topTitle').textContent = titleFor(page);
  notify('');
  try {
    if (page === 'overview') await renderOverview();
    if (page === 'players') await renderPlayers();
    if (page === 'priorities') await renderPriorities();
    if (page === 'audit') await renderAudit();


--- PADRÃO: function esc ---

--- PADRÃO: fetch\( ---
essage').innerHTML = message
    ? `<div class="message ${type}">${esc(message)}</div>` : '';
}

async function api(path, options = {}) {
  const headers = { ...(options.headers || {}) };
  if (token) headers.Authorization = `Bearer ${token}`;
  if (options.body !== undefined) headers['Content-Type'] = 'application/json';

  const response = await fetch(API + path, {
    ...options,
    headers,
    body: options.body === undefined ? undefined : JSON.stringify(options.body)
  });

  let data = {};
  try { data = await response.json(); } catch {}

  if (response.status === 401) {
    logout();
    throw new Error('SessÃ£o expirada. Entre novamente.');
  }

  if (!response.ok) {
    const messages = {
      INVALID_CREDENTIALS:'UsuÃ¡rio ou senha invÃ¡lidos.',
      TOO_MANY_LOGIN_ATTEMPTS:'Muitas tentativas. Aguarde antes de tentar novamente.',
      PLAYER_ALREADY_EXISTS:'Este Steam64 jÃ¡ estÃ¡ cadastrado.',
      PLAYER_NOT_FOUND:'Jogador nÃ£o encontrado.',
      CATEGORY_NOT_FOUND:'Categoria nÃ£o encontrada.',
      PRIORITY_ALREADY_EXISTS:'JÃ¡ existe uma concessÃ£o equivalente.',


--- PADRÃO: </style> ---
ht:0; padding:14px; }
    .sidebar .brand { padding:5px 8px 12px; }
    .nav-label,.sidebar-bottom { display:none; }
    .nav-btn { display:inline-flex; width:auto; padding:9px; }
    .topbar { height:58px; padding:0 16px; }
    .content { padding:22px 15px; }
    .grid { gap:9px; }
    .stat { padding:14px; }
    .stat-value { font-size:23px; }
}
</style>
</head>
<body>

<section id="loginScreen" class="login-screen">
  <form id="loginForm" class="login-card">
    <div class="brand">RAVEN<span>.</span></div>
    <p class="subtitle">Control Center Â· AdministraÃ§Ã£o</p>
    <div class="field">
      <label for="username">USUÃRIO</label>
      <input id="username" name="username" autocomplete="username" required minlength="3" maxlength="64">
    </div>
    <div class="field">
      <label for="password">SENHA</label>
      <input id="password" name="password" type="password" autocomplete="current-password" required minlength="14" maxlength="72">
    </div>
    <button class="btn btn-primary" type="submit" id="loginButton">Entrar no sistema</button>
    <div id="loginMessage" class="e

--- PADRÃO: </body> ---
Number.isNaN(date.getTime()) ? 'â€”' : date.toLocaleString('pt-BR');
}

async function initialize() {
  if(!token) return showLogin();
  try {
    const me=await api('/auth/me');
    admin=me.admin;
    showApp();
    await navigate('overview');
  } catch {
    logout();
  }
}

initialize();
checkHealth();
setInterval(checkHealth,30000);
</script>
</body>
</html>

PS C:\RavenRP\ControlCenter\API>
