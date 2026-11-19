# RAVEN CONTROL CENTER - CORRECAO PRIORITY QUEUE
# Executar no PowerShell. Altera somente fontes da API e cria uma migracao.
# NAO inicia/encerra servidores, NAO altera priority.txt e NAO aplica migracoes.

$ErrorActionPreference = 'Stop'
$ApiRoot = 'C:\RavenRP\ControlCenter\API'
$Desktop = [Environment]::GetFolderPath('Desktop')
$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$BackupDir = Join-Path $Desktop "RAVEN_PRIORITY_BACKUP_$Stamp"
$ReportPath = Join-Path $Desktop 'RAVEN_PRIORITY_CORRECTION_REPORT.txt'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$ChangedFiles = New-Object System.Collections.Generic.List[string]
$BackupMap = @{}
$Report = New-Object System.Collections.Generic.List[string]

function Add-Report([string]$Line) {
    $Report.Add($Line)
    Write-Host $Line
}

function Save-Backup([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Arquivo esperado nao encontrado: $Path"
    }
    $relative = $Path.Substring($ApiRoot.Length).TrimStart('\')
    $backupPath = Join-Path $BackupDir $relative
    $backupParent = Split-Path -Parent $backupPath
    New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
    Copy-Item -LiteralPath $Path -Destination $backupPath -Force
    $BackupMap[$Path] = $backupPath
}

function Replace-Exact([string]$Path, [string]$Old, [string]$New, [string]$Description) {
    $content = [System.IO.File]::ReadAllText($Path)
    $count = ([regex]::Matches($content, [regex]::Escape($Old))).Count
    if ($count -ne 1) {
        throw "A substituicao '$Description' esperava 1 ocorrencia, encontrou $count. Nenhuma alteracao adicional sera feita."
    }
    $updated = $content.Replace($Old, $New)
    [System.IO.File]::WriteAllText($Path, $updated, $Utf8NoBom)
    if (-not $ChangedFiles.Contains($Path)) { $ChangedFiles.Add($Path) }
    Add-Report "ALTERADO: $Description"
}

try {
    Add-Report 'RAVEN CONTROL CENTER - CORRECAO PRIORITY QUEUE'
    Add-Report "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Add-Report "API: $ApiRoot"
    Add-Report 'Modo: alteracao controlada de codigo + testes direcionados'
    Add-Report 'Servidor DayZ: nenhuma acao sera executada'
    Add-Report ''

    if (-not (Test-Path -LiteralPath $ApiRoot -PathType Container)) {
        throw "Diretorio da API nao encontrado: $ApiRoot"
    }

    $CanonicalServerDir = 'C:\\RavenRP\\DayZServer'
    if (-not (Test-Path -LiteralPath $CanonicalServerDir -PathType Container)) {
        throw "Diretorio operacional do DayZ nao encontrado: $CanonicalServerDir. Nenhuma alteracao sera aplicada."
    }
    Add-Report "Diretorio operacional confirmado: $CanonicalServerDir"

    $syncPath = Join-Path $ApiRoot 'src\services\priority-sync.js'
    $migrationPath = Join-Path $ApiRoot 'migrations\004_priority_sync_statuses.sql'
    $guardTestPath = Join-Path $ApiRoot 'src\services\priority-sync-guard.test.js'
    $formatTestPath = Join-Path $ApiRoot 'src\services\priority-sync.test.js'

    if (Test-Path -LiteralPath $migrationPath) {
        throw "A migracao 004 ja existe. O script nao ira sobrescreve-la: $migrationPath"
    }
    if (Test-Path -LiteralPath $guardTestPath) {
        throw "O teste priority-sync-guard.test.js ja existe. O script nao ira sobrescreve-lo."
    }

    $required = @(
        $syncPath,
        $formatTestPath,
        (Join-Path $ApiRoot 'src\services\priority-sync-guard.js'),
        (Join-Path $ApiRoot 'src\services\priority-scheduler.js'),
        (Join-Path $ApiRoot 'src\routes\priority.js'),
        (Join-Path $ApiRoot 'src\server.js'),
        (Join-Path $ApiRoot 'migrations\001_initial_schema.sql'),
        (Join-Path $ApiRoot 'migrations\002_priority_integrity.sql'),
        (Join-Path $ApiRoot 'migrations\003_system_incidents.sql')
    )
    foreach ($file in $required) {
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
            throw "Arquivo obrigatorio ausente: $file"
        }
    }

    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Save-Backup $syncPath
    Save-Backup $formatTestPath

    $oldTarget = "const TARGET_DIR = path.resolve(__dirname, '../../../../DayZServer');"
    $newTarget = "const TARGET_DIR = path.resolve('C:\\RavenRP\\DayZServer');"
    Replace-Exact $syncPath $oldTarget $newTarget 'Destino operacional da fila para C:\RavenRP\DayZServer'

    $oldLockVars = @'
    let locked = false;
    let runId = null;
'@
    $newLockVars = @'
    let locked = false;
    let destroyClient = false;
    let runId = null;
'@
    Replace-Exact $syncPath $oldLockVars $newLockVars 'Controle de descarte de conexao com lock possivelmente preso'

    $oldLockBlock = @'
        if (!locked) {
            return { status: 'skipped', reason: 'SYNC_ALREADY_RUNNING' };
        }

        const started = await client.query(
'@
    $newLockBlock = @'
        if (!locked) {
            return { status: 'skipped', reason: 'SYNC_ALREADY_RUNNING' };
        }

        // Com o advisory lock adquirido, nenhuma sincronizacao cooperante
        // esta ativa. Registros running restantes sao execucoes abandonadas.
        await client.query(`
            UPDATE public.queue_sync_runs
            SET status = 'failed',
                error_message = 'Execucao anterior interrompida antes da conclusao.',
                finished_at = NOW()
            WHERE status = 'running'
        `);

        const started = await client.query(
'@
    Replace-Exact $syncPath $oldLockBlock $newLockBlock 'Recuperacao de execucoes running abandonadas apos adquirir lock'

    $oldStatusBlock = @'
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
'@
    $newStatusBlock = @'
        const finalStatus = dryRun
            ? 'dry_run'
            : (emptyListProtected ? 'blocked' : 'success');

        await client.query(
            `UPDATE public.queue_sync_runs
             SET status = $1,
                 players_count = $2,
                 file_checksum = $3,
                 error_message = $4,
                 finished_at = NOW()
             WHERE id = $5`,
            [
                finalStatus,
                result.rows.length,
                checksum,
                emptyListProtected ? 'EMPTY_PRIORITY_LIST_PROTECTED' : null,
                runId
            ]
        );

        const response = {
            status: finalStatus,
'@
    Replace-Exact $syncPath $oldStatusBlock $newStatusBlock 'Estados distintos para DRY-RUN, LIVE bloqueado e LIVE concluido'

    $oldUnlockBlock = @'
            } catch (error) {
                logger.error({ error }, 'Falha ao liberar lock da sincronizacao');
            }
        }

        client.release();
'@
    $newUnlockBlock = @'
            } catch (error) {
                // Nao devolver ao pool uma sessao que pode continuar segurando
                // o advisory lock. O pg remove a conexao marcada como destruida.
                destroyClient = true;
                logger.error({ error }, 'Falha ao liberar lock da sincronizacao; conexao sera descartada');
            }
        }

        client.release(destroyClient);
'@
    Replace-Exact $syncPath $oldUnlockBlock $newUnlockBlock 'Descarte da conexao se a liberacao do advisory lock falhar'

    $migration = @'
-- Priority Queue: estados explicitos para simulacao e bloqueio de seguranca.
-- Esta migracao e criada, mas NAO e aplicada automaticamente pelo script.
ALTER TABLE public.queue_sync_runs
    DROP CONSTRAINT IF EXISTS queue_sync_runs_status_check;

ALTER TABLE public.queue_sync_runs
    ADD CONSTRAINT queue_sync_runs_status_check
    CHECK (status IN ('running', 'dry_run', 'success', 'blocked', 'failed'));
'@
    [System.IO.File]::WriteAllText($migrationPath, $migration + [Environment]::NewLine, $Utf8NoBom)
    $ChangedFiles.Add($migrationPath)
    Add-Report 'CRIADO: migrations\004_priority_sync_statuses.sql'

    $guardTest = @'
'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');

const { shouldBlockEmptyPriorityWrite } = require('./priority-sync-guard');

test('bloqueia lista vazia por padrao', () => {
    assert.equal(shouldBlockEmptyPriorityWrite('', false), true);
    assert.equal(shouldBlockEmptyPriorityWrite('', undefined), true);
});

test('permite lista vazia somente com autorizacao explicita', () => {
    assert.equal(shouldBlockEmptyPriorityWrite('', true), false);
});

test('nao bloqueia lista preenchida', () => {
    assert.equal(shouldBlockEmptyPriorityWrite('76561198000000001', false), false);
    assert.equal(shouldBlockEmptyPriorityWrite('76561198000000001', true), false);
});

test('rejeita conteudo que nao seja texto', () => {
    assert.throws(
        () => shouldBlockEmptyPriorityWrite(null, false),
        /Conteudo da lista/
    );
});
'@
    [System.IO.File]::WriteAllText($guardTestPath, $guardTest + [Environment]::NewLine, $Utf8NoBom)
    $ChangedFiles.Add($guardTestPath)
    Add-Report 'CRIADO: src\services\priority-sync-guard.test.js'

    Add-Report ''
    Add-Report 'Executando testes direcionados, sem banco de dados e sem servidor DayZ...'
    Push-Location $ApiRoot
    try {
        $testOutput = & node --test 'src/services/priority-sync.test.js' 'src/services/priority-sync-guard.test.js' 2>&1
        $testExit = $LASTEXITCODE
        foreach ($line in $testOutput) { Add-Report ([string]$line) }
        if ($testExit -ne 0) {
            throw "Testes direcionados falharam. Codigo de saida: $testExit"
        }
    }
    finally {
        Pop-Location
    }

    Add-Report ''
    Add-Report 'RESULTADO: ALTERACOES APLICADAS E TESTES DIRECIONADOS APROVADOS.'
    Add-Report "Backup original: $BackupDir"
    Add-Report 'A migracao 004 NAO foi aplicada ao PostgreSQL.'
    Add-Report 'A API NAO foi reiniciada.'
    Add-Report 'O servidor DayZ NAO foi parado, iniciado ou reiniciado.'
    Add-Report 'O arquivo priority.txt NAO foi lido, criado, removido ou alterado.'
}
catch {
    Add-Report ''
    Add-Report "ERRO: $($_.Exception.Message)"
    Add-Report 'Iniciando restauracao dos arquivos alterados...'
    foreach ($file in ($ChangedFiles | Select-Object -Reverse)) {
        if ($BackupMap.ContainsKey($file) -and (Test-Path -LiteralPath $BackupMap[$file])) {
            Copy-Item -LiteralPath $BackupMap[$file] -Destination $file -Force
            Add-Report "RESTAURADO: $file"
        }
        elseif (Test-Path -LiteralPath $file) {
            Remove-Item -LiteralPath $file -Force
            Add-Report "REMOVIDO arquivo novo: $file"
        }
    }
    Add-Report 'As alteracoes desta execucao foram revertidas quando possivel.'
    Add-Report "Backup preservado em: $BackupDir"
}
finally {
    $Report | Set-Content -LiteralPath $ReportPath -Encoding UTF8
    Write-Host ''
    Write-Host "Relatorio: $ReportPath"
    if (Test-Path -LiteralPath $BackupDir) {
        Write-Host "Backup: $BackupDir"
    }
}

if ($Report -match 'RESULTADO: ALTERACOES APLICADAS') {
    Write-Host 'Concluido. Envie o relatorio para revisao antes de aplicar a migracao ou testar LIVE.' -ForegroundColor Green
}
else {
    throw "A correcao nao foi concluida. Consulte $ReportPath"
}
