RAVEN CONTROL CENTER - INSPECAO PBO VPP
Data: 2026-11-19 13:53:28

======================================================================
VALIDACAO INICIAL
======================================================================
PBO: C:\RavenRP\DayZServer\@VPPAdminTools\addons\VPPAdminTools.pbo
SHA256 inicial: 431398D78FB3EAEE4C3F0849EAE582263BE2A5FC608F90DB6F035F29AFB60887

======================================================================
CRIACAO DO AMBIENTE ISOLADO
======================================================================
Ambiente: C:\Users\Nasdara\AppData\Local\RavenControlCenter\DayZDevTools\venv

======================================================================
INSTALACAO DA FERRAMENTA
======================================================================
CODIGO DE SAIDA: 0
Using pip 24.0 from C:\Users\Nasdara\AppData\Local\RavenControlCenter\DayZDevTools\venv\Lib\site-packages\pip (python 3.11)
Collecting dayz-dev-tools==1.10.0
  Obtaining dependency information for dayz-dev-tools==1.10.0 from https://files.pythonhosted.org/packages/f1/12/adde737789db473841a1bccca33a0bee6af601c6af5b3020726d6cc7fabd/dayz_dev_tools-1.10.0-cp311-cp311-win_amd64.whl.metadata
  Using cached dayz_dev_tools-1.10.0-cp311-cp311-win_amd64.whl.metadata (2.5 kB)
Collecting pydantic>=2.8.2 (from dayz-dev-tools==1.10.0)
  Obtaining dependency information for pydantic>=2.8.2 from https://files.pythonhosted.org/packages/8a/8c/824a686c4ba815ddb0722f9e66272088bccd4e1ae1d2f7015375e4a4fc7f/pydantic-2.14.4-py3-none-any.whl.metadata
  Downloading pydantic-2.14.4-py3-none-any.whl.metadata (143 kB)
     ------------------------------------ 144.0/144.0 kB 658.9 kB/s eta 0:00:00
Collecting annotated-types>=0.6.0 (from pydantic>=2.8.2->dayz-dev-tools==1.10.0)
  Obtaining dependency information for annotated-types>=0.6.0 from https://files.pythonhosted.org/packages/99/91/8acff4f5e50511b911bbccb72b8628a49c68ce14148cd9f6431094859a90/annotated_types-0.8.0-py3-none-any.whl.metadata
  Downloading annotated_types-0.8.0-py3-none-any.whl.metadata (15 kB)
Collecting pydantic-core==2.50.5 (from pydantic>=2.8.2->dayz-dev-tools==1.10.0)
  Obtaining dependency information for pydantic-core==2.50.5 from https://files.pythonhosted.org/packages/ac/61/5948dca31a355a03bbc4284cfb6f93e9d8add875ebcb38c90b848c28b522/pydantic_core-2.50.5-cp311-cp311-win_amd64.whl.metadata
  Downloading pydantic_core-2.50.5-cp311-cp311-win_amd64.whl.metadata (6.7 kB)
Collecting typing-extensions>=4.16.0 (from pydantic>=2.8.2->dayz-dev-tools==1.10.0)
  Obtaining dependency information for typing-extensions>=4.16.0 from https://files.pythonhosted.org/packages/49/d3/b8441a820a491ddfc024b0b0cf0393375b75ea13866d9c66727e54c2fc80/typing_extensions-4.16.0-py3-none-any.whl.metadata
  Using cached typing_extensions-4.16.0-py3-none-any.whl.metadata (3.3 kB)
Collecting typing-inspection>=0.4.4 (from pydantic>=2.8.2->dayz-dev-tools==1.10.0)
  Obtaining dependency information for typing-inspection>=0.4.4 from https://files.pythonhosted.org/packages/de/0c/ea2544850a7c135e15033a5c7a8e7211136184b7ae63e2239d557c2b3019/typing_inspection-0.4.5-py3-none-any.whl.metadata
  Downloading typing_inspection-0.4.5-py3-none-any.whl.metadata (2.6 kB)
Using cached dayz_dev_tools-1.10.0-cp311-cp311-win_amd64.whl (127 kB)
Downloading pydantic-2.14.4-py3-none-any.whl (494 kB)
   ---------------------------------------- 494.9/494.9 kB 3.1 MB/s eta 0:00:00
Downloading pydantic_core-2.50.5-cp311-cp311-win_amd64.whl (2.3 MB)
   ---------------------------------------- 2.3/2.3 MB 2.4 MB/s eta 0:00:00
Downloading annotated_types-0.8.0-py3-none-any.whl (13 kB)
Using cached typing_extensions-4.16.0-py3-none-any.whl (45 kB)
Downloading typing_inspection-0.4.5-py3-none-any.whl (14 kB)
Installing collected packages: typing-extensions, annotated-types, typing-inspection, pydantic-core, pydantic, dayz-dev-tools
Successfully installed annotated-types-0.8.0 dayz-dev-tools-1.10.0 pydantic-2.14.4 pydantic-core-2.50.5 typing-extensions-4.16.0 typing-inspection-0.4.5

======================================================================
VALIDACAO DO UNPBO
======================================================================
UNPBO ENCONTRADO: C:\Users\Nasdara\AppData\Local\RavenControlCenter\DayZDevTools\venv\Scripts\unpbo.exe
usage: unpbo [-h] [-l] [-b] [-d] [-m MATCH] [-v] [-D] [-V] pbofile [files ...]

View or extract a PBO archive

positional arguments:
  pbofile               The PBO archive to read
  files                 Files to extract from the PBO archive

options:
  -h, --help            show this help message and exit
  -l, --list            List contents of the PBO archive
  -b, --no-convert      Do not convert config.bin files to config.cpp files
  -d, --deobfuscate     Attempt to deobfuscate extracted files
  -m MATCH, --match MATCH
                        Extract files matching glob pattern
  -v, --verbose         Enable verbose output
  -D, --debug           Enable debug logs
  -V, --version         show program's version number and exit

See also: https://community.bistudio.com/wiki/PBO_File_Format

======================================================================
LISTAGEM DO PBO ORIGINAL
======================================================================
CODIGO DE SAIDA DA LISTAGEM: 0
 Original     Date    Time   Name
---------  ---------- -----  ----
      315  2022-01-26 01:19  VPPAdminTools\3_Game\CommunityFramework\RPC\DayZGame.c
     7631  2022-09-30 13:11  VPPAdminTools\3_Game\CommunityFramework\RPC\RPCManager.c
     1931  2022-11-12 05:41  VPPAdminTools\3_Game\VPPAdminTools\CfgExport.c
    10841  2026-10-27 12:00  VPPAdminTools\3_Game\VPPAdminTools\constants.c
     1073  2021-12-30 07:28  VPPAdminTools\3_Game\VPPAdminTools\EventHandler\VPPEventHandler.c
     1595  2026-09-29 03:02  VPPAdminTools\3_Game\VPPAdminTools\Freecam\HumanCommandScript_VPPCam.c
     9240  2025-08-12 07:36  VPPAdminTools\3_Game\VPPAdminTools\PlayerList\PlayerList.c
      646  2021-12-30 07:28  VPPAdminTools\3_Game\VPPAdminTools\PlayerList\VPPUser.c
      728  2022-07-05 08:58  VPPAdminTools\3_Game\VPPAdminTools\Steam\SteamAPIResponse.c
     1606  2022-09-30 07:26  VPPAdminTools\3_Game\VPPAdminTools\utils\DebugModeDialog.c
     3555  2023-01-26 05:40  VPPAdminTools\3_Game\VPPAdminTools\utils\FileProcessingFuncs.c
      387  2021-12-30 07:28  VPPAdminTools\3_Game\VPPAdminTools\utils\PlayerStatsData.c
    13037  2025-11-16 06:33  VPPAdminTools\3_Game\VPPAdminTools\utils\SHA256.c
     8257  2026-09-22 09:40  VPPAdminTools\3_Game\VPPAdminTools\utils\VPPATInventorySlots.c
      172  2021-12-30 07:28  VPPAdminTools\3_Game\VPPAdminTools\utils\VPPPlayerData.c
    47713  2026-09-23 10:45  VPPAdminTools\3_Game\VPPAdminTools\utils\xmlparser\VPPXmlDocument.c
     2478  2026-09-23 03:16  VPPAdminTools\3_Game\VPPAdminTools\utils\xmlparser\VPPXmlLineScanner.c
    10312  2026-09-23 10:44  VPPAdminTools\3_Game\VPPAdminTools\utils\xmlparser\VPPXmlStream.c
    12290  2026-09-23 10:44  VPPAdminTools\3_Game\VPPAdminTools\utils\xmlparser\VPPXmlText.c
    17936  2026-09-29 04:02  VPPAdminTools\3_Game\VPPAdminTools\VanillaPlusPlus.c
     2229  2026-09-29 04:02  VPPAdminTools\3_Game\VPPAdminTools\VPPATProfileOptions.c
      249  2026-10-29 07:43  VPPAdminTools\3_Game\VPPAdminTools\VPPATRPCs.c
     5014  2026-07-09 07:50  VPPAdminTools\3_Game\VPPAdminTools\VPPSpectateConstants.c
    10969  2026-09-29 06:19  VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPJsonCheck.c
     6626  2026-09-29 06:31  VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c
    13292  2026-09-29 07:58  VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookPresets.c
    19627  2026-10-15 08:23  VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookTemplate.c
    15290  2026-09-28 09:45  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXEConstants.c
     4938  2026-09-28 10:07  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXECreateRules.c
    11042  2026-09-23 03:15  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXEData.c
    50499  2026-09-28 04:17  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXEEvents.c
    14432  2026-09-23 10:44  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXEJobQueue.c
     8691  2026-09-24 04:07  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXEMessages.c
    16394  2026-09-28 11:51  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXESpawnables.c
    11917  2026-09-23 03:08  VPPAdminTools\3_Game\VPPAdminTools\XMLEditor\VPPXETypeMerge.c
      336  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Classes\Actions\ActionActivateTrap.c
     6506  2022-04-30 05:33  VPPAdminTools\4_World\VPPAdminTools\Classes\Actions\ActionAdminBaseBuilder.c
      179  2022-04-28 09:29  VPPAdminTools\4_World\VPPAdminTools\Classes\Actions\ActionConstructor.c
      302  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Classes\Actions\ActionPin.c
      320  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Classes\Actions\ActionUnpin.c
     1419  2022-04-28 11:28  VPPAdminTools\4_World\VPPAdminTools\Classes\BaseBuilding\Construction.c
     1260  2025-07-28 06:25  VPPAdminTools\4_World\VPPAdminTools\Classes\BaseBuilding\ConstructionActionData.c
      376  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Classes\BleedingSourcesManagerBase.c
      132  2022-03-29 06:00  VPPAdminTools\4_World\VPPAdminTools\Classes\MissionBaseWorld.c
      405  2025-08-13 08:52  VPPAdminTools\4_World\VPPAdminTools\Classes\Modifiers\AreaExposureMdfr.c
     1121  2022-10-17 00:07  VPPAdminTools\4_World\VPPAdminTools\Classes\Static.c
      692  2022-09-06 06:24  VPPAdminTools\4_World\VPPAdminTools\Classes\TransferValues.c
      991  2022-11-03 03:24  VPPAdminTools\4_World\VPPAdminTools\Classes\WorldData.c
     1230  2022-08-26 10:18  VPPAdminTools\4_World\VPPAdminTools\Entities\Building\VPPMarkerObj.c
     6400  2026-09-22 07:08  VPPAdminTools\4_World\VPPAdminTools\Entities\DayZPlayer\DayZPlayerCameraFree.c
     1966  2026-09-29 03:41  VPPAdminTools\4_World\VPPAdminTools\Entities\DayZPlayer\DayZPlayerCameras.c
    47181  2026-07-09 07:54  VPPAdminTools\4_World\VPPAdminTools\Entities\DayZPlayer\DayZPlayerCameraSpectate.c
     1735  2026-09-28 03:54  VPPAdminTools\4_World\VPPAdminTools\Entities\DayZPlayer\DayZPlayerImp.c
      696  2026-07-09 07:57  VPPAdminTools\4_World\VPPAdminTools\Entities\DayZPlayer\DayZPlayerImplement.c
      566  2026-07-09 07:57  VPPAdminTools\4_World\VPPAdminTools\Entities\DrowningMdfr.c
     5190  2026-09-22 09:38  VPPAdminTools\4_World\VPPAdminTools\Entities\Firearms\Weapon_Base.c
     2349  2026-09-22 09:37  VPPAdminTools\4_World\VPPAdminTools\Entities\Firearms\WeaponFSM.c
     1221  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Entities\ItemBase\Grenade_Base.c
      724  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Entities\ItemBase\TrapBase\LandMineTrap.c
      811  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Entities\ItemBase\TrapBase\TrapBase.c
    13742  2026-07-09 07:56  VPPAdminTools\4_World\VPPAdminTools\Entities\PlayerBase.c
     4177  2022-08-12 08:10  VPPAdminTools\4_World\VPPAdminTools\Entities\SurvivorBase.c
      308  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Entities\Triggers\ContaminatedTrigger.c
     2431  2026-09-29 04:18  VPPAdminTools\4_World\VPPAdminTools\Entities\Vehicles\VPPVehicleUtils.c
     3285  2026-09-16 07:38  VPPAdminTools\4_World\VPPAdminTools\Misc\BasebuildingHelperFuncs.c
     4788  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Misc\VPPCameras\VPPFreeCam.c
     6742  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Misc\VPPCameras\VPPPlacementCam.c
     1357  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\ConfigurablePlugin.c
     8848  2026-09-29 04:18  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\AdminTools\AdminTools.c
    18622  2026-10-27 09:55  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\BuildingSetManager\BuildingSetManager.c
     6330  2026-10-29 00:54  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\BuildingSetManager\Classes\BuildingSet.c
     5702  2026-10-29 07:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\BuildingSetManager\Classes\SpawnedBuilding.c
    10930  2026-10-27 09:55  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\BuildingSetManager\Classes\VPPBuildingSetJournal.c
    12189  2026-10-29 00:55  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\BuildingSetManager\Classes\VPPBuildingSetStore.c
     7105  2025-07-28 06:25  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\ChatCommandManager.c
      906  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatCommand.c
      773  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Administration\RemoveBanModule.c
     1393  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Misc\NamalskEvents.c
      995  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Spawning\SpawnInHandsModule.c
      814  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Spawning\SpawnInsideInventoryModule.c
     1599  2025-07-28 06:25  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Spawning\SpawnOnGroundModule.c
      666  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Teleporting\TeleportToPointModule.c
      807  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\ArgumentCommands\Teleporting\TeleportToTownModule.c
     3500  2026-09-29 04:18  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\NoArgumentCommands\Misc\RefuelVehicleModule.c
     1852  2022-02-23 23:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\NoArgumentCommands\Spawning\SpawnAmmoModule.c
     1210  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\NoArgumentCommands\Spawning\SpawnCarModule.c
     1142  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Administration\BanPlayerModule.c
     1047  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Administration\StripPlayerModule.c
     1034  2025-08-13 08:15  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Health\HealPlayerModule.c
     1036  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Health\KillPlayerModule.c
     1107  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Teleporting\BringPlayerModule.c
     1072  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Teleporting\GotoPlayerModule.c
     1045  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ChatCommandManager\Classes\ChatModules\PlayerTargetedCommands\Teleporting\ReturnPlayerModule.c
    21377  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextAttachmentActions.c
     6594  2026-09-22 09:41  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextAttachmentOps.c
     8770  2026-10-29 07:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextBodyActions.c
     3934  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextCommonActions.c
     2856  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextCreatureActions.c
     2287  2026-10-27 08:26  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextEntityActions.c
     7043  2026-09-22 12:05  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextItemActions.c
     4698  2026-09-29 04:18  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Entity\VPPContextVehicleActions.c
     4025  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Player\VPPContextPlayerActions.c
     5615  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Player\VPPContextPlayerBasicActions.c
     3049  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Player\VPPContextPlayerModerationActions.c
     5985  2026-09-22 10:45  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Player\VPPContextPlayerStatusActions.c
     3803  2026-10-27 05:12  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Player\VPPContextPlayerTeleportActions.c
     8007  2026-09-22 12:04  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Weapon\VPPContextWeaponActions.c
    17817  2026-09-22 12:04  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Actions\Weapon\VPPContextWeaponOps.c
     7640  2026-09-22 12:02  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\Examples\VPPContextExample.c
     5264  2026-09-22 06:32  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextAction.c
    32465  2026-09-22 12:05  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextActionManager.c
     8178  2026-09-22 09:41  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextItems.c
     2699  2026-09-22 06:30  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextRequest.c
    13588  2026-10-29 07:43  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextTarget.c
     7547  2026-10-27 08:26  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextTypes.c
     4418  2026-10-27 08:26  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ContextMenu\VPPContextUtils.c
     5026  2025-08-12 10:49  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\EspTools\VPPESPTools.c
      583  2023-11-07 07:04  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ItemManager\Classes\ItemSpawnParams.c
     1808  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ItemManager\Classes\PresetItemData.c
    16134  2025-08-13 08:43  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ItemManager\ItemManager.c
     2936  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\Keybinds\VPPKeybindsManager.c
     5854  2025-08-12 13:20  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\LogManager\LogManager.c
     2521  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\PermissionManager\Classes\UserGroup.c
      694  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\PermissionManager\PermissionLoader.c
    41281  2026-09-29 05:36  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\PermissionManager\PermissionManager.c
    34440  2026-10-27 05:12  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\PlayerManager\PlayerManager.c
    12391  2026-09-29 05:35  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\PluginAdminLog.c
     9645  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ServerManager\Classes\BansManager.c
     4550  2026-06-24 07:26  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\ServerManager\ServerManager.c
     1410  2026-07-07 11:19  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\SpectateManager\Classes\SpectateSession.c
    22210  2026-09-28 03:54  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\SpectateManager\SpectateManager.c
      129  2022-10-31 08:06  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\SteamAPIManager\Classes\VPPAT_IPIFY.c
      522  2022-07-05 08:58  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\SteamAPIManager\Classes\VPPATSteamAPICB.c
     4683  2025-07-30 07:29  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\SteamAPIManager\SteamAPIManager.c
       60  2026-10-27 05:12  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\TeleportManager\Classes\VPPAT_TeleportType.c
      469  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\TeleportManager\Classes\VPPTeleportLocation.c
    17869  2025-08-12 05:02  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\TeleportManager\TeleportManager.c
      799  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WeatherManager\Classes\TimeSetting.c
     1089  2021-12-30 07:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WeatherManager\Classes\WeatherSetting.c
     6153  2022-09-30 11:47  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WeatherManager\TimeManager.c
     7067  2022-11-03 03:08  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WeatherManager\WeatherManager.c
     2264  2026-09-29 05:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\AdminActivityMessage.c
     3009  2026-09-29 05:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\HitDamageMessage.c
     2283  2026-09-29 05:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\JoinLeaveMessage.c
     2988  2026-09-29 05:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\KillDeathMessage.c
     3616  2026-09-29 05:28  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c
    14998  2026-09-29 07:58  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c
     2036  2026-09-29 06:31  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookWire.c
    11869  2026-09-29 08:02  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\WebHook.c
     3594  2026-09-29 06:02  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\WebHookMessageBase.c
    42613  2026-09-29 07:58  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c
    39390  2026-09-23 11:36  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Backup\VPPXEBackupJobs.c
    40494  2026-09-24 01:52  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Backup\VPPXEBackupManager.c
    20256  2026-09-24 04:50  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXECreateFileJob.c
    69105  2026-09-28 02:34  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXEEventsService.c
    24226  2026-09-24 01:52  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXEFileRegistry.c
    20520  2026-09-24 04:08  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXEMessagesService.c
    11099  2026-09-24 00:33  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXENet.c
    16422  2026-09-24 04:50  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXESafeWrite.c
     2355  2026-09-23 10:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXESettings.c
    19093  2026-09-28 10:01  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Core\VPPXESpawnablesService.c
    23203  2026-10-27 05:51  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Dist\VPPXEAreaFlags.c
     8487  2026-09-23 10:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Dist\VPPXEClusterIndex.c
    37265  2026-10-27 05:51  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Dist\VPPXEDistQuery.c
    29456  2026-09-23 10:46  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Dist\VPPXEDistService.c
    56855  2026-09-23 10:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Dist\VPPXESpawnIndex.c
    11671  2026-09-23 11:36  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Live\VPPXELiveScan.c
    46278  2026-09-23 07:59  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Types\VPPXESaveJob.c
    15567  2026-09-23 10:44  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Types\VPPXETypesParseJob.c
    49516  2026-09-28 09:46  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Types\VPPXETypesService.c
    43271  2026-09-23 03:47  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\Types\VPPXETypesWriter.c
    71963  2026-09-29 08:15  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\XMLEditor\XMLEditor.c
     2373  2026-09-22 06:34  VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginManager.c
      523  2021-12-30 07:28  VPPAdminTools\5_Mission\VPPAdminTools\Freecamera.c
    23208  2026-10-29 07:50  VPPAdminTools\5_Mission\VPPAdminTools\GUI\Changelog\MenuChangelog.c
    11852  2026-10-29 07:54  VPPAdminTools\5_Mission\VPPAdminTools\GUI\Changelog\VPPChangelogContent.c
     7669  2026-09-22 12:08  VPPAdminTools\5_Mission\VPPAdminTools\GUI\Changelog\VPPChangelogData.c
      527  2022-08-10 22:26  VPPAdminTools\5_Mission\VPPAdminTools\GUI\ChatInputMenu.c
     1244  2022-11-01 10:38  VPPAdminTools\5_Mission\VPPAdminTools\GUI\Example.c
      609  2022-03-29 09:27  VPPAdminTools\5_Mission\VPPAdminTools\GUI\InGameMenu.c
     9624  2026-06-29 07:22  VPPAdminTools\5_Mission\VPPAdminTools\GUI\Options\OptionsMenuGame.c
     3984  2026-06-29 07:08  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\AdminHudSubMenu.c
      928  2022-03-29 09:40  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuBansManager\Classes\BannedPlayerEntry.c
    11013  2026-06-25 02:50  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuBansManager\MenuBansManager.c
     8007  2026-06-24 09:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuCommandsConsole\MenuCommandsConsole.c
      336  2022-11-01 20:21  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuEspTools\Classes\EspFilterProperties.c
     2912  2026-06-23 11:05  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuEspTools\Classes\VPPEspCatagoryHeader.c
     4262  2025-08-12 11:03  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuEspTools\Classes\VPPESPItemEntry.c
    21426  2026-06-23 11:14  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuEspTools\Classes\VPPESPTracker.c
     3436  2026-06-23 09:26  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuEspTools\Classes\VPPFilterEntry.c
    26037  2026-06-30 10:14  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuEspTools\EspToolsMenu.c
     1678  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuItemManager\Classes\ItemManagerClientPrefs.c
     1396  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuItemManager\Classes\PopUpCreatePreset.c
     3077  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuItemManager\Classes\PresetItemEntry.c
     2246  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuItemManager\Classes\VPPPresetEntry.c
    33770  2026-09-29 05:39  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuItemManager\MenuItemManager.c
     1906  2026-10-27 10:58  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuObjectManager\Classes\BuildingAttributesEditor.c
     5502  2026-09-28 02:49  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuObjectManager\Classes\BuildingEntry.c
     2419  2026-09-28 04:15  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuObjectManager\Classes\BuildingSetEditor.c
     3090  2026-09-28 04:15  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuObjectManager\Classes\BuildingSetEntry.c
    13754  2026-10-29 00:54  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuObjectManager\Classes\BuildingTracker.c
    42029  2026-10-27 09:46  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuObjectManager\MenuObjectManager.c
      743  2022-03-29 09:33  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPermissionsEditor\Classes\PermissionBox.c
     1720  2025-08-11 10:02  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPermissionsEditor\Classes\UserBoxTemplate.c
     5342  2026-09-28 07:21  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPermissionsEditor\Classes\UserGroupTemplate.c
    11745  2026-06-25 07:18  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPermissionsEditor\MenuPermissionsEditor.c
     2028  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPlayerManager\Classes\VPPModifierEntry.c
     2669  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPlayerManager\Classes\VPPPlayerEntry.c
     5171  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPlayerManager\Classes\VPPPlayerStats.c
      166  2021-12-30 07:28  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPlayerManager\Classes\VPPPlayerTemplate.c
    38487  2026-10-27 05:12  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuPlayerManager\MenuPlayerManager.c
    14779  2026-06-24 08:59  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuServerManager\MenuServerManager.c
    15974  2026-07-09 06:33  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuSpectateTools\MenuSpectateTools.c
     2155  2026-07-07 09:12  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuSpectateTools\SpectatePlayerEntry.c
    20787  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuTeleportManager\MenuTeleportManager.c
     2859  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuTeleportManager\PopUpNewPositionEditor.c
     3707  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuTeleportManager\TeleportEntry.c
     2196  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuTeleportManager\TeleportManagerClientPrefs.c
    18295  2026-06-24 10:10  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWeatherManager\MenuWeatherManager.c
    25822  2026-09-29 08:02  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWebHooks\MenuWebHooks.c
    11662  2026-09-29 07:53  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWebHooks\VPPWebhookEventsView.c
    13104  2026-09-29 07:53  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWebHooks\VPPWebhookSettingsView.c
    21264  2026-09-29 07:12  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWebHooks\VPPWebhookTemplateView.c
     1639  2026-09-29 06:36  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWebHooks\VPPWebhookToggle.c
     7066  2026-09-29 06:36  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuWebHooks\VPPWebhookUi.c
    65119  2026-10-27 05:49  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\MenuXMLEditor.c
    39167  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEBackupsTab.c
    63688  2026-09-24 05:18  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEClientModel.c
    25028  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXECreateTab.c
   150526  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEEventsTab.c
    26150  2026-10-27 05:36  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEFilesTab.c
    77028  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEGroupsView.c
    28548  2026-09-28 07:58  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEMapRenderer.c
    74958  2026-10-27 08:07  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEMapTab.c
    52211  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXEMessagesTab.c
   183856  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXESpawnablesTab.c
    86092  2026-10-27 05:36  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\VPPXETypesTab.c
     6727  2026-10-27 05:13  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\Widgets\VPPXEChipGroup.c
     4512  2026-09-23 08:59  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\Widgets\VPPXENumericEditHandler.c
     3560  2026-10-27 05:16  VPPAdminTools\5_Mission\VPPAdminTools\GUI\SubMenus\MenuXMLEditor\Widgets\VPPXEScale.c
     5364  2021-12-30 07:28  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\BanDurationInput.c
     2127  2022-11-30 06:29  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ConfirmationEventHandler.c
      846  2026-09-22 06:27  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ContextMenu\VPPContextMenuBridge.c
    37003  2026-09-22 12:05  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ContextMenu\VPPContextMenuController.c
     6803  2026-09-22 09:34  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ContextMenu\VPPContextMenuInput.c
     2893  2026-10-29 07:52  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ContextMenu\VPPContextMenuStyle.c
    23817  2026-10-29 07:56  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ContextMenu\VPPContextMenuView.c
     1065  2026-06-30 10:14  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\CustomGridSpacer.c
     3826  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\DropDownMenu.c
     2654  2026-09-23 07:34  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\EditBoxEventHandler.c
     2070  2025-07-28 06:25  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\InfoBoxInstance.c
      860  2021-12-30 07:28  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\MapWidgetUI.c
      997  2025-07-28 06:25  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\MouseEvents\VPPHoldLeftClickEvent.c
     2108  2025-07-28 06:25  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\MouseEvents\VPPMouseEventBase.c
     1819  2025-07-31 11:17  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\SliderEventHandler.c
     2521  2022-03-29 09:30  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\TextEditor.c
     1995  2025-07-28 06:25  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\ToolTipHandler.c
     1962  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\VPPCollapsibleSection.c
     4121  2026-09-28 02:09  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\VPPDialogBox.c
     2284  2026-06-23 07:41  VPPAdminTools\5_Mission\VPPAdminTools\GUI\UIHelpers\VPPSliderRowHandler.c
    12514  2026-09-28 03:54  VPPAdminTools\5_Mission\VPPAdminTools\GUI\VPPAdminHud.c
     2416  2021-12-30 07:28  VPPAdminTools\5_Mission\VPPAdminTools\GUI\VPPButton.c
     3620  2026-07-09 07:59  VPPAdminTools\5_Mission\VPPAdminTools\GUI\VPPSpectateOverlay.c
    10088  2026-09-29 04:02  VPPAdminTools\5_Mission\VPPAdminTools\GUI\VPPStatsHud.c
    13995  2026-09-28 03:54  VPPAdminTools\5_Mission\VPPAdminTools\GUI\VPPUIManager.c
      464  2023-12-28 06:18  VPPAdminTools\5_Mission\VPPAdminTools\missionBase.c
     3994  2025-07-28 09:47  VPPAdminTools\5_Mission\VPPAdminTools\MissionDebug.c
    41926  2026-10-29 07:38  VPPAdminTools\5_Mission\VPPAdminTools\missionGameplay.c
    22803  2026-10-29 07:38  VPPAdminTools\5_Mission\VPPAdminTools\missionServer.c
    14663  2026-07-08 09:11  VPPAdminTools\5_Mission\VPPAdminTools\SpectateClientHandler.c
      150  2026-10-29 08:01  VPPAdminTools\config.bin
     8013  2021-12-30 07:28  VPPAdminTools\data\lootableBuildings.vpp
    11014  2026-09-22 09:33  VPPAdminTools\data\modded_Inputs.xml
    54502  2021-12-30 07:28  VPPAdminTools\data\vpp_logo_m.paa
    22016  2021-12-30 07:28  VPPAdminTools\data\vpp_logo_s.paa
     5625  2021-12-30 07:28  VPPAdminTools\data\vpp_logo_ss.paa
       52  2023-11-06 03:33  VPPAdminTools\Definitions\VPPAdminTools\Definitions.c
      984  2022-09-26 11:38  VPPAdminTools\Extra\init.c
     1396  2021-12-30 07:28  VPPAdminTools\Extra\ObjectSorting.c
      200  2025-08-14 02:50  VPPAdminTools\GUI\Fonts\InterDisplay-Bold.xml
   699260  2025-08-11 11:15  VPPAdminTools\GUI\Fonts\InterDisplay-Bold12.edds
      407  2025-08-11 11:15  VPPAdminTools\GUI\Fonts\InterDisplay-Bold12.edds.meta
     5344  2025-08-11 11:07  VPPAdminTools\GUI\Fonts\InterDisplay-Bold12.fnt
   699260  2025-08-11 11:15  VPPAdminTools\GUI\Fonts\InterDisplay-Bold14.edds
      407  2025-08-11 11:15  VPPAdminTools\GUI\Fonts\InterDisplay-Bold14.edds.meta
     5344  2025-08-11 11:07  VPPAdminTools\GUI\Fonts\InterDisplay-Bold14.fnt
   699260  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold16.edds
      408  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold16.edds.meta
     5344  2025-08-11 11:07  VPPAdminTools\GUI\Fonts\InterDisplay-Bold16.fnt
  1398308  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold22.edds
      408  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold22.edds.meta
     5344  2025-08-11 11:07  VPPAdminTools\GUI\Fonts\InterDisplay-Bold22.fnt
  2796420  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold28.edds
      407  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold28.edds.meta
     5344  2025-08-11 11:07  VPPAdminTools\GUI\Fonts\InterDisplay-Bold28.fnt
  5592620  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold48.edds
      407  2025-08-11 11:16  VPPAdminTools\GUI\Fonts\InterDisplay-Bold48.edds.meta
     5344  2025-08-11 11:07  VPPAdminTools\GUI\Fonts\InterDisplay-Bold48.fnt
      200  2025-08-14 02:51  VPPAdminTools\GUI\Fonts\InterDisplay-Light.xml
   349724  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light12.edds
      410  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light12.edds.meta
     5345  2025-08-11 11:08  VPPAdminTools\GUI\Fonts\InterDisplay-Light12.fnt
   699260  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light14.edds
      410  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light14.edds.meta
     5345  2025-08-11 11:08  VPPAdminTools\GUI\Fonts\InterDisplay-Light14.fnt
   699260  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light16.edds
      410  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light16.edds.meta
     5345  2025-08-11 11:08  VPPAdminTools\GUI\Fonts\InterDisplay-Light16.fnt
  1398308  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light22.edds
      409  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light22.edds.meta
     5345  2025-08-11 11:08  VPPAdminTools\GUI\Fonts\InterDisplay-Light22.fnt
  1398308  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light28.edds
      409  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light28.edds.meta
     5345  2025-08-11 11:08  VPPAdminTools\GUI\Fonts\InterDisplay-Light28.fnt
  5592620  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light48.edds
      409  2025-08-11 11:17  VPPAdminTools\GUI\Fonts\InterDisplay-Light48.edds.meta
     5345  2025-08-11 11:08  VPPAdminTools\GUI\Fonts\InterDisplay-Light48.fnt
      200  2025-08-14 02:51  VPPAdminTools\GUI\Fonts\InterDisplay-Medium.xml
   349724  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium12.edds
      412  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium12.edds.meta
     5346  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Medium12.fnt
   699260  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium14.edds
      412  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium14.edds.meta
     5346  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Medium14.fnt
   699260  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium16.edds
      412  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium16.edds.meta
     5346  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Medium16.fnt
  1398308  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium22.edds
      412  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium22.edds.meta
     5346  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Medium22.fnt
  2796420  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium28.edds
      412  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium28.edds.meta
     5346  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Medium28.fnt
  5592620  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium48.edds
      412  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Medium48.edds.meta
     5346  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Medium48.fnt
      200  2025-08-14 02:51  VPPAdminTools\GUI\Fonts\InterDisplay-Regular.xml
   349724  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular12.edds
      414  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular12.edds.meta
     5347  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Regular12.fnt
   699260  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular14.edds
      413  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular14.edds.meta
     5347  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Regular14.fnt
   699260  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular16.edds
      413  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular16.edds.meta
     5347  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Regular16.fnt
  1398308  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular22.edds
      413  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular22.edds.meta
     5347  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Regular22.fnt
  1398308  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular28.edds
      413  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular28.edds.meta
     5347  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Regular28.fnt
  5592620  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular48.edds
      413  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-Regular48.edds.meta
     5347  2025-08-11 11:09  VPPAdminTools\GUI\Fonts\InterDisplay-Regular48.fnt
      200  2025-08-14 02:51  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold.xml
   699260  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold12.edds
      415  2025-08-11 11:18  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold12.edds.meta
     5348  2025-08-11 11:10  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold12.fnt
   699260  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold14.edds
      416  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold14.edds.meta
     5348  2025-08-11 11:10  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold14.fnt
   699260  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold16.edds
      416  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold16.edds.meta
     5348  2025-08-11 11:10  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold16.fnt
  1398308  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold22.edds
      416  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold22.edds.meta
     5348  2025-08-11 11:10  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold22.fnt
  2796420  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold28.edds
      416  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold28.edds.meta
     5348  2025-08-11 11:10  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold28.fnt
  5592620  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold48.edds
      416  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold48.edds.meta
     5348  2025-08-11 11:10  VPPAdminTools\GUI\Fonts\InterDisplay-SemiBold48.fnt
      200  2025-08-14 02:51  VPPAdminTools\GUI\Fonts\InterDisplay-Thin.xml
   349724  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin12.edds
      408  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin12.edds.meta
     5344  2025-08-11 11:11  VPPAdminTools\GUI\Fonts\InterDisplay-Thin12.fnt
   699260  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin14.edds
      407  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin14.edds.meta
     5344  2025-08-11 11:11  VPPAdminTools\GUI\Fonts\InterDisplay-Thin14.fnt
   699260  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin16.edds
      407  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin16.edds.meta
     5344  2025-08-11 11:11  VPPAdminTools\GUI\Fonts\InterDisplay-Thin16.fnt
  1398308  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin22.edds
      407  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin22.edds.meta
     5344  2025-08-11 11:11  VPPAdminTools\GUI\Fonts\InterDisplay-Thin22.fnt
  1398308  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin28.edds
      407  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin28.edds.meta
     5344  2025-08-11 11:11  VPPAdminTools\GUI\Fonts\InterDisplay-Thin28.fnt
  5592620  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin48.edds
      407  2025-08-11 11:19  VPPAdminTools\GUI\Fonts\InterDisplay-Thin48.edds.meta
     5344  2025-08-11 11:11  VPPAdminTools\GUI\Fonts\InterDisplay-Thin48.fnt
     1289  2026-07-07 10:59  VPPAdminTools\GUI\Layouts\AdminToolBar\VPPAdminHud.layout
     1324  2026-06-25 13:11  VPPAdminTools\GUI\Layouts\AdminToolBar\VPPButton.layout
    12760  2026-06-25 05:52  VPPAdminTools\GUI\Layouts\BansManagerUI\BanDurationInputPopUp.layout
    20109  2026-06-25 05:53  VPPAdminTools\GUI\Layouts\BansManagerUI\MenuBansManager.layout
      289  2026-10-27 12:10  VPPAdminTools\GUI\Layouts\ChangelogUI\ChangelogBuddy.layout
     1415  2026-09-23 00:31  VPPAdminTools\GUI\Layouts\ChangelogUI\ChangelogEntryRow.layout
      154  2026-09-23 00:31  VPPAdminTools\GUI\Layouts\ChangelogUI\ChangelogGapRow.layout
     1501  2026-09-23 00:31  VPPAdminTools\GUI\Layouts\ChangelogUI\ChangelogLinkRow.layout
     2087  2026-09-23 00:31  VPPAdminTools\GUI\Layouts\ChangelogUI\ChangelogSectionRow.layout
     5792  2026-10-29 07:49  VPPAdminTools\GUI\Layouts\ChangelogUI\MenuChangelog.layout
     7971  2026-06-24 09:32  VPPAdminTools\GUI\Layouts\CommandsConsoleUI\CommandsConsoleUI.layout
      990  2026-06-24 09:12  VPPAdminTools\GUI\Layouts\CommandsConsoleUI\TextElement.layout
     2082  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\CustomSubMenu.layout
     1950  2026-06-23 10:24  VPPAdminTools\GUI\Layouts\EspToolsUI\CatagoryContainer.layout
     3349  2026-06-23 10:03  VPPAdminTools\GUI\Layouts\EspToolsUI\EspItemEntry.layout
    31292  2026-06-23 10:12  VPPAdminTools\GUI\Layouts\EspToolsUI\EspToolsMenu.layout
     1968  2026-06-30 10:09  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTracker.layout
     5636  2026-06-24 02:28  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTrackerActions.layout
     1537  2026-06-24 02:28  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTrackerBaseBuilding.layout
      295  2022-03-25 11:08  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTrackerDetailed.layout
     4111  2026-06-24 02:28  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTrackerInfos.layout
     2004  2026-06-23 10:29  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTrackerPanelHeader.layout
     1671  2026-06-23 10:46  VPPAdminTools\GUI\Layouts\EspToolsUI\EspTrackerPlayerHealth.layout
     2066  2026-06-23 10:04  VPPAdminTools\GUI\Layouts\EspToolsUI\FilterEntry.layout
      684  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\InGameMenuButton.layout
     1999  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\ItemManagerUI\EntryPresetItem.layout
    37027  2026-06-24 02:32  VPPAdminTools\GUI\Layouts\ItemManagerUI\MenuItemManager.layout
     3898  2026-06-24 02:28  VPPAdminTools\GUI\Layouts\ItemManagerUI\PopUpCreatePreset.layout
     2335  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\ItemManagerUI\VPPPresetEntry.layout
     3530  2026-06-25 12:46  VPPAdminTools\GUI\Layouts\ObjectManagerUI\BuildingEntry.layout
     2510  2026-06-25 12:43  VPPAdminTools\GUI\Layouts\ObjectManagerUI\BuildingSetEntry.layout
     6805  2026-06-25 10:29  VPPAdminTools\GUI\Layouts\ObjectManagerUI\BuildingTracker.layout
     5964  2026-09-28 04:15  VPPAdminTools\GUI\Layouts\ObjectManagerUI\EditDialog.layout
     5115  2026-10-27 09:39  VPPAdminTools\GUI\Layouts\ObjectManagerUI\EditDialogBuilding.layout
    22914  2026-10-27 09:39  VPPAdminTools\GUI\Layouts\ObjectManagerUI\MenuObjectManager.layout
    13402  2026-06-25 07:26  VPPAdminTools\GUI\Layouts\PermissionManagerUI\MenuPermissionsEditor.layout
     4108  2026-06-25 07:34  VPPAdminTools\GUI\Layouts\PermissionManagerUI\SettingsPopUp.layout
      460  2026-06-25 07:07  VPPAdminTools\GUI\Layouts\PermissionManagerUI\VPPPermissionBox.layout
     1668  2026-06-25 06:57  VPPAdminTools\GUI\Layouts\PermissionManagerUI\VPPUserBox.layout
     5506  2026-06-25 07:25  VPPAdminTools\GUI\Layouts\PermissionManagerUI\VPPUserGroupBox.layout
      350  2023-11-06 02:24  VPPAdminTools\GUI\Layouts\PlayerESPCanvas.layout
    78064  2026-06-24 09:47  VPPAdminTools\GUI\Layouts\PlayerManagerUI\MenuPlayerManager.layout
     1424  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\PlayerManagerUI\VPPModifierEntry.layout
    24810  2026-06-24 09:38  VPPAdminTools\GUI\Layouts\PlayerManagerUI\VPPPlayerInfoBox.layout
      894  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\PlayerManagerUI\VPPPlayerList.layout
    27467  2026-06-24 09:02  VPPAdminTools\GUI\Layouts\ServerManagerUI\MenuServerManager.layout
    11366  2026-06-24 08:56  VPPAdminTools\GUI\Layouts\ServerManagerUI\ServerMonitorPin.layout
     1919  2026-06-24 07:18  VPPAdminTools\GUI\Layouts\SettingsMenuElement.layout
     1208  2026-06-24 07:18  VPPAdminTools\GUI\Layouts\SettingsMenuVPPATSection.layout
    22176  2026-07-09 06:31  VPPAdminTools\GUI\Layouts\SpectateUI\MenuSpectateTools.layout
     3253  2026-07-07 10:42  VPPAdminTools\GUI\Layouts\SpectateUI\SpectateOverlay.layout
     1493  2026-07-07 09:01  VPPAdminTools\GUI\Layouts\SpectateUI\SpectatePlayerEntry.layout
     8776  2026-09-22 12:03  VPPAdminTools\GUI\Layouts\StatsHudUI\StatsHud.layout
    20510  2026-06-24 02:28  VPPAdminTools\GUI\Layouts\TeleportManagerUI\MenuTeleportManager.layout
     4648  2026-06-24 02:28  VPPAdminTools\GUI\Layouts\TeleportManagerUI\PopUpCreatePosition.layout
     4448  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\TeleportManagerUI\TeleportEntry.layout
     2308  2026-09-22 06:19  VPPAdminTools\GUI\Layouts\UIHelpers\ContextMenu\VPPContextMenu.layout
     1873  2026-09-22 06:19  VPPAdminTools\GUI\Layouts\UIHelpers\ContextMenu\VPPContextMenuRow.layout
      349  2026-09-22 06:19  VPPAdminTools\GUI\Layouts\UIHelpers\ContextMenu\VPPContextMenuSeparator.layout
      287  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\UIHelpers\CustomGridSpacer.layout
     2976  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\UIHelpers\CustomInputMenu.layout
     2878  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\UIHelpers\CustomMapWidget.layout
      954  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\UIHelpers\DesignSystem\ActionButton.layout
     1010  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\UIHelpers\DesignSystem\SectionHeader.layout
     1776  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\UIHelpers\DesignSystem\VitalCell.layout
     7956  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\UIHelpers\VPPDialogBox.layout
      405  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\UIHelpers\VPPDragSelect.layout
     1365  2026-06-25 07:35  VPPAdminTools\GUI\Layouts\UIHelpers\VPPInfoBox.layout
      726  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\VPPDropdown\dropdown_element.layout
     2259  2026-06-23 07:41  VPPAdminTools\GUI\Layouts\VPPDropdown\dropdown_prefab.layout
     1396  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\VPPNotification.layout
     1539  2022-09-27 11:48  VPPAdminTools\GUI\Layouts\VPPNotificationDebug.layout
      439  2021-12-30 07:28  VPPAdminTools\GUI\Layouts\VPPNotificationParent.layout
    41938  2026-06-25 02:39  VPPAdminTools\GUI\Layouts\WeatherManagerUI\MenuWeatherManager.layout
    60795  2026-09-29 07:48  VPPAdminTools\GUI\Layouts\WebHooksUI\MenuWebHooks.layout
    30779  2026-10-27 05:14  VPPAdminTools\GUI\Layouts\XMLEditorUI\MenuXMLEditor.layout
    11713  2026-09-24 00:40  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorBackupsTab.layout
      874  2026-09-23 03:32  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorChip.layout
    13109  2026-09-28 10:08  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorCreateTab.layout
    85179  2026-09-28 02:36  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorEventsTab.layout
     6643  2026-09-24 04:41  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorFilesTab.layout
    35845  2026-09-24 04:24  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorMapTab.layout
    26970  2026-09-24 04:24  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorMessagesTab.layout
    58678  2026-09-29 02:59  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorSpawnablesTab.layout
   135303  2026-10-27 05:36  VPPAdminTools\GUI\Layouts\XMLEditorUI\XMLEditorTypesTab.layout
    31958  2026-09-23 04:40  VPPAdminTools\GUI\Styles\DesignSystem.md
     2658  2021-12-30 07:28  VPPAdminTools\GUI\Styles\testStyle.styles
    32053  2026-06-23 07:41  VPPAdminTools\GUI\Styles\vpp_widgets.styles
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\bar.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\car.paa
    11096  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\church.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\deerstand.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\feedshack.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\firestation.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\fuelstation.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\hospital.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\house.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\iconCar_ca.paa
      842  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\IconEmpty.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\iconTruck_ca.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\lighthouse.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\objective_CA.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\pictureParachute_ca.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\police.paa
    11096  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\radiotower.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\shopping.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\tent.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\unknown_CA.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\warning_CA.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\watchtower.paa
    22016  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\waterpump.paa
    11096  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\watertower.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\waypoint_CA.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\waypointcompleted_CA.paa
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\CustomMapIcons\waypointeditor_CA.paa
  8294536  2021-12-30 07:28  VPPAdminTools\GUI\Textures\dayz_gui_vpp.edds
      475  2021-12-30 07:28  VPPAdminTools\GUI\Textures\dayz_gui_vpp.edds.meta
     1886  2021-12-30 07:28  VPPAdminTools\GUI\Textures\dayz_gui_vpp.imageset
     5625  2021-12-30 07:28  VPPAdminTools\GUI\Textures\down-arrow.paa
     1522  2021-12-30 07:28  VPPAdminTools\GUI\Textures\icon_dead.paa
    19801  2026-10-27 11:59  VPPAdminTools\GUI\Textures\vpp_changelog_buddy_1.paa
    22016  2026-10-27 12:10  VPPAdminTools\GUI\Textures\vpp_changelog_buddy_2.paa
    22016  2026-10-27 12:10  VPPAdminTools\GUI\Textures\vpp_changelog_buddy_3.paa
   241250  2026-06-25 10:20  VPPAdminTools\GUI\Textures\vpp_icons.edds
      322  2026-06-25 10:20  VPPAdminTools\GUI\Textures\vpp_icons.edds.meta
     7404  2026-06-25 09:34  VPPAdminTools\GUI\Textures\vpp_icons.imageset
   136831  2026-10-21 07:49  VPPAdminTools\GUI\Textures\vpp_icons.paa
     4347  2026-06-11 12:13  VPPAdminTools\GUI\Textures\vpp_ui.edds
      335  2026-06-11 12:13  VPPAdminTools\GUI\Textures\vpp_ui.edds.meta
    11167  2026-06-11 12:13  VPPAdminTools\GUI\Textures\vpp_ui.imageset
    13640  2026-10-21 07:49  VPPAdminTools\GUI\Textures\vpp_ui.paa
     1051  2025-07-28 06:25  VPPAdminTools\README.md
     4997  2021-12-30 07:28  VPPAdminTools\sounds\beep.ogg
     5818  2021-12-30 07:28  VPPAdminTools\sounds\click.ogg
     7291  2021-12-30 07:28  VPPAdminTools\sounds\hint.ogg
    18433  2026-09-22 09:47  VPPAdminTools\stringtable.csv
     6435  2026-10-29 08:01  VPPAdminTools\texHeaders.bin
      959  2026-10-21 07:55  VPPAdminTools\VPPNotifications\3_Game\VPPNotifications\DayZGame.c
      568  2026-10-21 07:55  VPPAdminTools\VPPNotifications\3_Game\VPPNotifications\VPPMessageProps.c
      895  2026-10-21 07:55  VPPAdminTools\VPPNotifications\3_Game\VPPNotifications\VPPNotificationManager.c
      299  2026-10-21 07:55  VPPAdminTools\VPPNotifications\5_Mission\VPPNotifications\missionGameplay.c
     3061  2026-10-21 07:55  VPPAdminTools\VPPNotifications\5_Mission\VPPNotifications\VPPNotificationCard.c
     3818  2026-10-21 07:55  VPPAdminTools\VPPNotifications\5_Mission\VPPNotifications\VPPNotificationUI.c
       27  2026-10-21 07:55  VPPAdminTools\VPPNotifications\Definitions\VPPNotifications\Definitions.c
---------                    ---------
 79616396                    537 Files

======================================================================
VALIDACAO FINAL DO PBO
======================================================================
SHA256 inicial: 431398D78FB3EAEE4C3F0849EAE582263BE2A5FC608F90DB6F035F29AFB60887
SHA256 final: 431398D78FB3EAEE4C3F0849EAE582263BE2A5FC608F90DB6F035F29AFB60887
RESULTADO: PBO ORIGINAL INALTERADO

======================================================================
FIM DA INSPECAO
======================================================================
