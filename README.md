**********************
Início da transcrição do Windows PowerShell
Hora de início: 20261119132301
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
Transcrição iniciada, o arquivo de saída é C:\RavenRP\Auditorias\Bloco5_Padroes_Eventos_VPP.txt

==================================================
1. VALIDACAO DO DIRETORIO
==================================================
Diretorio: C:\DayZServer\profiles\VPPAdminTools\Logging
Arquivos encontrados: 31

==================================================
2. METADADOS DOS ARQUIVOS
==================================================

Name                        Length CreationTime        LastWriteTime
----                        ------ ------------        -------------
Log_2026-11-15_16-6-10.txt   11896 15/11/2026 13:06:10 15/11/2026 13:06:10
Log_2026-11-15_16-7-43.txt   11288 15/11/2026 13:07:43 15/11/2026 13:07:43
Log_2026-11-15_16-10-22.txt  11419 15/11/2026 13:10:22 15/11/2026 13:10:22
Log_2026-11-15_16-20-40.txt  11419 15/11/2026 13:20:41 15/11/2026 13:20:41
Log_2026-11-15_16-27-35.txt  11419 15/11/2026 13:27:35 15/11/2026 13:27:35
Log_2026-11-15_16-38-30.txt  11354 15/11/2026 13:38:30 15/11/2026 13:38:30
Log_2026-11-15_16-41-45.txt  11616 15/11/2026 13:41:45 15/11/2026 14:03:59
Log_2026-11-15_17-6-39.txt   11223 15/11/2026 14:06:39 15/11/2026 14:06:40
Log_2026-11-15_17-9-38.txt   11470 15/11/2026 14:09:38 15/11/2026 14:18:30
Log_2026-11-15_17-20-59.txt  11682 15/11/2026 14:20:59 15/11/2026 14:36:04
Log_2026-11-15_17-37-47.txt  26007 15/11/2026 14:37:47 15/11/2026 15:46:50
Log_2026-11-15_18-57-45.txt  11314 15/11/2026 15:57:45 15/11/2026 15:57:45
Log_2026-11-15_19-1-1.txt    11052 15/11/2026 16:01:01 15/11/2026 16:01:01
Log_2026-11-15_19-3-27.txt   11183 15/11/2026 16:03:27 15/11/2026 16:03:27
Log_2026-11-15_19-14-54.txt  11314 15/11/2026 16:14:54 15/11/2026 16:14:54
Log_2026-11-15_20-10-24.txt  11314 15/11/2026 17:10:24 15/11/2026 17:10:24
Log_2026-11-15_20-58-45.txt  11314 15/11/2026 17:58:45 15/11/2026 17:58:45
Log_2026-11-15_21-7-54.txt   18701 15/11/2026 18:07:54 15/11/2026 18:45:24
Log_2026-11-16_15-12-50.txt  15064 16/11/2026 12:12:50 16/11/2026 12:34:40
Log_2026-11-16_15-47-49.txt  11314 16/11/2026 12:47:49 16/11/2026 12:47:49
Log_2026-11-16_18-45-49.txt  11314 16/11/2026 15:45:49 16/11/2026 15:45:49
Log_2026-11-16_19-14-38.txt  11314 16/11/2026 16:14:38 16/11/2026 16:14:38
Log_2026-11-16_19-40-47.txt  11314 16/11/2026 16:40:47 16/11/2026 16:40:47
Log_2026-11-16_19-16-27.txt  13413 16/11/2026 16:16:27 16/11/2026 17:08:58
Log_2026-11-16_20-24-6.txt   11260 16/11/2026 17:24:06 16/11/2026 17:27:44
Log_2026-11-16_21-20-48.txt  11314 16/11/2026 18:20:48 16/11/2026 18:20:49
Log_2026-11-16_21-20-20.txt  21552 16/11/2026 18:20:20 16/11/2026 19:40:53
Log_2026-11-16_23-0-3.txt    11299 16/11/2026 20:00:03 16/11/2026 20:19:17
Log_2026-11-17_16-25-19.txt  11558 17/11/2026 13:25:19 17/11/2026 15:09:11
Log_2026-11-17_19-28-51.txt  13526 17/11/2026 16:28:51 17/11/2026 22:42:11
Log_2026-11-18_15-31-56.txt  11314 18/11/2026 12:31:56 18/11/2026 12:31:57



==================================================
3. AGRUPAMENTO DE EVENTOS REAIS
==================================================

TOTAL DE EVENTOS IDENTIFICADOS: 219

==================================================
4. CONTAGEM POR CATEGORIA
==================================================

Categoria          Count
---------          -----
AdministrativeKill     6
BanManager            31
Connection            33
Disconnection         52
Error                 39
Teleport              58



==================================================
5. FORMATOS UNICOS E FREQUENCIA
==================================================

Categoria: Disconnection
Frequencia: 3
Formato: 18:46:50 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 307

Categoria: Disconnection
Frequencia: 3
Formato: 21:37:30 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 203

Categoria: Disconnection
Frequencia: 3
Formato: 18:46:49 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 304

Categoria: Teleport
Frequencia: 2
Formato: 22:2:24 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 145

Categoria: Teleport
Frequencia: 2
Formato: 22:2:29 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 155

Categoria: Teleport
Frequencia: 2
Formato: 22:2:24 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 146

Categoria: Teleport
Frequencia: 2
Formato: 22:2:29 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 156

Categoria: Disconnection
Frequencia: 2
Formato: 17:36:4 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_17-20-59.txt, linha 136

Categoria: Connection
Frequencia: 2
Formato: 17:22:58 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-20-59.txt, linha 134

Categoria: Teleport
Frequencia: 1
Formato: 22:2:26 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 150

Categoria: Teleport
Frequencia: 1
Formato: 22:2:27 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 151

Categoria: Teleport
Frequencia: 1
Formato: 22:2:27 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 152

Categoria: Teleport
Frequencia: 1
Formato: 21:49:7 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 142

Categoria: Teleport
Frequencia: 1
Formato: 22:2:20 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 143

Categoria: Teleport
Frequencia: 1
Formato: 22:2:20 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 144

Categoria: Teleport
Frequencia: 1
Formato: 22:2:26 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 149

Categoria: Teleport
Frequencia: 1
Formato: 22:24:20 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 223

Categoria: Teleport
Frequencia: 1
Formato: 22:24:20 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 222

Categoria: Connection
Frequencia: 1
Formato: 22:20:13 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 219

Categoria: Disconnection
Frequencia: 1
Formato: 22:31:26 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected early from server (EXIT NOW).
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 227

Categoria: Disconnection
Frequencia: 1
Formato: 22:31:23 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 226

Categoria: Disconnection
Frequencia: 1
Formato: 22:31:20 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 224

Categoria: Teleport
Frequencia: 1
Formato: 22:36:50 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 228

Categoria: Teleport
Frequencia: 1
Formato: 22:2:28 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 154

Categoria: Teleport
Frequencia: 1
Formato: 22:2:28 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 153

Categoria: Disconnection
Frequencia: 1
Formato: 22:19:44 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 218

Categoria: Disconnection
Frequencia: 1
Formato: 22:19:44 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 217

Categoria: Connection
Frequencia: 1
Formato: 22:16:24 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 185

Categoria: Teleport
Frequencia: 1
Formato: 21:49:7 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 141

Categoria: Disconnection
Frequencia: 1
Formato: 19:36:42 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 153

Categoria: AdministrativeKill
Frequencia: 1
Formato: 19:26:42 | "[ADMIN]" (steamid=[STEAM64]) executed kill command on: "[STEAM64]"
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 146

Categoria: Teleport
Frequencia: 1
Formato: 19:25:23 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 143

Categoria: BanManager
Frequencia: 1
Formato: 19:40:47 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_19-40-47.txt, linha 113

Categoria: Disconnection
Frequencia: 1
Formato: 20:8:58 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 155

Categoria: Connection
Frequencia: 1
Formato: 19:37:35 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 154

Categoria: Teleport
Frequencia: 1
Formato: 19:25:23 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 142

Categoria: Teleport
Frequencia: 1
Formato: 19:25:20 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 138

Categoria: Connection
Frequencia: 1
Formato: 19:19:12 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 19:16:27 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 133

Categoria: Teleport
Frequencia: 1
Formato: 19:25:22 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 141

Categoria: Teleport
Frequencia: 1
Formato: 19:25:22 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 140

Categoria: Teleport
Frequencia: 1
Formato: 19:25:20 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 139

Categoria: Teleport
Frequencia: 1
Formato: 21:48:43 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 137

Categoria: Teleport
Frequencia: 1
Formato: 21:48:36 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 136

Categoria: Teleport
Frequencia: 1
Formato: 21:48:36 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 135

Categoria: Teleport
Frequencia: 1
Formato: 21:48:54 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 140

Categoria: Teleport
Frequencia: 1
Formato: 21:48:54 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 139

Categoria: Teleport
Frequencia: 1
Formato: 21:48:43 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 138

Categoria: Connection
Frequencia: 1
Formato: 21:48:9 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 20:24:6 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_20-24-6.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 20:24:6 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_20-24-6.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 19:40:47 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_19-40-47.txt, linha 133

Categoria: Error
Frequencia: 1
Formato: 21:20:20 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 21:20:20 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 113

Categoria: Connection
Frequencia: 1
Formato: 20:27:44 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_20-24-6.txt, linha 134

Categoria: Disconnection
Frequencia: 1
Formato: 23:27:47 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 145

Categoria: Disconnection
Frequencia: 1
Formato: 23:27:32 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 144

Categoria: Connection
Frequencia: 1
Formato: 23:19:33 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 143

Categoria: Connection
Frequencia: 1
Formato: 0:5:8 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 148

Categoria: Disconnection
Frequencia: 1
Formato: 0:0:46 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected early from server (EXIT NOW).
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 147

Categoria: Disconnection
Frequencia: 1
Formato: 0:0:44 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 146

Categoria: Connection
Frequencia: 1
Formato: 22:33:6 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 139

Categoria: Disconnection
Frequencia: 1
Formato: 22:28:30 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 138

Categoria: Disconnection
Frequencia: 1
Formato: 22:28:15 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 137

Categoria: Disconnection
Frequencia: 1
Formato: 23:13:16 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 142

Categoria: Disconnection
Frequencia: 1
Formato: 23:13:1 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 141

Categoria: Connection
Frequencia: 1
Formato: 22:38:6 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 140

Categoria: Connection
Frequencia: 1
Formato: 0:27:57 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 149

Categoria: Connection
Frequencia: 1
Formato: 1:34:33 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 158

Categoria: Disconnection
Frequencia: 1
Formato: 1:25:15 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 157

Categoria: Disconnection
Frequencia: 1
Formato: 1:25:0 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 156

Categoria: Error
Frequencia: 1
Formato: 15:31:57 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-18_15-31-56.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 15:31:57 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-18_15-31-56.txt, linha 113

Categoria: Disconnection
Frequencia: 1
Formato: 1:42:11 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 159

Categoria: Disconnection
Frequencia: 1
Formato: 1:5:53 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected early from server (EXIT NOW).
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 152

Categoria: Disconnection
Frequencia: 1
Formato: 1:5:52 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 151

Categoria: Disconnection
Frequencia: 1
Formato: 0:52:9 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 150

Categoria: Disconnection
Frequencia: 1
Formato: 1:10:57 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 155

Categoria: Disconnection
Frequencia: 1
Formato: 1:10:42 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 154

Categoria: Connection
Frequencia: 1
Formato: 1:10:9 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 153

Categoria: Connection
Frequencia: 1
Formato: 22:4:45 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 136

Categoria: Disconnection
Frequencia: 1
Formato: 22:40:53 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 239

Categoria: Disconnection
Frequencia: 1
Formato: 22:40:52 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 238

Categoria: Teleport
Frequencia: 1
Formato: 22:37:3 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 235

Categoria: BanManager
Frequencia: 1
Formato: 23:0:3 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_23-0-3.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 21:20:49 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_21-20-48.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 21:20:48 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_21-20-48.txt, linha 113

Categoria: Teleport
Frequencia: 1
Formato: 22:37:0 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 231

Categoria: Teleport
Frequencia: 1
Formato: 22:37:0 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 230

Categoria: Teleport
Frequencia: 1
Formato: 22:36:50 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 229

Categoria: Teleport
Frequencia: 1
Formato: 22:37:3 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 234

Categoria: Teleport
Frequencia: 1
Formato: 22:37:2 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 233

Categoria: Teleport
Frequencia: 1
Formato: 22:37:2 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_21-20-20.txt, linha 232

Categoria: Error
Frequencia: 1
Formato: 23:0:3 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_23-0-3.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 19:28:51 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 113

Categoria: Disconnection
Frequencia: 1
Formato: 18:9:11 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-17_16-25-19.txt, linha 136

Categoria: Disconnection
Frequencia: 1
Formato: 18:9:11 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-17_16-25-19.txt, linha 135

Categoria: Connection
Frequencia: 1
Formato: 21:3:9 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 135

Categoria: Connection
Frequencia: 1
Formato: 20:23:32 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 19:28:51 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-17_19-28-51.txt, linha 133

Categoria: Disconnection
Frequencia: 1
Formato: 23:19:17 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-16_23-0-3.txt, linha 136

Categoria: Disconnection
Frequencia: 1
Formato: 23:19:16 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_23-0-3.txt, linha 135

Categoria: Connection
Frequencia: 1
Formato: 23:10:57 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_23-0-3.txt, linha 134

Categoria: Connection
Frequencia: 1
Formato: 16:57:4 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-17_16-25-19.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 16:25:19 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-17_16-25-19.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:25:19 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-17_16-25-19.txt, linha 113

Categoria: Disconnection
Frequencia: 1
Formato: 18:13:5 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 159

Categoria: Connection
Frequencia: 1
Formato: 18:7:7 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 158

Categoria: Teleport
Frequencia: 1
Formato: 17:51:32 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 149

Categoria: AdministrativeKill
Frequencia: 1
Formato: 18:14:8 | "[ADMIN]" (steamid=[STEAM64]) executed kill command on: "[STEAM64]"
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 162

Categoria: Connection
Frequencia: 1
Formato: 18:13:43 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 161

Categoria: Disconnection
Frequencia: 1
Formato: 18:13:20 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 160

Categoria: Connection
Frequencia: 1
Formato: 17:39:42 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 133

Categoria: Error
Frequencia: 1
Formato: 17:37:47 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 132

Categoria: BanManager
Frequencia: 1
Formato: 17:37:47 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 112

Categoria: Teleport
Frequencia: 1
Formato: 17:51:32 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 148

Categoria: AdministrativeKill
Frequencia: 1
Formato: 17:48:53 | "[ADMIN]" (steamid=[STEAM64]) executed kill command on: "[STEAM64]"
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 142

Categoria: Connection
Frequencia: 1
Formato: 17:42:55 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 134

Categoria: AdministrativeKill
Frequencia: 1
Formato: 18:14:14 | "[ADMIN]" (steamid=[STEAM64]) executed kill command on: "[STEAM64]"
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 163

Categoria: BanManager
Frequencia: 1
Formato: 17:6:39 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_17-6-39.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 17:6:39 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_17-6-39.txt, linha 110

Categoria: Connection
Frequencia: 1
Formato: 18:30:29 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 193

Categoria: BanManager
Frequencia: 1
Formato: 17:9:38 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_17-9-38.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 17:9:38 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_17-9-38.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 17:6:40 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_17-6-39.txt, linha 133

Categoria: Teleport
Frequencia: 1
Formato: 18:24:8 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 189

Categoria: AdministrativeKill
Frequencia: 1
Formato: 18:21:12 | "[ADMIN]" (steamid=[STEAM64]) executed kill command on: "[STEAM64]"
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 187

Categoria: AdministrativeKill
Frequencia: 1
Formato: 18:21:8 | "[ADMIN]" (steamid=[STEAM64]) executed kill command on: "[STEAM64]"
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 185

Categoria: Disconnection
Frequencia: 1
Formato: 18:28:30 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 192

Categoria: Disconnection
Frequencia: 1
Formato: 18:28:15 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 191

Categoria: Teleport
Frequencia: 1
Formato: 18:24:8 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-15_17-37-47.txt, linha 190

Categoria: Error
Frequencia: 1
Formato: 16:27:35 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_16-27-35.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:27:35 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_16-27-35.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 16:27:35 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_16-27-35.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 16:38:30 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_16-38-30.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:38:30 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_16-38-30.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 16:38:30 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_16-38-30.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 16:10:22 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_16-10-22.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:10:22 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_16-10-22.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 16:10:22 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_16-10-22.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 16:20:41 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_16-20-40.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:20:41 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_16-20-40.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 16:20:41 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_16-20-40.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 16:41:45 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_16-41-45.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 16:7:43 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_16-7-43.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:7:43 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_16-7-43.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 16:7:43 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_16-7-43.txt, linha 110

Categoria: Error
Frequencia: 1
Formato: 17:20:59 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_17-20-59.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 17:20:59 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_17-20-59.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 17:20:59 | Error parsing credentials.txt! Please input a valid password, with no // at the start of the line!
Primeira ocorrencia: Log_2026-11-15_17-20-59.txt, linha 110

Categoria: Connection
Frequencia: 1
Formato: 16:58:12 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_16-41-45.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 16:41:45 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_16-41-45.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 16:41:45 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_16-41-45.txt, linha 113

Categoria: BanManager
Frequencia: 1
Formato: 16:6:10 | [BansManager]:: Save(): Saving ban list!
Primeira ocorrencia: Log_2026-11-15_16-6-10.txt, linha 119

Categoria: Disconnection
Frequencia: 1
Formato: 17:3:59 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected early from server (EXIT NOW).
Primeira ocorrencia: Log_2026-11-15_16-41-45.txt, linha 136

Categoria: Disconnection
Frequencia: 1
Formato: 17:3:58 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_16-41-45.txt, linha 135

Categoria: Error
Frequencia: 1
Formato: 17:9:38 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_17-9-38.txt, linha 133

Categoria: Teleport
Frequencia: 1
Formato: 15:33:23 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 164

Categoria: Teleport
Frequencia: 1
Formato: 15:32:56 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 163

Categoria: Teleport
Frequencia: 1
Formato: 15:32:56 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 162

Categoria: Teleport
Frequencia: 1
Formato: 15:33:52 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 167

Categoria: Teleport
Frequencia: 1
Formato: 15:33:52 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 166

Categoria: Teleport
Frequencia: 1
Formato: 15:33:23 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 165

Categoria: Teleport
Frequencia: 1
Formato: 15:32:46 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 158

Categoria: Connection
Frequencia: 1
Formato: 15:22:13 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 136

Categoria: Disconnection
Frequencia: 1
Formato: 15:20:46 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 135

Categoria: Teleport
Frequencia: 1
Formato: 15:32:54 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 161

Categoria: Teleport
Frequencia: 1
Formato: 15:32:54 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 160

Categoria: Teleport
Frequencia: 1
Formato: 15:32:46 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 159

Categoria: Teleport
Frequencia: 1
Formato: 15:33:54 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 168

Categoria: Error
Frequencia: 1
Formato: 18:45:49 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_18-45-49.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 18:45:49 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_18-45-49.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 15:47:49 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_15-47-49.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 19:16:27 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_19-16-27.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 19:14:38 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_19-14-38.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 19:14:38 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_19-14-38.txt, linha 113

Categoria: Teleport
Frequencia: 1
Formato: 15:33:57 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 171

Categoria: Teleport
Frequencia: 1
Formato: 15:33:57 | "[ADMIN]" (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 170

Categoria: Teleport
Frequencia: 1
Formato: 15:33:54 | "[ADMIN]": (steamid=[STEAM64]) teleported to (pos=[POSITION])
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 169

Categoria: BanManager
Frequencia: 1
Formato: 15:47:49 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_15-47-49.txt, linha 113

Categoria: Disconnection
Frequencia: 1
Formato: 15:34:40 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 173

Categoria: Disconnection
Frequencia: 1
Formato: 15:34:25 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 172

Categoria: Error
Frequencia: 1
Formato: 19:14:54 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_19-14-54.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 19:14:54 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_19-14-54.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 19:1:1 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_19-1-1.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 20:10:24 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_20-10-24.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 19:3:27 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_19-3-27.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 19:3:27 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_19-3-27.txt, linha 113

Categoria: Disconnection
Frequencia: 1
Formato: 17:18:30 | Player "[PLAYER]" (steamid=[STEAM64]) disconnected from server.
Primeira ocorrencia: Log_2026-11-15_17-9-38.txt, linha 136

Categoria: Disconnection
Frequencia: 1
Formato: 17:18:29 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_17-9-38.txt, linha 135

Categoria: Connection
Frequencia: 1
Formato: 17:12:17 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_17-9-38.txt, linha 134

Categoria: BanManager
Frequencia: 1
Formato: 19:1:1 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_19-1-1.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 18:57:45 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_18-57-45.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 18:57:45 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_18-57-45.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 20:10:24 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_20-10-24.txt, linha 133

Categoria: Disconnection
Frequencia: 1
Formato: 21:45:24 | Player "[PLAYER]" (steamid=[STEAM64]) initiated disconnect process...
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 206

Categoria: Connection
Frequencia: 1
Formato: 21:36:12 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 200

Categoria: Connection
Frequencia: 1
Formato: 21:30:9 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 187

Categoria: Connection
Frequencia: 1
Formato: 15:19:56 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 15:12:50 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 15:12:50 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-16_15-12-50.txt, linha 113

Categoria: BanManager
Frequencia: 1
Formato: 21:7:54 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 113

Categoria: Error
Frequencia: 1
Formato: 20:58:45 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_20-58-45.txt, linha 133

Categoria: BanManager
Frequencia: 1
Formato: 20:58:45 | [BansManager]:: Load(): Loading ban list Json File $profile:VPPAdminTools/BanList.json
Primeira ocorrencia: Log_2026-11-15_20-58-45.txt, linha 113

Categoria: Connection
Frequencia: 1
Formato: 21:14:18 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 135

Categoria: Connection
Frequencia: 1
Formato: 21:9:51 | Player "[PLAYER]" (steamid=[STEAM64]) connected to server!
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 134

Categoria: Error
Frequencia: 1
Formato: 21:7:54 | [SteamAPIManager] ERROR No steam API key configured, and or key is invalid.
Primeira ocorrencia: Log_2026-11-15_21-7-54.txt, linha 133

==================================================
6. DISTRIBUICAO POR ARQUIVO
==================================================

Arquivo_Categoria                               Count
-----------------                               -----
Log_2026-11-15_16-10-22.txt, BanManager             1
Log_2026-11-15_16-10-22.txt, Error                  2
Log_2026-11-15_16-20-40.txt, BanManager             1
Log_2026-11-15_16-20-40.txt, Error                  2
Log_2026-11-15_16-27-35.txt, BanManager             1
Log_2026-11-15_16-27-35.txt, Error                  2
Log_2026-11-15_16-38-30.txt, BanManager             1
Log_2026-11-15_16-38-30.txt, Error                  2
Log_2026-11-15_16-41-45.txt, BanManager             1
Log_2026-11-15_16-41-45.txt, Connection             1
Log_2026-11-15_16-41-45.txt, Disconnection          2
Log_2026-11-15_16-41-45.txt, Error                  2
Log_2026-11-15_16-6-10.txt, BanManager              1
Log_2026-11-15_16-7-43.txt, BanManager              1
Log_2026-11-15_16-7-43.txt, Error                   2
Log_2026-11-15_17-20-59.txt, BanManager             1
Log_2026-11-15_17-20-59.txt, Connection             2
Log_2026-11-15_17-20-59.txt, Disconnection          2
Log_2026-11-15_17-20-59.txt, Error                  2
Log_2026-11-15_17-37-47.txt, AdministrativeKill     5
Log_2026-11-15_17-37-47.txt, BanManager             1
Log_2026-11-15_17-37-47.txt, Connection             5
Log_2026-11-15_17-37-47.txt, Disconnection         10
Log_2026-11-15_17-37-47.txt, Error                  1
Log_2026-11-15_17-37-47.txt, Teleport               4
Log_2026-11-15_17-6-39.txt, BanManager              1
Log_2026-11-15_17-6-39.txt, Error                   2
Log_2026-11-15_17-9-38.txt, BanManager              1
Log_2026-11-15_17-9-38.txt, Connection              1
Log_2026-11-15_17-9-38.txt, Disconnection           2
Log_2026-11-15_17-9-38.txt, Error                   2
Log_2026-11-15_18-57-45.txt, BanManager             1
Log_2026-11-15_18-57-45.txt, Error                  1
Log_2026-11-15_19-1-1.txt, BanManager               1
Log_2026-11-15_19-1-1.txt, Error                    1
Log_2026-11-15_19-14-54.txt, BanManager             1
Log_2026-11-15_19-14-54.txt, Error                  1
Log_2026-11-15_19-3-27.txt, BanManager              1
Log_2026-11-15_19-3-27.txt, Error                   1
Log_2026-11-15_20-10-24.txt, BanManager             1
Log_2026-11-15_20-10-24.txt, Error                  1
Log_2026-11-15_20-58-45.txt, BanManager             1
Log_2026-11-15_20-58-45.txt, Error                  1
Log_2026-11-15_21-7-54.txt, BanManager              1
Log_2026-11-15_21-7-54.txt, Connection              4
Log_2026-11-15_21-7-54.txt, Disconnection           4
Log_2026-11-15_21-7-54.txt, Error                   1
Log_2026-11-16_15-12-50.txt, BanManager             1
Log_2026-11-16_15-12-50.txt, Connection             2
Log_2026-11-16_15-12-50.txt, Disconnection          3
Log_2026-11-16_15-12-50.txt, Error                  1
Log_2026-11-16_15-12-50.txt, Teleport              14
Log_2026-11-16_15-47-49.txt, BanManager             1
Log_2026-11-16_15-47-49.txt, Error                  1
Log_2026-11-16_18-45-49.txt, BanManager             1
Log_2026-11-16_18-45-49.txt, Error                  1
Log_2026-11-16_19-14-38.txt, BanManager             1
Log_2026-11-16_19-14-38.txt, Error                  1
Log_2026-11-16_19-16-27.txt, AdministrativeKill     1
Log_2026-11-16_19-16-27.txt, BanManager             1
Log_2026-11-16_19-16-27.txt, Connection             2
Log_2026-11-16_19-16-27.txt, Disconnection          2
Log_2026-11-16_19-16-27.txt, Error                  1
Log_2026-11-16_19-16-27.txt, Teleport               6
Log_2026-11-16_19-40-47.txt, BanManager             1
Log_2026-11-16_19-40-47.txt, Error                  1
Log_2026-11-16_20-24-6.txt, BanManager              1
Log_2026-11-16_20-24-6.txt, Connection              1
Log_2026-11-16_20-24-6.txt, Error                   1
Log_2026-11-16_21-20-20.txt, BanManager             1
Log_2026-11-16_21-20-20.txt, Connection             3
Log_2026-11-16_21-20-20.txt, Disconnection          7
Log_2026-11-16_21-20-20.txt, Error                  1
Log_2026-11-16_21-20-20.txt, Teleport              34
Log_2026-11-16_21-20-48.txt, BanManager             1
Log_2026-11-16_21-20-48.txt, Error                  1
Log_2026-11-16_23-0-3.txt, BanManager               1
Log_2026-11-16_23-0-3.txt, Connection               1
Log_2026-11-16_23-0-3.txt, Disconnection            2
Log_2026-11-16_23-0-3.txt, Error                    1
Log_2026-11-17_16-25-19.txt, BanManager             1
Log_2026-11-17_16-25-19.txt, Connection             1
Log_2026-11-17_16-25-19.txt, Disconnection          2
Log_2026-11-17_16-25-19.txt, Error                  1
Log_2026-11-17_19-28-51.txt, BanManager             1
Log_2026-11-17_19-28-51.txt, Connection            10
Log_2026-11-17_19-28-51.txt, Disconnection         16
Log_2026-11-17_19-28-51.txt, Error                  1
Log_2026-11-18_15-31-56.txt, BanManager             1
Log_2026-11-18_15-31-56.txt, Error                  1



==================================================
7. SEGURANCA
==================================================
Somente leitura.
Nenhum servico iniciado.
Nenhum banco acessado.
Nenhum webhook enviado.
Nenhuma configuracao alterada.
Nomes, SteamIDs e coordenadas foram mascarados na saida.
**********************
Fim da transcrição do Windows PowerShell
Hora de término: 20261119132304
**********************
