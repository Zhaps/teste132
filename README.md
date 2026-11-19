===========================================================================
ARQUIVO: src\routes\players.js
===========================================================================
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


===========================================================================
ARQUIVO: src\routes\priority.js
===========================================================================
   1: 'use strict';
   2:
   3: const express = require('express');
   4: const { z } = require('zod');
   5:
   6: const { pool } = require('../db');
   7: const { withTransaction } = require('../services/transaction');
   8: const { writeAudit } = require('../services/audit');
   9: const { refreshGrantStatuses } = require('../services/priority-status');
  10: const requireAuth = require('../middleware/require-auth');
  11: const requireRole = require('../middleware/require-role');
  12:
  13: const router = express.Router();
  14:
  15: router.use(requireAuth);
  16:
  17: const grantSchema = z.object({
  18:     steam64: z.string().regex(/^[0-9]{17}$/),
  19:     categoryCode: z.string().trim().toLowerCase()
  20:         .regex(/^[a-z0-9_-]{1,32}$/),
  21:     startsAt: z.string().datetime({ offset: true }).optional(),
  22:     expiresAt: z.union([
  23:         z.string().datetime({ offset: true }),
  24:         z.null()
  25:     ]).optional(),
  26:     reason: z.string().trim().max(500).nullable().optional()
  27: }).strict();
  28:
  29: const renewSchema = z.object({
  30:     expiresAt: z.string().datetime({ offset: true }),
  31:     reason: z.string().trim().max(500).nullable().optional()
  32: }).strict();
  33:
  34: const revokeSchema = z.object({
  35:     reason: z.string().trim().max(500).nullable().optional()
  36: }).strict();
  37:
  38: const listSchema = z.object({
  39:     status: z.enum(['active','scheduled','expired','revoked']).optional(),
  40:     steam64: z.string().regex(/^[0-9]{17}$/).optional(),
  41:     category: z.string().trim().toLowerCase()
  42:         .regex(/^[a-z0-9_-]{1,32}$/).optional(),
  43:     page: z.coerce.number().int().min(1).max(100000).default(1),
  44:     limit: z.coerce.number().int().min(1).max(100).default(25)
  45: }).strict();
  46:
  47: function validId(value) {
  48:     return typeof value === 'string' &&
  49:         /^[1-9][0-9]{0,18}$/.test(value);
  50: }
  51:
  52: function sendOperationError(req, res, error, context) {
  53:     if (error.statusCode) {
  54:         return res.status(error.statusCode).json({
  55:             error: error.codeName || 'OPERATION_REJECTED',
  56:             message: error.message
  57:         });
  58:     }
  59:
  60:     if (error.code === '23505') {
  61:         return res.status(409).json({
  62:             error: 'PRIORITY_ALREADY_EXISTS'
  63:         });
  64:     }
  65:
  66:     req.log.error({ error }, context);
  67:
  68:     return res.status(500).json({
  69:         error: 'PRIORITY_OPERATION_ERROR'
  70:     });
  71: }
  72:
  73: function operationError(statusCode, codeName, message) {
  74:     const error = new Error(message);
  75:     error.statusCode = statusCode;
  76:     error.codeName = codeName;
  77:     return error;
  78: }
  79:
  80: /* CATEGORIAS */
  81:
  82: router.get('/categories', async (req, res) => {
  83:     try {
  84:         const result = await pool.query(
  85:             `SELECT id, code, name, description, display_order
  86:              FROM public.priority_categories
  87:              WHERE is_active = TRUE
  88:              ORDER BY display_order`
  89:         );
  90:
  91:         return res.json({ categories: result.rows });
  92:     } catch (error) {
  93:         req.log.error({ error }, 'Falha ao listar categorias');
  94:
  95:         return res.status(500).json({
  96:             error: 'CATEGORY_LIST_ERROR'
  97:         });
  98:     }
  99: });
 100:
 101: /* PRIORIDADES EFETIVAS */
 102:
 103: router.get('/effective', async (req, res) => {
 104:     try {
 105:         const players = await withTransaction(async client => {
 106:             await refreshGrantStatuses(client);
 107:
 108:             const result = await client.query(`
 109:                 SELECT DISTINCT
 110:                     p.steam64,
 111:                     p.display_name
 112:                 FROM public.priority_grants g
 113:                 JOIN public.players p ON p.id = g.player_id
 114:                 WHERE g.status = 'active'
 115:                   AND g.starts_at <= NOW()
 116:                   AND (g.expires_at IS NULL OR g.expires_at > NOW())
 117:                 ORDER BY p.steam64
 118:             `);
 119:
 120:             return result.rows;
 121:         });
 122:
 123:         return res.json({
 124:             count: players.length,
 125:             players
 126:         });
 127:     } catch (error) {
 128:         req.log.error({ error }, 'Falha ao consultar fila efetiva');
 129:
 130:         return res.status(500).json({
 131:             error: 'EFFECTIVE_QUEUE_ERROR'
 132:         });
 133:     }
 134: });
 135:
 136: /* LISTAR CONCESSOES */
 137:
 138: router.get('/grants', async (req, res) => {
 139:     const parsed = listSchema.safeParse(req.query);
 140:
 141:     if (!parsed.success) {
 142:         return res.status(400).json({ error: 'INVALID_QUERY' });
 143:     }
 144:
 145:     const { status, steam64, category, page, limit } = parsed.data;
 146:
 147:     try {
 148:         await withTransaction(refreshGrantStatuses);
 149:
 150:         const conditions = [];
 151:         const values = [];
 152:
 153:         if (status) {
 154:             values.push(status);
 155:             conditions.push(`g.status = $${values.length}`);
 156:         }
 157:
 158:         if (steam64) {
 159:             values.push(steam64);
 160:             conditions.push(`p.steam64 = $${values.length}`);
 161:         }
 162:
 163:         if (category) {
 164:             values.push(category);
 165:             conditions.push(`c.code = $${values.length}`);
 166:         }
 167:
 168:         const where = conditions.length
 169:             ? `WHERE ${conditions.join(' AND ')}`
 170:             : '';
 171:
 172:         const count = await pool.query(
 173:             `SELECT COUNT(*)::integer AS total
 174:              FROM public.priority_grants g
 175:              JOIN public.players p ON p.id = g.player_id
 176:              JOIN public.priority_categories c ON c.id = g.category_id
 177:              ${where}`,
 178:             values
 179:         );
 180:
 181:         const offset = (page - 1) * limit;
 182:         const queryValues = [...values, limit, offset];
 183:         const limitPosition = values.length + 1;
 184:         const offsetPosition = values.length + 2;
 185:
 186:         const result = await pool.query(
 187:             `SELECT
 188:                 g.id::text,
 189:                 p.steam64,
 190:                 p.display_name,
 191:                 c.code AS category_code,
 192:                 c.name AS category_name,
 193:                 g.status,
 194:                 g.grant_source,
 195:                 g.reason,
 196:                 g.starts_at,
 197:                 g.expires_at,
 198:                 g.created_at,
 199:                 g.updated_at
 200:              FROM public.priority_grants g
 201:              JOIN public.players p ON p.id = g.player_id
 202:              JOIN public.priority_categories c ON c.id = g.category_id
 203:              ${where}
 204:              ORDER BY g.created_at DESC
 205:              LIMIT $${limitPosition} OFFSET $${offsetPosition}`,
 206:             queryValues
 207:         );
 208:
 209:         return res.json({
 210:             page,
 211:             limit,
 212:             total: count.rows[0].total,
 213:             grants: result.rows
 214:         });
 215:     } catch (error) {
 216:         req.log.error({ error }, 'Falha ao listar prioridades');
 217:
 218:         return res.status(500).json({
 219:             error: 'GRANT_LIST_ERROR'
 220:         });
 221:     }
 222: });
 223:
 224: /* CONCEDER PRIORIDADE */
 225:
 226: router.post(
 227:     '/grants',
 228:     requireRole('owner', 'admin', 'moderator'),
 229:     async (req, res) => {
 230:         const parsed = grantSchema.safeParse(req.body);
 231:
 232:         if (!parsed.success) {
 233:             return res.status(400).json({
 234:                 error: 'INVALID_GRANT_DATA',
 235:                 details: parsed.error.issues.map(issue => ({
 236:                     field: issue.path.join('.'),
 237:                     message: issue.message
 238:                 }))
 239:             });
 240:         }
 241:
 242:         const input = parsed.data;
 243:         const startsAt = input.startsAt
 244:             ? new Date(input.startsAt)
 245:             : new Date();
 246:
 247:         const expiresAt = input.expiresAt
 248:             ? new Date(input.expiresAt)
 249:             : null;
 250:
 251:         if (expiresAt && expiresAt <= startsAt) {
 252:             return res.status(400).json({
 253:                 error: 'INVALID_EXPIRATION_DATE'
 254:             });
 255:         }
 256:
 257:         const status = startsAt > new Date()
 258:             ? 'scheduled'
 259:             : 'active';
 260:
 261:         try {
 262:             const grant = await withTransaction(async client => {
 263:                 await refreshGrantStatuses(client);
 264:
 265:                 const playerResult = await client.query(
 266:                     `SELECT id FROM public.players
 267:                      WHERE steam64 = $1`,
 268:                     [input.steam64]
 269:                 );
 270:
 271:                 if (playerResult.rowCount === 0) {
 272:                     throw operationError(
 273:                         404,
 274:                         'PLAYER_NOT_FOUND',
 275:                         'Cadastre o jogador antes de conceder prioridade.'
 276:                     );
 277:                 }
 278:
 279:                 const categoryResult = await client.query(
 280:                     `SELECT id, code
 281:                      FROM public.priority_categories
 282:                      WHERE code = $1 AND is_active = TRUE`,
 283:                     [input.categoryCode]
 284:                 );
 285:
 286:                 if (categoryResult.rowCount === 0) {
 287:                     throw operationError(
 288:                         404,
 289:                         'CATEGORY_NOT_FOUND',
 290:                         'Categoria inexistente ou inativa.'
 291:                     );
 292:                 }
 293:
 294:                 const result = await client.query(
 295:                     `INSERT INTO public.priority_grants
 296:                         (player_id, category_id, status,
 297:                          grant_source, reason, starts_at, expires_at,
 298:                          granted_by_admin_id)
 299:                      VALUES ($1,$2,$3,'web',$4,$5,$6,$7)
 300:                      RETURNING id::text, status, starts_at, expires_at`,
 301:                     [
 302:                         playerResult.rows[0].id,
 303:                         categoryResult.rows[0].id,
 304:                         status,
 305:                         input.reason || null,
 306:                         startsAt,
 307:                         expiresAt,
 308:                         req.admin.id
 309:                     ]
 310:                 );
 311:
 312:                 const created = result.rows[0];
 313:
 314:                 await writeAudit(client, {
 315:                     actorType: 'admin',
 316:                     actorIdentifier: req.admin.username,
 317:                     actorAdminId: req.admin.id,
 318:                     action: 'priority.granted',
 319:                     entityType: 'priority_grant',
 320:                     entityId: created.id,
 321:                     details: {
 322:                         steam64: input.steam64,
 323:                         category: input.categoryCode,
 324:                         status: created.status,
 325:                         expiresAt: created.expires_at
 326:                     },
 327:                     sourceIp: req.ip
 328:                 });
 329:
 330:                 return created;
 331:             });
 332:
 333:             return res.status(201).json({ grant });
 334:         } catch (error) {
 335:             return sendOperationError(
 336:                 req, res, error, 'Falha ao conceder prioridade'
 337:             );
 338:         }
 339:     }
 340: );
 341:
 342: /* RENOVAR PRIORIDADE */
 343:
 344: router.post(
 345:     '/grants/:id/renew',
 346:     requireRole('owner', 'admin', 'moderator'),
 347:     async (req, res) => {
 348:         if (!validId(req.params.id)) {
 349:             return res.status(400).json({ error: 'INVALID_GRANT_ID' });
 350:         }
 351:
 352:         const parsed = renewSchema.safeParse(req.body);
 353:
 354:         if (!parsed.success) {
 355:             return res.status(400).json({
 356:                 error: 'INVALID_RENEWAL_DATA'
 357:             });
 358:         }
 359:
 360:         const newExpiry = new Date(parsed.data.expiresAt);
 361:
 362:         try {
 363:             const grant = await withTransaction(async client => {
 364:                 await refreshGrantStatuses(client);
 365:
 366:                 const current = await client.query(
 367:                     `SELECT g.id, g.status, g.starts_at, g.expires_at,
 368:                             p.steam64, c.code AS category_code
 369:                      FROM public.priority_grants g
 370:                      JOIN public.players p ON p.id = g.player_id
 371:                      JOIN public.priority_categories c ON c.id = g.category_id
 372:                      WHERE g.id = $1
 373:                      FOR UPDATE OF g`,
 374:                     [req.params.id]
 375:                 );
 376:
 377:                 if (current.rowCount === 0) {
 378:                     throw operationError(404, 'GRANT_NOT_FOUND', 'Concessao nao encontrada.');
 379:                 }
 380:
 381:                 const old = current.rows[0];
 382:
 383:                 if (!['active', 'scheduled'].includes(old.status)) {
 384:                     throw operationError(409, 'GRANT_NOT_RENEWABLE', 'Concessao nao esta ativa ou agendada.');
 385:                 }
 386:
 387:                 if (old.expires_at === null) {
 388:                     throw operationError(409, 'GRANT_IS_PERMANENT', 'Concessao permanente nao precisa de renovacao.');
 389:                 }
 390:
 391:                 if (
 392:                     newExpiry <= new Date(old.expires_at) ||
 393:                     newExpiry <= new Date(old.starts_at)
 394:                 ) {
 395:                     throw operationError(400, 'INVALID_RENEWAL_DATE', 'A nova validade deve ser posterior a validade atual.');
 396:                 }
 397:
 398:                 const result = await client.query(
 399:                     `UPDATE public.priority_grants
 400:                      SET expires_at = $1,
 401:                          reason = COALESCE($2, reason),
 402:                          status = CASE
 403:                              WHEN starts_at > NOW() THEN 'scheduled'
 404:                              ELSE 'active'
 405:                          END
 406:                      WHERE id = $3
 407:                      RETURNING id::text, status, starts_at, expires_at`,
 408:                     [
 409:                         newExpiry,
 410:                         parsed.data.reason || null,
 411:                         req.params.id
 412:                     ]
 413:                 );
 414:
 415:                 const updated = result.rows[0];
 416:
 417:                 await writeAudit(client, {
 418:                     actorType: 'admin',
 419:                     actorIdentifier: req.admin.username,
 420:                     actorAdminId: req.admin.id,
 421:                     action: 'priority.renewed',
 422:                     entityType: 'priority_grant',
 423:                     entityId: updated.id,
 424:                     details: {
 425:                         steam64: old.steam64,
 426:                         category: old.category_code,
 427:                         previousExpiry: old.expires_at,
 428:                         newExpiry: updated.expires_at
 429:                     },
 430:                     sourceIp: req.ip
 431:                 });
 432:
 433:                 return updated;
 434:             });
 435:
 436:             return res.json({ grant });
 437:         } catch (error) {
 438:             return sendOperationError(
 439:                 req, res, error, 'Falha ao renovar prioridade'
 440:             );
 441:         }
 442:     }
 443: );
 444:
 445: /* REVOGAR PRIORIDADE */
 446:
 447: router.patch(
 448:     '/grants/:id/revoke',
 449:     requireRole('owner', 'admin', 'moderator'),
 450:     async (req, res) => {
 451:         if (!validId(req.params.id)) {
 452:             return res.status(400).json({ error: 'INVALID_GRANT_ID' });
 453:         }
 454:
 455:         const parsed = revokeSchema.safeParse(req.body || {});
 456:
 457:         if (!parsed.success) {
 458:             return res.status(400).json({
 459:                 error: 'INVALID_REVOCATION_DATA'
 460:             });
 461:         }
 462:
 463:         try {
 464:             const grant = await withTransaction(async client => {
 465:                 await refreshGrantStatuses(client);
 466:
 467:                 const current = await client.query(
 468:                     `SELECT g.id, g.status, p.steam64, c.code AS category_code
 469:                      FROM public.priority_grants g
 470:                      JOIN public.players p ON p.id = g.player_id
 471:                      JOIN public.priority_categories c ON c.id = g.category_id
 472:                      WHERE g.id = $1
 473:                      FOR UPDATE OF g`,
 474:                     [req.params.id]
 475:                 );
 476:
 477:                 if (current.rowCount === 0) {
 478:                     throw operationError(404, 'GRANT_NOT_FOUND', 'Concessao nao encontrada.');
 479:                 }
 480:
 481:                 const old = current.rows[0];
 482:
 483:                 if (!['active', 'scheduled'].includes(old.status)) {
 484:                     throw operationError(409, 'GRANT_NOT_REVOCABLE', 'Concessao nao esta ativa ou agendada.');
 485:                 }
 486:
 487:                 const result = await client.query(
 488:                     `UPDATE public.priority_grants
 489:                      SET status = 'revoked',
 490:                          revoked_at = NOW(),
 491:                          revoked_by_admin_id = $1,
 492:                          reason = COALESCE($2, reason)
 493:                      WHERE id = $3
 494:                      RETURNING id::text, status, revoked_at`,
 495:                     [
 496:                         req.admin.id,
 497:                         parsed.data.reason || null,
 498:                         req.params.id
 499:                     ]
 500:                 );
 501:
 502:                 const revoked = result.rows[0];
 503:
 504:                 await writeAudit(client, {
 505:                     actorType: 'admin',
 506:                     actorIdentifier: req.admin.username,
 507:                     actorAdminId: req.admin.id,
 508:                     action: 'priority.revoked',
 509:                     entityType: 'priority_grant',
 510:                     entityId: revoked.id,
 511:                     details: {
 512:                         steam64: old.steam64,
 513:                         category: old.category_code,
 514:                         reason: parsed.data.reason || null
 515:                     },
 516:                     sourceIp: req.ip
 517:                 });
 518:
 519:                 return revoked;
 520:             });
 521:
 522:             return res.json({ grant });
 523:         } catch (error) {
 524:             return sendOperationError(
 525:                 req, res, error, 'Falha ao revogar prioridade'
 526:             );
 527:         }
 528:     }
 529: );
 530:
 531: module.exports = router;


===========================================================================
ARQUIVO: src\middleware\require-auth.js
===========================================================================
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


===========================================================================
ARQUIVO: src\middleware\require-role.js
===========================================================================
   1: 'use strict';
   2:
   3: module.exports = (...allowedRoles) => {
   4:     return (req, res, next) => {
   5:         if (!req.admin) {
   6:             return res.status(401).json({ error: 'AUTHENTICATION_REQUIRED' });
   7:         }
   8:
   9:         if (!allowedRoles.includes(req.admin.role)) {
  10:             return res.status(403).json({ error: 'INSUFFICIENT_PERMISSIONS' });
  11:         }
  12:
  13:         return next();
  14:     };
  15: };


===========================================================================
ARQUIVO: src\services\auth.js
===========================================================================
   1: 'use strict';
   2:
   3: const secret = Buffer.from(
   4:     process.env.AUTH_JWT_SECRET_B64 || '',
   5:     'base64'
   6: );
   7:
   8: if (secret.length !== 32) {
   9:     throw new Error('Chave JWT invalida.');
  10: }
  11:
  12: const issuer = 'raven-control-api';
  13: const audience = 'raven-control-dashboard';
  14:
  15: async function createAccessToken(admin) {
  16:     const { SignJWT } = await import('jose');
  17:
  18:     const ttl = Number(
  19:         process.env.AUTH_ACCESS_TTL_SECONDS || 900
  20:     );
  21:
  22:     if (!Number.isInteger(ttl) || ttl < 60 || ttl > 3600) {
  23:         throw new Error('Validade JWT invalida.');
  24:     }
  25:
  26:     return new SignJWT({
  27:         role: admin.access_role
  28:     })
  29:         .setProtectedHeader({ alg: 'HS256', typ: 'JWT' })
  30:         .setSubject(String(admin.id))
  31:         .setIssuer(issuer)
  32:         .setAudience(audience)
  33:         .setIssuedAt()
  34:         .setExpirationTime(`${ttl}s`)
  35:         .sign(secret);
  36: }
  37:
  38: async function verifyAccessToken(token) {
  39:     const { jwtVerify } = await import('jose');
  40:
  41:     const result = await jwtVerify(token, secret, {
  42:         issuer,
  43:         audience,
  44:         algorithms: ['HS256']
  45:     });
  46:
  47:     return result.payload;
  48: }
  49:
  50: module.exports = {
  51:     createAccessToken,
  52:     verifyAccessToken
  53: };


===========================================================================
ARQUIVO: src\services\transaction.js
===========================================================================
   1: 'use strict';
   2:
   3: const { pool } = require('../db');
   4:
   5: async function withTransaction(callback) {
   6:     const client = await pool.connect();
   7:
   8:     try {
   9:         await client.query('BEGIN');
  10:
  11:         const result = await callback(client);
  12:
  13:         await client.query('COMMIT');
  14:         return result;
  15:     } catch (error) {
  16:         await client.query('ROLLBACK');
  17:         throw error;
  18:     } finally {
  19:         client.release();
  20:     }
  21: }
  22:
  23: module.exports = { withTransaction };

===== AUDITORIA CONCLUIDA =====
PS C:\RavenRP\ControlCenter\API>
