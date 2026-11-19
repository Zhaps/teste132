==================================================
1. IDENTIFICACAO DOS PROCESSOS E SEUS COMANDOS
==================================================

Processo: node.exe
PID: 4636
PID pai: 8440
Executavel: C:\Program Files\nodejs\node.exe
Comando: "C:\Program Files\nodejs\node.exe" server.js
Processo pai: powershell.exe
Executavel pai: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
Comando pai: "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

Processo: node.exe
PID: 7320
PID pai: 8440
Executavel: C:\Program Files\nodejs\node.exe
Comando: "C:\Program Files\nodejs\node.exe" src/server.js
Processo pai: powershell.exe
Executavel pai: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
Comando pai: "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

Processo: python.exe
PID: 7588
PID pai: 8440
Executavel: C:\Program Files\Python311\python.exe
Comando: "C:\Program Files\Python311\python.exe" -
Processo pai: powershell.exe
Executavel pai: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
Comando pai: "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

==================================================
2. ARQUIVOS DE INICIALIZACAO
==================================================

--- start.bat ---
@echo off
cd /d "%~dp0"
if not exist .venv\Scripts\python.exe (
  echo Execute install.bat primeiro.
  pause
  exit /b 1
)
.venv\Scripts\python.exe -m killfeed
pause

--- start-killfeed.bat ---

--- install.bat ---
@echo off
cd /d "%~dp0"
py -3.11 -m venv .venv
if errorlevel 1 goto error
.venv\Scripts\python.exe -m pip install --upgrade pip
.venv\Scripts\pip.exe install -r requirements.txt
if not exist .env copy .env.example .env
echo.
echo Instalacao concluida. Edite o arquivo .env antes de iniciar.
pause
exit /b 0
:error
echo Falha na instalacao. Verifique se Python 3.11+ esta instalado e no PATH.
pause
exit /b 1

==================================================
3. DEPENDENCIAS PYTHON
==================================================
psycopg[binary]>=3.2,<4
requests>=2.32,<3
python-dotenv>=1.0,<2

==================================================
4. DOCUMENTACAO README
==================================================
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

==================================================
5. VARIAVEIS CONFIGURADAS NO ENV (SEM VALORES)
==================================================
DATABASE_URL
DAYZ_FILE_GLOB
DAYZ_LOG_DIR
DISCORD_WEBHOOK_URL
EMBED_COLOR
POLL_INTERVAL_SECONDS
TIMEZONE

==================================================
6. INVENTARIO DOS ARQUIVOS PYTHON
==================================================

FullName                                                                                                                Length LastWriteTime
--------                                                                                                                ------ -------------
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\typing_extensions.py                                                165012 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\certifi\core.py                                                       3394 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\certifi\__init__.py                                                     94 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\certifi\__main__.py                                                    243 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\certifi\tests\test_certify.py                                          467 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\certifi\tests\__init__.py                                                0 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\api.py                                            36708 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\cd.py                                             16447 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\constant.py                                       63309 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\legacy.py                                          2730 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\md.py                                             36339 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\models.py                                         13917 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\utils.py                                          14574 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\version.py                                          123 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\__init__.py                                        1630 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\__main__.py                                         115 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\cli\__init__.py                                     144 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\charset_normalizer\cli\__main__.py                                   12312 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\cli.py                                                         6969 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\ipython.py                                                     1326 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\main.py                                                       15179 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\parser.py                                                      5806 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\variables.py                                                   2348 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\version.py                                                       22 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\__init__.py                                                    1230 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\dotenv\__main__.py                                                     129 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\cli.py                                                           4245 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\codec.py                                                         8002 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\compat.py                                                        1376 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\core.py                                                         32580 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\idnadata.py                                                     45763 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\intranges.py                                                     1851 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\package_data.py                                                    21 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\uts46data.py                                                   237174 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\__init__.py                                                       944 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\idna\__main__.py                                                        83 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\__init__.py                                                        512 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\__main__.py                                                        873 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\__pip-runner__.py                                                 1451 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cache.py                                               10645 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\configuration.py                                       16463 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\main.py                                                  338 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\pyproject.py                                            4555 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\self_outdated_check.py                                  8887 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\wheel_builder.py                                        9146 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\__init__.py                                              511 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\build_env\base.py                                       3440 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\build_env\installer.py                                 13046 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\build_env\noop.py                                       1001 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\build_env\venv.py                                       5700 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\build_env\virtual.py                                    4888 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\build_env\__init__.py                                    788 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\autocompletion.py                                   7529 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\base_command.py                                     9457 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\cmdoptions.py                                      40920 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\command_context.py                                   817 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\index_command.py                                    7904 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\main.py                                             3489 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\main_parser.py                                      4917 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\parser.py                                          14685 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\progress_bars.py                                    4706 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\req_command.py                                     22051 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\spinners.py                                         7362 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\status_codes.py                                      136 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\cli\__init__.py                                          131 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\cache.py                                       9251 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\check.py                                       2244 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\completion.py                                  4565 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\configuration.py                              10370 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\debug.py                                       6500 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\download.py                                    5398 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\freeze.py                                      3100 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\hash.py                                        1679 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\help.py                                        1108 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\index.py                                       5608 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\inspect.py                                     3185 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\install.py                                    40284 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\list.py                                       13908 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\lock.py                                        5981 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\search.py                                      5597 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\show.py                                        8247 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\uninstall.py                                   3868 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\wheel.py                                       6181 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\commands\__init__.py                                    4148 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\distributions\base.py                                   1907 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\distributions\installed.py                               994 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\distributions\sdist.py                                  7783 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\distributions\wheel.py                                  1429 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\distributions\__init__.py                                858 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\build.py                                     5444 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\hashes.py                                    7185 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\network.py                                   6497 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\pyproject.py                                 1568 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\uninstall.py                                 1818 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\wheel.py                                      553 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\_base.py                                     4692 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\exceptions\__init__.py                                 15525 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\index\collector.py                                     16578 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\index\package_finder.py                                43209 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\index\sources.py                                        8621 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\index\__init__.py                                         29 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\locations\base.py                                       2548 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\locations\_distutils.py                                 5938 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\locations\_sysconfig.py                                 8205 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\locations\__init__.py                                  14022 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\base.py                                       26627 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\direct_references.py                           1694 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\pkg_resources.py                              10792 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\_json.py                                       2711 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\__init__.py                                    5824 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\importlib\_compat.py                           2804 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\importlib\_dists.py                            8979 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\importlib\_envs.py                             5590 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\metadata\importlib\__init__.py                           135 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\candidate.py                                      824 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\direct_url.py                                     944 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\format_control.py                                2471 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\index.py                                         1030 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\installation_report.py                           2846 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\link.py                                         23474 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\release_control.py                               3365 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\scheme.py                                         558 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\search_scope.py                                  4461 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\selection_prefs.py                               1503 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\target_python.py                                 4243 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\wheel.py                                         2920 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\models\__init__.py                                        62 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\auth.py                                        21545 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\cache.py                                        4862 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\download.py                                    14761 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\lazy_wheel.py                                   7646 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\session.py                                     20836 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\utils.py                                        8128 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\xmlrpc.py                                       1830 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\network\__init__.py                                       49 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\check.py                                     5891 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\freeze.py                                    9854 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\prepare.py                                  34612 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\__init__.py                                     0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\build\build_tracker.py                       4771 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\build\metadata.py                            1421 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\build\metadata_editable.py                   1509 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\build\wheel.py                               1136 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\build\wheel_editable.py                      1478 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\build\__init__.py                               0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\install\wheel.py                            34992 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\operations\install\__init__.py                            50 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\constructors.py                                    21283 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\pep723.py                                           1242 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\req_dependency_group.py                             3145 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\req_file.py                                        20644 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\req_install.py                                     33840 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\req_set.py                                          2828 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\req_uninstall.py                                   26993 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\req\__init__.py                                         3289 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\base.py                                       573 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\__init__.py                                     0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\legacy\resolver.py                          24193 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\legacy\__init__.py                              0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\base.py                           5900 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\candidates.py                    20615 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\factory.py                       36359 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\found_candidates.py               6005 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\provider.py                      12310 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\reporter.py                       3992 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\requirements.py                   8239 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\resolver.py                      13849 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\resolution\resolvelib\__init__.py                          0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\appdirs.py                                        1681 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\compat.py                                         2601 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\compatibility_tags.py                             6630 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\datetime.py                                        868 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\deprecation.py                                    5523 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\direct_url_helpers.py                             3363 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\egg_link.py                                       2459 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\entrypoints.py                                    3324 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\filesystem.py                                     6812 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\filetypes.py                                       689 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\glibc.py                                          3726 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\hashes.py                                         5040 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\logging.py                                       13919 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\misc.py                                          26942 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\packaging.py                                      1975 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\pylock.py                                        11341 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\retry.py                                          1488 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\subprocess.py                                     9001 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\temp_dir.py                                       9418 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\unpacking.py                                     14812 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\urls.py                                           2151 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\virtualenv.py                                     2272 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\wheel.py                                          4468 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\_jaraco_text.py                                   3350 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\_log.py                                           1015 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\utils\__init__.py                                          0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\vcs\bazaar.py                                           3734 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\vcs\git.py                                             19273 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\vcs\mercurial.py                                        5575 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\vcs\subversion.py                                      11787 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\vcs\versioncontrol.py                                  22579 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_internal\vcs\__init__.py                                          596 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\__init__.py                                               4932 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\adapter.py                                   6586 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\cache.py                                     1953 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\controller.py                               19102 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\filewrapper.py                               4354 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\heuristics.py                                4881 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\serialize.py                                 5163 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\wrapper.py                                   1417 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\_cmd.py                                      1737 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\__init__.py                                   820 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\caches\file_cache.py                         4117 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\caches\redis_cache.py                        1386 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\cachecontrol\caches\__init__.py                            303 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\certifi\core.py                                           3442 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\certifi\__init__.py                                         94 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\certifi\__main__.py                                        255 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\certifi\tests\test_certify.py                              484 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\certifi\tests\__init__.py                                    0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distlib\compat.py                                        41180 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distlib\resources.py                                     11508 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distlib\scripts.py                                       19132 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distlib\util.py                                          70311 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distlib\__init__.py                                        625 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distro\distro.py                                         49430 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distro\__init__.py                                         981 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\distro\__main__.py                                          64 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\cli.py                                               4245 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\codec.py                                             8002 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\compat.py                                            1376 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\core.py                                             32580 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\idnadata.py                                         45763 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\intranges.py                                         1851 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\package_data.py                                        21 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\uts46data.py                                       237174 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\__init__.py                                           944 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\idna\__main__.py                                            83 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\msgpack\exceptions.py                                     1081 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\msgpack\ext.py                                            6428 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\msgpack\fallback.py                                      33710 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\msgpack\__init__.py                                       1109 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\dependency_groups.py                           11224 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\direct_url.py                                  11645 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\errors.py                                       2680 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\markers.py                                     20566 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\metadata.py                                    42059 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\pylock.py                                      35232 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\ranges.py                                      83090 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\requirements.py                                 7052 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\specifiers.py                                  52834 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\tags.py                                        38314 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\utils.py                                       12215 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\version.py                                     39064 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_elffile.py                                     3236 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_manylinux.py                                  10000 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_musllinux.py                                   2774 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_parser.py                                     12639 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_ranges.py                                     30850 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_structures.py                                  1109 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\_tokenizer.py                                   5573 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\__init__.py                                      494 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\licenses\_spdx.py                              51122 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\packaging\licenses\__init__.py                            7859 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pkg_resources\__init__.py                               124451 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\android.py                                  10294 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\api.py                                      27616 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\ios.py                                       6892 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\macos.py                                     8152 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\pytest_plugin.py                              824 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\testing.py                                   2641 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\unix.py                                     16684 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\version.py                                    522 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\windows.py                                  16549 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\_xdg.py                                      8460 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\__init__.py                                 43369 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\platformdirs\__main__.py                                  2045 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\console.py                                       1721 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\filter.py                                        1913 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\formatter.py                                     4393 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\lexer.py                                        35395 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\modeline.py                                      1008 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\plugin.py                                        1933 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\regexopt.py                                      3313 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\scanner.py                                       3095 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\sphinxext.py                                     7984 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\style.py                                         6491 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\token.py                                         6229 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\unistring.py                                    63211 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\util.py                                         10770 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\__init__.py                                      2986 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\__main__.py                                       356 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\filters\__init__.py                             40397 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\formatters\_mapping.py                           4176 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\formatters\__init__.py                           5388 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\lexers\python.py                                54622 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\lexers\_mapping.py                              78442 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\lexers\__init__.py                              12118 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\styles\_mapping.py                               3381 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pygments\styles\__init__.py                               2045 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pyproject_hooks\_impl.py                                 15780 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pyproject_hooks\__init__.py                                743 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pyproject_hooks\_in_process\_in_process.py               12856 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\pyproject_hooks\_in_process\__init__.py                    557 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\adapters.py                                     28208 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\api.py                                           7152 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\auth.py                                         12233 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\certs.py                                          442 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\compat.py                                        2035 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\cookies.py                                      21549 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\exceptions.py                                    4576 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\help.py                                          4114 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\hooks.py                                         1138 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\models.py                                       41848 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\packages.py                                      1057 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\sessions.py                                     34248 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\status_codes.py                                  4351 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\structures.py                                    4134 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\utils.py                                        36334 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\_internal_utils.py                               1542 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\_types.py                                        5838 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\__init__.py                                      5869 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\requests\__version__.py                                    435 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\providers.py                                   8914 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\reporters.py                                   2037 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\structs.py                                     6420 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\__init__.py                                     541 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\resolvers\abstract.py                          1543 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\resolvers\criterion.py                         1768 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\resolvers\exceptions.py                        1768 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\resolvers\resolution.py                       24212 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\resolvelib\resolvers\__init__.py                           640 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\abc.py                                                890 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\align.py                                            10798 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\ansi.py                                              6947 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\bar.py                                               3263 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\box.py                                              10686 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\cells.py                                            12347 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\color.py                                            18211 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\color_triplet.py                                     1054 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\columns.py                                           7131 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\console.py                                         101421 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\constrain.py                                         1288 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\containers.py                                        5502 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\control.py                                           6487 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\default_styles.py                                    8437 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\diagnose.py                                          1025 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\emoji.py                                             2412 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\errors.py                                             642 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\filesize.py                                          2484 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\file_proxy.py                                        1750 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\highlighter.py                                       9729 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\json.py                                              5031 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\jupyter.py                                           3252 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\layout.py                                           14004 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\live.py                                             15317 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\live_render.py                                       3803 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\logging.py                                          12634 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\markup.py                                            8451 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\measure.py                                           5305 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\padding.py                                           4908 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\pager.py                                              828 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\palette.py                                           3396 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\panel.py                                            11157 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\pretty.py                                           36385 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\progress.py                                         60393 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\progress_bar.py                                      8162 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\prompt.py                                           12460 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\protocol.py                                          1372 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\region.py                                             166 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\repr.py                                              4448 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\rule.py                                              4602 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\scope.py                                             3251 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\screen.py                                            1591 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\segment.py                                          25776 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\spinner.py                                           4214 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\status.py                                            4424 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\style.py                                            27068 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\styled.py                                            1258 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\syntax.py                                           36413 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\table.py                                            40057 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\terminal_theme.py                                    3370 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\text.py                                             47667 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\theme.py                                             3780 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\themes.py                                             102 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\traceback.py                                        37607 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\tree.py                                              9451 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_emoji_codes.py                                    140235 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_emoji_replace.py                                    1067 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_export_format.py                                    2128 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_extension.py                                         265 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_fileno.py                                            799 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_inspect.py                                          9894 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_log_render.py                                       3225 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_loop.py                                             1236 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_null_file.py                                        1394 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_palettes.py                                         7063 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_pick.py                                              423 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_ratio.py                                            5325 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_spinners.py                                        19919 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_stack.py                                             351 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_timer.py                                             417 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_win32_console.py                                   22755 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_windows.py                                          1925 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_windows_renderer.py                                 2783 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_wrap.py                                             3404 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\__init__.py                                          6155 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\__main__.py                                          7869 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode10-0-0.py                      14508 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode11-0-0.py                      14886 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode12-0-0.py                      15228 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode12-1-0.py                      15201 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode13-0-0.py                      15531 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode14-0-0.py                      15896 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode15-0-0.py                      16168 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode15-1-0.py                      16141 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode16-0-0.py                      16492 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode17-0-0.py                      16716 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode4-1-0.py                        9500 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode5-0-0.py                        9625 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode5-1-0.py                        9662 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode5-2-0.py                       10402 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode6-0-0.py                       10616 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode6-1-0.py                       10911 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode6-2-0.py                       10911 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode6-3-0.py                       10936 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode7-0-0.py                       11642 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode8-0-0.py                       11876 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\unicode9-0-0.py                       14160 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\_versions.py                            298 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\rich\_unicode_data\__init__.py                            2646 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\tomli\_parser.py                                         26519 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\tomli\_re.py                                              3235 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\tomli\_types.py                                            254 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\tomli\__init__.py                                          314 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\tomli_w\_writer.py                                        6961 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\tomli_w\__init__.py                                        169 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\truststore\_api.py                                       13222 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\truststore\_macos.py                                     20503 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\truststore\_openssl.py                                    2370 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\truststore\_ssl_constants.py                              1106 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\truststore\_windows.py                                   18035 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\truststore\__init__.py                                    1307 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\connection.py                                    47903 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\connectionpool.py                                45250 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\exceptions.py                                     9945 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\fields.py                                        10801 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\filepost.py                                       2388 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\poolmanager.py                                   25060 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\response.py                                      54440 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\_base_connection.py                               5580 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\_collections.py                                  17669 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\_request_methods.py                               9931 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\_version.py                                        520 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\__init__.py                                       6979 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\pyopenssl.py                             21520 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\socks.py                                  7566 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\__init__.py                                  0 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\emscripten\connection.py                  8960 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\emscripten\fetch.py                      23520 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\emscripten\request.py                      566 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\emscripten\response.py                    9719 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\contrib\emscripten\__init__.py                     870 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\http2\connection.py                              12613 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\http2\probe.py                                    3014 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\http2\__init__.py                                 1741 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\connection.py                                4444 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\proxy.py                                     1148 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\request.py                                   9951 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\response.py                                  3374 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\retry.py                                    20151 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\ssltransport.py                              8847 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\ssl_.py                                     17856 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\ssl_match_hostname.py                        5479 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\timeout.py                                  10363 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\url.py                                      19630 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\util.py                                      1146 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\wait.py                                      4423 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pip\_vendor\urllib3\util\__init__.py                                  1001 16/11/2026 13:50:51
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\__init__.py                                           108568 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\extern\__init__.py                                      2426 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\appdirs.py                                     24701 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\zipp.py                                         8425 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\__init__.py                                        0 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\abc.py                      3886 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\readers.py                  3566 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\simple.py                   2836 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\_adapters.py                4504 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\_common.py                  2741 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\_compat.py                  2706 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\_itertools.py                884 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\_legacy.py                  3494 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\importlib_resources\__init__.py                  506 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\jaraco\context.py                               5420 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\jaraco\functools.py                            13515 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\jaraco\__init__.py                                 0 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\jaraco\text\__init__.py                        15526 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\more_itertools\more.py                        132569 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\more_itertools\recipes.py                      18410 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\more_itertools\__init__.py                        83 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\markers.py                            8496 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\requirements.py                       4706 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\specifiers.py                        30110 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\tags.py                              15699 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\utils.py                              4200 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\version.py                           14665 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\_manylinux.py                        11488 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\_musllinux.py                         4378 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\_structures.py                        1431 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\__about__.py                           661 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\packaging\__init__.py                            497 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\actions.py                            6426 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\common.py                            12936 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\core.py                             213310 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\exceptions.py                         9023 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\helpers.py                           39129 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\results.py                           25341 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\testing.py                           13402 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\unicode.py                           10787 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\util.py                               6805 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\__init__.py                           9159 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\pkg_resources\_vendor\pyparsing\diagram\__init__.py                  23668 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\abc.py                                                        7965 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\adapt.py                                                      5437 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\client_cursor.py                                              2681 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\connection.py                                                21325 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\connection_async.py                                          23623 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\conninfo.py                                                   4470 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\copy.py                                                        806 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\cursor.py                                                    11116 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\cursor_async.py                                              11426 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\dbapi20.py                                                    3309 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\errors.py                                                    46563 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\generators.py                                                12462 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\postgres.py                                                   6439 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\raw_cursor.py                                                 1159 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\rows.py                                                       7959 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\sql.py                                                       19116 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\transaction.py                                               10964 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\version.py                                                     232 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\waiting.py                                                   21050 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_acompat.py                                                   2238 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_adapters_map.py                                             11008 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_capabilities.py                                              5387 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_cmodule.py                                                    872 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_column.py                                                    3004 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_compat.py                                                    1504 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_connection_base.py                                          24343 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_connection_info.py                                           6680 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_conninfo_attempts.py                                         3501 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_conninfo_attempts_async.py                                   3590 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_conninfo_utils.py                                            3164 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_copy.py                                                     11045 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_copy_async.py                                               11292 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_copy_base.py                                                14446 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_cursor_base.py                                              23103 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_dns.py                                                       8006 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_encodings.py                                                 4599 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_enums.py                                                     1691 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_oids.py                                                      1875 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_pipeline.py                                                  2165 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_pipeline_async.py                                            2108 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_pipeline_base.py                                             6669 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_preparing.py                                                 6398 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_py_transformer.py                                           11919 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_queries.py                                                  15724 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_server_cursor.py                                             4662 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_server_cursor_async.py                                       4711 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_server_cursor_base.py                                        7537 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_struct.py                                                    2000 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_tpc.py                                                       3529 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_transformer.py                                                451 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_tstrings.py                                                  5617 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_typeinfo.py                                                 10644 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_typemod.py                                                   3165 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_tz.py                                                        1186 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\_wrappers.py                                                  3126 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\__init__.py                                                   3423 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\crdb\connection.py                                            2758 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\crdb\_types.py                                                7296 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\crdb\__init__.py                                               439 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\abc.py                                                     8095 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\misc.py                                                    6726 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\pq_ctypes.py                                              42415 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\_debug.py                                                  3098 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\_enums.py                                                  6004 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\_pq_ctypes.py                                             22497 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\pq\__init__.py                                                3976 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\array.py                                               17027 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\bool.py                                                 1163 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\composite.py                                           18725 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\datetime.py                                            25585 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\enum.py                                                 7479 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\hstore.py                                               7076 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\json.py                                                 9713 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\multirange.py                                          18829 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\net.py                                                  6732 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\none.py                                                  666 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\numeric.py                                             17498 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\numpy.py                                                3273 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\range.py                                               23533 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\shapely.py                                              2594 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\string.py                                               7547 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\uuid.py                                                 1589 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg\types\__init__.py                                              181 16/11/2026 13:51:07
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg_binary\version.py                                              258 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\psycopg_binary\__init__.py                                             747 16/11/2026 13:51:05
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\adapters.py                                                 28064 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\api.py                                                       7152 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\auth.py                                                     12233 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\certs.py                                                      430 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\compat.py                                                    2465 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\cookies.py                                                  21549 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\exceptions.py                                                4564 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\help.py                                                      4210 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\hooks.py                                                     1138 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\models.py                                                   41783 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\packages.py                                                   904 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\sessions.py                                                 34248 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\status_codes.py                                              4351 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\structures.py                                                4134 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\utils.py                                                    36322 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\_internal_utils.py                                           1542 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\_types.py                                                    5838 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\__init__.py                                                  5922 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\requests\__version__.py                                                435 16/11/2026 13:51:06
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\archive_util.py                                            7346 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\build_meta.py                                             19539 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\depends.py                                                 5499 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\dep_util.py                                                 949 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\discovery.py                                              20799 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\dist.py                                                   45578 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\errors.py                                                  2464 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\extension.py                                               5591 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\glob.py                                                    4873 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\installer.py                                               3824 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\launch.py                                                   812 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\logging.py                                                 1210 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\monkey.py                                                  4857 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\msvc.py                                                   47724 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\namespaces.py                                              3093 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\package_index.py                                          40020 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\py34compat.py                                               245 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\sandbox.py                                                14348 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\unicode_utils.py                                            941 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\version.py                                                  144 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\wheel.py                                                   8376 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\windows_support.py                                          718 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_deprecation_warning.py                                     218 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_entry_points.py                                           1972 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_imp.py                                                    2392 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_importlib.py                                              1311 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_itertools.py                                               675 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_path.py                                                    749 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_reqs.py                                                    501 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\__init__.py                                                8429 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\alias.py                                           2381 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\bdist_egg.py                                      16623 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\bdist_rpm.py                                       1182 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\build.py                                           6595 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\build_clib.py                                      4415 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\build_ext.py                                      15821 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\build_py.py                                       14115 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\develop.py                                         7012 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\dist_info.py                                       4800 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\easy_install.py                                   85662 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\editable_wheel.py                                 31188 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\egg_info.py                                       26795 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\install.py                                         5163 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\install_egg_info.py                                2226 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\install_lib.py                                     3875 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\install_scripts.py                                 2612 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\py36compat.py                                      4946 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\register.py                                         468 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\rotate.py                                          2128 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\saveopts.py                                         658 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\sdist.py                                           7071 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\setopt.py                                          5086 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\test.py                                            8102 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\upload.py                                           462 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\upload_docs.py                                     7494 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\command\__init__.py                                         396 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\expand.py                                          16319 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\pyprojecttoml.py                                   19304 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\setupcfg.py                                        25198 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_apply_pyprojecttoml.py                            13398 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\__init__.py                                         1121 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_validate_pyproject\error_reporting.py             11266 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_validate_pyproject\extra_validations.py            1153 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_validate_pyproject\fastjsonschema_exceptions.py    1612 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_validate_pyproject\fastjsonschema_validations.py 269900 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_validate_pyproject\formats.py                      8736 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\config\_validate_pyproject\__init__.py                     1038 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\extern\__init__.py                                         2512 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\archive_util.py                                 8603 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\bcppcompiler.py                                14789 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\ccompiler.py                                   47369 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\cmd.py                                         17973 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\config.py                                       4920 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\core.py                                         9451 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\cygwinccompiler.py                             12537 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\debug.py                                         139 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\dep_util.py                                     3423 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\dir_util.py                                     8082 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\dist.py                                        50186 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\errors.py                                       3589 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\extension.py                                   10270 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\fancy_getopt.py                                17910 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\filelist.py                                    13713 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\file_util.py                                    8226 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\log.py                                          1972 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\msvc9compiler.py                               30235 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\msvccompiler.py                                23602 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\py38compat.py                                    217 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\py39compat.py                                    639 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\spawn.py                                        3517 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\sysconfig.py                                   18858 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\text_file.py                                   12096 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\unixccompiler.py                               15641 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\util.py                                        18128 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\version.py                                     12952 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\versionpredicate.py                             5248 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\_collections.py                                 1330 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\_functools.py                                    411 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\_macos_compat.py                                 239 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\_msvccompiler.py                               19672 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\__init__.py                                      537 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\bdist.py                                5441 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\bdist_dumb.py                           4701 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\bdist_rpm.py                           22051 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\build.py                                5617 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\build_clib.py                           7728 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\build_ext.py                           31558 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\build_py.py                            16568 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\build_scripts.py                        5624 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\check.py                                4888 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\clean.py                                2603 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\config.py                              13137 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\install.py                             30221 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\install_data.py                         2779 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\install_egg_info.py                     2785 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\install_headers.py                      1189 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\install_lib.py                          8434 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\install_scripts.py                      1936 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\py37compat.py                            672 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\register.py                            11765 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\sdist.py                               19241 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\upload.py                               7477 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\_framework_compat.py                    1614 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_distutils\command\__init__.py                              430 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\ordered_set.py                                    15130 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\typing_extensions.py                              87149 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\zipp.py                                            8425 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\__init__.py                                           0 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_adapters.py                    1862 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_collections.py                  743 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_compat.py                      1828 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_functools.py                   2895 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_itertools.py                   2068 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_meta.py                        1154 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\_text.py                        2166 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_metadata\__init__.py                    30130 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\abc.py                         3886 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\readers.py                     3566 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\simple.py                      2836 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\_adapters.py                   4504 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\_common.py                     2741 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\_compat.py                     2706 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\_itertools.py                   884 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\_legacy.py                     3494 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\importlib_resources\__init__.py                     506 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\jaraco\context.py                                  5420 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\jaraco\functools.py                               13512 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\jaraco\__init__.py                                    0 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\jaraco\text\__init__.py                           15517 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\more_itertools\more.py                           117959 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\more_itertools\recipes.py                         16256 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\more_itertools\__init__.py                           82 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\markers.py                               8493 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\requirements.py                          4700 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\specifiers.py                           30110 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\tags.py                                 15699 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\utils.py                                 4200 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\version.py                              14665 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\_manylinux.py                           11488 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\_musllinux.py                            4378 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\_structures.py                           1431 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\__about__.py                              661 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\packaging\__init__.py                               497 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\actions.py                               6426 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\common.py                               12936 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\core.py                                213310 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\exceptions.py                            9023 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\helpers.py                              39129 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\results.py                              25341 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\testing.py                              13402 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\unicode.py                              10787 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\util.py                                  6805 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\__init__.py                              9159 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\pyparsing\diagram\__init__.py                     23668 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\tomli\_parser.py                                  22633 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\tomli\_re.py                                       2943 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\tomli\_types.py                                     254 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\setuptools\_vendor\tomli\__init__.py                                   396 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\__init__.py                                                     252 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\__init__.py                                              0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Africa\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\America\__init__.py                                      0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\America\Argentina\__init__.py                            0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\America\Indiana\__init__.py                              0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\America\Kentucky\__init__.py                             0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\America\North_Dakota\__init__.py                         0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Antarctica\__init__.py                                   0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Arctic\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Asia\__init__.py                                         0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Atlantic\__init__.py                                     0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Australia\__init__.py                                    0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Brazil\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Canada\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Chile\__init__.py                                        0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Etc\__init__.py                                          0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Europe\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Indian\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Mexico\__init__.py                                       0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\Pacific\__init__.py                                      0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\tzdata\zoneinfo\US\__init__.py                                           0 16/11/2026 13:51:04
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\connection.py                                                47903 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\connectionpool.py                                            45250 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\exceptions.py                                                 9945 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\fields.py                                                    10801 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\filepost.py                                                   2388 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\poolmanager.py                                               25026 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\response.py                                                  54628 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\_base_connection.py                                           5580 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\_collections.py                                              17669 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\_request_methods.py                                           9931 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\_version.py                                                    520 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\__init__.py                                                   6979 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\pyopenssl.py                                         21494 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\socks.py                                              7566 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\__init__.py                                              0 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\emscripten\connection.py                              8960 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\emscripten\fetch.py                                  23520 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\emscripten\request.py                                  566 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\emscripten\response.py                                9719 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\contrib\emscripten\__init__.py                                 836 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\http2\connection.py                                          12613 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\http2\probe.py                                                3014 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\http2\__init__.py                                             1741 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\connection.py                                            4444 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\proxy.py                                                 1148 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\request.py                                              10228 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\response.py                                              3374 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\retry.py                                                20151 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\ssltransport.py                                          8847 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\ssl_.py                                                 17856 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\ssl_match_hostname.py                                    5479 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\timeout.py                                              10346 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\url.py                                                  19579 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\util.py                                                  1146 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\wait.py                                                  4423 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\urllib3\util\__init__.py                                              1001 16/11/2026 13:51:03
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\_distutils_hack\override.py                                             44 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\.venv\Lib\site-packages\_distutils_hack\__init__.py                                           6128 16/11/2026 13:50:39
C:\RavenRP\Discord-KillFeed\killfeed\database.py                                                                          2663 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\discord.py                                                                           2311 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\monitor.py                                                                           3372 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\parser.py                                                                            3276 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\__init__.py                                                                            30 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\__main__.py                                                                          2521 16/11/2026 13:43:41



Auditoria somente leitura concluida.
