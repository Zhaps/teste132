============================================
RAVEN - AUDITORIA PREPARATORIA 6.7.2
Data: 2026-11-20 20:02:07
MODO: SOMENTE LEITURA
============================================

======================================================================
ARQUIVO: src\services\incident-manager.js
======================================================================
'use strict';

const { pool } = require('../db');

const COMPONENTS = new Set([
    'postgresql',
    'killfeed',
    'dayz',
    'host',
    'network',
    'server'
]);

const SEVERITIES = new Set([
    'warning',
    'critical'
]);

function validateIdentity(input) {
    if (!input || typeof input !== 'object' || Array.isArray(input)) {
        throw new Error('INVALID_INCIDENT_INPUT');
    }

    const { component, incidentKey, serverId = null } = input;

    if (!COMPONENTS.has(component)) {
        throw new Error('INVALID_INCIDENT_COMPONENT');
    }

    if (
        typeof incidentKey !== 'string' ||
        !/^[A-Za-z0-9._:-]{1,100}$/.test(incidentKey)
    ) {
        throw new Error('INVALID_INCIDENT_KEY');
    }

    if (
        serverId !== null &&
        (
            typeof serverId !== 'string' ||
            !/^[A-Za-z0-9_-]{1,64}$/.test(serverId)
        )
    ) {
        throw new Error('INVALID_INCIDENT_SERVER_ID');
    }

    return { component, incidentKey, serverId };
}

function validateDetails(details = {}) {
    if (
        !details ||
        typeof details !== 'object' ||
        Array.isArray(details)
    ) {
        throw new Error('INVALID_INCIDENT_DETAILS');
    }

    let serialized;

    try {
        serialized = JSON.stringify(details);
    } catch (_) {
        throw new Error('INVALID_INCIDENT_DETAILS');
    }

    if (
        typeof serialized !== 'string' ||
        Buffer.byteLength(serialized, 'utf8') > 16384
    ) {
        throw new Error('INCIDENT_DETAILS_TOO_LARGE');
    }

    return serialized;
}

function validateTimestamp(value, name) {
    if (value === undefined || value === null) {
        return new Date();
    }

    const date = new Date(value);

    if (Number.isNaN(date.getTime())) {
        throw new Error(`INVALID_${name}`);
    }

    return date;
}

async function openIncident(input) {
    const identity = validateIdentity(input);

    if (!SEVERITIES.has(input.severity)) {
        throw new Error('INVALID_INCIDENT_SEVERITY');
    }

    const details = validateDetails(input.details || {});
    const startedAt = validateTimestamp(
        input.startedAt,
        'INCIDENT_STARTED_AT'
    );

    const result = await pool.query(
        `INSERT INTO public.system_incidents (
            component,
            incident_key,
            server_id,
            severity,
            details,
            started_at,
            last_seen_at
         )
         VALUES ($1, $2, $3, $4, $5::jsonb, $6, NOW())
         ON CONFLICT (
            component,
            incident_key,
            (COALESCE(server_id, ''::VARCHAR))
         )
         WHERE resolved_at IS NULL
         DO UPDATE SET
            severity = EXCLUDED.severity,
            details = public.system_incidents.details || EXCLUDED.details,
            last_seen_at = NOW()
         RETURNING
            id::text,
            component,
            incident_key,
            server_id,
            severity,
            details,
            started_at,
            last_seen_at,
            resolved_at,
            (xmax = 0) AS created`,
        [
            identity.component,
            identity.incidentKey,
            identity.serverId,
            input.severity,
            details,
            startedAt
        ]
    );

    return result.rows[0];
}

async function resolveIncident(input) {
    const identity = validateIdentity(input);
    const details = validateDetails(input.details || {
        recovery: 'Condição normalizada'
    });

    const result = await pool.query(
        `UPDATE public.system_incidents
         SET
            resolved_at = NOW(),
            last_seen_at = NOW(),
            details = details || $4::jsonb
         WHERE component = $1
           AND incident_key = $2
           AND server_id IS NOT DISTINCT FROM $3
           AND resolved_at IS NULL
         RETURNING
            id::text,
            component,
            incident_key,
            server_id,
            severity,
            details,
            started_at,
            last_seen_at,
            resolved_at`,
        [
            identity.component,
            identity.incidentKey,
            identity.serverId,
            details
        ]
    );

    return result.rows[0] || null;
}

async function findOpenIncident(input) {
    const identity = validateIdentity(input);

    const result = await pool.query(
        `SELECT
            id::text,
            component,
            incident_key,
            server_id,
            severity,
            details,
            started_at,
            last_seen_at,
            resolved_at
         FROM public.system_incidents
         WHERE component = $1
           AND incident_key = $2
           AND server_id IS NOT DISTINCT FROM $3
           AND resolved_at IS NULL
         LIMIT 1`,
        [
            identity.component,
            identity.incidentKey,
            identity.serverId
        ]
    );

    return result.rows[0] || null;
}

module.exports = {
    openIncident,
    resolveIncident,
    findOpenIncident
};

======================================================================
ARQUIVO: src\services\incident-monitor.js
======================================================================
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

======================================================================
ARQUIVO: src\routes\health.js
======================================================================
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

======================================================================
ARQUIVO: src\routes\host-metrics.js
======================================================================
'use strict';

const express = require('express');
const { pool } = require('../db');
const requireHostToken = require('../middleware/require-host-token');
const { normalizeHostMetrics } = require('../services/host-metrics-normalizer');

const router = express.Router();

router.post('/:serverId', requireHostToken, async (req, res) => {
    try {
        if (!Buffer.isBuffer(req.body)) {
            return res.status(400).json({ error: 'RAW_JSON_BODY_REQUIRED' });
        }

        let envelope;

        try {
            envelope = JSON.parse(req.body.toString('utf8'));
        } catch (_) {
            return res.status(400).json({ error: 'INVALID_JSON' });
        }

        const serverId = req.params.serverId;

        if (!/^[a-zA-Z0-9_-]{1,64}$/.test(serverId)) {
            return res.status(400).json({ error: 'INVALID_SERVER_ID' });
        }

        if (envelope.server_id !== serverId) {
            return res.status(400).json({ error: 'SERVER_ID_MISMATCH' });
        }

        const metrics = normalizeHostMetrics(envelope);

        const result = await pool.query(
            `INSERT INTO public.server_host_metrics
                (server_id, event_id, occurred_at, computer_name,
                 cpu_usage_percent, memory_total_bytes, memory_used_bytes,
                 memory_available_bytes, memory_used_percent,
                 dayz_status, dayz_process_count, network, processes,
                 payload, payload_hash)
             VALUES
                ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12::jsonb,
                 $13::jsonb,$14::jsonb,$15)
             ON CONFLICT (server_id, event_id) DO NOTHING
             RETURNING id`,
            [
                serverId,
                metrics.eventId,
                metrics.occurredAt,
                metrics.computerName,
                metrics.cpuPercent,
                metrics.memoryTotal,
                metrics.memoryUsed,
                metrics.memoryAvailable,
                metrics.memoryPercent,
                metrics.dayzStatus,
                metrics.dayzProcessCount,
                JSON.stringify(metrics.network),
                JSON.stringify(metrics.processes),
                JSON.stringify(metrics.payload),
                metrics.payloadHash
            ]
        );

        if (result.rowCount === 0) {
            return res.status(200).json({
                status: 'duplicate',
                event_id: metrics.eventId
            });
        }

        req.log.info({
            serverId,
            eventId: metrics.eventId
        }, 'Telemetria Windows recebida');

        return res.status(201).json({
            status: 'accepted',
            event_id: metrics.eventId,
            record_id: String(result.rows[0].id)
        });
    } catch (error) {
        if (
            error.message &&
            (
                error.message.startsWith('INVALID_') ||
                error.message.startsWith('MISSING_')
            )
        ) {
            return res.status(400).json({ error: error.message });
        }

        req.log.error({
            code: error.code,
            message: error.message
        }, 'Falha na ingestao de metricas Windows');

        return res.status(500).json({ error: 'HOST_INGESTION_FAILED' });
    }
});

module.exports = router;

======================================================================
ARQUIVO: src\services\host-metrics-normalizer.js
======================================================================
'use strict';

const crypto = require('node:crypto');

function finiteNumber(value, name, max = Number.MAX_SAFE_INTEGER) {
    if (
        typeof value !== 'number' ||
        !Number.isFinite(value) ||
        value < 0 ||
        value > max
    ) {
        throw new Error(`INVALID_${name}`);
    }

    return value;
}

function normalizeHostMetrics(envelope) {
    if (!envelope || typeof envelope !== 'object' || Array.isArray(envelope)) {
        throw new Error('INVALID_ENVELOPE');
    }

    if (envelope.event_type !== 'host.metrics') {
        throw new Error('INVALID_EVENT_TYPE');
    }

    if (
        typeof envelope.event_id !== 'string' ||
        !/^[A-Za-z0-9._:-]{1,128}$/.test(envelope.event_id)
    ) {
        throw new Error('INVALID_EVENT_ID');
    }

    if (
        typeof envelope.occurred_at !== 'string' ||
        !/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{1,9})?(?:Z|[+-]\d{2}:\d{2})$/.test(envelope.occurred_at)
    ) {
        throw new Error('INVALID_OCCURRED_AT');
    }

    const occurredAt = new Date(envelope.occurred_at);

    if (Number.isNaN(occurredAt.getTime())) {
        throw new Error('INVALID_OCCURRED_AT');
    }

    const payload = envelope.payload;

    if (!payload || typeof payload !== 'object' || Array.isArray(payload)) {
        throw new Error('INVALID_PAYLOAD');
    }

        const cpuData = payload.cpu;

    if (!cpuData || typeof cpuData !== 'object' || Array.isArray(cpuData)) {
        throw new Error('INVALID_CPU');
    }

    const cpu = finiteNumber(cpuData.usage_percent, 'CPU', 100);
    const memory = payload.memory;

    if (!memory || typeof memory !== 'object' || Array.isArray(memory)) {
        throw new Error('INVALID_MEMORY');
    }

    const memoryTotal = finiteNumber(memory.total_bytes, 'MEMORY_TOTAL');
    const memoryUsed = finiteNumber(memory.used_bytes, 'MEMORY_USED');
    const memoryAvailable = finiteNumber(memory.available_bytes, 'MEMORY_AVAILABLE');
    const memoryPercent = finiteNumber(memory.used_percent, 'MEMORY_PERCENT', 100);

    if (memoryUsed > memoryTotal || memoryAvailable > memoryTotal) {
        throw new Error('INVALID_MEMORY_RELATION');
    }

    const dayz = payload.dayz;

    if (!dayz || typeof dayz !== 'object' || Array.isArray(dayz)) {
        throw new Error('INVALID_DAYZ');
    }

    if (!['online', 'offline'].includes(dayz.status)) {
        throw new Error('INVALID_DAYZ_STATUS');
    }

    if (
        !Number.isSafeInteger(dayz.process_count) ||
        dayz.process_count < 0 ||
        dayz.process_count > 100
    ) {
        throw new Error('INVALID_PROCESS_COUNT');
    }

    if (!Array.isArray(payload.network) || payload.network.length > 32) {
        throw new Error('INVALID_NETWORK');
    }

    const network = payload.network.map(adapter => {
        if (
            !adapter ||
            typeof adapter.name !== 'string' ||
            adapter.name.length < 1 ||
            adapter.name.length > 128
        ) {
            throw new Error('INVALID_NETWORK_ADAPTER');
        }

        return {
            name: adapter.name,
            received_bytes_total: finiteNumber(adapter.received_bytes_total ?? adapter.received_bytes, 'RECEIVED_BYTES'),
            sent_bytes_total: finiteNumber(adapter.sent_bytes_total ?? adapter.sent_bytes, 'SENT_BYTES'),
            download_bytes_per_sec: adapter.download_bytes_per_sec === null
                ? null
                : finiteNumber(adapter.download_bytes_per_sec, 'DOWNLOAD_RATE'),
            upload_bytes_per_sec: adapter.upload_bytes_per_sec === null
                ? null
                : finiteNumber(adapter.upload_bytes_per_sec, 'UPLOAD_RATE')
        };
    });

    const dayzProcesses = Array.isArray(dayz.processes)
        ? dayz.processes.slice(0, 100)
        : [];

    const processes = dayzProcesses.map(process => ({
        pid: Number.isSafeInteger(process.pid) && process.pid > 0 ? process.pid : null,
        executable: typeof process.executable === 'string'
            ? process.executable.slice(0, 128)
            : null,
        cpu_time_seconds: process.cpu_time_seconds === null
            ? null
            : finiteNumber(process.cpu_time_seconds, 'PROCESS_CPU'),
        working_set_bytes: process.working_set_bytes === null
            ? null
            : finiteNumber(process.working_set_bytes, 'WORKING_SET'),
        private_memory_bytes: process.private_memory_bytes === null
            ? null
            : finiteNumber(process.private_memory_bytes, 'PRIVATE_MEMORY'),
        started_at: process.started_at || null
    }));

    const host = payload.host;

    if (!host || typeof host !== 'object' || Array.isArray(host)) {
        throw new Error('INVALID_HOST');
    }

    if (
        typeof host.computer_name !== 'string' ||
        host.computer_name.length < 1 ||
        host.computer_name.length > 128
    ) {
        throw new Error('INVALID_COMPUTER_NAME');
    }

    return {
        eventId: envelope.event_id,
        occurredAt: occurredAt.toISOString(),
        cpuPercent: cpu,
        memoryTotal,
        memoryUsed,
        memoryAvailable,
        memoryPercent,
        dayzStatus: dayz.status,
        dayzProcessCount: dayz.process_count,
        computerName: host.computer_name,
        network,
        processes,
        payload: envelope,
        payloadHash: crypto.createHash('sha256')
            .update(JSON.stringify(envelope))
            .digest('hex')
    };
}

module.exports = { normalizeHostMetrics };


======================================================================
ARQUIVO: src\server.js
======================================================================
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
const ingestRoutes = require('./routes/ingest');
const serverStatusRoutes = require('./routes/server-status');
const hostMetricsRoutes = require('./routes/host-metrics');
const hostMetricsQueryRoutes = require('./routes/host-metrics-query');
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

app.use('/api/v1/ingest', express.raw({
    type: 'application/json',
    limit: '64kb'
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
app.use('/api/v1/ingest', ingestRoutes);
app.use('/api/v1/servers', serverStatusRoutes);
app.use('/api/v1/servers', hostMetricsQueryRoutes);
app.use('/api/v1/ingest/host', hostMetricsRoutes);

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



======================================================================
ARQUIVO: migrations\006_incident_core.sql
======================================================================
ALTER TABLE public.system_incidents
    ADD COLUMN incident_key VARCHAR(100),
    ADD COLUMN server_id VARCHAR(64),
    ADD COLUMN last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

UPDATE public.system_incidents
SET incident_key = 'legacy.' || component,
    last_seen_at = COALESCE(resolved_at, started_at);

ALTER TABLE public.system_incidents
    ALTER COLUMN incident_key SET NOT NULL;

DROP INDEX IF EXISTS public.uq_system_incidents_open_component;

ALTER TABLE public.system_incidents
    DROP CONSTRAINT IF EXISTS system_incidents_component_check;

ALTER TABLE public.system_incidents
    ADD CONSTRAINT ck_system_incidents_component
    CHECK (
        component IN (
            'postgresql',
            'killfeed',
            'dayz',
            'host',
            'network',
            'server'
        )
    );

ALTER TABLE public.system_incidents
    ADD CONSTRAINT ck_system_incidents_incident_key
    CHECK (
        length(incident_key) BETWEEN 1 AND 100
    );

ALTER TABLE public.system_incidents
    ADD CONSTRAINT ck_system_incidents_server_id
    CHECK (
        server_id IS NULL OR
        server_id ~ '^[A-Za-z0-9_-]{1,64}$'
    );

CREATE UNIQUE INDEX uq_system_incidents_open_key
ON public.system_incidents (
    component,
    incident_key,
    (COALESCE(server_id, ''::VARCHAR))
)
WHERE resolved_at IS NULL;

CREATE INDEX idx_system_incidents_server
ON public.system_incidents (server_id, started_at DESC)
WHERE server_id IS NOT NULL;

CREATE INDEX idx_system_incidents_key
ON public.system_incidents (incident_key, started_at DESC);

============================================
ESTADO DO POSTGRESQL - CONSULTAS READ ONLY
============================================

 --- TABELAS E COLUNAS DE MONITORAMENTO --- audit_logs.id (bigint) audit_logs.actor_type (character varying) audit_logs.actor_identifier (character varying) audit_logs.actor_admin_id (bigint) audit_logs.action (character varying) audit_logs.entity_type (character varying) audit_logs.entity_id (character varying) audit_logs.details (jsonb) audit_logs.source_ip (inet) audit_logs.created_at (timestamp with time zone) server_host_metrics.id (bigint) server_host_metrics.server_id (character varying) server_host_metrics.event_id (character varying) server_host_metrics.occurred_at (timestamp with time zone) server_host_metrics.received_at (timestamp with time zone) server_host_metrics.computer_name (character varying) server_host_metrics.cpu_usage_percent (numeric) server_host_metrics.memory_total_bytes (bigint) server_host_metrics.memory_used_bytes (bigint) server_host_metrics.memory_available_bytes (bigint) server_host_metrics.memory_used_percent (numeric) server_host_metrics.dayz_status (character varying) server_host_metrics.dayz_process_count (integer) server_host_metrics.network (jsonb) server_host_metrics.processes (jsonb) server_host_metrics.payload (jsonb) server_host_metrics.payload_hash (character varying) server_status_events.id (bigint) server_status_events.server_id (character varying) server_status_events.event_id (character varying) server_status_events.occurred_at (timestamp with time zone) server_status_events.received_at (timestamp with time zone) server_status_events.fps (numeric) server_status_events.uptime_seconds (bigint) server_status_events.players (integer) server_status_events.max_players (integer) server_status_events.steam_queue (integer) server_status_events.payload (jsonb) system_incidents.id (bigint) system_incidents.component (character varying) system_incidents.severity (character varying) system_incidents.details (jsonb) system_incidents.started_at (timestamp with time zone) system_incidents.resolved_at (timestamp with time zone) system_incidents.created_at (timestamp with time zone) system_incidents.incident_key (character varying) system_incidents.server_id (character varying) system_incidents.last_seen_at (timestamp with time zone) system_settings.setting_key (character varying) system_settings.setting_value (jsonb) system_settings.description (text) system_settings.updated_at (timestamp with time zone)  --- CONTAGEM DE REGISTROS --- system_incidents: 1 system_settings: 0 server_host_metrics: 60 server_status_events: 1 audit_logs: 4  --- INCIDENTES ABERTOS --- []  --- CONFIGURACOES EXISTENTES (SOMENTE CHAVES) --- []  --- METRICAS HOST RECENTES --- [   {     "server_id": "nasdara-dayz",     "occurred_at": "2026-11-20T22:43:59.523Z",     "cpu_usage_percent": "0.00",     "memory_used_percent": "61.21",     "dayz_status": "online",     "connectivity": {       "status": "online",       "targets": [         {           "role": "gateway",           "status": "online",           "destination": "192.168.15.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 0,           "latency_max_ms": 0,           "latency_min_ms": 0,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_cloudflare",           "status": "online",           "destination": "1.1.1.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4,           "latency_max_ms": 4,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_google",           "status": "online",           "destination": "8.8.8.8",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 5,           "latency_max_ms": 5,           "latency_min_ms": 5,           "packets_received": 2,           "packet_loss_percent": 0         }       ],       "measured_at": "2026-11-20T22:43:59.9878306Z",       "gateway_status": "online",       "external_targets_total": 2,       "external_targets_online": 2     }   },   {     "server_id": "nasdara-dayz",     "occurred_at": "2026-11-20T22:43:43.958Z",     "cpu_usage_percent": "0.00",     "memory_used_percent": "61.25",     "dayz_status": "online",     "connectivity": {       "status": "online",       "targets": [         {           "role": "gateway",           "status": "online",           "destination": "192.168.15.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 0,           "latency_max_ms": 0,           "latency_min_ms": 0,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_cloudflare",           "status": "online",           "destination": "1.1.1.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4,           "latency_max_ms": 4,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_google",           "status": "online",           "destination": "8.8.8.8",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 5,           "latency_max_ms": 6,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         }       ],       "measured_at": "2026-11-20T22:43:44.4335124Z",       "gateway_status": "online",       "external_targets_total": 2,       "external_targets_online": 2     }   },   {     "server_id": "nasdara-dayz",     "occurred_at": "2026-11-20T22:43:28.414Z",     "cpu_usage_percent": "0.00",     "memory_used_percent": "61.37",     "dayz_status": "online",     "connectivity": {       "status": "online",       "targets": [         {           "role": "gateway",           "status": "online",           "destination": "192.168.15.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 0,           "latency_max_ms": 0,           "latency_min_ms": 0,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_cloudflare",           "status": "online",           "destination": "1.1.1.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4,           "latency_max_ms": 4,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_google",           "status": "online",           "destination": "8.8.8.8",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4.5,           "latency_max_ms": 5,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         }       ],       "measured_at": "2026-11-20T22:43:28.8889557Z",       "gateway_status": "online",       "external_targets_total": 2,       "external_targets_online": 2     }   },   {     "server_id": "nasdara-dayz",     "occurred_at": "2026-11-20T22:43:12.867Z",     "cpu_usage_percent": "0.00",     "memory_used_percent": "61.39",     "dayz_status": "online",     "connectivity": {       "status": "online",       "targets": [         {           "role": "gateway",           "status": "online",           "destination": "192.168.15.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 0,           "latency_max_ms": 0,           "latency_min_ms": 0,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_cloudflare",           "status": "online",           "destination": "1.1.1.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4,           "latency_max_ms": 4,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_google",           "status": "online",           "destination": "8.8.8.8",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 5,           "latency_max_ms": 5,           "latency_min_ms": 5,           "packets_received": 2,           "packet_loss_percent": 0         }       ],       "measured_at": "2026-11-20T22:43:13.3333700Z",       "gateway_status": "online",       "external_targets_total": 2,       "external_targets_online": 2     }   },   {     "server_id": "nasdara-dayz",     "occurred_at": "2026-11-20T22:42:57.211Z",     "cpu_usage_percent": "1.00",     "memory_used_percent": "61.42",     "dayz_status": "online",     "connectivity": {       "status": "online",       "targets": [         {           "role": "gateway",           "status": "online",           "destination": "192.168.15.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 0,           "latency_max_ms": 0,           "latency_min_ms": 0,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_cloudflare",           "status": "online",           "destination": "1.1.1.1",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4,           "latency_max_ms": 4,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         },         {           "role": "external_google",           "status": "online",           "destination": "8.8.8.8",           "packets_lost": 0,           "packets_sent": 2,           "latency_avg_ms": 4.5,           "latency_max_ms": 5,           "latency_min_ms": 4,           "packets_received": 2,           "packet_loss_percent": 0         }       ],       "measured_at": "2026-11-20T22:42:57.7431433Z",       "gateway_status": "online",       "external_targets_total": 2,       "external_targets_online": 2     }   } ]  --- EVENTOS VPP RECENTES --- [   {     "server_id": "raven-selftest",     "event_id": "selftest-fabe3f3ab20a46288b069df1a37dea9d",     "occurred_at": "2026-11-20T20:21:32.382Z",     "fps": "60.000",     "players": 2,     "max_players": 60   } ]  AUDITORIA READ ONLY CONCLUIDA.
