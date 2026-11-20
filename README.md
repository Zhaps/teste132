RAVEN CONTROL CENTER - INSPECAO 6.5.4 CORRIGIDA
Data: 2026-11-20 17:37:37
Modo: SOMENTE LEITURA


====================================================================================================
ARQUIVO: API\src\server.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 193

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
   25: const ingestRoutes = require('./routes/ingest');
   26: const { startPriorityScheduler, stopPriorityScheduler } = require('./services/priority-scheduler');
   27: 
   28: const app = express();
   29: 
   30: const HOST = process.env.API_HOST || '127.0.0.1';
   31: const PORT = Number(process.env.API_PORT || 3100);
   32: 
   33: const allowedOrigins = new Set(
   34:     (process.env.CORS_ORIGINS || '')
   35:         .split(',')
   36:         .map(value => value.trim())
   37:         .filter(Boolean)
   38: );
   39: 
   40: app.disable('x-powered-by');
   41: 
   42: app.use(pinoHttp({ logger }));
   43: 
   44: app.use(helmet());
   45: 
   46: app.use(cors({
   47:     origin: (origin, callback) => {
   48:         if (!origin || allowedOrigins.has(origin)) {
   49:             return callback(null, true);
   50:         }
   51: 
   52:         return callback(null, false);
   53:     },
   54:     credentials: true,
   55:     methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']
   56: }));
   57: 
   58: app.use('/api/v1/ingest', express.raw({
   59:     type: 'application/json',
   60:     limit: '64kb'
   61: }));
   62: app.use(express.json({ limit: '1mb' }));
   63: app.use(express.urlencoded({ extended: false, limit: '1mb' }));
   64: 
   65: app.use(rateLimit({
   66:     windowMs: 15 * 60 * 1000,
   67:     limit: 300,
   68:     standardHeaders: 'draft-8',
   69:     legacyHeaders: false
   70: }));
   71: 
   72: app.get('/', (req, res) => {
   73:     res.json({
   74:         name: 'Raven Control Center API',
   75:         version: '1.0.0',
   76:         status: 'running'
   77:     });
   78: });
   79: 
   80: app.use('/api/health', healthRoutes);
   81: app.use('/api/auth', authRoutes);
   82: app.use('/api/players', playersRoutes);
   83: app.use('/api/priority', priorityRoutes);
   84: app.use('/api/audit', auditRoutes);
   85: app.use('/api/killfeed', killfeedRoutes);
   86: app.use('/api/incidents', incidentsRoutes);
   87: app.use('/api/logs', logsRoutes);
   88: app.use('/api/v1/ingest', ingestRoutes);
   89: 
   90: app.use((req, res) => {
   91:     res.status(404).json({
   92:         error: 'ROUTE_NOT_FOUND'
   93:     });
   94: });
   95: 
   96: app.use((error, req, res, next) => {
   97:     if (res.headersSent) {
   98:         return next(error);
   99:     }
  100: 
  101:     req.log.error({ error }, 'Erro na requisicao');
  102: 
  103:     res.status(error.status || 500).json({
  104:         error: 'INTERNAL_SERVER_ERROR',
  105:         message: 'Erro interno da API.'
  106:     });
  107: });
  108: 
  109: let server;
  110: 
  111: async function startServer() {
  112:     await pool.query('SELECT 1');
  113:     startPriorityScheduler();
  114: 
  115:     server = app.listen(PORT, HOST, () => {
  116:         logger.info({
  117:             host: HOST,
  118:             port: PORT,
  119:             database: process.env.DB_NAME
  120:         }, 'Raven Control Center API iniciada');
  121:     });
  122: 
  123:     server.on('error', (error) => {
  124:         logger.error({ error }, 'Falha no servidor HTTP');
  125:         process.exitCode = 1;
  126:     });
  127: }
  128: 
  129: let shuttingDown = false;
  130: 
  131: async function shutdown(signal) {
  132:     if (shuttingDown) return;
  133:     shuttingDown = true;
  134: 
  135:     logger.info({ signal }, 'Encerramento seguro da API iniciado');
  136: 
  137:     let shutdownError = null;
  138: 
  139:     try {
  140:         await stopPriorityScheduler();
  141:     } catch (error) {
  142:         shutdownError = error;
  143:         logger.error({ error }, 'Falha ao aguardar o agendador');
  144:     }
  145: 
  146:     if (server) {
  147:         try {
  148:             await new Promise((resolve, reject) => {
  149:                 server.close((error) => {
  150:                     if (error) reject(error);
  151:                     else resolve();
  152:                 });
  153: 
  154:                 if (typeof server.closeIdleConnections === 'function') {
  155:                     server.closeIdleConnections();
  156:                 }
  157:             });
  158:         } catch (error) {
  159:             shutdownError = shutdownError || error;
  160:             logger.error({ error }, 'Falha ao encerrar servidor HTTP');
  161:         }
  162:     }
  163: 
  164:     try {
  165:         await pool.end();
  166:     } catch (error) {
  167:         shutdownError = shutdownError || error;
  168:         logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
  169:     }
  170: 
  171:     if (shutdownError) {
  172:         logger.error('API encerrada com erro durante o desligamento');
  173:         process.exitCode = 1;
  174:         return;
  175:     }
  176: 
  177:     logger.info('API encerrada com seguranca');
  178:     process.exitCode = 0;
  179: }
  180: 
  181: process.on('SIGINT', () => {
  182:     void shutdown('SIGINT');
  183: });
  184: 
  185: process.on('SIGTERM', () => {
  186:     void shutdown('SIGTERM');
  187: });
  188: 
  189: startServer().catch(async (error) => {
  190:     logger.fatal({ error }, 'Nao foi possivel iniciar a API');
  191:     await pool.end();
  192:     process.exit(1);
  193: });

====================================================================================================
ARQUIVO: API\src\routes\ingest.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 105

    1: 'use strict';
    2: 
    3: const express = require('express');
    4: const { pool } = require('../db');
    5: const requireIngestToken = require('../middleware/require-ingest-token');
    6: const { normalizeServerStatus } = require('../services/server-status-normalizer');
    7: 
    8: const router = express.Router();
    9: 
   10: router.post('/:serverId', requireIngestToken, async (req, res) => {
   11:     try {
   12:         if (!Buffer.isBuffer(req.body)) {
   13:             return res.status(400).json({
   14:                 error: 'RAW_JSON_BODY_REQUIRED'
   15:             });
   16:         }
   17: 
   18:         let envelope;
   19: 
   20:         try {
   21:             envelope = JSON.parse(req.body.toString('utf8'));
   22:         } catch (_) {
   23:             return res.status(400).json({
   24:                 error: 'INVALID_JSON'
   25:             });
   26:         }
   27: 
   28:         const serverId = req.params.serverId;
   29: 
   30:         if (!/^[a-zA-Z0-9_-]{1,64}$/.test(serverId)) {
   31:             return res.status(400).json({
   32:                 error: 'INVALID_SERVER_ID'
   33:             });
   34:         }
   35: 
   36:         if (
   37:             envelope.server_id !== undefined &&
   38:             envelope.server_id !== serverId
   39:         ) {
   40:             return res.status(400).json({
   41:                 error: 'SERVER_ID_MISMATCH'
   42:             });
   43:         }
   44: 
   45:         const status = normalizeServerStatus(envelope);
   46: 
   47:         const result = await pool.query(
   48:             `INSERT INTO public.server_status_events
   49:                 (server_id, event_id, occurred_at, fps,
   50:                  uptime_seconds, players, max_players,
   51:                  steam_queue, payload)
   52:              VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9::jsonb)
   53:              ON CONFLICT (server_id, event_id) DO NOTHING
   54:              RETURNING id`,
   55:             [
   56:                 serverId,
   57:                 status.eventId,
   58:                 status.occurredAt,
   59:                 status.fps,
   60:                 status.uptimeSeconds,
   61:                 status.players,
   62:                 status.maxPlayers,
   63:                 status.steamQueue,
   64:                 JSON.stringify(status.rawPayload)
   65:             ]
   66:         );
   67: 
   68:         if (result.rowCount === 0) {
   69:             return res.status(200).json({
   70:                 status: 'duplicate',
   71:                 event_id: status.eventId
   72:             });
   73:         }
   74: 
   75:         req.log.info({
   76:             serverId,
   77:             eventId: status.eventId
   78:         }, 'Evento server.status recebido');
   79: 
   80:         return res.status(201).json({
   81:             status: 'accepted',
   82:             event_id: status.eventId,
   83:             record_id: String(result.rows[0].id)
   84:         });
   85:     } catch (error) {
   86:         if (error.message && error.message.startsWith('INVALID_') ||
   87:             error.message && error.message.startsWith('MISSING_') ||
   88:             error.message === 'PLAYERS_EXCEED_MAX_PLAYERS') {
   89:             return res.status(400).json({
   90:                 error: error.message
   91:             });
   92:         }
   93: 
   94:         req.log.error({
   95:             code: error.code,
   96:             message: error.message
   97:         }, 'Falha na ingestao server.status');
   98: 
   99:         return res.status(500).json({
  100:             error: 'INGESTION_FAILED'
  101:         });
  102:     }
  103: });
  104: 
  105: module.exports = router;

====================================================================================================
ARQUIVO: API\src\routes\health.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 92

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

====================================================================================================
ARQUIVO: API\src\middleware\require-auth.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 86

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

====================================================================================================
ARQUIVO: API\src\db.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 33

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

====================================================================================================
ARQUIVO: API\src\routes\players.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 145

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

====================================================================================================
ARQUIVO: API\src\routes\incidents.js
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 75

    1: 'use strict';
    2: 
    3: const express = require('express');
    4: const { z } = require('zod');
    5: 
    6: const { pool } = require('../db');
    7: const requireAuth = require('../middleware/require-auth');
    8: const requireRole = require('../middleware/require-role');
    9: 
   10: const router = express.Router();
   11: 
   12: router.use(requireAuth);
   13: router.use(requireRole('owner', 'admin'));
   14: 
   15: const querySchema = z.object({
   16:     page: z.coerce.number().int().min(1).max(100000).default(1),
   17:     limit: z.coerce.number().int().min(1).max(100).default(50)
   18: }).strict();
   19: 
   20: router.get('/', async (req, res) => {
   21:     const parsed = querySchema.safeParse(req.query);
   22: 
   23:     if (!parsed.success) {
   24:         return res.status(400).json({
   25:             error: 'INVALID_INCIDENT_QUERY'
   26:         });
   27:     }
   28: 
   29:     const { page, limit } = parsed.data;
   30: 
   31:     try {
   32:         const count = await pool.query(
   33:             `SELECT COUNT(*)::integer AS total
   34:              FROM public.system_incidents`
   35:         );
   36: 
   37:         const result = await pool.query(
   38:             `SELECT
   39:                 id::text,
   40:                 component,
   41:                 severity,
   42:                 details,
   43:                 started_at,
   44:                 resolved_at,
   45:                 CASE
   46:                     WHEN resolved_at IS NULL
   47:                     THEN EXTRACT(EPOCH FROM (NOW() - started_at))::integer
   48:                     ELSE EXTRACT(EPOCH FROM (resolved_at - started_at))::integer
   49:                 END AS duration_seconds,
   50:                 resolved_at IS NULL AS is_open
   51:              FROM public.system_incidents
   52:              ORDER BY started_at DESC
   53:              LIMIT $1 OFFSET $2`,
   54:             [limit, (page - 1) * limit]
   55:         );
   56: 
   57:         return res.json({
   58:             page,
   59:             limit,
   60:             total: count.rows[0].total,
   61:             incidents: result.rows
   62:         });
   63:     } catch (error) {
   64:         req.log.error(
   65:             { code: error.code },
   66:             'Falha ao consultar incidentes'
   67:         );
   68: 
   69:         return res.status(500).json({
   70:             error: 'INCIDENT_QUERY_ERROR'
   71:         });
   72:     }
   73: });
   74: 
   75: module.exports = router;

====================================================================================================
ARQUIVO: Dashboard\public\index.html
====================================================================================================
[OK] Arquivo encontrado. Total de linhas: 1261

    1: <!DOCTYPE html>
    2: <html lang="pt-BR">
    3: <head>
    4: <meta charset="UTF-8">
    5: <meta name="viewport" content="width=device-width, initial-scale=1.0">
    6: <meta name="theme-color" content="#0b0e13">
    7: <title>RAVEN | Control Center</title>
    8: <style>
    9: :root {
   10:     color-scheme: dark;
   11:     --bg:#0b0e13;
   12:     --panel:#121720;
   13:     --panel2:#171e29;
   14:     --line:#252e3b;
   15:     --text:#edf1f7;
   16:     --muted:#8c98a9;
   17:     --red:#a93442;
   18:     --red2:#d14c59;
   19:     --green:#3eb889;
   20:     --yellow:#d8aa53;
   21:     --blue:#6c9ed8;
   22: }
   23: * { box-sizing:border-box; }
   24: body {
   25:     margin:0;
   26:     min-height:100vh;
   27:     background:var(--bg);
   28:     color:var(--text);
   29:     font-family:Inter,Segoe UI,Arial,sans-serif;
   30: }
   31: button,input,select,textarea { font:inherit; }
   32: button { cursor:pointer; }
   33: .hidden { display:none!important; }
   34: .login-screen {
   35:     min-height:100vh;
   36:     display:grid;
   37:     place-items:center;
   38:     padding:24px;
   39:     background:
   40:       radial-gradient(ellipse at 50% 35%,#351820 0%,transparent 48%),
   41:       var(--bg);
   42: }
   43: .login-card {
   44:     width:min(420px,100%);
   45:     background:var(--panel);
   46:     border:1px solid var(--line);
   47:     border-radius:16px;
   48:     padding:36px;
   49:     box-shadow:0 24px 80px #0008;
   50: }
   51: .brand {
   52:     font-size:25px;
   53:     font-weight:900;
   54:     letter-spacing:5px;
   55: }
   56: .brand span { color:var(--red2); }
   57: .subtitle { color:var(--muted); margin:8px 0 28px; }
   58: .field { display:grid; gap:7px; margin:16px 0; }
   59: .field label { color:var(--muted); font-size:12px; }
   60: input,select,textarea {
   61:     width:100%;
   62:     padding:12px 13px;
   63:     border:1px solid var(--line);
   64:     border-radius:8px;
   65:     background:#0d1219;
   66:     color:var(--text);
   67:     outline:none;
   68: }
   69: input:focus,select:focus,textarea:focus { border-color:var(--red2); }
   70: textarea { resize:vertical; min-height:75px; }
   71: .btn {
   72:     border:1px solid var(--line);
   73:     background:var(--panel2);
   74:     color:var(--text);
   75:     padding:10px 14px;
   76:     border-radius:8px;
   77:     font-weight:650;
   78: }
   79: .btn:hover { border-color:#566477; }
   80: .btn-primary { background:var(--red); border-color:var(--red); }
   81: .btn-primary:hover { background:var(--red2); }
   82: .btn-danger { color:#ff9ca5; border-color:#63303a; }
   83: .btn-small { padding:7px 10px; font-size:12px; }
   84: .login-card .btn { width:100%; margin-top:12px; }
   85: .error { color:#ff8994; font-size:13px; margin-top:12px; }
   86: .app { min-height:100vh; display:grid; grid-template-columns:245px 1fr; }
   87: .sidebar {
   88:     background:#0e131b;
   89:     border-right:1px solid var(--line);
   90:     padding:25px 16px;
   91:     display:flex;
   92:     flex-direction:column;
   93:     min-height:100vh;
   94: }
   95: .sidebar .brand { padding:0 12px 28px; font-size:21px; }
   96: .nav-label {
   97:     color:#657184;
   98:     font-size:10px;
   99:     font-weight:800;
  100:     letter-spacing:1.7px;
  101:     padding:15px 12px 8px;
  102: }
  103: .nav-btn {
  104:     display:flex;
  105:     width:100%;
  106:     gap:12px;
  107:     align-items:center;
  108:     text-align:left;
  109:     padding:12px;
  110:     margin:3px 0;
  111:     border:0;
  112:     border-radius:8px;
  113:     background:transparent;
  114:     color:#9ba7b7;
  115: }
  116: .nav-btn:hover,.nav-btn.active { background:#202936; color:white; }
  117: .nav-btn.active { box-shadow:inset 3px 0 var(--red2); }
  118: .sidebar-bottom { margin-top:auto; border-top:1px solid var(--line); padding:18px 10px 0; }
  119: .user-name { font-weight:700; font-size:13px; }
  120: .user-role { color:var(--muted); font-size:11px; margin-top:5px; }
  121: .main { min-width:0; }
  122: .topbar {
  123:     height:76px;
  124:     border-bottom:1px solid var(--line);
  125:     display:flex;
  126:     align-items:center;
  127:     justify-content:space-between;
  128:     padding:0 32px;
  129: }
  130: .topbar small { color:var(--muted); }
  131: .content { padding:30px 32px 50px; max-width:1500px; margin:auto; }
  132: .page-title { font-size:25px; margin:0 0 7px; }
  133: .page-desc { color:var(--muted); margin:0 0 25px; font-size:13px; }
  134: .grid { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:15px; }
  135: .stat,.panel {
  136:     background:var(--panel);
  137:     border:1px solid var(--line);
  138:     border-radius:11px;
  139: }
  140: .stat { padding:20px; }
  141: .stat-label { color:var(--muted); font-size:12px; }
  142: .stat-value { font-size:29px; font-weight:800; margin-top:12px; }
  143: .stat-note { color:var(--muted); font-size:11px; margin-top:7px; }
  144: .panel { padding:20px; margin-top:18px; }
  145: .panel-head {
  146:     display:flex; justify-content:space-between; align-items:center;
  147:     gap:12px; margin-bottom:16px;
  148: }
  149: .panel-head h3 { margin:0; font-size:15px; }
  150: .toolbar { display:flex; gap:9px; flex-wrap:wrap; margin-bottom:15px; }
  151: .toolbar input,.toolbar select { width:auto; min-width:180px; }
  152: .table-wrap { overflow-x:auto; }
  153: table { width:100%; border-collapse:collapse; font-size:12px; }
  154: th {
  155:     text-align:left; color:var(--muted); font-size:10px;
  156:     letter-spacing:.7px; text-transform:uppercase;
  157:     padding:12px 10px; border-bottom:1px solid var(--line);
  158: }
  159: td { padding:13px 10px; border-bottom:1px solid #202936; vertical-align:middle; }
  160: tbody tr:hover { background:#ffffff06; }
  161: .muted { color:var(--muted); }
  162: .pill {
  163:     display:inline-block; border-radius:20px; padding:5px 9px;
  164:     font-size:10px; font-weight:800; background:#293342; color:#c5d0df;
  165: }
  166: .pill.active { background:#153c31; color:#6ce0b3; }
  167: .pill.scheduled { background:#3b321d; color:#e7c16e; }
  168: .pill.expired,.pill.revoked { background:#39232a; color:#e89aa4; }
  169: .actions { display:flex; gap:6px; flex-wrap:wrap; }
  170: .empty { color:var(--muted); text-align:center; padding:28px; }
  171: .monitor-panel { margin:18px 0; }
  172: .monitor-grid {
  173:     display:grid;
  174:     grid-template-columns:repeat(auto-fit,minmax(190px,1fr));
  175:     gap:12px;
  176: }
  177: .monitor-card {
  178:     background:#151e29;
  179:     border:1px solid var(--line);
  180:     border-radius:9px;
  181:     padding:15px;
  182:     min-width:0;
  183: }
  184: .monitor-card-title {
  185:     color:var(--muted);
  186:     font-size:10px;
  187:     font-weight:800;
  188:     letter-spacing:.6px;
  189:     text-transform:uppercase;
  190:     margin-bottom:10px;
  191: }
  192: .monitor-state {
  193:     display:inline-flex;
  194:     align-items:center;
  195:     gap:7px;
  196:     font-size:13px;
  197:     font-weight:800;
  198: }
  199: .monitor-state::before {
  200:     content:"";
  201:     width:8px;
  202:     height:8px;
  203:     border-radius:50%;
  204:     background:var(--green);
  205: }
  206: .monitor-state.bad::before { background:var(--red2); }
  207: .monitor-detail {
  208:     color:var(--muted);
  209:     font-size:11px;
  210:     margin-top:8px;
  211:     line-height:1.6;
  212: }
  213: .monitor-metrics {
  214:     display:flex;
  215:     flex-wrap:wrap;
  216:     gap:12px 22px;
  217:     margin-top:14px;
  218:     padding-top:13px;
  219:     border-top:1px solid var(--line);
  220: }
  221: .monitor-metric-label {
  222:     color:var(--muted);
  223:     font-size:10px;
  224:     text-transform:uppercase;
  225: }
  226: .monitor-metric-value {
  227:     font-size:15px;
  228:     font-weight:800;
  229:     margin-top:4px;
  230: }
  231: .monitor-updated {
  232:     color:var(--muted);
  233:     font-size:10px;
  234:     margin-top:12px;
  235: }
  236: .status-dot {
  237:     display:inline-block; width:8px; height:8px; border-radius:50%;
  238:     background:var(--green); margin-right:7px;
  239: }
  240: @keyframes ravenApiPulseGreen {
  241:     0%, 100% {
  242:         opacity: 1;
  243:         box-shadow: 0 0 0 0 rgba(34,197,94,.75);
  244:         filter: brightness(1);
  245:     }
  246:     50% {
  247:         opacity: .35;
  248:         box-shadow: 0 0 0 7px rgba(34,197,94,0);
  249:         filter: brightness(1.5);
  250:     }
  251: }
  252: 
  253: @keyframes ravenApiPulseRed {
  254:     0%, 100% {
  255:         opacity: 1;
  256:         box-shadow: 0 0 0 0 rgba(239,68,68,.8);
  257:         filter: brightness(1);
  258:     }
  259:     50% {
  260:         opacity: .35;
  261:         box-shadow: 0 0 0 7px rgba(239,68,68,0);
  262:         filter: brightness(1.5);
  263:     }
  264: }
  265: 
  266: .status-dot:not(.bad) {
  267:     background: #22c55e;
  268:     animation: ravenApiPulseGreen 1.2s ease-in-out infinite;
  269: }
  270: 
  271: .status-dot.bad {
  272:     background: #ef4444;
  273:     animation: ravenApiPulseRed 1.2s ease-in-out infinite;
  274: }
  275: .message {
  276:     padding:12px 14px; border-radius:8px; margin:12px 0;
  277:     background:#202936; color:#cbd5e1; font-size:13px;
  278: }
  279: .message.error { background:#3a2027; color:#ffabb3; }
  280: .message.success { background:#17372e; color:#8ae0bd; }
  281: .modal-backdrop {
  282:     position:fixed; inset:0; background:#000a; z-index:5;
  283:     display:grid; place-items:center; padding:20px;
  284: }
  285: .modal {
  286:     width:min(500px,100%); max-height:90vh; overflow:auto;
  287:     background:var(--panel); border:1px solid var(--line);
  288:     border-radius:13px; padding:23px;
  289: }
  290: .modal h3 { margin:0 0 18px; }
  291: .modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }
  292: .footer-note { color:#647184; font-size:11px; margin-top:24px; }
  293: @media(max-width:1000px) {
  294:     .grid { grid-template-columns:repeat(2,minmax(0,1fr)); }
  295:     .app { grid-template-columns:205px 1fr; }
  296: }
  297: @media(max-width:700px) {
  298:     .app { display:block; }
  299:     .sidebar { min-height:0; padding:14px; }
  300:     .sidebar .brand { padding:5px 8px 12px; }
  301:     .nav-label,.sidebar-bottom { display:none; }
  302:     .nav-btn { display:inline-flex; width:auto; padding:9px; }
  303:     .topbar { height:58px; padding:0 16px; }
  304:     .content { padding:22px 15px; }
  305:     .grid { gap:9px; }
  306:     .stat { padding:14px; }
  307:     .stat-value { font-size:23px; }
  308: }
  309: </style>
  310: </head>
  311: <body>
  312: 
  313: <section id="loginScreen" class="login-screen">
  314:   <form id="loginForm" class="login-card">
  315:     <div class="brand">RAVEN<span>.</span></div>
  316:     <p class="subtitle">Control Center Â· AdministraÃ§Ã£o</p>
  317:     <div class="field">
  318:       <label for="username">USUÃRIO</label>
  319:       <input id="username" name="username" autocomplete="username" required minlength="3" maxlength="64">
  320:     </div>
  321:     <div class="field">
  322:       <label for="password">SENHA</label>
  323:       <input id="password" name="password" type="password" autocomplete="current-password" required minlength="14" maxlength="72">
  324:     </div>
  325:     <button class="btn btn-primary" type="submit" id="loginButton">Entrar no sistema</button>
  326:     <div id="loginMessage" class="error" role="alert"></div>
  327:   </form>
  328: </section>
  329: 
  330: <div id="app" class="app hidden">
  331:   <aside class="sidebar">
  332:     <div class="brand">RAVEN<span>.</span></div>
  333:     <div class="nav-label">GERENCIAMENTO</div>
  334:     <button class="nav-btn active" data-page="overview">â—ˆ VisÃ£o geral</button>
  335:     <button class="nav-btn" data-page="players">â™™ Jogadores</button>
  336:     <button class="nav-btn" data-page="priorities">â—† Prioridades</button>
  337:     <button class="nav-btn" data-page="audit" id="auditNav">â–¤ Auditoria</button>
  338:     <button class="nav-btn" data-page="killfeed">âš” KillFeed</button>
  339:     <button class="nav-btn" data-page="incidents" id="incidentsNav">â—· Incidentes</button>
  340:     <button class="nav-btn" data-page="logs" id="logsNav">Logs e Diagnosticos</button>
  341:     <div class="sidebar-bottom">
  342:       <div class="user-name" id="sideUsername">Administrador</div>
  343:       <div class="user-role" id="sideRole">Perfil</div>
  344:       <button class="btn btn-small" id="logoutButton" style="margin-top:15px;width:100%">Sair da conta</button>
  345:     </div>
  346:   </aside>
  347: 
  348:   <main class="main">
  349:     <header class="topbar">
  350:       <strong id="topTitle">VisÃ£o geral</strong>
  351:       <small><span class="status-dot" id="apiDot"></span><span id="apiLabel">Verificando API</span></small>
  352:     </header>
  353:     <section class="content">
  354:       <div id="pageContent"></div>
  355:       <div id="globalMessage"></div>
  356:       <div class="footer-note">RAVEN CONTROL CENTER Â· AÃ§Ãµes administrativas sÃ£o registradas pela API.</div>
  357:     </section>
  358:   </main>
  359: </div>
  360: 
  361: <div id="modalRoot"></div>
  362: 
  363: <script>
  364: 'use strict';
  365: 
  366: const API = 'http://127.0.0.1:3100/api';
  367: const TOKEN_KEY = 'raven_access_token';
  368: const ADMIN_KEY = 'raven_admin';
  369: 
  370: let token = sessionStorage.getItem(TOKEN_KEY);
  371: let admin = null;
  372: let currentPage = 'overview';
  373: let playersPage = 1;
  374: let grantsPage = 1;
  375: let auditPage = 1;
  376: let playerSearchTimer = null;
  377: 
  378: const $ = id => document.getElementById(id);
  379: const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({
  380:   '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
  381: })[c]);
  382: 
  383: function notify(message, type = '') {
  384:   $('globalMessage').innerHTML = message
  385:     ? `<div class="message ${type}">${esc(message)}</div>` : '';
  386: }
  387: 
  388: async function api(path, options = {}) {
  389:   const headers = { ...(options.headers || {}) };
  390:   if (token) headers.Authorization = `Bearer ${token}`;
  391:   if (options.body !== undefined) headers['Content-Type'] = 'application/json';
  392: 
  393:   const response = await fetch(API + path, {
  394:     ...options,
  395:     headers,
  396:     body: options.body === undefined ? undefined : JSON.stringify(options.body)
  397:   });
  398: 
  399:   let data = {};
  400:   try { data = await response.json(); } catch {}
  401: 
  402:   if (response.status === 401) {
  403:     logout();
  404:     throw new Error('SessÃ£o expirada. Entre novamente.');
  405:   }
  406: 
  407:   if (!response.ok) {
  408:     const messages = {
  409:       INVALID_CREDENTIALS:'UsuÃ¡rio ou senha invÃ¡lidos.',
  410:       TOO_MANY_LOGIN_ATTEMPTS:'Muitas tentativas. Aguarde antes de tentar novamente.',
  411:       PLAYER_ALREADY_EXISTS:'Este Steam64 jÃ¡ estÃ¡ cadastrado.',
  412:       PLAYER_NOT_FOUND:'Jogador nÃ£o encontrado.',
  413:       CATEGORY_NOT_FOUND:'Categoria nÃ£o encontrada.',
  414:       PRIORITY_ALREADY_EXISTS:'JÃ¡ existe uma concessÃ£o equivalente.',
  415:       GRANT_NOT_FOUND:'ConcessÃ£o nÃ£o encontrada.',
  416:       GRANT_NOT_RENEWABLE:'Esta concessÃ£o nÃ£o pode ser renovada.',
  417:       GRANT_NOT_REVOCABLE:'Esta concessÃ£o nÃ£o pode ser revogada.',
  418:       GRANT_IS_PERMANENT:'Esta concessÃ£o Ã© permanente.',
  419:       INSUFFICIENT_PERMISSIONS:'Seu perfil nÃ£o tem permissÃ£o para esta operaÃ§Ã£o.'
  420:     };
  421:     throw new Error(messages[data.error] || data.message || data.error || `Erro HTTP ${response.status}`);
  422:   }
  423:   return data;
  424: }
  425: 
  426: function showLogin() {
  427:   $('loginScreen').classList.remove('hidden');
  428:   $('app').classList.add('hidden');
  429: }
  430: 
  431: function showApp() {
  432:   $('loginScreen').classList.add('hidden');
  433:   $('app').classList.remove('hidden');
  434:   $('sideUsername').textContent = admin.username;
  435:   $('sideRole').textContent = admin.role.toUpperCase();
  436:   $('auditNav').classList.toggle('hidden', !['owner','admin'].includes(admin.role));
  437:   incidentsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
  438:   logsNav.classList.toggle('hidden', !['owner','admin'].includes(admin.role));
  439: }
  440: 
  441: function logout() {
  442:   token = null;
  443:   admin = null;
  444:   sessionStorage.removeItem(TOKEN_KEY);
  445:   sessionStorage.removeItem(ADMIN_KEY);
  446:   showLogin();
  447: }
  448: 
  449: $('loginForm').addEventListener('submit', async event => {
  450:   event.preventDefault();
  451:   const button = $('loginButton');
  452:   const message = $('loginMessage');
  453:   button.disabled = true;
  454:   message.textContent = 'Autenticando...';
  455: 
  456:   try {
  457:     const result = await api('/auth/login', {
  458:       method:'POST',
  459:       body:{
  460:         username:$('username').value.trim(),
  461:         password:$('password').value
  462:       }
  463:     });
  464:     token = result.accessToken;
  465:     sessionStorage.setItem(TOKEN_KEY, token);
  466: 
  467:     const me = await api('/auth/me');
  468:     admin = me.admin;
  469:     sessionStorage.setItem(ADMIN_KEY, JSON.stringify(admin));
  470:     $('password').value = '';
  471:     showApp();
  472:     await navigate('overview');
  473:   } catch (error) {
  474:     message.textContent = error.message;
  475:   } finally {
  476:     button.disabled = false;
  477:   }
  478: });
  479: 
  480: $('logoutButton').addEventListener('click', logout);
  481: 
  482: document.querySelectorAll('.nav-btn').forEach(button => {
  483:   button.addEventListener('click', () => navigate(button.dataset.page));
  484: });
  485: 
  486: function titleFor(page) {
  487:   return ({
  488:     overview:'VisÃ£o geral',
  489:     players:'Jogadores',
  490:     priorities:'Prioridades',
  491:     audit:'Auditoria',
  492:     killfeed:'KillFeed',
  493:     incidents:'Incidentes',
  494:     logs:'Logs e Diagnosticos'
  495:   })[page] || 'Raven Control Center';
  496: }
  497: 
  498: async function navigate(page) {
  499:   if (page === 'audit' && !['owner','admin'].includes(admin?.role)) {
  500:     return notify('Seu perfil nÃ£o possui acesso Ã  auditoria.', 'error');
  501:   }
  502:   if (['incidents','logs'].includes(page) && !['owner','admin'].includes(admin?.role)) {
  503:     return notify('Acesso restrito.', 'error');
  504:   }
  505:   currentPage = page;
  506:   document.querySelectorAll('.nav-btn').forEach(button => {
  507:     button.classList.toggle('active', button.dataset.page === page);
  508:   });
  509:   $('topTitle').textContent = titleFor(page);
  510:   notify('');
  511:   try {
  512:     if (page === 'overview') await renderOverview();
  513:     if (page === 'players') await renderPlayers();
  514:     if (page === 'priorities') await renderPriorities();
  515:     if (page === 'audit') await renderAudit();
  516:     if (page === 'incidents') await renderIncidents();
  517:     if (page === 'logs') await renderLogs();
  518:     if (page === 'killfeed') await renderKillfeed();
  519:   } catch (error) {
  520:     $('pageContent').innerHTML = `<div class="panel message error">${esc(error.message)}</div>`;
  521:   }
  522: }
  523: 
  524: async function checkHealth() {
  525:   const setMonitorState = (id, connected, label) => {
  526:     const element = $(id);
  527:     if (!element) return;
  528: 
  529:     element.textContent = label;
  530:     element.classList.toggle('bad', !connected);
  531:   };
  532: 
  533:   const setMonitorText = (id, value) => {
  534:     const element = $(id);
  535:     if (element) element.textContent = value;
  536:   };
  537: 
  538:   const formatUptime = (seconds) => {
  539:     const total = Math.max(0, Number(seconds) || 0);
  540:     const days = Math.floor(total / 86400);
  541:     const hours = Math.floor((total % 86400) / 3600);
  542:     const minutes = Math.floor((total % 3600) / 60);
  543:     const secs = Math.floor(total % 60);
  544: 
  545:     return `${days}d ${hours}h ${minutes}m ${secs}s`;
  546:   };
  547: 
  548:   try {
  549:     const health = await api('/health');
  550: 
  551:     const primary = health.databases?.primary;
  552:     const killfeed = health.databases?.killfeed;
  553: 
  554:     const primaryOK = primary?.status === 'connected';
  555:     const killfeedOK = killfeed?.status === 'connected';
  556:     const overallOK = health.status === 'ok';
  557: 
  558:     $('apiDot').classList.toggle('bad', !overallOK);
  559:     $('apiLabel').textContent = overallOK
  560:       ? 'API operacional'
  561:       : 'API com degradacao';
  562: 
  563:     setMonitorState(
  564:       'monitorPrimary',
  565:       primaryOK,
  566:       primaryOK ? 'Conectado' : 'Desconectado'
  567:     );
  568: 
  569:     setMonitorState(
  570:       'monitorKillfeed',
  571:       killfeedOK,
  572:       killfeedOK ? 'Conectado' : 'Desconectado'
  573:     );
  574: 
  575:     setMonitorText(
  576:       'monitorPrimaryLatency',
  577:       primaryOK ? `Latencia: ${primary.latencyMs} ms` : 'Banco indisponivel'
  578:     );
  579: 
  580:     setMonitorText(
  581:       'monitorKillfeedLatency',
  582:       killfeedOK ? `Latencia: ${killfeed.latencyMs} ms` : 'Banco indisponivel'
  583:     );
  584: 
  585:     setMonitorText(
  586:       'monitorOverall',
  587:       overallOK ? 'Todos os servicos operacionais' : 'Estado degradado'
  588:     );
  589: 
  590:     setMonitorText(
  591:       'monitorUptime',
  592:       formatUptime(health.uptimeSeconds)
  593:     );
  594: 
  595:     setMonitorText(
  596:       'monitorRss',
  597:       health.process?.memory?.rssMb != null
  598:         ? `${health.process.memory.rssMb} MB`
  599:         : 'Indisponivel'
  600:     );
  601: 
  602:     setMonitorText(
  603:       'monitorHeap',
  604:       health.process?.memory?.heapUsedMb != null
  605:         ? `${health.process.memory.heapUsedMb} / ${health.process.memory.heapTotalMb} MB`
  606:         : 'Indisponivel'
  607:     );
  608: 
  609:     setMonitorText(
  610:       'monitorUpdated',
  611:       `Ultima verificacao: ${new Date(health.timestamp).toLocaleTimeString('pt-BR')}`
  612:     );
  613:   } catch {
  614:     $('apiDot').classList.add('bad');
  615:     $('apiLabel').textContent = 'API indisponivel';
  616: 
  617:     setMonitorState('monitorPrimary', false, 'Indisponivel');
  618:     setMonitorState('monitorKillfeed', false, 'Indisponivel');
  619: 
  620:     setMonitorText('monitorPrimaryLatency', 'Sem resposta da API');
  621:     setMonitorText('monitorKillfeedLatency', 'Sem resposta da API');
  622:     setMonitorText('monitorOverall', 'API indisponivel');
  623:     setMonitorText('monitorUptime', 'â€”');
  624:     setMonitorText('monitorRss', 'â€”');
  625:     setMonitorText('monitorHeap', 'â€”');
  626:     setMonitorText('monitorUpdated', 'Falha na verificacao');
  627:   }
  628: }
  629: 
  630: async function renderOverview() {
  631:   $('pageContent').innerHTML = `
  632:     <h1 class="page-title">VisÃ£o geral</h1>
  633:     <p class="page-desc">Resumo operacional do Raven Control Center.</p>
  634:     <div class="panel monitor-panel">
  635:       <div class="panel-head">
  636:         <h3>Monitoramento da infraestrutura</h3>
  637:         <span class="muted" id="monitorOverall">Verificando...</span>
  638:       </div>
  639:       <div class="monitor-grid">
  640:         <div class="monitor-card">
  641:           <div class="monitor-card-title">PostgreSQL principal</div>
  642:           <div class="monitor-state" id="monitorPrimary">Verificando</div>
  643:           <div class="monitor-detail" id="monitorPrimaryLatency">Aguardando verificacao</div>
  644:         </div>
  645:         <div class="monitor-card">
  646:           <div class="monitor-card-title">PostgreSQL KillFeed</div>
  647:           <div class="monitor-state" id="monitorKillfeed">Verificando</div>
  648:           <div class="monitor-detail" id="monitorKillfeedLatency">Aguardando verificacao</div>
  649:         </div>
  650:       </div>
  651:       <div class="monitor-metrics">
  652:         <div>
  653:           <div class="monitor-metric-label">Uptime da API</div>
  654:           <div class="monitor-metric-value" id="monitorUptime">â€”</div>
  655:         </div>
  656:         <div>
  657:           <div class="monitor-metric-label">Memoria RSS</div>
  658:           <div class="monitor-metric-value" id="monitorRss">â€”</div>
  659:         </div>
  660:         <div>
  661:           <div class="monitor-metric-label">Heap utilizado</div>
  662:           <div class="monitor-metric-value" id="monitorHeap">â€”</div>
  663:         </div>
  664:       </div>
  665:       <div class="monitor-updated" id="monitorUpdated">Aguardando primeira verificacao</div>
  666:     </div>
  667:     <div class="grid">
  668:       <div class="stat"><div class="stat-label">JOGADORES CADASTRADOS</div><div class="stat-value" id="statPlayers">â€”</div><div class="stat-note">Registros na base</div></div>
  669:       <div class="stat"><div class="stat-label">FILA EFETIVA</div><div class="stat-value" id="statQueue">â€”</div><div class="stat-note">Jogadores com prioridade ativa</div></div>
  670:       <div class="stat"><div class="stat-label">CONCESSÃ•ES ATIVAS</div><div class="stat-value" id="statActive">â€”</div><div class="stat-note">Prioridades vigentes</div></div>
  671:       <div class="stat"><div class="stat-label">CONCESSÃ•ES AGENDADAS</div><div class="stat-value" id="statScheduled">â€”</div><div class="stat-note">AtivaÃ§Ãµes futuras</div></div>
  672:     </div>
  673:     <div class="panel">
  674:       <div class="panel-head"><h3>Fila efetiva de prioridade</h3><button class="btn btn-small" id="refreshOverview">Atualizar</button></div>
  675:       <div id="effectiveTable" class="muted">Carregando...</div>
  676:     </div>`;
  677:   $('refreshOverview').addEventListener('click', renderOverview);
  678:   const [players, effective, active, scheduled] = await Promise.all([
  679:     api('/players?limit=1'),
  680:     api('/priority/effective'),
  681:     api('/priority/grants?status=active&limit=1'),
  682:     api('/priority/grants?status=scheduled&limit=1')
  683:   ]);
  684:   $('statPlayers').textContent = players.total;
  685:   $('statQueue').textContent = effective.count;
  686:   $('statActive').textContent = active.total;
  687:   $('statScheduled').textContent = scheduled.total;
  688:   $('effectiveTable').innerHTML = effective.players.length
  689:     ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th></tr></thead><tbody>${effective.players.map(p => `<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td></tr>`).join('')}</tbody></table></div>`
  690:     : '<div class="empty">Nenhum jogador na fila efetiva.</div>';
  691: }
  692: 
  693: async function renderPlayers() {
  694:   $('pageContent').innerHTML = `
  695:     <h1 class="page-title">Jogadores</h1>
  696:     <p class="page-desc">Consulte e cadastre jogadores vinculados ao Steam64.</p>
  697:     <div class="panel">
  698:       <div class="toolbar">
  699:         <input id="playerSearch" placeholder="Pesquisar Steam64 ou nome..." maxlength="64">
  700:         <button class="btn btn-primary" id="addPlayer">+ Cadastrar jogador</button>
  701:       </div>
  702:       <div id="playersTable">Carregando...</div>
  703:       <div class="toolbar" style="justify-content:space-between;margin-top:15px">
  704:         <button class="btn btn-small" id="playersPrev">Anterior</button>
  705:         <span class="muted" id="playersInfo"></span>
  706:         <button class="btn btn-small" id="playersNext">PrÃ³xima</button>
  707:       </div>
  708:     </div>`;
  709:   $('playerSearch').addEventListener('input', () => {
  710:     clearTimeout(playerSearchTimer);
  711:     playerSearchTimer = setTimeout(() => { playersPage = 1; loadPlayers(); }, 300);
  712:   });
  713:   $('addPlayer').addEventListener('click', openPlayerModal);
  714:   $('playersPrev').addEventListener('click', () => { if(playersPage > 1){playersPage--;loadPlayers();} });
  715:   $('playersNext').addEventListener('click', () => { playersPage++;loadPlayers(); });
  716:   await loadPlayers();
  717: }
  718: 
  719: async function loadPlayers() {
  720:   const search = $('playerSearch')?.value.trim() || '';
  721:   const query = new URLSearchParams({page:playersPage,limit:25});
  722:   if (search) query.set('search',search);
  723:   const data = await api('/players?' + query);
  724:   const pages = Math.max(1,Math.ceil(data.total/data.limit));
  725:   if (playersPage > pages) playersPage = pages;
  726:   $('playersInfo').textContent = `PÃ¡gina ${playersPage} de ${pages} Â· ${data.total} registros`;
  727:   $('playersPrev').disabled = playersPage <= 1;
  728:   $('playersNext').disabled = playersPage >= pages;
  729:   $('playersTable').innerHTML = data.players.length
  730:     ? `<div class="table-wrap"><table><thead><tr><th>Steam64</th><th>Nome</th><th>Primeiro registro</th><th>Ãšltima atividade</th></tr></thead><tbody>${data.players.map(p=>`<tr><td>${esc(p.steam64)}</td><td>${esc(p.display_name || 'â€”')}</td><td>${formatDate(p.first_seen_at || p.created_at)}</td><td>${formatDate(p.last_seen_at)}</td></tr>`).join('')}</tbody></table></div>`
  731:     : '<div class="empty">Nenhum jogador encontrado.</div>';
  732: }
  733: 
  734: function openPlayerModal() {
  735:   openModal('Cadastrar jogador', `
  736:     <div class="field"><label>STEAM64 (17 DÃGITOS)</label><input id="modalSteam" maxlength="17" inputmode="numeric" placeholder="7656119..." required></div>
  737:     <div class="field"><label>NOME DO JOGADOR (OPCIONAL)</label><input id="modalName" maxlength="64"></div>`,
  738:     async () => {
  739:       const steam64 = $('modalSteam').value.trim();
  740:       const displayName = $('modalName').value.trim() || null;
  741:       if (!/^[0-9]{17}$/.test(steam64)) throw new Error('Steam64 deve conter exatamente 17 nÃºmeros.');
  742:       await api('/players',{method:'POST',body:{steam64,displayName}});
  743:       await renderPlayers();
  744:       notify('Jogador cadastrado com sucesso.','success');
  745:     });
  746: }
  747: 
  748: async function renderPriorities() {
  749:   $('pageContent').innerHTML = `
  750:     <h1 class="page-title">Prioridades</h1>
  751:     <p class="page-desc">Gerencie concessÃµes, renovaÃ§Ãµes e revogaÃ§Ãµes.</p>
  752:     <div class="panel">
  753:       <div class="toolbar">
  754:         <select id="grantStatus"><option value="">Todos os status</option><option value="active">Ativas</option><option value="scheduled">Agendadas</option><option value="expired">Expiradas</option><option value="revoked">Revogadas</option></select>
  755:         <input id="grantSearch" placeholder="Filtrar por Steam64" maxlength="17">
  756:         <button class="btn btn-primary" id="addGrant">+ Conceder prioridade</button>
  757:       </div>
  758:       <div id="grantsTable">Carregando...</div>
  759:       <div class="toolbar" style="justify-content:space-between;margin-top:15px">
  760:         <button class="btn btn-small" id="grantsPrev">Anterior</button>
  761:         <span class="muted" id="grantsInfo"></span>
  762:         <button class="btn btn-small" id="grantsNext">PrÃ³xima</button>
  763:       </div>
  764:     </div>`;
  765:   $('grantStatus').addEventListener('change',()=>{grantsPage=1;loadGrants();});
  766:   $('grantSearch').addEventListener('input',()=>{clearTimeout(playerSearchTimer);playerSearchTimer=setTimeout(()=>{grantsPage=1;loadGrants();},300);});
  767:   $('addGrant').addEventListener('click',openGrantModal);
  768:   $('grantsPrev').addEventListener('click',()=>{if(grantsPage>1){grantsPage--;loadGrants();}});
  769:   $('grantsNext').addEventListener('click',()=>{grantsPage++;loadGrants();});
  770:   await loadGrants();
  771: }
  772: 
  773: async function loadGrants() {
  774:   const query = new URLSearchParams({page:grantsPage,limit:25});
  775:   if ($('grantStatus').value) query.set('status',$('grantStatus').value);
  776:   if ($('grantSearch').value.trim()) query.set('steam64',$('grantSearch').value.trim());
  777:   const data = await api('/priority/grants?' + query);
  778:   const pages = Math.max(1,Math.ceil(data.total/data.limit));
  779:   if (grantsPage > pages) grantsPage = pages;
  780:   $('grantsInfo').textContent = `PÃ¡gina ${grantsPage} de ${pages} Â· ${data.total} concessÃµes`;
  781:   $('grantsPrev').disabled = grantsPage <= 1;
  782:   $('grantsNext').disabled = grantsPage >= pages;
  783:   $('grantsTable').innerHTML = data.grants.length
  784:     ? `<div class="table-wrap"><table><thead><tr><th>Jogador</th><th>Categoria</th><th>Status</th><th>Validade</th><th>Origem</th><th>AÃ§Ãµes</th></tr></thead><tbody>${data.grants.map(g=>`<tr><td>${esc(g.display_name || g.steam64)}<br><span class="muted">${esc(g.steam64)}</span></td><td>${esc(g.category_name)}</td><td><span class="pill ${esc(g.status)}">${esc(g.status)}</span></td><td>${g.expires_at ? formatDate(g.expires_at) : 'Permanente'}</td><td>${esc(g.grant_source)}</td><td>${['active','scheduled'].includes(g.status)?`<div class="actions"><button class="btn btn-small" data-renew="${esc(g.id)}">Renovar</button><button class="btn btn-small btn-danger" data-revoke="${esc(g.id)}">Revogar</button></div>`:'â€”'}</td></tr>`).join('')}</tbody></table></div>`
  785:     : '<div class="empty">Nenhuma concessÃ£o encontrada.</div>';
  786:   document.querySelectorAll('[data-renew]').forEach(b=>b.addEventListener('click',()=>openRenewModal(b.dataset.renew)));
  787:   document.querySelectorAll('[data-revoke]').forEach(b=>b.addEventListener('click',()=>revokeGrant(b.dataset.revoke)));
  788: }
  789: 
  790: async function openGrantModal() {
  791:   const result = await api('/priority/categories');
  792:   const options = result.categories.map(c=>`<option value="${esc(c.code)}">${esc(c.name)}</option>`).join('');
  793:   openModal('Conceder prioridade',`
  794:     <div class="field"><label>STEAM64 DO JOGADOR</label><input id="grantSteam" maxlength="17" placeholder="7656119..."></div>
  795:     <div class="field"><label>CATEGORIA</label><select id="grantCategory">${options}</select></div>
  796:     <div class="field"><label>INÃCIO (OPCIONAL)</label><input id="grantStart" type="datetime-local"></div>
  797:     <div class="field"><label>VALIDADE (VAZIO = PERMANENTE)</label><input id="grantExpiry" type="datetime-local"></div>
  798:     <div class="field"><label>MOTIVO (OPCIONAL)</label><textarea id="grantReason" maxlength="500"></textarea></div>`,
  799:     async()=>{
  800:       const steam64=$('grantSteam').value.trim();
  801:       if(!/^[0-9]{17}$/.test(steam64)) throw new Error('Steam64 invÃ¡lido.');
  802:       const startsAt=$('grantStart').value ? new Date($('grantStart').value).toISOString() : undefined;
  803:       const expiresAt=$('grantExpiry').value ? new Date($('grantExpiry').value).toISOString() : null;
  804:       await api('/priority/grants',{method:'POST',body:{
  805:         steam64,categoryCode:$('grantCategory').value,startsAt,expiresAt,
  806:         reason:$('grantReason').value.trim() || null
  807:       }});
  808:       await renderPriorities();
  809:       notify('Prioridade concedida com sucesso.','success');
  810:     });
  811: }
  812: 
  813: function openRenewModal(id) {
  814:   openModal('Renovar prioridade',`
  815:     <div class="field"><label>NOVA DATA E HORA DE EXPIRAÃ‡ÃƒO</label><input id="renewExpiry" type="datetime-local" required></div>
  816:     <div class="field"><label>MOTIVO (OPCIONAL)</label><textarea id="renewReason" maxlength="500"></textarea></div>`,
  817:     async()=>{
  818:       const value=$('renewExpiry').value;
  819:       if(!value) throw new Error('Informe a nova validade.');
  820:       await api(`/priority/grants/${encodeURIComponent(id)}/renew`,{method:'POST',body:{
  821:         expiresAt:new Date(value).toISOString(),
  822:         reason:$('renewReason').value.trim() || null
  823:       }});
  824:       await renderPriorities();
  825:       notify('Prioridade renovada com sucesso.','success');
  826:     });
  827: }
  828: 
  829: async function revokeGrant(id) {
  830:   if(!confirm('Confirma a revogaÃ§Ã£o desta prioridade?')) return;
  831:   const reason=prompt('Motivo da revogaÃ§Ã£o (opcional):');
  832:   if(reason === null) return;
  833:   try {
  834:     await api(`/priority/grants/${encodeURIComponent(id)}/revoke`,{
  835:       method:'PATCH',body:{reason:reason.trim() || null}
  836:     });
  837:     await renderPriorities();
  838:     notify('Prioridade revogada.','success');
  839:   } catch(error) { notify(error.message,'error'); }
  840: }
  841: 
  842: async function renderAudit() {
  843:   $('pageContent').innerHTML=`
  844:     <h1 class="page-title">Auditoria</h1>
  845:     <p class="page-desc">HistÃ³rico de operaÃ§Ãµes administrativas registradas pela API.</p>
  846:     <div class="panel">
  847:       <div class="toolbar">
  848:         <input id="auditAction" placeholder="AÃ§Ã£o (ex.: priority.granted)" maxlength="100">
  849:         <input id="auditEntity" placeholder="Tipo de entidade" maxlength="60">
  850:         <button class="btn" id="auditFilter">Filtrar</button>
  851:       </div>
  852:       <div id="auditTable">Carregando...</div>
  853:       <div class="toolbar" style="justify-content:space-between;margin-top:15px">
  854:         <button class="btn btn-small" id="auditPrev">Anterior</button>
  855:         <span class="muted" id="auditInfo"></span>
  856:         <button class="btn btn-small" id="auditNext">PrÃ³xima</button>
  857:       </div>
  858:     </div>`;
  859:   $('auditFilter').addEventListener('click',()=>{auditPage=1;loadAudit();});
  860:   $('auditPrev').addEventListener('click',()=>{if(auditPage>1){auditPage--;loadAudit();}});
  861:   $('auditNext').addEventListener('click',()=>{auditPage++;loadAudit();});
  862:   await loadAudit();
  863: }
  864: 
  865: async function loadAudit() {
  866:   const query=new URLSearchParams({page:auditPage,limit:50});
  867:   if($('auditAction').value.trim()) query.set('action',$('auditAction').value.trim());
  868:   if($('auditEntity').value.trim()) query.set('entityType',$('auditEntity').value.trim());
  869:   const data=await api('/audit?'+query);
  870:   const pages=Math.max(1,Math.ceil(data.total/data.limit));
  871:   if(auditPage>pages) auditPage=pages;
  872:   $('auditInfo').textContent=`PÃ¡gina ${auditPage} de ${pages} Â· ${data.total} registros`;
  873:   $('auditPrev').disabled=auditPage<=1;
  874:   $('auditNext').disabled=auditPage>=pages;
  875:   $('auditTable').innerHTML=data.entries.length
  876:     ? `<div class="table-wrap"><table><thead><tr><th>Data</th><th>ResponsÃ¡vel</th><th>AÃ§Ã£o</th><th>Entidade</th><th>ID</th></tr></thead><tbody>${data.entries.map(e=>`<tr><td>${formatDate(e.created_at)}</td><td>${esc(e.actor_identifier)}</td><td>${esc(e.action)}</td><td>${esc(e.entity_type)}</td><td>${esc(e.entity_id)}</td></tr>`).join('')}</tbody></table></div>`
  877:     : '<div class="empty">Nenhum registro encontrado.</div>';
  878: }
  879: 
  880: 
  881: let incidentsPage = 1;
  882: 
  883: function formatIncidentDuration(seconds) {
  884:   const total = Math.max(0, Number(seconds) || 0);
  885:   const days = Math.floor(total / 86400);
  886:   const hours = Math.floor((total % 86400) / 3600);
  887:   const minutes = Math.floor((total % 3600) / 60);
  888:   const secs = total % 60;
  889: 
  890:   if (days > 0) return `${days}d ${hours}h ${minutes}min`;
  891:   if (hours > 0) return `${hours}h ${minutes}min`;
  892:   if (minutes > 0) return `${minutes}min ${secs}s`;
  893:   return `${secs}s`;
  894: }
  895: 
  896: async function renderIncidents() {
  897:   $('pageContent').innerHTML = `
  898:     <h1 class="page-title">Historico de incidentes</h1>
  899:     <p class="page-desc">Indisponibilidades e recuperacoes dos bancos monitorados pelo Raven.</p>
  900:     <div class="panel">
  901:       <div class="toolbar" style="justify-content:space-between">
  902:         <span class="muted">Historico de incidentes do sistema</span>
  903:         <button class="btn" id="incidentsRefresh">Atualizar</button>
  904:       </div>
  905:       <div id="incidentsTable">Carregando...</div>
  906:       <div class="toolbar" style="justify-content:space-between;margin-top:15px">
  907:         <button class="btn btn-small" id="incidentsPrev">Anterior</button>
  908:         <span class="muted" id="incidentsInfo"></span>
  909:         <button class="btn btn-small" id="incidentsNext">Proxima</button>
  910:       </div>
  911:     </div>`;
  912: 
  913:   $('incidentsRefresh').addEventListener('click', () => loadIncidents());
  914:   $('incidentsPrev').addEventListener('click', () => {
  915:     if (incidentsPage > 1) {
  916:       incidentsPage--;
  917:       loadIncidents();
  918:     }
  919:   });
  920:   $('incidentsNext').addEventListener('click', () => {
  921:     incidentsPage++;
  922:     loadIncidents();
  923:   });
  924: 
  925:   await loadIncidents();
  926: }
  927: 
  928: async function loadIncidents() {
  929:   const query = new URLSearchParams({
  930:     page: incidentsPage,
  931:     limit: 50
  932:   });
  933: 
  934:   try {
  935:     const data = await api('/incidents?' + query);
  936:     const pages = Math.max(1, Math.ceil(data.total / data.limit));
  937: 
  938:     if (incidentsPage > pages) {
  939:       incidentsPage = pages;
  940:       return loadIncidents();
  941:     }
  942: 
  943:     $('incidentsInfo').textContent =
  944:       `Pagina ${incidentsPage} de ${pages} - ${data.total} incidentes`;
  945: 
  946:     $('incidentsPrev').disabled = incidentsPage <= 1;
  947:     $('incidentsNext').disabled = incidentsPage >= pages;
  948: 
  949:     $('incidentsTable').innerHTML = data.incidents.length
  950:       ? `<div class="table-wrap"><table>
  951:           <thead>
  952:             <tr>
  953:               <th>Inicio</th>
  954:               <th>Componente</th>
  955:               <th>Severidade</th>
  956:               <th>Descricao</th>
  957:               <th>Duracao</th>
  958:               <th>Resolucao</th>
  959:               <th>Estado</th>
  960:             </tr>
  961:           </thead>
  962:           <tbody>
  963:             ${data.incidents.map(incident => `
  964:               <tr>
  965:                 <td>${formatDate(incident.started_at)}</td>
  966:                 <td>${esc(incident.component)}</td>
  967:                 <td>${esc(incident.severity)}</td>
  968:                 <td>${esc(incident.details?.description || '-')}</td>
  969:                 <td>${formatIncidentDuration(incident.duration_seconds)}</td>
  970:                 <td>${incident.resolved_at ? formatDate(incident.resolved_at) : '-'}</td>
  971:                 <td>${incident.is_open ? 'Aberto' : 'Resolvido'}</td>
  972:               </tr>
  973:             `).join('')}
  974:           </tbody>
  975:         </table></div>`
  976:       : '<div class="empty">Nenhum incidente registrado.</div>';
  977: 
  978:   } catch (error) {
  979:     $('incidentsTable').innerHTML =
  980:       `<div class="message error">${esc(error.message)}</div>`;
  981:     $('incidentsInfo').textContent = 'Falha ao consultar incidentes';
  982:   }
  983: }
  984: 
  985: 
  986: let logsPage = 1;
  987: 
  988: async function renderLogs() {
  989:   $('pageContent').innerHTML = `
  990:     <h1 class="page-title">Logs e Diagnosticos</h1>
  991:     <p class="page-desc">Consulta operacional dos registros da API Raven.</p>
  992: 
  993:     <div class="panel">
  994:       <div class="toolbar">
  995:         <select id="logsLevel">
  996:           <option value="">Todos os niveis</option>
  997:           <option value="trace">Trace</option>
  998:           <option value="debug">Debug</option>
  999:           <option value="info">Info</option>
 1000:           <option value="warn">Warning</option>
 1001:           <option value="error">Error</option>
 1002:           <option value="fatal">Fatal</option>
 1003:         </select>
 1004: 
 1005:         <input id="logsComponent" placeholder="Componente" maxlength="80">
 1006:         <input id="logsSearch" placeholder="Pesquisar nos registros" maxlength="200">
 1007:         <button class="btn" id="logsFilter">Filtrar</button>
 1008:         <button class="btn" id="logsRefresh">Atualizar</button>
 1009:       </div>
 1010: 
 1011:       <div class="toolbar">
 1012:         <label>De <input type="datetime-local" id="logsFrom"></label>
 1013:         <label>AtÃ© <input type="datetime-local" id="logsTo"></label>
 1014:       </div>
 1015: 
 1016:       <div id="logsTable">Carregando registros...</div>
 1017: 
 1018:       <div class="toolbar" style="justify-content:space-between;margin-top:15px">
 1019:         <button class="btn btn-small" id="logsPrev">Anterior</button>
 1020:         <span class="muted" id="logsInfo"></span>
 1021:         <button class="btn btn-small" id="logsNext">Proxima</button>
 1022:       </div>
 1023:     </div>`;
 1024: 
 1025:   $('logsFilter').addEventListener('click', () => {
 1026:     logsPage = 1;
 1027:     loadLogs();
 1028:   });
 1029: 
 1030:   $('logsRefresh').addEventListener('click', () => loadLogs());
 1031: 
 1032:   $('logsSearch').addEventListener('keydown', event => {
 1033:     if (event.key === 'Enter') {
 1034:       logsPage = 1;
 1035:       loadLogs();
 1036:     }
 1037:   });
 1038: 
 1039:   $('logsPrev').addEventListener('click', () => {
 1040:     if (logsPage > 1) {
 1041:       logsPage--;
 1042:       loadLogs();
 1043:     }
 1044:   });
 1045: 
 1046:   $('logsNext').addEventListener('click', () => {
 1047:     logsPage++;
 1048:     loadLogs();
 1049:   });
 1050: 
 1051:   await loadLogs();
 1052: }
 1053: 
 1054: async function loadLogs() {
 1055:   const query = new URLSearchParams({
 1056:     page: logsPage,
 1057:     limit: 50
 1058:   });
 1059: 
 1060:   const level = $('logsLevel').value;
 1061:   const component = $('logsComponent').value.trim();
 1062:   const search = $('logsSearch').value.trim();
 1063:   const from = $('logsFrom').value;
 1064:   const to = $('logsTo').value;
 1065: 
 1066:   if (level) query.set('level', level);
 1067:   if (component) query.set('component', component);
 1068:   if (search) query.set('search', search);
 1069: 
 1070:   if (from) query.set('from', new Date(from).toISOString());
 1071:   if (to) query.set('to', new Date(to).toISOString());
 1072: 
 1073:   try {
 1074:     const data = await api('/logs?' + query);
 1075:     const pages = Math.max(1, Math.ceil(data.total / data.limit));
 1076: 
 1077:     if (logsPage > pages) {
 1078:       logsPage = pages;
 1079:       return loadLogs();
 1080:     }
 1081: 
 1082:     $('logsInfo').textContent =
 1083:       `Pagina ${logsPage} de ${pages} Â· ${data.total} registros Â· ${data.filesScanned} arquivos`;
 1084: 
 1085:     $('logsPrev').disabled = logsPage <= 1;
 1086:     $('logsNext').disabled = logsPage >= pages;
 1087: 
 1088:     $('logsTable').innerHTML = data.logs.length
 1089:       ? `<div class="table-wrap">
 1090:           <table>
 1091:             <thead>
 1092:               <tr>
 1093:                 <th>Data</th>
 1094:                 <th>Nivel</th>
 1095:                 <th>Componente</th>
 1096:                 <th>Mensagem</th>
 1097:               </tr>
 1098:             </thead>
 1099:             <tbody>
 1100:               ${data.logs.map(log => {
 1101:                 const level = String(log.level || 'unknown').toLowerCase();
 1102:                 const message = String(log.message || '-');
 1103: 
 1104:                 return `<tr>
 1105:                   <td>${log.time ? esc(formatDate(log.time)) : '-'}</td>
 1106:                   <td><strong>${esc(level.toUpperCase())}</strong></td>
 1107:                   <td>${esc(log.component)}</td>
 1108:                   <td title="${esc(message)}">${esc(message)}</td>
 1109:                 </tr>`;
 1110:               }).join('')}
 1111:             </tbody>
 1112:           </table>
 1113:         </div>`
 1114:       : '<div class="empty">Nenhum registro encontrado para os filtros informados.</div>';
 1115: 
 1116:   } catch (error) {
 1117:     $('logsTable').innerHTML =
 1118:       `<div class="message error">${esc(error.message)}</div>`;
 1119: 
 1120:     $('logsInfo').textContent = 'Falha ao consultar logs';
 1121:   }
 1122: }
 1123: let killfeedPage = 1;
 1124: 
 1125: async function renderKillfeed() {
 1126:   $('pageContent').innerHTML = `
 1127:     <h1 class="page-title">KillFeed</h1>
 1128:     <p class="page-desc">HistÃ³rico de eliminaÃ§Ãµes PvP registradas pelo servidor DayZ.</p>
 1129:     <div class="panel">
 1130:       <div class="toolbar">
 1131:         <input id="killfeedSearch" placeholder="Buscar jogador ou arma" maxlength="64">
 1132:         <button class="btn" id="killfeedFilter">Pesquisar</button>
 1133:       </div>
 1134:       <div id="killfeedTable">Carregando...</div>
 1135:       <div class="toolbar" style="justify-content:space-between;margin-top:15px">
 1136:         <button class="btn btn-small" id="killfeedPrev">Anterior</button>
 1137:         <span class="muted" id="killfeedInfo"></span>
 1138:         <button class="btn btn-small" id="killfeedNext">PrÃ³xima</button>
 1139:       </div>
 1140:     </div>`;
 1141: 
 1142:   $('killfeedFilter').addEventListener('click', () => {
 1143:     killfeedPage = 1;
 1144:     loadKillfeed();
 1145:   });
 1146: 
 1147:   $('killfeedSearch').addEventListener('keydown', event => {
 1148:     if (event.key === 'Enter') {
 1149:       killfeedPage = 1;
 1150:       loadKillfeed();
 1151:     }
 1152:   });
 1153: 
 1154:   $('killfeedPrev').addEventListener('click', () => {
 1155:     if (killfeedPage > 1) {
 1156:       killfeedPage--;
 1157:       loadKillfeed();
 1158:     }
 1159:   });
 1160: 
 1161:   $('killfeedNext').addEventListener('click', () => {
 1162:     killfeedPage++;
 1163:     loadKillfeed();
 1164:   });
 1165: 
 1166:   await loadKillfeed();
 1167: }
 1168: 
 1169: async function loadKillfeed() {
 1170:   const query = new URLSearchParams({ page: killfeedPage, limit: 50 });
 1171:   const search = $('killfeedSearch').value.trim();
 1172:   if (search) query.set('search', search);
 1173: 
 1174:   try {
 1175:     const data = await api('/killfeed?' + query);
 1176:     const pages = Math.max(1, Math.ceil(data.total / data.limit));
 1177: 
 1178:     if (killfeedPage > pages) killfeedPage = pages;
 1179: 
 1180:     $('killfeedInfo').textContent =
 1181:       `PÃ¡gina ${killfeedPage} de ${pages} Â· ${data.total} eliminaÃ§Ãµes`;
 1182: 
 1183:     $('killfeedPrev').disabled = killfeedPage <= 1;
 1184:     $('killfeedNext').disabled = killfeedPage >= pages;
 1185: 
 1186:     $('killfeedTable').innerHTML = data.kills.length
 1187:       ? `<div class="table-wrap"><table>
 1188:           <thead><tr><th>Data</th><th>Atacante</th><th>VÃ­tima</th><th>Arma</th><th>DistÃ¢ncia</th></tr></thead>
 1189:           <tbody>${data.kills.map(k => {
 1190:             const distance = k.distance_m == null ||
 1191:               !Number.isFinite(Number(k.distance_m))
 1192:               ? 'â€”' : `${Number(k.distance_m).toFixed(1)} m`;
 1193: 
 1194:             return `<tr>
 1195:               <td>${formatDate(k.occurred_at)}</td>
 1196:               <td>${esc(k.killer_name)}</td>
 1197:               <td>${esc(k.victim_name)}</td>
 1198:               <td>${esc(k.weapon || 'â€”')}</td>
 1199:               <td>${distance}</td>
 1200:             </tr>`;
 1201:           }).join('')}</tbody>
 1202:         </table></div>`
 1203:       : '<div class="empty">Nenhuma eliminaÃ§Ã£o encontrada.</div>';
 1204:   } catch (error) {
 1205:     $('killfeedTable').innerHTML =
 1206:       `<div class="message error">${esc(error.message)}</div>`;
 1207:   }
 1208: }
 1209: function openModal(title, body, onSave) {
 1210:   $('modalRoot').innerHTML=`
 1211:     <div class="modal-backdrop">
 1212:       <form class="modal" id="activeModal">
 1213:         <h3>${esc(title)}</h3>
 1214:         ${body}
 1215:         <div id="modalError" class="error"></div>
 1216:         <div class="modal-actions">
 1217:           <button type="button" class="btn" id="modalCancel">Cancelar</button>
 1218:           <button type="submit" class="btn btn-primary" id="modalSave">Salvar</button>
 1219:         </div>
 1220:       </form>
 1221:     </div>`;
 1222:   $('modalCancel').addEventListener('click',()=>$('modalRoot').innerHTML='');
 1223:   $('activeModal').addEventListener('submit',async event=>{
 1224:     event.preventDefault();
 1225:     const button=$('modalSave');
 1226:     button.disabled=true;
 1227:     $('modalError').textContent='';
 1228:     try {
 1229:       await onSave();
 1230:       $('modalRoot').innerHTML='';
 1231:     } catch(error) {
 1232:       $('modalError').textContent=error.message;
 1233:       button.disabled=false;
 1234:     }
 1235:   });
 1236: }
 1237: 
 1238: function formatDate(value) {
 1239:   if(!value) return 'â€”';
 1240:   const date=new Date(value);
 1241:   return Number.isNaN(date.getTime()) ? 'â€”' : date.toLocaleString('pt-BR');
 1242: }
 1243: 
 1244: async function initialize() {
 1245:   if(!token) return showLogin();
 1246:   try {
 1247:     const me=await api('/auth/me');
 1248:     admin=me.admin;
 1249:     showApp();
 1250:     await navigate('overview');
 1251:   } catch {
 1252:     logout();
 1253:   }
 1254: }
 1255: 
 1256: initialize();
 1257: checkHealth();
 1258: setInterval(checkHealth,30000);
 1259: </script>
 1260: </body>
 1261: </html>

FIM DA INSPECAO
