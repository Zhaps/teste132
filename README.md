**********************
Início da transcrição do Windows PowerShell
Hora de início: 20261119141335
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
Transcrição iniciada, o arquivo de saída é C:\Users\Nasdara\Desktop\Raven_Auditoria_Comparativa_KillFeed.txt

===========================================================================
RAVEN - AUDITORIA COMPARATIVA DO KILLFEED
===========================================================================
Data: 2026-11-19 14:13:35
Computador: DESKTOP-LDECQT3
Relatorio: C:\Users\Nasdara\Desktop\Raven_Auditoria_Comparativa_KillFeed.txt
Modo: SOMENTE LEITURA

===========================================================================
1. EXISTENCIA DAS INSTALACOES
===========================================================================

DIRETORIO: C:\RavenRP\Discord-KillFeed
EXISTE: SIM
CRIACAO: 11/16/2026 13:43:41
MODIFICACAO: 11/16/2026 16:37:57

DIRETORIO: C:\DayZ\dayz-discord-killfeed
EXISTE: NAO

===========================================================================
2. INVENTARIO E HASHES
===========================================================================

INSTALACAO: C:\RavenRP\Discord-KillFeed
.env | 522 bytes | FDFF0F87DC2F78C105C191FDC775518D06FEC1D8A0C1001884D0349FF51E9477
.env.example | 438 bytes | 37F275448A75DC761EEB39CD334D250DE9464E308860DEC25CADB1EC13845533
.gitignore | 46 bytes | 09F4BB580DC8C1143289755E2BCD5D9B6E3315F9FF988AA0F83B580BB4D506AB
install.bat | 408 bytes | E48F18BFAE3F878FBF6969C8A05C69597AB2F4C68253CE00A170D07F1346F95C
README.md | 4245 bytes | 63AFED8F15345082645FF2CB6E6BBA1BFBEDE8E2BE9C9E5DCD1C0219F820F0C5
requirements.txt | 64 bytes | 2C4416BB2BEEBBB1F090908E61E671EDD45CEF73A129926D184152A7512557AE
start-killfeed.bat | 0 bytes | E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
start.bat | 166 bytes | B559C31B4FEAF0D3096885AE8F5525B4FF89B354E77C6826CD4453AFEBA4D660
killfeed\database.py | 2663 bytes | D53AB9BEE554DB9F1D2FBE68693904AF52467F34CE0DB18E71A24A72A1599FD2
killfeed\discord.py | 2311 bytes | 1922D50DCE3617451AC831531B9FA2546FE31061D340B505D3FE0A22366C4D33
killfeed\monitor.py | 3372 bytes | DD63370F121927C6A3FB2A5743AF6E0AEDC8511B67B1E258B7BB8110F93EA43E
killfeed\parser.py | 3276 bytes | 3F45E62DC4B2DE5473D226F0BEFC0E67EBE8E2AAA607239C3449B90478C7581D
killfeed\__init__.py | 30 bytes | 28C7761088AC0A03C415551FE125C771A2C1AD2F5701D3235D15CA54C1A5FBF9
killfeed\__main__.py | 2521 bytes | 812269625544AB37DEAAAA2701FE0D3D47659D9FFD8D53139A2B6D4CFF401985
sql\schema.sql | 758 bytes | 2BA26761FA7F3B939F958F886912A1F938C426CA11A001D6AA32596128AC30F7

===========================================================================
3. COMPARACAO DOS ARQUIVOS ENTRE INSTALACOES
===========================================================================
SOMENTE NA OFICIAL: .env
SOMENTE NA OFICIAL: .env.example
SOMENTE NA OFICIAL: .gitignore
SOMENTE NA OFICIAL: install.bat
SOMENTE NA OFICIAL: killfeed\__init__.py
SOMENTE NA OFICIAL: killfeed\__main__.py
SOMENTE NA OFICIAL: killfeed\database.py
SOMENTE NA OFICIAL: killfeed\discord.py
SOMENTE NA OFICIAL: killfeed\monitor.py
SOMENTE NA OFICIAL: killfeed\parser.py
SOMENTE NA OFICIAL: readme.md
SOMENTE NA OFICIAL: requirements.txt
SOMENTE NA OFICIAL: sql\schema.sql
SOMENTE NA OFICIAL: start.bat
SOMENTE NA OFICIAL: start-killfeed.bat

===========================================================================
4. CODIGO-FONTE E CONFIGURACOES RELEVANTES
===========================================================================

ANALISANDO: C:\RavenRP\Discord-KillFeed

ARQUIVO: C:\RavenRP\Discord-KillFeed\install.bat
    1: @echo off
    2: cd /d "%~dp0"
    3: py -3.11 -m venv .venv
    4: if errorlevel 1 goto error
    5: .venv\Scripts\python.exe -m pip install --upgrade pip
    6: .venv\Scripts\pip.exe install -r requirements.txt
    7: if not exist .env copy .env.example .env
    8: echo.
    9: echo Instalacao concluida. Edite o arquivo .env antes de iniciar.
   10: pause
   11: exit /b 0
   12: :error
   13: echo Falha na instalacao. Verifique se Python 3.11+ esta instalado e no PATH.
   14: pause
   15: exit /b 1

ARQUIVO: C:\RavenRP\Discord-KillFeed\README.md
    1: # DayZ PvP Kill Feed â†’ Discord
    2:
    3: ServiÃ§o independente para Windows que acompanha os arquivos `.ADM` do DayZ, detecta mortes PvP, grava no PostgreSQL e publica embeds em um canal privado do Discord.
    4:
    5: ## Requisitos
    6:
    7: - Windows 10/11 ou Windows Server
    8: - Python 3.11 ou superior
    9: - PostgreSQL 14 ou superior
   10: - DayZ Dedicated Server iniciado com `-adminlog`
   11: - Webhook de um canal privado do Discord
   12:
   13: ## 1. Ativar o ADM no DayZ
   14:
   15: O parÃ¢metro `-adminlog` Ã© obrigatÃ³rio. O arquivo `.ADM` Ã© criado na pasta definida pelo parÃ¢metro `-profiles`.
   16:
   17: Exemplo de inicializaÃ§Ã£o (adapte os caminhos e parÃ¢metros jÃ¡ existentes):
   18:
   19: ```bat
   20: DayZServer_x64.exe -config=serverDZ.cfg -port=2302 "-profiles=C:\DayZServer\profiles" -adminlog
   21: ```
   22:
   23: NÃ£o substitua sua linha atual: apenas acrescente `-adminlog` se ainda nÃ£o estiver presente. O valor de `DAYZ_LOG_DIR` deve apontar para a mesma pasta de `-profiles`.
   24:
   25: ReferÃªncia oficial: https://community.bohemia.net/wiki/DayZ:Administration_Logs
   26:
   27: ## 2. Criar banco PostgreSQL
   28:
   29: No pgAdmin ou `psql`, execute (troque a senha):
   30:
   31: ```sql
   32: CREATE USER dayz_killfeed WITH PASSWORD 'SENHA_FORTE_AQUI';
   33: CREATE DATABASE dayz_killfeed OWNER dayz_killfeed;
   34: ```
   35:
   36: A aplicaÃ§Ã£o cria a tabela e os Ã­ndices automaticamente ao iniciar. O arquivo `sql/schema.sql` tambÃ©m pode ser executado manualmente.
   37:
   38: ## 3. Criar webhook no Discord
   39:
   40: 1. Abra as configuraÃ§Ãµes do servidor Discord.
   41: 2. Entre em IntegraÃ§Ãµes â†’ Webhooks.
   42: 3. Crie um webhook no canal privado da administraÃ§Ã£o.
   43: 4. Copie a URL e guarde-a como segredo. Qualquer pessoa com essa URL pode publicar no canal.
   44:
   45: NÃ£o Ã© necessÃ¡rio criar um bot nem disponibilizar token de bot.
   46:
   47: ## 4. Instalar e configurar
   48:
   49: 1. Extraia a pasta do projeto no PC que hospeda o DayZ.
   50: 2. Execute `install.bat`.
   51: 3. Edite `.env` e configure:
   52:    - `DAYZ_LOG_DIR`: pasta `profiles` real do servidor.
   53:    - `DATABASE_URL`: endereÃ§o, banco, usuÃ¡rio e senha PostgreSQL.
   54:    - `DISCORD_WEBHOOK_URL`: URL do webhook.
   55: 4. Rode o teste local do parser:
   56:
   57: ```powershell
   58: .venv\Scripts\python.exe -m killfeed --test-parser
   59: ```
   60:
   61: 5. Execute `start.bat`.
   62:
   63: ## 5. Testar com o log real
   64:
   65: FaÃ§a uma morte PvP controlada no servidor e confira:
   66:
   67: - O console do serviÃ§o deve exibir `PvP detectado`.
   68: - O canal Discord deve receber o Embed.
   69: - A tabela `pvp_kills` deve conter o evento.
   70:
   71: Consulta de conferÃªncia:
   72:
   73: ```sql
   74: SELECT occurred_at, killer_name, victim_name, weapon, distance_m,
   75:        discord_sent, discord_attempts
   76: FROM pvp_kills
   77: ORDER BY occurred_at DESC
   78: LIMIT 20;
   79: ```
   80:
   81: O parser foi implementado para o formato vanilla documentado. Mods, versÃµes ou formatos diferentes podem exigir ajuste. Se o parser de exemplo funcionar mas uma kill real nÃ£o for reconhecida, envie uma linha real do `.ADM` (pode ocultar os IDs) para ajustar a expressÃ£o com seguranÃ§a.
   82:
   83: ## 6. InicializaÃ§Ã£o automÃ¡tica
   84:
   85: Use o Agendador de Tarefas do Windows:
   86:
   87: - Gatilho: Ao iniciar o computador (ou ao iniciar sessÃ£o, conforme sua operaÃ§Ã£o).
   88: - AÃ§Ã£o / Programa: caminho completo para `dayz-discord-killfeed\.venv\Scripts\python.exe`.
   89: - Argumentos: `-m killfeed`.
   90: - Iniciar em: caminho completo da pasta `dayz-discord-killfeed`.
   91: - Configure reinicializaÃ§Ã£o em caso de falha.
   92:
   93: O serviÃ§o grava o log em `logs\killfeed.log`.
   94:
   95: ## Comportamento e limitaÃ§Ãµes
   96:
   97: - Na primeira inicializaÃ§Ã£o, o monitor comeÃ§a no final do `.ADM` mais recente para nÃ£o despejar o histÃ³rico antigo no Discord.
   98: - Ao detectar um novo arquivo `.ADM` (normalmente apÃ³s reinÃ­cio do servidor), comeÃ§a a acompanhar o novo arquivo desde o inÃ­cio.
   99: - A chave SHA-256 e a restriÃ§Ã£o `UNIQUE` evitam inserir a mesma linha duas vezes no banco.
  100: - Se o Discord estiver indisponÃ­vel, os eventos ficam pendentes no banco e sÃ£o tentados novamente.
  101: - A entrega ao Discord Ã© **at-least-once**: uma queda exatamente depois de o Discord aceitar a mensagem e antes de o banco marcar como enviada pode ocasionar uma mensagem repetida. Webhook nÃ£o oferece chave de idempotÃªncia para eliminar completamente essa janela.
  102: - O monitor acompanha o arquivo `.ADM` mais recente. NÃ£o mova nem apague o arquivo ativo enquanto o serviÃ§o estiver rodando.
  103: - O serviÃ§o nÃ£o executa comandos administrativos, nÃ£o altera o jogo e nÃ£o requer mod instalado pelos jogadores.

ARQUIVO: C:\RavenRP\Discord-KillFeed\requirements.txt
    1: psycopg[binary]>=3.2,<4
    2: requests>=2.32,<3
    3: python-dotenv>=1.0,<2

ARQUIVO: C:\RavenRP\Discord-KillFeed\start-killfeed.bat

ARQUIVO: C:\RavenRP\Discord-KillFeed\start.bat
    1: @echo off
    2: cd /d "%~dp0"
    3: if not exist .venv\Scripts\python.exe (
    4:   echo Execute install.bat primeiro.
    5:   pause
    6:   exit /b 1
    7: )
    8: .venv\Scripts\python.exe -m killfeed
    9: pause

ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\database.py
    1: import json
    2: import psycopg
    3: from psycopg.rows import dict_row
    4:
    5: SCHEMA = '''
    6: CREATE TABLE IF NOT EXISTS pvp_kills (
    7:     id BIGSERIAL PRIMARY KEY,
    8:     event_id CHAR(64) NOT NULL UNIQUE,
    9:     occurred_at TIMESTAMPTZ NOT NULL,
   10:     killer_name TEXT NOT NULL,
   11:     killer_id TEXT,
   12:     victim_name TEXT NOT NULL,
   13:     victim_id TEXT,
   14:     weapon TEXT NOT NULL,
   15:     distance_m DOUBLE PRECISION,
   16:     killer_position JSONB,
   17:     victim_position JSONB,
   18:     raw_line TEXT NOT NULL,
   19:     discord_sent BOOLEAN NOT NULL DEFAULT FALSE,
   20:     discord_attempts INTEGER NOT NULL DEFAULT 0,
   21:     discord_last_error TEXT,
   22:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
   23: );
   24: CREATE INDEX IF NOT EXISTS idx_pvp_kills_occurred_at ON pvp_kills (occurred_at DESC);
   25: CREATE INDEX IF NOT EXISTS idx_pvp_kills_pending ON pvp_kills (created_at) WHERE discord_sent = FALSE;
   26: '''
   27:
   28:
   29: class Database:
   30:     def __init__(self, dsn: str):
   31:         self.conn = psycopg.connect(dsn, row_factory=dict_row)
   32:         self.conn.execute(SCHEMA)
   33:         self.conn.commit()
   34:
   35:     def insert_kill(self, event: dict) -> bool:
   36:         query = '''INSERT INTO pvp_kills
   37:         (event_id, occurred_at, killer_name, killer_id, victim_name, victim_id,
   38:          weapon, distance_m, killer_position, victim_position, raw_line)
   39:         VALUES (%(event_id)s, %(occurred_at)s, %(killer_name)s, %(killer_id)s,
   40:          %(victim_name)s, %(victim_id)s, %(weapon)s, %(distance_m)s,
   41:          %(killer_position)s::jsonb, %(victim_position)s::jsonb, %(raw_line)s)
   42:         ON CONFLICT (event_id) DO NOTHING RETURNING id'''
   43:         values = dict(event)
   44:         values['killer_position'] = json.dumps(event['killer_position']) if event['killer_position'] else None
   45:         values['victim_position'] = json.dumps(event['victim_position']) if event['victim_position'] else None
   46:         try:
   47:             row = self.conn.execute(query, values).fetchone()
   48:             self.conn.commit()
   49:             return row is not None
   50:         except Exception:
   51:             self.conn.rollback()
   52:             raise
   53:
   54:     def pending(self, limit=20):
   55:         return self.conn.execute(
   56:             'SELECT * FROM pvp_kills WHERE discord_sent=FALSE ORDER BY id LIMIT %s', (limit,)
   57:         ).fetchall()
   58:
   59:     def mark_sent(self, row_id: int):
   60:         self.conn.execute('UPDATE pvp_kills SET discord_sent=TRUE, discord_last_error=NULL WHERE id=%s', (row_id,))
   61:         self.conn.commit()
   62:
   63:     def mark_error(self, row_id: int, error: str):
   64:         self.conn.execute('''UPDATE pvp_kills SET discord_attempts=discord_attempts+1,
   65:             discord_last_error=%s WHERE id=%s''', (error[:1000], row_id))
   66:         self.conn.commit()
   67:
   68:     def close(self):
   69:         self.conn.close()

ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\discord.py
    1: import requests
    2:
    3:
    4: def _safe(value):
    5:     # Impede menÃ§Ãµes involuntÃ¡rias e limita o tamanho dos campos do Discord.
    6:     return str(value or 'NÃ£o informado').replace('@', '@\u200b')[:1024]
    7:
    8:
    9: def _coords(value):
   10:     if isinstance(value, str):
   11:         import json
   12:         value = json.loads(value)
   13:     return ', '.join(f'{float(v):.1f}' for v in value)
   14:
   15:
   16: class DiscordWebhook:
   17:     def __init__(self, url: str, color: int):
   18:         self.url = url
   19:         self.color = color
   20:         self.session = requests.Session()
   21:         self.session.headers.update({'User-Agent': 'DayZ-PvP-KillFeed/1.0'})
   22:
   23:     def send(self, event: dict):
   24:         fields = [
   25:             {'name': 'ðŸ”« Assassino', 'value': _safe(event['killer_name']), 'inline': True},
   26:             {'name': 'ðŸ’€ VÃ­tima', 'value': _safe(event['victim_name']), 'inline': True},
   27:             {'name': 'Arma', 'value': _safe(event['weapon']), 'inline': True},
   28:             {'name': 'DistÃ¢ncia', 'value': f"{event['distance_m']:.1f} m" if event['distance_m'] is not None else 'NÃ£o registrada', 'inline': True},
   29:             {'name': 'Data/hora', 'value': event['occurred_at'].strftime('%d/%m/%Y %H:%M:%S %Z'), 'inline': True},
   30:         ]
   31:         killer_pos = event.get('killer_position')
   32:         victim_pos = event.get('victim_position')
   33:         if killer_pos:
   34:             fields.append({'name': 'PosiÃ§Ã£o do assassino (X, Y, Z)', 'value': _coords(killer_pos), 'inline': True})
   35:         if victim_pos:
   36:             fields.append({'name': 'PosiÃ§Ã£o da vÃ­tima (X, Y, Z)', 'value': _coords(victim_pos), 'inline': True})
   37:
   38:         payload = {
   39:             'username': 'DayZ Kill Feed',
   40:             'allowed_mentions': {'parse': []},
   41:             'embeds': [{
   42:                 'title': 'â˜ ï¸ KILL FEED â€” PvP',
   43:                 'description': f"**{_safe(event['killer_name'])}** eliminou **{_safe(event['victim_name'])}**",
   44:                 'color': self.color,
   45:                 'fields': fields,
   46:                 'footer': {'text': 'Servidor DayZ â€¢ Registro administrativo'},
   47:             }],
   48:         }
   49:         response = self.session.post(self.url, json=payload, timeout=15)
   50:         if response.status_code not in (200, 204):
   51:             raise RuntimeError(f'Discord HTTP {response.status_code}: {response.text[:250]}')
   52:
   53:     def close(self):
   54:         self.session.close()

ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\monitor.py
    1: import logging
    2: import time
    3: from pathlib import Path
    4:
    5: from .parser import parse_kill
    6:
    7:
    8: def latest_adm(directory: Path, pattern: str):
    9:     candidates = list(directory.glob(pattern))
   10:     return max(candidates, key=lambda path: path.stat().st_mtime) if candidates else None
   11:
   12:
   13: class AdmMonitor:
   14:     def __init__(self, log_dir: str, pattern: str, database, discord, timezone, interval: float):
   15:         self.log_dir = Path(log_dir)
   16:         self.pattern = pattern
   17:         self.database = database
   18:         self.discord = discord
   19:         self.timezone = timezone
   20:         self.interval = interval
   21:         self.logger = logging.getLogger('killfeed')
   22:         self.current_file = None
   23:         self.position = 0
   24:         self.discord_retry_at = 0.0
   25:
   26:     def _dispatch_pending(self):
   27:         now = time.monotonic()
   28:         if now < self.discord_retry_at:
   29:             return
   30:         for row in self.database.pending():
   31:             try:
   32:                 self.discord.send(row)
   33:                 self.database.mark_sent(row['id'])
   34:                 self.logger.info('Publicado no Discord: %s -> %s', row['killer_name'], row['victim_name'])
   35:             except Exception as exc:
   36:                 self.database.mark_error(row['id'], str(exc))
   37:                 self.logger.exception('Falha ao publicar evento %s', row['id'])
   38:                 self.discord_retry_at = time.monotonic() + 10
   39:                 break
   40:
   41:     def _tail(self):
   42:         newest = latest_adm(self.log_dir, self.pattern)
   43:         if newest is None:
   44:             return
   45:         if self.current_file is None:
   46:             # Primeira inicializaÃ§Ã£o: evita disparar todo o histÃ³rico antigo.
   47:             self.current_file = newest
   48:             self.position = newest.stat().st_size
   49:             self.logger.info('Arquivo ADM inicial: %s; leitura comeÃ§arÃ¡ no fim.', newest.name)
   50:             return
   51:         if newest != self.current_file:
   52:             self.current_file = newest
   53:             self.position = 0
   54:             self.logger.info('Novo arquivo ADM detectado: %s', newest.name)
   55:
   56:         size = self.current_file.stat().st_size
   57:         if size < self.position:
   58:             self.logger.warning('Arquivo ADM truncado; reposicionando leitura.')
   59:             self.position = 0
   60:         if size == self.position:
   61:             return
   62:
   63:         # Reabre a cada ciclo para nÃ£o bloquear o DayZ no Windows.
   64:         with self.current_file.open('rb') as stream:
   65:             stream.seek(self.position)
   66:             chunk = stream.read()
   67:             self.position = stream.tell()
   68:         lines = chunk.decode('utf-8', errors='replace').splitlines()
   69:         for line in lines:
   70:             event = parse_kill(line, self.current_file.name, self.timezone)
   71:             if event and self.database.insert_kill(event):
   72:                 self.logger.info('PvP detectado: %s -> %s | %s', event['killer_name'], event['victim_name'], event['weapon'])
   73:
   74:     def run(self):
   75:         self.logger.info('Monitorando %s (%s)', self.log_dir, self.pattern)
   76:         while True:
   77:             try:
   78:                 self._dispatch_pending()
   79:                 self._tail()
   80:                 time.sleep(self.interval)
   81:             except KeyboardInterrupt:
   82:                 self.logger.info('Encerramento solicitado.')
   83:                 return
   84:             except Exception:
   85:                 self.logger.exception('Erro no monitoramento; nova tentativa em 3 segundos.')
   86:                 time.sleep(3)

ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\parser.py
    1: import hashlib
    2: import re
    3: from datetime import date, datetime
    4: from pathlib import Path
    5: from zoneinfo import ZoneInfo
    6:
    7: # Formato vanilla documentado: HH:MM:SS | Player "victim" (DEAD)
    8: # (id=... pos=<x, y, z>) killed by Player "killer" (id=... pos=<x, y, z>)
    9: # with WEAPON from N meters. A distÃ¢ncia/posiÃ§Ãµes podem variar em versÃµes/mods.
   10: KILL_RE = re.compile(
   11:     r'^(?P<clock>\d{2}:\d{2}:\d{2})\s*\|\s*'
   12:     r'Player\s+"(?P<victim>.*?)"\s+\(DEAD\)\s+'
   13:     r'\(id=(?P<victim_id>.*?)\s+pos=<(?P<vx>-?[\d.]+),\s*(?P<vy>-?[\d.]+),\s*(?P<vz>-?[\d.]+)>\)\s+'
   14:     r'killed by Player\s+"(?P<killer>.*?)"\s+'
   15:     r'\(id=(?P<killer_id>.*?)\s+pos=<(?P<kx>-?[\d.]+),\s*(?P<ky>-?[\d.]+),\s*(?P<kz>-?[\d.]+)>\)\s+'
   16:     r'with\s+(?P<weapon>.+?)\s+from\s+(?P<distance>[\d.]+)\s+meters?\s*$', re.I
   17: )
   18:
   19: # Fallback conservador: ainda exige morte de um Player causada por outro Player.
   20: FALLBACK_RE = re.compile(
   21:     r'^(?P<clock>\d{2}:\d{2}:\d{2})\s*\|\s*'
   22:     r'Player\s+"(?P<victim>.*?)".*?\(DEAD\).*?killed by Player\s+"(?P<killer>.*?)".*?'
   23:     r'with\s+(?P<weapon>.+?)(?:\s+from\s+(?P<distance>[\d.]+)\s*(?:meters?|m))?\s*$', re.I
   24: )
   25:
   26:
   27: def _date_from_filename(filename: str) -> date | None:
   28:     name = Path(filename).name
   29:     # DayZServer_x64_2026-11-16_13-38-51.ADM
   30:     match = re.search(r'(\d{4})-(\d{2})-(\d{2})', name)
   31:     # DayZServer_x64_2026_11_16_133851123.ADM
   32:     if not match:
   33:         match = re.search(r'(\d{4})_(\d{2})_(\d{2})', name)
   34:     if match:
   35:         try:
   36:             return date(*(int(part) for part in match.groups()))
   37:         except ValueError:
   38:             return None
   39:     return None
   40:
   41:
   42: def parse_kill(line: str, filename: str, timezone: ZoneInfo) -> dict | None:
   43:     raw = line.strip()
   44:     match = KILL_RE.match(raw)
   45:     has_positions = match is not None
   46:     if match is None:
   47:         match = FALLBACK_RE.match(raw)
   48:     if match is None:
   49:         return None
   50:
   51:     data = match.groupdict()
   52:     killer, victim = data['killer'].strip(), data['victim'].strip()
   53:     if not killer or not victim or killer.casefold() == victim.casefold():
   54:         return None
   55:
   56:     log_date = _date_from_filename(filename) or datetime.now(timezone).date()
   57:     clock = datetime.strptime(data['clock'], '%H:%M:%S').time()
   58:     occurred_at = datetime.combine(log_date, clock, tzinfo=timezone)
   59:
   60:     def coords(prefix):
   61:         if not has_positions:
   62:             return None
   63:         return [float(data[prefix + axis]) for axis in ('x', 'y', 'z')]
   64:
   65:     # O ID Ã© capturado sem o sufixo " pos=...".
   66:     victim_id = data.get('victim_id')
   67:     killer_id = data.get('killer_id')
   68:     if victim_id:
   69:         victim_id = victim_id.split(' pos=')[0].strip()[:128]
   70:     if killer_id:
   71:         killer_id = killer_id.split(' pos=')[0].strip()[:128]
   72:
   73:     event_id = hashlib.sha256((Path(filename).name + '|' + raw).encode('utf-8', 'replace')).hexdigest()
   74:     return {
   75:         'event_id': event_id,
   76:         'occurred_at': occurred_at,
   77:         'killer_name': killer,
   78:         'killer_id': killer_id,
   79:         'victim_name': victim,
   80:         'victim_id': victim_id,
   81:         'weapon': data.get('weapon', 'NÃ£o identificada').strip(),
   82:         'distance_m': float(data['distance']) if data.get('distance') else None,
   83:         'killer_position': coords('k'),
   84:         'victim_position': coords('v'),
   85:         'raw_line': raw,
   86:     }

ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\__init__.py
    1: "

ARQUIVO: C:\RavenRP\Discord-KillFeed\killfeed\__main__.py
    1: import argparse
    2: import logging
    3: import os
    4: from pathlib import Path
    5: from zoneinfo import ZoneInfo
    6:
    7: from dotenv import load_dotenv
    8:
    9: from .parser import parse_kill
   10:
   11: SAMPLE = ('14:22:34 | Player "Vex" (DEAD) (id=ABC pos=<4758.1, 10200.8, 288.6>) '
   12:           'killed by Player "Rook" (id=XYZ pos=<4611.0, 10088.4, 291.0>) '
   13:           'with M4-A1 from 185.1 meters')
   14:
   15:
   16: def main():
   17:     load_dotenv()
   18:     cli = argparse.ArgumentParser(description='DayZ PvP Kill Feed para Discord')
   19:     cli.add_argument('--test-parser', action='store_true', help='Valida o parser com uma linha de exemplo')
   20:     args = cli.parse_args()
   21:     timezone = ZoneInfo(os.getenv('TIMEZONE', 'America/Sao_Paulo'))
   22:
   23:     if args.test_parser:
   24:         result = parse_kill(SAMPLE, 'DayZServer_x64_2026-11-16_13-38-51.ADM', timezone)
   25:         if not result:
   26:             raise SystemExit('FALHA: exemplo nÃ£o reconhecido')
   27:         print('OK: parser reconheceu a morte PvP')
   28:         for key, value in result.items():
   29:             if key != 'raw_line':
   30:                 print(f'{key}: {value}')
   31:         return
   32:
   33:     from .database import Database
   34:     from .discord import DiscordWebhook
   35:     from .monitor import AdmMonitor
   36:
   37:     log_dir = os.getenv('DAYZ_LOG_DIR', '').strip()
   38:     dsn = os.getenv('DATABASE_URL', '').strip()
   39:     webhook_url = [VALOR OCULTO]'DISCORD_WEBHOOK_URL', '').strip()
   40:     if not log_dir or not dsn or not webhook_url:
   41:         raise SystemExit('Configure DAYZ_LOG_DIR, DATABASE_URL e DISCORD_WEBHOOK_URL no arquivo .env')
   42:     if not Path(log_dir).is_dir():
   43:         raise SystemExit(f'DAYZ_LOG_DIR nÃ£o existe: {log_dir}')
   44:     if 'COLOQUE_A_URL' in webhook_url or 'ID/TOKEN' in webhook_url:
   45:         raise SystemExit('Configure a URL real do webhook no .env')
   46:
   47:     Path('logs').mkdir(exist_ok=True)
   48:     logging.basicConfig(
   49:         level=logging.INFO,
   50:         format='%(asctime)s %(levelname)s %(message)s',
   51:         handlers=[logging.StreamHandler(), logging.FileHandler('logs/killfeed.log', encoding='utf-8')],
   52:     )
   53:     logger = logging.getLogger('killfeed')
   54:     db = Database(dsn)
   55:     discord = DiscordWebhook(webhook_url, int(os.getenv('EMBED_COLOR', '15158332')))
   56:     monitor = AdmMonitor(
   57:         log_dir=log_dir,
   58:         pattern=os.getenv('DAYZ_FILE_GLOB', '*.ADM'),
   59:         database=db,
   60:         discord=discord,
   61:         timezone=timezone,
   62:         interval=max(0.5, float(os.getenv('POLL_INTERVAL_SECONDS', '1'))),
   63:     )
   64:     try:
   65:         monitor.run()
   66:     finally:
   67:         discord.close()
   68:         db.close()
   69:
   70:
   71: if __name__ == '__main__':
   72:     main()

ARQUIVO: C:\RavenRP\Discord-KillFeed\sql\schema.sql
    1: CREATE TABLE IF NOT EXISTS pvp_kills (
    2:     id BIGSERIAL PRIMARY KEY,
    3:     event_id CHAR(64) NOT NULL UNIQUE,
    4:     occurred_at TIMESTAMPTZ NOT NULL,
    5:     killer_name TEXT NOT NULL,
    6:     killer_id TEXT,
    7:     victim_name TEXT NOT NULL,
    8:     victim_id TEXT,
    9:     weapon TEXT NOT NULL,
   10:     distance_m DOUBLE PRECISION,
   11:     killer_position JSONB,
   12:     victim_position JSONB,
   13:     raw_line TEXT NOT NULL,
   14:     discord_sent BOOLEAN NOT NULL DEFAULT FALSE,
   15:     discord_attempts INTEGER NOT NULL DEFAULT 0,
   16:     discord_last_error TEXT,
   17:     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
   18: );
   19: CREATE INDEX IF NOT EXISTS idx_pvp_kills_occurred_at ON pvp_kills (occurred_at DESC);
   20: CREATE INDEX IF NOT EXISTS idx_pvp_kills_pending ON pvp_kills (created_at) WHERE discord_sent = FALSE;

===========================================================================
5. PROCESSOS RELACIONADOS AO KILLFEED
===========================================================================
Nenhum processo identificado pelos filtros.

===========================================================================
6. SERVICOS DO WINDOWS RELACIONADOS
===========================================================================
Nenhum servico identificado pelos filtros.

===========================================================================
7. TAREFAS AGENDADAS RELACIONADAS
===========================================================================

===========================================================================
8. RESUMO
===========================================================================
Arquivos inventariados na oficial: 15
Arquivos inventariados na antiga: 0
Processos, servicos e tarefas foram consultados em modo somente leitura.
Nenhum arquivo foi alterado ou removido.
Nenhum servico foi iniciado ou encerrado.
Nenhuma conexao ou escrita no PostgreSQL foi realizada.

===========================================================================
AUDITORIA CONCLUIDA
===========================================================================
**********************
Fim da transcrição do Windows PowerShell
Hora de término: 20261119141339
**********************
