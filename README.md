
===========================================================================
1. IDENTIFICACAO DO AMBIENTE
===========================================================================
Data: 19/11/2026 17:42:48
Computador: DESKTOP-LDECQT3
Usuario: Nasdara
PowerShell: 5.1.19041.6456
Raiz Raven: C:\RavenRP\ControlCenter
ENCONTRADO: C:\RavenRP\ControlCenter\API
ENCONTRADO: C:\RavenRP\ControlCenter\Dashboard

===========================================================================
2. ARQUIVOS PRINCIPAIS
===========================================================================
ENCONTRADO: C:\RavenRP\ControlCenter\API\src\logger.js
Tamanho: 3809 bytes | Modificado: 11/19/2026 08:44:42
ENCONTRADO: C:\RavenRP\ControlCenter\API\src\routes\logs.js
Tamanho: 8184 bytes | Modificado: 11/19/2026 08:53:46
ENCONTRADO: C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js
Tamanho: 2250 bytes | Modificado: 11/17/2026 21:27:16
ENCONTRADO: C:\RavenRP\ControlCenter\API\src\server.js
Tamanho: 4735 bytes | Modificado: 11/19/2026 08:53:46
ENCONTRADO: C:\RavenRP\ControlCenter\API\package.json
Tamanho: 810 bytes | Modificado: 11/17/2026 21:10:18
ENCONTRADO: C:\RavenRP\ControlCenter\Dashboard\server.js
Tamanho: 1613 bytes | Modificado: 11/18/2026 20:40:39
ENCONTRADO: C:\RavenRP\ControlCenter\Dashboard\public\index.html
Tamanho: 45787 bytes | Modificado: 11/19/2026 09:09:13
ENCONTRADO: C:\RavenRP\ControlCenter\Dashboard\package.json
Tamanho: 200 bytes | Modificado: 11/18/2026 20:40:39

===========================================================================
3. CONTEUDO DOS ARQUIVOS CENTRAIS
===========================================================================

----- ARQUIVO: C:\RavenRP\ControlCenter\API\src\logger.js -----
'use strict';

const fs = require('fs');
const path = require('path');
const { Writable } = require('stream');
const pino = require('pino');

const logDir = path.resolve(__dirname, '..', 'logs');
const MAX_FILE_SIZE = 10 * 1024 * 1024;
const RETENTION_DAYS = 14;

fs.mkdirSync(logDir, { recursive: true });

function getDateKey() {
    const now = new Date();

    return [
        now.getFullYear(),
        String(now.getMonth() + 1).padStart(2, '0'),
        String(now.getDate()).padStart(2, '0')
    ].join('-');
}

function cleanupOldLogs() {
    const cutoff = Date.now() - RETENTION_DAYS * 86400000;
    const pattern = /^api-\d{4}-\d{2}-\d{2}-\d{3}\.log$/;

    for (const name of fs.readdirSync(logDir)) {
        if (!pattern.test(name)) continue;

        const file = path.join(logDir, name);

        try {
            const stat = fs.statSync(file);

            if (stat.isFile() && stat.mtimeMs < cutoff) {
                fs.unlinkSync(file);
            }
        } catch (error) {
            process.stderr.write(
                `[RAVEN LOGGER] Falha na limpeza de ${name}: ${error.message}\n`
            );
        }
    }
}

class RotatingLogStream extends Writable {
    constructor() {
        super();

        this.fd = null;
        this.currentDate = null;
        this.currentSize = 0;
        this.sequence = 0;

        cleanupOldLogs();
        this.openNextFile();
    }

    openNextFile() {
        if (this.fd !== null) {
            fs.closeSync(this.fd);
            this.fd = null;
        }

        this.currentDate = getDateKey();

        const pattern = new RegExp(
            `^api-${this.currentDate}-(\\d{3})\\.log$`
        );

        let highest = 0;

        for (const name of fs.readdirSync(logDir)) {
            const match = name.match(pattern);

            if (match) {
                highest = Math.max(highest, Number(match[1]));
            }
        }

        this.sequence = highest + 1;

        const filename =
            `api-${this.currentDate}-${String(this.sequence).padStart(3, '0')}.log`;

        const fullPath = path.join(logDir, filename);

        this.fd = fs.openSync(fullPath, 'a');
        this.currentSize = fs.fstatSync(this.fd).size;
    }

    _write(chunk, encoding, callback) {
        try {
            const buffer = Buffer.isBuffer(chunk)
                ? chunk
                : Buffer.from(chunk, encoding);

            if (
                getDateKey() !== this.currentDate ||
                this.currentSize + buffer.length > MAX_FILE_SIZE
            ) {
                this.openNextFile();
            }

            fs.writeSync(this.fd, buffer);
            this.currentSize += buffer.length;

            callback();
        } catch (error) {
            callback(error);
        }
    }

    _final(callback) {
        try {
            if (this.fd !== null) {
                fs.closeSync(this.fd);
                this.fd = null;
            }

            callback();
        } catch (error) {
            callback(error);
        }
    }
}

const fileStream = new RotatingLogStream();

const streams = pino.multistream([
    { stream: process.stdout },
    { stream: fileStream }
]);

const logger = pino({
    level: process.env.LOG_LEVEL || 'info',

    redact: {
        paths: [
            'req.headers.authorization',
            'headers.authorization',
            'req.headers.cookie',
            'headers.cookie',
            'password',
            '*.password',
            'token',
            '*.token',
            'accessToken',
            '*.accessToken',
            'refreshToken',
            '*.refreshToken',
            'DB_PASSWORD_B64'
        ],
        censor: '[REDACTED]'
    },

    timestamp: pino.stdTimeFunctions.isoTime
}, streams);

module.exports = logger;
----- FIM DO ARQUIVO -----

----- ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\logs.js -----
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
----- FIM DO ARQUIVO -----

----- ARQUIVO: C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js -----
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
----- FIM DO ARQUIVO -----

----- ARQUIVO: C:\RavenRP\ControlCenter\API\src\server.js -----
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

----- FIM DO ARQUIVO -----

----- ARQUIVO: C:\RavenRP\ControlCenter\API\package.json -----
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

----- FIM DO ARQUIVO -----

----- ARQUIVO: C:\RavenRP\ControlCenter\Dashboard\server.js -----
'use strict';

const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');

const HOST = '127.0.0.1';
const PORT = 5173;
const PUBLIC = path.join(__dirname, 'public');

const MIME = {
    '.html': 'text/html; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.svg': 'image/svg+xml'
};

const server = http.createServer((req, res) => {
    const pathname = decodeURIComponent(
        new URL(req.url, `http://${HOST}:${PORT}`).pathname
    );

    let requested = pathname === '/'
        ? 'index.html'
        : pathname.replace(/^\/+/, '');

    const file = path.resolve(PUBLIC, requested);

    if (!file.startsWith(PUBLIC + path.sep)) {
        res.writeHead(403);
        return res.end('Forbidden');
    }

    fs.readFile(file, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                res.writeHead(404);
                return res.end('Not found');
            }

            res.writeHead(500);
            return res.end('Internal server error');
        }

        res.writeHead(200, {
            'Content-Type': MIME[path.extname(file)] || 'application/octet-stream',
            'X-Content-Type-Options': 'nosniff',
            'Cache-Control': 'no-store'
        });

        res.end(content);
    });
});

server.listen(PORT, HOST, () => {
    console.log(`Raven Dashboard disponivel em http://${HOST}:${PORT}`);
});

server.on('error', error => {
    console.error('Falha ao iniciar Dashboard:', error.message);
    process.exitCode = 1;
});

----- FIM DO ARQUIVO -----

----- ARQUIVO: C:\RavenRP\ControlCenter\Dashboard\package.json -----
{
  "name": "raven-control-center-dashboard",
  "version": "1.0.0",
  "private": true,
  "description": "Interface web do Raven Control Center",
  "scripts": {
    "start": "node server.js"
  }
}

----- FIM DO ARQUIVO -----

===========================================================================
4. ANALISE DA PAGINA DE LOGS DO DASHBOARD
===========================================================================

PADRAO: logs
Linha 340: <button class="nav-btn" data-page="logs" id="logsNav">Logs e Diagnosticos</button>
Linha 438: logsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 494: logs:'Logs e Diagnosticos'
Linha 502: if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {
Linha 517: if (page === 'logs') await renderLogs();
Linha 986: let logsPage = 1;
Linha 988: async function renderLogs() {
Linha 990: <h1 class="page-title">Logs e Diagnosticos</h1>
Linha 995: <select id="logsLevel">
Linha 1005: <input id="logsComponent" placeholder="Componente" maxlength="80">
Linha 1006: <input id="logsSearch" placeholder="Pesquisar nos registros" maxlength="200">
Linha 1007: <button class="btn" id="logsFilter">Filtrar</button>
Linha 1008: <button class="btn" id="logsRefresh">Atualizar</button>
Linha 1012: <label>De <input type="datetime-local" id="logsFrom"></label>
Linha 1013: <label>Até <input type="datetime-local" id="logsTo"></label>
Linha 1016: <div id="logsTable">Carregando registros...</div>
Linha 1019: <button class="btn btn-small" id="logsPrev">Anterior</button>
Linha 1020: <span class="muted" id="logsInfo"></span>
Linha 1021: <button class="btn btn-small" id="logsNext">Proxima</button>
Linha 1025: $('logsFilter').addEventListener('click', () => {
Linha 1026: logsPage = 1;
Linha 1027: loadLogs();
Linha 1030: $('logsRefresh').addEventListener('click', () => loadLogs());
Linha 1032: $('logsSearch').addEventListener('keydown', event => {
Linha 1034: logsPage = 1;
Linha 1035: loadLogs();
Linha 1039: $('logsPrev').addEventListener('click', () => {
Linha 1040: if (logsPage > 1) {
Linha 1041: logsPage--;
Linha 1042: loadLogs();

PADRAO: diagnostic
Linha 340: <button class="nav-btn" data-page="logs" id="logsNav">Logs e Diagnosticos</button>
Linha 494: logs:'Logs e Diagnosticos'
Linha 990: <h1 class="page-title">Logs e Diagnosticos</h1>

PADRAO: diagnost
Linha 340: <button class="nav-btn" data-page="logs" id="logsNav">Logs e Diagnosticos</button>
Linha 494: logs:'Logs e Diagnosticos'
Linha 990: <h1 class="page-title">Logs e Diagnosticos</h1>

PADRAO: fetch\(
Linha 393: const response = await fetch(API + path, {

PADRAO: Authorization
Linha 390: if (token) headers.Authorization = `Bearer ${token}`;

PADRAO: Bearer
Linha 390: if (token) headers.Authorization = `Bearer ${token}`;

PADRAO: pagination
Nenhuma ocorrencia encontrada.

PADRAO: pageSize
Nenhuma ocorrencia encontrada.

PADRAO: filter
Linha 244: filter: brightness(1);
Linha 249: filter: brightness(1.5);
Linha 257: filter: brightness(1);
Linha 262: filter: brightness(1.5);
Linha 850: <button class="btn" id="auditFilter">Filtrar</button>
Linha 859: $('auditFilter').addEventListener('click',()=>{auditPage=1;loadAudit();});
Linha 1007: <button class="btn" id="logsFilter">Filtrar</button>
Linha 1025: $('logsFilter').addEventListener('click', () => {
Linha 1132: <button class="btn" id="killfeedFilter">Pesquisar</button>
Linha 1142: $('killfeedFilter').addEventListener('click', () => {

PADRAO: owner
Linha 436: $('auditNav').classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 437: incidentsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 438: logsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 499: if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
Linha 502: if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {

PADRAO: admin
Linha 316: <p class="subtitle">Control Center · Administração</p>
Linha 342: <div class="user-name" id="sideUsername">Administrador</div>
Linha 356: <div class="footer-note">RAVEN CONTROL CENTER · Ações administrativas são registradas pela API.</div>
Linha 368: const ADMIN_KEY = 'raven_admin';
Linha 371: let admin = null;
Linha 434: $('sideUsername').textContent = admin.username;
Linha 435: $('sideRole').textContent = admin.role.toUpperCase();
Linha 436: $('auditNav').classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 437: incidentsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 438: logsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
Linha 443: admin = null;
Linha 445: sessionStorage.removeItem(ADMIN_KEY);
Linha 468: admin = me.admin;
Linha 469: sessionStorage.setItem(ADMIN_KEY, JSON.stringify(admin));
Linha 499: if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
Linha 502: if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {
Linha 845: <p class="page-desc">Histórico de operações administrativas registradas pela API.</p>
Linha 1248: admin=me.admin;

PADRAO: esc\(
Linha 385: ? `<div class="message ${type}">${esc(message)}</div>` : '';
Linha 520: $('pageContent').innerHTML = `<div class="panel message error">${esc(error.message)}</div>`;
Linha 689: ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || '—')}</td></tr>`).join('')}</tbody></table></div>`
Linha 730: ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th><th>Primeiro registro</th><th>Última atividade</th></tr></thead><tbody>${data.players.map(p=>`<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || '—')}</td><td>${formatDate(p.first_seen_at || p.created_at)}</td><td>${formatDate(p.last_seen_at)}</td></tr>`).join('')}</tbody></table></div>`
Linha 784: ? `<div class="table-wrap"><table><thead><tr><th>Jogador</th><th>Categoria</th><th>Status</th><th>Validade</th><th>Origem</th><th>Ações</th></tr></thead><tbody>${data.grants.map(g=>`<tr><td>${esc(g.display_name || g.steam64)}<br><span class="muted">${esc(g.steam64)}</span></td><td>${esc(g.category_name)}</td><td><span class="pill ${esc(g.status)}">${esc(g.status)}</span></td><td>${g.expires_at ? formatDate(g.expires_at) : 'Permanente'}</td><td>${esc(g.grant_source)}</td><td>${['active','scheduled'].includes(g.status)?`<div class="actions"><button class="btn btn-small" data-renew="${esc(g.id)}">Renovar</button><button class="btn btn-small btn-danger" data-revoke="${esc(g.id)}">Revogar</button></div>`:'—'}</td></tr>`).join('')}</tbody></table></div>`
Linha 792: const options = result.categories.map(c=>`<option value="${esc(c.code)}">${esc(c.name)}</option>`).join('');
Linha 876: ? `<div class="table-wrap"><table><thead><tr><th>Data</th><th>Responsável</th><th>Ação</th><th>Entidade</th><th>ID</th></tr></thead><tbody>${data.entries.map(e=>`<tr><td>${formatDate(e.created_at)}</td><td>${esc(e.actor_identifier)}</td><td>${esc(e.action)}</td><td>${esc(e.entity_type)}</td><td>${esc(e.entity_id)}</td></tr>`).join('')}</tbody></table></div>`
Linha 966: <td>${esc(incident.component)}</td>
Linha 967: <td>${esc(incident.severity)}</td>
Linha 968: <td>${esc(incident.details?.description || '-')}</td>
Linha 980: `<div class="message error">${esc(error.message)}</div>`;
Linha 1105: <td>${log.time ? esc(formatDate(log.time)) : '-'}</td>
Linha 1106: <td><strong>${esc(level.toUpperCase())}</strong></td>
Linha 1107: <td>${esc(log.component)}</td>
Linha 1108: <td title="${esc(message)}">${esc(message)}</td>
Linha 1118: `<div class="message error">${esc(error.message)}</div>`;
Linha 1196: <td>${esc(k.killer_name)}</td>
Linha 1197: <td>${esc(k.victim_name)}</td>
Linha 1198: <td>${esc(k.weapon || '—')}</td>
Linha 1206: `<div class="message error">${esc(error.message)}</div>`;
Linha 1213: <h3>${esc(title)}</h3>

PADRAO: innerHTML
Linha 384: $('globalMessage').innerHTML = message
Linha 520: $('pageContent').innerHTML = `<div class="panel message error">${esc(error.message)}</div>`;
Linha 631: $('pageContent').innerHTML = `
Linha 688: $('effectiveTable').innerHTML = effective.players.length
Linha 694: $('pageContent').innerHTML = `
Linha 729: $('playersTable').innerHTML = data.players.length
Linha 749: $('pageContent').innerHTML = `
Linha 783: $('grantsTable').innerHTML = data.grants.length
Linha 843: $('pageContent').innerHTML=`
Linha 875: $('auditTable').innerHTML=data.entries.length
Linha 897: $('pageContent').innerHTML = `
Linha 949: $('incidentsTable').innerHTML = data.incidents.length
Linha 979: $('incidentsTable').innerHTML =
Linha 989: $('pageContent').innerHTML = `
Linha 1088: $('logsTable').innerHTML = data.logs.length
Linha 1117: $('logsTable').innerHTML =
Linha 1126: $('pageContent').innerHTML = `
Linha 1186: $('killfeedTable').innerHTML = data.kills.length
Linha 1205: $('killfeedTable').innerHTML =
Linha 1210: $('modalRoot').innerHTML=`
Linha 1222: $('modalCancel').addEventListener('click',()=>$('modalRoot').innerHTML='');
Linha 1230: $('modalRoot').innerHTML='';

PADRAO: textContent
Linha 434: $('sideUsername').textContent = admin.username;
Linha 435: $('sideRole').textContent = admin.role.toUpperCase();
Linha 454: message.textContent = 'Autenticando...';
Linha 474: message.textContent = error.message;
Linha 509: $('topTitle').textContent = titleFor(page);
Linha 529: element.textContent = label;
Linha 535: if (element) element.textContent = value;
Linha 559: $('apiLabel').textContent = overallOK
Linha 615: $('apiLabel').textContent = 'API indisponivel';
Linha 684: $('statPlayers').textContent = players.total;
Linha 685: $('statQueue').textContent = effective.count;
Linha 686: $('statActive').textContent = active.total;
Linha 687: $('statScheduled').textContent = scheduled.total;
Linha 726: $('playersInfo').textContent = `Página ${playersPage} de ${pages} · ${data.total} registros`;
Linha 780: $('grantsInfo').textContent = `Página ${grantsPage} de ${pages} · ${data.total} concessões`;
Linha 872: $('auditInfo').textContent=`Página ${auditPage} de ${pages} · ${data.total} registros`;
Linha 943: $('incidentsInfo').textContent =
Linha 981: $('incidentsInfo').textContent = 'Falha ao consultar incidentes';
Linha 1082: $('logsInfo').textContent =
Linha 1120: $('logsInfo').textContent = 'Falha ao consultar logs';
Linha 1180: $('killfeedInfo').textContent =
Linha 1227: $('modalError').textContent='';
Linha 1232: $('modalError').textContent=error.message;

PADRAO: health
Linha 524: async function checkHealth() {
Linha 549: const health = await api('/health');
Linha 551: const primary = health.databases?.primary;
Linha 552: const killfeed = health.databases?.killfeed;
Linha 556: const overallOK = health.status === 'ok';
Linha 592: formatUptime(health.uptimeSeconds)
Linha 597: health.process?.memory?.rssMb != null
Linha 598: ? `${health.process.memory.rssMb} MB`
Linha 604: health.process?.memory?.heapUsedMb != null
Linha 605: ? `${health.process.memory.heapUsedMb} / ${health.process.memory.heapTotalMb} MB`
Linha 611: `Ultima verificacao: ${new Date(health.timestamp).toLocaleTimeString('pt-BR')}`
Linha 1257: checkHealth();
Linha 1258: setInterval(checkHealth,30000);

===========================================================================
5. BUSCA DE CONFIGURACOES DE LOG
===========================================================================

DIRETORIO: C:\RavenRP\ControlCenter\API\src
C:\RavenRP\ControlCenter\API\src\db.js | Linha 4 | logger
  const logger = require('./logger');
C:\RavenRP\ControlCenter\API\src\db.js | Linha 30 | logger
  logger.error({ error }, 'Erro inesperado no pool PostgreSQL');
C:\RavenRP\ControlCenter\API\src\db.js | Linha 6 | password
  if (!process.env.DB_PASSWORD_B64) {
C:\RavenRP\ControlCenter\API\src\db.js | Linha 7 | password
  throw new Error('DB_PASSWORD_B64 nao configurado.');
C:\RavenRP\ControlCenter\API\src\db.js | Linha 10 | password
  const password = Buffer
C:\RavenRP\ControlCenter\API\src\db.js | Linha 11 | password
  .from(process.env.DB_PASSWORD_B64, 'base64')
C:\RavenRP\ControlCenter\API\src\db.js | Linha 19 | password
  password,
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 7 | logger
  const logger = require('./logger');
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 42 | logger
  logger.error({ code: error.code }, 'Erro inesperado no pool read-only do KillFeed');
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 20 | password
  const encodedPassword = fs.readFileSync(secretPath, 'utf8').trim();
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 21 | password
  const password = Buffer.from(encodedPassword, 'base64').toString('utf8');
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 23 | password
  if (!password) {
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 32 | password
  password,
C:\RavenRP\ControlCenter\API\src\killfeed-db.js | Linha 20 | readFile
  const encodedPassword = fs.readFileSync(secretPath, 'utf8').trim();
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 6 | pino
  const pino = require('pino');
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 131 | pino
  const streams = pino.multistream([
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 136 | pino
  const logger = pino({
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 158 | pino
  timestamp: pino.stdTimeFunctions.isoTime
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 41 | logger
  `[RAVEN LOGGER] Falha na limpeza de ${name}: ${error.message}\n`
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 136 | logger
  const logger = pino({
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 161 | logger
  module.exports = logger;
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 47 | rotat
  class RotatingLogStream extends Writable {
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 129 | rotat
  const fileStream = new RotatingLogStream();
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 10 | retention
  const RETENTION_DAYS = 14;
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 25 | retention
  const cutoff = Date.now() - RETENTION_DAYS * 86400000;
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 10 | 14
  const RETENTION_DAYS = 14;
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 9 | 10\s*\*\s*1024
  const MAX_FILE_SIZE = 10 * 1024 * 1024;
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 139 | redact
  redact: {
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 155 | redact
  censor: '[REDACTED]'
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 145 | password
  'password',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 146 | password
  '*.password',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 153 | password
  'DB_PASSWORD_B64'
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 147 | token
  'token',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 148 | token
  '*.token',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 149 | token
  'accessToken',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 150 | token
  '*.accessToken',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 151 | token
  'refreshToken',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 141 | authorization
  'req.headers.authorization',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 142 | authorization
  'headers.authorization',
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 28 | readdir
  for (const name of fs.readdirSync(logDir)) {
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 74 | readdir
  for (const name of fs.readdirSync(logDir)) {
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 34 | statSync
  const stat = fs.statSync(file);
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 90 | statSync
  this.currentSize = fs.fstatSync(this.fd).size;
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 37 | unlink
  fs.unlinkSync(file);
C:\RavenRP\ControlCenter\API\src\logger.js | Linha 37 | unlinkSync
  fs.unlinkSync(file);
C:\RavenRP\ControlCenter\API\src\server.js | Linha 13 | pino
  const pinoHttp = require('pino-http');
C:\RavenRP\ControlCenter\API\src\server.js | Linha 41 | pino
  app.use(pinoHttp({ logger }));
C:\RavenRP\ControlCenter\API\src\server.js | Linha 15 | logger
  const logger = require('./logger');
C:\RavenRP\ControlCenter\API\src\server.js | Linha 41 | logger
  app.use(pinoHttp({ logger }));
C:\RavenRP\ControlCenter\API\src\server.js | Linha 110 | logger
  logger.info({
C:\RavenRP\ControlCenter\API\src\server.js | Linha 118 | logger
  logger.error({ error }, 'Falha no servidor HTTP');
C:\RavenRP\ControlCenter\API\src\server.js | Linha 129 | logger
  logger.info({ signal }, 'Encerramento seguro da API iniciado');
C:\RavenRP\ControlCenter\API\src\server.js | Linha 131 | owner
  let shutdownError = null;
C:\RavenRP\ControlCenter\API\src\server.js | Linha 136 | owner
  shutdownError = error;
C:\RavenRP\ControlCenter\API\src\server.js | Linha 153 | owner
  shutdownError = shutdownError || error;
C:\RavenRP\ControlCenter\API\src\server.js | Linha 161 | owner
  shutdownError = shutdownError || error;
C:\RavenRP\ControlCenter\API\src\server.js | Linha 165 | owner
  if (shutdownError) {
C:\RavenRP\ControlCenter\API\src\server.js | Linha 12 | limit
  const rateLimit = require('express-rate-limit');
C:\RavenRP\ControlCenter\API\src\server.js | Linha 57 | limit
  app.use(express.json({ limit: '1mb' }));
C:\RavenRP\ControlCenter\API\src\server.js | Linha 58 | limit
  app.use(express.urlencoded({ extended: false, limit: '1mb' }));
C:\RavenRP\ControlCenter\API\src\server.js | Linha 60 | limit
  app.use(rateLimit({
C:\RavenRP\ControlCenter\API\src\server.js | Linha 62 | limit
  limit: 300,
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 3 | token
  const { verifyAccessToken } = require('../services/auth');
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 17 | token
  const payload = await verifyAccessToken(match[1]);
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 22 | token
  error: 'INVALID_TOKEN_SUBJECT'
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 63 | token
  error: 'TOKEN_EXPIRED'
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 74 | token
  error: 'INVALID_OR_EXPIRED_TOKEN'
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 7 | authorization
  const authorization = req.get('authorization') || '';
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 8 | authorization
  const match = authorization.match(/^Bearer\s+(.+)$/i);
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 6 | requireAuth
  async function requireAuth(req, res, next) {
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 86 | requireAuth
  module.exports = requireAuth;
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 18 | admin
  const adminId = Number(payload.sub);
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 20 | admin
  if (!Number.isSafeInteger(adminId) || adminId <= 0) {
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 28 | admin
  FROM public.admin_users
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 30 | admin
  [adminId]
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js | Linha 33 | admin
  const admin = result.rows[0];
C:\RavenRP\ControlCenter\API\src\middleware\require-role.js | Linha 5 | admin
  if (!req.admin) {
C:\RavenRP\ControlCenter\API\src\middleware\require-role.js | Linha 9 | admin
  if (!allowedRoles.includes(req.admin.role)) {
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 77 | source_ip
  source_ip,
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 7 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 12 | requireAuth
  router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 13 | owner
  router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 13 | admin
  router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 72 | admin
  actor_admin_id::text,
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 20 | limit
  limit: z.coerce.number().int().min(1).max(100).default(50)
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 30 | limit
  const { action, entityType, entityId, page, limit } = parsed.data;
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 63 | limit
  limit,
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 64 | limit
  (page - 1) * limit
C:\RavenRP\ControlCenter\API\src\routes\audit.js | Linha 82 | limit
  LIMIT $${values.length + 1}
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 33 | 14
  password: z.string().min(14).max(72)
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 33 | password
  password: z.string().min(14).max(72)
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 50 | password
  const { username, password } = parsed.data;
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 52 | password
  if (Buffer.byteLength(password, 'utf8') > 72) {
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 60 | password
  `SELECT id, username, password_hash,
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 69 | password
  const passwordValid = await bcrypt.compare(
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 9 | token
  const { createAccessToken } = require('../services/auth');
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 87 | token
  const accessToken = await createAccessToken(admin);
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 90 | token
  accessToken,
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 91 | token
  tokenType: 'Bearer',
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 10 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 111 | requireAuth
  router.get('/me', requireAuth, (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 62 | admin
  FROM public.admin_users
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 67 | admin
  const admin = result.rows[0];
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 71 | admin
  admin ? admin.password_hash : dummyHash
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 74 | admin
  if (!admin || !admin.is_active || !passwordValid) {
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 81 | admin
  `UPDATE public.admin_users
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 6 | limit
  const rateLimit = require('express-rate-limit');
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 14 | limit
  const loginLimiter = rateLimit({
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 16 | limit
  limit: 5,
C:\RavenRP\ControlCenter\API\src\routes\auth.js | Linha 41 | limit
  router.post('/login', loginLimiter, async (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 7 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 12 | requireAuth
  router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 13 | owner
  router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 13 | admin
  router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 17 | limit
  limit: z.coerce.number().int().min(1).max(100).default(50)
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 29 | limit
  const { page, limit } = parsed.data;
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 53 | limit
  LIMIT $1 OFFSET $2`,
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 54 | limit
  [limit, (page - 1) * limit]
C:\RavenRP\ControlCenter\API\src\routes\incidents.js | Linha 59 | limit
  limit,
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 6 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 9 | requireAuth
  router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 14 | limit
  limit: z.coerce.number().int().min(1).max(100).default(50)
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 24 | limit
  const { search, page, limit } = parsed.data;
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 25 | limit
  const offset = (page - 1) * limit;
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 47 | limit
  LIMIT $${values.length + 1}
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js | Linha 49 | limit
  [...values, limit, offset]
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 81 | redact
  function redactValue(value, key = '') {
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 86 | redact
  return '[REDACTED]';
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 90 | redact
  return value.map(item => redactValue(item));
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 97 | redact
  output[childKey] = redactValue(childValue, childKey);
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 107 | redact
  '$1[REDACTED]'
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 82 | sensitive
  const sensitiveKey =
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 85 | sensitive
  if (sensitiveKey.test(key)) {
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 83 | password
  /(authorization|cookie|password|passwd|token|secret|api.?key|DB_PASSWORD_B64)/i;
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 110 | password
  /((?:password|passwd|token|secret|api[_-]?key)\s*[:=]\s*)[^,\s;]+/gi,
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 83 | token
  /(authorization|cookie|password|passwd|token|secret|api.?key|DB_PASSWORD_B64)/i;
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 110 | token
  /((?:password|passwd|token|secret|api[_-]?key)\s*[:=]\s*)[^,\s;]+/gi,
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 83 | authorization
  /(authorization|cookie|password|passwd|token|secret|api.?key|DB_PASSWORD_B64)/i;
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 8 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 19 | requireAuth
  router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 20 | owner
  router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 20 | admin
  router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 279 | readFile
  const content = await fs.promises.readFile(fullPath, 'utf8');
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 222 | readdir
  let files = fs.readdirSync(logDir, { withFileTypes: true })
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 266 | statSync
  const stat = fs.statSync(fullPath);
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 34 | limit
  limit: z.coerce.number().int().min(1).max(100).default(50)
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 207 | limit
  const { page, limit } = filters;
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 213 | limit
  limit,
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 251 | limit
  error: 'LOG_FILE_LIMIT_EXCEEDED',
C:\RavenRP\ControlCenter\API\src\routes\logs.js | Linha 261 | limit
  const offset = (page - 1) * limit;
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 9 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 14 | requireAuth
  router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 83 | owner
  requireRole('owner', 'admin', 'moderator'),
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 83 | admin
  requireRole('owner', 'admin', 'moderator'),
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 112 | admin
  actorType: 'admin',
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 113 | admin
  actorIdentifier: req.admin.username,
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 114 | admin
  actorAdminId: req.admin.id,
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 19 | limit
  limit: z.coerce.number().int().min(1).max(100).default(25)
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 34 | limit
  const { search, page, limit } = parsed.data;
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 35 | limit
  const offset = (page - 1) * limit;
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 52 | limit
  const paginationValues = [...values, limit, offset];
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 53 | limit
  const limitPosition = values.length + 1;
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 52 | pagination
  const paginationValues = [...values, limit, offset];
C:\RavenRP\ControlCenter\API\src\routes\players.js | Linha 63 | pagination
  paginationValues
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 10 | requireAuth
  const requireAuth = require('../middleware/require-auth');
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 15 | requireAuth
  router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 228 | owner
  requireRole('owner', 'admin', 'moderator'),
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 346 | owner
  requireRole('owner', 'admin', 'moderator'),
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 449 | owner
  requireRole('owner', 'admin', 'moderator'),
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 228 | admin
  requireRole('owner', 'admin', 'moderator'),
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 298 | admin
  granted_by_admin_id)
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 308 | admin
  req.admin.id
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 315 | admin
  actorType: 'admin',
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 316 | admin
  actorIdentifier: req.admin.username,
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 44 | limit
  limit: z.coerce.number().int().min(1).max(100).default(25)
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 145 | limit
  const { status, steam64, category, page, limit } = parsed.data;
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 181 | limit
  const offset = (page - 1) * limit;
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 182 | limit
  const queryValues = [...values, limit, offset];
C:\RavenRP\ControlCenter\API\src\routes\priority.js | Linha 183 | limit
  const limitPosition = values.length + 1;
C:\RavenRP\ControlCenter\API\src\services\audit.js | Linha 7 | source_ip
  action, entity_type, entity_id, details, source_ip)
C:\RavenRP\ControlCenter\API\src\services\audit.js | Linha 6 | admin
  (actor_type, actor_identifier, actor_admin_id,
C:\RavenRP\ControlCenter\API\src\services\audit.js | Linha 10 | admin
  data.actorType || 'admin',
C:\RavenRP\ControlCenter\API\src\services\audit.js | Linha 12 | admin
  data.actorAdminId || null,
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 15 | token
  async function createAccessToken(admin) {
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 38 | token
  async function verifyAccessToken(token) {
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 41 | token
  const result = await jwtVerify(token, secret, {
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 51 | token
  createAccessToken,
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 52 | token
  verifyAccessToken
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 15 | admin
  async function createAccessToken(admin) {
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 27 | admin
  role: admin.access_role
C:\RavenRP\ControlCenter\API\src\services\auth.js | Linha 30 | admin
  .setSubject(String(admin.id))
C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js | Linha 7 | logger
  async function recordHealthSnapshot(snapshot, logger) {
C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js | Linha 71 | logger
  if (logger && typeof logger.error === 'function') {
C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js | Linha 72 | logger
  logger.error(
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 11 | logger
  const logger = require('../logger');
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 73 | logger
  logger.info({ version, file }, 'Migration ja aplicada');
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 97 | logger
  logger.info(
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 107 | logger
  logger.info(
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 128 | logger
  logger.fatal({ error }, 'Falha nas migrations');
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 53 | readFile
  const sql = fs.readFileSync(
C:\RavenRP\ControlCenter\API\src\services\migrate.js | Linha 40 | readdir
  const files = fs.readdirSync(MIGRATIONS_DIR)
C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js | Linha 3 | logger
  const logger = require('../logger');
C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js | Linha 21 | logger
  logger.info(result, 'Concessoes prioritarias atualizadas');
C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js | Linha 30 | logger
  logger.error({ error }, 'Falha no agendador de prioridades');
C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js | Linha 54 | logger
  logger.info('Agendador de prioridades iniciado');
C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js | Linha 69 | logger
  logger.info('Agendador de prioridades encerrado');
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 9 | logger
  const logger = require('../logger');
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 156 | logger
  logger.warn({
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 192 | logger
  logger.info(response, 'Sincronizacao de prioridades concluida');
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 207 | logger
  logger.error({ error: recordError }, 'Falha ao registrar erro da sincronizacao');
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 211 | logger
  logger.error({ error }, 'Falha na sincronizacao de prioridades');
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 64 | readFile
  existing = await fs.readFile(TARGET_FILE, 'utf8');
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 77 | unlink
  await fs.unlink(TARGET_FILE);
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js | Linha 96 | unlink
  await fs.unlink(temp);

DIRETORIO: C:\RavenRP\ControlCenter\Dashboard
C:\RavenRP\ControlCenter\Dashboard\server.js | Linha 34 | readFile
  fs.readFile(file, (error, content) => {
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 18 | 14
  --red2:#d14c59;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 75 | 14
  padding:10px 14px;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 217 | 14
  margin-top:14px;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 276 | 14
  padding:12px 14px; border-radius:8px; margin:12px 0;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 299 | 14
  .sidebar { min-height:0; padding:14px; }
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 322 | password
  <label for="password">SENHA</label>
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 323 | password
  <input id="password" name="password" type="password" autocomplete="current-password" required minlength="14" maxlength="72">
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 461 | password
  password:$('password').value
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 470 | password
  $('password').value = '';
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 367 | token
  const TOKEN_KEY = 'raven_access_token';
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 370 | token
  let token = sessionStorage.getItem(TOKEN_KEY);
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 390 | token
  if (token) headers.Authorization = `Bearer ${token}`;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 442 | token
  token = null;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 444 | token
  sessionStorage.removeItem(TOKEN_KEY);
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 390 | authorization
  if (token) headers.Authorization = `Bearer ${token}`;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 436 | owner
  $('auditNav').classList.toggle('hidden', !['owner','admin'].includes(admin.role));
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 437 | owner
  incidentsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 438 | owner
  logsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 499 | owner
  if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 502 | owner
  if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 316 | admin
  <p class="subtitle">Control Center · Administração</p>
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 342 | admin
  <div class="user-name" id="sideUsername">Administrador</div>
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 356 | admin
  <div class="footer-note">RAVEN CONTROL CENTER · Ações administrativas são registradas pela API.</div>
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 368 | admin
  const ADMIN_KEY = 'raven_admin';
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 371 | admin
  let admin = null;
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 679 | limit
  api('/players?limit=1'),
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 681 | limit
  api('/priority/grants?status=active&limit=1'),
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 682 | limit
  api('/priority/grants?status=scheduled&limit=1')
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 721 | limit
  const query = new URLSearchParams({page:playersPage,limit:25});
C:\RavenRP\ControlCenter\Dashboard\public\index.html | Linha 724 | limit
  const pages = Math.max(1,Math.ceil(data.total/data.limit));

===========================================================================
6. TESTES AUTOMATIZADOS EXISTENTES
===========================================================================
TESTE ENCONTRADO: C:\RavenRP\ControlCenter\API\src\services\priority-sync-guard.test.js
Tamanho: 937 bytes
TESTE ENCONTRADO: C:\RavenRP\ControlCenter\API\src\services\priority-sync.test.js
Tamanho: 911 bytes

NAO FORAM EXECUTADOS TESTES NESTA AUDITORIA.

===========================================================================
7. INVENTARIO DOS ARQUIVOS DE LOG
===========================================================================

DIRETORIO: C:\RavenRP\ControlCenter\API\logs
ARQUIVO: api-2026-11-19-001.log
Tamanho: 202 bytes
Criado: 11/19/2026 08:43:38
Modificado: 11/19/2026 08:43:38
ARQUIVO: api-2026-11-19-002.log
Tamanho: 202 bytes
Criado: 11/19/2026 08:44:42
Modificado: 11/19/2026 08:44:42
ARQUIVO: api-2026-11-19-003.log
Tamanho: 2833154 bytes
Criado: 11/19/2026 09:01:06
Modificado: 11/19/2026 17:39:26
ARQUIVO: api-2026-11-19-004.log
Tamanho: 0 bytes
Criado: 11/19/2026 10:48:55
Modificado: 11/19/2026 10:48:55
ARQUIVO: api-2026-11-19-005.log
Tamanho: 0 bytes
Criado: 11/19/2026 10:50:49
Modificado: 11/19/2026 10:50:49
ARQUIVO: api-2026-11-19-006.log
Tamanho: 0 bytes
Criado: 11/19/2026 10:55:30
Modificado: 11/19/2026 10:55:30
ARQUIVO: api-2026-11-19-007.log
Tamanho: 0 bytes
Criado: 11/19/2026 11:01:13
Modificado: 11/19/2026 11:01:13
ARQUIVO: api-2026-11-19-008.log
Tamanho: 0 bytes
Criado: 11/19/2026 11:02:44
Modificado: 11/19/2026 11:02:44
ARQUIVO: api-monitoring-20261118-213548.stderr.log
Tamanho: 32 bytes
Criado: 11/18/2026 21:35:48
Modificado: 11/18/2026 21:35:48
ARQUIVO: api-monitoring-20261118-213548.stdout.log
Tamanho: 343156 bytes
Criado: 11/18/2026 21:35:48
Modificado: 11/18/2026 21:35:48
ARQUIVO: api-start-20261118-212635.stderr.log
Tamanho: 771 bytes
Criado: 11/18/2026 21:26:35
Modificado: 11/18/2026 21:26:36
ARQUIVO: api-start-20261118-212635.stdout.log
Tamanho: 0 bytes
Criado: 11/18/2026 21:26:35
Modificado: 11/18/2026 21:26:35
ARQUIVO: api-start-20261118-212709.stderr.log
Tamanho: 32 bytes
Criado: 11/18/2026 21:27:09
Modificado: 11/18/2026 21:27:09
ARQUIVO: api-start-20261118-212709.stdout.log
Tamanho: 199202 bytes
Criado: 11/18/2026 21:27:09
Modificado: 11/18/2026 21:35:20
ARQUIVO: restart-20261119-090103-stderr.log
Tamanho: 32 bytes
Criado: 11/19/2026 09:01:04
Modificado: 11/19/2026 09:01:04
ARQUIVO: restart-20261119-090103-stdout.log
Tamanho: 2441755 bytes
Criado: 11/19/2026 09:01:04
Modificado: 11/19/2026 16:07:35
TOTAL DE ARQUIVOS: 16
TOTAL EM MB: 5.55
PROPRIETARIO: BUILTIN\Administradores
REGRAS DE ACESSO:
IDENTIDADE: BUILTIN\Administradores
ACESSO: FullControl
TIPO: Allow
HERDADO: True
IDENTIDADE: AUTORIDADE NT\SISTEMA
ACESSO: FullControl
TIPO: Allow
HERDADO: True
IDENTIDADE: BUILTIN\Usuários
ACESSO: ReadAndExecute, Synchronize
TIPO: Allow
HERDADO: True
IDENTIDADE: AUTORIDADE NT\Usuários autenticados
ACESSO: Modify, Synchronize
TIPO: Allow
HERDADO: True
IDENTIDADE: AUTORIDADE NT\Usuários autenticados
ACESSO: -536805376
TIPO: Allow
HERDADO: True

DIRETORIO: C:\RavenRP\ControlCenter\Dashboard\logs
ARQUIVO: dashboard-20261119-083230.stderr.log
Tamanho: 0 bytes
Criado: 11/19/2026 08:32:30
Modificado: 11/19/2026 08:32:30
ARQUIVO: dashboard-20261119-083230.stdout.log
Tamanho: 0 bytes
Criado: 11/19/2026 08:32:30
Modificado: 11/19/2026 08:32:30
TOTAL DE ARQUIVOS: 2
TOTAL EM MB: 0
PROPRIETARIO: BUILTIN\Administradores
REGRAS DE ACESSO:
IDENTIDADE: BUILTIN\Administradores
ACESSO: FullControl
TIPO: Allow
HERDADO: True
IDENTIDADE: AUTORIDADE NT\SISTEMA
ACESSO: FullControl
TIPO: Allow
HERDADO: True
IDENTIDADE: BUILTIN\Usuários
ACESSO: ReadAndExecute, Synchronize
TIPO: Allow
HERDADO: True
IDENTIDADE: AUTORIDADE NT\Usuários autenticados
ACESSO: Modify, Synchronize
TIPO: Allow
HERDADO: True
IDENTIDADE: AUTORIDADE NT\Usuários autenticados
ACESSO: -536805376
TIPO: Allow
HERDADO: True

===========================================================================
8. VALIDACAO DE REFERENCIAS E ROTAS
===========================================================================
SERVER.JS LINHA 17: const healthRoutes = require('./routes/health');
SERVER.JS LINHA 23: const incidentsRoutes = require('./routes/incidents');
SERVER.JS LINHA 24: const logsRoutes = require('./routes/logs');
SERVER.JS LINHA 75: app.use('/api/health', healthRoutes);
SERVER.JS LINHA 81: app.use('/api/incidents', incidentsRoutes);
SERVER.JS LINHA 82: app.use('/api/logs', logsRoutes);
LOGS.JS LINHA 8: const requireAuth = require('../middleware/require-auth');
LOGS.JS LINHA 9: const requireRole = require('../middleware/require-role');
LOGS.JS LINHA 19: router.use(requireAuth);
LOGS.JS LINHA 20: router.use(requireRole('owner', 'admin'));
LOGS.JS LINHA 33: page: z.coerce.number().int().min(1).max(100000).default(1),
LOGS.JS LINHA 34: limit: z.coerce.number().int().min(1).max(100).default(50)
LOGS.JS LINHA 158: !JSON.stringify(entry)
LOGS.JS LINHA 197: router.get('/', async (req, res) => {
LOGS.JS LINHA 201: return res.status(400).json({
LOGS.JS LINHA 207: const { page, limit } = filters;
LOGS.JS LINHA 211: return res.json({
LOGS.JS LINHA 212: page,
LOGS.JS LINHA 213: limit,
LOGS.JS LINHA 222: let files = fs.readdirSync(logDir, { withFileTypes: true })
LOGS.JS LINHA 250: return res.status(413).json({
LOGS.JS LINHA 251: error: 'LOG_FILE_LIMIT_EXCEEDED',
LOGS.JS LINHA 261: const offset = (page - 1) * limit;
LOGS.JS LINHA 262: const end = offset + limit;
LOGS.JS LINHA 266: const stat = fs.statSync(fullPath);
LOGS.JS LINHA 268: if (!stat.isFile()) continue;
LOGS.JS LINHA 270: scannedBytes += stat.size;
LOGS.JS LINHA 273: return res.status(413).json({
LOGS.JS LINHA 274: error: 'LOG_SCAN_LIMIT_EXCEEDED',
LOGS.JS LINHA 279: const content = await fs.promises.readFile(fullPath, 'utf8');
LOGS.JS LINHA 292: entry = JSON.parse(line);
LOGS.JS LINHA 307: return res.json({
LOGS.JS LINHA 308: page,
LOGS.JS LINHA 309: limit,
LOGS.JS LINHA 321: return res.status(500).json({

===========================================================================
9. PROCESSOS E SERVICOS - SOMENTE CONSULTA
===========================================================================
PROCESSO: node.exe | PID: 4636
PROCESSO: node.exe | PID: 7320
Nenhum processo foi iniciado, encerrado ou reiniciado.

===========================================================================
10. LIMITACOES DESTA AUDITORIA
===========================================================================
- Nenhum endpoint HTTP foi chamado.
- Nenhuma conexao PostgreSQL foi aberta.
- Nenhum teste automatizado foi executado.
- Nenhum arquivo foi alterado.
- Nenhum arquivo .env foi lido.
- Nenhum conteudo de arquivo de log foi exibido.
- Rotacao e retencao foram analisadas apenas pelo codigo e metadados.
- ACL foi consultada sem modificacao.
- Resultados precisam ser avaliados antes da homologacao.

===========================================================================
11. RESULTADO
===========================================================================
AUDITORIA 6.4 CONCLUIDA.
Tipo: SOMENTE LEITURA
Relatorio: C:\Users\Nasdara\Desktop\RAVEN_AUDITORIA_64_LOGS_20261119_174248.txt
