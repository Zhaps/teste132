RAVEN CONTROL CENTER - CODIGO VPP INSTALADO
Data: 2026-11-19 13:56:56
PBO: C:\RavenRP\DayZServer\@VPPAdminTools\addons\VPPAdminTools.pbo
SHA256 inicial: 431398D78FB3EAEE4C3F0849EAE582263BE2A5FC608F90DB6F035F29AFB60887

CODIGO DE SAIDA DA EXTRACAO: 0


======================================================================
CONTEUDO DOS ARQUIVOS EXTRAIDOS
======================================================================

ARQUIVO: VPPAdminTools\3_Game\VPPAdminTools\PlayerList\PlayerList.c
----------------------------------------------------------------------
/*
* Player list is synchronized between server and client(s) based on server events
* (join, leave, respawn)
* when an administrator client joins/respawns in the server, they are added as a RECEIVER and added into PLAYERS.
* The entire list of PLAYERS_CLIENT is then sent to the joining/respawning administrator client.
* On the event of a regular player leaving/joining/respawn their entry is updated and synchronized with all RECEIVERS
* RECEIVERS are administrators
* PLAYERS / PLAYERS_CLIENT is everyone
*/

class PlayerListManager
{
	static ref PlayerListManager m_Instance;
	static ref map<string, PlayerIdentity> PLAYERS; 	//Bohemia UID, Identity ref (server only)
	static ref map<string, ref VPPUser> PLAYERS_CLIENT; //sending this via RPC to clients (client + server)
	static ref array<PlayerIdentity> RECEIVERS;			//hold onto administrator identities (server only)

	static bool InitMaps = Init();
	static bool Init()
	{
		PLAYERS = new map<string, PlayerIdentity>;
		PLAYERS_CLIENT = new map<string, ref VPPUser>;
		RECEIVERS = {};
		return true;
	}

	void PlayerListManager()
	{
		m_Instance = this;
		g_Game.Event_OnRPC.Insert(OnRPC);
	}

	void ~PlayerListManager()
	{
		if (g_Game)
			g_Game.Event_OnRPC.Remove(OnRPC);
	}

	/*
	* RPC handler
	*/
	void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)
	{
#ifdef SERVER
		if (rpc_type == VPPATRPCs.RPC_PLAYERLIST_FORCESYNC)
		{
			if (!sender || !GetGame().IsDedicatedServer())
				return;

			PlayerListManager.SyncListToClient(sender, true);
		}
#else
		if (rpc_type == VPPATRPCs.RPC_SYNC_PLAYER_LIST)
		{
			map<string, VPPUser> tmp = new map<string, VPPUser>;
			if (!ctx.Read(tmp))
			{
				Print("VPPATRPCs.RPC_SYNC_PLAYER_LIST ~ FAIELD ~");
				return;
			}

			PlayerListManager.PLAYERS_CLIENT.Clear();
			PlayerListManager.PLAYERS_CLIENT.Copy(tmp);
		}

		string uid;
		if (rpc_type == VPPATRPCs.RPC_PLAYERLIST_ADD)
		{
			VPPUser user;
			if (!ctx.Read(uid) || !ctx.Read(user))
			{
				Print("VPPATRPCs.RPC_PLAYERLIST_ADD: error unable to break down RPC data!");
				return;
			}

			bool added = AddEntryClient(uid, user);
			Print(string.Format("VPPATRPCs.RPC_PLAYERLIST_ADD: %1 %2 %3", uid, user.GetUserName(), added));
		}

		if (rpc_type == VPPATRPCs.RPC_PLAYERLIST_REMOVE)
		{
			if (ctx.Read(uid))
			{
				bool removed = RemoveEntryClient(uid);
				Print("VPPATRPCs.RPC_PLAYERLIST_REMOVE: removed â–º " + uid);
			}
		}
#endif
	}

	/*
	* (client)
	*/
	bool AddEntryClient(string uid, VPPUser data)
	{
		if (PlayerListManager.PLAYERS_CLIENT.Contains(uid))
		{
			PlayerListManager.PLAYERS_CLIENT.Set(uid, data);
			return true;
		}

		PlayerListManager.PLAYERS_CLIENT.Insert(uid, data);
		return true;
	}

	/*
	* (client)
	*/
	bool RemoveEntryClient(string uid)
	{
		if (PlayerListManager.PLAYERS_CLIENT.Contains(uid))
		{
			PlayerListManager.PLAYERS_CLIENT.Remove(uid);
			return true;
		}
		return false;
	}

	/*
	* (client)
	* Send RPC to server to force build a list and send back to all RECEIVERS
	*/
	void RequestForceSync()
	{
		ScriptRPC rpc = new ScriptRPC();
		rpc.Send(NULL, VPPATRPCs.RPC_PLAYERLIST_FORCESYNC, true, NULL);
	}

	/*
	* Give the player count from what World module has. 
	* Best used to determine if our list is out of sync somehow
	*/
	int GetCountActual()
	{
		array<Man> players = new array<Man>;
       	GetGame().GetWorld().GetPlayerList(players);
       	return players.Count();
	}

	int GetCount()
	{
		if (GetGame().IsDedicatedServer() && GetGame().IsMultiplayer())
		{
			return PlayerListManager.PLAYERS.Count();
		}
		return PlayerListManager.PLAYERS_CLIENT.Count();
	}
	
	array<ref VPPUser> GetUsers()
	{
		//On server only
		if (GetGame().IsDedicatedServer() && GetGame().IsMultiplayer())
		{
			if (PLAYERS_CLIENT.Count() != GetCountActual())
				PlayerListManager.BuildList();
		}

		array<ref VPPUser> elements = {};
		for (int i = 0; i < PlayerListManager.PLAYERS_CLIENT.Count(); i++)
		{
			elements.Insert(PlayerListManager.PLAYERS_CLIENT.GetElement(i));
		}

		return elements;
	}

	/*
	* Works ONLY with Bohemia ID
	* Server / Client supported
	*/
	bool HasPlayerInList(string id)
	{
		if (GetGame().IsDedicatedServer() && GetGame().IsMultiplayer())
		{
			return PlayerListManager.PLAYERS[id] != NULL;
		}
		return PlayerListManager.PLAYERS_CLIENT[id] != NULL;
	}

//start-server-methods
	static void AddReceiver(notnull PlayerIdentity identity)
	{
		if (RECEIVERS.Find(identity) > -1)
			return; //duplicate check.

		RECEIVERS.Insert(identity);
		Print("[PlayerListManager] AddReceiver â–º added: " + identity);
	}

	static void RemoveReceiver(notnull PlayerIdentity identity)
	{
		int index = RECEIVERS.Find(identity);
		if (identity && index > -1)
		{
			RECEIVERS.RemoveOrdered(index);
			Print("[PlayerListManager] RemoveReceiver â–º removed: " + identity);
		}
	}

	/*
	* Add entry, doesn't handle sync!
	* if already exists, replaced by new ptr of identity.
	*/
	static bool AddEntry(string uid, PlayerIdentity identity = NULL)
	{
		if (PLAYERS.Contains(uid))
		{
			PLAYERS.Set(uid, identity);
			return true;
		}

		PLAYERS.Insert(uid, identity);
		return true;
	}

	/*
	* remove entry, handles sync automatically.
	*/
	static bool RemoveEntry(string uid, bool ignoreNull = false)
	{
		if (PLAYERS.Contains(uid) && (ignoreNull || PLAYERS[uid] == NULL))
		{
			PLAYERS.Remove(uid);
			PlayerListManager.SyncEntryToReceivers(uid);
			return true;
		}
		return false;
	}

	/*
	* remove entry by PlayerIdentity, handles sync automatically.
	*/
	static bool RemoveEntry(PlayerIdentity identity)
	{
		if (identity && PLAYERS.Contains(identity.GetId()))
		{
			PLAYERS.Remove(identity.GetId());
			PlayerListManager.SyncEntryToReceivers(identity.GetId());
			return true;
		}
		return false;
	}

	static void BuildList(bool useWorldPtr = false)
	{
		if (useWorldPtr || PLAYERS.Count() <= 0)
		{
			//rebuild one from world array
			array<Man> players = new array<Man>;
       		GetGame().GetWorld().GetPlayerList(players);
       		for (int i = 0; i < players.Count(); ++i)
       		{
       			if (!players[i])
       				continue;

       			if (!players[i].GetIdentity())
       				continue;

       			PLAYERS.Insert(players[i].GetIdentity().GetId(), players[i].GetIdentity());
       		}
		}

		PLAYERS_CLIENT.Clear();
		foreach(string uid, PlayerIdentity identity : PLAYERS)
		{
			if (!identity)
			{
				Print("[PlayerListManager] UID: " + uid + " no identity");
				continue;
			}
			PLAYERS_CLIENT.Insert(uid, new VPPUser(identity.GetName(), identity.GetPlainId(), identity.GetPlayerId()));
		}
	}

	/*
	* Sends entire Sync list to a specified client via RPC
	*/
	static void SyncListToClient(notnull PlayerIdentity identity, bool useWorldPtr = false)
	{
		if (!identity)
			return;

		BuildList(useWorldPtr);

		ScriptRPC rpc = new ScriptRPC();
		rpc.Write(PLAYERS_CLIENT);
		rpc.Send(NULL, VPPATRPCs.RPC_SYNC_PLAYER_LIST, true, identity);
		delete rpc;
	}

	/*
	* Sends an entry of a player by using uid to all RECEIVERS clients
	* Automatically determines weather to send an ADD or REMOVE RPC
	* @Param0: Bohemia ID of the player you want to sync to all RECEIVERS.
	*/
	static bool SyncEntryToReceivers(string uid)
	{
		if (RECEIVERS.Count() <= 0)
			return false;

		if (PLAYERS_CLIENT.Count() != GetPlayerListManager().GetCountActual())
			BuildList();

		int rpc_type = VPPATRPCs.RPC_PLAYERLIST_ADD;
		PlayerIdentity identity = PLAYERS[uid];
		
		if (!PLAYERS.Contains(uid) || !identity)
		{
			Print("[PlayerListManager] SyncEntryToReceivers â–º uid: " + uid + " isn't in the players list! sending a remove.");
			rpc_type = VPPATRPCs.RPC_PLAYERLIST_REMOVE;
		}

		ScriptRPC rpc = new ScriptRPC();
		rpc.Write(uid);

		if (identity && rpc_type == VPPATRPCs.RPC_PLAYERLIST_ADD)
		{
			if (!PLAYERS_CLIENT[uid])
			{
				Print("[PlayerListManager] SyncEntryToReceivers:: ERROR! unable to fetch VPPUser â–º " + uid);
				return false;
			}
			rpc.Write(PLAYERS_CLIENT[uid]);
		}
		
		for (int i = 0; i < RECEIVERS.Count(); ++i)
		{
			if (!RECEIVERS[i])
				continue;

			rpc.Send(NULL, rpc_type, true, RECEIVERS[i]);
		}

		delete rpc;
		return true;
	}
//end-server-methods

	static void DebugListServer()
	{
		Print("[PlayerListManager] ~debug~\n");
		foreach(string uid, PlayerIdentity identity : PLAYERS)
		{
			Print(string.Format("\t â–º uid: %1 identity: %2", uid, identity));
		}
		Print("[PlayerListManager] Total entries in map: " + PLAYERS.Count());
	}

	static void DebugListClient()
	{
		Print("[PlayerListManager] ~debug~\n");
		foreach(string uid, VPPUser data : PLAYERS_CLIENT)
		{
			Print(string.Format("\t â–º uid: %1 data: %2 %3 %4", uid, data.GetUserId(), data.GetUserName(), data.GetSessionId()));
		}
		Print("[PlayerListManager] Total entries in map: " + PLAYERS_CLIENT.Count());
	}
};

PlayerListManager GetPlayerListManager()
{
    return PlayerListManager.m_Instance;
};

ARQUIVO: VPPAdminTools\3_Game\VPPAdminTools\PlayerList\VPPUser.c
----------------------------------------------------------------------
class VPPUser
{
	private string m_UserName;
	private string m_Steam64ID;
	private int    m_SessionId;
	
	void VPPUser(string name, string id, int sessionId = -1)
	{
		m_UserName  = name;
		m_Steam64ID = id;
		m_SessionId = sessionId;
	}
		
	string GetUserId()
	{
		return m_Steam64ID;
	}
	
	string GetUserName()
	{
		return m_UserName;
	}

	int GetSessionId()
	{
		return m_SessionId;
	}
};

/*
	ONLY FOR BACKWARD COMPAT, DATA TYPE CHANGES WOULD CAUSE CRASH UPON CONVERTION
*/
class Old_VPPUser
{
	private string m_UserName;
	private string m_Steam64ID;
	
	void Old_VPPUser(string name, string id)
	{
	}
};

ARQUIVO: VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c
----------------------------------------------------------------------
/*
	Webhook events and the variables each one offers to templates. Shared (3_Game) so the server renders and validates
	with them and the admin client can list them (variable reference, previews).

	Every event also gets the common variables (server, players, time, event id). A variable's Sample is what previews
	and validation render with.
*/
class VPPWebhookVar : Managed
{
	string Name;
	string Sample;

	void VPPWebhookVar(string name, string sample)
	{
		Name = name;
		Sample = sample;
	}
};

class VPPWebhookEventDef : Managed
{
	string Id;
	// legacy switch this event followed in old configs ("" = none): death, admin, hit, joinleave, status
	string LegacyGroup;
	ref array<ref VPPWebhookVar> Vars;

	void VPPWebhookEventDef(string id, string legacyGroup)
	{
		Id = id;
		LegacyGroup = legacyGroup;
		Vars = new array<ref VPPWebhookVar>();
	}

	void AddVar(string name, string sample)
	{
		Vars.Insert(new VPPWebhookVar(name, sample));
	}

	bool HasVar(string name)
	{
		foreach (VPPWebhookVar webhookVar : Vars)
		{
			if (webhookVar.Name == name)
			{
				return true;
			}
		}

		return false;
	}

	// The sample values of every variable (common ones included), for previews and validation.
	void FillSamples(map<string, string> outVars)
	{
		foreach (VPPWebhookVar webhookVar : Vars)
		{
			outVars.Set(webhookVar.Name, webhookVar.Sample);
		}
	}
};

class VPPWebhookDefs
{
	const static string EV_ADMIN = "admin.action";
	const static string EV_KILL = "kill";
	const static string EV_HIT = "hit";
	const static string EV_JOIN = "join";
	const static string EV_LEAVE = "leave";
	const static string EV_LEAVE_EARLY = "leave.early";
	const static string EV_LOGOUT_START = "logout.start";
	const static string EV_LOGOUT_CANCEL = "logout.cancel";
	const static string EV_STATUS = "server.status";
	const static string EV_BOOT = "server.boot";

	const static string GROUP_DEATH = "death";
	const static string GROUP_ADMIN = "admin";
	const static string GROUP_HIT = "hit";
	const static string GROUP_JOINLEAVE = "joinleave";
	const static string GROUP_STATUS = "status";

	protected static ref array<ref VPPWebhookEventDef> s_Defs;

	static array<ref VPPWebhookEventDef> All()
	{
		Ensure();
		return s_Defs;
	}

	static VPPWebhookEventDef Get(string eventId)
	{
		Ensure();
		foreach (VPPWebhookEventDef def : s_Defs)
		{
			if (def.Id == eventId)
			{
				return def;
			}
		}

		return null;
	}

	protected static void Ensure()
	{
		if (s_Defs)
		{
			return;
		}

		s_Defs = new array<ref VPPWebhookEventDef>();
		VPPWebhookEventDef def = NewDef(EV_ADMIN, GROUP_ADMIN);
		def.AddVar("admin.name", "SurvivorAdmin");
		def.AddVar("admin.id", "76561198000000000");
		def.AddVar("action", "[ItemManager] Spawned Item: M4A1 on self");
		def.AddVar("action.text", "Spawned Item: M4A1 on self");
		def.AddVar("module", "ItemManager");

		def = NewDef(EV_KILL, GROUP_DEATH);
		def.AddVar("victim.name", "Survivor");
		def.AddVar("victim.id", "76561198000000001");
		def.AddVar("victim.pos", "7500.1, 290.5, 7700.2");
		def.AddVar("killer.name", "Bandit");
		def.AddVar("killer.id", "76561198000000002");
		def.AddVar("killer.pos", "7560.3, 291.0, 7712.8");
		def.AddVar("cause", "player");
		def.AddVar("weapon", "M4-A1");
		def.AddVar("distance", "61.4");
		def.AddVar("details", "Survivor (7500, 7700) killed by: Bandit (7560, 7712) with [M4-A1] from [61.4] meters");

		def = NewDef(EV_HIT, GROUP_HIT);
		def.AddVar("victim.name", "Survivor");
		def.AddVar("victim.id", "76561198000000001");
		def.AddVar("victim.pos", "7500.1, 290.5, 7700.2");
		def.AddVar("source.name", "Bandit");
		def.AddVar("source.id", "76561198000000002");
		def.AddVar("source.kind", "player");
		def.AddVar("weapon", "M4-A1");
		def.AddVar("ammo", "Bullet_556x45");
		def.AddVar("zone", "Torso");
		def.AddVar("distance", "61.4");
		def.AddVar("health", "72.5");
		def.AddVar("details", "Survivor (7500, 7700) hit by Bandit (7560, 7712) into Torso(72.5 HP left) with (M4-A1) from (61.4) meters");

		AddPlayerEvent(EV_JOIN, "joined the server!");
		AddPlayerEvent(EV_LEAVE, "left the server!");
		AddPlayerEvent(EV_LEAVE_EARLY, "disconnected early from server (EXIT NOW).");
		AddPlayerEvent(EV_LOGOUT_START, "initiated disconnect process..");
		AddPlayerEvent(EV_LOGOUT_CANCEL, "canceled logout");

		def = NewDef(EV_STATUS, GROUP_STATUS);
		def.AddVar("server.fps", "58");
		def.AddVar("uptime", "0d 5h 12m 40s");
		def.AddVar("uptime.seconds", "18760");

		NewDef(EV_BOOT, GROUP_STATUS);

		foreach (VPPWebhookEventDef common : s_Defs)
		{
			AddCommonVars(common);
		}
	}

	protected static VPPWebhookEventDef NewDef(string eventId, string legacyGroup)
	{
		VPPWebhookEventDef def = new VPPWebhookEventDef(eventId, legacyGroup);
		s_Defs.Insert(def);
		return def;
	}

	protected static void AddPlayerEvent(string eventId, string actionSample)
	{
		VPPWebhookEventDef def = NewDef(eventId, GROUP_JOINLEAVE);
		def.AddVar("player.name", "Survivor");
		def.AddVar("player.id", "76561198000000001");
		def.AddVar("action", actionSample);
	}

	protected static void AddCommonVars(VPPWebhookEventDef def)
	{
		def.AddVar("event", def.Id);
		def.AddVar("server.name", "My DayZ Server");
		def.AddVar("server.ip", "203.0.113.10");
		def.AddVar("server.port", "27016");
		def.AddVar("server.map", "chernarusplus");
		def.AddVar("players", "12");
		def.AddVar("time.iso", "2026-09-29T18:04:00.000Z");
		def.AddVar("time.unix", "1790705040");
		def.AddVar("time.date", "2026-09-29");
		def.AddVar("time.time", "18:04:00");
	}

	// "hook.*" variables come from the webhook's own custom variables; they are always allowed in templates.
	static bool IsHookVar(string name)
	{
		return name.IndexOf("hook.") == 0;
	}
};

// What an admin may do in the webhooks menu (the server sends the mask with the list; the server checks again).
class VPPWebhookAccess
{
	const static int CREATE = 1;
	const static int EDIT = 2;
	const static int DELETE = 4;
	const static int EDIT_TEMPLATES = 8;
	const static int TEST_SEND = 16;
	const static int VIEW_URL = 32;
};

class VPPWebhookVarNames
{
	// Letters, digits, "_" and "." (template variable and hook.* names).
	static bool IsPlain(string name)
	{
		int total = name.Length();
		int i = 0;
		int code = 0;
		string ch = "";
		if (total == 0)
		{
			return false;
		}

		for (i = 0; i < total; i++)
		{
			ch = name.Get(i);
			code = ch.ToAscii();
			if (code >= 97 && code <= 122)
			{
				continue;
			}

			if (code >= 65 && code <= 90)
			{
				continue;
			}

			if (code >= 48 && code <= 57)
			{
				continue;
			}

			if (ch != "." && ch != "_")
			{
				return false;
			}
		}

		return true;
	}
};


ARQUIVO: VPPAdminTools\3_Game\VPPAdminTools\VanillaPlusPlus.c
----------------------------------------------------------------------
modded class DayZGame
{
	private ref VPPEventHandler vppatEventHandler;
	private bool   m_SpectateStatus;
	private bool   m_IsLShiftHolding;

	private bool   m_DisablePasswordProtection;
	private int    m_FailedLoginCount = 0;
	private string m_AdminPassword;

	private string 			  m_VServerIP;

	private string 			  m_ServerName;
	private int 			  m_Vtps = 0;
    private int 			  m_Vtps_time = 0;
    private int 			  m_Vticks = 0;

    private bool 					m_VPPATOnlineServicesInit;
    private ref VPPATProfileOptions m_VPPATProfileOptions;

    private ref map<string,string> 	 m_VPPDebugMissions; //terrain name, path

	void DayZGame()
	{
		new PlayerListManager();
		m_VPPDebugMissions = new map<string,string>;
		Print("[DayZ Game]:: DayZGame(): Initializing V++ Admin Tools.");
		vppatEventHandler = new VPPEventHandler();
		GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.RegisterRPCs, 500, false); //Register RPCs after 10 seconds of game boot
		m_VPPATProfileOptions = new VPPATProfileOptions();

		#ifndef SERVER
			SetupDebugMission("ChernarusPlus");
			SetupDebugMission("Enoch");
		#endif
	}

	void CreateDirectoriesFromPath(string basePath, string path)
	{
		array<string> output = {};
		path.Split("\\", output);
		for (int i = 0; i < output.Count() - 1; ++i)
			MakeDirectory(string.Format("%1/%2", basePath, output[i]));
	}

	void SetupDebugMission(string terrain, bool forceOverride = false)
	{
		terrain.ToLower();
		string path = string.Format("$saves:VPPDebugMissions/Debug.%1", terrain);

		MakeDirectory("$saves:VPPDebugMissions");
		string missionPath = string.Format("$saves:VPPDebugMissions/Debug.%1", terrain);
		if (FileExist(missionPath) && !forceOverride)
		{
			Print("Default Mission: " + missionPath + " exists!");
			m_VPPDebugMissions.Insert(terrain, path); //exists already
			return;
		}

		if (forceOverride)
			FileProcessingFuncs.DeleteRecursive(missionPath, true); //Delete existing

		MakeDirectory(missionPath);
		CopyFile("VPPAdminTools/Extra/init.c", path + "/init.c");

		string fileName;
		FileAttr fileAttributes;
		FindFileFlags flags = FindFileFlags.ARCHIVES;
		
		FindFileHandle fHandle = FindFile(string.Format("dz/worlds/%1/ce/*", terrain), fileName, fileAttributes, flags);
		CreateDirectoriesFromPath(path, fileName);
		CopyFile(string.Format("dz/worlds/%1/ce/%2", terrain, fileName), path + "/" + fileName);

		int i = 0;
		while(FindNextFile(fHandle, fileName, fileAttributes))
		{
			CreateDirectoriesFromPath(path, fileName);
			CopyFile(string.Format("dz/worlds/%1/ce/%2", terrain, fileName), path + "/" + fileName);
			i++;
		}

		m_VPPDebugMissions.Insert(terrain, path);
	}

	bool SearchForCustomDebugMission(out array<string> paths)
	{
		paths = {};
		string fileName;
		FileAttr fileAtts;
		FindFileFlags flags = FindFileFlags.ARCHIVES;

		FindFileHandle fHandle = FindFile("$CurrentDir:/*", fileName, fileAtts, flags);
		if (FileExist(string.Format("$CurrentDir:%1/init.c", fileName)) && fileAtts == FileAttr.DIRECTORY)
			paths.Insert(fileName);

		int i = 0;
		while(FindNextFile(fHandle, fileName, fileAtts))
		{
			if (FileExist(string.Format("$CurrentDir:%1/init.c", fileName)) && fileAtts == FileAttr.DIRECTORY)
				paths.Insert(fileName);

			i++;
		}

		//Append paths to vanilla missions:
		foreach(string terrain, string path: m_VPPDebugMissions)
		{
			paths.Insert(path);
		}
		return true;
	}

	void PlayCustomMission(string path)
	{
		Print("PlayCustomMission: " + path);
		SetGameState(DayZGameState.IN_GAME);
		SetLoadState(DayZLoadState.MISSION_START);
		path.Replace("/", "\\");
		PlayMission(path);
	}

	override bool OnInitialize()
	{
		string value;
		if (CommandlineGetParam("CEDebugMode", value))
		{
			value.ToLower();
			if (GetLoadState() == DayZLoadState.UNDEFINED)
			{
				ParticleList.PreloadParticles();
				InitNotifications();

				switch(value)
				{
					case "chernarusplus":
						PlayCustomMission(m_VPPDebugMissions["chernarusplus"]);
					break;

					case "enoch":
					case "livonia":
						PlayCustomMission(m_VPPDebugMissions["enoch"]);
					break;

					default:
						//Search for a custom mission
						Print("[VPPAdminTools] FAILED TO LOAD DEBUG MISSION: " + value + " unknown terrain map");
						DebugModeDialog diag;
						GetGame().GetWorkspace().CreateWidgets("VPPAdminTools\\GUI\\Layouts\\VPPNotificationDebug.layout").GetScript(diag);
						string errorMsg = string.Format("Unable to find a mission folder for world: %1\n", value);
						errorMsg += "\n-Make sure the world name is correct according to the config of the world.";
						errorMsg += "\n-Copy a valid mission folder to the root directory of DayZ Client and click 'SEARCH AGAIN'.";
						errorMsg += "\n\n-Missions under '$saves' are created by default directly from game data (CLE PBOs)";
						errorMsg += "\nYou can find those missions in:";
						errorMsg += "\n\n[when '-profiles' param is NOT used]:\nC:\\Users\\(PC_NAME)\\Documents\\DayZ\\VPPDebugMissions\\";
						errorMsg += "\n\n[when '-profiles' param is used]: $profile:VPPDebugMissions\\";
						errorMsg += "\n\n'$profile' is the path you set with the startup parameter '-profiles'";
						errorMsg += "\n\nDouble-click a mission from the list below to start!";
						diag.SetError("ERROR: No Debug mission files found!", errorMsg);
						diag.RefreshSearch();
					break;
				}
			}
		}
		else
		{
			return super.OnInitialize();
		}
		return false;
	}

	override void OnKeyPress(int key)
	{
		super.OnKeyPress(key);
		if ( key == KeyCode.KC_LSHIFT ) 
		{
			m_IsLShiftHolding = true;
		}

		if ((IsLeftAltHolding() || IsLeftAltHolding()) && key == KeyCode.KC_F4)
		{
			LogoutRequestTime();
			GetMission().Pause();
			GetCallQueue(CALL_CATEGORY_GUI).Call(GetMission().CreateLogoutMenu, GetGame().GetUIManager().GetMenu());
			GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(GetMission().AbortMission, 1000);
			GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.RequestExit, 500, false, 0);
		}
	}
	
	override void OnKeyRelease(int key)
	{
		super.OnKeyRelease(key);
		if ( key == KeyCode.KC_LSHIFT ) 
		{
			m_IsLShiftHolding = false;
		}
	}

	override void DeferredInit()
	{
		super.DeferredInit();
		//Register custom option 
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.CAM_SPEED, "vppat_cam_speed", VPPATProfileConstants.DEFAULT_CAM_SPEED);
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.CAM_BOOST, "vppat_cam_boost", VPPATProfileConstants.DEFAULT_CAM_BOOST);
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.CAM_MOVE_DRAG, "vppat_cam_move_drag", VPPATProfileConstants.DEFAULT_CAM_MOVE_DRAG);
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.CAM_MOUSE_SENSE, "vppat_cam_mouse_sense", VPPATProfileConstants.DEFAULT_CAM_MOUSE_SENSE);
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.CAM_SMOOTHNESS, "vppat_cam_smoothness", VPPATProfileConstants.DEFAULT_CAM_SMOOTHNESS);
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.CAM_FOV, "vppat_cam_fov", VPPATProfileConstants.DEFAULT_CAM_FOV);
		//Stats HUD on/off. Encoded 1.0=enabled (default) / 2.0=disabled â€” never 0.0, because
		//RegisterProfileOption treats a stored "0" as "unset" and would reset the user's choice.
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.STATS_HUD_ENABLED, "vppat_stats_hud_enabled", 1.0);
		//Stats HUD corner (stored 1..4 = corner 0..3, default 1 = bottom-right) and orientation
		//(1.0=vertical (default) / 2.0=horizontal); same "never store 0" rule as above.
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.STATS_HUD_CORNER, "vppat_stats_hud_corner", 1.0);
		m_VPPATProfileOptions.RegisterProfileOption(EVPPATProfileOptions.STATS_HUD_VERTICAL, "vppat_stats_hud_vertical", 1.0);
	}

	//Credit to philip from CFTools ;)
	override void OnUpdate(bool doSim, float timeslice)
	{
        super.OnUpdate(doSim, timeslice);

        m_Vticks++;
        if(m_Vtps_time + 1 < GetGame().GetTickTime()) {
            m_Vtps_time = GetGame().GetTickTime();
            m_Vtps = m_Vticks / 2;
            m_Vticks = 0;
        }
    }

    int GetServerFPS()
    {
    	return m_Vtps;
    }

    string GetServerName()
	{
		return m_ServerName;
	}

	void SetServerName(string str)
	{
		m_ServerName = str;
	}

	void VSetServerIP(string ip)
	{
		m_VServerIP = ip;
	}

	string VGetServerIP()
	{
		return m_VServerIP;
	}

	VPPEventHandler VPPATGetEventHandler()
	{
		return vppatEventHandler;
	}

	//Register early RPCs after game is running.
	void RegisterRPCs()
	{
		GetRPCManager().AddRPC( "RPC_MissionGameplay", "KickClientHandle", this, SingleplayerExecutionType.Client );
		GetRPCManager().AddRPC( "RPC_MissionGameplay", "GetConnectedSession", this, SingleplayerExecutionType.Client );
	}
	
	void KickClientHandle( CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target )
	{
		Param1<string> data;
        if ( !ctx.Read( data ) || sender != null ) return;

        if (type == CallType.Client)
        {
			bool done = false;
			while( !done )
			{
				if (GetDayZGame().GetGameState() != DayZGameState.CONNECT || GetDayZGame().GetGameState() != DayZGameState.CONNECTING || g_Game.GetLoadState() != DayZLoadState.CONNECT_START)
				{
					GetGame().GetUIManager().ShowDialog("#VSTR_SESSION_DISCONNECT", "V++ AdminTools: "+data.param1, 1, DBT_OK, DBB_OK, DMT_WARNING, g_Game.GetUIManager().GetMenu());
	        		GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(GetGame().DisconnectSessionForce, 100, false);
					done = true;
					break;
				}
			}
        }
	}

	void GetConnectedSession( CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target )
	{
		if (type == CallType.Client)
        {
        	string address;
        	int port;
        	GetGame().GetHostAddress( address, port );
        	GetRPCManager().VSendRPC( "RPC_MissionGameplay", "ConnectedSession", new Param1<string>(address), true);
        }
	}
	
	void SetSpectateMode(bool state)
	{
		m_SpectateStatus = state;
	}
	
	float GetVPPATProfileVal(EVPPATProfileOptions option)
	{
		return m_VPPATProfileOptions.GetProfileOptionVal(option);
	}
	
	void SetVPPATProfileVal(EVPPATProfileOptions option, float value)
	{
		m_VPPATProfileOptions.SetProfileOptionVal(option, value);
	}

	//Stats HUD global on/off (persisted in the profile). Encoded 1.0=enabled / 2.0=disabled.
	bool IsStatsHudEnabled()
	{
		return GetVPPATProfileVal(EVPPATProfileOptions.STATS_HUD_ENABLED) < 1.5;
	}

	void SetStatsHudEnabled(bool enabled)
	{
		float val = 2.0;
		if (enabled)
			val = 1.0;
		SetVPPATProfileVal(EVPPATProfileOptions.STATS_HUD_ENABLED, val);
	}

	//Stats HUD screen corner, 0=bottom-right, 1=bottom-left, 2=top-left, 3=top-right (persisted in the profile)
	int GetStatsHudCorner()
	{
		float stored = GetVPPATProfileVal(EVPPATProfileOptions.STATS_HUD_CORNER);
		int corner = Math.Round(stored) - 1;
		if (corner < 0 || corner > 3)
		{
			corner = 0;
		}

		return corner;
	}

	void SetStatsHudCorner(int corner)
	{
		float stored = corner + 1;
		SetVPPATProfileVal(EVPPATProfileOptions.STATS_HUD_CORNER, stored);
	}

	//Stats HUD orientation (persisted in the profile); vertical unless the user switched it to horizontal
	bool IsStatsHudVertical()
	{
		return GetVPPATProfileVal(EVPPATProfileOptions.STATS_HUD_VERTICAL) < 1.5;
	}

	void SetStatsHudVertical(bool vertical)
	{
		float val = 2.0;
		if (vertical)
		{
			val = 1.0;
		}

		SetVPPATProfileVal(EVPPATProfileOptions.STATS_HUD_VERTICAL, val);
	}

	bool IsSpectateMode()
	{
		return m_SpectateStatus;
	}
	
	bool IsRightAltHolding()
	{
		return m_IsRightAltHolding;
	}
	
	bool IsLeftAltHolding()
	{
		return m_IsLeftAltHolding;
	}
	
	bool IsLShiftHolding()
	{
		return m_IsLShiftHolding;
	}

	int GetFailedLoginAttempts()
	{
		return m_FailedLoginCount;
	}

	void IncrementFailedLoginAttempts()
	{
		m_FailedLoginCount++;
	}

	void SetAdminPasswordHash(string data)
	{
		m_AdminPassword = data;
	}

	void DisablePasswordProtection(bool state)
	{
		m_DisablePasswordProtection = state;
	}

	bool IsPasswordProtectionDisabled()
	{
		return m_DisablePasswordProtection;
	}

	string GetAdminPasswordHash()
	{
		return m_AdminPassword;
	}

	string GetSessionPassword()
	{
		string password;
		if (GetCLIParam("password", password))
		{
			return password;
		}
		return m_ConnectPassword;
	}
	
	string VPPAT_GetSteam64Id()
	{
		if ( !m_VPPATOnlineServicesInit )
		{
			OnlineServices.Init();
			m_VPPATOnlineServicesInit = true;
		}
        
		BiosUserManager user_manager = GetGame().GetUserManager();
		if( user_manager )
		{
		    if( user_manager.GetTitleInitiator() )
		    {
		        user_manager.SelectUserEx( user_manager.GetTitleInitiator() );
		    }
		}

		if ( user_manager && user_manager.GetSelectedUser() )
		    return user_manager.GetSelectedUser().GetUid();

		return "-1";
	}

	/*
		Reconnects player to same session
	*/
	void ReconnectToCurrentSession()
	{
		string portStr, ip, password;
		int port;
		password = GetSessionPassword();
		if( !GetCLIParam("connect", ip) )
		{
			ip = m_ConnectAddress;
		}
		
		if ( !GetCLIParam("port", portStr) )
		{
			port = m_ConnectPort;
		}else{
			port = portStr.ToInt();
		}
		GetGame().Connect( null, ip, port, password );
	}

	//-=-=-=-=-=-=-=-=-=-=-=-
	string GetDefaultMagazine(EntityAI weapon)
	{
		TStringArray mag_names = new TStringArray;
		string cfg_path = "cfgWeapons " + weapon.GetType() + " magazines";
		GetGame().ConfigGetTextArray(cfg_path, mag_names);	
		
		if (mag_names.Count() > 0)
		{
			return mag_names[0];
		}
		
		mag_names = new TStringArray;
		cfg_path = "cfgWeapons " + weapon.GetType() + " chamberableFrom";
		GetGame().ConfigGetTextArray(cfg_path, mag_names);
		
		if (mag_names.Count() > 0)
		{
			return mag_names[0];
		}
			
		return "";
	}
	
	string GetDate(bool fullStamp)
	{
		int year, month, day, hour, minute, second;
		GetYearMonthDay(year, month, day);
		GetHourMinuteSecond(hour, minute, second);
		string date;
		if (fullStamp)
		{
			date = "[" + "Hr: " + hour.ToStringLen(2) + " - "+ "Min: " + minute.ToStringLen(2) +"] " + " || " + "[Mth: " +month.ToStringLen(2) + " -- " + "Day: " + day.ToStringLen(2) + "]";
			return date;
		}
		date = "[" + "Hr: " + hour.ToStringLen(2) + " - "+ "Min: " + minute.ToStringLen(2) +"] ";
		return date;
	}
	
	vector SwapYZ(vector vec)
	{
		vector tmp;
		tmp[0] = vec[0];
		tmp[1] = vec[2];
		tmp[2] = vec[1];
	
		return tmp;
	}

	vector StringToVector(string str)
	{
		vector oV = "0 0 0";
		TStringArray strs = new TStringArray;
		str.Replace("<","");
		str.Replace(">","");
		str.Replace(","," ");

		str.Split( " ", strs );

		oV = Vector(strs.Get(0).ToFloat(),strs.Get(1).ToFloat(),strs.Get(2).ToFloat());
		return oV;
	}

	string VectorToString(vector vctr)
	{
		string oStr;
		oStr = vctr[0].ToString();
		oStr += "," + vctr[1].ToString();
		oStr += "," + vctr[2].ToString();
		return oStr;
	}

	vector SnapToGround(vector pos)
	{
		float pos_x = pos[0];
		float pos_z = pos[2];
		float pos_y = GetGame().SurfaceY(pos_x, pos_z);
		vector tmp_pos = Vector(pos_x, pos_y, pos_z);
		tmp_pos[1] = tmp_pos[1] + pos[1];
	
		return tmp_pos;
	}

	vector GetPosByCursor( float distance = 1000.0, Object ignore = NULL )
	{
	    if ( !GetPlayer() )
	        return "0 0 0";

	    vector dir = GetGame().GetPointerDirection();
	    vector from = GetGame().GetCurrentCameraPosition();
	    vector to = from + ( dir * distance );
	    vector rayStart = from;
	    vector rayEnd = to;
	    vector hitPos;
	    vector hitNormal;
	    int hitComponentIndex;
	    DayZPhysics.RaycastRV( rayStart, rayEnd, hitPos, hitNormal, hitComponentIndex, NULL, NULL, ignore );
	    return hitPos;
	}

	vector GetCursorPos()
	{
	    if ( !GetPlayer() )
	        return "0 0 0";

	    vector rayStart = GetGame().GetCurrentCameraPosition();
	    vector rayEnd = rayStart + GetGame().GetCurrentCameraDirection() * 10000;
	    vector hitPos;
	    vector hitNormal;
	    int hitComponentIndex;
	    DayZPhysics.RaycastRV(rayStart, rayEnd, hitPos, hitNormal, hitComponentIndex, NULL, NULL, GetPlayer());
	    return hitPos;
	}

	set< Object > GetObjectsAt( vector from, vector to, Object ignore = NULL, float radius = 0.0, Object with = NULL )
	{
	    vector contact_pos;
	    vector contact_dir;
	    int contact_component;

	    set< Object > geom = new set< Object >;
	    set< Object > view = new set< Object >;

	    DayZPhysics.RaycastRV( from, to, contact_pos, contact_dir, contact_component, geom, with, ignore, false, false, ObjIntersectGeom, radius );
	    DayZPhysics.RaycastRV( from, to, contact_pos, contact_dir, contact_component, view, with, ignore, false, false, ObjIntersectView, radius );

	    for ( int i = 0; i < geom.Count(); i++ )
	        view.Insert( geom[i] );

	    if ( view.Count() > 0 ) 
	        return view;
		
	    return NULL;
	}

	Object getObjectAtCrosshair(float distance = 1000.0, float radius = 0.0, Object with = NULL)
	{
	    vector rayStart = GetGame().GetCurrentCameraPosition();
	    vector rayEnd = rayStart + GetGame().GetCurrentCameraDirection() * distance;
	    auto objs = GetObjectsAt( rayStart, rayEnd, GetGame().GetPlayer(), radius, with );

	    if( objs != null && objs.Count() > 0 )
	        return objs[ 0 ];

	    return NULL;
	}
};

VPPEventHandler VPPATGetEventHandler()
{
	return g_Game.VPPATGetEventHandler();
};

ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\PluginAdminLog.c
----------------------------------------------------------------------
modded class PluginAdminLog
{
	/*override void LogPrint( string message )
	{
		super.LogPrint( message );
	}*/

	string VPPGetPlayerPrefix( vector pos, PlayerBase identity )
	{
		string PosArray[3] = { pos[0].ToString(), pos[2].ToString(), pos[1].ToString() };
		
		for ( int i = 0; i < 3; i++ )
		{
			m_DotIndex = PosArray[i].IndexOf(".");
			if ( m_DotIndex != -1 )
			{
				PosArray[i] = PosArray[i].Substring( 0, m_DotIndex + 2 );
			}
		}
		
		if ( !identity )
		{
			return string.Format("Player (Unknown/Dead Entity)\nID: (Unknown)\nPosition: <%1, %2, %3>\n", PosArray[0], PosArray[2], PosArray[1]);
		}
		
		return string.Format("Player: (%1)\nID: (%2)\nPosition: <%3, %4, %5>\n",  identity.VPlayerGetName(), identity.VPlayerGetSteamId(), PosArray[0], PosArray[2], PosArray[1]);
	}

	string VPPGetHitMessage( TotalDamageResult damageResult, int component, string zone, string ammo) 
	{
		if ( damageResult )	
		{
			float dmg = damageResult.GetHighestDamage("Health");
			return " into Zone: (" + zone + ") Component: (" + component.ToString() + ") Damage Dealt: (" + dmg.ToString() + ") Damage Type: (" + ammo + ") ";
		}
		else
		{
			return " into Block: (" + component.ToString() + ") 0 damage dealt ";
		}
	}

	// "x, y, z" rounded to 0.1, for webhook templates
	protected string VPPWebhookPos(vector pos)
	{
		float posX = Math.Round(pos[0] * 10) / 10;
		float posY = Math.Round(pos[1] * 10) / 10;
		float posZ = Math.Round(pos[2] * 10) / 10;
		return posX.ToString() + ", " + posY.ToString() + ", " + posZ.ToString();
	}

	protected string VPPWebhookRound(float value)
	{
		float rounded = Math.Round(value * 10) / 10;
		return rounded.ToString();
	}

	override void PlayerHitBy( TotalDamageResult damageResult, int damageType, PlayerBase player, EntityAI source, int component, string dmgZone, string ammo ) // PlayerBase.c 
	{
		if ( player && source )		
		{
			string PlayerPrefix = VPPGetPlayerPrefix( player.GetPosition() , player ) + " HP: (" + player.GetHealth().ToString() + ") \n";
			string HitMessage   = VPPGetHitMessage( damageResult, component, dmgZone, ammo );
			HitDamageMessage rpt = new HitDamageMessage();
			int srcId = -1;
			int low, high;
			bool shouldSendLog = true;

			if (player.GetIdentity() == null) return;

			rpt.victimName = player.VPlayerGetName();
			rpt.victimId   = player.VPlayerGetSteamId();
			vector victimPosition = player.GetPosition();
			string victimPos = VPPWebhookPos(victimPosition);
			rpt.SetVar("victim.pos", victimPos);
			rpt.SetVar("zone", dmgZone);
			rpt.SetVar("ammo", ammo);
			float victimHealth = player.GetHealth();
			string victimHealthText = VPPWebhookRound(victimHealth);
			rpt.SetVar("health", victimHealthText);

			switch ( damageType )
			{
				case DT_CLOSE_COMBAT:	// Player melee, animals, infected 
				
					if ( ( source.IsZombie() || source.IsAnimal() ) )  // Infected & Animals
					{
						rpt.sourceName = source.GetType();
						rpt.sourceId   = "_obj";
						rpt.details    = PlayerPrefix + " hit by " + source.GetDisplayName() + HitMessage;
						if (source.IsZombie())
						{
							rpt.SetVar("source.kind", "infected");
						}
						else
						{
							rpt.SetVar("source.kind", "animal");
						}
}			
					else if ( source.IsPlayer() || (source.GetHierarchyRootPlayer() && source.GetHierarchyRootPlayer().IsPlayer()) )		// Fists, includes bayonets and weapon bitch slaps 
					{
						m_Source = PlayerBase.Cast(source.GetHierarchyRootPlayer());
						m_PlayerPrefix2 = VPPGetPlayerPrefix( m_Source.GetPosition() ,  m_Source );
						
						rpt.sourceName = m_Source.VPlayerGetName();
						rpt.sourceId   = m_Source.VPlayerGetSteamId();
						rpt.details    = PlayerPrefix + " hit by " + m_PlayerPrefix2 + HitMessage;
					}
					else if ( source.IsMeleeWeapon() )			// Melee weapons
					{
						m_ItemInHands = source.GetDisplayName();		
						m_Source = PlayerBase.Cast( source.GetHierarchyRootPlayer() );
						m_PlayerPrefix2 = VPPGetPlayerPrefix( m_Source.GetPosition() ,  m_Source );

						rpt.sourceName = m_Source.VPlayerGetName();
						rpt.sourceId   = m_Source.VPlayerGetSteamId();
						rpt.details = PlayerPrefix + " hit by " + m_PlayerPrefix2 + HitMessage + " with " + m_ItemInHands;
						rpt.SetVar("weapon", m_ItemInHands);
}
					else
					{
						//Includes Beartraps and tripwire
						rpt.sourceName = source.GetType();
						rpt.sourceId   = "_obj";

						EnScript.GetClassVar(source, "m_activatorSessionID", -1, srcId);
						GetGame().GetPlayerNetworkIDByIdentityID(srcId, low, high);
						m_Source = PlayerBase.Cast(GetGame().GetObjectByNetworkId(low, high));

						if (m_Source)
							rpt.details = PlayerPrefix + " hit by " + source.GetType() + HitMessage + "\nSetup by " + VPPGetPlayerPrefix(m_Source.GetPosition(), m_Source);
						else
							rpt.details = PlayerPrefix + " hit by " + source.GetType() + HitMessage;
					}
					break;
				
				case DT_FIRE_ARM:	// Player ranged
					if ( source.IsWeapon() )
					{
						m_ItemInHands = source.GetDisplayName();				
						m_Source = PlayerBase.Cast(source.GetHierarchyRootPlayer());
						if (m_Source)
						{
							m_PlayerPrefix2 = VPPGetPlayerPrefix( m_Source.GetPosition() ,  m_Source );
							m_Distance = vector.Distance( player.GetPosition(), m_Source.GetPosition() );

							rpt.sourceName = m_Source.VPlayerGetName();
							rpt.sourceId   = m_Source.VPlayerGetSteamId();
							string hitDistance = VPPWebhookRound(m_Distance);
							rpt.SetVar("distance", hitDistance);
						}

						rpt.SetVar("weapon", m_ItemInHands);

						rpt.details = PlayerPrefix + " hit by " + m_PlayerPrefix2 + HitMessage + " with ("+ m_ItemInHands +") from (" + m_Distance + ") meters ";
					}
					else 
					{
						rpt.sourceName = source.GetType();
						rpt.sourceId   = "_obj";
						rpt.details = PlayerPrefix + " hit by (" + source.GetType() + ") " + HitMessage;		
					}
					break;
				
				case DT_EXPLOSION:	// Explosion
					rpt.sourceName =  ammo;
					rpt.sourceId   = "Explosion";
					
					EnScript.GetClassVar(source, "m_activatorSessionID", -1, srcId);
					GetGame().GetPlayerNetworkIDByIdentityID(srcId, low, high);
					m_Source = PlayerBase.Cast(GetGame().GetObjectByNetworkId(low, high));

					if (m_Source)
						rpt.details = PlayerPrefix + " hit by explosion (" + ammo + ")\n " + "Caused by " + VPPGetPlayerPrefix(m_Source.GetPosition(), m_Source);
					else
						rpt.details = PlayerPrefix + " hit by explosion (" + ammo + ") ";
					break;
						
				case DT_STUN: 		// unused atm
					rpt.details = PlayerPrefix + " stunned by (" + ammo + ") ";
					break;
						
				case DT_CUSTOM:		// Others (Vehicle hit, fall, fireplace, barbed wire ...)
					if ( ammo == "FallDamage" || ammo == "FallDamageShock" || ammo == "FallDamageHealth")
					{
						//FallDamage ignored, it's too spammy
						shouldSendLog = false;
					}
					else if ( source.GetType() == "AreaDamageBase" )  
					{
						EntityAI parent = EntityAI.Cast( source );
						if ( parent )
						{
							rpt.sourceName = parent.GetType();
							rpt.sourceId   = "_obj";
							rpt.details = PlayerPrefix + " hit by (" + parent.GetType() + ") with (" + ammo + ") ";
						}
					}
					else
					{
						rpt.sourceName = source.GetType();
						rpt.sourceId   = "_obj";
						rpt.details = PlayerPrefix + " by (" + source.GetType() + ") with (" + ammo + ") ";
					}
					break;
											
				default:
					rpt.details ="WARNING: PlayerHitBy Unknown damageType: (" + ammo + ")";
					break;
			}
			//Wrap up and send
			if (shouldSendLog)
			{
				GetWebHooksManager().PostData(HitDamageMessage, rpt);
			}
		}
		else
		{
			LogPrint("DEBUG: player/source does not exist");
		}
		super.PlayerHitBy( damageResult, damageType, player, source, component, dmgZone, ammo );
	}

	override void PlayerKilled( PlayerBase player, Object source )  
	{
		if ( player && source )
		{
			string PlayerPrefix = VPPGetPlayerPrefix( player.GetPosition(), player );
			string PlayerPrefix2 = "";
			KillDeathMessage rpt = new KillDeathMessage();
			
			if (player.GetIdentity() == null) return;

			rpt.victimName = player.VPlayerGetName();
			rpt.victimGUID = player.VPlayerGetSteamId();
			vector deadPosition = player.GetPosition();
			string deadPos = VPPWebhookPos(deadPosition);
			rpt.SetVar("victim.pos", deadPos);

			if( player == source )	// deaths not caused by another object (starvation, dehydration)
			{
				m_StatWater  = player.GetStatWater();
				m_StatEnergy = player.GetStatEnergy();
				m_BleedMgr   = player.GetBleedingManagerServer();
				
				if ( m_StatWater && m_StatEnergy && m_BleedMgr )
				{
					rpt.details = PlayerPrefix + " died. Stats => Water: [" + m_StatWater.Get().ToString() + "] Energy: [" + m_StatEnergy.Get().ToString() + "] Bleed sources: [" + m_BleedMgr.GetBleedingSourcesCount().ToString() + "]";
				}
				else if ( m_StatWater && m_StatEnergy && !m_BleedMgr )
				{
					rpt.details = PlayerPrefix + " died. Stats => Water: " + m_StatWater.Get().ToString() + " Energy: " + m_StatEnergy.Get().ToString() + "]";
				}
				else
				{
					rpt.details = PlayerPrefix + " died. Stats => could not fetch";
				}
				rpt.killerName = rpt.victimName;
				rpt.killerGUID = player.VPlayerGetSteamId();
			}
			else if (source.IsInherited(Grenade_Base) || source.IsInherited(LandMineTrap))
			{
				//Grenades + Landmines
				int srcId = -1;
				EnScript.GetClassVar(source, "m_activatorSessionID", -1, srcId);

				int low, high;
				GetGame().GetPlayerNetworkIDByIdentityID(srcId, low, high);
				m_Source = PlayerBase.Cast(GetGame().GetObjectByNetworkId(low, high));
				if (m_Source)
				{
					PlayerPrefix2 = VPPGetPlayerPrefix(m_Source.GetPosition(), m_Source);
					rpt.details = PlayerPrefix + " killed by:\n" + PlayerPrefix2 + " with " + source.GetDisplayName();
					rpt.killerName = m_Source.VPlayerGetName();
					rpt.killerGUID = m_Source.VPlayerGetSteamId();
					vector bomberPosition = m_Source.GetPosition();
					string bomberPos = VPPWebhookPos(bomberPosition);
					rpt.SetVar("killer.pos", bomberPos);
					string explosiveName = source.GetDisplayName();
					rpt.SetVar("weapon", explosiveName);
				}else{
					//Generic no source message fallback
					rpt.details = PlayerPrefix + " killed by: " + source.GetType();
				}
			}
			else if ( source.IsWeapon() || source.IsMeleeWeapon() )  // player
			{
				m_Source = PlayerBase.Cast( EntityAI.Cast( source ).GetHierarchyRootPlayer() );
				string name;
				string guid;

				if(m_Source != null && m_Source.GetIdentity() != null)
				{
					name = m_Source.VPlayerGetName();
					guid = m_Source.VPlayerGetSteamId();
					
					PlayerPrefix2 = VPPGetPlayerPrefix( m_Source.GetPosition() , m_Source );
					vector killerPosition = m_Source.GetPosition();
					string killerPos = VPPWebhookPos(killerPosition);
					rpt.SetVar("killer.pos", killerPos);
					string weaponName = source.GetDisplayName();
					rpt.SetVar("weapon", weaponName);

					if ( source.IsMeleeWeapon() )
					{
						rpt.details = PlayerPrefix + " killed by:\n" + PlayerPrefix2 + " with " + source.GetDisplayName();	
					}
					else
					{
						m_Distance = vector.Distance( player.GetPosition(), m_Source.GetPosition() );
						rpt.details = PlayerPrefix + " killed by:\n" + PlayerPrefix2 + " with [" + source.GetDisplayName() + "] from [" + m_Distance + "] meters ";
						string killDistance = VPPWebhookRound(m_Distance);
						rpt.SetVar("distance", killDistance);
}
					rpt.killerName = name;
					rpt.killerGUID = guid;
				}
				else
				{
					rpt.details = PlayerPrefix + " killed by: " + source.GetType();
				}
			}
			else
			{
				if (source.IsInherited(ZombieBase))
				{
					rpt.killerName = "Infected";
				}
				else if (source.IsInherited(AnimalBase))
				{
					rpt.SetVar("cause", "animal");
					string animalName = source.GetDisplayName();
					rpt.SetVar("killer.name", animalName);
				}
rpt.details = PlayerPrefix + " killed by: " + source.GetType();
			}
			GetWebHooksManager().PostData(KillDeathMessage, rpt);
		}
		super.PlayerKilled( player, source );
	}
};

ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\SteamAPIManager\SteamAPIManager.c
----------------------------------------------------------------------
class SteamAPIManager: ConfigurablePlugin
{
	private string STEAM_API_KEY;
	private float  QUERY_INTERVAL_SEC = 60.0; //seconds
	private string QUERY_PORT;
	private string SERVER_IP;

	[NonSerialized()]
	private ref Timer m_QueryTimer;
	[NonSerialized()]
	private string m_QueryPort;
	[NonSerialized()]
	ref VPPATSteamGameServer m_ServerDataCache;

	void SteamAPIManager()
	{
		JSONPATH = "$profile:VPPAdminTools/ConfigurablePlugins/SteamAPI.json";
	}

	override void OnInit()
	{
		if (!FileExist(JSONPATH))
		{
			GetSimpleLogger().Log("[SteamAPIManager] configuration file missing...creating default.");
			Save();
			return;
		}

		//load settings
		JsonFileLoader<SteamAPIManager>.JsonLoadFile(JSONPATH, this);
		g_Game.VSetServerIP(SERVER_IP);

		//Query port
		if (!QUERY_PORT || QUERY_PORT == string.Empty)
		{
			QUERY_PORT = GetGame().ServerConfigGetInt("steamQueryPort").ToString();
			if (!QUERY_PORT || QUERY_PORT == string.Empty)
			{
				GetSimpleLogger().Log("[SteamAPIManager] ERROR couldn't fetch server query port from configs...");
			}
		}

		//Fetch current server's IP, either from config, launch params or last resort via cURL
		if (SERVER_IP == string.Empty)
		{
			bool foundIp = GetCLIParam("ip", SERVER_IP);
	        if (!foundIp || SERVER_IP == string.Empty)
	        {
	        	//Resort to using cURL to get server's IP
	        	GetSimpleLogger().Log("[SteamAPIManager] WARNING couldn't fetch server IP from configs; using cURL...");
	        	VPPAT_IPIFY cb = new VPPAT_IPIFY();
				GetRestApi().GetRestContext("http://api.ipify.org/").GET(cb, "");
	        }
	        else
	        {
	        	g_Game.VSetServerIP(SERVER_IP);
	        }
		}

		if (STEAM_API_KEY != string.Empty && STEAM_API_KEY.Length() == 32)
		{
			//start timed task to query Steam
			m_QueryTimer = new Timer();
			if (QUERY_INTERVAL_SEC < 30.0)
			{
				GetSimpleLogger().Log("[SteamAPIManager] WARNING QUERY_INTERVAL_SEC is too short, minimum 30 seconds! Interval set to 30 seconds.");
				QUERY_INTERVAL_SEC = 30.0;
			}
			QueryServerData();
			m_QueryTimer.Run(QUERY_INTERVAL_SEC, this, "QueryServerData", NULL, true);
			GetSimpleLogger().Log("[SteamAPIManager] loaded configuration...query timer active! @ interval: " + QUERY_INTERVAL_SEC);
		}
		else
		{
			GetSimpleLogger().Log("[SteamAPIManager] ERROR No steam API key configured, and or key is invalid.");
		}
	}

	override void Save()
	{
		JsonFileLoader<SteamAPIManager>.JsonSaveFile(JSONPATH, this);
	}

	/*
	* Called by the timer setup with the interval of your choice, and or manually if you wish.
	* updates cached data about current server (players, pop, queue etc)
	*/
	void QueryServerData()
	{
		if (!g_Game.VGetServerIP() || g_Game.VGetServerIP() == string.Empty)
		{
			GetSimpleLogger().Log("[SteamAPIManager] ERROR Failed to query Steam for server data, invalid server IP: " + g_Game.VGetServerIP());
			return;
		}

		VPPATSteamAPICB steamCb = new VPPATSteamAPICB();
		string req = string.Format("?key=%1&filter=\\addr\\%2&limit=10", GetSteamAPIKey(), g_Game.VGetServerIP());
		GetRestApi().GetRestContext("https://api.steampowered.com/IGameServersService/GetServerList/v1/").GET(steamCb, req);
	}

	/*
	* Don't call this manually unless you wan't to reload the same data into Cache
	* Called by VPPATSteamAPICB after query was return with data successfully from Steam.
	*/
	void HandleSteamQueryCb()
	{
		VPPATSteamAPIResponse dta;
		JsonFileLoader<ref VPPATSteamAPIResponse>.JsonLoadFile(string.Format("$profile:GameServer_%1.json", g_Game.VGetServerIP()), dta);
		if (dta == NULL)
			return;

		array<ref VPPATSteamGameServer> servers = dta.response.servers;
		foreach(VPPATSteamGameServer server: servers)
		{
			if (server && server.addr == (string.Format("%1:%2", g_Game.VGetServerIP(), QUERY_PORT)))
			{
				m_ServerDataCache = server;
				g_Game.SetServerName(server.name);
				break;
			}
		}
	}

	string GetSteamAPIKey()
	{
		return STEAM_API_KEY;
	}

	string GetTotalPlayerCount()
	{
		array<Man> players = {};
		GetGame().GetWorld().GetPlayerList(players);

		string count  	= players.Count().ToString();
		string maxCount = GetGame().ServerConfigGetInt("maxPlayers").ToString();
		string result   = string.Format("%1/%2", count, maxCount);
		if (m_ServerDataCache && m_ServerDataCache.GetQueuedPlayers() > 0)
		{
			result += string.Format(" (+%1)", m_ServerDataCache.GetQueuedPlayers());
		}
		return result;
	}
};

SteamAPIManager GetSteamAPIManager()
{
	return SteamAPIManager.Cast(GetPluginManager().GetPluginByType(SteamAPIManager));
};

ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c
----------------------------------------------------------------------
/*
	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
	- Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
	  its preset when missing, so server owners can also edit them in a text editor (ReloadTemplates picks changes up).
	- Delivery: VPPWebhookSender (rate limit, retries, stats), pumped here once a second.
	- Old configs (v0: per-category switches + "simplified") are migrated to events + the Discord preset with the same
	  switches, so nothing changes until an admin edits a template.
*/
class WebHooksManager: ConfigurablePlugin
{
	const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
	const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
	const static string TEMPLATE_EXT = ".tpl";

	private ref array<ref WebHook> 		 M_DATA;

	[NonSerialized()]
	protected ref map<string, ref VPPWebhookSender> m_Senders;
	// senders of deleted / replaced webhooks: kept until the engine answered their requests
	[NonSerialized()]
	protected ref array<ref VPPWebhookSender> m_Retired;
	// next server status time (GetGame().GetTime()) per webhook id
	[NonSerialized()]
	protected ref map<string, int> m_StatusDue;
	[NonSerialized()]
	protected bool m_Ticking;
	[NonSerialized()]
	protected int m_IdSerial;
	// a preset template hash changed (WebHooks.json needs saving)
	[NonSerialized()]
	protected bool m_TemplatesDirty;

	void WebHooksManager()
	{
		M_DATA = new array<ref WebHook>;
		m_Senders = new map<string, ref VPPWebhookSender>();
		m_Retired = new array<ref VPPWebhookSender>();
		m_StatusDue = new map<string, int>();

		if (!FileExist(ROOT_DIR))
			MakeDirectory(ROOT_DIR);

		JSONPATH = ROOT_DIR + "/WebHooks.json";

		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "CreateWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ValidateTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ReloadTemplates", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebhookById", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DuplicateWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ResetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebhookStats", this, SingleplayerExecutionType.Server);
	}

	void ~WebHooksManager()
	{
		if (GetGame())
		{
			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).Remove(this.Tick);
		}
	}

	override void OnInit()
	{
		Load();
		if (!GetGame().IsServer())
		{
			return;
		}

		bool migrated = false;
		foreach (WebHook hook : M_DATA)
		{
			if (hook && hook.Migrate(NextSerial()))
			{
				migrated = true;
			}
		}

		if (migrated)
		{
			Save();
			Print("[WebHooksManager] Webhooks migrated to templated events (v" + WebHook.VERSION.ToString() + ")");
		}

		WriteReadme();
		foreach (WebHook loaded : M_DATA)
		{
			if (loaded)
			{
				StartSender(loaded);
			}
		}

		SaveIfTemplatesChanged();

		if (!m_Ticking)
		{
			m_Ticking = true;
			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.Tick, 1000, true);
		}
	}

	override void Load()
	{
		if (FileExist( JSONPATH ))
		{
			JsonFileLoader<WebHooksManager>.JsonLoadFile(JSONPATH, this);
			Print("[WebHooksManager] Loading Saved Webhooks configuration");
		}

		if (!M_DATA)
		{
			M_DATA = new array<ref WebHook>;
		}
	}

	override void Save()
	{
		JsonFileLoader<WebHooksManager>.JsonSaveFile(JSONPATH, this);
	}

	protected int NextSerial()
	{
		m_IdSerial++;
		return m_IdSerial;
	}

	// ---------------------------------------------------------------- events

	/*
		Called from many other instances such as admin logs and vppat plugins
	*/
	void PostData(typename messageType, WebHookMessageBase dataClass)
	{
		if (!dataClass)
		{
			return;
		}

		VPPWebhookEvent webhookEvent = dataClass.ToEvent();
		if (webhookEvent)
		{
			Emit(webhookEvent);
		}
	}

	void PostServerBootup()
	{
		VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
		Emit(bootEvent);
	}

	// Sends an event to every webhook that has it enabled and whose filters let it through.
	void Emit(VPPWebhookEvent webhookEvent)
	{
		if (!webhookEvent || !CanSend() || !M_DATA || M_DATA.Count() == 0)
		{
			return;
		}

		FillCommonVars(webhookEvent);
		foreach (WebHook hook : M_DATA)
		{
			if (!hook || !hook.IsEventEnabled(webhookEvent.Id))
			{
				continue;
			}

			VPPWebhookEventCfg cfg = hook.GetEventCfg(webhookEvent.Id);
			if (!Passes(cfg, webhookEvent))
			{
				continue;
			}

			SendTo(hook, webhookEvent, "", 0);
		}
	}

	// false when the webhook has no sender or no usable template for the event (nothing is sent)
	protected bool SendTo(WebHook hook, VPPWebhookEvent webhookEvent, string testBy, int testReqId)
	{
		VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
		if (!sender)
		{
			return false;
		}

		string body = sender.Render(webhookEvent);
		if (body == "")
		{
			return false;
		}

		sender.Enqueue(webhookEvent.Id, body, testBy, testReqId);
		return true;
	}

	protected bool CanSend()
	{
		return GetGame().IsServer() && GetGame().IsDedicatedServer();
	}

	// server / players / time variables every event has (a producer's own values win)
	protected void FillCommonVars(VPPWebhookEvent webhookEvent)
	{
		map<string, string> common = new map<string, string>();
		common.Set("event", webhookEvent.Id);
		string serverName = g_Game.GetServerName();
		common.Set("server.name", serverName);
		string serverIp = g_Game.VGetServerIP();
		common.Set("server.ip", serverIp);
		int queryPort = GetGame().ServerConfigGetInt("steamQueryPort");
		common.Set("server.port", queryPort.ToString());
		string worldName = "";
		GetGame().GetWorldName(worldName);
		worldName.ToLower();
		common.Set("server.map", worldName);
		string playerCount = "0";
		if (GetSteamAPIManager())
		{
			playerCount = GetSteamAPIManager().GetTotalPlayerCount();
		}

		common.Set("players", playerCount);
		VPPWebhookClock.Fill(common);
		for (int i = 0; i < common.Count(); i++)
		{
			string commonName = common.GetKey(i);
			if (!webhookEvent.Vars.Contains(commonName))
			{
				string commonValue = common.GetElement(i);
				webhookEvent.Set(commonName, commonValue);
			}
		}
	}

	// The per event filters of a webhook.
	protected bool Passes(VPPWebhookEventCfg cfg, VPPWebhookEvent webhookEvent)
	{
		if (!cfg)
		{
			return true;
		}

		string eventId = webhookEvent.Id;
		if (eventId == VPPWebhookDefs.EV_KILL || eventId == VPPWebhookDefs.EV_HIT)
		{
			string kind = webhookEvent.Get("cause");
			if (eventId == VPPWebhookDefs.EV_HIT)
			{
				kind = webhookEvent.Get("source.kind");
			}

			if (cfg.PvPOnly && kind != "player")
			{
				return false;
			}

			if (cfg.SkipAI && (kind == "infected" || kind == "animal"))
			{
				return false;
			}

			if (cfg.MinDistance > 0)
			{
				string distanceText = webhookEvent.Get("distance");
				float distance = distanceText.ToFloat();
				if (distanceText == "" || distance < cfg.MinDistance)
				{
					return false;
				}
			}

			return true;
		}

		if (eventId == VPPWebhookDefs.EV_ADMIN)
		{
			string moduleName = webhookEvent.Get("module");
			moduleName.ToLower();
			if (cfg.ExcludedModules && cfg.ExcludedModules.Find(moduleName) >= 0)
			{
				return false;
			}

			if (cfg.Modules && cfg.Modules.Count() > 0 && cfg.Modules.Find(moduleName) < 0)
			{
				return false;
			}
		}

		return true;
	}

	// ---------------------------------------------------------------- senders, templates

	protected void StartSender(WebHook hook)
	{
		VPPWebhookSender sender = new VPPWebhookSender(hook);
		m_Senders.Set(hook.m_Id, sender);
		LoadTemplates(hook, sender, true);
		int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
		m_StatusDue.Set(hook.m_Id, due);
	}

	// The old sender keeps living until its requests are answered (the engine holds its callbacks).
	protected void RetireSender(string hookId)
	{
		VPPWebhookSender sender = m_Senders.Get(hookId);
		if (sender)
		{
			m_Retired.Insert(sender);
		}

		m_Senders.Remove(hookId);
		m_StatusDue.Remove(hookId);
	}

	string TemplatePath(WebHook hook, string eventId)
	{
		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
	}

	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
	// Returns how many templates have errors (they are logged; such an event sends nothing until fixed).
	protected int LoadTemplates(WebHook hook, VPPWebhookSender sender, bool logIssues)
	{
		EnsureHookDir(hook);
		int broken = 0;
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			string path = TemplatePath(hook, def.Id);
			RefreshPresetTemplate(hook, def.Id, false);
			string text = "";
			VPPXmlText.ReadAll(path, text);
			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
			sender.SetTemplate(def.Id, tpl);
			if (tpl.HasErrors())
			{
				broken++;
				if (logIssues)
				{
					LogIssues(hook, def.Id, tpl);
				}
			}
		}

		return broken;
	}

	protected void LogIssues(WebHook hook, string eventId, VPPWebhookTemplate tpl)
	{
		string hookName = hook.GetName();
		foreach (VPPWebhookIssue issue : tpl.Issues)
		{
			string where = eventId + TEMPLATE_EXT + ":" + issue.Line.ToString() + ":" + issue.Col.ToString();
			Print("[WebHooksManager] \"" + hookName + "\" " + where + " " + issue.Message);
		}
	}

	protected void EnsureHookDir(WebHook hook)
	{
		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

		string hookDir = TEMPLATE_DIR + "/" + hook.m_Id;
		if (!FileExist(hookDir))
		{
			MakeDirectory(hookDir);
		}
	}

	// (Re)writes every template of the webhook from its preset.
	protected void WritePresetTemplates(WebHook hook)
	{
		EnsureHookDir(hook);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			RefreshPresetTemplate(hook, def.Id, true);
		}
	}

	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still
	// exactly the preset text this server wrote earlier (so preset fixes reach untouched files). A file an admin
	// edited, or one written before hashes were tracked that differs from the preset, is left alone.
	protected void RefreshPresetTemplate(WebHook hook, string eventId, bool force)
	{
		string path = TemplatePath(hook, eventId);
		string presetText = VPPWebhookPresets.TemplateFor(hook.m_Preset, eventId);
		int presetHash = VPPXmlText.NormalizedHash(presetText);
		string current = "";
		int currentHash = 0;
		int writtenHash = 0;
		bool known = hook.m_PresetHashes.Contains(eventId);
		if (known)
		{
			writtenHash = hook.m_PresetHashes.Get(eventId);
		}

		if (!force && FileExist(path))
		{
			VPPXmlText.ReadAll(path, current);
			currentHash = VPPXmlText.NormalizedHash(current);
			if (currentHash == presetHash)
			{
				if (!known || writtenHash != presetHash)
				{
					hook.m_PresetHashes.Set(eventId, presetHash);
					m_TemplatesDirty = true;
				}

				return;
			}

			if (!known || writtenHash != currentHash)
			{
				return;
			}

			string hookName = hook.GetName();
			Print("[WebHooksManager] \"" + hookName + "\" " + eventId + TEMPLATE_EXT + " updated to the current preset");
		}

		VPPXmlText.WriteAll(path, presetText);
		hook.m_PresetHashes.Set(eventId, presetHash);
		m_TemplatesDirty = true;
	}

	protected void SaveIfTemplatesChanged()
	{
		if (!m_TemplatesDirty)
		{
			return;
		}

		m_TemplatesDirty = false;
		Save();
	}

	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
	protected void WriteReadme()
	{
		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

		string nl = "\n";
		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
		text = text + "Each webhook has a folder named after its id with one <event>.tpl per event: the request body sent for it." + nl;
		text = text + "Edit them here or in the WebHooks menu; the server reads them at start (or on Reload in the menu)." + nl;
		text = text + "Delete a file to get the webhook's preset template back." + nl + nl;
		text = text + "Syntax:" + nl;
		text = text + "  {{victim.name}}                        a variable (JSON-escaped for JSON webhooks)" + nl;
		text = text + "  {{victim.id|steamurl}}                 filters: upper lower trim truncate:N default:TEXT round:N number steamurl raw json" + nl;
		text = text + "  {{#if killer.id}} ... {{else}} ... {{/if}}   shown when the variable is not empty" + nl;
		text = text + "  {{#unless killer.id}} ... {{/unless}}       shown when it is empty" + nl;
		text = text + "  {{#ifeq cause suicide}} ... {{/ifeq}}       shown when it equals the value" + nl;
		text = text + "  {{! comment }}" + nl;
		text = text + "  {{hook.<name>}}                        a custom variable of the webhook (username, avatar, chat_id, ...)" + nl + nl;
		text = text + "Webhooks:" + nl;
		foreach (WebHook hook : M_DATA)
		{
			if (hook)
			{
				string hookName = hook.GetName();
				text = text + "  " + hook.m_Id + "  " + hookName + "  (" + hook.m_Preset + ")" + nl;
			}
		}

		text = text + nl + "Events and their variables:" + nl;
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			text = text + nl + "  " + def.Id + nl;
			foreach (VPPWebhookVar webhookVar : def.Vars)
			{
				text = text + "    {{" + webhookVar.Name + "}}  e.g. " + webhookVar.Sample + nl;
			}
		}

		string readmePath = TEMPLATE_DIR + "/README.txt";
		VPPXmlText.WriteAll(readmePath, text);
	}

	// ---------------------------------------------------------------- tick

	void Tick()
	{
		int now = GetGame().GetTime();
		foreach (WebHook hook : M_DATA)
		{
			if (!hook)
			{
				continue;
			}

			VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
			if (!sender)
			{
				continue;
			}

			if (hook.IsEventEnabled(VPPWebhookDefs.EV_STATUS) && m_StatusDue.Contains(hook.m_Id) && now >= m_StatusDue.Get(hook.m_Id))
			{
				int nextDue = now + hook.GetServerStatsInterval() * 1000;
				m_StatusDue.Set(hook.m_Id, nextDue);
				PostStatusTo(hook);
			}

			sender.Pump();
		}

		for (int r = m_Retired.Count() - 1; r >= 0; r--)
		{
			VPPWebhookSender retired = m_Retired[r];
			retired.Pump();
			if (retired.PendingRequests() == 0)
			{
				m_Retired.Remove(r);
			}
		}
	}

	protected void PostStatusTo(WebHook hook)
	{
		if (!CanSend())
		{
			return;
		}

		ServerStatusMessage status = new ServerStatusMessage();
		VPPWebhookEvent statusEvent = status.ToEvent();
		FillCommonVars(statusEvent);
		SendTo(hook, statusEvent, "", 0);
	}

	// ---------------------------------------------------------------- menu RPCs (list / create / edit / delete)

	protected bool CanViewUrls(string plainId)
	{
		return GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:ViewURL", "", false);
	}

	protected void SendList(PlayerIdentity sender)
	{
		string plainId = sender.GetPlainId();
		bool showUrl = CanViewUrls(plainId);
		array<ref WebHook> copies = new array<ref WebHook>();
		foreach (WebHook hook : M_DATA)
		{
			if (hook)
			{
				WebHook copy = hook.CopyForClient(showUrl);
				copies.Insert(copy);
			}
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "PopulateList", new Param1<ref array<ref WebHook>>(copies), true, sender);
		int access = AccessMask(plainId);
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnAccess", new Param1<int>(access), true, sender);
	}

	// What the admin may do in the menu (VPPWebhookAccess bits), so it can disable what the server would refuse.
	protected int AccessMask(string plainId)
	{
		int access = 0;
		PermissionManager perms = GetPermissionManager();
		if (perms.VerifyPermission(plainId, "MenuWebHooks:Create", "", false))
		{
			access = access | VPPWebhookAccess.CREATE;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:Edit", "", false))
		{
			access = access | VPPWebhookAccess.EDIT;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:Delete", "", false))
		{
			access = access | VPPWebhookAccess.DELETE;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:EditTemplates", "", false))
		{
			access = access | VPPWebhookAccess.EDIT_TEMPLATES;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:TestSend", "", false))
		{
			access = access | VPPWebhookAccess.TEST_SEND;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:ViewURL", "", false))
		{
			access = access | VPPWebhookAccess.VIEW_URL;
		}

		return access;
	}

	void GetWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if(type == CallType.Server && sender)
		{
			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks", "", false))
				return;

			SendList(sender);
		}
	}

	void DeleteWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if(type == CallType.Server && sender)
		{
			Param2<int,string> data;
			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Delete"))
				return;

			if (!ctx.Read(data))
				return;

			if (data.param1 >= 0 && data.param1 < M_DATA.Count() && M_DATA.Get(data.param1).GetName() == data.param2)
			{
				WebHook removed = M_DATA.Get(data.param1);
				string removedName = removed.GetName();
				GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Deleted WebHook: " + removedName));
				RetireSender(removed.m_Id);
				M_DATA.RemoveOrdered(data.param1);
				Save();
				WriteReadme();
				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"WebHook: "+data.param2 + " was successfully deleted!", NotifyTypes.NOTIFY);
				SendList(sender);
			}
			else
			{
				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"Error deleting webhook: "+data.param2 + "\nobject not found in array!", NotifyTypes.NOTIFY);
			}
		}
	}

	void CreateWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if(type == CallType.Server && sender)
		{
			Param1<ref WebHook> data;

			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Create"))
				return;

			if (!ctx.Read(data))
				return;

			WebHook webHook = data.param1;
			if (!webHook)
				return;

			string createdUrl = webHook.GetURL();
			if (createdUrl == "" || WebHook.IsMasked(createdUrl))
				return;

			// a fresh webhook: the preset follows the menu's "simplified" switch, the events its category switches
			webHook.m_Id = "";
			webHook.m_Version = 0;
			webHook.m_Preset = "";
			webHook.m_ContentType = "";
			webHook.Migrate(NextSerial());
			M_DATA.Insert(webHook);
			WritePresetTemplates(webHook);
			StartSender(webHook);

			string createdName = webHook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Created new WebHook: " + createdName));
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"New WebHook: " + createdName + " successfully created and saved!", NotifyTypes.NOTIFY);
			Save();
			WriteReadme();
			SendList(sender);
		}
	}

	// The current menu edits name, URL, the category switches, the status interval and "simplified": they are merged
	// into the stored webhook, which keeps its id, templates, variables and filters.
	void EditWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if(type == CallType.Server && sender)
		{
			Param3<int,string,ref WebHook> data;

			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Edit"))
				return;

			if (!ctx.Read(data))
				return;

			if (data.param1 < 0 || data.param1 >= M_DATA.Count() || !data.param3)
				return;

			WebHook stored = M_DATA.Get(data.param1);
			if (!stored)
				return;

			WebHook edited = data.param3;
			string storedName = stored.GetName();
			string editedName = edited.GetName();
			if (storedName != data.param2)
			{
				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"Failed to save changes to webhook: " + editedName + "\n\nCould not find old instance, another admin deleted it?", NotifyTypes.NOTIFY);
				return;
			}

			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Edited WebHook: " + storedName));
			stored.SetName(editedName);
			string newUrl = edited.GetURL();
			if (newUrl != "" && !WebHook.IsMasked(newUrl))
				stored.SetURL(newUrl);

			stored.m_deathKillLogs = edited.m_deathKillLogs;
			stored.m_adminActivityLog = edited.m_adminActivityLog;
			stored.m_admHitLog = edited.m_admHitLog;
			stored.m_joinLeaveLog = edited.m_joinLeaveLog;
			stored.m_serverStatusLog = edited.m_serverStatusLog;
			VPPWebHookServerStatsTime editedInterval = edited.GetServerStatsInterval();
			stored.SetServerStatsInterval(editedInterval);
			stored.SyncEventsFromSwitches();
			bool presetChanged = false;
			if (stored.m_simplifiedMessages != edited.m_simplifiedMessages && VPPWebhookPresets.IsDiscord(stored.m_Preset))
			{
				stored.m_Preset = VPPWebhookPresets.DISCORD_EMBED;
				if (edited.m_simplifiedMessages)
					stored.m_Preset = VPPWebhookPresets.DISCORD_SIMPLE;

				presetChanged = true;
			}

			stored.m_simplifiedMessages = edited.m_simplifiedMessages;
			stored.Migrate(NextSerial());
			if (presetChanged)
				WritePresetTemplates(stored);

			RetireSender(stored.m_Id);
			StartSender(stored);
			Save();
			WriteReadme();
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"WebHook: " + editedName + " was successfully edited & saved!", NotifyTypes.NOTIFY);
			SendList(sender);
		}
	}

	// ---------------------------------------------------------------- webhook RPCs of the new menu

	protected void ReplySaved(PlayerIdentity sender, int reqId, bool ok, string hookId, string error)
	{
		VPPWebhookSaveReply reply = new VPPWebhookSaveReply();
		reply.ReqId = reqId;
		reply.Ok = ok;
		reply.HookId = hookId;
		reply.Error = error;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnWebhookSaved", new Param1<ref VPPWebhookSaveReply>(reply), true, sender);
	}

	protected bool NameInUse(string name, string exceptId)
	{
		string lowerName = name;
		lowerName.ToLower();
		foreach (WebHook hook : M_DATA)
		{
			if (!hook || hook.m_Id == exceptId)
			{
				continue;
			}

			string otherName = hook.GetName();
			otherName.ToLower();
			if (otherName == lowerName)
			{
				return true;
			}
		}

		return false;
	}

	// Creates (empty or unknown m_Id) or updates a webhook with everything the menu edits. A changed preset rewrites
	// the webhook's templates from the new preset; the legacy switches are kept in step for older tools.
	void SaveWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param2<int, ref WebHook> data;
		if (!ctx.Read(data))
		{
			return;
		}

		string plainId = sender.GetPlainId();
		WebHook incoming = data.param2;
		int reqId = data.param1;
		if (!incoming)
		{
			return;
		}

		WebHook stored = FindHook(incoming.m_Id);
		bool creating = false;
		if (!stored)
		{
			creating = true;
		}

		string permission = "MenuWebHooks:Edit";
		if (creating)
		{
			permission = "MenuWebHooks:Create";
		}

		if (!GetPermissionManager().VerifyPermission(plainId, permission))
		{
			return;
		}

		string newName = incoming.GetName();
		newName = newName.Trim();
		if (newName.Length() < 3)
		{
			ReplySaved(sender, reqId, false, incoming.m_Id, "NAME_SHORT");
			return;
		}

		string exceptId = "";
		if (stored)
		{
			exceptId = stored.m_Id;
		}

		if (NameInUse(newName, exceptId))
		{
			ReplySaved(sender, reqId, false, incoming.m_Id, "NAME_IN_USE");
			return;
		}

		string newUrl = incoming.GetURL();
		newUrl = newUrl.Trim();
		bool urlGiven = newUrl != "" && !WebHook.IsMasked(newUrl);
		if (creating && !urlGiven)
		{
			ReplySaved(sender, reqId, false, "", "URL_MISSING");
			return;
		}

		string newPreset = incoming.m_Preset;
		if (!VPPWebhookPresets.IsPreset(newPreset))
		{
			newPreset = VPPWebhookPresets.DISCORD_EMBED;
		}

		if (creating)
		{
			stored = new WebHook(newName, newUrl);
			stored.m_Preset = newPreset;
			stored.Migrate(NextSerial());
			M_DATA.Insert(stored);
		}

		bool presetChanged = stored.m_Preset != newPreset;
		stored.SetName(newName);
		if (urlGiven)
		{
			stored.SetURL(newUrl);
		}

		stored.m_Preset = newPreset;
		string contentType = incoming.m_ContentType;
		contentType = contentType.Trim();
		if (contentType == "")
		{
			contentType = VPPWebhookPresets.ContentTypeOf(newPreset);
		}

		stored.m_ContentType = contentType;
		int rateLimit = incoming.m_RateLimit;
		if (rateLimit < 0)
		{
			rateLimit = 0;
		}

		if (rateLimit > 600)
		{
			rateLimit = 600;
		}

		stored.m_RateLimit = rateLimit;
		stored.m_Disabled = incoming.m_Disabled;
		stored.m_HideIds = incoming.m_HideIds;
		stored.m_HideServerAddress = incoming.m_HideServerAddress;
		VPPWebHookServerStatsTime interval = ValidInterval(incoming.m_serverStatsInterval);
		stored.SetServerStatsInterval(interval);
		CopyVars(incoming, stored);
		CopyEvents(incoming, stored);
		stored.SyncSwitchesFromEvents();
		if (creating || presetChanged)
		{
			WritePresetTemplates(stored);
		}

		RetireSender(stored.m_Id);
		StartSender(stored);
		Save();
		SaveIfTemplatesChanged();
		WriteReadme();
		string verb = "Edited";
		if (creating)
		{
			verb = "Created";
		}

		string logText = "[WebHooksManager] " + verb + " WebHook: " + newName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, reqId, true, stored.m_Id, "");
		SendList(sender);
	}

	protected VPPWebHookServerStatsTime ValidInterval(VPPWebHookServerStatsTime interval)
	{
		if (interval == VPPWebHookServerStatsTime.ONE_MINUTE || interval == VPPWebHookServerStatsTime.FIVE_MINUTES)
		{
			return interval;
		}

		if (interval == VPPWebHookServerStatsTime.TEN_MINUTES || interval == VPPWebHookServerStatsTime.FIFTEEN_MINUTES)
		{
			return interval;
		}

		return VPPWebHookServerStatsTime.FIVE_MINUTES;
	}

	// hook.* variables: plain names only (letters, digits, _ and .), at most 32, values up to 500 characters.
	protected void CopyVars(WebHook source, WebHook target)
	{
		target.m_Vars.Clear();
		if (!source.m_Vars)
		{
			return;
		}

		int total = source.m_Vars.Count();
		for (int i = 0; i < total; i++)
		{
			if (target.m_Vars.Count() >= 32)
			{
				break;
			}

			string varName = source.m_Vars.GetKey(i);
			string varValue = source.m_Vars.GetElement(i);
			varName = varName.Trim();
			if (!VPPWebhookVarNames.IsPlain(varName))
			{
				continue;
			}

			if (varValue.Length() > 500)
			{
				varValue = varValue.Substring(0, 500);
			}

			target.m_Vars.Set(varName, varValue);
		}
	}

	// Event settings for the known events (unknown ids are ignored); module names are kept lower case and trimmed.
	protected void CopyEvents(WebHook source, WebHook target)
	{
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			VPPWebhookEventCfg sourceCfg = null;
			if (source.m_Events)
			{
				sourceCfg = source.m_Events.Get(def.Id);
			}

			VPPWebhookEventCfg cfg = target.m_Events.Get(def.Id);
			if (!cfg)
			{
				cfg = new VPPWebhookEventCfg();
				target.m_Events.Set(def.Id, cfg);
			}

			if (!sourceCfg)
			{
				continue;
			}

			cfg.Enabled = sourceCfg.Enabled;
			cfg.PvPOnly = sourceCfg.PvPOnly;
			cfg.SkipAI = sourceCfg.SkipAI;
			cfg.MinDistance = Math.Clamp(sourceCfg.MinDistance, 0, 20000);
			CopyModules(sourceCfg.Modules, cfg.Modules);
			CopyModules(sourceCfg.ExcludedModules, cfg.ExcludedModules);
		}
	}

	protected void CopyModules(array<string> source, array<string> target)
	{
		target.Clear();
		if (!source)
		{
			return;
		}

		foreach (string moduleName : source)
		{
			string cleanName = moduleName.Trim();
			cleanName.ToLower();
			if (cleanName == "" || target.Find(cleanName) >= 0 || target.Count() >= 50)
			{
				continue;
			}

			target.Insert(cleanName);
		}
	}

	void DeleteWebhookById(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param1<string> data;
		if (!ctx.Read(data))
		{
			return;
		}

		string plainId = sender.GetPlainId();
		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:Delete"))
		{
			return;
		}

		int index = -1;
		for (int i = 0; i < M_DATA.Count(); i++)
		{
			if (M_DATA[i] && M_DATA[i].m_Id == data.param1)
			{
				index = i;
				break;
			}
		}

		if (index < 0)
		{
			SendList(sender);
			return;
		}

		WebHook removed = M_DATA[index];
		string removedName = removed.GetName();
		RetireSender(removed.m_Id);
		M_DATA.RemoveOrdered(index);
		Save();
		WriteReadme();
		string logText = "[WebHooksManager] Deleted WebHook: " + removedName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		SendList(sender);
	}

	// A copy with a new id, " (copy)" name and copies of all its template files.
	void DuplicateWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param2<int, string> data;
		if (!ctx.Read(data))
		{
			return;
		}

		string plainId = sender.GetPlainId();
		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:Create"))
		{
			return;
		}

		WebHook source = FindHook(data.param2);
		if (!source)
		{
			ReplySaved(sender, data.param1, false, data.param2, "NOT_FOUND");
			return;
		}

		WebHook copy = source.CopyForClient(true);
		copy.m_Id = WebHook.NewId(NextSerial());
		string baseName = source.GetName() + " (copy)";
		string copyName = baseName;
		int attempt = 2;
		while (NameInUse(copyName, ""))
		{
			copyName = baseName + " " + attempt.ToString();
			attempt++;
		}

		copy.SetName(copyName);
		copy.m_PresetHashes.Copy(source.m_PresetHashes);
		EnsureHookDir(copy);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			string fromPath = TemplatePath(source, def.Id);
			string toPath = TemplatePath(copy, def.Id);
			string text = "";
			bool readOk = false;
			if (FileExist(fromPath))
			{
				readOk = VPPXmlText.ReadAll(fromPath, text);
			}

			if (readOk)
			{
				VPPXmlText.WriteAll(toPath, text);
			}
		}

		M_DATA.Insert(copy);
		StartSender(copy);
		Save();
		SaveIfTemplatesChanged();
		WriteReadme();
		string logText = "[WebHooksManager] Duplicated WebHook: " + copyName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, data.param1, true, copy.m_Id, "");
		SendList(sender);
	}

	// Puts one event template back to the webhook's preset and answers like GetTemplate.
	void ResetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param3<int, string, string> data;
		if (!ctx.Read(data))
		{
			return;
		}

		string plainId = sender.GetPlainId();
		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
		if (!hook || !def)
		{
			return;
		}

		EnsureHookDir(hook);
		RefreshPresetTemplate(hook, def.Id, true);
		string text = "";
		string path = TemplatePath(hook, def.Id);
		VPPXmlText.ReadAll(path, text);
		VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
		if (hookSender)
		{
			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
			hookSender.SetTemplate(def.Id, tpl);
		}

		SaveIfTemplatesChanged();
		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void GetWebhookStats(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks", "", false))
		{
			return;
		}

		array<ref VPPWebhookStatsWire> rows = new array<ref VPPWebhookStatsWire>();
		foreach (WebHook hook : M_DATA)
		{
			if (!hook)
			{
				continue;
			}

			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (!hookSender)
			{
				continue;
			}

			VPPWebhookStatsWire row = new VPPWebhookStatsWire();
			row.HookId = hook.m_Id;
			row.Queued = hookSender.Stats.Queued;
			row.Delivered = hookSender.Stats.Delivered;
			row.NoReply = hookSender.Stats.NoReply;
			row.Failed = hookSender.Stats.Failed;
			row.Dropped = hookSender.Stats.Dropped;
			row.Waiting = hookSender.QueueCount();
			row.ConsecutiveFailures = hookSender.Stats.ConsecutiveFailures;
			row.LastError = hookSender.Stats.LastError;
			row.LastErrorTime = hookSender.Stats.LastErrorTime;
			row.LastSuccessTime = hookSender.Stats.LastSuccessTime;
			rows.Insert(row);
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnStats", new Param1<ref array<ref VPPWebhookStatsWire>>(rows), true, sender);
	}

	// ---------------------------------------------------------------- template RPCs (webhook editor)

	protected WebHook FindHook(string hookId)
	{
		foreach (WebHook hook : M_DATA)
		{
			if (hook && hook.m_Id == hookId)
			{
				return hook;
			}
		}

		return null;
	}

	void GetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param3<int, string, string> data;
		if (!ctx.Read(data))
		{
			return;
		}

		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		if (!hook || !VPPWebhookDefs.Get(data.param3))
		{
			return;
		}

		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = data.param2;
		reply.EventId = data.param3;
		string text = "";
		string path = TemplatePath(hook, data.param3);
		VPPXmlText.ReadAll(path, text);
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, false);
	}

	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, true);
	}

	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param4<int, string, string, string> data;
		if (!ctx.Read(data))
		{
			return;
		}

		string plainId = sender.GetPlainId();
		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
		if (!hook || !def)
		{
			return;
		}

		VPPWebhookCheckReply reply = CheckTemplate(hook, def, data.param4);
		reply.ReqId = data.param1;
		if (save && reply.TemplateOk)
		{
			EnsureHookDir(hook);
			string path = TemplatePath(hook, def.Id);
			VPPXmlText.WriteAll(path, data.param4);
			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (hookSender)
			{
				VPPWebhookTemplate tpl = new VPPWebhookTemplate();
				tpl.Parse(data.param4, def);
				hookSender.SetTemplate(def.Id, tpl);
			}

			reply.Saved = true;
			string hookName = hook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Edited the " + def.Id + " template of WebHook: " + hookName));
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);
	}

	VPPWebhookCheckReply CheckTemplate(WebHook hook, VPPWebhookEventDef def, string text)
	{
		VPPWebhookCheckReply reply = new VPPWebhookCheckReply();
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		VPPWebhookTemplate tpl = new VPPWebhookTemplate();
		tpl.Parse(text, def);
		foreach (VPPWebhookIssue issue : tpl.Issues)
		{
			VPPWebhookIssueWire wire = new VPPWebhookIssueWire();
			wire.IsError = issue.IsError;
			wire.Line = issue.Line;
			wire.Col = issue.Col;
			wire.Code = issue.Code;
			wire.Arg = issue.Arg;
			wire.Message = issue.Message;
			reply.Issues.Insert(wire);
		}

		reply.TemplateOk = !tpl.HasErrors();
		if (!reply.TemplateOk)
		{
			return reply;
		}

		map<string, string> samples = new map<string, string>();
		def.FillSamples(samples);
		for (int i = 0; i < hook.m_Vars.Count(); i++)
		{
			string hookKey = hook.m_Vars.GetKey(i);
			string hookValue = hook.m_Vars.GetElement(i);
			samples.Set("hook." + hookKey, hookValue);
		}

		bool jsonBody = hook.m_ContentType.Contains("json");
		string preview = tpl.Render(samples, jsonBody);
		reply.Preview = preview;
		if (!jsonBody)
		{
			return reply;
		}

		reply.JsonChecked = true;
		VPPJsonCheckResult verdict = VPPJsonCheck.Check(preview);
		reply.JsonValid = verdict.Valid;
		reply.JsonMessage = verdict.Message;
		reply.JsonLine = verdict.Line;
		reply.JsonCol = verdict.Col;
		if (verdict.Valid && VPPWebhookPresets.UsesDiscordLimits(hook.m_Preset))
		{
			VPPDiscordLint.Check(preview, reply.ServiceProblems);
		}

		return reply;
	}

	// Sends the event's sample message now; the answer comes back through OnTestResult.
	void TestSend(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param3<int, string, string> data;
		if (!ctx.Read(data))
		{
			return;
		}

		string plainId = sender.GetPlainId();
		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:TestSend"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
		if (!hook || !def)
		{
			return;
		}

		VPPWebhookEvent sample = new VPPWebhookEvent(def.Id);
		def.FillSamples(sample.Vars);
		FillCommonVars(sample);
		string hookName = hook.GetName();
		if (!SendTo(hook, sample, plainId, data.param1))
		{
			OnTestResult(plainId, data.param1, hook.m_Id, def.Id, false, "TEMPLATE_ERROR");
			return;
		}

		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Test send of " + def.Id + " to WebHook: " + hookName));
	}

	void OnTestResult(string plainId, int reqId, string hookId, string eventId, bool ok, string reason)
	{
		PlayerIdentity admin = FindIdentity(plainId);
		if (!admin)
		{
			return;
		}

		VPPWebhookTestReply reply = new VPPWebhookTestReply();
		reply.ReqId = reqId;
		reply.HookId = hookId;
		reply.EventId = eventId;
		reply.Ok = ok;
		reply.Reason = reason;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTestResult", new Param1<ref VPPWebhookTestReply>(reply), true, admin);
		string verdict = "failed: " + reason;
		if (ok)
		{
			verdict = "delivered (" + reason + ")";
		}

		GetPermissionManager().NotifyPlayer(plainId, "Webhook test " + eventId + " " + verdict, NotifyTypes.NOTIFY);
	}

	protected PlayerIdentity FindIdentity(string plainId)
	{
		array<Man> players = new array<Man>();
		GetGame().GetPlayers(players);
		foreach (Man player : players)
		{
			if (player && player.GetIdentity() && player.GetIdentity().GetPlainId() == plainId)
			{
				return player.GetIdentity();
			}
		}

		return null;
	}

	// Re-reads every template file (edits made on disk) and reports which webhooks have broken templates.
	void ReloadTemplates(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param1<int> data;
		if (!ctx.Read(data))
		{
			return;
		}

		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		VPPWebhookReloadReply reply = new VPPWebhookReloadReply();
		reply.ReqId = data.param1;
		foreach (WebHook hook : M_DATA)
		{
			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (!hookSender)
			{
				continue;
			}

			int broken = LoadTemplates(hook, hookSender, true);
			reply.HookIds.Insert(hook.m_Id);
			reply.TemplateErrors.Insert(broken);
		}

		SaveIfTemplatesChanged();

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplatesReloaded", new Param1<ref VPPWebhookReloadReply>(reply), true, sender);
	}
};

WebHooksManager GetWebHooksManager()
{
	return WebHooksManager.Cast(GetPluginManager().GetPluginByType(WebHooksManager));
};


ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c
----------------------------------------------------------------------
// An event to send: its id and variables (VPPWebhookDefs lists the built-in ones). Other mods can emit their own ids
// with any variables through GetWebHooksManager().Emit(); templates for them are not name-checked.
class VPPWebhookEvent : Managed
{
	string Id;
	ref map<string, string> Vars;

	void VPPWebhookEvent(string eventId)
	{
		Id = eventId;
		Vars = new map<string, string>();
	}

	void Set(string name, string value)
	{
		Vars.Set(name, value);
	}

	string Get(string name)
	{
		string value = "";
		if (Vars.Contains(name))
		{
			value = Vars.Get(name);
		}

		return value;
	}
};

// Delivery numbers of one webhook (since the server started).
class VPPWebhookStats : Managed
{
	int Queued;
	int Delivered;
	// accepted without an answer (a 2xx without body is reported by the engine like a timeout)
	int NoReply;
	int Failed;
	int Dropped;
	int ConsecutiveFailures;
	string LastError;
	string LastErrorTime;
	string LastSuccessTime;
};

// A request in flight or waiting in the queue.
class VPPWebhookJob : Managed
{
	int Id;
	string EventId;
	string Body;
	int Attempts;
	// GetGame().GetTime() before which it is not sent (retry backoff)
	int NotBefore;
	// a test send: who asked (plain id) and their request id
	string TestBy;
	int TestReqId;
};

// One request's answer. Bound to a sender + job while the request runs, unbound on the first answer (a second
// answer for the same request is ignored) and then reused through VPPWebhookCallbackPool.
class VPPWebhookRequestCallback : RestCallback
{
	protected VPPWebhookSender m_Owner;
	protected int m_JobId;

	void Bind(VPPWebhookSender owner, int jobId)
	{
		m_Owner = owner;
		m_JobId = jobId;
	}

	protected void Answer(int state)
	{
		VPPWebhookSender owner = m_Owner;
		int jobId = m_JobId;
		m_Owner = null;
		if (owner)
		{
			owner.OnRequestDone(jobId, state, this);
		}
	}

	override void OnSuccess(string data, int dataSize)
	{
		Answer(VPPWebhookSender.RESULT_SUCCESS);
	}

	override void OnError(int errorCode)
	{
		Answer(errorCode);
	}

	override void OnTimeout()
	{
		Answer(VPPWebhookSender.RESULT_NO_REPLY);
	}
};

// The engine keeps a reference to every RestCallback it is given (proven 2026-09-29: every callback, also the older
// VPPAT_IPIFY one, showed as leaked at shutdown), so one new callback per message would grow without end. Answered
// callbacks go back here and are bound to the next request; the pool never holds more than were in flight at once.
class VPPWebhookCallbackPool
{
	protected static ref array<ref VPPWebhookRequestCallback> s_Free;

	static VPPWebhookRequestCallback Acquire(VPPWebhookSender owner, int jobId)
	{
		VPPWebhookRequestCallback callback = null;
		if (!s_Free)
		{
			s_Free = new array<ref VPPWebhookRequestCallback>();
		}

		int last = s_Free.Count() - 1;
		if (last >= 0)
		{
			callback = s_Free[last];
			s_Free.Remove(last);
		}
		else
		{
			callback = new VPPWebhookRequestCallback();
		}

		callback.Bind(owner, jobId);
		return callback;
	}

	static void Release(VPPWebhookRequestCallback callback)
	{
		if (!callback)
		{
			return;
		}

		if (!s_Free)
		{
			s_Free = new array<ref VPPWebhookRequestCallback>();
		}

		if (s_Free.Find(callback) < 0)
		{
			s_Free.Insert(callback);
		}
	}
};

/*
	Runtime of one webhook (server): its compiled templates, the send queue (rate limited per minute, retried with
	backoff) and the delivery stats. Request callbacks stay referenced until the engine calls them: the engine keeps a
	raw pointer, so they are never freed early.
*/
class VPPWebhookSender : Managed
{
	// Result codes as the engine really reports them (DayZServer 1.30 sub_1408B07C0 / sub_1408C9260). The script
	// ERestResultState names are one step off (its EREST_ERROR is 5, the engine's 4xx code), so they are not used.
	const static int RESULT_SUCCESS = 3;
	// HTTP 4xx (bad body, bad / deleted webhook URL, rate limited)
	const static int RESULT_HTTP_4XX = 5;
	// HTTP 5xx
	const static int RESULT_HTTP_5XX = 6;
	// any other curl failure: connect, DNS, TLS, or a 3xx redirect (redirects are not followed)
	const static int RESULT_NETWORK = 7;
	// curl timeout, or a 2xx without a body (Discord without ?wait=true answers 204)
	const static int RESULT_NO_REPLY = 8;

	const static int MAX_QUEUE = 100;
	const static int MAX_IN_FLIGHT = 50;
	const static int MAX_ATTEMPTS = 4;

	protected WebHook m_Hook;
	protected ref map<string, ref VPPWebhookTemplate> m_Templates;
	protected ref array<ref VPPWebhookJob> m_Queue;
	protected ref map<int, ref VPPWebhookJob> m_InFlight;
	// callbacks of the requests in flight (back to VPPWebhookCallbackPool when answered)
	protected ref map<int, ref VPPWebhookRequestCallback> m_Callbacks;
	protected ref array<int> m_SentTimes;
	protected int m_NextJobId;
	ref VPPWebhookStats Stats;

	void VPPWebhookSender(WebHook hook)
	{
		m_Hook = hook;
		m_Templates = new map<string, ref VPPWebhookTemplate>();
		m_Queue = new array<ref VPPWebhookJob>();
		m_InFlight = new map<int, ref VPPWebhookJob>();
		m_Callbacks = new map<int, ref VPPWebhookRequestCallback>();
		m_SentTimes = new array<int>();
		Stats = new VPPWebhookStats();
	}

	WebHook GetHook()
	{
		return m_Hook;
	}

	void SetTemplate(string eventId, VPPWebhookTemplate tpl)
	{
		m_Templates.Set(eventId, tpl);
	}

	VPPWebhookTemplate GetTemplate(string eventId)
	{
		return m_Templates.Get(eventId);
	}

	bool IsJson()
	{
		return m_Hook.m_ContentType.Contains("json");
	}

	// Render with the webhook's variables added (hook.*) and its redaction applied; "" when there is no usable template.
	string Render(VPPWebhookEvent webhookEvent)
	{
		VPPWebhookTemplate tpl = m_Templates.Get(webhookEvent.Id);
		if (!tpl || tpl.HasErrors())
		{
			return "";
		}

		map<string, string> vars = new map<string, string>();
		vars.Copy(webhookEvent.Vars);
		for (int i = 0; i < m_Hook.m_Vars.Count(); i++)
		{
			string hookKey = m_Hook.m_Vars.GetKey(i);
			string hookValue = m_Hook.m_Vars.GetElement(i);
			vars.Set("hook." + hookKey, hookValue);
		}

		Redact(vars);
		bool jsonBody = IsJson();
		return tpl.Render(vars, jsonBody);
	}

	protected void Redact(map<string, string> vars)
	{
		if (m_Hook.m_HideServerAddress)
		{
			vars.Set("server.ip", "hidden");
			vars.Set("server.port", "hidden");
		}

		if (!m_Hook.m_HideIds)
		{
			return;
		}

		for (int i = 0; i < vars.Count(); i++)
		{
			string varName = vars.GetKey(i);
			if (varName.Length() > 3 && varName.Substring(varName.Length() - 3, 3) == ".id")
			{
				vars.Set(varName, "hidden");
			}
		}
	}

	// ---------------------------------------------------------------- queue

	void Enqueue(string eventId, string body, string testBy, int testReqId)
	{
		if (body == "")
		{
			return;
		}

		if (m_Queue.Count() >= MAX_QUEUE)
		{
			m_Queue.RemoveOrdered(0);
			Stats.Dropped++;
		}

		VPPWebhookJob job = new VPPWebhookJob();
		m_NextJobId++;
		job.Id = m_NextJobId;
		job.EventId = eventId;
		job.Body = body;
		job.TestBy = testBy;
		job.TestReqId = testReqId;
		m_Queue.Insert(job);
		Stats.Queued++;
	}

	// Called every second by the manager: sends what the rate limit and the in-flight cap allow.
	void Pump()
	{
		int now = GetGame().GetTime();
		if (m_Queue.Count() == 0 || !m_Hook)
		{
			return;
		}

		for (int i = m_SentTimes.Count() - 1; i >= 0; i--)
		{
			if (now - m_SentTimes[i] > 60000)
			{
				m_SentTimes.Remove(i);
			}
		}

		int budget = m_Hook.GetRateLimit() - m_SentTimes.Count();
		int index = 0;
		while (budget > 0 && index < m_Queue.Count() && m_InFlight.Count() < MAX_IN_FLIGHT)
		{
			VPPWebhookJob job = m_Queue[index];
			if (job.NotBefore > now)
			{
				index++;
				continue;
			}

			m_Queue.RemoveOrdered(index);
			Send(job);
			m_SentTimes.Insert(now);
			budget--;
		}
	}

	// Messages waiting in the queue (not sent yet).
	int QueueCount()
	{
		return m_Queue.Count();
	}

	// Requests still waiting for the engine (the manager keeps a sender alive until this is 0).
	int PendingRequests()
	{
		return m_InFlight.Count();
	}

	protected void Send(VPPWebhookJob job)
	{
		string url = m_Hook.GetSendUrl();
		if (url == "" || !GetRestApi())
		{
			Finish(job, false, "no URL or no RestApi");
			return;
		}

		job.Attempts++;
		VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
		m_Callbacks.Set(job.Id, callback);
		m_InFlight.Set(job.Id, job);
		RestContext context = GetRestApi().GetRestContext(url);
		context.SetHeader(m_Hook.m_ContentType);
		context.POST(callback, "", job.Body);
	}

	void OnRequestDone(int jobId, int state, VPPWebhookRequestCallback callback)
	{
		VPPWebhookJob job = m_InFlight.Get(jobId);
		m_InFlight.Remove(jobId);
		VPPWebhookCallbackPool.Release(callback);
		m_Callbacks.Remove(jobId);
		// a retired sender (its webhook was deleted / replaced) only waits for its callbacks
		if (!job || !m_Hook)
		{
			return;
		}

		if (state == RESULT_SUCCESS)
		{
			Finish(job, true, "");
			return;
		}

		// a bodyless 2xx and a real timeout look the same; with Discord's ?wait=true a delivered message has a body
		if (state == RESULT_NO_REPLY && !m_Hook.ExpectsReply())
		{
			Stats.NoReply++;
			Stats.ConsecutiveFailures = 0;
			string noReplyTime = TimeText();
			Stats.LastSuccessTime = noReplyTime;
			ReportTest(job, true, "NO_REPLY");
			return;
		}

		string reason = StateName(state);
		// 4xx is usually a bad payload or URL: one retry (covers a 429 rate limit); server / network errors retry more
		int maxAttempts = MAX_ATTEMPTS;
		if (state == RESULT_HTTP_4XX)
		{
			maxAttempts = 2;
		}

		if (job.Attempts < maxAttempts && job.TestBy == "")
		{
			int delay = 10000 * job.Attempts * job.Attempts;
			job.NotBefore = GetGame().GetTime() + delay;
			m_Queue.InsertAt(job, 0);
			return;
		}

		Finish(job, false, reason);
	}

	protected void Finish(VPPWebhookJob job, bool ok, string reason)
	{
		string now = TimeText();
		if (ok)
		{
			Stats.Delivered++;
			Stats.ConsecutiveFailures = 0;
			Stats.LastSuccessTime = now;
			ReportTest(job, true, "DELIVERED");
			return;
		}

		Stats.Failed++;
		Stats.ConsecutiveFailures++;
		Stats.LastError = reason;
		Stats.LastErrorTime = now;
		string hookName = m_Hook.GetName();
		Print("[WebHooksManager] Webhook \"" + hookName + "\" failed to deliver " + job.EventId + ": " + reason);
		if (reason.IndexOf("HTTP_4XX") == 0)
		{
			DiagnoseRejected(job);
		}

		ReportTest(job, false, reason);
	}

	protected void ReportTest(VPPWebhookJob job, bool ok, string reason)
	{
		if (job.TestBy == "")
		{
			return;
		}

		WebHooksManager manager = GetWebHooksManager();
		if (manager)
		{
			manager.OnTestResult(job.TestBy, job.TestReqId, m_Hook.m_Id, job.EventId, ok, reason);
		}
	}

	// A 4xx: the full body goes to Rejected/<webhook id>_<event>.txt (the newest one per event), and the log says
	// whether the game's JSON parser accepts it (with line / column) and which Discord limits it breaks. Valid JSON
	// with no limit problems points at the URL or the service's rate limit instead.
	protected void DiagnoseRejected(VPPWebhookJob job)
	{
		string dir = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Rejected";
		string path = "";
		string verdictText = "";
		string lineText = "";
		string colText = "";
		string problem = "";
		VPPJsonCheckResult verdict = null;
		array<string> problems = new array<string>();
		if (!FileExist(dir))
		{
			MakeDirectory(dir);
		}

		path = dir + "/" + m_Hook.m_Id + "_" + job.EventId + ".txt";
		VPPXmlText.WriteAll(path, job.Body);
		Print("[WebHooksManager] Rejected body saved to " + path);
		if (!IsJson())
		{
			return;
		}

		verdict = VPPJsonCheck.Check(job.Body);
		if (!verdict.Valid)
		{
			lineText = verdict.Line.ToString();
			colText = verdict.Col.ToString();
			verdictText = "[WebHooksManager] The body is NOT valid JSON at line " + lineText + ", column " + colText + ": " + verdict.Message;
			Print(verdictText);
			return;
		}

		bool discordPreset = VPPWebhookPresets.UsesDiscordLimits(m_Hook.m_Preset);
		if (m_Hook.IsDiscordUrl() && !discordPreset)
		{
			string presetName = m_Hook.m_Preset;
			Print("[WebHooksManager] The URL is a Discord webhook but the preset is " + presetName + ": Discord only accepts the discord_embed / discord_simple formats");
			return;
		}

		if (discordPreset)
		{
			VPPDiscordLint.Check(job.Body, problems);
		}

		if (problems.Count() == 0)
		{
			Print("[WebHooksManager] The body is valid JSON within Discord limits: check the URL, or the service is rate limiting");
			return;
		}

		foreach (string lintProblem : problems)
		{
			problem = "[WebHooksManager] Discord limit: " + lintProblem;
			Print(problem);
		}
	}

	static string StateName(int state)
	{
		if (state == RESULT_HTTP_4XX)
		{
			return "HTTP_4XX (bad body, wrong or deleted URL, or rate limited)";
		}

		if (state == RESULT_HTTP_5XX)
		{
			return "HTTP_5XX (the service had an error)";
		}

		if (state == RESULT_NETWORK)
		{
			return "NETWORK_ERROR (connect, DNS, TLS, or a redirecting URL)";
		}

		if (state == RESULT_NO_REPLY)
		{
			return "TIMEOUT (or an empty reply)";
		}

		return "ERROR_" + state.ToString();
	}

	static string TimeText()
	{
		int year;
		int month;
		int day;
		int hour;
		int minute;
		int second;
		GetYearMonthDayUTC(year, month, day);
		GetHourMinuteSecondUTC(hour, minute, second);
		string dateText = VPPWebhookClock.Pad(year, 4) + "-" + VPPWebhookClock.Pad(month, 2) + "-" + VPPWebhookClock.Pad(day, 2);
		return dateText + " " + VPPWebhookClock.Pad(hour, 2) + ":" + VPPWebhookClock.Pad(minute, 2) + ":" + VPPWebhookClock.Pad(second, 2) + " UTC";
	}
};

// UTC time texts for the common template variables.
class VPPWebhookClock
{
	static string Pad(int value, int width)
	{
		string text = value.ToString();
		while (text.Length() < width)
		{
			text = "0" + text;
		}

		return text;
	}

	// Seconds since 1970-01-01 UTC (days-from-civil, no CF dependency).
	static int UnixTime(int year, int month, int day, int hour, int minute, int second)
	{
		int y = year;
		if (month <= 2)
		{
			y = y - 1;
		}

		int era = y / 400;
		if (y < 0)
		{
			era = (y - 399) / 400;
		}

		int yoe = y - era * 400;
		int shiftedMonth = month + 9;
		if (month > 2)
		{
			shiftedMonth = month - 3;
		}

		int doy = (153 * shiftedMonth + 2) / 5 + day - 1;
		int doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
		int days = era * 146097 + doe - 719468;
		return days * 86400 + hour * 3600 + minute * 60 + second;
	}

	static void Fill(map<string, string> vars)
	{
		int year;
		int month;
		int day;
		int hour;
		int minute;
		int second;
		GetYearMonthDayUTC(year, month, day);
		GetHourMinuteSecondUTC(hour, minute, second);
		string dateText = Pad(year, 4) + "-" + Pad(month, 2) + "-" + Pad(day, 2);
		string timeText = Pad(hour, 2) + ":" + Pad(minute, 2) + ":" + Pad(second, 2);
		int unix = UnixTime(year, month, day, hour, minute, second);
		vars.Set("time.date", dateText);
		vars.Set("time.time", timeText);
		vars.Set("time.iso", dateText + "T" + timeText + ".000Z");
		vars.Set("time.unix", unix.ToString());
	}
};


ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\WebHook.c
----------------------------------------------------------------------
enum VPPWebHookServerStatsTime
{
	ONE_MINUTE 		= 60,
	FIVE_MINUTES    = 300,
	TEN_MINUTES     = 600,
	FIFTEEN_MINUTES = 900,
};

// Per event settings of a webhook: on/off and what gets through.
class VPPWebhookEventCfg : Managed
{
	bool Enabled;
	// kill / hit: only player vs player
	bool PvPOnly;
	// kill / hit: skip infected and animals
	bool SkipAI;
	// kill / hit: minimum distance in meters (0 = any)
	float MinDistance;
	// admin.action: only these modules (lower case, empty = all) / never these
	ref array<string> Modules;
	ref array<string> ExcludedModules;

	void VPPWebhookEventCfg()
	{
		Modules = new array<string>();
		ExcludedModules = new array<string>();
	}
};

/*
	One webhook. The legacy fields (the per-category switches and "simplified messages") are kept so old configs load
	and the current menu keeps working: on load a v0 config is migrated to events + a Discord preset with the same
	switches (Migrate). Templates live in files (Templates/<m_Id>/<event>.tpl), runtime state in VPPWebhookSender.
*/
class WebHook : Managed
{
	const static int VERSION = 2;

	private string 			  m_Name;
	private string 			  m_URL;
	bool   					  m_deathKillLogs;
	bool   					  m_adminActivityLog;
	bool   					  m_admHitLog;
	bool   					  m_joinLeaveLog;
	bool   					  m_serverStatusLog;
	VPPWebHookServerStatsTime m_serverStatsInterval;
	bool 					  m_simplifiedMessages;

	// v2
	int m_Version;
	// stable id (template folder name)
	string m_Id;
	bool m_Disabled;
	string m_Preset;
	string m_ContentType;
	// messages per minute (0 = the preset default)
	int m_RateLimit;
	bool m_HideIds;
	bool m_HideServerAddress;
	// "hook.<key>" template variables (Discord username / avatar, Telegram chat_id, role mentions, ...)
	ref map<string, string> m_Vars;
	ref map<string, ref VPPWebhookEventCfg> m_Events;
	// per event: hash of the preset template text the server wrote to disk. A file still matching it is untouched
	// and follows preset updates; a file an admin edited no longer matches and is never overwritten.
	ref map<string, int> m_PresetHashes;

	void WebHook(string name, string url)
	{
		m_Name = name;
		m_URL  = url;
		m_Vars = new map<string, string>();
		m_Events = new map<string, ref VPPWebhookEventCfg>();
		m_PresetHashes = new map<string, int>();
	}

	// ---------------------------------------------------------------- migration

	// v0 (switches only) -> v2: an id, a Discord preset and one event config per event, enabled from the old switches.
	bool Migrate(int serial)
	{
		if (!m_Vars)
		{
			m_Vars = new map<string, string>();
		}

		if (!m_Events)
		{
			m_Events = new map<string, ref VPPWebhookEventCfg>();
		}

		if (!m_PresetHashes)
		{
			m_PresetHashes = new map<string, int>();
		}

		bool changed = false;
		if (m_Id == "")
		{
			m_Id = NewId(serial);
			changed = true;
		}

		if (m_Version < VERSION)
		{
			if (m_Preset == "")
			{
				m_Preset = VPPWebhookPresets.DISCORD_EMBED;
				if (m_simplifiedMessages)
				{
					m_Preset = VPPWebhookPresets.DISCORD_SIMPLE;
				}
			}

			SyncEventsFromSwitches();
			m_Version = VERSION;
			changed = true;
		}

		if (!VPPWebhookPresets.IsPreset(m_Preset))
		{
			m_Preset = VPPWebhookPresets.DISCORD_EMBED;
			changed = true;
		}

		if (m_ContentType == "")
		{
			m_ContentType = VPPWebhookPresets.ContentTypeOf(m_Preset);
			changed = true;
		}

		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			if (!m_Events.Contains(def.Id))
			{
				VPPWebhookEventCfg added = new VPPWebhookEventCfg();
				added.Enabled = SwitchOf(def.LegacyGroup);
				m_Events.Set(def.Id, added);
				changed = true;
			}
		}

		if (m_serverStatsInterval <= 0)
		{
			m_serverStatsInterval = VPPWebHookServerStatsTime.FIVE_MINUTES;
			changed = true;
		}

		return changed;
	}

	static string NewId(int serial)
	{
		int year;
		int month;
		int day;
		int hour;
		int minute;
		int second;
		GetYearMonthDayUTC(year, month, day);
		GetHourMinuteSecondUTC(hour, minute, second);
		int stamp = ((day * 24 + hour) * 60 + minute) * 60 + second;
		int random = Math.RandomInt(1000, 9999);
		return "wh" + stamp.ToString() + serial.ToString() + random.ToString();
	}

	// Makes the webhook safe to read: missing maps and lists are created, and a missing (null) event setting is
	// rebuilt from the legacy switch of its group (the server keeps those in step). Returns how many settings were
	// missing, so a caller can report data that arrived damaged.
	int RepairEvents()
	{
		int repaired = 0;
		if (!m_Vars)
		{
			m_Vars = new map<string, string>();
		}

		if (!m_Events)
		{
			m_Events = new map<string, ref VPPWebhookEventCfg>();
		}

		if (!m_PresetHashes)
		{
			m_PresetHashes = new map<string, int>();
		}

		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			VPPWebhookEventCfg cfg = m_Events.Get(def.Id);
			if (!cfg)
			{
				cfg = new VPPWebhookEventCfg();
				cfg.Enabled = SwitchOf(def.LegacyGroup);
				m_Events.Set(def.Id, cfg);
				repaired++;
				continue;
			}

			if (!cfg.Modules)
			{
				cfg.Modules = new array<string>();
			}

			if (!cfg.ExcludedModules)
			{
				cfg.ExcludedModules = new array<string>();
			}
		}

		return repaired;
	}

	// The old per-category switches decide which events are on (old menu and old configs).
	void SyncEventsFromSwitches()
	{
		if (!m_Events)
		{
			m_Events = new map<string, ref VPPWebhookEventCfg>();
		}

		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			VPPWebhookEventCfg cfg = m_Events.Get(def.Id);
			if (!cfg)
			{
				cfg = new VPPWebhookEventCfg();
				m_Events.Set(def.Id, cfg);
			}

			cfg.Enabled = SwitchOf(def.LegacyGroup);
		}
	}

	// The legacy per-category switches follow the event settings (a group is on when any of its events is).
	void SyncSwitchesFromEvents()
	{
		m_deathKillLogs = IsEventEnabled(VPPWebhookDefs.EV_KILL);
		m_adminActivityLog = IsEventEnabled(VPPWebhookDefs.EV_ADMIN);
		m_admHitLog = IsEventEnabled(VPPWebhookDefs.EV_HIT);
		m_joinLeaveLog = false;
		m_serverStatusLog = false;
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			VPPWebhookEventCfg cfg = m_Events.Get(def.Id);
			if (!cfg || !cfg.Enabled)
			{
				continue;
			}

			if (def.LegacyGroup == VPPWebhookDefs.GROUP_JOINLEAVE)
			{
				m_joinLeaveLog = true;
			}

			if (def.LegacyGroup == VPPWebhookDefs.GROUP_STATUS)
			{
				m_serverStatusLog = true;
			}
		}

		m_simplifiedMessages = m_Preset == VPPWebhookPresets.DISCORD_SIMPLE;
	}

	protected bool SwitchOf(string legacyGroup)
	{
		if (legacyGroup == VPPWebhookDefs.GROUP_DEATH)
		{
			return m_deathKillLogs;
		}

		if (legacyGroup == VPPWebhookDefs.GROUP_ADMIN)
		{
			return m_adminActivityLog;
		}

		if (legacyGroup == VPPWebhookDefs.GROUP_HIT)
		{
			return m_admHitLog;
		}

		if (legacyGroup == VPPWebhookDefs.GROUP_JOINLEAVE)
		{
			return m_joinLeaveLog;
		}

		if (legacyGroup == VPPWebhookDefs.GROUP_STATUS)
		{
			return m_serverStatusLog;
		}

		return false;
	}

	// ---------------------------------------------------------------- client copy

	// What an admin client gets: the URL masked unless showUrl (a webhook URL is a secret), no runtime state.
	WebHook CopyForClient(bool showUrl)
	{
		WebHook copy = new WebHook(m_Name, m_URL);
		if (!showUrl)
		{
			copy.SetURL(MaskUrl(m_URL));
		}

		copy.m_deathKillLogs = m_deathKillLogs;
		copy.m_adminActivityLog = m_adminActivityLog;
		copy.m_admHitLog = m_admHitLog;
		copy.m_joinLeaveLog = m_joinLeaveLog;
		copy.m_serverStatusLog = m_serverStatusLog;
		copy.m_serverStatsInterval = m_serverStatsInterval;
		copy.m_simplifiedMessages = m_simplifiedMessages;
		copy.m_Version = m_Version;
		copy.m_Id = m_Id;
		copy.m_Disabled = m_Disabled;
		copy.m_Preset = m_Preset;
		copy.m_ContentType = m_ContentType;
		copy.m_RateLimit = m_RateLimit;
		copy.m_HideIds = m_HideIds;
		copy.m_HideServerAddress = m_HideServerAddress;
		if (m_Vars)
		{
			copy.m_Vars.Copy(m_Vars);
		}

		RepairEvents();
		int total = m_Events.Count();
		for (int i = 0; i < total; i++)
		{
			string eventId = m_Events.GetKey(i);
			VPPWebhookEventCfg source = m_Events.GetElement(i);
			VPPWebhookEventCfg cloned = new VPPWebhookEventCfg();
			if (source)
			{
				cloned.Enabled = source.Enabled;
				cloned.PvPOnly = source.PvPOnly;
				cloned.SkipAI = source.SkipAI;
				cloned.MinDistance = source.MinDistance;
				if (source.Modules)
				{
					cloned.Modules.Copy(source.Modules);
				}

				if (source.ExcludedModules)
				{
					cloned.ExcludedModules.Copy(source.ExcludedModules);
				}
			}

			copy.m_Events.Set(eventId, cloned);
		}

		return copy;
	}

	// "https://discord.com/api/webhooks/â€¦Ab3F": scheme and host, then â€¦ and the last 4 characters.
	static string MaskUrl(string url)
	{
		if (url == "")
		{
			return "";
		}

		int schemeEnd = url.IndexOf("://");
		int hostEnd = -1;
		if (schemeEnd >= 0)
		{
			hostEnd = url.IndexOfFrom(schemeEnd + 3, "/");
		}

		string head = url;
		if (hostEnd > 0)
		{
			head = url.Substring(0, hostEnd + 1);
		}

		int total = url.Length();
		string tail = "";
		if (total > 4)
		{
			tail = url.Substring(total - 4, 4);
		}

		return head + MASK_MARK + tail;
	}

	const static string MASK_MARK = "â€¦";

	static bool IsMasked(string url)
	{
		return url.Contains(MASK_MARK);
	}

	// ---------------------------------------------------------------- accessors

	void SetURL(string url)
	{
		m_URL = url;
	}

	void SetServerStatsInterval(VPPWebHookServerStatsTime interval)
	{
		m_serverStatsInterval = interval;
	}

	void SetName(string name)
	{
		m_Name = name;
	}

	string GetName()
	{
		return m_Name;
	}

	string GetURL()
	{
		return m_URL;
	}

	bool SendDeathKillLogs()
	{
		return m_deathKillLogs;
	}

	bool SendAdminActivityLogs()
	{
		return m_adminActivityLog;
	}

	bool SendHitLogs()
	{
		return m_admHitLog;
	}

	bool SendJoinLeaveLogs()
	{
		return m_joinLeaveLog;
	}

	bool ReportServerStatus()
	{
		return m_serverStatusLog;
	}

	VPPWebHookServerStatsTime GetServerStatsInterval()
	{
		return m_serverStatsInterval;
	}

	bool SimplifyMessages()
	{
		return m_simplifiedMessages;
	}

	bool IsEventEnabled(string eventId)
	{
		if (m_Disabled || !m_Events)
		{
			return false;
		}

		VPPWebhookEventCfg cfg = m_Events.Get(eventId);
		return cfg && cfg.Enabled;
	}

	VPPWebhookEventCfg GetEventCfg(string eventId)
	{
		if (!m_Events)
		{
			return null;
		}

		return m_Events.Get(eventId);
	}

	// Messages per minute this webhook may send (Discord allows about 30 per webhook).
	int GetRateLimit()
	{
		if (m_RateLimit > 0)
		{
			return m_RateLimit;
		}

		// Discord allows about 30 per minute per webhook, Lolka 30 (then 429)
		if (VPPWebhookPresets.UsesDiscordLimits(m_Preset))
		{
			return 25;
		}

		return 60;
	}

	// The URL requests go to: Discord gets ?wait=true so a delivered message answers with a body (the engine reports a
	// bodyless 204 as a timeout, memory dayz-restapi-json-internals).
	bool IsDiscordUrl()
	{
		string lower = m_URL;
		lower.ToLower();
		return lower.Contains("discord.com/api/webhooks") || lower.Contains("discordapp.com/api/webhooks");
	}

	bool IsLolkaUrl()
	{
		string lower = m_URL;
		lower.ToLower();
		return lower.Contains("lolka.app/api/webhooks");
	}

	string GetSendUrl()
	{
		string url = m_URL;
		string lower = url;
		lower.ToLower();
		// Lolka answers 200 + the message by default too; wait=true makes it explicit
		bool discord = IsDiscordUrl() || IsLolkaUrl();
		if (!discord || lower.Contains("wait="))
		{
			return url;
		}

		if (url.Contains("?"))
		{
			return url + "&wait=true";
		}

		return url + "?wait=true";
	}

	bool ExpectsReply()
	{
		string sendUrl = GetSendUrl();
		return sendUrl.Contains("wait=true");
	}
};


ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\WebHookMessageBase.c
----------------------------------------------------------------------
class WebHookMessageBase
{
	protected ref array<ref WbEmbed> embeds;
	ref JsonSerializer serializer;
	string content;
	// structured values the producer adds for templates (weapon, distance, positions, ...)
	[NonSerialized()]
	ref map<string, string> m_Extra;

	void WebHookMessageBase()
	{
		embeds = new array<ref WbEmbed>;
		serializer = new JsonSerializer;
	}

	void ~WebHookMessageBase()
	{
		if (serializer)
			delete serializer;
	}

	WbEmbed AddEmbed()
	{
		return null;
	}

	void SetContent(string str = string.Empty)
	{
		content = str;
	}

	string GetContent()
	{
		return content;
	}

	// The event this message becomes for templated webhooks (null = this message type has no event).
	VPPWebhookEvent ToEvent()
	{
		return null;
	}

	void SetVar(string name, string value)
	{
		if (!m_Extra)
		{
			m_Extra = new map<string, string>();
		}

		m_Extra.Set(name, value);
	}

	string GetVar(string name)
	{
		string value = "";
		if (m_Extra && m_Extra.Contains(name))
		{
			value = m_Extra.Get(name);
		}

		return value;
	}

	protected void AddExtras(VPPWebhookEvent webhookEvent)
	{
		if (!m_Extra)
		{
			return;
		}

		for (int i = 0; i < m_Extra.Count(); i++)
		{
			string extraName = m_Extra.GetKey(i);
			string extraValue = m_Extra.GetElement(i);
			webhookEvent.Set(extraName, extraValue);
		}
	}

	string BuildMessage(bool simplified = false)
	{
		string result = "";
		serializer.WriteToString(embeds, true, result);
		if (!simplified)
			return "{" + "\"embeds\": " + result + "}";

		return "{ \"content\": \""+ GetContent() + "\", \"embeds\": null, \"username\": \"VPPAdminTools\", \"avatar_url\": \"https://i.imgur.com/oSEhCJV.png\", \"attachments\": [] }";
	}
};

class WbEmbed
{
	string title;
	int color;
	ref WbAuthor author;
	ref array<ref WbField> fields;
	string timestamp;
	
	void WbEmbed(string ltitle = "WebHook Title", int lcolor = 25500, string authorName = "", string authorURL = "", string authorImg = "")
	{
		fields = new array<ref WbField>;
		this.title = ltitle;
		this.color = lcolor;
		author = new WbAuthor();
		author.SetName(authorName);
		author.SetURL(authorURL);
		author.SetIconURL(authorImg);

		int year, month, day, hour, minute, second;
		GetHourMinuteSecondUTC(hour, minute, second);
		GetYearMonthDayUTC(year, month, day);

		string strHour = hour.ToString(), strMin = minute.ToString();
		if (hour.ToString().Length() == 1)
			strHour = string.Format("%2%1", hour, 0);

		if (minute.ToString().Length() == 1)
			strMin = string.Format("%2%1", minute, 0);

		timestamp = string.Format( "%3-%2-%1T%4:%5:00.000Z", day, month, year, strHour, strMin);
	}

	WbField AddField()
	{
		ref WbField field = new WbField();
		fields.Insert( field );
		return field;
	}
};

class WbField
{
	string name  = "field";
	string value = "content";
	bool inline  = false;

	void SetName(string n)
	{
		if (n == "") return;
		name = n;
	}

	void SetValue(string v)
	{
		if (v == "") return;
		value = v;
	}

	void Inline(bool state)
	{
		inline = state;
	}
};

class WbAuthor
{
	string name     = "VPPAdminTools";
	string url      = "https://steamcommunity.com/sharedfiles/filedetails/?id=1828439124";
	string icon_url = "https://i.imgur.com/oSEhCJV.png";
	
	void SetName(string n)
	{
		if (n == "") return;
		name = n;
	}

	void SetURL(string u)
	{
		if (u == "") return;
		url = u;
	}

	void SetIconURL(string iconurl)
	{
		if (iconurl == "") return;
		icon_url = iconurl;
	}
};

ARQUIVO: VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c
----------------------------------------------------------------------
class ServerStatusMessage: WebHookMessageBase
{
	bool m_BoottUp;

	void ServerStatusMessage(bool bootUp = false)
	{
		m_BoottUp = bootUp;
		AddEmbed();
		SetContent();
	}

	int RGB(int r, int g, int b)
	{
		r = r << 16;
		g = g << 8;
		return r | g | b;
	}

	int ConvertTime(int ms, int div, bool floor = true)
	{
		if (floor){
		return Math.Floor((ms / div));
		}
		return (ms / div);
	}

	/*
	* We use this for simplified versions of the webhook messages (without embeds)
	*/
	override void SetContent(string str = string.Empty)
	{
		int queryPort = GetGame().ServerConfigGetInt("steamQueryPort");
		if (m_BoottUp)
		{
			content = string.Format("Server [**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>) successfully started, player connect enabled.", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
		}
		else
		{
			content = string.Format("**Server Status:** [%1](<http://dayzsalauncher.com/#/servercheck/%3:%2>) ", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
			content += string.Format("Up-Time: **%1** ", FormatUpTime());
			content += string.Format("Server FPS: **%1** ", g_Game.GetServerFPS());
			content += string.Format("Players: **%1**", GetSteamAPIManager().GetTotalPlayerCount());
		}
	}

	override VPPWebhookEvent ToEvent()
	{
		if (m_BoottUp)
		{
			return new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
		}

		VPPWebhookEvent webhookEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_STATUS);
		int fps = g_Game.GetServerFPS();
		webhookEvent.Set("server.fps", fps.ToString());
		string upTime = FormatUpTime();
		webhookEvent.Set("uptime", upTime);
		int upSeconds = ConvertTime(GetGame().GetTime(), 1000);
		webhookEvent.Set("uptime.seconds", upSeconds.ToString());
		AddExtras(webhookEvent);
		return webhookEvent;
	}

	string FormatUpTime()
	{
		int secs = ConvertTime(GetGame().GetTime(), 1000);
	   	int days = secs / (24 * 3600);
        	secs = secs % (24 * 3600);

       	int hours = secs / 3600;
        	secs = secs % 3600;

        int minutes = secs / 60;
        	secs = secs % 60;
		
		return string.Format("%1d %2h %3m %4s", days, hours, minutes, secs);
	}

	override WbEmbed AddEmbed()
	{
		WbEmbed embed;
		WbField field;
		int queryPort = GetGame().ServerConfigGetInt("steamQueryPort");

		if ( m_BoottUp )
		{
			embed = new WbEmbed("**SERVER BOOT-UP REPORT**", RGB(0, 255, 0), "", "", "");
			field;
			//---
			field = embed.AddField();
			field.SetName("Server Online!");
			field.SetValue(string.Format("Server [**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>) has **booted-up** successfully!", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP()));
			field.Inline(true);

			embeds.Insert( embed );
			return embed;
		}
		else
		{
			embed = new WbEmbed(string.Format("**SERVER STATUS REPORT:**\n**%1**", g_Game.GetServerName()), 16766720, "", "", "");
			field;
			//---
			field = embed.AddField();
			field.SetName("Server Status:");

	        string final;
	        final 			 += string.Format("[**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>)", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
			final 			 += string.Format("\nUp-Time: %1", FormatUpTime());
			final 			 += string.Format("\nServer FPS: %1", g_Game.GetServerFPS());

			final 			 += string.Format("\nPlayers: %1", GetSteamAPIManager().GetTotalPlayerCount());

			field.SetValue(final);
			field.Inline(false);
			embeds.Insert( embed );
			return embed;
		}
		return NULL;
	}
};

======================================================================
VALIDACAO FINAL
======================================================================
SHA256 inicial: 431398D78FB3EAEE4C3F0849EAE582263BE2A5FC608F90DB6F035F29AFB60887
SHA256 final: 431398D78FB3EAEE4C3F0849EAE582263BE2A5FC608F90DB6F035F29AFB60887
PBO ORIGINAL INALTERADO: True
PASTA DE EXTRACAO: C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted
