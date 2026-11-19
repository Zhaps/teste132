**********************
Início da transcrição do Windows PowerShell
Hora de início: 20261119140802
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

==================================================
RAVEN CONTROL CENTER - AUDITORIA DE INTEGRACAO VPP
==================================================

[1] DIRETORIOS PRINCIPAIS


[2] PROJETOS NODE.JS

--- C:\RavenRP\ControlCenter\API\package.json ---
Nome: raven-control-api
Versao: 1.0.0
Scripts:
FullName                    LastWriteTime
--------                    -------------
C:\RavenRP\Auditorias       19/11/2026 13:28:09
C:\RavenRP\Backups          17/11/2026 21:27:26
C:\RavenRP\ControlCenter    19/11/2026 10:40:38
C:\RavenRP\Data             17/11/2026 15:09:22
C:\RavenRP\DayZServer       18/11/2026 12:30:18
C:\RavenRP\Discord-KillFeed 16/11/2026 16:37:57
C:\RavenRP\Logs             17/11/2026 16:49:29
C:\RavenRP\Monitoring       17/11/2026 15:09:22
C:\RavenRP\Tools            17/11/2026 17:24:36




test       : node --test
start      : node src/server.js
dev        : node --watch src/server.js
db:migrate : node src/services/migrate.js



Dependencias:
bcryptjs
cors
dotenv
express
express-rate-limit
helmet
jose
pg
pino
pino-http
zod

--- C:\RavenRP\ControlCenter\Dashboard\package.json ---
Nome: raven-control-center-dashboard
Versao: 1.0.0
Scripts:


start : node server.js



Dependencias:

[3] ESTRUTURA DE CODIGO

FullName                                                                                                                            Length LastWriteTime
--------                                                                                                                            ------ -------------
C:\RavenRP\Backups\API\server_20261117_212726.js                                                                                      2756 17/11/2026 17:39:12
C:\RavenRP\Backups\API\server_before_priority_20261117_214916.js                                                                      2837 17/11/2026 21:27:26
C:\RavenRP\ControlCenter\API\package-lock.json                                                                                       54241 17/11/2026 17:36:47
C:\RavenRP\ControlCenter\API\package.json                                                                                              810 17/11/2026 21:10:18
C:\RavenRP\ControlCenter\API\backups\empty-list-protection-20261118-202749\priority-sync.js                                           5916 18/11/2026 19:43:53
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                                                          4551 18/11/2026 21:18:14
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js                                                   2298 18/11/2026 21:35:10
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js                                               4454 18/11/2026 20:05:52
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js                                             4454 18/11/2026 20:05:52
C:\RavenRP\ControlCenter\API\backups\priority-sync-fix-20261118-194353\priority-sync.js                                               5872 18/11/2026 19:42:14
C:\RavenRP\ControlCenter\API\backups\shutdown-20261118-200552\priority-scheduler.js                                                   1403 18/11/2026 19:42:14
C:\RavenRP\ControlCenter\API\backups\shutdown-20261118-200552\server.js                                                               3274 17/11/2026 21:49:16
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql                                                                        5373 17/11/2026 21:09:26
C:\RavenRP\ControlCenter\API\migrations\002_priority_integrity.sql                                                                     995 17/11/2026 21:44:57
C:\RavenRP\ControlCenter\API\migrations\003_system_incidents.sql                                                                       850 18/11/2026 21:56:06
C:\RavenRP\ControlCenter\API\scripts\create-owner.js                                                                                  1999 17/11/2026 21:18:39
C:\RavenRP\ControlCenter\API\scripts\priority-sync-dry-run.js                                                                          805 18/11/2026 19:42:14
C:\RavenRP\ControlCenter\API\src\db.js                                                                                                 821 17/11/2026 17:39:12
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                                                                       1343 18/11/2026 21:18:14
C:\RavenRP\ControlCenter\API\src\logger.js                                                                                            3809 19/11/2026 08:44:42
C:\RavenRP\ControlCenter\API\src\server.js                                                                                            4735 19/11/2026 08:53:46
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js                                                                           2250 17/11/2026 21:27:16
C:\RavenRP\ControlCenter\API\src\middleware\require-role.js                                                                            381 17/11/2026 21:48:47
C:\RavenRP\ControlCenter\API\src\routes\audit.js                                                                                      2648 17/11/2026 21:49:11
C:\RavenRP\ControlCenter\API\src\routes\auth.js                                                                                       2829 17/11/2026 22:10:38
C:\RavenRP\ControlCenter\API\src\routes\health.js                                                                                     2512 18/11/2026 21:47:00
C:\RavenRP\ControlCenter\API\src\routes\incidents.js                                                                                  2041 18/11/2026 21:47:00
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js                                                                                   1914 18/11/2026 21:18:14
C:\RavenRP\ControlCenter\API\src\routes\logs.js                                                                                       8184 19/11/2026 08:53:46
C:\RavenRP\ControlCenter\API\src\routes\players.js                                                                                    4340 17/11/2026 21:48:53
C:\RavenRP\ControlCenter\API\src\routes\priority.js                                                                                  16995 17/11/2026 21:49:02
C:\RavenRP\ControlCenter\API\src\services\audit.js                                                                                     671 17/11/2026 21:48:47
C:\RavenRP\ControlCenter\API\src\services\auth.js                                                                                     1166 17/11/2026 21:27:16
C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js                                                                         2719 18/11/2026 21:47:00
C:\RavenRP\ControlCenter\API\src\services\migrate.js                                                                                  3478 17/11/2026 21:10:01
C:\RavenRP\ControlCenter\API\src\services\priority-format.js                                                                           541 18/11/2026 19:43:53
C:\RavenRP\ControlCenter\API\src\services\priority-scheduler.js                                                                       1804 18/11/2026 20:05:52
C:\RavenRP\ControlCenter\API\src\services\priority-status.js                                                                          1799 17/11/2026 21:48:47
C:\RavenRP\ControlCenter\API\src\services\priority-sync-guard.js                                                                       312 18/11/2026 20:27:49
C:\RavenRP\ControlCenter\API\src\services\priority-sync-guard.test.js                                                                  937 18/11/2026 20:27:49
C:\RavenRP\ControlCenter\API\src\services\priority-sync.js                                                                            6915 18/11/2026 20:27:49
C:\RavenRP\ControlCenter\API\src\services\priority-sync.test.js                                                                        911 18/11/2026 19:43:53
C:\RavenRP\ControlCenter\API\src\services\transaction.js                                                                               464 17/11/2026 21:48:47
C:\RavenRP\ControlCenter\Dashboard\package.json                                                                                        200 18/11/2026 20:40:39
C:\RavenRP\ControlCenter\Dashboard\server.js                                                                                          1613 18/11/2026 20:40:39
C:\RavenRP\DayZServer\@BuildingFortifications\Configs\BuildingFortifications\Fortifications Settings.json                            11060 16/11/2026 15:43:47
C:\RavenRP\DayZServer\@CookZ\cookz_expansion_trader_example.json                                                                     26471 16/11/2026 15:43:18
C:\RavenRP\DayZServer\@ZensNotes\extras\ZenNotesConfig.json                                                                            802 16/11/2026 15:43:37
C:\RavenRP\DayZServer\mpmissions\dayzOffline.chernarusplus\cfgeffectarea.json                                                         6280 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.chernarusplus\cfggameplay.json                                                           3047 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.chernarusplus\cfgundergroundtriggers.json                                                  35 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.enoch\cfgeffectarea.json                                                                 5233 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.enoch\cfggameplay.json                                                                   3082 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.enoch\cfgundergroundtriggers.json                                                        4681 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara\cfgbunkerbroadcast.json                                                          2809 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara\cfgeffectarea.json                                                               6868 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara\cfgexternallocks.json                                                             153 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara\cfggameplay.json                                                                 3615 15/11/2026 16:29:23
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara\cfgundergroundtriggers.json                                                   1187209 15/11/2026 00:48:24
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara\CookZ\CookZ_V003.json                                                             532 16/11/2026 16:14:38
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara.BACKUP\cfgbunkerbroadcast.json                                                   2809 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara.BACKUP\cfgeffectarea.json                                                        6868 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara.BACKUP\cfgexternallocks.json                                                      153 15/11/2026 00:51:53
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara.BACKUP\cfggameplay.json                                                          3615 15/11/2026 16:29:23
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara.BACKUP\cfgundergroundtriggers.json                                            1187209 15/11/2026 00:48:24
C:\RavenRP\DayZServer\mpmissions\dayzOffline.nasdara.BACKUP\CookZ\CookZ_V003.json                                                      532 16/11/2026 16:14:38
C:\RavenRP\DayZServer\mpmissions\dayzOffline.sakhal\cfgeffectarea.json                                                               11223 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.sakhal\cfggameplay.json                                                                  3119 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.sakhal\cfgundergroundtriggers.json                                                      11399 15/11/2026 00:51:54
C:\RavenRP\DayZServer\mpmissions\dayzOffline.sakhal\pra\warheadstorage.json                                                            386 15/11/2026 00:51:54
C:\RavenRP\DayZServer\profiles\Buddys_Whistle\Buddys_Whistle_Config.json                                                               123 16/11/2026 12:47:49
C:\RavenRP\DayZServer\profiles\BuildingFortifications\Fortifications Settings.json                                                   16497 15/11/2026 17:58:45
C:\RavenRP\DayZServer\profiles\CodeLock\CodeLockConfig.json                                                                            439 18/11/2026 12:31:57
C:\RavenRP\DayZServer\profiles\CodeLock\CodeLockPerms.json                                                                             416 18/11/2026 18:34:41
C:\RavenRP\DayZServer\profiles\KomodoDragon\KomodoDragon.json                                                                          191 18/11/2026 12:31:57
C:\RavenRP\DayZServer\profiles\Suppression\SuppressionSettings.json                                                                    192 16/11/2026 15:45:48
C:\RavenRP\DayZServer\profiles\VPPAdminTools\BanList.json                                                                              457 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\LogOptions.json                                                                            50 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\SpectateRecovery.json                                                                      23 15/11/2026 14:49:09
C:\RavenRP\DayZServer\profiles\VPPAdminTools\ConfigurablePlugins\SteamAPI.json                                                         102 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\ConfigurablePlugins\BuildingSetManager\BuildingSetJournal.json                             55 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\ConfigurablePlugins\TeleportManager\TeleportLocation.json                                4316 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\ConfigurablePlugins\TimeManager\TimeSettingsPresets.json                                  212 15/11/2026 14:58:16
C:\RavenRP\DayZServer\profiles\VPPAdminTools\ConfigurablePlugins\WeatherManager\WeatherSettingsPresets.json                             29 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\Permissions\UserGroups\UserGroups.json                                                   4649 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\VPPAdminTools\XMLEditor\XMLEditorSettings.json                                                          328 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\Zenarchist\ZenNotesConfig.json                                                                          889 16/11/2026 12:12:50
C:\RavenRP\DayZServer\profiles\Zenarchist\Core\ZenCoreConfig.json                                                                     1540 16/11/2026 12:12:50
C:\RavenRP\Discord-KillFeed\sql\schema.sql                                                                                             758 16/11/2026 13:43:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1031.js                                                                                   288212 10/11/2026 18:00:06
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1047.js                                                                                   909190 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1103.js                                                                                    11836 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1151.js                                                                                    12448 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1189.js                                                                                    12427 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1229.js                                                                                   301272 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1319.js                                                                                    12110 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1359.js                                                                                   327729 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1498.js                                                                                    16482 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1595.js                                                                                    13320 19/11/2024 11:57:24
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1695.js                                                                                    40013 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1698.js                                                                                    13574 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1864.js                                                                                   276104 18/12/2025 11:14:26
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1891.js                                                                                    11834 20/08/2025 11:12:30
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1939.js                                                                                     9899 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\196.js                                                                                     11996 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\20.js                                                                                      44365 09/11/2026 16:54:38
C:\RavenRP\Tools\SteamCMD\siteserverui\js\200.js                                                                                    261159 02/12/2025 11:14:04
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2165.js                                                                                    16541 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2269.js                                                                                   272125 18/12/2025 14:22:38
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2330.js                                                                                   356801 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2378.js                                                                                   426269 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2444.js                                                                                    11315 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2589.js                                                                                   344218 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2711.js                                                                                   320543 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2736.js                                                                                   351090 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2889.js                                                                                   276252 04/12/2025 11:19:04
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2895.js                                                                                    10508 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\295.js                                                                                    283367 19/12/2025 11:11:52
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3248.js                                                                                   325770 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3296.js                                                                                   365997 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3301.js                                                                                   909194 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3380.js                                                                                    11804 08/10/2024 11:11:06
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3518.js                                                                                    11259 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\361.js                                                                                    759045 09/11/2026 16:15:12
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3723.js                                                                                    22873 15/11/2025 00:24:04
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3789.js                                                                                   388932 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3800.js                                                                                   249089 01/12/2025 18:47:14
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3814.js                                                                                    40680 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3907.js                                                                                   261424 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4111.js                                                                                    11171 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4122.js                                                                                   359020 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4175.js                                                                                  1021740 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4230.js                                                                                   462434 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4279.js                                                                                    42889 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4289.js                                                                                   259090 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4401.js                                                                                   312550 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4419.js                                                                                   285657 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4468.js                                                                                    11013 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4539.js                                                                                     3582 09/10/2026 08:33:48
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4625.js                                                                                   261567 03/12/2025 11:15:50
C:\RavenRP\Tools\SteamCMD\siteserverui\js\465.js                                                                                     17512 14/10/2024 14:24:34
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4719.js                                                                                    11298 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4725.js                                                                                    11991 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4732.js                                                                                    12339 17/03/2025 11:11:46
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4750.js                                                                                   278785 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4792.js                                                                                   273777 04/12/2025 11:19:04
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4846.js                                                                                    14708 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\488.js                                                                                       117 27/08/2025 13:10:16
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4955.js                                                                                    12355 11/08/2025 11:15:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4978.js                                                                                   269608 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5001.js                                                                                    11286 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5024.js                                                                                    11832 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5040.js                                                                                   287377 03/12/2025 11:15:50
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5088.js                                                                                    18274 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5191.js                                                                                   246995 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5233.js                                                                                   276427 02/12/2025 11:14:04
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5291.js                                                                                    11767 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5294.js                                                                                    11867 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5319.js                                                                                   304601 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5436.js                                                                                   244846 11/12/2025 06:13:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\559.js                                                                                    276893 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5701.js                                                                                    10932 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5777.js                                                                                   366263 18/12/2025 18:18:30
C:\RavenRP\Tools\SteamCMD\siteserverui\js\578.js                                                                                     13695 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\5802.js                                                                                    11488 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6125.js                                                                                    12018 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6512.js                                                                                   258788 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6556.js                                                                                    11826 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\662.js                                                                                    406350 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6680.js                                                                                    13881 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6736.js                                                                                   278171 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6742.js                                                                                    38104 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6752.js                                                                                     9872 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\684.js                                                                                    326678 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\6975.js                                                                                    12700 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7046.js                                                                                   313606 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7077.js                                                                                    14663 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7246.js                                                                                   366202 04/12/2025 11:19:04
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7263.js                                                                                   309954 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7476.js                                                                                    17993 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\764.js                                                                                    480759 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7688.js                                                                                   315154 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7700.js                                                                                   360404 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7885.js                                                                                    11294 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\7896.js                                                                                    12433 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8010.js                                                                                   559801 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8050.js                                                                                    17480 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\815.js                                                                                    274696 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8356.js                                                                                   305170 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8449.js                                                                                    35639 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8476.js                                                                                   313337 12/12/2025 11:21:26
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8499.js                                                                                    13759 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8515.js                                                                                   309611 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8564.js                                                                                    10917 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8676.js                                                                                    12710 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8765.js                                                                                    11047 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\8876.js                                                                                    10496 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9274.js                                                                                    11871 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9333.js                                                                                   320812 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9400.js                                                                                    13097 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9423.js                                                                                    14016 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9431.js                                                                                   329160 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9574.js                                                                                   269115 10/12/2025 05:05:14
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9666.js                                                                                    22495 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9668.js                                                                                   397321 03/12/2025 11:15:50
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9709.js                                                                                    37900 05/10/2026 16:56:02
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9745.js                                                                                    11898 28/06/2024 16:27:40
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9845.js                                                                                    11697 12/11/2024 11:13:12
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9850.js                                                                                    22577 23/12/2024 11:11:34
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9854.js                                                                                   983057 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9863.js                                                                                   293478 02/12/2025 19:27:42
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9965.js                                                                                   403200 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\9998.js                                                                                   917021 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\siteserverui\js\libraries~b28b7af69.js                                                                    558328 28/10/2026 20:54:24
C:\RavenRP\Tools\SteamCMD\siteserverui\js\main.js                                                                                   454047 05/11/2026 19:51:36
C:\RavenRP\Tools\SteamCMD\siteserverui\js\manifest.js                                                                                 4961 11/11/2026 15:41:22
C:\RavenRP\Tools\SteamCMD\steamapps\workshop\content\221100\2670506982\Configs\BuildingFortifications\Fortifications Settings.json   11060 17/11/2026 13:18:49
C:\RavenRP\Tools\SteamCMD\steamapps\workshop\content\221100\2857994912\extras\ZenNotesConfig.json                                      802 17/11/2026 13:18:37
C:\RavenRP\Tools\SteamCMD\steamapps\workshop\content\221100\3302732231\cookz_expansion_trader_example.json                           26471 17/11/2026 13:18:16



[4] ARQUIVOS DE CONFIGURACAO (SEM EXPOR SEGREDOS)

FullName                                                                                                     Length LastWriteTime
--------                                                                                                     ------ -------------
C:\RavenRP\VPP_Auditoria_Configuracoes.txt                                                                   478808 19/11/2026 13:12:24
C:\RavenRP\Auditorias\Bloco5_Auditoria_Config_WebHooks_VPP.txt                                                11932 19/11/2026 13:25:15
C:\RavenRP\Auditorias\Bloco5_Auditoria_Global_WebHooks_Profiles.txt                                            9506 19/11/2026 13:28:10
C:\RavenRP\Auditorias\Bloco5_Auditoria_Localizacao_WebHooks_VPP.txt                                           49064 19/11/2026 13:27:20
C:\RavenRP\ControlCenter\API\.env                                                                               442 18/11/2026 19:56:45
C:\RavenRP\ControlCenter\API\.env.backup-20261118-195645                                                        386 17/11/2026 21:18:32
C:\RavenRP\ControlCenter\API\.env.example                                                                       277 17/11/2026 17:38:58
C:\RavenRP\DayZServer\@VPPAdminTools\!No, the configuration isn't here                                            0 16/11/2026 15:43:13
C:\RavenRP\DayZServer\@VPPAdminTools\Configs of mod are in profiles folder                                        0 16/11/2026 15:43:13
C:\RavenRP\DayZServer\@ZensNotes\extras\ZenNotesConfig.json                                                     802 16/11/2026 15:43:37
C:\RavenRP\DayZServer\battleye\Bec\Config\Config.cfg                                                            160 15/11/2026 13:16:59
C:\RavenRP\DayZServer\config\config.vdf                                                                       10067 18/11/2026 17:48:25
C:\RavenRP\DayZServer\logs\configstore_log.txt                                                                10996 18/11/2026 17:48:25
C:\RavenRP\DayZServer\mpmissions\dayzOffline.sakhal\config.cpp                                                  197 15/11/2026 00:51:53
C:\RavenRP\DayZServer\profiles\Buddys_Whistle\Buddys_Whistle_Config.json                                        123 16/11/2026 12:47:49
C:\RavenRP\DayZServer\profiles\CodeLock\CodeLockConfig.json                                                     439 18/11/2026 12:31:57
C:\RavenRP\DayZServer\profiles\VPPAdminTools\Permissions\webhooks_perms_v1.txt                                    1 15/11/2026 13:06:10
C:\RavenRP\DayZServer\profiles\Zenarchist\ZenNotesConfig.json                                                   889 16/11/2026 12:12:50
C:\RavenRP\DayZServer\profiles\Zenarchist\Core\ZenCoreConfig.json                                              1540 16/11/2026 12:12:50
C:\RavenRP\Discord-KillFeed\.env                                                                                522 16/11/2026 15:27:23
C:\RavenRP\Discord-KillFeed\.env.example                                                                        438 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\database.py                                                               2663 16/11/2026 13:43:41
C:\RavenRP\Discord-KillFeed\killfeed\__pycache__\database.cpython-311.pyc                                      4668 16/11/2026 13:51:16
C:\RavenRP\Discord-KillFeed\killfeed\__pycache__\database.cpython-313.pyc                                      4388 16/11/2026 13:43:41
C:\RavenRP\Tools\SteamCMD\config\config.vdf                                                                   19655 17/11/2026 13:18:51
C:\RavenRP\Tools\SteamCMD\logs\configstore_log.txt                                                            45284 17/11/2026 13:18:51
C:\RavenRP\Tools\SteamCMD\steamapps\workshop\content\221100\1828439124\!No, the configuration isn't here          0 17/11/2026 13:18:12
C:\RavenRP\Tools\SteamCMD\steamapps\workshop\content\221100\1828439124\Configs of mod are in profiles folder      0 17/11/2026 13:18:12
C:\RavenRP\Tools\SteamCMD\steamapps\workshop\content\221100\2857994912\extras\ZenNotesConfig.json               802 17/11/2026 13:18:37
C:\RavenRP\Tools\SteamCMD\userdata\236427630\7\remote\sharedconfig.vdf                                         1404 10/07/2026 11:04:01
C:\RavenRP\Tools\SteamCMD\userdata\236427630\config\localconfig.vdf                                           49182 17/11/2026 13:18:10



[5] REFERENCIAS A INTEGRACAO E EVENTOS

--- Busca: express ---

Path                                                                                      LineNumber Trecho
----                                                                                      ---------- ------
C:\RavenRP\Backups\API\server_20261117_212726.js                                                   9 const express = require('express');
C:\RavenRP\Backups\API\server_20261117_212726.js                                                  12 const rateLimit = require('express-rate-limit');
C:\RavenRP\Backups\API\server_20261117_212726.js                                                  19 const app = express();
C:\RavenRP\Backups\API\server_20261117_212726.js                                                  49 app.use(express.json({ limit: '1mb' }));
C:\RavenRP\Backups\API\server_20261117_212726.js                                                  50 app.use(express.urlencoded({ extended: false, limit: '1mb' }));
C:\RavenRP\Backups\API\server_before_priority_20261117_214916.js                                   9 const express = require('express');
C:\RavenRP\Backups\API\server_before_priority_20261117_214916.js                                  12 const rateLimit = require('express-rate-limit');
C:\RavenRP\Backups\API\server_before_priority_20261117_214916.js                                  20 const app = express();
C:\RavenRP\Backups\API\server_before_priority_20261117_214916.js                                  50 app.use(express.json({ limit: '1mb' }));
C:\RavenRP\Backups\API\server_before_priority_20261117_214916.js                                  51 app.use(express.urlencoded({ extended: false, limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                       9 const express = require('express');
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                      12 const rateLimit = require('express-rate-limit');
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                      25 const app = express();
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                      55 app.use(express.json({ limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                      56 app.use(express.urlencoded({ extended: false, limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js                3 const express = require('express');
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js                7 const router = express.Router();
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js            9 const express = require('express');
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js           12 const rateLimit = require('express-rate-limit');
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js           24 const app = express();
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js           54 app.use(express.json({ limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js           55 app.use(express.urlencoded({ extended: false, limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js          9 const express = require('express');
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js         12 const rateLimit = require('express-rate-limit');
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js         24 const app = express();
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js         54 app.use(express.json({ limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js         55 app.use(express.urlencoded({ extended: false, limit: '1mb' }));
C:\RavenRP\ControlCenter\API\backups\shutdown-20261118-200552\server.js                            9 const express = require('express');
C:\RavenRP\ControlCenter\API\backups\shutdown-20261118-200552\server.js                           12 const rateLimit = require('express-rate-limit');
C:\RavenRP\ControlCenter\API\backups\shutdown-20261118-200552\server.js                           24 const app = express();



--- Busca: router ---

Path                                                                                LineNumber Trecho
----                                                                                ---------- ------
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js          7 const router = express.Router();
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         35 router.get('/', async (req, res) => {
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         77 router.get('/live', (req, res) => {
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         86 module.exports = router;
C:\RavenRP\ControlCenter\API\src\routes\audit.js                                            10 const router = express.Router();
C:\RavenRP\ControlCenter\API\src\routes\audit.js                                            12 router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\audit.js                                            13 router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\audit.js                                            23 router.get('/', async (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\audit.js                                           102 module.exports = router;
C:\RavenRP\ControlCenter\API\src\routes\auth.js                                             12 const router = express.Router();
C:\RavenRP\ControlCenter\API\src\routes\auth.js                                             41 router.post('/login', loginLimiter, async (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\auth.js                                            111 router.get('/me', requireAuth, (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\auth.js                                            117 module.exports = router;
C:\RavenRP\ControlCenter\API\src\routes\health.js                                            8 const router = express.Router();
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           36 router.get('/', async (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           83 router.get('/live', (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           92 module.exports = router;
C:\RavenRP\ControlCenter\API\src\routes\incidents.js                                        10 const router = express.Router();
C:\RavenRP\ControlCenter\API\src\routes\incidents.js                                        12 router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\incidents.js                                        13 router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\incidents.js                                        20 router.get('/', async (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\incidents.js                                        75 module.exports = router;
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js                                          8 const router = express.Router();
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js                                          9 router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js                                         17 router.get('/', async (req, res) => {
C:\RavenRP\ControlCenter\API\src\routes\killfeed.js                                         64 module.exports = router;
C:\RavenRP\ControlCenter\API\src\routes\logs.js                                             11 const router = express.Router();
C:\RavenRP\ControlCenter\API\src\routes\logs.js                                             19 router.use(requireAuth);
C:\RavenRP\ControlCenter\API\src\routes\logs.js                                             20 router.use(requireRole('owner', 'admin'));
C:\RavenRP\ControlCenter\API\src\routes\logs.js                                            197 router.get('/', async (req, res) => {



--- Busca: webhook ---

--- Busca: postgres ---

Path                                                                                      LineNumber Trecho
----                                                                                      ---------- ------
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                     158 logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js               37 checkDatabase(pool, req, 'postgresql'),
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-20261118_211705\API-server.js          156 logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
C:\RavenRP\ControlCenter\API\backups\killfeed-integration-retry-20261118_211814\server.js        156 logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
C:\RavenRP\ControlCenter\API\migrations\003_system_incidents.sql                                   4 CHECK (component IN ('postgresql', 'killfeed')),
C:\RavenRP\ControlCenter\API\src\db.js                                                            30 logger.error({ error }, 'Erro inesperado no pool PostgreSQL');
C:\RavenRP\ControlCenter\API\src\server.js                                                       162 logger.error({ error }, 'Falha ao encerrar pool PostgreSQL');
C:\RavenRP\ControlCenter\API\src\middleware\require-auth.js                                       54 req.log.error({ error }, 'PostgreSQL indisponivel');
C:\RavenRP\ControlCenter\API\src\routes\health.js                                                 38 checkDatabase(pool, req, 'postgresql'),
C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js                                     19 VALUES ('postgresql', 'critical', $1::jsonb, $2, $3)`,
C:\RavenRP\ControlCenter\API\src\services\incident-monitor.js                                     22 description: 'Indisponibilidade do PostgreSQL principal',



--- Busca: pg\.Pool ---

--- Busca: CREATE TABLE ---

Path                                                             LineNumber Trecho
----                                                             ---------- ------
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql            1 CREATE TABLE public.players (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           12 CREATE TABLE public.admin_users (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           24 CREATE TABLE public.priority_categories (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           35 CREATE TABLE public.priority_grants (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           54 CREATE TABLE public.discord_accounts (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           64 CREATE TABLE public.audit_logs (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           78 CREATE TABLE public.system_settings (
C:\RavenRP\ControlCenter\API\migrations\001_initial_schema.sql           85 CREATE TABLE public.queue_sync_runs (
C:\RavenRP\ControlCenter\API\migrations\003_system_incidents.sql          1 CREATE TABLE public.system_incidents (
C:\RavenRP\ControlCenter\API\src\services\migrate.js                     31 CREATE TABLE IF NOT EXISTS public.schema_migrations (
C:\RavenRP\Discord-KillFeed\sql\schema.sql                                1 CREATE TABLE IF NOT EXISTS pvp_kills (



--- Busca: kill ---

Path                                                                                LineNumber Trecho
----                                                                                ---------- ------
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                22 const killfeedRoutes = require('./routes/killfeed');
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\server.js                78 app.use('/api/killfeed', killfeedRoutes);
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js          5 const { killfeedPool } = require('../killfeed-db');
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         36 const [primaryDatabase, killfeedDatabase] = await Promise.all([
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         38 checkDatabase(killfeedPool, req, 'killfeed')
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         42 const killfeedConnected = killfeedDatabase.status === 'connected';
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         46 : killfeedConnected
C:\RavenRP\ControlCenter\API\backups\incidents\20261118-214700\src\routes\health.js         66 killfeed: killfeedDatabase
C:\RavenRP\ControlCenter\API\migrations\003_system_incidents.sql                             4 CHECK (component IN ('postgresql', 'killfeed')),
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                              9 const secretPath = process.env.KILLFEED_READER_SECRET_FILE ||
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             13 'killfeed-reader-secret.b64'
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             17 throw new Error('Credencial protegida do KillFeed nao encontrada.');
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             24 throw new Error('Credencial do KillFeed esta vazia.');
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             27 const killfeedPool = new Pool({
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             28 host: process.env.KILLFEED_DB_HOST || '127.0.0.1',
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             29 port: Number(process.env.KILLFEED_DB_PORT || 5432),
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             30 database: process.env.KILLFEED_DB_NAME || 'dayz_killfeed',
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             31 user: process.env.KILLFEED_DB_USER || 'raven_killfeed_reader',
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             36 application_name: 'raven-killfeed-readonly-api',
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             41 killfeedPool.on('error', error => {
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             42 logger.error({ code: error.code }, 'Erro inesperado no pool read-only do KillFeed');
C:\RavenRP\ControlCenter\API\src\killfeed-db.js                                             45 module.exports = { killfeedPool };
C:\RavenRP\ControlCenter\API\src\server.js                                                  22 const killfeedRoutes = require('./routes/killfeed');
C:\RavenRP\ControlCenter\API\src\server.js                                                  80 app.use('/api/killfeed', killfeedRoutes);
C:\RavenRP\ControlCenter\API\src\routes\health.js                                            5 const { killfeedPool } = require('../killfeed-db');
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           37 const [primaryDatabase, killfeedDatabase] = await Promise.all([
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           39 checkDatabase(killfeedPool, req, 'killfeed')
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           43 const killfeedConnected = killfeedDatabase.status === 'connected';
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           47 killfeed: killfeedDatabase.status
C:\RavenRP\ControlCenter\API\src\routes\health.js                                           52 : killfeedConnected



--- Busca: admin\.action ---

--- Busca: server\.status ---

--- Busca: player\.list ---

--- Busca: ingest ---

Path                                              LineNumber Trecho
----                                              ---------- ------
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1031.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[1031],{1031:(e=>{e.exports=JSON.parse(`{"language":"english","Steam_Platform":"Steam","B
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1047.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[1047],{1047:(e=>{e.exports=JSON.parse(`{"language":"thai","Steam_Platform":"Steam","Butt
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1229.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[1229],{1229:(a=>{a.exports=JSON.parse(`{"language":"indonesian","Steam_Platform":"Steam"
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1359.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[1359],{1359:(e=>{e.exports=JSON.parse(`{"language":"german","Steam_Platform":"Steam","Bu
C:\RavenRP\Tools\SteamCMD\siteserverui\js\1864.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[1864],{1864:e=>{e.exports=JSON.parse('{"language":"italian","Steam_Platform":"Steam","Button_A
C:\RavenRP\Tools\SteamCMD\siteserverui\js\200.js           1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[200],{200:a=>{a.exports=JSON.parse('{"language":"indonesian","Steam_Platform":"Steam","Button_
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2269.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2269],{2269:e=>{e.exports=JSON.parse('{"language":"portuguese","Steam_Platform":"Steam","Butto
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2330.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2330],{2330:(e=>{e.exports=JSON.parse(`{"language":"hungarian","Steam_Platform":"Steam",
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2378.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2378],{2378:(n=>{n.exports=JSON.parse(`{"language":"vietnamese","Steam_Platform":"Steam"
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2589.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2589],{2589:(e=>{e.exports=JSON.parse(`{"language":"french","Steam_Platform":"Steam","Bu
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2711.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2711],{2711:(e=>{e.exports=JSON.parse(`{"language":"italian","Steam_Platform":"Steam","B
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2736.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2736],{2736:(e=>{e.exports=JSON.parse(`{"language":"polish","Steam_Platform":"Steam","Bu
C:\RavenRP\Tools\SteamCMD\siteserverui\js\2889.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[2889],{2889:e=>{e.exports=JSON.parse('{"language":"polish","Steam_Platform":"Steam","Button_Ab
C:\RavenRP\Tools\SteamCMD\siteserverui\js\295.js           1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[295],{295:e=>{e.exports=JSON.parse('{"language":"korean","Steam_Platform":"Steam","Button_Abou
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3248.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3248],{3248:(e=>{e.exports=JSON.parse(`{"language":"portuguese","Steam_Platform":"Steam"
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3296.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3296],{3296:(e=>{e.exports=JSON.parse(`{"language":"czech","Steam_Platform":"Steam","But
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3301.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3301],{3301:(e=>{e.exports=JSON.parse(`{"language":"ukrainian","Steam_Platform":"Steam",
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3518.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3518],{3518:e=>{e.exports=JSON.parse('{"Steam_EResult_0":"Geen","Steam_EResult_1":"OK","Steam_
C:\RavenRP\Tools\SteamCMD\siteserverui\js\361.js           1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[361],{361:(e=>{e.exports=JSON.parse(`{"language":"\u0627\u0644\u0639\u0631\u0628\u064A\u
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3789.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3789],{3789:e=>{e.exports=JSON.parse('{"language":"bulgarian","Steam_Platform":"Steam","Button
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3800.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3800],{3800:e=>{e.exports=JSON.parse('{"language":"english","Steam_Platform":"Steam","Button_A
C:\RavenRP\Tools\SteamCMD\siteserverui\js\3907.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[3907],{3907:e=>{e.exports=JSON.parse('{"language":"finnish","Steam_Platform":"Steam","Button_A
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4122.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4122],{4122:(e=>{e.exports=JSON.parse(`{"language":"romanian","Steam_Platform":"Steam","
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4175.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4175],{4175:(e=>{e.exports=JSON.parse(`{"language":"greek","Steam_Platform":"Steam","But
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4230.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4230],{4230:e=>{e.exports=JSON.parse('{"language":"thai","Steam_Platform":"Steam","Button_Abou
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4289.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4289],{4289:e=>{e.exports=JSON.parse('{"language":"danish","Steam_Platform":"Steam","Button_Ab
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4401.js          1 "use strict";(()=>{(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4401],{4401:(e=>{e.exports=JSON.parse(`{"language":"dutch","Steam_Platform":"Steam","But
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4419.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4419],{4419:e=>{e.exports=JSON.parse('{"language":"romanian","Steam_Platform":"Steam","Button_
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4625.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4625],{4625:e=>{e.exports=JSON.parse('{"language":"swedish","Steam_Platform":"Steam","Button_A
C:\RavenRP\Tools\SteamCMD\siteserverui\js\4750.js          1 "use strict";(self.webpackChunksiteserverui=self.webpackChunksiteserverui||[]).push([[4750],{4750:e=>{e.exports=JSON.parse('{"language":"german","Steam_Platform":"Steam","Button_Ab



[6] SERVICOS E PROCESSOS - APENAS CONSULTA


==================================================
AUDITORIA CONCLUIDA
Relatorio: C:\Users\Nasdara\Desktop\Raven_Auditoria_Integracao_VPP.txt
==================================================
**********************
Fim da transcrição do Windows PowerShell
Hora de término: 20261119140809
**********************
