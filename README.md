RAVEN CONTROL CENTER - AUDITORIA DIRECIONADA DE CODIGO
Data: 2026-11-19 14:28:36
Modo: SOMENTE LEITURA
Objetivo: preparar correcao do KillFeed e integracao VPP.

1. EXISTENCIA DOS DIRETORIOS
C:\RavenRP\ControlCenter : True
C:\RavenRP\ControlCenter\API : True
C:\RavenRP\Discord-KillFeed : True

ESTRUTURA: C:\RavenRP\ControlCenter

Mode   Length LastWriteTime       Name                                  
----   ------ -------------       ----                                  
d-----        19/11/2026 08:44:42 API                                   
d-----        19/11/2026 10:43:38 audit                                 
d-----        18/11/2026 20:40:39 Backups                               
d-----        19/11/2026 08:32:30 Dashboard                             
d-----        17/11/2026 15:09:22 Integrations                          
d-----        19/11/2026 08:21:22 Logs                                  
d-----        17/11/2026 15:09:22 PriorityQueue                         
-a---- 1870   18/11/2026 19:12:25 Start-RavenAPI.ps1                    
-a---- 1137   18/11/2026 18:58:25 Start-RavenAPI.ps1.20261118-191224.bak




ESTRUTURA: C:\RavenRP\ControlCenter\API

Mode   Length LastWriteTime       Name                       
----   ------ -------------       ----                       
d-----        19/11/2026 08:53:46 backups                    
d-----        19/11/2026 11:02:44 logs                       
d-----        18/11/2026 21:47:00 migrations                 
d-----        17/11/2026 17:36:47 node_modules               
d-----        18/11/2026 20:09:42 scripts                    
d-----        18/11/2026 21:18:14 src                        
-a---- 442    18/11/2026 19:56:45 .env                       
-a---- 386    17/11/2026 21:18:32 .env.backup-20261118-195645
-a---- 277    17/11/2026 17:38:58 .env.example               
-a---- 61     17/11/2026 17:38:58 .gitignore                 
-a---- 54241  17/11/2026 17:36:47 package-lock.json          
-a---- 810    17/11/2026 21:10:18 package.json               




ESTRUTURA: C:\RavenRP\ControlCenter\API\src

Mode   Length LastWriteTime       Name          
----   ------ -------------       ----          
d-----        17/11/2026 21:48:47 middleware    
d-----        19/11/2026 08:53:46 routes        
d-----        18/11/2026 21:47:00 services      
-a---- 821    17/11/2026 17:39:12 db.js         
-a---- 1343   18/11/2026 21:18:14 killfeed-db.js
-a---- 3809   19/11/2026 08:44:42 logger.js     
-a---- 4735   19/11/2026 08:53:46 server.js     




ESTRUTURA: C:\RavenRP\ControlCenter\API\migrations

Mode   Length LastWriteTime       Name                      
----   ------ -------------       ----                      
-a----   5373 17/11/2026 21:09:26 001_initial_schema.sql    
-a----    995 17/11/2026 21:44:57 002_priority_integrity.sql
-a----    850 18/11/2026 21:56:06 003_system_incidents.sql  




ESTRUTURA: C:\RavenRP\Discord-KillFeed

Mode   Length LastWriteTime       Name              
----   ------ -------------       ----              
d-----        16/11/2026 13:50:36 .venv             
d-----        16/11/2026 13:43:41 killfeed          
d-----        17/11/2026 13:01:13 logs              
d-----        16/11/2026 13:43:42 sql               
-a---- 522    16/11/2026 15:27:23 .env              
-a---- 438    16/11/2026 13:43:41 .env.example      
-a---- 46     16/11/2026 13:43:41 .gitignore        
-a---- 408    16/11/2026 13:43:41 install.bat       
-a---- 4245   16/11/2026 13:43:41 README.md         
-a---- 64     16/11/2026 13:43:41 requirements.txt  
-a---- 0      16/11/2026 16:37:57 start-killfeed.bat
-a---- 166    16/11/2026 13:43:41 start.bat         




ESTRUTURA: C:\RavenRP\Discord-KillFeed\killfeed

Mode   Length LastWriteTime       Name       
----   ------ -------------       ----       
d-----        16/11/2026 13:51:17 __pycache__
-a---- 2663   16/11/2026 13:43:41 database.py
-a---- 2311   16/11/2026 13:43:41 discord.py 
-a---- 3372   16/11/2026 13:43:41 monitor.py 
-a---- 3276   16/11/2026 13:43:41 parser.py  
-a---- 30     16/11/2026 13:43:41 __init__.py
-a---- 2521   16/11/2026 13:43:41 __main__.py




ESTRUTURA: C:\RavenRP\Discord-KillFeed\sql

Mode   Length LastWriteTime       Name      
----   ------ -------------       ----      
-a----    758 16/11/2026 13:43:42 schema.sql




2. METADADOS DOS REPOSITORIOS GIT

3. CONFIGURACAO DA API - PACKAGE.JSON

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\package.json
====================================================================================================
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


4. CODIGO JAVASCRIPT DA API

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\db.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\killfeed-db.js
====================================================================================================
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const { Pool } = require('pg');
const logger = require('./logger');

const secretPath = process.env.KILLFEED_READER_SECRET_FILE ||
    path.join(
        process.env.LOCALAPPDATA || os.homedir(),
        'RavenControlCenter',
        'killfeed-reader-secret.b64'
    );

if (!fs.existsSync(secretPath)) {
    throw new Error('Credencial protegida do KillFeed nao encontrada.');
}

const encodedPassword = fs.readFileSync(secretPath, 'utf8').trim();
const password = Buffer.from(encodedPassword, 'base64').toString('utf8');

if (!password) {
    throw new Error('Credencial do KillFeed esta vazia.');
}

const killfeedPool = new Pool({
    host: process.env.KILLFEED_DB_HOST || '127.0.0.1',
    port: Number(process.env.KILLFEED_DB_PORT || 5432),
    database: process.env.KILLFEED_DB_NAME || 'dayz_killfeed',
    user: process.env.KILLFEED_DB_USER || 'raven_killfeed_reader',
    password,
    max: 2,
    connectionTimeoutMillis: 5000,
    idleTimeoutMillis: 10000,
    application_name: 'raven-killfeed-readonly-api',
    ssl: false,
    allowExitOnIdle: true
});

killfeedPool.on('error', error => {
    logger.error({ code: error.code }, 'Erro inesperado no pool read-only do KillFeed');
});

module.exports = { killfeedPool };

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\logger.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\middleware\require-role.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\audit.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\auth.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\health.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\incidents.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\killfeed.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\logs.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\players.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\routes\priority.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\server.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\audit.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\auth.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\migrate.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-format.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-status.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-sync.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-sync.test.js
====================================================================================================
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


====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-sync-guard.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\priority-sync-guard.test.js
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\src\services\transaction.js
====================================================================================================
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

5. MIGRACOES SQL DA API

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\migrations\002_priority_integrity.sql
====================================================================================================
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

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\migrations\003_system_incidents.sql
====================================================================================================
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


6. OUTROS ARQUIVOS SQL DA API

7. CODIGO PYTHON DO KILLFEED

====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\__init__.py
====================================================================================================
"""DayZ ADM PvP kill feed."""


====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\__main__.py
====================================================================================================
import argparse
import logging
import os
from pathlib import Path
from zoneinfo import ZoneInfo

from dotenv import load_dotenv

from .parser import parse_kill

SAMPLE = ('14:22:34 | Player "Vex" (DEAD) (id=ABC pos=<4758.1, 10200.8, 288.6>) '
          'killed by Player "Rook" (id=XYZ pos=<4611.0, 10088.4, 291.0>) '
          'with M4-A1 from 185.1 meters')


def main():
    load_dotenv()
    cli = argparse.ArgumentParser(description='DayZ PvP Kill Feed para Discord')
    cli.add_argument('--test-parser', action='store_true', help='Valida o parser com uma linha de exemplo')
    args = cli.parse_args()
    timezone = ZoneInfo(os.getenv('TIMEZONE', 'America/Sao_Paulo'))

    if args.test_parser:
        result = parse_kill(SAMPLE, 'DayZServer_x64_2026-11-16_13-38-51.ADM', timezone)
        if not result:
            raise SystemExit('FALHA: exemplo nÃ£o reconhecido')
        print('OK: parser reconheceu a morte PvP')
        for key, value in result.items():
            if key != 'raw_line':
                print(f'{key}: {value}')
        return

    from .database import Database
    from .discord import DiscordWebhook
    from .monitor import AdmMonitor

    log_dir = os.getenv('DAYZ_LOG_DIR', '').strip()
    dsn = os.getenv('DATABASE_URL', '').strip()
    webhook_url = os.getenv('DISCORD_WEBHOOK_URL', '').strip()
    if not log_dir or not dsn or not webhook_url:
        raise SystemExit('Configure DAYZ_LOG_DIR, DATABASE_URL e DISCORD_WEBHOOK_URL no arquivo .env')
    if not Path(log_dir).is_dir():
        raise SystemExit(f'DAYZ_LOG_DIR nÃ£o existe: {log_dir}')
    if 'COLOQUE_A_URL' in webhook_url or 'ID/TOKEN' in webhook_url:
        raise SystemExit('Configure a URL real do webhook no .env')

    Path('logs').mkdir(exist_ok=True)
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)s %(message)s',
        handlers=[logging.StreamHandler(), logging.FileHandler('logs/killfeed.log', encoding='utf-8')],
    )
    logger = logging.getLogger('killfeed')
    db = Database(dsn)
    discord = DiscordWebhook(webhook_url, int(os.getenv('EMBED_COLOR', '15158332')))
    monitor = AdmMonitor(
        log_dir=log_dir,
        pattern=os.getenv('DAYZ_FILE_GLOB', '*.ADM'),
        database=db,
        discord=discord,
        timezone=timezone,
        interval=max(0.5, float(os.getenv('POLL_INTERVAL_SECONDS', '1'))),
    )
    try:
        monitor.run()
    finally:
        discord.close()
        db.close()


if __name__ == '__main__':
    main()


====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\database.py
====================================================================================================
import json
import psycopg
from psycopg.rows import dict_row

SCHEMA = '''
CREATE TABLE IF NOT EXISTS pvp_kills (
    id BIGSERIAL PRIMARY KEY,
    event_id CHAR(64) NOT NULL UNIQUE,
    occurred_at TIMESTAMPTZ NOT NULL,
    killer_name TEXT NOT NULL,
    killer_id TEXT,
    victim_name TEXT NOT NULL,
    victim_id TEXT,
    weapon TEXT NOT NULL,
    distance_m DOUBLE PRECISION,
    killer_position JSONB,
    victim_position JSONB,
    raw_line TEXT NOT NULL,
    discord_sent BOOLEAN NOT NULL DEFAULT FALSE,
    discord_attempts INTEGER NOT NULL DEFAULT 0,
    discord_last_error TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_pvp_kills_occurred_at ON pvp_kills (occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_pvp_kills_pending ON pvp_kills (created_at) WHERE discord_sent = FALSE;
'''


class Database:
    def __init__(self, dsn: str):
        self.conn = psycopg.connect(dsn, row_factory=dict_row)
        self.conn.execute(SCHEMA)
        self.conn.commit()

    def insert_kill(self, event: dict) -> bool:
        query = '''INSERT INTO pvp_kills
        (event_id, occurred_at, killer_name, killer_id, victim_name, victim_id,
         weapon, distance_m, killer_position, victim_position, raw_line)
        VALUES (%(event_id)s, %(occurred_at)s, %(killer_name)s, %(killer_id)s,
         %(victim_name)s, %(victim_id)s, %(weapon)s, %(distance_m)s,
         %(killer_position)s::jsonb, %(victim_position)s::jsonb, %(raw_line)s)
        ON CONFLICT (event_id) DO NOTHING RETURNING id'''
        values = dict(event)
        values['killer_position'] = json.dumps(event['killer_position']) if event['killer_position'] else None
        values['victim_position'] = json.dumps(event['victim_position']) if event['victim_position'] else None
        try:
            row = self.conn.execute(query, values).fetchone()
            self.conn.commit()
            return row is not None
        except Exception:
            self.conn.rollback()
            raise

    def pending(self, limit=20):
        return self.conn.execute(
            'SELECT * FROM pvp_kills WHERE discord_sent=FALSE ORDER BY id LIMIT %s', (limit,)
        ).fetchall()

    def mark_sent(self, row_id: int):
        self.conn.execute('UPDATE pvp_kills SET discord_sent=TRUE, discord_last_error=NULL WHERE id=%s', (row_id,))
        self.conn.commit()

    def mark_error(self, row_id: int, error: str):
        self.conn.execute('''UPDATE pvp_kills SET discord_attempts=discord_attempts+1,
            discord_last_error=%s WHERE id=%s''', (error[:1000], row_id))
        self.conn.commit()

    def close(self):
        self.conn.close()


====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\discord.py
====================================================================================================
import requests


def _safe(value):
    # Impede menÃ§Ãµes involuntÃ¡rias e limita o tamanho dos campos do Discord.
    return str(value or 'NÃ£o informado').replace('@', '@\u200b')[:1024]


def _coords(value):
    if isinstance(value, str):
        import json
        value = json.loads(value)
    return ', '.join(f'{float(v):.1f}' for v in value)


class DiscordWebhook:
    def __init__(self, url: str, color: int):
        self.url = url
        self.color = color
        self.session = requests.Session()
        self.session.headers.update({'User-Agent': 'DayZ-PvP-KillFeed/1.0'})

    def send(self, event: dict):
        fields = [
            {'name': 'ðŸ”« Assassino', 'value': _safe(event['killer_name']), 'inline': True},
            {'name': 'ðŸ’€ VÃ­tima', 'value': _safe(event['victim_name']), 'inline': True},
            {'name': 'Arma', 'value': _safe(event['weapon']), 'inline': True},
            {'name': 'DistÃ¢ncia', 'value': f"{event['distance_m']:.1f} m" if event['distance_m'] is not None else 'NÃ£o registrada', 'inline': True},
            {'name': 'Data/hora', 'value': event['occurred_at'].strftime('%d/%m/%Y %H:%M:%S %Z'), 'inline': True},
        ]
        killer_pos = event.get('killer_position')
        victim_pos = event.get('victim_position')
        if killer_pos:
            fields.append({'name': 'PosiÃ§Ã£o do assassino (X, Y, Z)', 'value': _coords(killer_pos), 'inline': True})
        if victim_pos:
            fields.append({'name': 'PosiÃ§Ã£o da vÃ­tima (X, Y, Z)', 'value': _coords(victim_pos), 'inline': True})

        payload = {
            'username': 'DayZ Kill Feed',
            'allowed_mentions': {'parse': []},
            'embeds': [{
                'title': 'â˜ ï¸ KILL FEED â€” PvP',
                'description': f"**{_safe(event['killer_name'])}** eliminou **{_safe(event['victim_name'])}**",
                'color': self.color,
                'fields': fields,
                'footer': {'text': 'Servidor DayZ â€¢ Registro administrativo'},
            }],
        }
        response = self.session.post(self.url, json=payload, timeout=15)
        if response.status_code not in (200, 204):
            raise RuntimeError(f'Discord HTTP {response.status_code}: {response.text[:250]}')

    def close(self):
        self.session.close()


====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\monitor.py
====================================================================================================
import logging
import time
from pathlib import Path

from .parser import parse_kill


def latest_adm(directory: Path, pattern: str):
    candidates = list(directory.glob(pattern))
    return max(candidates, key=lambda path: path.stat().st_mtime) if candidates else None


class AdmMonitor:
    def __init__(self, log_dir: str, pattern: str, database, discord, timezone, interval: float):
        self.log_dir = Path(log_dir)
        self.pattern = pattern
        self.database = database
        self.discord = discord
        self.timezone = timezone
        self.interval = interval
        self.logger = logging.getLogger('killfeed')
        self.current_file = None
        self.position = 0
        self.discord_retry_at = 0.0

    def _dispatch_pending(self):
        now = time.monotonic()
        if now < self.discord_retry_at:
            return
        for row in self.database.pending():
            try:
                self.discord.send(row)
                self.database.mark_sent(row['id'])
                self.logger.info('Publicado no Discord: %s -> %s', row['killer_name'], row['victim_name'])
            except Exception as exc:
                self.database.mark_error(row['id'], str(exc))
                self.logger.exception('Falha ao publicar evento %s', row['id'])
                self.discord_retry_at = time.monotonic() + 10
                break

    def _tail(self):
        newest = latest_adm(self.log_dir, self.pattern)
        if newest is None:
            return
        if self.current_file is None:
            # Primeira inicializaÃ§Ã£o: evita disparar todo o histÃ³rico antigo.
            self.current_file = newest
            self.position = newest.stat().st_size
            self.logger.info('Arquivo ADM inicial: %s; leitura comeÃ§arÃ¡ no fim.', newest.name)
            return
        if newest != self.current_file:
            self.current_file = newest
            self.position = 0
            self.logger.info('Novo arquivo ADM detectado: %s', newest.name)

        size = self.current_file.stat().st_size
        if size < self.position:
            self.logger.warning('Arquivo ADM truncado; reposicionando leitura.')
            self.position = 0
        if size == self.position:
            return

        # Reabre a cada ciclo para nÃ£o bloquear o DayZ no Windows.
        with self.current_file.open('rb') as stream:
            stream.seek(self.position)
            chunk = stream.read()
            self.position = stream.tell()
        lines = chunk.decode('utf-8', errors='replace').splitlines()
        for line in lines:
            event = parse_kill(line, self.current_file.name, self.timezone)
            if event and self.database.insert_kill(event):
                self.logger.info('PvP detectado: %s -> %s | %s', event['killer_name'], event['victim_name'], event['weapon'])

    def run(self):
        self.logger.info('Monitorando %s (%s)', self.log_dir, self.pattern)
        while True:
            try:
                self._dispatch_pending()
                self._tail()
                time.sleep(self.interval)
            except KeyboardInterrupt:
                self.logger.info('Encerramento solicitado.')
                return
            except Exception:
                self.logger.exception('Erro no monitoramento; nova tentativa em 3 segundos.')
                time.sleep(3)


====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\parser.py
====================================================================================================
import hashlib
import re
from datetime import date, datetime
from pathlib import Path
from zoneinfo import ZoneInfo

# Formato vanilla documentado: HH:MM:SS | Player "victim" (DEAD)
# (id=... pos=<x, y, z>) killed by Player "killer" (id=... pos=<x, y, z>)
# with WEAPON from N meters. A distÃ¢ncia/posiÃ§Ãµes podem variar em versÃµes/mods.
KILL_RE = re.compile(
    r'^(?P<clock>\d{2}:\d{2}:\d{2})\s*\|\s*'
    r'Player\s+"(?P<victim>.*?)"\s+\(DEAD\)\s+'
    r'\(id=(?P<victim_id>.*?)\s+pos=<(?P<vx>-?[\d.]+),\s*(?P<vy>-?[\d.]+),\s*(?P<vz>-?[\d.]+)>\)\s+'
    r'killed by Player\s+"(?P<killer>.*?)"\s+'
    r'\(id=(?P<killer_id>.*?)\s+pos=<(?P<kx>-?[\d.]+),\s*(?P<ky>-?[\d.]+),\s*(?P<kz>-?[\d.]+)>\)\s+'
    r'with\s+(?P<weapon>.+?)\s+from\s+(?P<distance>[\d.]+)\s+meters?\s*$', re.I
)

# Fallback conservador: ainda exige morte de um Player causada por outro Player.
FALLBACK_RE = re.compile(
    r'^(?P<clock>\d{2}:\d{2}:\d{2})\s*\|\s*'
    r'Player\s+"(?P<victim>.*?)".*?\(DEAD\).*?killed by Player\s+"(?P<killer>.*?)".*?'
    r'with\s+(?P<weapon>.+?)(?:\s+from\s+(?P<distance>[\d.]+)\s*(?:meters?|m))?\s*$', re.I
)


def _date_from_filename(filename: str) -> date | None:
    name = Path(filename).name
    # DayZServer_x64_2026-11-16_13-38-51.ADM
    match = re.search(r'(\d{4})-(\d{2})-(\d{2})', name)
    # DayZServer_x64_2026_11_16_133851123.ADM
    if not match:
        match = re.search(r'(\d{4})_(\d{2})_(\d{2})', name)
    if match:
        try:
            return date(*(int(part) for part in match.groups()))
        except ValueError:
            return None
    return None


def parse_kill(line: str, filename: str, timezone: ZoneInfo) -> dict | None:
    raw = line.strip()
    match = KILL_RE.match(raw)
    has_positions = match is not None
    if match is None:
        match = FALLBACK_RE.match(raw)
    if match is None:
        return None

    data = match.groupdict()
    killer, victim = data['killer'].strip(), data['victim'].strip()
    if not killer or not victim or killer.casefold() == victim.casefold():
        return None

    log_date = _date_from_filename(filename) or datetime.now(timezone).date()
    clock = datetime.strptime(data['clock'], '%H:%M:%S').time()
    occurred_at = datetime.combine(log_date, clock, tzinfo=timezone)

    def coords(prefix):
        if not has_positions:
            return None
        return [float(data[prefix + axis]) for axis in ('x', 'y', 'z')]

    # O ID Ã© capturado sem o sufixo " pos=...".
    victim_id = data.get('victim_id')
    killer_id = data.get('killer_id')
    if victim_id:
        victim_id = victim_id.split(' pos=')[0].strip()[:128]
    if killer_id:
        killer_id = killer_id.split(' pos=')[0].strip()[:128]

    event_id = hashlib.sha256((Path(filename).name + '|' + raw).encode('utf-8', 'replace')).hexdigest()
    return {
        'event_id': event_id,
        'occurred_at': occurred_at,
        'killer_name': killer,
        'killer_id': killer_id,
        'victim_name': victim,
        'victim_id': victim_id,
        'weapon': data.get('weapon', 'NÃ£o identificada').strip(),
        'distance_m': float(data['distance']) if data.get('distance') else None,
        'killer_position': coords('k'),
        'victim_position': coords('v'),
        'raw_line': raw,
    }


8. SQL DO KILLFEED

====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\sql\schema.sql
====================================================================================================
CREATE TABLE IF NOT EXISTS pvp_kills (
    id BIGSERIAL PRIMARY KEY,
    event_id CHAR(64) NOT NULL UNIQUE,
    occurred_at TIMESTAMPTZ NOT NULL,
    killer_name TEXT NOT NULL,
    killer_id TEXT,
    victim_name TEXT NOT NULL,
    victim_id TEXT,
    weapon TEXT NOT NULL,
    distance_m DOUBLE PRECISION,
    killer_position JSONB,
    victim_position JSONB,
    raw_line TEXT NOT NULL,
    discord_sent BOOLEAN NOT NULL DEFAULT FALSE,
    discord_attempts INTEGER NOT NULL DEFAULT 0,
    discord_last_error TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_pvp_kills_occurred_at ON pvp_kills (occurred_at DESC);
CREATE INDEX IF NOT EXISTS idx_pvp_kills_pending ON pvp_kills (created_at) WHERE discord_sent = FALSE;


9. DOCUMENTACAO DO KILLFEED

====================================================================================================
ARQUIVO: C:\RavenRP\Discord-KillFeed\README.md
====================================================================================================
# DayZ PvP Kill Feed â†’ Discord

ServiÃ§o independente para Windows que acompanha os arquivos `.ADM` do DayZ, detecta mortes PvP, grava no PostgreSQL e publica embeds em um canal privado do Discord.

## Requisitos

- Windows 10/11 ou Windows Server
- Python 3.11 ou superior
- PostgreSQL 14 ou superior
- DayZ Dedicated Server iniciado com `-adminlog`
- Webhook de um canal privado do Discord

## 1. Ativar o ADM no DayZ

O parÃ¢metro `-adminlog` Ã© obrigatÃ³rio. O arquivo `.ADM` Ã© criado na pasta definida pelo parÃ¢metro `-profiles`.

Exemplo de inicializaÃ§Ã£o (adapte os caminhos e parÃ¢metros jÃ¡ existentes):

```bat
DayZServer_x64.exe -config=serverDZ.cfg -port=2302 "-profiles=C:\DayZServer\profiles" -adminlog
```

NÃ£o substitua sua linha atual: apenas acrescente `-adminlog` se ainda nÃ£o estiver presente. O valor de `DAYZ_LOG_DIR` deve apontar para a mesma pasta de `-profiles`.

ReferÃªncia oficial: https://community.bohemia.net/wiki/DayZ:Administration_Logs

## 2. Criar banco PostgreSQL

No pgAdmin ou `psql`, execute (troque a senha):

```sql
CREATE USER dayz_killfeed WITH PASSWORD 'SENHA_FORTE_AQUI';
CREATE DATABASE dayz_killfeed OWNER dayz_killfeed;
```

A aplicaÃ§Ã£o cria a tabela e os Ã­ndices automaticamente ao iniciar. O arquivo `sql/schema.sql` tambÃ©m pode ser executado manualmente.

## 3. Criar webhook no Discord

1. Abra as configuraÃ§Ãµes do servidor Discord.
2. Entre em IntegraÃ§Ãµes â†’ Webhooks.
3. Crie um webhook no canal privado da administraÃ§Ã£o.
4. Copie a URL e guarde-a como segredo. Qualquer pessoa com essa URL pode publicar no canal.

NÃ£o Ã© necessÃ¡rio criar um bot nem disponibilizar token de bot.

## 4. Instalar e configurar

1. Extraia a pasta do projeto no PC que hospeda o DayZ.
2. Execute `install.bat`.
3. Edite `.env` e configure:
   - `DAYZ_LOG_DIR`: pasta `profiles` real do servidor.
   - `DATABASE_URL`: endereÃ§o, banco, usuÃ¡rio e senha PostgreSQL.
   - `DISCORD_WEBHOOK_URL`: URL do webhook.
4. Rode o teste local do parser:

```powershell
.venv\Scripts\python.exe -m killfeed --test-parser
```

5. Execute `start.bat`.

## 5. Testar com o log real

FaÃ§a uma morte PvP controlada no servidor e confira:

- O console do serviÃ§o deve exibir `PvP detectado`.
- O canal Discord deve receber o Embed.
- A tabela `pvp_kills` deve conter o evento.

Consulta de conferÃªncia:

```sql
SELECT occurred_at, killer_name, victim_name, weapon, distance_m,
       discord_sent, discord_attempts
FROM pvp_kills
ORDER BY occurred_at DESC
LIMIT 20;
```

O parser foi implementado para o formato vanilla documentado. Mods, versÃµes ou formatos diferentes podem exigir ajuste. Se o parser de exemplo funcionar mas uma kill real nÃ£o for reconhecida, envie uma linha real do `.ADM` (pode ocultar os IDs) para ajustar a expressÃ£o com seguranÃ§a.

## 6. InicializaÃ§Ã£o automÃ¡tica

Use o Agendador de Tarefas do Windows:

- Gatilho: Ao iniciar o computador (ou ao iniciar sessÃ£o, conforme sua operaÃ§Ã£o).
- AÃ§Ã£o / Programa: caminho completo para `dayz-discord-killfeed\.venv\Scripts\python.exe`.
- Argumentos: `-m killfeed`.
- Iniciar em: caminho completo da pasta `dayz-discord-killfeed`.
- Configure reinicializaÃ§Ã£o em caso de falha.

O serviÃ§o grava o log em `logs\killfeed.log`.

## Comportamento e limitaÃ§Ãµes

- Na primeira inicializaÃ§Ã£o, o monitor comeÃ§a no final do `.ADM` mais recente para nÃ£o despejar o histÃ³rico antigo no Discord.
- Ao detectar um novo arquivo `.ADM` (normalmente apÃ³s reinÃ­cio do servidor), comeÃ§a a acompanhar o novo arquivo desde o inÃ­cio.
- A chave SHA-256 e a restriÃ§Ã£o `UNIQUE` evitam inserir a mesma linha duas vezes no banco.
- Se o Discord estiver indisponÃ­vel, os eventos ficam pendentes no banco e sÃ£o tentados novamente.
- A entrega ao Discord Ã© **at-least-once**: uma queda exatamente depois de o Discord aceitar a mensagem e antes de o banco marcar como enviada pode ocasionar uma mensagem repetida. Webhook nÃ£o oferece chave de idempotÃªncia para eliminar completamente essa janela.
- O monitor acompanha o arquivo `.ADM` mais recente. NÃ£o mova nem apague o arquivo ativo enquanto o serviÃ§o estiver rodando.
- O serviÃ§o nÃ£o executa comandos administrativos, nÃ£o altera o jogo e nÃ£o requer mod instalado pelos jogadores.


10. DOCUMENTACAO E CONFIGURACAO DE EXEMPLO DA API

====================================================================================================
ARQUIVO: C:\RavenRP\ControlCenter\API\.env.example
====================================================================================================
NODE_ENV=development
API_HOST=127.0.0.1
API_PORT=3100
LOG_LEVEL=info

DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=raven_control
DB_USER=raven_app
DB_PASSWORD_B64=SUBSTITUIR_POR_BASE64
DB_POOL_MAX=5
DB_CONNECTION_TIMEOUT=5000

CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173

11. INTEGRACOES RAVEN - INVENTARIO

ESTRUTURA: C:\RavenRP\ControlCenter\Integrations


12. VERIFICACAO DE SEGURANCA
Arquivos .env: NAO LIDOS
Credenciais: NAO CONSULTADAS
Banco PostgreSQL: NENHUMA CONEXAO REALIZADA
Servicos: NAO REINICIADOS
Migracoes: NAO EXECUTADAS
Arquivos do projeto: NAO ALTERADOS
Instalacoes: NENHUMA

FIM DA AUDITORIA

