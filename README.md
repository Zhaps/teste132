**********************
Início da transcrição do Windows PowerShell
Hora de início: 20261119141025
Nome de Usuário: DESKTOP-LDECQT3\Nasdara
Executar como Usuário: DESKTOP-LDECQT3\Nasdara
Nome da Configuração: 
Computador: DESKTOP-LDECQT3 (Microsoft Windows NT 10.0.19045.0)
Aplicativo Host: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
ID do Processo: 1100
PSVersion: 5.1.19041.6456
PSEdition: Desktop
PSCompatibleVersions: 1.0, 2.0, 3.0, 4.0, 5.0, 5.1.19041.6456
BuildVersion: 10.0.19041.6456
CLRVersion: 4.0.30319.42000
WSManStackVersion: 3.0
PSRemotingProtocolVersion: 2.3
SerializationVersion: 1.1.0.1
**********************

RAVEN - INSPECAO DA API E DO POSTGRESQL
Data: 2026-11-19 14:10:26

[1] CONFIGURACAO DO PROJETO
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

[2] ARQUIVOS PRINCIPAIS DA API

==================================================
ARQUIVO: src/server.js
==================================================
   1: 'use strict';
   2:
   3: const path = require('path');
   4:
   5: require('dotenv').config({
   6:     path: path.resolve(__dirname, '..', '.env')
   7: });
   8:
   9: const express = require('express');
  10: const helmet = require('helmet');
  11: const cors = require('cors');
  12: const rateLimit = require('express-rate-limit');
  13: const pinoHttp = require('pino-http');
  14:
  15: const logger = require('./logger');
  16: const { pool } = require('./db');
  17: const healthRoutes = require('./routes/health');
  18: const authRoutes = require('./routes/auth');
  19: const playersRoutes = require('./routes/players');
  20: const priorityRoutes = require('./routes/priority');
  21: const auditRoutes = require('./routes/audit');
  22: const killfeedRoutes = require('./routes/killfeed');
  23: const incidentsRoutes = require('./routes/incidents');
  24: const logsRoutes = require('./routes/logs');
  25: const { startPriorityScheduler, stopPriorityScheduler } = require('./services/priority-scheduler');
  26:
  27: const app = express();
  28:
  29: const HOST = process.env.API_HOST || '127.0.0.1';
  30: const PORT = Number(process.env.API_PORT || 3100);
  31:
  32: const allowedOrigins = new Set(
  33:     (process.env.CORS_ORIGINS || '')
  34:         .split(',')
  35:         .map(value => value.trim())
  36:         .filter(Boolean)
  37: );
  38:
  39: app.disable('x-powered-by');
  40:
  41: app.use(pinoHttp({ logger }));
  42:
  43: app.use(helmet());
  44:
  45: app.use(cors({
  46:     origin: (origin, callback) => {
  47:         if (!origin || allowedOrigins.has(origin)) {
  48:             return callback(null, true);
  49:         }
  50:
  51:         return callback(null, false);
  52:     },
  53:     credentials: true,
  54:     methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
  55: }));
  56:
  57: app.use(express.json({ limit: '1mb' }));
  58: app.use(express.urlencoded({ extended: false, limit: '1mb' }));
  59:
  60: app.use(rateLimit({
  61:     windowMs: 15 * 60 * 1000,
  62:     limit: 300,
  63:     standardHeaders: 'draft-8',
  64:     legacyHeaders: false
  65: }));
  66:
  67: app.get('/', (req, res) => {
  68:     res.json({
  69:         name: 'Raven Control Center API',
  70:         version: '1.0.0',
  71:         status: 'running'
  72:     });
  73: });
  74:
  75: app.use('/api/health', healthRoutes);
  76: app.use('/api/auth', authRoutes);
  77: app.use('/api/players', playersRoutes);
  78: app.use('/api/priority', priorityRoutes);
  79: app.use('/api/audit', auditRoutes);
  80: app.use('/api/killfeed', killfeedRoutes);
  81: app.use('/api/incidents', incidentsRoutes);
  82: app.use('/api/logs', logsRoutes);
  83:
  84: app.use((req, res) => {
  85:     res.status(404).json({
  86:         error: 'ROUTE_NOT_FOUND'
  87:     });
  88: });
  89:
  90: app.use((error, req, res, next) => {
  91:     if (res.headersSent) {
  92:         return next(error);
  93:     }
  94:
  95:     req.log.error({ error }, 'Erro na requisicao');
  96:
  97:     res.status(error.status || 500).json({
  98:         error: 'INTERNAL_SERVER_ERROR',
  99:         message: 'Erro interno da API.'
 100:     });
 101: });
 102:
 103: let server;
 104:
 105: async function startServer() {
 106:     await pool.query('SELECT 1');
 107:     startPriorityScheduler();
 108:
 109:     server = app.listen(PORT, HOST, () => {
 110:         logger.info({
 111:             host: HOST,
 112:             port: PORT,
 113:             database: process.env.DB_NAME
 114:         }, 'Raven Control Center API iniciada');
 115:     });
 116:
 117:     server.on('error', (error) => {
 118:         logger.error({ error }, 'Falha no servidor HTTP');
 119:         process.exitCode = 1;
 120:     });
 121: }
 122:
 123: let shuttingDown = false;
 124:
 125: async function shutdown(signal) {
 126:     if (shuttingDown) return;
 127:     shuttingDown = true;
 128:
 129:     logger.info({ signal }, 'Encerramento seguro da API iniciado');
 130:
 131:     let shutdownError = null;
 132:
 133:     try {
 134:         await stopPriorityScheduler();
 135:     } catch (error) {
 136:         shutdownError = error;
 137:         logger.error({ error }, 'Falha ao aguardar o agendador');
 138:     }
 139:
 140:     if (server) {
 141:         try {
 142:             await new Promise((resolve, reject) => {
 143:                 server.close((error) => {
 144:                     if (error) reject(error);
 145:                     else resolve();
 146:                 });
 147:
 148:                 if (typeof server.closeIdleConnections === 'function') {
 149:                     server.closeIdleConnections();
 150:                 }
 151:             });
 152:         } catch (error) {
 153:             shutdownError = shutdownError || error;
 154:             logger.error({ error }, 'Falha ao encerrar servidor HTTP');
 155:         }
 156:     }
 157:
 158:     try {
 159:         await pool.end();
 160:     } catch (error) {
 161:         shutdownError = shutdownError || error;
 162:         logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
 163:     }
 164:
 165:     if (shutdownError) {
 166:         logger.error('API encerrada com erro durante o desligamento');
 167:         process.exitCode = 1;
 168:         return;
 169:     }
 170:
 171:     logger.info('API encerrada com seguranca');
 172:     process.exitCode = 0;
 173: }
 174:
 175: process.on('SIGINT', () => {
 176:     void shutdown('SIGINT');
 177: });
 178:
 179: process.on('SIGTERM', () => {
 180:     void shutdown('SIGTERM');
 181: });
 182:
 183: startServer().catch(async (error) => {
 184:     logger.fatal({ error }, 'Nao foi possivel iniciar a API');
 185:     await pool.end();
 186:     process.exit(1);
 187: });

==================================================
ARQUIVO: src/db.js
==================================================
   1: 'use strict';
   2:
   3: const { Pool } = require('pg');
   4: const logger = require('./logger');
   5:
   6: if (!process.env.DB_PASSWORD_B64) {
   7:     throw new Error('DB_PASSWORD_B64 nao configurado.');
   8: }
   9:
  10: const password = Buffer
  11:     .from(process.env.DB_PASSWORD_B64, 'base64')
  12:     .toString('utf8');
  13:
  14: const pool = new Pool({
  15:     host: process.env.DB_HOST,
  16:     port: Number(process.env.DB_PORT || 5432),
  17:     database: process.env.DB_NAME,
  18:     user: process.env.DB_USER,
  19:     password,
  20:     max: Number(process.env.DB_POOL_MAX || 5),
  21:     connectionTimeoutMillis: Number(
  22:         process.env.DB_CONNECTION_TIMEOUT || 5000
  23:     ),
  24:     idleTimeoutMillis: 10000,
  25:     application_name: 'raven-control-api',
  26:     ssl: false
  27: });
  28:
  29: pool.on('error', (error) => {
  30:     logger.error({ error }, 'Erro inesperado no pool PostgreSQL');
  31: });
  32:
  33: module.exports = { pool };

==================================================
ARQUIVO: src/killfeed-db.js
==================================================
   1: 'use strict';
   2:
   3: const fs = require('node:fs');
   4: const path = require('node:path');
   5: const os = require('node:os');
   6: const { Pool } = require('pg');
   7: const logger = require('./logger');
   8:
   9: const secretPath = process.env.KILLFEED_READER_SECRET_FILE ||
  10:     path.join(
  11:         process.env.LOCALAPPDATA || os.homedir(),
  12:         'RavenControlCenter',
  13:         'killfeed-reader-secret.b64'
  14:     );
  15:
  16: if (!fs.existsSync(secretPath)) {
  17:     throw new Error('Credencial protegida do KillFeed nao encontrada.');
  18: }
  19:
  20: const encodedPassword = fs.readFileSync(secretPath, 'utf8').trim();
  21: const password = Buffer.from(encodedPassword, 'base64').toString('utf8');
  22:
  23: if (!password) {
  24:     throw new Error('Credencial do KillFeed esta vazia.');
  25: }
  26:
  27: const killfeedPool = new Pool({
  28:     host: process.env.KILLFEED_DB_HOST || '127.0.0.1',
  29:     port: Number(process.env.KILLFEED_DB_PORT || 5432),
  30:     database: process.env.KILLFEED_DB_NAME || 'dayz_killfeed',
  31:     user: process.env.KILLFEED_DB_USER || 'raven_killfeed_reader',
  32:     password,
  33:     max: 2,
  34:     connectionTimeoutMillis: 5000,
  35:     idleTimeoutMillis: 10000,
  36:     application_name: 'raven-killfeed-readonly-api',
  37:     ssl: false,
  38:     allowExitOnIdle: true
  39: });
  40:
  41: killfeedPool.on('error', error => {
  42:     logger.error({ code: error.code }, 'Erro inesperado no pool read-only do KillFeed');
  43: });
  44:
  45: module.exports = { killfeedPool };

==================================================
ARQUIVO: src/routes/health.js
==================================================
   1: 'use strict';
   2:
   3: const express = require('express');
   4: const { pool } = require('../db');
   5: const { killfeedPool } = require('../killfeed-db');
   6: const { recordHealthSnapshot } = require('../services/incident-monitor');
   7:
   8: const router = express.Router();
   9:
  10: async function checkDatabase(databasePool, req, label) {
  11:     const start = process.hrtime.bigint();
  12:
  13:     try {
  14:         await databasePool.query('SELECT 1 AS result');
  15:
  16:         const latencyMs = Number(
  17:             process.hrtime.bigint() - start
  18:         ) / 1_000_000;
  19:
  20:         return {
  21:             status: 'connected',
  22:             latencyMs: Number(latencyMs.toFixed(2))
  23:         };
  24:     } catch (error) {
  25:         req.log.error(
  26:             { code: error.code, component: label },
  27:             'Health check de banco falhou'
  28:         );
  29:
  30:         return {
  31:             status: 'disconnected'
  32:         };
  33:     }
  34: }
  35:
  36: router.get('/', async (req, res) => {
  37:     const [primaryDatabase, killfeedDatabase] = await Promise.all([
  38:         checkDatabase(pool, req, 'postgresql'),
  39:         checkDatabase(killfeedPool, req, 'killfeed')
  40:     ]);
  41:
  42:     const primaryConnected = primaryDatabase.status === 'connected';
  43:     const killfeedConnected = killfeedDatabase.status === 'connected';
  44:
  45:     await recordHealthSnapshot({
  46:         primary: primaryDatabase.status,
  47:         killfeed: killfeedDatabase.status
  48:     }, req.log);
  49:
  50:     const status = !primaryConnected
  51:         ? 'degraded'
  52:         : killfeedConnected
  53:             ? 'ok'
  54:             : 'degraded';
  55:
  56:     const memory = process.memoryUsage();
  57:
  58:     const response = {
  59:         status,
  60:         service: 'raven-control-api',
  61:         timestamp: new Date().toISOString(),
  62:         uptimeSeconds: Math.floor(process.uptime()),
  63:         process: {
  64:             memory: {
  65:                 rssMb: Number((memory.rss / 1024 / 1024).toFixed(2)),
  66:                 heapUsedMb: Number((memory.heapUsed / 1024 / 1024).toFixed(2)),
  67:                 heapTotalMb: Number((memory.heapTotal / 1024 / 1024).toFixed(2))
  68:             }
  69:         },
  70:         databases: {
  71:             primary: primaryDatabase,
  72:             killfeed: killfeedDatabase
  73:         }
  74:     };
  75:
  76:     if (!primaryConnected) {
  77:         return res.status(503).json(response);
  78:     }
  79:
  80:     return res.status(200).json(response);
  81: });
  82:
  83: router.get('/live', (req, res) => {
  84:     return res.status(200).json({
  85:         status: 'alive',
  86:         service: 'raven-control-api',
  87:         timestamp: new Date().toISOString(),
  88:         uptimeSeconds: Math.floor(process.uptime())
  89:     });
  90: });
  91:
  92: module.exports = router;

==================================================
ARQUIVO: src/routes/killfeed.js
==================================================
   1: 'use strict';
   2:
   3: const express = require('express');
   4: const { z } = require('zod');
   5: const { killfeedPool } = require('../killfeed-db');
   6: const requireAuth = require('../middleware/require-auth');
   7:
   8: const router = express.Router();
   9: router.use(requireAuth);
  10:
  11: const querySchema = z.object({
  12:     search: z.string().trim().max(64).optional(),
  13:     page: z.coerce.number().int().min(1).max(100000).default(1),
  14:     limit: z.coerce.number().int().min(1).max(100).default(50)
  15: }).strict();
  16:
  17: router.get('/', async (req, res) => {
  18:     const parsed = querySchema.safeParse(req.query);
  19:
  20:     if (!parsed.success) {
  21:         return res.status(400).json({ error: 'INVALID_KILLFEED_QUERY' });
  22:     }
  23:
  24:     const { search, page, limit } = parsed.data;
  25:     const offset = (page - 1) * limit;
  26:
  27:     try {
  28:         const values = [];
  29:         let where = '';
  30:
  31:         if (search) {
  32:             values.push(`%${search}%`);
  33:             where = 'WHERE (killer_name ILIKE $1 OR victim_name ILIKE $1 OR weapon ILIKE $1)';
  34:         }
  35:
  36:         const count = await killfeedPool.query(
  37:             `SELECT COUNT(*)::integer AS total
  38:              FROM public.pvp_kills ${where}`,
  39:             values
  40:         );
  41:
  42:         const result = await killfeedPool.query(
  43:             `SELECT id::text, occurred_at, killer_name, victim_name, weapon, distance_m
  44:              FROM public.pvp_kills
  45:              ${where}
  46:              ORDER BY occurred_at DESC, id DESC
  47:              LIMIT $${values.length + 1}
  48:              OFFSET $${values.length + 2}`,
  49:             [...values, limit, offset]
  50:         );
  51:
  52:         return res.json({
  53:             page,
  54:             limit,
  55:             total: count.rows[0].total,
  56:             kills: result.rows
  57:         });
  58:     } catch (error) {
  59:         req.log.error({ code: error.code }, 'Falha ao consultar historico KillFeed');
  60:         return res.status(503).json({ error: 'KILLFEED_DATABASE_UNAVAILABLE' });
  61:     }
  62: });
  63:
  64: module.exports = router;

==================================================
ARQUIVO: src/routes/players.js
==================================================
   1: 'use strict';
   2:
   3: const express = require('express');
   4: const { z } = require('zod');
   5:
   6: const { pool } = require('../db');
   7: const { withTransaction } = require('../services/transaction');
   8: const { writeAudit } = require('../services/audit');
   9: const requireAuth = require('../middleware/require-auth');
  10: const requireRole = require('../middleware/require-role');
  11:
  12: const router = express.Router();
  13:
  14: router.use(requireAuth);
  15:
  16: const listSchema = z.object({
  17:     search: z.string().trim().max(64).optional(),
  18:     page: z.coerce.number().int().min(1).max(100000).default(1),
  19:     limit: z.coerce.number().int().min(1).max(100).default(25)
  20: }).strict();
  21:
  22: const createSchema = z.object({
  23:     steam64: z.string().regex(/^[0-9]{17}$/),
  24:     displayName: z.string().trim().min(1).max(64).nullable().optional()
  25: }).strict();
  26:
  27: router.get('/', async (req, res) => {
  28:     const parsed = listSchema.safeParse(req.query);
  29:
  30:     if (!parsed.success) {
  31:         return res.status(400).json({ error: 'INVALID_QUERY' });
  32:     }
  33:
  34:     const { search, page, limit } = parsed.data;
  35:     const offset = (page - 1) * limit;
  36:
  37:     try {
  38:         const values = [];
  39:         let where = '';
  40:
  41:         if (search) {
  42:             values.push(search, `%${search}%`);
  43:             where = 'WHERE (steam64 = $1 OR display_name ILIKE $2)';
  44:         }
  45:
  46:         const count = await pool.query(
  47:             `SELECT COUNT(*)::integer AS total
  48:              FROM public.players ${where}`,
  49:             values
  50:         );
  51:
  52:         const paginationValues = [...values, limit, offset];
  53:         const limitPosition = values.length + 1;
  54:         const offsetPosition = values.length + 2;
  55:
  56:         const result = await pool.query(
  57:             `SELECT id::text, steam64, display_name,
  58:                     first_seen_at, last_seen_at, created_at, updated_at
  59:              FROM public.players
  60:              ${where}
  61:              ORDER BY created_at DESC
  62:              LIMIT $${limitPosition} OFFSET $${offsetPosition}`,
  63:             paginationValues
  64:         );
  65:
  66:         return res.json({
  67:             page,
  68:             limit,
  69:             total: count.rows[0].total,
  70:             players: result.rows
  71:         });
  72:     } catch (error) {
  73:         req.log.error({ error }, 'Falha ao listar jogadores');
  74:
  75:         return res.status(500).json({
  76:             error: 'PLAYER_LIST_ERROR'
  77:         });
  78:     }
  79: });
  80:
  81: router.post(
  82:     '/',
  83:     requireRole('owner', 'admin', 'moderator'),
  84:     async (req, res) => {
  85:         const parsed = createSchema.safeParse(req.body);
  86:
  87:         if (!parsed.success) {
  88:             return res.status(400).json({
  89:                 error: 'INVALID_PLAYER_DATA',
  90:                 details: parsed.error.issues.map(issue => ({
  91:                     field: issue.path.join('.'),
  92:                     message: issue.message
  93:                 }))
  94:             });
  95:         }
  96:
  97:         const { steam64, displayName } = parsed.data;
  98:
  99:         try {
 100:             const player = await withTransaction(async client => {
 101:                 const result = await client.query(
 102:                     `INSERT INTO public.players
 103:                         (steam64, display_name)
 104:                      VALUES ($1, $2)
 105:                      RETURNING id::text, steam64, display_name, created_at`,
 106:                     [steam64, displayName || null]
 107:                 );
 108:
 109:                 const created = result.rows[0];
 110:
 111:                 await writeAudit(client, {
 112:                     actorType: 'admin',
 113:                     actorIdentifier: req.admin.username,
 114:                     actorAdminId: req.admin.id,
 115:                     action: 'player.created',
 116:                     entityType: 'player',
 117:                     entityId: created.id,
 118:                     details: {
 119:                         steam64,
 120:                         displayName: displayName || null
 121:                     },
 122:                     sourceIp: req.ip
 123:                 });
 124:
 125:                 return created;
 126:             });
 127:
 128:             return res.status(201).json({ player });
 129:         } catch (error) {
 130:             if (error.code === '23505') {
 131:                 return res.status(409).json({
 132:                     error: 'PLAYER_ALREADY_EXISTS'
 133:                 });
 134:             }
 135:
 136:             req.log.error({ error }, 'Falha ao cadastrar jogador');
 137:
 138:             return res.status(500).json({
 139:                 error: 'PLAYER_CREATE_ERROR'
 140:             });
 141:         }
 142:     }
 143: );
 144:
 145: module.exports = router;

==================================================
ARQUIVO: src/routes/logs.js
==================================================
   1: 'use strict';
   2:
   3: const express = require('express');
   4: const fs = require('fs');
   5: const path = require('path');
   6: const { z } = require('zod');
   7:
   8: const requireAuth = require('../middleware/require-auth');
   9: const requireRole = require('../middleware/require-role');
  10:
  11: const router = express.Router();
  12:
  13: const logDir = path.resolve(__dirname, '..', '..', 'logs');
  14:
  15: const MAX_FILES = 100;
  16: const MAX_SCAN_BYTES = 100 * 1024 * 1024;
  17: const MAX_LINE_LENGTH = 1024 * 1024;
  18:
  19: router.use(requireAuth);
  20: router.use(requireRole('owner', 'admin'));
  21:
  22: const querySchema = z.object({
  23:     level: z.enum([
  24:         'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  25:     ]).optional(),
  26:
  27:     component: z.string().trim().max(80).optional(),
  28:     search: z.string().trim().max(200).optional(),
  29:
  30:     from: z.string().datetime({ offset: true }).optional(),
  31:     to: z.string().datetime({ offset: true }).optional(),
  32:
  33:     page: z.coerce.number().int().min(1).max(100000).default(1),
  34:     limit: z.coerce.number().int().min(1).max(100).default(50)
  35: }).strict().superRefine((value, context) => {
  36:     if (
  37:         value.from &&
  38:         value.to &&
  39:         new Date(value.from) > new Date(value.to)
  40:     ) {
  41:         context.addIssue({
  42:             code: 'custom',
  43:             path: ['from'],
  44:             message: 'FROM_AFTER_TO'
  45:         });
  46:     }
  47: });
  48:
  49: const levelNames = {
  50:     10: 'trace',
  51:     20: 'debug',
  52:     30: 'info',
  53:     40: 'warn',
  54:     50: 'error',
  55:     60: 'fatal'
  56: };
  57:
  58: function normalizeLevel(value) {
  59:     if (typeof value === 'string') {
  60:         const normalized = value.toLowerCase();
  61:
  62:         if ([
  63:             'trace', 'debug', 'info',
  64:             'warn', 'error', 'fatal'
  65:         ].includes(normalized)) {
  66:             return normalized;
  67:         }
  68:
  69:         if (/^\d+$/.test(value)) {
  70:             return levelNames[Number(value)] || 'unknown';
  71:         }
  72:     }
  73:
  74:     if (typeof value === 'number') {
  75:         return levelNames[value] || 'unknown';
  76:     }
  77:
  78:     return 'unknown';
  79: }
  80:
  81: function redactValue(value, key = '') {
  82:     const sensitiveKey =
  83:         /(authorization|cookie|password|passwd|token|secret|api.?key|DB_PASSWORD_B64)/i;
  84:
  85:     if (sensitiveKey.test(key)) {
  86:         return '[REDACTED]';
  87:     }
  88:
  89:     if (Array.isArray(value)) {
  90:         return value.map(item => redactValue(item));
  91:     }
  92:
  93:     if (value && typeof value === 'object') {
  94:         const output = {};
  95:
  96:         for (const [childKey, childValue] of Object.entries(value)) {
  97:             output[childKey] = redactValue(childValue, childKey);
  98:         }
  99:
 100:         return output;
 101:     }
 102:
 103:     if (typeof value === 'string') {
 104:         return value
 105:             .replace(
 106:                 /(Bearer\s+)[A-Za-z0-9._~+/-]+=*/gi,
 107:                 '$1[REDACTED]'
 108:             )
 109:             .replace(
 110:                 /((?:password|passwd|token|secret|api[_-]?key)\s*[:=]\s*)[^,\s;]+/gi,
 111:                 '$1[REDACTED]'
 112:             );
 113:     }
 114:
 115:     return value;
 116: }
 117:
 118: function getLogTimestamp(entry) {
 119:     const value = entry.time || entry.timestamp || entry.datetime;
 120:     const timestamp = typeof value === 'number'
 121:         ? value
 122:         : Date.parse(value);
 123:
 124:     if (!Number.isFinite(timestamp)) {
 125:         return null;
 126:     }
 127:
 128:     return timestamp;
 129: }
 130:
 131: function getComponent(entry) {
 132:     return String(
 133:         entry.component ||
 134:         entry.name ||
 135:         entry.event ||
 136:         'general'
 137:     );
 138: }
 139:
 140: function matchesFilters(entry, filters) {
 141:     const level = normalizeLevel(entry.level);
 142:     const component = getComponent(entry);
 143:     const message = String(entry.msg || entry.message || '');
 144:
 145:     if (filters.level && level !== filters.level) {
 146:         return false;
 147:     }
 148:
 149:     if (
 150:         filters.component &&
 151:         !component.toLowerCase().includes(filters.component.toLowerCase())
 152:     ) {
 153:         return false;
 154:     }
 155:
 156:     if (
 157:         filters.search &&
 158:         !JSON.stringify(entry)
 159:             .toLowerCase()
 160:             .includes(filters.search.toLowerCase())
 161:     ) {
 162:         return false;
 163:     }
 164:
 165:     const timestamp = getLogTimestamp(entry);
 166:
 167:     if (filters.from) {
 168:         if (timestamp === null || timestamp < Date.parse(filters.from)) {
 169:             return false;
 170:         }
 171:     }
 172:
 173:     if (filters.to) {
 174:         if (timestamp === null || timestamp > Date.parse(filters.to)) {
 175:             return false;
 176:         }
 177:     }
 178:
 179:     return true;
 180: }
 181:
 182: function publicEntry(entry) {
 183:     const safe = redactValue(entry);
 184:
 185:     return {
 186:         time: safe.time || safe.timestamp || safe.datetime || null,
 187:         level: normalizeLevel(safe.level),
 188:         component: getComponent(safe),
 189:         message: String(safe.msg || safe.message || ''),
 190:         pid: safe.pid ?? null,
 191:         hostname: safe.hostname ?? null,
 192:         event: safe.event ?? null,
 193:         details: safe
 194:     };
 195: }
 196:
 197: router.get('/', async (req, res) => {
 198:     const parsed = querySchema.safeParse(req.query);
 199:
 200:     if (!parsed.success) {
 201:         return res.status(400).json({
 202:             error: 'INVALID_LOG_QUERY'
 203:         });
 204:     }
 205:
 206:     const filters = parsed.data;
 207:     const { page, limit } = filters;
 208:
 209:     try {
 210:         if (!fs.existsSync(logDir)) {
 211:             return res.json({
 212:                 page,
 213:                 limit,
 214:                 total: 0,
 215:                 logs: [],
 216:                 filesScanned: 0
 217:             });
 218:         }
 219:
 220:         const pattern = /^api-\d{4}-\d{2}-\d{2}-\d{3}\.log$/;
 221:
 222:         let files = fs.readdirSync(logDir, { withFileTypes: true })
 223:             .filter(item => item.isFile() && pattern.test(item.name))
 224:             .map(item => item.name)
 225:             .sort()
 226:             .reverse();
 227:
 228:         if (filters.from || filters.to) {
 229:             const lower = filters.from
 230:                 ? Date.parse(filters.from)
 231:                 : -Infinity;
 232:
 233:             const upper = filters.to
 234:                 ? Date.parse(filters.to)
 235:                 : Infinity;
 236:
 237:             files = files.filter(name => {
 238:                 const match = name.match(/^api-(\d{4}-\d{2}-\d{2})-/);
 239:
 240:                 if (!match) return false;
 241:
 242:                 const dayStart = Date.parse(`${match[1]}T00:00:00.000Z`);
 243:                 const dayEnd = dayStart + 86400000 - 1;
 244:
 245:                 return dayEnd >= lower && dayStart <= upper;
 246:             });
 247:         }
 248:
 249:         if (files.length > MAX_FILES) {
 250:             return res.status(413).json({
 251:                 error: 'LOG_FILE_LIMIT_EXCEEDED',
 252:                 message: 'Reduza o periodo da consulta.'
 253:             });
 254:         }
 255:
 256:         const selected = [];
 257:         let total = 0;
 258:         let scannedBytes = 0;
 259:         let filesScanned = 0;
 260:
 261:         const offset = (page - 1) * limit;
 262:         const end = offset + limit;
 263:
 264:         for (const filename of files) {
 265:             const fullPath = path.join(logDir, filename);
 266:             const stat = fs.statSync(fullPath);
 267:
 268:             if (!stat.isFile()) continue;
 269:
 270:             scannedBytes += stat.size;
 271:
 272:             if (scannedBytes > MAX_SCAN_BYTES) {
 273:                 return res.status(413).json({
 274:                     error: 'LOG_SCAN_LIMIT_EXCEEDED',
 275:                     message: 'Reduza o periodo ou os filtros da consulta.'
 276:                 });
 277:             }
 278:
 279:             const content = await fs.promises.readFile(fullPath, 'utf8');
 280:             const lines = content.split(/\r?\n/);
 281:
 282:             filesScanned++;
 283:
 284:             for (let index = lines.length - 1; index >= 0; index--) {
 285:                 const line = lines[index];
 286:
 287:                 if (!line || line.length > MAX_LINE_LENGTH) continue;
 288:
 289:                 let entry;
 290:
 291:                 try {
 292:                     entry = JSON.parse(line);
 293:                 } catch {
 294:                     continue;
 295:                 }
 296:
 297:                 if (!matchesFilters(entry, filters)) continue;
 298:
 299:                 if (total >= offset && total < end) {
 300:                     selected.push(publicEntry(entry));
 301:                 }
 302:
 303:                 total++;
 304:             }
 305:         }
 306:
 307:         return res.json({
 308:             page,
 309:             limit,
 310:             total,
 311:             logs: selected,
 312:             filesScanned
 313:         });
 314:
 315:     } catch (error) {
 316:         req.log.error(
 317:             { code: error.code },
 318:             'Falha ao consultar arquivos de log'
 319:         );
 320:
 321:         return res.status(500).json({
 322:             error: 'LOG_QUERY_ERROR'
 323:         });
 324:     }
 325: });
 326:
 327: module.exports = router;

==================================================
ARQUIVO: src/middleware/require-auth.js
==================================================
   1: 'use strict';
   2:
   3: const { verifyAccessToken } = require('../services/auth');
   4: const { pool } = require('../db');
   5:
   6: async function requireAuth(req, res, next) {
   7:     const authorization = req.get('authorization') || '';
   8:     const match = authorization.match(/^Bearer\s+(.+)$/i);
   9:
  10:     if (!match) {
  11:         return res.status(401).json({
  12:             error: 'AUTHENTICATION_REQUIRED'
  13:         });
  14:     }
  15:
  16:     try {
  17:         const payload = await verifyAccessToken(match[1]);
  18:         const adminId = Number(payload.sub);
  19:
  20:         if (!Number.isSafeInteger(adminId) || adminId <= 0) {
  21:             return res.status(401).json({
  22:                 error: 'INVALID_TOKEN_SUBJECT'
  23:             });
  24:         }
  25:
  26:         const result = await pool.query(
  27:             `SELECT id, username, access_role, is_active
  28:              FROM public.admin_users
  29:              WHERE id = $1`,
  30:             [adminId]
  31:         );
  32:
  33:         const admin = result.rows[0];
  34:
  35:         if (!admin || !admin.is_active) {
  36:             return res.status(401).json({
  37:                 error: 'ADMIN_INACTIVE'
  38:             });
  39:         }
  40:
  41:         req.admin = {
  42:             id: admin.id,
  43:             username: admin.username,
  44:             role: admin.access_role
  45:         };
  46:
  47:         return next();
  48:
  49:     } catch (error) {
  50:         if (
  51:             error.code === 'ECONNREFUSED' ||
  52:             error.code === '57P01'
  53:         ) {
  54:             req.log.error({ error }, 'PostgreSQL indisponivel');
  55:
  56:             return res.status(503).json({
  57:                 error: 'AUTHENTICATION_SERVICE_UNAVAILABLE'
  58:             });
  59:         }
  60:
  61:         if (error.name === 'JWTExpired') {
  62:             return res.status(401).json({
  63:                 error: 'TOKEN_EXPIRED'
  64:             });
  65:         }
  66:
  67:         if (
  68:             error.code === 'ERR_JWS_INVALID' ||
  69:             error.code === 'ERR_JWT_INVALID' ||
  70:             error.code === 'ERR_JWT_EXPIRED' ||
  71:             error.code === 'ERR_JWS_SIGNATURE_VERIFICATION_FAILED'
  72:         ) {
  73:             return res.status(401).json({
  74:                 error: 'INVALID_OR_EXPIRED_TOKEN'
  75:             });
  76:         }
  77:
  78:         req.log.error({ error }, 'Falha na autenticacao');
  79:
  80:         return res.status(500).json({
  81:             error: 'AUTHENTICATION_ERROR'
  82:         });
  83:     }
  84: }
  85:
  86: module.exports = requireAuth;

==================================================
ARQUIVO: src/services/migrate.js
==================================================
   1: 'use strict';
   2:
   3: const fs = require('fs');
   4: const path = require('path');
   5: const crypto = require('crypto');
   6:
   7: require('dotenv').config({
   8:     path: path.resolve(__dirname, '..', '..', '.env')
   9: });
  10:
  11: const logger = require('../logger');
  12: const { pool } = require('../db');
  13:
  14: const MIGRATIONS_DIR = path.resolve(__dirname, '..', '..', 'migrations');
  15:
  16: async function main() {
  17:     let client;
  18:     let lockAcquired = false;
  19:
  20:     try {
  21:         client = await pool.connect();
  22:
  23:         await client.query(
  24:             'SELECT pg_advisory_lock($1::integer, $2::integer)',
  25:             [741923, 1]
  26:         );
  27:
  28:         lockAcquired = true;
  29:
  30:         await client.query(`
  31:             CREATE TABLE IF NOT EXISTS public.schema_migrations (
  32:                 version VARCHAR(20) PRIMARY KEY,
  33:                 name VARCHAR(255) NOT NULL,
  34:                 checksum VARCHAR(64) NOT NULL,
  35:                 execution_ms INTEGER NOT NULL DEFAULT 0,
  36:                 applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  37:             )
  38:         `);
  39:
  40:         const files = fs.readdirSync(MIGRATIONS_DIR)
  41:             .filter(file => /^\d+_.+\.sql$/i.test(file))
  42:             .sort();
  43:
  44:         if (files.length === 0) {
  45:             throw new Error('Nenhuma migration encontrada.');
  46:         }
  47:
  48:         let applied = 0;
  49:
  50:         for (const file of files) {
  51:             const version = file.match(/^(\d+)_/)[1];
  52:
  53:             const sql = fs.readFileSync(
  54:                 path.join(MIGRATIONS_DIR, file),
  55:                 'utf8'
  56:             );
  57:
  58:             const checksum = crypto
  59:                 .createHash('sha256')
  60:                 .update(sql)
  61:                 .digest('hex');
  62:
  63:             const existing = await client.query(
  64:                 'SELECT checksum FROM public.schema_migrations WHERE version = $1',
  65:                 [version]
  66:             );
  67:
  68:             if (existing.rowCount > 0) {
  69:                 if (existing.rows[0].checksum !== checksum) {
  70:                     throw new Error(`Checksum divergente: ${file}`);
  71:                 }
  72:
  73:                 logger.info({ version, file }, 'Migration ja aplicada');
  74:                 continue;
  75:             }
  76:
  77:             const startedAt = Date.now();
  78:
  79:             await client.query('BEGIN');
  80:
  81:             try {
  82:                 await client.query(sql);
  83:
  84:                 const executionMs = Date.now() - startedAt;
  85:
  86:                 await client.query(
  87:                     `INSERT INTO public.schema_migrations
  88:                     (version, name, checksum, execution_ms)
  89:                     VALUES ($1, $2, $3, $4)`,
  90:                     [version, file, checksum, executionMs]
  91:                 );
  92:
  93:                 await client.query('COMMIT');
  94:
  95:                 applied++;
  96:
  97:                 logger.info(
  98:                     { version, file, executionMs },
  99:                     'Migration aplicada'
 100:                 );
 101:             } catch (error) {
 102:                 await client.query('ROLLBACK');
 103:                 throw error;
 104:             }
 105:         }
 106:
 107:         logger.info(
 108:             { applied, total: files.length },
 109:             'Migrations concluidas'
 110:         );
 111:     } finally {
 112:         if (client) {
 113:             if (lockAcquired) {
 114:                 await client.query(
 115:                     'SELECT pg_advisory_unlock($1::integer, $2::integer)',
 116:                     [741923, 1]
 117:                 );
 118:             }
 119:
 120:             client.release();
 121:         }
 122:
 123:         await pool.end();
 124:     }
 125: }
 126:
 127: main().catch(error => {
 128:     logger.fatal({ error }, 'Falha nas migrations');
 129:     process.exitCode = 1;
 130: });

[3] MIGRACOES POSTGRESQL

==================================================
ARQUIVO: migrations\001_initial_schema.sql
==================================================
   1: CREATE TABLE public.players (
   2:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   3:     steam64 VARCHAR(17) NOT NULL UNIQUE
   4:         CHECK (steam64 ~ '^[0-9]{17}$'),
   5:     display_name VARCHAR(64),
   6:     first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   7:     last_seen_at TIMESTAMPTZ,
   8:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   9:     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  10: );
  11:
  12: CREATE TABLE public.admin_users (
  13:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  14:     username VARCHAR(64) NOT NULL UNIQUE,
  15:     password_hash VARCHAR(255) NOT NULL,
  16:     access_role VARCHAR(20) NOT NULL DEFAULT 'admin'
  17:         CHECK (access_role IN ('owner','admin','moderator','viewer')),
  18:     is_active BOOLEAN NOT NULL DEFAULT TRUE,
  19:     last_login_at TIMESTAMPTZ,
  20:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  21:     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  22: );
  23:
  24: CREATE TABLE public.priority_categories (
  25:     id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  26:     code VARCHAR(32) NOT NULL UNIQUE,
  27:     name VARCHAR(80) NOT NULL,
  28:     description TEXT,
  29:     display_order SMALLINT NOT NULL DEFAULT 0,
  30:     is_active BOOLEAN NOT NULL DEFAULT TRUE,
  31:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  32:     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  33: );
  34:
  35: CREATE TABLE public.priority_grants (
  36:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  37:     player_id BIGINT NOT NULL REFERENCES public.players(id),
  38:     category_id SMALLINT NOT NULL REFERENCES public.priority_categories(id),
  39:     status VARCHAR(20) NOT NULL DEFAULT 'active'
  40:         CHECK (status IN ('scheduled','active','revoked','expired')),
  41:     grant_source VARCHAR(20) NOT NULL DEFAULT 'web'
  42:         CHECK (grant_source IN ('web','discord','system')),
  43:     reason TEXT,
  44:     starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  45:     expires_at TIMESTAMPTZ,
  46:     granted_by_admin_id BIGINT REFERENCES public.admin_users(id),
  47:     revoked_by_admin_id BIGINT REFERENCES public.admin_users(id),
  48:     revoked_at TIMESTAMPTZ,
  49:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  50:     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  51:     CHECK (expires_at IS NULL OR expires_at > starts_at)
  52: );
  53:
  54: CREATE TABLE public.discord_accounts (
  55:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  56:     player_id BIGINT NOT NULL UNIQUE REFERENCES public.players(id),
  57:     discord_user_id VARCHAR(20) NOT NULL UNIQUE
  58:         CHECK (discord_user_id ~ '^[0-9]{17,20}$'),
  59:     discord_username VARCHAR(100),
  60:     verified_at TIMESTAMPTZ,
  61:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  62: );
  63:
  64: CREATE TABLE public.audit_logs (
  65:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  66:     actor_type VARCHAR(20) NOT NULL
  67:         CHECK (actor_type IN ('admin','discord','system')),
  68:     actor_identifier VARCHAR(100),
  69:     actor_admin_id BIGINT REFERENCES public.admin_users(id) ON DELETE SET NULL,
  70:     action VARCHAR(100) NOT NULL,
  71:     entity_type VARCHAR(60),
  72:     entity_id VARCHAR(100),
  73:     details JSONB NOT NULL DEFAULT '{}'::JSONB,
  74:     source_ip INET,
  75:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  76: );
  77:
  78: CREATE TABLE public.system_settings (
  79:     setting_key VARCHAR(100) PRIMARY KEY,
  80:     setting_value JSONB NOT NULL,
  81:     description TEXT,
  82:     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  83: );
  84:
  85: CREATE TABLE public.queue_sync_runs (
  86:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  87:     status VARCHAR(20) NOT NULL
  88:         CHECK (status IN ('running','success','failed')),
  89:     players_count INTEGER NOT NULL DEFAULT 0
  90:         CHECK (players_count >= 0),
  91:     file_checksum VARCHAR(64),
  92:     target_path TEXT,
  93:     error_message TEXT,
  94:     started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  95:     finished_at TIMESTAMPTZ
  96: );
  97:
  98: CREATE INDEX idx_priority_grants_player
  99:     ON public.priority_grants(player_id);
 100:
 101: CREATE INDEX idx_priority_grants_category
 102:     ON public.priority_grants(category_id);
 103:
 104: CREATE INDEX idx_priority_grants_status_expiration
 105:     ON public.priority_grants(status, expires_at);
 106:
 107: CREATE INDEX idx_audit_logs_created
 108:     ON public.audit_logs(created_at DESC);
 109:
 110: CREATE INDEX idx_audit_logs_entity
 111:     ON public.audit_logs(entity_type, entity_id);
 112:
 113: CREATE INDEX idx_queue_sync_runs_started
 114:     ON public.queue_sync_runs(started_at DESC);
 115:
 116: CREATE OR REPLACE FUNCTION public.set_updated_at()
 117: RETURNS TRIGGER
 118: LANGUAGE plpgsql
 119: AS $$
 120: BEGIN
 121:     NEW.updated_at = NOW();
 122:     RETURN NEW;
 123: END;
 124: $$;
 125:
 126: CREATE TRIGGER trg_players_updated_at
 127: BEFORE UPDATE ON public.players
 128: FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
 129:
 130: CREATE TRIGGER trg_admin_users_updated_at
 131: BEFORE UPDATE ON public.admin_users
 132: FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
 133:
 134: CREATE TRIGGER trg_priority_categories_updated_at
 135: BEFORE UPDATE ON public.priority_categories
 136: FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
 137:
 138: CREATE TRIGGER trg_priority_grants_updated_at
 139: BEFORE UPDATE ON public.priority_grants
 140: FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
 141:
 142: CREATE TRIGGER trg_system_settings_updated_at
 143: BEFORE UPDATE ON public.system_settings
 144: FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
 145:
 146: INSERT INTO public.priority_categories
 147:     (code, name, description, display_order)
 148: VALUES
 149:     ('staff', 'Staff', 'Equipe administrativa do Raven RP', 1),
 150:     ('supporters', 'Apoiadores', 'Apoiadores da comunidade', 2),
 151:     ('events', 'Eventos', 'Vencedores e convidados de eventos', 3),
 152:     ('creators', 'Criadores', 'Criadores de conteudo e parceiros', 4);

==================================================
ARQUIVO: migrations\002_priority_integrity.sql
==================================================
   1: -- Corrigir concessoes cuja validade ja terminou
   2: UPDATE public.priority_grants
   3: SET status = 'expired',
   4:     updated_at = NOW()
   5: WHERE status IN ('active', 'scheduled')
   6:   AND expires_at IS NOT NULL
   7:   AND expires_at <= NOW();
   8:
   9: -- Uma concessao aberta por jogador e categoria.
  10: -- O mesmo jogador pode possuir categorias diferentes.
  11: CREATE UNIQUE INDEX uq_priority_grants_player_category_open
  12: ON public.priority_grants (player_id, category_id)
  13: WHERE status IN ('active', 'scheduled');
  14:
  15: -- Pesquisa de jogadores por nome
  16: CREATE INDEX idx_players_display_name_lower
  17: ON public.players (LOWER(display_name))
  18: WHERE display_name IS NOT NULL;
  19:
  20: -- Pesquisa de concessoes por validade
  21: CREATE INDEX idx_priority_grants_expiration
  22: ON public.priority_grants (expires_at)
  23: WHERE status IN ('active', 'scheduled')
  24:   AND expires_at IS NOT NULL;
  25:
  26: -- Pesquisa de auditoria por administrador
  27: CREATE INDEX idx_audit_logs_actor_admin
  28: ON public.audit_logs (actor_admin_id, created_at DESC)
  29: WHERE actor_admin_id IS NOT NULL;

==================================================
ARQUIVO: migrations\003_system_incidents.sql
==================================================
   1: CREATE TABLE public.system_incidents (
   2:     id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   3:     component VARCHAR(32) NOT NULL
   4:         CHECK (component IN ('postgresql', 'killfeed')),
   5:     severity VARCHAR(16) NOT NULL
   6:         CHECK (severity IN ('warning', 'critical')),
   7:     details JSONB NOT NULL DEFAULT '{}'::JSONB,
   8:     started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
   9:     resolved_at TIMESTAMPTZ,
  10:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  11:     CHECK (resolved_at IS NULL OR resolved_at >= started_at)
  12: );
  13:
  14: CREATE UNIQUE INDEX uq_system_incidents_open_component
  15: ON public.system_incidents (component)
  16: WHERE resolved_at IS NULL;
  17:
  18: CREATE INDEX idx_system_incidents_started
  19: ON public.system_incidents (started_at DESC);
  20:
  21: CREATE INDEX idx_system_incidents_resolved
  22: ON public.system_incidents (resolved_at DESC)
  23: WHERE resolved_at IS NOT NULL;

[4] SCHEMA DO KILLFEED SEPARADO
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

[5] NOMES DAS VARIAVEIS DE AMBIENTE

Arquivo: .env
NODE_ENV=[VALOR OCULTO]
API_HOST=[VALOR OCULTO]
API_PORT=[VALOR OCULTO]
LOG_LEVEL=[VALOR OCULTO]
DB_HOST=[VALOR OCULTO]
DB_PORT=[VALOR OCULTO]
DB_NAME=[VALOR OCULTO]
DB_USER=[VALOR OCULTO]
DB_PASSWORD_B64=[VALOR OCULTO]
DB_POOL_MAX=[VALOR OCULTO]
DB_CONNECTION_TIMEOUT=[VALOR OCULTO]
CORS_ORIGINS=[VALOR OCULTO]
AUTH_JWT_SECRET_B64=[VALOR OCULTO]
AUTH_ACCESS_TTL_SECONDS=[VALOR OCULTO]
PRIORITY_SYNC_ENABLED=[VALOR OCULTO]
PRIORITY_SYNC_DRY_RUN=[VALOR OCULTO]

Arquivo: .env.backup-20261118-195645
NODE_ENV=[VALOR OCULTO]
API_HOST=[VALOR OCULTO]
API_PORT=[VALOR OCULTO]
LOG_LEVEL=[VALOR OCULTO]
DB_HOST=[VALOR OCULTO]
DB_PORT=[VALOR OCULTO]
DB_NAME=[VALOR OCULTO]
DB_USER=[VALOR OCULTO]
DB_PASSWORD_B64=[VALOR OCULTO]
DB_POOL_MAX=[VALOR OCULTO]
DB_CONNECTION_TIMEOUT=[VALOR OCULTO]
CORS_ORIGINS=[VALOR OCULTO]
AUTH_JWT_SECRET_B64=[VALOR OCULTO]
AUTH_ACCESS_TTL_SECONDS=[VALOR OCULTO]

Arquivo: .env.example
NODE_ENV=[VALOR OCULTO]
API_HOST=[VALOR OCULTO]
API_PORT=[VALOR OCULTO]
LOG_LEVEL=[VALOR OCULTO]
DB_HOST=[VALOR OCULTO]
DB_PORT=[VALOR OCULTO]
DB_NAME=[VALOR OCULTO]
DB_USER=[VALOR OCULTO]
DB_PASSWORD_B64=[VALOR OCULTO]
DB_POOL_MAX=[VALOR OCULTO]
DB_CONNECTION_TIMEOUT=[VALOR OCULTO]
CORS_ORIGINS=[VALOR OCULTO]

[6] ESTRUTURA DAS PASTAS DA API


==================================================
INSPECAO CONCLUIDA
Relatorio: C:\Users\Nasdara\Desktop\Raven_Analise_API_PostgreSQL_VPP.txt
==================================================
**********************
Fim da transcrição do Windows PowerShell
Hora de término: 20261119141027
**********************
