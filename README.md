==================================================
1. PREPARACAO DA VARREDURA
==================================================
Diretorio: C:\DayZServer
Python: C:\Program Files\Python311\python.exe

==================================================
2. VARREDURA DOS PBOs
==================================================
PBOs encontrados: 188
Modo: leitura binaria, sem extracao ou alteracao.

================================================================================
PBO: C:\DayZServer\@A_BeautifulCoyote\addons\ABeautiful_Coyote.pbo
Tamanho: 23,699,765 bytes
  TERMO: GetPlayer | ocorrencias: 4
    Offset: 19841349 | Contexto: t()..{...array<Man> players = new array<Man>;...g_Game.GetPlayers(players);...PlayerBase best;...float bestD2 = float.MAX;...vector me = GetPosition();...foreach (
    Offset: 19841867 | Contexto: os)..{...array<Man> players = new array<Man>;...g_Game.GetPlayers(players);...PlayerBase best;...float bestD2 = float.MAX;...foreach (Man m : players)...{....Playe
    Offset: 19842380 | Contexto: e()..{...array<Man> players = new array<Man>;...g_Game.GetPlayers(players);...vector me = GetPosition();...foreach (Man m : players)...{....PlayerBase p = PlayerBa
  TERMO: slot | ocorrencias: 18
    Offset: 24041 | Contexto: h.......proximityAttackRange... @..attackCooldown......SlotCowering.jB...SlotCalmGrazing..B...SlotSiege..F...SlotEating..K...SlotHunting..P...SlotCalmRes
    Offset: 24059 | Contexto: ttackRange... @..attackCooldown......SlotCowering.jB...SlotCalmGrazing..B...SlotSiege..F...SlotEating..K...SlotHunting..P...SlotCalmResting..T...SlotCalm
    Offset: 24080 | Contexto: ckCooldown......SlotCowering.jB...SlotCalmGrazing..B...SlotSiege..F...SlotEating..K...SlotHunting..P...SlotCalmResting..T...SlotCalmTravelling..X...SlotA
================================================================================
PBO: C:\DayZServer\@A_BeautifulKomodoDragon\addons\Beautiful_Komodo.pbo
Tamanho: 2,877,647 bytes
  TERMO: GetIdentity | ocorrencias: 2
    Offset: 2807895 | Contexto: ..{...PlayerBase p = PlayerBase.Cast(e);....if (p && p.GetIdentity())....return "\"" + p.GetIdentity().GetName() + "\"";....return e.GetType();..}...// Why NLZ_IsTarge
    Offset: 2807929 | Contexto: st(e);....if (p && p.GetIdentity())....return "\"" + p.GetIdentity().GetName() + "\"";....return e.GetType();..}...// Why NLZ_IsTarget turned a player down...protected
  TERMO: GetPlayer | ocorrencias: 1
    Offset: 2817087 | Contexto:  NLZ_CollectPlayers(array<Man> players)..{...GetGame().GetPlayers(players);..}...// The infected within INFECTED_SCAN_RADIUS, looked up at most every..// INFECTED_
  TERMO: queue | ocorrencias: 1
    Offset: 2825801 | Contexto: Z_KomodoSickness.Infect(p);...else....GetGame().GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(NLZ_KomodoSickness.Infect, delay, false, p);..}...// A bite
  TERMO: slot | ocorrencias: 1
    Offset: 2815274 | Contexto: ull;....if (!ctrl)....return;....ctrl.OverrideBehaviourSlot(false, 0);...ctrl.OverrideBehaviourAction(false, 0);...ctrl.OverrideTurnSpeed(false, 0);...ct
================================================================================
PBO: C:\DayZServer\@A_BeautifulMotorbikePassenger\addons\BikesSeat2.pbo
Tamanho: 1,136,037 bytes
  TERMO: queue | ocorrencias: 1
    Offset: 1132132 | Contexto: cWeapon();....PlayerBase self = this;....g_Game.GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(self.BSP_ResyncWeapon, 600, false);...}..}.../*...The instan
  TERMO: reserved | ocorrencias: 1
    Offset: 1124139 | Contexto: r, il, true, 10000, action_data))...{....action_data.m_ReservedInventoryLocations.Insert(il);....return true;...}....return false;..}.}.modded class ActionConstr
  TERMO: slot | ocorrencias: 4
    Offset: 1121292 | Contexto: the seat the player looks at, and on..a bike both crew slots share the one "seat_driver" selection, so it can only ever offer the driver seat. This one..
    Offset: 1121438 | Contexto: s one..targets the bike itself and takes the passenger slot when the rider is already on..*/.class ActionGetInBikePassenger: ActionBase.{..void ActionGet
    Offset: 1124436 | Contexto: senger);..}.}..//! never put anyone into the passenger slot from the driver's get in.modded class ActionGetInTransport.{..override bool ActionCondition(P
================================================================================
PBO: C:\DayZServer\@A_BeautifulNasdaraCactusHurts\addons\Nasdara_Cactus.pbo
Tamanho: 5,092 bytes
  TERMO: slot | ocorrencias: 1
    Offset: 4567 | Contexto: )..{...ItemBase gloves = ItemBase.Cast(FindAttachmentBySlotName("Gloves"));...if (gloves && !gloves.IsDamageDestroyed())....return false;....if (!GetBlee
================================================================================
PBO: C:\DayZServer\@BuildingFortifications\Addons\BuildingFortifications.pbo
Tamanho: 161,106,427 bytes
  TERMO: OnConnect | ocorrencias: 2
    Offset: 160953604 | Contexto: icationsConfig();...#endif...}.....override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)...{....super.InvokeOnConnect(player, identity);.....#i
    Offset: 160953677 | Contexto: se player, PlayerIdentity identity)...{....super.InvokeOnConnect(player, identity);.....#ifdef SERVER....//! Request building fortifications server configuration o
  TERMO: GetPlainId | ocorrencias: 1
    Offset: 160812109 | Contexto: CLPermissionManager().UserIsAdmin(player.GetIdentity().GetPlainId())) {..                        lockState = "Admin Lock";..                        return true;..
  TERMO: GetIdentity | ocorrencias: 16
    Offset: 160797562 | Contexto: {.....PlayerBase player;.....string Firsthalf = player.GetIdentity().GetName() + " (GUID: " +  player.GetIdentity().GetId() + ") " + " Destroyed" + action_data.m_Targe
    Offset: 160797609 | Contexto:  player.GetIdentity().GetName() + " (GUID: " +  player.GetIdentity().GetId() + ") " + " Destroyed" + action_data.m_Target.GetObject().GetDisplayName();.....string Seco
    Offset: 160808574 | Contexto:               bool isOwner = codelockRS.IsOwner(player.GetIdentity().GetId());..                bool isGuest = codelockRS.IsGuest(player.GetIdentity().GetId());..
  TERMO: GetPlayer | ocorrencias: 3
    Offset: 160795365 | Contexto: ...{....PlayerBase player = PlayerBase.Cast( GetGame().GetPlayer() );....int DisableDestory = GetBuildingFortificationsConfig().Disable_Raiding_Tool;....if ( playe
    Offset: 160827057 | Contexto: ...{.....PlayerBase player = PlayerBase.Cast(GetGame().GetPlayer());....if(IsPlayerInside(player,"") == true)....{.....if (category_name == "Base" && !HasBase())..
    Offset: 160893896 | Contexto: ...{.....PlayerBase player = PlayerBase.Cast(GetGame().GetPlayer());.....if (player).....{......ConstructionActionData construction_action_data = player.GetConstru
  TERMO: PlayerIdentity | ocorrencias: 8
    Offset: 160792959 | Contexto: ;....modded class DayZGame..{..    override void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)..    {..        super.OnRPC(sender, target,
    Offset: 160809254 | Contexto:     PlayerBase player = action_data.m_Player;..        PlayerIdentity identity = player.GetIdentity();..        BuildingFortficationsCore fence = BuildingFortficationsCore.C
    Offset: 160811375 | Contexto: sCore.Cast(action_data.m_Target.GetObject());..        PlayerIdentity playerId = action_data.m_Player.GetIdentity();....        if (fence) {..            GetCodeLockLogger()
  TERMO: queue | ocorrencias: 25
    Offset: 160834372 | Contexto: e);..........//regenerate navmesh.....GetGame().GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(UpdateNavmesh, GATE_ROTATION_TIME_APPROX, false);........../
    Offset: 160834757 | Contexto: agePos(0,true);........//add check....GetGame().GetCallQueue(CALL_CATEGORY_GAMEPLAY).Remove(CheckFenceClosed);....GetGame().GetCallQueue(CALL_CATEGORY_GAME
    Offset: 160834833 | Contexto: AMEPLAY).Remove(CheckFenceClosed);....GetGame().GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(CheckFenceOpened, 0, true);...}.....override void CloseFence
  TERMO: connection | ocorrencias: 35
    Offset: 67099503 | Contexto: dcontact.canclimb.0.ignorecomponents.1.generateoffmesshconnections.0...............(..;...5....?............7.5.7.55............5......................@.............
    Offset: 67189095 | Contexto: slopelandcontact.canclimb.0.damage.wall.generateoffmeshconnections.0...............(...........?............7.5.7.5.................(I(.*..=.3..r7..*..=.3..(I(.s..@.
    Offset: 67210335 | Contexto: slopelandcontact.canclimb.0.damage.wall.generateoffmeshconnections.0...............(...........?............7.5.7.5.................&`.....<."u.|_.>...<."u.&`... .?.
  TERMO: connect | ocorrencias: 51
    Offset: 67099503 | Contexto: dcontact.canclimb.0.ignorecomponents.1.generateoffmesshconnections.0...............(..;...5....?............7.5.7.55............5......................@.......
    Offset: 67189095 | Contexto: slopelandcontact.canclimb.0.damage.wall.generateoffmeshconnections.0...............(...........?............7.5.7.5.................(I(.*..=.3..r7..*..=.3..(I(
    Offset: 67210335 | Contexto: slopelandcontact.canclimb.0.damage.wall.generateoffmeshconnections.0...............(...........?............7.5.7.5.................&`.....<."u.|_.>...<."u.&`.
  TERMO: slot | ocorrencias: 355
    Offset: 15439 | Contexto: ...scripts\4_World\BuildingFortifications\Recipes\CraftSlottedPlank.c.............%C[g....scripts\4_World\BuildingFortifications\Recipes\CraftWindowBarri
    Offset: 160779499 | Contexto: Name = partName;..    }....    void AddMaterial(string slotName, int quantity)..    {..        BFConstructionMaterial mat = new BFConstructionMaterial(sl
    Offset: 160779595 | Contexto: FConstructionMaterial mat = new BFConstructionMaterial(slotName, quantity);..        Materials.Insert(mat);..    }....    array<ref BFConstructionMateria
================================================================================
PBO: C:\DayZServer\@CF\addons\gui.pbo
Tamanho: 97,235 bytes
  TERMO: priority | ocorrencias: 6
    Offset: 591 | Contexto: {.. size 1 1.. halign center_ref.. valign center_ref.. priority 995.. {..  WrapSpacerWidgetClass Licensing {..   clipchildren 0..   position 0.05 0.062..   size
    Offset: 797 | Contexto: ..   vexactpos 0..   hexactsize 0..   vexactsize 1..   priority 5..   Padding 8..   Margin 0..   "Size To Content H" 1..   "Size To Content V" 1..   content_vali
    Offset: 1151 | Contexto: exactpos 1..     hexactsize 0..     vexactsize 0..     priority 2..     text "#main_menu_version"..     font "gui/fonts/sdf_MetronLight24"..     "exact text" 0..
================================================================================
PBO: C:\DayZServer\@CF\addons\scripts.pbo
Tamanho: 438,303 bytes
  TERMO: OnClientNewEvent | ocorrencias: 5
    Offset: 370443 | Contexto: ne, not exposed in script)... * 4) 14 s MissionServer::OnClientNewEvent... * 5) PlayerBase::OnSelectPlayer... * 6) MissionServer::InvokeOnConnect... * ... * On connect (existing
    Offset: 371280 | Contexto: ne, not exposed in script)... * 3) -- s MissionServer::OnClientNewEvent (time varies based on respawnTime)... * 4) PlayerBase::OnSelectPlayer... * 5) MissionServer::InvokeOnConn
    Offset: 431616 | Contexto: ( player, identity, uid );...}.....override PlayerBase OnClientNewEvent( PlayerIdentity identity, vector pos, ParamsReadContext ctx )...{....CF_Log.Debug("[CF] MissionServer::On
  TERMO: OnClientReadyEvent | ocorrencias: 4
    Offset: 371035 | Contexto: ntity (for each item on player)... * 6) MissionServer::OnClientReadyEvent... * 7) PlayerBase::OnSelectPlayer... * 8) MissionServer::InvokeOnConnect... * ... * On respawn:... * 1) Mi
    Offset: 429061 | Contexto: new CF_EventPlayerArgs(player));...}.....override void OnClientReadyEvent( PlayerIdentity identity, PlayerBase player )...{....CF_Log.Debug("[CF] MissionServer::OnClientReadyEvent -
    Offset: 429167 | Contexto: Base player )...{....CF_Log.Debug("[CF] MissionServer::OnClientReadyEvent - %1 %2 - ID '%3' - player.GetIdentity() = %4", "" + identity, "" + player, identity.GetId(), "" + player.G
  TERMO: OnClientDisconnected | ocorrencias: 4
    Offset: 371451 | Contexto: OnConnect... * ... * On logout:... * 1) MissionServer::OnClientDisconnectedEvent (calls OnClientLogout for CF modules)... * 2) MissionServer::OnEvent LogoutCancelEventTypeID (if player
    Offset: 430141 | Contexto: tPlayerArgs(player, identity));...}......override void OnClientDisconnectedEvent( PlayerIdentity identity, PlayerBase player, int logoutTime, bool authFailed )...{....CF_Log.Debug("[CF]
    Offset: 430287 | Contexto:  authFailed )...{....CF_Log.Debug("[CF] MissionServer::OnClientDisconnectedEvent - %1 %2 - ID '%3' - player.GetIdentity() = %4", "" + identity, "" + player, identity.GetId(), "" + playe
  TERMO: OnEvent | ocorrencias: 5
    Offset: 230381 | Contexto: (sender, target, rpc_type, ctx);...}.....override void OnEvent(EventType eventTypeId, Param params)...{....super.OnEvent(eventTypeId, params);......switch (eve
    Offset: 230439 | Contexto: vent(EventType eventTypeId, Param params)...{....super.OnEvent(eventTypeId, params);......switch (eventTypeId)....{....case MPSessionStartEventTypeID:....{....
    Offset: 371538 | Contexto:  OnClientLogout for CF modules)... * 2) MissionServer::OnEvent LogoutCancelEventTypeID (if player cancels logout countdown, calls OnClientLogoutCancelled for C
  TERMO: OnConnect | ocorrencias: 7
    Offset: 370524 | Contexto: layerBase::OnSelectPlayer... * 6) MissionServer::InvokeOnConnect... * ... * On connect (existing character):... * 1) MissionServer::OnClientPrepareEvent... * 2) EO
    Offset: 371118 | Contexto: layerBase::OnSelectPlayer... * 8) MissionServer::InvokeOnConnect... * ... * On respawn:... * 1) MissionServer::OnClientPrepareEvent... * 2) EOnClientPrepare (engin
    Offset: 371396 | Contexto: layerBase::OnSelectPlayer... * 5) MissionServer::InvokeOnConnect... * ... * On logout:... * 1) MissionServer::OnClientDisconnectedEvent (calls OnClientLogout for C
  TERMO: OnDisconnect | ocorrencias: 5
    Offset: 371851 | Contexto: isconnect for CF modules)... * 2) MissionServer::InvokeOnDisconnect (called by PlayerDisconnected, only if player character not yet deleted)... * 3) PlayerBase::OnStoreS
    Offset: 383661 | Contexto: s args);...../**... * @brief See: MissionServer::InvokeOnDisconnect... */...void OnInvokeDisconnect(Class sender, CF_EventArgs args);...../**... * @brief See: ClientNewE
    Offset: 428800 | Contexto: erArgs(player, identity));...}.....override void InvokeOnDisconnect( PlayerBase player )...{....CF_Log.Debug("[CF] MissionServer::InvokeOnDisconnect %1", "" + player);..
  TERMO: GetPlainId | ocorrencias: 1
    Offset: 298620 | Contexto: der!");......return;.....}.......recievedFrom = sender.GetPlainId();....}........map< string, ref RPCMetaWrapper > functions;....if ( m_RPCActions.Find( modName, fun
  TERMO: GetIdentity | ocorrencias: 17
    Offset: 362861 | Contexto: a queued ID at that point....PlayerIdentity identity = GetIdentity();....if (identity)....{.....string id = identity.GetId();.....if (m_CF_IdentityID != id).....{.....
    Offset: 363589 | Contexto: nected"})).....m_CF_IdentityID = id;...}.....string CF_GetIdentityId(bool fallBackToQueue=true)...{....PlayerIdentity currentIdentity = GetIdentity();....string id;...
    Offset: 363670 | Contexto: kToQueue=true)...{....PlayerIdentity currentIdentity = GetIdentity();....string id;......//! Always prefer current identity when it is available....if (currentIdentity
  TERMO: PlayerIdentity | ocorrencias: 41
    Offset: 181157 | Contexto: e2;...}..};..class CF_EventRPCArgs : CF_EventArgs..{...PlayerIdentity Sender;...Object Target;...int ID;...Serializer Context;..};..class CF_Expression..{...protected string
    Offset: 228994 | Contexto: ate(timeslice);.....}....}...}.....override void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)...{..#ifdef CF_TRACE_ENABLED....auto trace
    Offset: 269510 | Contexto: onLoaded(this, CF_EventArgs.Empty);...}.....void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)...{....auto args = new CF_EventRPCArgs();..
  TERMO: queue | ocorrencias: 2
    Offset: 362808 | Contexto: ty will already be removed) and we don't want to use a queued ID at that point....PlayerIdentity identity = GetIdentity();....if (identity)....{.....string
    Offset: 363618 | Contexto: D = id;...}.....string CF_GetIdentityId(bool fallBackToQueue=true)...{....PlayerIdentity currentIdentity = GetIdentity();....string id;......//! Always pre
  TERMO: connection | ocorrencias: 20
    Offset: 96947 | Contexto: nager.s_MPConnectAbort.Add(this);...}.....void EnableMPConnectionLost()...{....CF_ModuleCoreManager.s_MPConnectionLost.Add(this);...}.....void EnableRespawn()...{...
    Offset: 96996 | Contexto: ableMPConnectionLost()...{....CF_ModuleCoreManager.s_MPConnectionLost.Add(this);...}.....void EnableRespawn()...{....CF_ModuleCoreManager.s_Respawn.Add(this);...}...
    Offset: 98506 | Contexto: sender, CF_EventArgs args);...../**... * @brief See: MPConnectionLostEventTypeID... */...void OnMPConnectionLost(Class sender, CF_EventArgs args);...../**... * @brie
  TERMO: connect | ocorrencias: 155
    Offset: 96855 | Contexto: Manager.s_MPSessionEnd.Add(this);...}.....void EnableMPConnectAbort()...{....CF_ModuleCoreManager.s_MPConnectAbort.Add(this);...}.....void EnableMPConnectionLo
    Offset: 96902 | Contexto: EnableMPConnectAbort()...{....CF_ModuleCoreManager.s_MPConnectAbort.Add(this);...}.....void EnableMPConnectionLost()...{....CF_ModuleCoreManager.s_MPConnection
    Offset: 96947 | Contexto: nager.s_MPConnectAbort.Add(this);...}.....void EnableMPConnectionLost()...{....CF_ModuleCoreManager.s_MPConnectionLost.Add(this);...}.....void EnableRespawn().
  TERMO: login | ocorrencias: 37
    Offset: 5038 | Contexto: .....Jb"...3_Game\CommunityFramework\EventArgs\CF_EventLoginArgs.c...............Jb....3_Game\CommunityFramework\EventArgs\CF_EventRPCArgs.c.....w.........
    Offset: 97119 | Contexto: uleCoreManager.s_Respawn.Add(this);...}.....void EnableLoginTime()...{....CF_ModuleCoreManager.s_LoginTime.Add(this);...}.....void EnableLoginStatus()...{.
    Offset: 97161 | Contexto: ..void EnableLoginTime()...{....CF_ModuleCoreManager.s_LoginTime.Add(this);...}.....void EnableLoginStatus()...{....CF_ModuleCoreManager.s_LoginStatus.Add(
  TERMO: slot | ocorrencias: 4
    Offset: 417459 | Contexto: )....{.....location.SetAttachment(this, NULL, InventorySlots.MAGAZINE);.....success = Class.CastTo(magazine, SpawnEntity(magazineType, location, ECE_IN_I
    Offset: 419286 | Contexto: ..}......// Magazine has to attach into the attachment slot....if (isMagazine)....{.....InventoryLocation srcLocation();.....magazine.GetInventory().GetC
    Offset: 419516 | Contexto: ....dstLocation.SetAttachment(this, magazine, InventorySlots.MAGAZINE);.......// If false, then the magazine is already properly attached to the desired
  TERMO: servermod | ocorrencias: 1
    Offset: 437614 | Contexto: "", {"ResourceManager", "ScriptEditor"})]..class LaunchServerModTool: DayZProjectManager..{...override void Run()...{....RunDayZBat(string.Format("P:\\%1\\Workbenc
================================================================================
PBO: C:\DayZServer\@CodeLock\Addons\CodeLock.pbo
Tamanho: 10,312,938 bytes
  TERMO: queue | ocorrencias: 1
    Offset: 10290496 | Contexto: , null,.6"._.].W..._.t.c. shi.{.l...`...StS`3/](.`C.allQueue.(CALL_CA.TEGORY_G.AMEPLAY)u.".L.`r(H.`...Ur..*.[.[.[.[..ShowAttacch.._.fp e~..........q.......
  TERMO: reserved | ocorrencias: 12
    Offset: 10119071 | Contexto: .t. ... .D.a.t.t.o.,. .I.n.c... .A.l.l. .r.i.g.h.t.s. .r.e.s.e.r.v.e.d....Copyright . Datto, Inc. All rights reserved...D.-.D.I.N..D-DIN..R.e.g.u.l.a.r..Regular.
    Offset: 10119125 | Contexto: .r.e.s.e.r.v.e.d....Copyright . Datto, Inc. All rights reserved...D.-.D.I.N..D-DIN..R.e.g.u.l.a.r..Regular..D.-.D.I.N. .B.u.i.l.d. .1.0.0..D-DIN Build 100..D.-.D
    Offset: 10119654 | Contexto: .c... .(.f.o.n.t.s.@.d.a.t.t.o...c.o.m.).,...w.i.t.h. .R.e.s.e.r.v.e.d. .F.o.n.t. .N.a.m.e. .D.-.D.I.N.......T.h.i.s. .F.o.n.t. .S.o.f.t.w.a.r.e. .i.s. .l.i.c.e.
  TERMO: connection | ocorrencias: 1
    Offset: 10275671 | Contexto: ONTRACT, TORT OR OTHERWISE, ARISING FROM,.OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE.SOFTWARE..# CodeLock.CodeLock modification av
  TERMO: connect | ocorrencias: 1
    Offset: 10275671 | Contexto: ONTRACT, TORT OR OTHERWISE, ARISING FROM,.OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE.SOFTWARE..# CodeLock.CodeLock modificat
  TERMO: slot | ocorrencias: 3
    Offset: 10288263 | Contexto: -]5.._0@..#.P"..Clear.Inv.0oryR.eserva.AE.xw.././."nt ?slotID.0W..S..s.!..IdF.romS.2(CL..".cl}Cm.@.+.fA..er.Pre.di.@veTak.eEntityT.o$CM...`2,..M.ai}B,..C
    Offset: 10292363 | Contexto: per.l.1.-......Receive.Attachme.nt(Entit.yAI a.., .int slot3Id..'..T.....==........!H.asFullyC.onstruct.edGat*.||. (GetDay;ZG..()....../.figP.&& a!&.&...
    Offset: 10294077 | Contexto: g90y9.,9.9..!...To.1s@*.6;/.......d?d?d1<.a7.aP., int ?slotIds>UK.5.)=.=.Y?;.;.;..;.0.k<.......MhU..Q.E.VuSAc.QT.eAt t...ZOb'jec....=).L!. .8Jarray<N.#>
================================================================================
PBO: C:\DayZServer\@CookZ\addons\CookZ.pbo
Tamanho: 65,861,838 bytes
  TERMO: OnConnect | ocorrencias: 2
    Offset: 65526902 | Contexto: onfig(cookz_config);..    }....    override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity
    Offset: 65526984 | Contexto: , PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity);..        auto configParams = new Param1<CookZ_Config>(GetDayZGame().GetCookZ_Co
  TERMO: GetPlayer | ocorrencias: 2
    Offset: 65535593 | Contexto: ffectSound = SEffectManager.PlaySound(sound, GetGame().GetPlayer().GetPosition());..        effectSound.SetSoundAutodestroy(true);..    }..}..// all here is meant
    Offset: 65540764 | Contexto: ..        PlayerBase pBase = PlayerBase.Cast(GetGame().GetPlayer());..        if (pBase && pBase.IsReadingCookbook())..        {..            pBase.ToggleCookbookR
  TERMO: PlayerIdentity | ocorrencias: 2
    Offset: 65490616 | Contexto: n isReadingCookbook;..    }....    override void OnRPC(PlayerIdentity sender, int rpc_type, ParamsReadContext ctx)..    {..        super.OnRPC(sender, rpc_type, ctx);....
    Offset: 65526931 | Contexto: ..    override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity);..        auto configParams = new Par
  TERMO: priority | ocorrencias: 1
    Offset: 65335441 | Contexto:  hexactpos 0. vexactpos 0. hexactsize 0. vexactsize 0. priority 50. {.  WindowWidgetClass WindowWidget {.   color 1 0.7843 1 1.   position 0 0.   size 1 1.   hal
  TERMO: connect | ocorrencias: 2
    Offset: 65526904 | Contexto: fig(cookz_config);..    }....    override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identi
    Offset: 65526986 | Contexto: PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity);..        auto configParams = new Param1<CookZ_Config>(GetDayZGame().GetCookZ_
  TERMO: slot | ocorrencias: 28
    Offset: 11492 | Contexto: .....raP........L......CfgPatches.R....CfgMods......CfgSlots......CfgVehicles.....L......CookZ.c..........requiredAddons...DZ_Data..DZ_Gear_Medical..DZ_G
    Offset: 12096 | Contexto: et..CookZ\GUI\ImageSets\empty_can_icon.imageset........Slot_CookZ_EmptyCans......Slot_CookZ_EmptyBoxes.@...........name.CookZ_EmptyCans...displayName.$ST
    Offset: 12122 | Contexto: pty_can_icon.imageset........Slot_CookZ_EmptyCans......Slot_CookZ_EmptyBoxes.@...........name.CookZ_EmptyCans...displayName.$STR_CookZ_Slot_EmptyCans...g
================================================================================
PBO: C:\DayZServer\@Coyote\addons\ABeautiful_Coyote.pbo
Tamanho: 23,699,765 bytes
  TERMO: GetPlayer | ocorrencias: 4
    Offset: 19841349 | Contexto: t()..{...array<Man> players = new array<Man>;...g_Game.GetPlayers(players);...PlayerBase best;...float bestD2 = float.MAX;...vector me = GetPosition();...foreach (
    Offset: 19841867 | Contexto: os)..{...array<Man> players = new array<Man>;...g_Game.GetPlayers(players);...PlayerBase best;...float bestD2 = float.MAX;...foreach (Man m : players)...{....Playe
    Offset: 19842380 | Contexto: e()..{...array<Man> players = new array<Man>;...g_Game.GetPlayers(players);...vector me = GetPosition();...foreach (Man m : players)...{....PlayerBase p = PlayerBa
  TERMO: slot | ocorrencias: 18
    Offset: 24041 | Contexto: h.......proximityAttackRange... @..attackCooldown......SlotCowering.jB...SlotCalmGrazing..B...SlotSiege..F...SlotEating..K...SlotHunting..P...SlotCalmRes
    Offset: 24059 | Contexto: ttackRange... @..attackCooldown......SlotCowering.jB...SlotCalmGrazing..B...SlotSiege..F...SlotEating..K...SlotHunting..P...SlotCalmResting..T...SlotCalm
    Offset: 24080 | Contexto: ckCooldown......SlotCowering.jB...SlotCalmGrazing..B...SlotSiege..F...SlotEating..K...SlotHunting..P...SlotCalmResting..T...SlotCalmTravelling..X...SlotA
================================================================================
PBO: C:\DayZServer\@DabsFramework\addons\GUI.pbo
Tamanho: 33,431,015 bytes
  TERMO: priority | ocorrencias: 14
    Offset: 33237770 | Contexto: actpos 1.. vexactpos 1.. hexactsize 0.. vexactsize 0.. priority 998.. scriptclass "".. style Outline_1px_BlackBackground.. "Ignore invisible" 0.. Padding 5.. Mar
    Offset: 33240262 | Contexto:          hexactsize 0..         vexactsize 0..         priority 5..         scriptclass "ViewBinding"..         style Default..         "no focus" 1..         te
    Offset: 33240814 | Contexto: s 0..   hexactsize 0..   vexactsize 1..   scaled 1..   priority 3..   scriptclass "ViewBinding"..   style Empty..   Padding 5..   Margin 0..   content_halign cen
  TERMO: connect | ocorrencias: 2
    Offset: 1210356 | Contexto: 92.....Size 64 64.....Flags 0....}....ImageSetDefClass connectdevelop {.....Name "connectdevelop".....Pos 640 192.....Size 64 64.....Flags 0....}....ImageSetDe
    Offset: 1210383 | Contexto:  0....}....ImageSetDefClass connectdevelop {.....Name "connectdevelop".....Pos 640 192.....Size 64 64.....Flags 0....}....ImageSetDefClass contao {.....Name "c
  TERMO: slot | ocorrencias: 32
    Offset: 9363891 | Contexto: ze 64 64.....Flags 0....}....ImageSetDefClass check_to_slot {.....Name "check_to_slot".....Pos 3200 640.....Size 64 64.....Flags 0....}....ImageSetDefCla
    Offset: 9363917 | Contexto: ...ImageSetDefClass check_to_slot {.....Name "check_to_slot".....Pos 3200 640.....Size 64 64.....Flags 0....}....ImageSetDefClass check {.....Name "check
    Offset: 9372363 | Contexto: .....Flags 0....}....ImageSetDefClass circle_dollar_to_slot {.....Name "circle_dollar_to_slot".....Pos 896 768.....Size 64 64.....Flags 0....}....ImageSe
================================================================================
PBO: C:\DayZServer\@DabsFramework\addons\Scripts.pbo
Tamanho: 781,331 bytes
  TERMO: OnClientDisconnected | ocorrencias: 2
    Offset: 699136 | Contexto: Destroyed(identity, uid);....}...}.......override void OnClientDisconnectedEvent(PlayerIdentity identity, PlayerBase player, int logoutTime, bool authFailed)...{....super.OnClientDiscon
    Offset: 699252 | Contexto:  player, int logoutTime, bool authFailed)...{....super.OnClientDisconnectedEvent(identity, player, logoutTime, authFailed);........if (m_JoinedPlayers.Find(identity.GetId()) != -1) {...
  TERMO: OnEvent | ocorrencias: 12
    Offset: 312136 | Contexto:  the init of event manager for clients...override void OnEvent(EventType eventTypeId, Param params)...{..#ifdef DIAG_DEVELOPER....if (m_EventLogging) {.......s
    Offset: 312695 | Contexto: r.UnsuppressAll();......break;.....}....}........super.OnEvent(eventTypeId, params);...}........DayZPlayer GetPlayerByIdentity(PlayerIdentity identity)...{....
    Offset: 318678 | Contexto: peID: return "SetPausedEventTypeID";.....case TerminationEventTypeID: return "TerminationEventTypeID";.....case UserSettingsChangedEventTypeID: return "UserSet
  TERMO: OnConnect | ocorrencias: 2
    Offset: 698279 | Contexto: ..// load client info first hand...override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)...{....super.InvokeOnConnect(player, identity);....if
    Offset: 698352 | Contexto: se player, PlayerIdentity identity)...{....super.InvokeOnConnect(player, identity);....if (m_JoinedPlayers.Find(identity.GetId()) == -1) {.....OnPlayerJoined(playe
  TERMO: GetPlainId | ocorrencias: 2
    Offset: 340850 | Contexto:  }........return null;...}......// use PlayerIdentity::GetPlainId()...static PlayerIdentity FindByPlainId(string plain_id)...{....array<PlayerIdentity> player_identi
    Offset: 341133 | Contexto:  i++)..        {..            if (player_identities[i].GetPlainId() == plain_id)..            {..                return player_identities[i];..            }..
  TERMO: GetIdentity | ocorrencias: 1
    Offset: 482117 | Contexto: inue;......}............event_base.SyncToClient(player.GetIdentity());.....}....}...}.........bool IsEventActive(typename event_type)...{....return (m_ActiveEvents[eve
  TERMO: GetPlayer | ocorrencias: 7
    Offset: 312747 | Contexto: er.OnEvent(eventTypeId, params);...}........DayZPlayer GetPlayerByIdentity(PlayerIdentity identity)...{......int high, low;....if (!IsMultiplayer()) {.....return G
    Offset: 312854 | Contexto: ..int high, low;....if (!IsMultiplayer()) {.....return GetPlayer();....}........if (!identity) {.....return null;....}........GetPlayerNetworkIDByIdentityID(identi
    Offset: 312925 | Contexto: }........if (!identity) {.....return null;....}........GetPlayerNetworkIDByIdentityID(identity.GetPlayerId(), low, high);....return DayZPlayer.Cast(GetObjectByNetw
  TERMO: SteamID | ocorrencias: 3
    Offset: 329494 | Contexto: ..    }......// todo base64 encoding so we can convert Steamid64 to DayZ ID..}class EnScriptVar<Class T>..{....static T Get(Class instance, string variable_nam
    Offset: 413838 | Contexto: t Version = 8;...string MapName;...string AuthorId; // Steamid64 of original author...ref array<string> CreditIds = {}; // SteamId64 of all users that have edi
    Offset: 413906 | Contexto: original author...ref array<string> CreditIds = {}; // SteamId64 of all users that have edited / saved this build...DateTime LastModified;...DateTime CreationD
  TERMO: PlayerIdentity | ocorrencias: 28
    Offset: 3589 | Contexto: Plane.c.....#..........j#...3_Game\DabsFramework\!Core\PlayerIdentity.c................j....3_Game\DabsFramework\!Core\PositionWithRadius2D.c.....+..........j+...3_Game\Dabs
    Offset: 311802 | Contexto: ..}...}....#ifdef DIAG_DEVELOPER...override void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)...{....super.OnRPC(sender, target, rpc_type
    Offset: 312767 | Contexto: Id, params);...}........DayZPlayer GetPlayerByIdentity(PlayerIdentity identity)...{......int high, low;....if (!IsMultiplayer()) {.....return GetPlayer();....}........if (!i
  TERMO: PriorityQueue | ocorrencias: 3
    Offset: 3723 | Contexto: ius2D.c.....+..........j+...3_Game\DabsFramework\!Core\PriorityQueue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFramework\!Cor
    Offset: 344530 | Contexto: DrawSphere(Position, 0.25, color);...}..#endif..}class PriorityQueue<Class TElement, Class TPriority>..{...static const TElement ELEMENT_DEFAULT;...static const TPriority
    Offset: 344956 | Contexto: nvoker Event_OnDequeue = new ScriptInvoker();.....void PriorityQueue(int capacity = 0)...{....m_Capacity = capacity;......if (capacity > 0) {.....// resize the queue array
  TERMO: priority | ocorrencias: 56
    Offset: 3723 | Contexto: ius2D.c.....+..........j+...3_Game\DabsFramework\!Core\PriorityQueue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFram
    Offset: 344530 | Contexto: DrawSphere(Position, 0.25, color);...}..#endif..}class PriorityQueue<Class TElement, Class TPriority>..{...static const TElement ELEMENT_DEFAULT;...static const
    Offset: 344567 | Contexto: }..#endif..}class PriorityQueue<Class TElement, Class TPriority>..{...static const TElement ELEMENT_DEFAULT;...static const TPriority PRIORITY_DEFAULT;.....prote
  TERMO: queue | ocorrencias: 77
    Offset: 3731 | Contexto: ....+..........j+...3_Game\DabsFramework\!Core\PriorityQueue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFramew
    Offset: 3786 | Contexto: Queue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFramework\!Core\Ray.c................j....3_Game\DabsFramewor
    Offset: 315997 | Contexto: turn "NetworkManagerServerEventTypeID";.....case DialogQueuedEventTypeID: return "DialogQueuedEventTypeID";.....case ChatMessageEventTypeID: return "ChatMe
  TERMO: connection | ocorrencias: 8
    Offset: 315611 | Contexto: return "MPSessionPlayerReadyEventTypeID";.....//case MPConnectionLostEventTypeID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return
    Offset: 315648 | Contexto: ID";.....//case MPConnectionLostEventTypeID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return "MPConnectionCloseEventTypeID";.....
    Offset: 315687 | Contexto: peID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return "MPConnectionCloseEventTypeID";.....case ProgressEventTypeID: return "Progr
  TERMO: connect | ocorrencias: 32
    Offset: 67500 | Contexto: CONFLUENCE = "image:confluence";...static const Brands CONNECTDEVELOP = "image:connectdevelop";...static const Brands CONTAO = "image:contao";...static const B
    Offset: 67524 | Contexto: luence";...static const Brands CONNECTDEVELOP = "image:connectdevelop";...static const Brands CONTAO = "image:contao";...static const Brands COTTON_BUREAU = "i
    Offset: 315611 | Contexto: return "MPSessionPlayerReadyEventTypeID";.....//case MPConnectionLostEventTypeID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID:
  TERMO: login | ocorrencias: 7
    Offset: 317075 | Contexto: ventTypeID: return "LogoutCancelEventTypeID";.....case LoginTimeEventTypeID: return "LoginTimeEventTypeID";.....case RespawnEventTypeID: return "RespawnEve
    Offset: 317105 | Contexto: elEventTypeID";.....case LoginTimeEventTypeID: return "LoginTimeEventTypeID";.....case RespawnEventTypeID: return "RespawnEventTypeID";.....case PreloadEve
    Offset: 317309 | Contexto: ogoutEventTypeID: return "LogoutEventTypeID";.....case LoginStatusEventTypeID: return "LoginStatusEventTypeID";.....case SelectedUserChangedEventTypeID: re
  TERMO: slot | ocorrencias: 15
    Offset: 128221 | Contexto:  "image:check_double";...static const Symbols CHECK_TO_SLOT = "image:check_to_slot";...static const Symbols CHECK = "image:check";...static const Symbols
    Offset: 128244 | Contexto: ..static const Symbols CHECK_TO_SLOT = "image:check_to_slot";...static const Symbols CHECK = "image:check";...static const Symbols CHEESE_SWISS = "image:
    Offset: 132465 | Contexto: ircle_divide";...static const Symbols CIRCLE_DOLLAR_TO_SLOT = "image:circle_dollar_to_slot";...static const Symbols CIRCLE_DOLLAR = "image:circle_dollar"
  TERMO: servermod | ocorrencias: 6
    Offset: 754587 | Contexto: ppend prefix of current mod....if (!m_ProjectSettings["ServerMod"].ToInt() && !launch_settings.DisableMod) {........m_ProjectSettings["Mods"] = m_ProjectSettings["
    Offset: 754758 | Contexto:  ";@" + mod_prefix;....} else {.....m_ProjectSettings["ServerMod"] = m_ProjectSettings["ServerMod"];....}........if (launch_settings.LaunchType & 16) {.....m_Proje
    Offset: 754791 | Contexto: ...m_ProjectSettings["ServerMod"] = m_ProjectSettings["ServerMod"];....}........if (launch_settings.LaunchType & 16) {.....m_ProjectSettings["Mods"] = m_ProjectSet
================================================================================
PBO: C:\DayZServer\@KomodoDragon\addons\Beautiful_Komodo.pbo
Tamanho: 2,877,647 bytes
  TERMO: GetIdentity | ocorrencias: 2
    Offset: 2807895 | Contexto: ..{...PlayerBase p = PlayerBase.Cast(e);....if (p && p.GetIdentity())....return "\"" + p.GetIdentity().GetName() + "\"";....return e.GetType();..}...// Why NLZ_IsTarge
    Offset: 2807929 | Contexto: st(e);....if (p && p.GetIdentity())....return "\"" + p.GetIdentity().GetName() + "\"";....return e.GetType();..}...// Why NLZ_IsTarget turned a player down...protected
  TERMO: GetPlayer | ocorrencias: 1
    Offset: 2817087 | Contexto:  NLZ_CollectPlayers(array<Man> players)..{...GetGame().GetPlayers(players);..}...// The infected within INFECTED_SCAN_RADIUS, looked up at most every..// INFECTED_
  TERMO: queue | ocorrencias: 1
    Offset: 2825801 | Contexto: Z_KomodoSickness.Infect(p);...else....GetGame().GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(NLZ_KomodoSickness.Infect, delay, false, p);..}...// A bite
  TERMO: slot | ocorrencias: 1
    Offset: 2815274 | Contexto: ull;....if (!ctrl)....return;....ctrl.OverrideBehaviourSlot(false, 0);...ctrl.OverrideBehaviourAction(false, 0);...ctrl.OverrideTurnSpeed(false, 0);...ct
================================================================================
PBO: C:\DayZServer\@MotorbikePassenger\addons\BikesSeat2.pbo
Tamanho: 1,136,037 bytes
  TERMO: queue | ocorrencias: 1
    Offset: 1132132 | Contexto: cWeapon();....PlayerBase self = this;....g_Game.GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(self.BSP_ResyncWeapon, 600, false);...}..}.../*...The instan
  TERMO: reserved | ocorrencias: 1
    Offset: 1124139 | Contexto: r, il, true, 10000, action_data))...{....action_data.m_ReservedInventoryLocations.Insert(il);....return true;...}....return false;..}.}.modded class ActionConstr
  TERMO: slot | ocorrencias: 4
    Offset: 1121292 | Contexto: the seat the player looks at, and on..a bike both crew slots share the one "seat_driver" selection, so it can only ever offer the driver seat. This one..
    Offset: 1121438 | Contexto: s one..targets the bike itself and takes the passenger slot when the rider is already on..*/.class ActionGetInBikePassenger: ActionBase.{..void ActionGet
    Offset: 1124436 | Contexto: senger);..}.}..//! never put anyone into the passenger slot from the driver's get in.modded class ActionGetInTransport.{..override bool ActionCondition(P
================================================================================
PBO: C:\DayZServer\@NasdaraCactus\addons\Nasdara_Cactus.pbo
Tamanho: 5,092 bytes
  TERMO: slot | ocorrencias: 1
    Offset: 4567 | Contexto: )..{...ItemBase gloves = ItemBase.Cast(FindAttachmentBySlotName("Gloves"));...if (gloves && !gloves.IsDamageDestroyed())....return false;....if (!GetBlee
================================================================================
PBO: C:\DayZServer\@SimpleWhistle\Addons\Whistle.pbo
Tamanho: 100,893 bytes
  TERMO: PlayerIdentity | ocorrencias: 2
    Offset: 7347 | Contexto: eConfig( CallType type, ref ParamsReadContext ctx, ref PlayerIdentity sender, ref Object target ) ..    {..        Param1< Buddys_Whistle_Config > data;....        if ( !ctx
    Offset: 8072 | Contexto: eConfig( CallType type, ref ParamsReadContext ctx, ref PlayerIdentity sender, ref Object target ) ..    {..        if (sender)..        {..            GetRPCManager().SendRP
  TERMO: slot | ocorrencias: 2
    Offset: 4103 | Contexto: ...return !player.GetItemInHands() && !player.GetItemOnSlot("Gloves") && !player.GetItemOnSlot("Mask") && player.GetStaminaHandler().GetStamina() >= 25;.
    Offset: 4138 | Contexto: && !player.GetItemOnSlot("Gloves") && !player.GetItemOnSlot("Mask") && player.GetStaminaHandler().GetStamina() >= 25;...}......override void OnEndServer(
================================================================================
PBO: C:\DayZServer\@SuppressionMod\addons\Scripts.pbo
Tamanho: 28,694 bytes
  TERMO: OnConnect | ocorrencias: 3
    Offset: 21429 | Contexto:  }..    //     }..    // };....    override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity
    Offset: 21511 | Contexto: , PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity);..        //Print("[Suppression Config] :: MissionServer.c :: InvokeOnConnect");
    Offset: 21607 | Contexto: rint("[Suppression Config] :: MissionServer.c :: InvokeOnConnect");..        GetRPCManager().SendRPC("Suppression", "GetEarProtectionConfig", new Param1<TStringArr
  TERMO: GetIdentity | ocorrencias: 1
    Offset: 24768 | Contexto: yer.GetSuppressionLevel());.                if (player.GetIdentity()).                {.                    player.SpawnShockEffect( 0.7 );.                    player.
  TERMO: GetPlayer | ocorrencias: 3
    Offset: 9751 | Contexto: Fire(this);.......PlayerBase currentPlayer = GetGame().GetPlayer();.....if (currentPlayer && IsCurrentPlayerSuppressed()).....{......currentPlayer.OnSuppressedClie
    Offset: 11875 | Contexto: ppressed()...{....PlayerBase currentPlayer = GetGame().GetPlayer();....if (!currentPlayer)..        {..            return false;..        }........PlayerBase shoot
    Offset: 20091 | Contexto: .        PlayerBase player = PlayerBase.Cast(GetGame().GetPlayer());....        if (player)..        {..            player.earProtectionItems = data.param1;..
  TERMO: PlayerIdentity | ocorrencias: 8
    Offset: 1742 | Contexto: ----....modded class DayZGame..{...override void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)..    {..        super.OnRPC(sender, target,
    Offset: 3747 | Contexto: ion_Tinnitus_Start;...}.......static void SyncDataSend(PlayerIdentity identity)...{....ScriptRPC rpc = new ScriptRPC();....rpc.Write(s_Instance);....rpc.Send(null, Suppressi
    Offset: 14139 | Contexto: ession(suppressionAmount);...}.....override void OnRPC(PlayerIdentity sender, int rpc_type, ParamsReadContext ctx)...{....super.OnRPC(sender, rpc_type, ctx);......if (GetGam
  TERMO: connect | ocorrencias: 3
    Offset: 21431 | Contexto: ..    //     }..    // };....    override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identi
    Offset: 21513 | Contexto: PlayerIdentity identity)..    {..        super.InvokeOnConnect(player, identity);..        //Print("[Suppression Config] :: MissionServer.c :: InvokeOnConnect"
    Offset: 21609 | Contexto: nt("[Suppression Config] :: MissionServer.c :: InvokeOnConnect");..        GetRPCManager().SendRPC("Suppression", "GetEarProtectionConfig", new Param1<TStringA
  TERMO: slot | ocorrencias: 4
    Offset: 18182 | Contexto: ....override void EEItemAttached(EntityAI item, string slot_name)...{....super.EEItemAttached(item, slot_name);......CheckHearingProtection(item);...}...
    Offset: 18227 | Contexto: m, string slot_name)...{....super.EEItemAttached(item, slot_name);......CheckHearingProtection(item);...}...override void EEItemDetached(EntityAI item, s
    Offset: 18331 | Contexto: }...override void EEItemDetached(EntityAI item, string slot_name)...{....super.EEItemDetached(item, slot_name);......CheckHearingProtection(item);...}..}
================================================================================
PBO: C:\DayZServer\@SurvivorAnimations\Addons\player_main.pbo
Tamanho: 2,531,459 bytes
  TERMO: queue | ocorrencias: 52
    Offset: 263425 | Contexto: Suicide".     Column "farminghoe".    }.    AnimSrcNodeQueue SuicideFireQ {.     EditorPos 256.1 -28.9.     Child "SuicideSTM".     QueueItems {.      Anim
    Offset: 263502 | Contexto:     EditorPos 256.1 -28.9.     Child "SuicideSTM".     QueueItems {.      AnimSrcNodeQueueItem "{6930A8DE269909CE}" {.       Child "WeaponStanceMaster".
    Offset: 263532 | Contexto:  Child "SuicideSTM".     QueueItems {.      AnimSrcNodeQueueItem "{6930A8DE269909CE}" {.       Child "WeaponStanceMaster".       StartExpr "GetCommandI(CMD
  TERMO: slot | ocorrencias: 190
    Offset: 410022 | Contexto: ditorPos -24 -4.6.     Source "WeaponChange.1HDLeftBackSlotHide".     Looptype "No Loop".    }.    AnimSrcNodeSource "1hdBackLShowAnim" {.     EditorPos
    Offset: 410168 | Contexto: torPos -25.2 -3.9.     Source "WeaponChange.1HDLeftBackSlotShow".     Looptype "No Loop".    }.    AnimSrcNodeSource "1hdBackRHideAnim" {.     EditorPos
    Offset: 410315 | Contexto: orPos -15.2 -4.6.     Source "WeaponChange.1HDRightBackSlotHide".     Looptype "No Loop".    }.    AnimSrcNodeSource "1hdBackRShowAnim" {.     EditorPos
================================================================================
PBO: C:\DayZServer\@SurvivorAnimations\Addons\SurvivorAnims.pbo
Tamanho: 97,994,168 bytes
  TERMO: OnEvent | ocorrencias: 34
    Offset: 998140 | Contexto: EVNT...@..........Sound......)#..c.......ParticlexplosionEvent..........MetaFileClass {. Name "{37E35919A8E94F87}SurvivorAnims/animations/emotes/JUTSU.anm". Au
    Offset: 97903800 | Contexto: ....super.InitActionComponent();........RegisterAnimationEvent("CraftingAction", UA_IN_CRAFTING);...}...*/..};....class ActionSearchPlayerAtWall: ActionContinu
    Offset: 97905021 | Contexto: UREFB_HandsOnWall).....{......//GetGame().GetMission().OnEvent(ChatMessageEventTypeID, new ChatMessageEventParams(CCDirect, "", "Callback EMOTE " + em.m_Callba
  TERMO: GetIdentity | ocorrencias: 2
    Offset: 97904735 | Contexto: );....if ( body_EAI &&  body_EAI.IsAlive() && body_EAI.GetIdentity()) // && body_EAI.GetIdentity().GetName())....{.....return false; //disabled until finished.........
    Offset: 97904765 | Contexto: AI.IsAlive() && body_EAI.GetIdentity()) // && body_EAI.GetIdentity().GetName())....{.....return false; //disabled until finished..........EmoteManager em = body_EAI.Ge
  TERMO: queue | ocorrencias: 13
    Offset: 16613448 | Contexto: torPos 209.8000031 32.6000023....}...}...$Node AnimNodeQueue {.... "SuicideFireQ" "" "SuicideSTM"....$items 1 {.....$item {...... "WeaponStanceMaster" "Get
    Offset: 16670821 | Contexto: ...#EditorPos -5.0 17.2000008....}...}...$Node AnimNodeQueue {.... "MeleeMasterQ" "" "MeleeRotNode"....$items 1 {.....$item {...... "DamageMaster" "IsComma
    Offset: 16735407 | Contexto: itorPos 4.3000002 -57.9000015....}...}...$Node AnimNodeQueue {.... "HitQ" "" "SickIK"....$items 1 {.....$item {...... "DamageMaster" "IsCommand(CMD_Damage)
  TERMO: slot | ocorrencias: 196
    Offset: 16702925 | Contexto: e {.... "1hdBackLHideAnim" "" "WeaponChange.1HDLeftBackSlotHide" "noloop"....$Predictions {....}....$EditorData {.....#EditorPos -24.0 4.5999999....}...}
    Offset: 16703100 | Contexto: e {.... "1hdBackLShowAnim" "" "WeaponChange.1HDLeftBackSlotShow" "noloop"....$Predictions {....}....$EditorData {.....#EditorPos -25.2000008 3.9000001...
    Offset: 16703282 | Contexto:  {.... "1hdBackRHideAnim" "" "WeaponChange.1HDRightBackSlotHide" "noloop"....$Predictions {....}....$EditorData {.....#EditorPos -15.1999998 4.5999999...
================================================================================
PBO: C:\DayZServer\@VPPAdminTools\addons\assets.pbo
Tamanho: 1,179,261 bytes
  TERMO: SteamID | ocorrencias: 1
    Offset: 258139 | Contexto: Nom:","......:","......:","Nome:","......:".."VSTR_LBL_STEAMID","Steam ID:","Steam ID:","Steam ID:","Steam ID:","Steam ID:","Steam ID:","Steam ID:","Steam ID:"
  TERMO: Steam64 | ocorrencias: 14
    Offset: 403840 | Contexto: ntemente","............".."VSTR_CTX_PLR_COPY_ID","Copy Steam64 ID","Copy Steam64 ID","Kop..rovat Steam64 ID","Steam64-ID kopieren",".................... Steam6
    Offset: 403858 | Contexto: .....".."VSTR_CTX_PLR_COPY_ID","Copy Steam64 ID","Copy Steam64 ID","Kop..rovat Steam64 ID","Steam64-ID kopieren",".................... Steam64 ID","Kopiuj Stea
    Offset: 403882 | Contexto: PY_ID","Copy Steam64 ID","Copy Steam64 ID","Kop..rovat Steam64 ID","Steam64-ID kopieren",".................... Steam64 ID","Kopiuj Steam64 ID","Steam64 ID m..s
  TERMO: priority | ocorrencias: 4
    Offset: 249994 | Contexto: rags","........................rags".."VSTR_XML_COST","Priority for CE (higher value should be prioritized by the spawner)","Priority for CE (higher value should
    Offset: 250064 | Contexto:  (higher value should be prioritized by the spawner)","Priority for CE (higher value should be prioritized by the spawner)","Priorita pro CE (vy...... hodnota m.
    Offset: 447194 | Contexto: 0 .....................".."VSTR_XMLE_HELP_COST","Spawn priority. Higher values are preferred by the spawner. Vanilla uses 100.","Spawn priority. Higher values ar
  TERMO: queue | ocorrencias: 1
    Offset: 407750 | Contexto: ..:","Acoplado:",".........:".."VSTR_CTX_RESULT_ATTACH_QUEUED","Replacing attachment:","Replacing attachment:","Nahrazov..n.. p....slu..enstv..:","Anbautei
  TERMO: connection | ocorrencias: 4
    Offset: 659163 | Contexto: ely to each player %1 min after they connect (once per connection).","Sent privately to each player %1 min after they connect (once per connection).","Ode..le se sou
    Offset: 659244 | Contexto: ely to each player %1 min after they connect (once per connection).","Ode..le se soukrom.. ka..d..mu hr....i %1 min po p..ipojen.. (jednou za p..ipojen..).","Wird je
    Offset: 660504 | Contexto: tely to each player right after they connect (once per connection).","Sent privately to each player right after they connect (once per connection).","Ode..le se souk
  TERMO: connect | ocorrencias: 44
    Offset: 91151 | Contexto: + AdminTools","Vanilla++ AdminTools".."VSTR_SESSION_DISCONNECT","Session Disconnect","Session Disconnect","Odpojen.. relace","Sitzung getrennt","..............
    Offset: 91172 | Contexto: a++ AdminTools".."VSTR_SESSION_DISCONNECT","Session Disconnect","Session Disconnect","Odpojen.. relace","Sitzung getrennt",".................... ............",
    Offset: 91193 | Contexto: R_SESSION_DISCONNECT","Session Disconnect","Session Disconnect","Odpojen.. relace","Sitzung getrennt",".................... ............","Roz....czenie sesji"
  TERMO: login | ocorrencias: 33
    Offset: 293104 | Contexto: ,"......","......","Liberar","......".."VSTR_LBL_ADMIN_LOGIN","Admin Login","Admin Login","P..ihl....en.. admina","Admin-Login","........ .................
    Offset: 293118 | Contexto: ...","Liberar","......".."VSTR_LBL_ADMIN_LOGIN","Admin Login","Admin Login","P..ihl....en.. admina","Admin-Login","........ ............................","
    Offset: 293132 | Contexto: ,"......".."VSTR_LBL_ADMIN_LOGIN","Admin Login","Admin Login","P..ihl....en.. admina","Admin-Login","........ ............................","Logowanie admi
  TERMO: slot | ocorrencias: 55
    Offset: 383475 | Contexto: ..................","Objeto","......".."VSTR_CTX_EMPTY_SLOT","Empty","Empty","Pr..zdn..","Leer","..........","Pusty","..res","Vuoto","Vac..o","Vide","...
    Offset: 407151 | Contexto: ..vel",".....................".."VSTR_CTX_ATT_LOCKED","Slot is locked","Slot is locked","Slot je zam..en..","Slot ist gesperrt","........ ...............
    Offset: 407168 | Contexto: ............".."VSTR_CTX_ATT_LOCKED","Slot is locked","Slot is locked","Slot je zam..en..","Slot ist gesperrt","........ ........................","Slot
================================================================================
PBO: C:\DayZServer\@VPPAdminTools\addons\VPPAdminTools.pbo
Tamanho: 79,657,389 bytes
  TERMO: OnClientDisconnected | ocorrencias: 4
    Offset: 3303441 | Contexto: _LogoutQueueInital"..                    ScriptInvoker onClientDisconnectedEvent = VPPATGetEventHandler().GetEventInvoker("OnPlayerDisconnected");..                    onClientDisconnec
    Offset: 3303554 | Contexto: tInvoker("OnPlayerDisconnected");..                    onClientDisconnectedEvent.Invoke(player, identity, false);..                }..                else if (!IsLogoutTimeExpired(playe
    Offset: 3306082 | Contexto: ntry ... " + uid);..        }....        ScriptInvoker onClientDisconnectedEvent = VPPATGetEventHandler().GetEventInvoker("OnPlayerDisconnected");    ..        onClientDisconnectedEvent
  TERMO: OnEvent | ocorrencias: 49
    Offset: 22576 | Contexto: ..a....5_Mission\VPPAdminTools\GUI\UIHelpers\ConfirmationEventHandler.c.....O.......m".cO...5_Mission\VPPAdminTools\GUI\UIHelpers\ContextMenu\VPPContextMenuBri
    Offset: 685476 | Contexto: w)..{...if (!w)....return true;....if (w.CanProcessWeaponEvents() && !w.IsIdle())....return true;....if (GetGame().HasInventoryJunctureItem(w))....return true;
    Offset: 1222978 | Contexto: hunk chunk)..{...ScriptRPC netRpc = VPPXENet.Begin("XE_OnEventsChunk");...Param1<ref VPPXEEventsChunk> netPayload = new Param1<ref VPPXEEventsChunk>(chunk);...
  TERMO: OnConnect | ocorrencias: 28
    Offset: 347164 | Contexto: duler:.// - a <message> reads delay, repeat, deadline, onconnect and shutdown (integers, minutes; anything unreadable is 0),.//   time and text. Text longer than 1
    Offset: 347358 | Contexto: server skips a message without text or without a mode: onconnect = 1, repeat > 0, deadline > 0 or a time..//   shutdown = 1 only counts together with a deadline or
    Offset: 347480 | Contexto: 1 only counts together with a deadline or a time..// - onconnect: sent once, privately, `delay` minutes after each player connects (delay 0 = 1 second)..// - repea
  TERMO: GetPlainId | ocorrencias: 339
    Offset: 41888 | Contexto:  must have a valid sender........recievedFrom = sender.GetPlainId();.......Param3<string, string, string> serverMetaData;.....if (!ctx.Read(serverMetaData))......ret
    Offset: 71155 | Contexto: T.Insert(uid, new VPPUser(identity.GetName(), identity.GetPlainId(), identity.GetPlayerId()));....}...}...../*...* Sends entire Sync list to a specified client via R
    Offset: 387553 | Contexto: ...string plainId = action_data.m_Player.GetIdentity().GetPlainId();....if (!GetPermissionManager().VerifyPermission(plainId, "EspToolsMenu:InstantBaseBuild")).....r
  TERMO: GetIdentity | ocorrencias: 87
    Offset: 70738 | Contexto: i])..       ....continue;....       ...if (!players[i].GetIdentity())..       ....continue;....       ...PLAYERS.Insert(players[i].GetIdentity().GetId(), players[i].Ge
    Offset: 70814 | Contexto:   ....continue;....       ...PLAYERS.Insert(players[i].GetIdentity().GetId(), players[i].GetIdentity());..       ..}....}......PLAYERS_CLIENT.Clear();....foreach(strin
    Offset: 70848 | Contexto: RS.Insert(players[i].GetIdentity().GetId(), players[i].GetIdentity());..       ..}....}......PLAYERS_CLIENT.Clear();....foreach(string uid, PlayerIdentity identity : P
  TERMO: GetPlayer | ocorrencias: 381
    Offset: 67862 | Contexto: layers = new array<Man>;..       .GetGame().GetWorld().GetPlayerList(players);..       .return players.Count();...}.....int GetCount()...{....if (GetGame().IsDedic
    Offset: 70571 | Contexto: ayers = new array<Man>;..       ..GetGame().GetWorld().GetPlayerList(players);..       ..for (int i = 0; i < players.Count(); ++i)..       ..{..       ...if (!play
    Offset: 71178 | Contexto: er(identity.GetName(), identity.GetPlainId(), identity.GetPlayerId()));....}...}...../*...* Sends entire Sync list to a specified client via RPC...*/...static void
  TERMO: SteamID | ocorrencias: 194
    Offset: 74530 | Contexto: meServer..{...string addr;...int    gameport;...string steamid;...string name;...int    appid;...string gamedir;...string version;...string product;...int    r
    Offset: 388588 | Contexto: ....GetSimpleLogger().Log(string.Format("Admin \"%1\" (steamId=%2) built part %3 at position: %4", action_data.m_Player.GetIdentity().GetName(), plainId, part_
    Offset: 396787 | Contexto: .if (!GetPermissionManager().HasUserGroup(pb.VPlayerGetSteamId()))......continue;.......GetGame().RPCSingleParam(player, VPPATRPCs.RPC_SYNC_TRANSFER_VALUES, ne
  TERMO: Steam64 | ocorrencias: 93
    Offset: 73663 | Contexto: ser..{...private string m_UserName;...private string m_Steam64ID;...private int    m_SessionId;......void VPPUser(string name, string id, int sessionId = -1)..
    Offset: 73798 | Contexto: d, int sessionId = -1)...{....m_UserName  = name;....m_Steam64ID = id;....m_SessionId = sessionId;...}.......string GetUserId()...{....return m_Steam64ID;...}.
    Offset: 73887 | Contexto: essionId;...}.......string GetUserId()...{....return m_Steam64ID;...}......string GetUserName()...{....return m_UserName;...}.....int GetSessionId()...{....ret
  TERMO: PlayerIdentity | ocorrencias: 381
    Offset: 41019 | Contexto: ........modded class DayZGame..{...override void OnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)...{....if (rpc_type == RPCManager.VPPAT_FRA
    Offset: 41475 | Contexto: = 10420;.....void RPCManager()...{...}.....void VOnRPC(PlayerIdentity sender, Object target, int rpc_type, ParamsReadContext ctx)...{....if (rpc_type != VPPAT_FRAMEWORK_RPC_
    Offset: 43778 | Contexto: ionCallData = new Param4< CallType, ParamsReadContext, PlayerIdentity, Object >( CallType.Server, ctx, sender, target );.............if ( ( GetGame().IsServer() && GetGame()
  TERMO: priority | ocorrencias: 40
    Offset: 432057 | Contexto: ---------..// ADS sight resolution (mode-aware vanilla priority, all off the REMOTE target)..//------------------------------------------------------------------
    Offset: 2030968 | Contexto: g true keeps the HUD select box and the generic window-priority path out of it....*/...override bool OnMouseButtonDown(Widget w, int x, int y, int button)...{...
    Offset: 2239527 | Contexto: ble: keep it hidden while another admin window has the priority....if (m_BrokenHidden)....{.....m_MapTab.SetMapVisible(false);....}...}..}...protected void Apply
  TERMO: queue | ocorrencias: 489
    Offset: 2152 | Contexto: C.......l..jC...3_Game\VPPAdminTools\XMLEditor\VPPXEJobQueue.c.....`8.........j`8..3_Game\VPPAdminTools\XMLEditor\VPPXEMessages.c......!......J..j.!..3_Gam
    Offset: 74741 | Contexto:     bots;...string Map;...string gametype;......int GetQueuedPlayers()...{....string temp = gametype;....temp.Replace("battleye,external,privHive,shard,",
    Offset: 127553 | Contexto: E_SPLIT;..}...// Splits, then tokenizes, while VPPXEJobQueue.BudgetOk(); true when done (ok or error)...bool Step()..{...if (m_Phase == PHASE_DONE)...{....
  TERMO: reserved | ocorrencias: 4
    Offset: 703228 | Contexto: name (e.g. mylocks.vehicle.unlock). The vpp. prefix is reserved....Rules (frozen, contract section 4):..A1 Actions are stateless singletons shared by every reque
    Offset: 711912 | Contexto: wercase <modtag>.<category>.<name>; the vpp. prefix is reserved..string GetId()..{...return "";..}...//empty = root page, otherwise the id of a SUBMENU action..s
    Offset: 2687182 | Contexto: int TIER_DEFAULT_COUNT = 5;..const static int TIER_BAR_RESERVED = 128;..const static int LAYER_TOTAL = 8;..const static int ALL_TIERS = 255;..const static int CH
  TERMO: connect | ocorrencias: 158
    Offset: 45489 | Contexto: er() && !GetGame().IsDedicatedServer();  //Diag client connected to a MP session......auto sendData = new array<ref Param>;......//Diag client connected to a M
    Offset: 45577 | Contexto: to sendData = new array<ref Param>;......//Diag client connected to a MP session....if (isDiagMPClient)....{.....string pw = string.Empty;.....EnScript.GetClas
    Offset: 61868 | Contexto: w map<string, ref ScriptInvoker>;....AddEvent("OnPlayerConnect");....AddEvent("OnPlayerDisconnected");....AddEvent("OnClientDisconnectCancel");...}...../*...vo
  TERMO: login | ocorrencias: 90
    Offset: 41348 | Contexto:  class RPCManager..{...protected ref map<string,int> m_LoginAttempts = new map<string,int>;...const int VPPAT_FRAMEWORK_RPC_ID = 10420;.....void RPCManager
    Offset: 42676 | Contexto: ls.txt");.......VSendRPC("RPC_MissionGameplay", "ServerLoginError", NULL, true, sender, NULL);.......return;......}........if (m_LoginAttempts[recievedFrom
    Offset: 42750 | Contexto: true, sender, NULL);.......return;......}........if (m_LoginAttempts[recievedFrom] >= 6).......return;........string hash = VSHA256.ComputeString(pw);.....
  TERMO: slot | ocorrencias: 535
    Offset: 951 | Contexto: ......]..i.2..3_Game\VPPAdminTools\utils\VPPATInventorySlots.c.....A ......5w.jA ..3_Game\VPPAdminTools\utils\VPPPlayerData.c................a....3_Game\
    Offset: 93648 | Contexto:  game inventory objects types..*/..class VPPATInventorySlots..{...static ref map<string, ref array<string>> SlotsItems = new map <string, ref array<strin
    Offset: 93701 | Contexto: rySlots..{...static ref map<string, ref array<string>> SlotsItems = new map <string, ref array<string>>;.....//context-menu spawnable index: separate fro
  TERMO: servermod | ocorrencias: 1
    Offset: 709126 | Contexto: ride above),..and a server-side-only PBO (loaded with -serverMod) adds the logic, keeping it out of the client download:...modded class MyLocks_CA_Unlock..{...over
================================================================================
PBO: C:\DayZServer\@ZensCoreMod\addons\ZenModCore.pbo
Tamanho: 2,430,897 bytes
  TERMO: OnEvent | ocorrencias: 4
    Offset: 2359610 | Contexto: ..if (g_Game.GetPlayer())....{.....g_Game.GetMission().OnEvent(ChatMessageEventTypeID, new ChatMessageEventParams(CCDirect, "", message, ""));....}...}..}class
    Offset: 2371719 | Contexto: ..if (g_Game.GetPlayer())....{.....g_Game.GetMission().OnEvent(ChatMessageEventTypeID, new ChatMessageEventParams(CCDirect, "", message, ""));....}..#endif...}
    Offset: 2408168 | Contexto: essage(playerWatchlistMsg);....}...}.....override void OnEvent(EventType eventTypeId, Param params)...{....if (eventTypeId == ChatMessageEventTypeID)....{.....
  TERMO: OnConnect | ocorrencias: 4
    Offset: 2406337 | Contexto: ...super.LoadZenConfig();...}......override void InvokeOnConnect(PlayerBase player, PlayerIdentity identity) ...{....super.InvokeOnConnect(player, identity);......
    Offset: 2406411 | Contexto: e player, PlayerIdentity identity) ...{....super.InvokeOnConnect(player, identity);........ZenInvokeOnConnect(player, identity);...}......void ZenInvokeOnConnect(P
    Offset: 2406456 | Contexto: per.InvokeOnConnect(player, identity);........ZenInvokeOnConnect(player, identity);...}......void ZenInvokeOnConnect(PlayerBase player, PlayerIdentity identity)...
  TERMO: OnDisconnect | ocorrencias: 4
    Offset: 2350751 | Contexto: layerLoadedClientPlayer();....}...}......override void OnDisconnect()...{....super.OnDisconnect();........if (g_Game.IsClient() && IsControlledPlayer())....{.....Zen_OnD
    Offset: 2350779 | Contexto: ..}...}......override void OnDisconnect()...{....super.OnDisconnect();........if (g_Game.IsClient() && IsControlledPlayer())....{.....Zen_OnDisconnectClientPlayer();....
    Offset: 2350862 | Contexto: _Game.IsClient() && IsControlledPlayer())....{.....Zen_OnDisconnectClientPlayer();....}...}......void Zen_OnPlayerLoadedClientPlayer() ...{....GetZenConfigRegister().Req
  TERMO: GetPlainId | ocorrencias: 7
    Offset: 2236974 | Contexto: in(id.GetId())).....return true;........if (IsAdmin(id.GetPlainId())).....return true;........return false;...}......bool IsModerator(string uid)...{....return ZenCo
    Offset: 2355471 | Contexto: eedName() + "](" + idLink + playerKiller.GetIdentity().GetPlainId() + ")";.....}..........victimText = "[" + GetZenKillFeedName() + "](http://steamcommunity.com/prof
    Offset: 2355604 | Contexto: ](http://steamcommunity.com/profiles/" + GetIdentity().GetPlainId() + ")";....}......string weaponText = "";....if (object.GetType() == playerKiller.GetType()).....w
  TERMO: GetIdentity | ocorrencias: 23
    Offset: 2346288 | Contexto:  a player, nothing to log...//..if (!player || !player.GetIdentity())..//...return;........//! TODO: We can now check:....// 1. Was the timestamp difference between no
    Offset: 2351870 | Contexto: feed: No valid webhooks.");.....return;....}......if (!GetIdentity() || Zen_IsAI() || GetType().Contains("_Ghost"))....{.....//ZMPrint("Killfeed: No identity or is AI=
    Offset: 2353867 | Contexto: }........if (!playerKiller.Zen_IsAI() && !playerKiller.GetIdentity())....{.....//ZMPrint("Killfeed: Killer has no identity.");.....return;....}......ZenKillFeed(player
  TERMO: GetPlayer | ocorrencias: 21
    Offset: 2347912 | Contexto: ate PlayerBase m_ZenTrapperPlayer;......PlayerBase Zen_GetPlayerTrapper()...{....return m_ZenTrapperPlayer;...}......override void StartActivate(PlayerBase player)
    Offset: 2352965 | Contexto: != null).......playerKiller = PlayerBase.Cast(trap.Zen_GetPlayerTrapper());.....}.......// Check for vehicles.....if (!playerKiller).....{......CarScript vehicle =
    Offset: 2359568 | Contexto: DisplayClientMessage(string message)...{....if (g_Game.GetPlayer())....{.....g_Game.GetMission().OnEvent(ChatMessageEventTypeID, new ChatMessageEventParams(CCDirec
  TERMO: SteamID | ocorrencias: 7
    Offset: 2243280 | Contexto: ef array<string> KillfeedWebhooks;...bool DisplayPlayerSteamID;...bool DisplayKillLocation;...bool DisplayKillsByAI;......void ZenKillfeedConfig()...{....Enabl
    Offset: 2243529 | Contexto: sert killfeed channel webhooks here");....DisplayPlayerSteamID = false;....DisplayKillLocation = false;....DisplayKillsByAI = false;...}..}/*..This is purely f
    Offset: 2355094 | Contexto: ig().ZenCore_DiscordConfig.KillfeedConfig.DisplayPlayerSteamID)....{.....if (!playerKiller.GetIdentity()).....{......killerText = playerKiller.GetType();.....}
  TERMO: PlayerIdentity | ocorrencias: 15
    Offset: 2236850 | Contexto: Config.AdminIDs.Find(uid) != -1;...}......bool IsAdmin(PlayerIdentity id)...{....if (!id).....return false;........if (IsAdmin(id.GetId())).....return true;........if (IsAdm
    Offset: 2259918 | Contexto: ot implemented"; return false; }.....void SyncToClient(PlayerIdentity identity = null)...{....string payload, err;....if (!BuildSyncPayload(payload, err))....{.....ErrorEx("
    Offset: 2267371 | Contexto: ConfigIfOutdated(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)...{....if (type != CallType.Server).....return;.......Param2<string, string> msg
  TERMO: priority | ocorrencias: 31
    Offset: 2276417 | Contexto: ex;...int SavedIndex;...int PendingIndex;...int DisplayPriority;.....void ZenModSetting(string id, string categoryId, string title, array<string> options, int de
    Offset: 2276575 | Contexto:  defaultIndex = 0, string description = "", int displayPriority = 0)...{....Id = id;....CategoryId = categoryId;....Title = title;....Description = description;.
    Offset: 2276691 | Contexto: Title = title;....Description = description;....DisplayPriority = displayPriority;......Options = new array<string>;....if (options)....{.....for (int i = 0; i <
  TERMO: queue | ocorrencias: 16
    Offset: 2270608 | Contexto:  true);....cfg.AfterConfigReceived();....g_Game.GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(DeferredInvokeAfterSync, 0, false, cfg);...}......void Deferre
    Offset: 2302381 | Contexto: CanAffectPathgraph()) ...    {...        g_Game.GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(g_Game.UpdatePathgraphRegionByObject, 100, false, obj);...
    Offset: 2321285 | Contexto: int MAX_BUFFER_LINES  = 50;     // or when >= 50 lines queued.....protected static ref map<string, ref TStringArray> s_Buffers = new map<string, ref TStrin
  TERMO: connect | ocorrencias: 19
    Offset: 2223301 | Contexto: ............................",.."STR_ZenWatchlistPlayerConnected","A player on your watchlist just connected to your server:","A player on your watchlist just
    Offset: 2223345 | Contexto: hlistPlayerConnected","A player on your watchlist just connected to your server:","A player on your watchlist just connected to your server:","Hr.... z va..eho
    Offset: 2223405 | Contexto: cted to your server:","A player on your watchlist just connected to your server:","Hr.... z va..eho seznamu sledovan..ch se pr..v.. p..ipojil k va..emu serveru
  TERMO: slot | ocorrencias: 23
    Offset: 2369356 | Contexto: ..isRuined = true;........}........if (child.IsLockedInSlot())......{.......isLocked = true;......}........InventoryLocation child_src = new InventoryLoc
    Offset: 2381285 | Contexto: nd;...}.....//! Get the EntityAI attached to the given slot NAME on the given entity ...static EntityAI GetItemOnSlotBySlotName(notnull EntityAI entityAI
    Offset: 2381343 | Contexto: t NAME on the given entity ...static EntityAI GetItemOnSlotBySlotName(notnull EntityAI entityAI, string slot_type)...{....return GetItemOnSlotBySlotID(en
================================================================================
PBO: C:\DayZServer\@ZensNotes\addons\ZenNotes.pbo
Tamanho: 5,196,442 bytes
  TERMO: OnEvent | ocorrencias: 1
    Offset: 5188448 | Contexto: Msg(string msg)..{...Print(msg);...g_Game.GetMission().OnEvent(ChatMessageEventTypeID, new ChatMessageEventParams(CCDirect, "", msg, ""));..}.}modded class Mis
  TERMO: GetPlainId | ocorrencias: 1
    Offset: 5148092 | Contexto: tity.GetId()) != -1 || SteamIDsBlacklist.Find(identity.GetPlainId()) != -1;....}......return false;...}.....// Check if the given message contains a blacklisted word
  TERMO: GetIdentity | ocorrencias: 6
    Offset: 5155986 | Contexto: RECEIVE_WRITTEN_NOTE, data, true, action_data.m_Player.GetIdentity());....note.IncreaseLifetime();...}..}...// For compatibility with @ZenCraftingSounds..override stri
    Offset: 5157068 | Contexto: RECEIVE_WRITTEN_NOTE, data, true, action_data.m_Player.GetIdentity());....note.IncreaseLifetime();...}..}.}.class ActionZenWritePaperCB : ActionContinuousBaseCB {}..cl
    Offset: 5160277 | Contexto: Cs.RECEIVE_NOTE_DATE, data, true, action_data.m_Player.GetIdentity());..}...// Get the ARGB colour integer for the given pen..static int GetPenColour(Pen_ColorBase pen
  TERMO: GetPlayer | ocorrencias: 2
    Offset: 5162323 | Contexto:        {....PlayerBase player = PlayerBase.Cast(sender.GetPlayer());..            if (!player || !sender) // If we can't identify the player who sent this note dat
    Offset: 5187346 | Contexto: enNoteData>(note_data);.....if (msgTxt != "" && g_Game.GetPlayer())....{.....m_Paper.RPCSingleParam(ZenNotesRPCs.SEND_WRITTEN_NOTE, params, true, NULL);....}...../
  TERMO: SteamID | ocorrencias: 4
    Offset: 5146314 | Contexto: lNotes;...string BlacklistMessage;...ref array<string> SteamIDsBlacklist = new array<string>;.....// Load config file or create default file if config doesn't
    Offset: 5147963 | Contexto: sPlayerBlacklisted(PlayerIdentity identity)...{....if (SteamIDsBlacklist.Count() > 0)....{.....return SteamIDsBlacklist.Find(identity.GetId()) != -1 || SteamID
    Offset: 5148010 | Contexto: ....if (SteamIDsBlacklist.Count() > 0)....{.....return SteamIDsBlacklist.Find(identity.GetId()) != -1 || SteamIDsBlacklist.Find(identity.GetPlainId()) != -1;..
  TERMO: PlayerIdentity | ocorrencias: 5
    Offset: 5147927 | Contexto: n player ID is blacklisted ...bool IsPlayerBlacklisted(PlayerIdentity identity)...{....if (SteamIDsBlacklist.Count() > 0)....{.....return SteamIDsBlacklist.Find(identity.Get
    Offset: 5161299 | Contexto:  {.        m_Pen = pen;.    }..    override void OnRPC(PlayerIdentity sender, int rpc_type, ParamsReadContext ctx).    {.        super.OnRPC(sender, rpc_type, ctx);..
    Offset: 5163023 | Contexto:                   NotificationSystem.SendNotificationToPlayerIdentityExtended(player.GetIdentity(), 10.0, "#layout_notification_info_warning", GetZenNotesConfig().BlacklistM
  TERMO: priority | ocorrencias: 1
    Offset: 2237153 | Contexto: os 1.   vexactpos 1.   hexactsize 1.   vexactsize 1.   priority 1.   image0 "ZenNotes/data/gui/layouts/notes/notebg.edds".   imageTexture "{7819C907890D2FF0}ZenN
  TERMO: queue | ocorrencias: 4
    Offset: 5162031 | Contexto: t after data is received.                g_Game.GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(UpdateGUI, 50, false);.            }..            return;.
    Offset: 5168050 | Contexto: m the ground.                            g_Game.GetCallQueue(CALL_CATEGORY_GAMEPLAY).CallLater(TakeNoteToHands, 200, true, player, noteGround);.
    Offset: 5170210 | Contexto: ries >= 5).            {.                g_Game.GetCallQueue(CALL_CATEGORY_GAMEPLAY).Remove(TakeNoteToHands);.            }.        }.        else.
  TERMO: reserved | ocorrencias: 8
    Offset: 5166323 | Contexto:                     // Put the paper stack back in its reserved location, and place note into player's hands.                            HumanInventory inventory
    Offset: 5166580 | Contexto:            return;..                            // Get reserved paper location in inventory (dst).                            InventoryLocation loc_dst = new Inv
    Offset: 5166734 | Contexto: new InventoryLocation;.                            int reservedIndex = inventory.FindUserReservedLocationIndex(this);.                            inventory.GetUs
  TERMO: connect | ocorrencias: 3
    Offset: 5169131 | Contexto: ive() && !player.IsUnconscious() && !player.IsPlayerDisconnected()).        {.            // For some reason this approach bugs the player's hands?? Seems to w
    Offset: 5170415 | Contexto: ject, or they're dead, or they're uncon, or they're disconnected, stop trying to pick it up and leave note on ground..            g_Game.GetCallQueue(CALL_CATE
    Offset: 5171233 | Contexto: MessageParam && player.IsAlive() && !player.IsPlayerDisconnected() && message != "").        {.            m_MessageParam.param1 = message;.            g_Game.
  TERMO: slot | ocorrencias: 2
    Offset: 7813 | Contexto: QuantityMax.d.....stackedUnit.percentage......inventorySlot...ZenJournal_Pen.....Pen_ColorBase....scope.......displayName.$STR_ZenPen_Black..penColor....
    Offset: 5167205 | Contexto:  If player has moved an item into the paper's reserved slot, or ServerTakeToDst fails, just take paper to anywhere in inventory..
================================================================================
PBO: C:\DayZServer\addons\ai.pbo
Tamanho: 119,965 bytes
  TERMO: slot | ocorrencias: 152
    Offset: 1371 | Contexto: .A..agentPathUpdateDelta....@..agentPathMinLength... @.SlotCowering......SlotCalm.P....SlotNonSpecificThreat......SlotAlerted.u....AlertSystem.....-.....
    Offset: 1389 | Contexto: eDelta....@..agentPathMinLength... @.SlotCowering......SlotCalm.P....SlotNonSpecificThreat......SlotAlerted.u....AlertSystem.....-......BehaviourCowering
    Offset: 1403 | Contexto: gentPathMinLength... @.SlotCowering......SlotCalm.P....SlotNonSpecificThreat......SlotAlerted.u....AlertSystem.....-......BehaviourCowering.7...P.......p
================================================================================
PBO: C:\DayZServer\addons\ai_bliss.pbo
Tamanho: 10,843 bytes
  TERMO: slot | ocorrencias: 10
    Offset: 899 | Contexto: e....A..annoyanceTimerMin....A..annoyanceTimerMax...@A.SlotCowering......SlotCalmResting......SlotCalmGrazing.@....SlotCalmTravelling......SlotDrinking..
    Offset: 917 | Contexto: imerMin....A..annoyanceTimerMax...@A.SlotCowering......SlotCalmResting......SlotCalmGrazing.@....SlotCalmTravelling......SlotDrinking......SlotNonSpecifi
    Offset: 938 | Contexto: ceTimerMax...@A.SlotCowering......SlotCalmResting......SlotCalmGrazing.@....SlotCalmTravelling......SlotDrinking......SlotNonSpecificThreat.u....SlotSpec
================================================================================
PBO: C:\DayZServer\addons\animals.pbo
Tamanho: 67,075,644 bytes
  TERMO: priority | ocorrencias: 40
    Offset: 66266802 | Contexto: lds..!......MoveCompleted.K....TimeElapsed.............priority.......to.SetRandom3..Condition......Action.............function.moveCompleted..parameters....thre
    Offset: 66266977 | Contexto: ....function.nothing..parameters...thresholds..........priority.......to.SetRandom2..Condition.:....Action.t...........function.timeElapsed..parameters....thresh
    Offset: 66267278 | Contexto: ..L?......thresholds.........WaitCompleted.'...........priority.......to.SetTimerRandom..Condition.k....Action.............function.waitCompleted..parameters....
  TERMO: queue | ocorrencias: 27
    Offset: 271209 | Contexto:  {.     EditorPos 0 -37.3.     Child "SecondaryActions_Queue".     Expression "clamp(lookYAngle,-90.0, 90.0)   * 0.01745329251994329576923690768489".     B
    Offset: 272567 | Contexto:      EditorPos -4.7 -37.2.     Child "SecondaryActions_Queue".     Expression "clamp(lookYAngle,-90.0, 90.0)   * 0.01745329251994329576923690768489".     B
    Offset: 275845 | Contexto: .     EditorPos 3.9 -37.4.     Child "SecondaryActions_Queue".     Expression "clamp(lookYAngle,-90.0, 90.0)   * 0.01745329251994329576923690768489".     B
  TERMO: connect | ocorrencias: 14
    Offset: 65610733 | Contexto: valentTo" value="" />..                <variable name="connectAs" value="" />..                <array name="variantAfter">..                    <variable value
    Offset: 65610991 | Contexto:                 </array>..                <array name="connectFrom" />..                <array name="connectTo" />..                <array name="interpolateWit
    Offset: 65611037 | Contexto: ay name="connectFrom" />..                <array name="connectTo" />..                <array name="interpolateWith" />..                <array name="interpolat
  TERMO: slot | ocorrencias: 3
    Offset: 92721 | Contexto: alue 0.    MaxValue 2.   }.   AnimSrcGCTVarInt behaviorSlotID {.    DefaultValue 0.    MinValue 0.    MaxValue 31.   }.   AnimSrcGCTVarInt AnimalType {.
    Offset: 229195 | Contexto: alue 0.    MaxValue 2.   }.   AnimSrcGCTVarInt behaviorSlotID {.    DefaultValue 0.    MinValue 0.    MaxValue 31.   }.   AnimSrcGCTVarInt AnimalType {.
    Offset: 3916886 | Contexto: alue 0.    MaxValue 2.   }.   AnimSrcGCTVarInt behaviorSlotID {.    DefaultValue 0.    MinValue 0.    MaxValue 31.   }.   AnimSrcGCTVarInt AnimalType {.
================================================================================
PBO: C:\DayZServer\addons\animals_bliss.pbo
Tamanho: 8,347,335 bytes
  TERMO: queue | ocorrencias: 20
    Offset: 80667 | Contexto: r_Y_rot {.     EditorPos -2.5 -38.     Child "LookRoll_Queue".     Expression "clamp(lookYAngle,-1.0, 1.0)   * 0.01745329251994329576923690768489".     Bon
    Offset: 81255 | Contexto:        Amount 0.25.      }.     }.    }.    AnimSrcNodeQueue LookRoll_Queue {.     EditorPos -2.5 -36.6.     Child "Roars_Queue".     QueueItems {.      An
    Offset: 81270 | Contexto: .25.      }.     }.    }.    AnimSrcNodeQueue LookRoll_Queue {.     EditorPos -2.5 -36.6.     Child "Roars_Queue".     QueueItems {.      AnimSrcNodeQueueI
  TERMO: slot | ocorrencias: 4
    Offset: 20465 | Contexto: alue 0.    MaxValue 2.   }.   AnimSrcGCTVarInt behaviorSlotID {.    DefaultValue 0.    MinValue 0.    MaxValue 17.   }.   AnimSrcGCTVarInt AnimalType {.
    Offset: 104437 | Contexto: I(CMD_AnimCallBack) == 30 && RandomPerc(50) && behaviorSlotID != 9".       InterruptExpr "".       StartTime "".       BlendInTime 0.3.       BlendOutTim
    Offset: 108679 | Contexto: riggerOn "".     TriggerOff "".     Condition "behaviorSlotID == 14".     Child0 "Run_Intimidate_BlendT".     Child1 "Run_Enraged_BlendT".     OptimizeMi
================================================================================
PBO: C:\DayZServer\addons\anims_anm_player.pbo
Tamanho: 356,687,985 bytes
  TERMO: slot | ocorrencias: 76
    Offset: 484164 | Contexto: g_poses.anm.............CP.j.A..weaponswitch\p_1hd_erc_slot_backL_hide.anm.............CP.j....weaponswitch\p_1hd_erc_slot_backL_show.anm.............CP.
    Offset: 484227 | Contexto: kL_hide.anm.............CP.j....weaponswitch\p_1hd_erc_slot_backL_show.anm.............CP.j....weaponswitch\p_1hd_erc_slot_backR_hide.anm.............CP.
    Offset: 484290 | Contexto: kL_show.anm.............CP.j....weaponswitch\p_1hd_erc_slot_backR_hide.anm.............CP.j....weaponswitch\p_1hd_erc_slot_backR_show.anm.............CP.
================================================================================
PBO: C:\DayZServer\addons\anims_workspaces.pbo
Tamanho: 4,780,932 bytes
  TERMO: queue | ocorrencias: 56
    Offset: 110866 | Contexto: Hit Left".     Looptype "No Loop".    }.    AnimSrcNodeQueue CrawlHitQ {.     EditorPos -5.1 -20.3.     Child "CrawlSTM".     QueueItems {.      AnimSrcNod
    Offset: 110937 | Contexto: {.     EditorPos -5.1 -20.3.     Child "CrawlSTM".     QueueItems {.      AnimSrcNodeQueueItem "{6930A8DE2FA4C82E}" {.       Child "CrawlHitSTM".       Sta
    Offset: 110967 | Contexto:    Child "CrawlSTM".     QueueItems {.      AnimSrcNodeQueueItem "{6930A8DE2FA4C82E}" {.       Child "CrawlHitSTM".       StartExpr "IsCommand(CMD_HIT_LIGH
  TERMO: slot | ocorrencias: 190
    Offset: 2250390 | Contexto: ditorPos -24 -4.6.     Source "WeaponChange.1HDLeftBackSlotHide".     Looptype "No Loop".    }.    AnimSrcNodeSource "1hdBackLShowAnim" {.     EditorPos
    Offset: 2250536 | Contexto: torPos -25.2 -3.9.     Source "WeaponChange.1HDLeftBackSlotShow".     Looptype "No Loop".    }.    AnimSrcNodeSource "1hdBackRHideAnim" {.     EditorPos
    Offset: 2250683 | Contexto: orPos -15.2 -4.6.     Source "WeaponChange.1HDRightBackSlotHide".     Looptype "No Loop".    }.    AnimSrcNodeSource "1hdBackRShowAnim" {.     EditorPos
================================================================================
PBO: C:\DayZServer\addons\characters_backpacks.pbo
Tamanho: 5,651,934 bytes
  TERMO: slot | ocorrencias: 25
    Offset: 2452268 | Contexto: kpacks\taloon_g.p3d...debug_ItemCategory......inventorySlot...Back..attachments...Chemlight..WalkieTalkie..Backpack_1..NBCBag..itemInfo...Clothing..Back.
    Offset: 2454540 | Contexto: acks\tortilla_g.p3d...debug_ItemCategory......inventorySlot...Back..attachments...Chemlight..WalkieTalkie..Backpack_1..NBCBag..itemInfo...Clothing..Back.
    Offset: 2456349 | Contexto: ImpCourierBag_g.p3d...debug_ItemCategory......inventorySlot...Back..attachments...WalkieTalkie..Backpack_1..itemInfo...Clothing..Back...rotationFlags....
================================================================================
PBO: C:\DayZServer\addons\characters_belts.pbo
Tamanho: 423,354 bytes
  TERMO: slot | ocorrencias: 10
    Offset: 64649 | Contexto: .vehicleClass.Clothing...simulation.clothing..inventorySlot...Hips..itemInfo...Clothing..Hips...quickBarBonus......itemSize..............weight......repa
    Offset: 65988 | Contexto: .vehicleClass.Clothing...simulation.clothing..inventorySlot...Hips..itemInfo...Clothing..Hips...quickBarBonus......itemSize..............weight......repa
    Offset: 67230 | Contexto: s\belts\Rope_Belt_g.p3d..attachments...Knife..inventorySlot...Hips..itemInfo...Clothing..Hips...quickBarBonus......itemSize..............weight......Dama
================================================================================
PBO: C:\DayZServer\addons\characters_bodies.pbo
Tamanho: 540,281 bytes
  TERMO: slot | ocorrencias: 8
    Offset: 85113 | Contexto: aracters\proxies\rpg7_proxy.002........................slot_melee_rifle............................slot_shoulder_rifle............................slot_sh
    Offset: 85157 | Contexto: ...........slot_melee_rifle............................slot_shoulder_rifle............................slot_shoulder_melee............................spin
    Offset: 85204 | Contexto: ........slot_shoulder_rifle............................slot_shoulder_melee............................spine2........................decay_preload........
================================================================================
PBO: C:\DayZServer\addons\characters_data.pbo
Tamanho: 198,584 bytes
  TERMO: slot | ocorrencias: 125
    Offset: 4451 | Contexto: nBone.RightHand...weaponBone.RightHand_Dummy..inventorySlot...Driver..attachments...Head..Shoulder..Melee..Headgear..Mask..Eyewear..Hands..LeftHand..Glov
    Offset: 8212 | Contexto: ?O.......ammo.MeleeFist_Heavy...range.33.@x......playerSlots...Slot_Shoulder..Slot_Melee..Slot_Vest..Slot_Body..Slot_Hips..Slot_Legs..Slot_Back..Slot_Hea
    Offset: 8220 | Contexto: .ammo.MeleeFist_Heavy...range.33.@x......playerSlots...Slot_Shoulder..Slot_Melee..Slot_Vest..Slot_Body..Slot_Hips..Slot_Legs..Slot_Back..Slot_Headgear..S
================================================================================
PBO: C:\DayZServer\addons\characters_glasses.pbo
Tamanho: 611,507 bytes
  TERMO: slot | ocorrencias: 12
    Offset: 23086 | Contexto: .vehicleClass.Clothing...simulation.clothing..inventorySlot...Eyewear..itemInfo...Clothing..Eyewear...rotationFlags......itemSize..............weight....
    Offset: 25108 | Contexto: .vehicleClass.Clothing...simulation.clothing..inventorySlot...Eyewear..itemInfo...Clothing..Eyewear...rotationFlags.......weight.$....itemSize...........
    Offset: 26307 | Contexto: .vehicleClass.Clothing...simulation.clothing..inventorySlot...Eyewear..itemInfo...Clothing..Eyewear...rotationFlags.......weight.(....itemSize...........
================================================================================
PBO: C:\DayZServer\addons\characters_gloves.pbo
Tamanho: 5,505,207 bytes
  TERMO: slot | ocorrencias: 13
    Offset: 10163 | Contexto: s...model.\DZ\characters\gloves\hands3_m.p3d..inventorySlot...Gloves..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.843
    Offset: 14581 | Contexto: s...model.\DZ\characters\gloves\hands3_f.p3d..inventorySlot...Gloves..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.843
    Offset: 23992 | Contexto: l.\DZ\characters\gloves\working_gloves_g.p3d..inventorySlot...Gloves...simulation.clothing..itemInfo...Clothing..Gloves...rotationFlags."....repairableWi
================================================================================
PBO: C:\DayZServer\addons\characters_headgear.pbo
Tamanho: 4,640,361 bytes
  TERMO: priority | ocorrencias: 6
    Offset: 1226573 | Contexto: ..c...AnimEvents.Kc....soundVoiceType.none...soundVoicePriority......c.....GlobalHealth.Ba...b.....Health.Ta...b......hitpoints.2....healthLevels........?...DZ\c
    Offset: 1232925 | Contexto: ..}...Protection..~....soundVoiceType.none...soundVoicePriority......~.....Beam..z...z.....color......?....?.........?..brightness....?..radius.......angle.F....
    Offset: 1234842 | Contexto: AnimEvents.[.....soundVoiceType.motohelmet...soundVoicePriority.............male.\DZ\characters\headgear\MotoHelmet.p3d...female.\DZ\characters\headgear\MotoHelm
  TERMO: slot | ocorrencias: 64
    Offset: 1208584 | Contexto: .repairableWithKits........repairCosts......A.inventorySlot...Headgear...simulation.clothing...vehicleClass.Clothing..itemInfo...Clothing..Headgear...vis
    Offset: 1215158 | Contexto: adCover_improvised_g.p3d...rotationFlags......inventorySlot...Headgear...simulation.clothing...vehicleClass.Clothing..itemInfo...Clothing..Headgear...vis
    Offset: 1216654 | Contexto: Z\characters\headgear\BaseballCap_ground.p3d..inventorySlot...Headgear...simulation.clothing...vehicleClass.Clothing..itemInfo...Clothing..Headgear...vis
================================================================================
PBO: C:\DayZServer\addons\characters_heads.pbo
Tamanho: 1,539,091 bytes
  TERMO: slot | ocorrencias: 1
    Offset: 80580 | Contexto: ame.head...descriptionShort.engine head base..inventorySlot...Head...simulation.head.hU..Head....scope.......displayName.face...descriptionShort.for test
================================================================================
PBO: C:\DayZServer\addons\characters_masks.pbo
Tamanho: 1,195,258 bytes
  TERMO: priority | ocorrencias: 7
    Offset: 309947 | Contexto: mpactType.plastic...soundVoiceType.gasmask...soundVoicePriority............GlobalHealth.....E......Health.....E.......hitpoints.x....healthLevels........?...DZ\c
    Offset: 311609 | Contexto: .L....AnimEvents.~.....soundVoiceType.none...soundVoicePriority............GlobalHealth............Health.............hitpoints.2....healthLevels........?...DZ\c
    Offset: 321284 | Contexto: ...AnimEvents.!6....soundVoiceType.gasmask...soundVoicePriority......6.....GlobalHealth.N4...5.....Health.`4...5......hitpoints.P....healthLevels........?...DZ\c
  TERMO: slot | ocorrencias: 16
    Offset: 309125 | Contexto: 1...model.\DZ\characters\masks\GasMask_g.p3d..inventorySlot...Mask...simulation.clothing...vehicleClass.Clothing..itemInfo...Clothing..Mask..repairableWi
    Offset: 311091 | Contexto: del.\DZ\characters\masks\NioshFaceMask_g.p3d..inventorySlot...Mask..itemInfo...Clothing..Mask...rotationFlags.......weight......itemSize..............var
    Offset: 312488 | Contexto: ..model.\DZ\characters\masks\Balaclava_g.p3d..inventorySlot...Mask..itemInfo...Clothing..Mask...rotationFlags.......weight......itemSize..............rag
================================================================================
PBO: C:\DayZServer\addons\characters_pants.pbo
Tamanho: 4,402,342 bytes
  TERMO: slot | ocorrencias: 28
    Offset: 1106523 | Contexto: se0...model.\DZ\characters\pants\legs3_m.p3d..inventorySlot...Legs..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.84313
    Offset: 1110928 | Contexto: se0...model.\DZ\characters\pants\legs3_f.p3d..inventorySlot...Legs..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.84313
    Offset: 1120309 | Contexto: und.p3d..ContinuouActions...AT_WRING_CLOTHES..inventorySlot...Legs...simulation.clothing..itemInfo...Clothing..Legs..itemSize.............itemsCargoSize.
================================================================================
PBO: C:\DayZServer\addons\characters_shoes.pbo
Tamanho: 2,407,099 bytes
  TERMO: slot | ocorrencias: 21
    Offset: 842013 | Contexto: se0...model.\DZ\characters\shoes\feet3_m.p3d..inventorySlot...Feet..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.84313
    Offset: 846418 | Contexto: se0...model.\DZ\characters\shoes\feet3_f.p3d..inventorySlot...Feet..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.84313
    Offset: 855994 | Contexto: DZ\characters\shoes\athleticShoes_ground.p3d..inventorySlot...Feet..itemInfo...Clothing..Feet..itemSize..............weight.J.....durability...L>..varWet
================================================================================
PBO: C:\DayZServer\addons\characters_tops.pbo
Tamanho: 6,204,922 bytes
  TERMO: slot | ocorrencias: 49
    Offset: 689344 | Contexto: se0...model.\DZ\characters\tops\torso3_m.p3d..inventorySlot...Body..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.84313
    Offset: 693686 | Contexto: se0...model.\DZ\characters\tops\torso3_f.p3d..inventorySlot...Body..hiddenSelections...personality..hiddenSelectionsTextures...#(argb,8,8,3)color(0.84313
    Offset: 700046 | Contexto: ..model.\DZ\characters\tops\DownJacket_g.p3d..inventorySlot...Body..itemInfo...Clothing..Body...weight......itemSize.............itemsCargoSize..........
================================================================================
PBO: C:\DayZServer\addons\characters_vests.pbo
Tamanho: 1,869,323 bytes
  TERMO: slot | ocorrencias: 20
    Offset: 249684 | Contexto: eA..VestGrenadeB..VestGrenadeC..VestGrenadeD..inventorySlot...Vest..itemInfo...Clothing..Vest...weight......itemSize..............quickBarBonus.......var
    Offset: 254948 | Contexto: eA..VestGrenadeB..VestGrenadeC..VestGrenadeD..inventorySlot...Vest..itemInfo...Clothing..Vest...weight......itemSize.............itemsCargoSize..........
    Offset: 256398 | Contexto: eA..VestGrenadeB..VestGrenadeC..VestGrenadeD..inventorySlot...Vest..itemInfo...Clothing..Vest...weight.X....itemSize.............itemsCargoSize..........
================================================================================
PBO: C:\DayZServer\addons\characters_zombies.pbo
Tamanho: 3,915,687 bytes
  TERMO: slot | ocorrencias: 16
    Offset: 597950 | Contexto: FilterTimeout....?..lookAtFilterSpeed....?.&.....playerSlots...Slot_Vest..Slot_Back..Slot_Headgear..Slot_Eyewear..&.....itemsCargoSize..............allow
    Offset: 597958 | Contexto: meout....?..lookAtFilterSpeed....?.&.....playerSlots...Slot_Vest..Slot_Back..Slot_Headgear..Slot_Eyewear..&.....itemsCargoSize..............allowOwnedCar
    Offset: 597969 | Contexto: .lookAtFilterSpeed....?.&.....playerSlots...Slot_Vest..Slot_Back..Slot_Headgear..Slot_Eyewear..&.....itemsCargoSize..............allowOwnedCargoManipulat
================================================================================
PBO: C:\DayZServer\addons\dz.pbo
Tamanho: 2,270,036 bytes
  TERMO: priority | ocorrencias: 12
    Offset: 130862 | Contexto: ....OpticsCHAbera3.....,.......type.ColorCorrections...priority......params..............................................?...L>....?...K>..E.?..x.=.............t
    Offset: 130991 | Contexto: ..?...K>..E.?..x.=.............type.ColorCorrections...priority......params..............................................?...L>...L?...K>....>..x.=.....w.......t
    Offset: 131113 | Contexto: ...L>...L?...K>....>..x.=.....w.......type.FilmGrain...priority......params.....L=...........33.>..................type.colorInversion...priority......params....
  TERMO: slot | ocorrencias: 14
    Offset: 50956 | Contexto:  types..#define PLUG_UNDEFINED 0..#define PLUG_BATTERY_SLOT 1..#define PLUG_COMMON_APPLIANCE 2..#define PLUG_CROCODILE_PINS 3..#define PLUG_CROCODILE_PIN
    Offset: 51143 | Contexto: CE 5..#define PLUG_BARBED_WIRE 6..#define PLUG_GAS_CAN_SLOT 7..#define PLUG_VEHICLE_BATTERY_PINS 8....// Wetness exposure..#define STOP_WORK_WHEN_DAMP 1.
    Offset: 136001 | Contexto: .....fragility....=..inventoryCondition.true..inventorySlot......cargoClass....targetCategory...itemInfo....absorbency.......heatIsolation......Environme
================================================================================
PBO: C:\DayZServer\addons\gear_camping.pbo
Tamanho: 4,615,454 bytes
  TERMO: connection | ocorrencias: 18
    Offset: 1132809 | Contexto: ocenter.0.canclimb.0.ignorecomponents.1.generateoffmeshconnections.0...............(......G....?............7.5.7.5G............G......;...........;.......;...;...;.
    Offset: 1147312 | Contexto: placement.slopelandcontact.autocenter.0.generateoffmeshconnections.0.....?T|.?T|...(..c........?............7.5.7.5....................@o...h.M....@o...N3.=.x.?o...N
    Offset: 1636943 | Contexto: ent.slopelandcontact.ignorecomponents.1.generateoffmeshconnections.0...............(..;...5....?............7.5.7.55............5......................@.............
  TERMO: connect | ocorrencias: 18
    Offset: 1132809 | Contexto: ocenter.0.canclimb.0.ignorecomponents.1.generateoffmeshconnections.0...............(......G....?............7.5.7.5G............G......;...........;.......;...
    Offset: 1147312 | Contexto: placement.slopelandcontact.autocenter.0.generateoffmeshconnections.0.....?T|.?T|...(..c........?............7.5.7.5....................@o...h.M....@o...N3.=.x.
    Offset: 1636943 | Contexto: ent.slopelandcontact.ignorecomponents.1.generateoffmeshconnections.0...............(..;...5....?............7.5.7.55............5......................@.......
  TERMO: slot | ocorrencias: 238
    Offset: 572125 | Contexto: .$STR_attachment_accessories...description...attachmentSlots...CamoNet..Lights...icon.set:dayz_inventory image:cat_fp_tents...view_index............Body.
    Offset: 580148 | Contexto: .$STR_attachment_accessories...description...attachmentSlots...CamoNet..Lights...icon.set:dayz_inventory image:cat_fp_tents...view_index.....>8.....Body.
    Offset: 587160 | Contexto: .$STR_attachment_accessories...description...attachmentSlots...CamoNet..Lights...icon.set:dayz_inventory image:cat_fp_tents...view_index......S.....Body.
================================================================================
PBO: C:\DayZServer\addons\gear_consumables.pbo
Tamanho: 871,502 bytes
  TERMO: slot | ocorrencias: 38
    Offset: 95857 | Contexto: .....itemSize..............rotationFlags......inventorySlot...Paper...varWetMax....?.DamageSystem......AnimEvents.....^......GlobalHealth............Heal
    Offset: 97166 | Contexto: d....itemSize..............rotationFlags......inventorySlot...Paper..DamageSystem......AnimEvents.2..........GlobalHealth.....2......Health.....2.......h
    Offset: 100689 | Contexto: ncy......itemSize..............varWetMax....?.inventorySlot...Rags..ChangeInventorySlot...Mask..ChangeIntoOnAttach.....MouthRag...canBeSplit.......varQua
================================================================================
PBO: C:\DayZServer\addons\gear_containers.pbo
Tamanho: 379,296 bytes
  TERMO: slot | ocorrencias: 2
    Offset: 123024 | Contexto: avmesh.......canBeDigged.......heavyItem......inventorySlot...Truck_01_Barrel1..Truck_01_Barrel2..Truck_01_Barrel3..Truck_01_Barrel4...weight..'...itemSi
    Offset: 130475 | Contexto: characters\vests\plate_carrier_pouches_g.p3d..inventorySlot...VestPouch...weight......itemSize.............itemsCargoSize.............repairableWithKits.
================================================================================
PBO: C:\DayZServer\addons\gear_cooking.pbo
Tamanho: 592,203 bytes
  TERMO: slot | ocorrencias: 37
    Offset: 62958 | Contexto: attachment_CookingEquipment0...description...attachmentSlots...CookingTripod..CookingEquipment...icon.set:dayz_inventory image:cat_fp_cooking...view_inde
    Offset: 63125 | Contexto: name.$STR_attachment_Smoking...description...attachmentSlots...SmokingA..SmokingB..SmokingC..SmokingD...icon.set:dayz_inventory image:cookingequipment...
    Offset: 63311 | Contexto: attachment_CookingEquipment0...description...attachmentSlots...DirectCookingA..DirectCookingB..DirectCookingC...icon.set:dayz_inventory image:cookingequi
================================================================================
PBO: C:\DayZServer\addons\gear_crafting.pbo
Tamanho: 339,800 bytes
  TERMO: slot | ocorrencias: 16
    Offset: 77331 | Contexto: ces_grayscale image:rope...rotationFlags......inventorySlot...Rope..Material_FPole_Rope..Material_Shelter_Rope..RB_LvL1_Rope..RB_LvL2_Rope..Backpack_1..i
    Offset: 77515 | Contexto: ...soundImpactType.textile..DamageSystem......InventorySlotsOffsets.L....AnimEvents............GlobalHealth.....L......Health.*...L.......hitpoints......
    Offset: 80281 | Contexto: nFlags......itemSize..............weight......inventorySlot...MetalWire..Material_MetalWire..Material_FPole_MetalWire..RB_LvL1_MetalWire..RB_LvL2_MetalWi
================================================================================
PBO: C:\DayZServer\addons\gear_cultivation.pbo
Tamanho: 453,022 bytes
  TERMO: slot | ocorrencias: 426
    Offset: 45696 | Contexto: ......spawnOffset.......lootCategory.Crafted..inventorySlot...SeedBase_1..SeedBase_2..SeedBase_3..SeedBase_4..SeedBase_5..SeedBase_6..SeedBase_7..SeedBas
    Offset: 54889 | Contexto: odel.\dz\gear\cultivation\plant_material.p3d..inventorySlot...Plant...lootCategory.Crafted..itemSize..............rotationFlags.".....weight.......weight
    Offset: 55572 | Contexto: material_destruct.rvmat..0......TexId.......AddEnergyToSlot....?..ConsumedQuantity....B..FertilizeLength.....R1.....SoundWeapon.i1...2.....pickUpItem_Lig
================================================================================
PBO: C:\DayZServer\addons\gear_drinks.pbo
Tamanho: 213,231 bytes
  TERMO: slot | ocorrencias: 8
    Offset: 12772 | Contexto: \drinks\Canteen.p3d...debug_ItemCategory......inventorySlot...Belt_Left..DirectCookingA..DirectCookingB..DirectCookingC...weight......itemSize...........
    Offset: 13519 | Contexto: geSystem......MeleeModes.?....AnimEvents......InventorySlotsOffsets............GlobalHealth.....?......Health.'...?.......hitpoints.d....healthLevels....
    Offset: 15687 | Contexto: .....soundImpactType.plastic..AnimEvents......InventorySlotsOffsets.K...D......GlobalHealth............Health.............hitpoints.2....healthLevels....
================================================================================
PBO: C:\DayZServer\addons\gear_food.pbo
Tamanho: 3,179,679 bytes
  TERMO: slot | ocorrencias: 90
    Offset: 532249 | Contexto: ageSystem......Nutrition......AnimEvents.g....InventorySlotsOffsets.j...c......GlobalHealth............Health.............hitpoints......healthLevels....
    Offset: 534009 | Contexto: ageSystem......Nutrition......AnimEvents.V....InventorySlotsOffsets.J!..C".....GlobalHealth............Health.............hitpoints......healthLevels....
    Offset: 535718 | Contexto: ......varTemperatureMax.i.....absorbency......inventorySlot...Guts...isMeleeWeapon......DamageSystem..$...MeleeModes.%&...Nutrition..&...NoiseImpact.*'..
================================================================================
PBO: C:\DayZServer\addons\gear_medical.pbo
Tamanho: 460,680 bytes
  TERMO: slot | ocorrencias: 12
    Offset: 83375 | Contexto: andage_dressing.p3d...debug_ItemCategory......inventorySlot...MedicalBandage...isMeleeWeapon.......varWetMax....?..quantityBar.......varQuantityDestroyOn
    Offset: 84687 | Contexto: sinfectantSpray.p3d...debug_ItemCategory......inventorySlot...Disinfectant...quantityBar.......varQuantityInit.......varQuantityMin.......varQuantityMax.
    Offset: 86664 | Contexto: .....soundImpactType.glass..DamageSystem......inventorySlot...Nutrition.K....AnimEvents.....O......GlobalHealth.+...K......Health.=...K.......hitpoints..
================================================================================
PBO: C:\DayZServer\addons\gear_navigation.pbo
Tamanho: 629,461 bytes
  TERMO: slot | ocorrencias: 7
    Offset: 173313 | Contexto: .........weight.......simulation.ItemCompass..inventorySlot...WalkieTalkie..Chemlight..DamageSystem.t....AnimationSources.......soundImpactType.glass..An
    Offset: 173434 | Contexto: .......soundImpactType.glass..AnimEvents......InventorySlotsOffsets.....T......GlobalHealth............Health.............hitpoints.F....healthLevels....
    Offset: 174461 | Contexto: .........weight.......simulation.ItemCompass..inventorySlot...WalkieTalkie..Chemlight..DamageSystem......AnimationSources.[.....soundImpactType.plastic..
================================================================================
PBO: C:\DayZServer\addons\gear_optics.pbo
Tamanho: 216,197 bytes
  TERMO: slot | ocorrencias: 3
    Offset: 116161 | Contexto: lay/rangefinder_hud_2.layout..OpticsInfo.f....inventorySlot...WalkieTalkie..Chemlight..attachments...BatteryD..DamageSystem......repairableWithKits......
    Offset: 116324 | Contexto: sts......A.EnergyManager......MeleeModes.c....InventorySlotsOffsets......OpticsModelInfo.......soundImpactType.plastic.........memoryPointCamera.eyeScope
    Offset: 119344 | Contexto: yEncore.....'...ProxyAttachment....scope......inventorySlot...Pistol...model.\dz\gear\optics\binoculars.p3d.'.......destructengine.....destructdefault...
================================================================================
PBO: C:\DayZServer\addons\gear_radio.pbo
Tamanho: 249,042 bytes
  TERMO: slot | ocorrencias: 4
    Offset: 59527 | Contexto: ht.......absorbency....?.itemSize.............inventorySlot...WalkieTalkie..Chemlight...rotationFlags.......oldpower.......isMeleeWeapon......MeleeModes.
    Offset: 59859 | Contexto: ..DamageSystem.......soundImpactType.plastic..InventorySlotsOffsets.V....AnimEvents.....L......Default......Heavy......Sprint.L...{.......ammo.MeleeLight
    Offset: 61022 | Contexto: ht..'....absorbency....?.itemSize.............inventorySlot...Back..ClothingTypes.5.....oldpower.......simulation.itemTransmitter...inputRange.......rang
================================================================================
PBO: C:\DayZServer\addons\gear_tools.pbo
Tamanho: 1,354,374 bytes
  TERMO: slot | ocorrencias: 34
    Offset: 210367 | Contexto: Weapon......itemSize..............weight......inventorySlot...TriggerAlarmClock...soundImpactType.metal..AnimationSources......NoiseAlarmClock......hidde
    Offset: 212077 | Contexto: Weapon......itemSize..............weight......inventorySlot...TriggerKitchenTimer..hiddenSelections...camo..hiddenSelectionsTextures...dz\gear\tools\data
    Offset: 230825 | Contexto: ...........fragility.o..<..itemBehaviour......inventorySlot...Shoulder..Melee...suicideAnim.pitchfork...build_action_type.......dismantle_action_type....
================================================================================
PBO: C:\DayZServer\addons\gear_traps.pbo
Tamanho: 192,898 bytes
  TERMO: slot | ocorrencias: 4
    Offset: 56050 | Contexto: .....itemSize..............itemBehaviour......inventorySlot...IEDExplosiveA..IEDExplosiveB...slopeTolerance....>.yawPitchRollLimit...<....<....<....hidde
    Offset: 62703 | Contexto: ycharge..%..d&..ProxyAttachment....scope......inventorySlot...TrapPrey_1...model.\dz\gear\food\lepus_europaeus_dead.p3d..%..ProxyAttachment....scope.....
    Offset: 62811 | Contexto: us_dead.p3d..%..ProxyAttachment....scope......inventorySlot...Trap_Bait_2...model.\dz\gear\traps\proxy\bait.p3d..%..ProxyAttachment....scope......invento
================================================================================
PBO: C:\DayZServer\addons\sounds_hpp.pbo
Tamanho: 8,578,378 bytes
  TERMO: priority | ocorrencias: 2
    Offset: 6060676 | Contexto: ...?..soundShadersLimit.......spatial.......loop.......priority.....}u\....soundShaders...AnniversaryMusic_Light_SoundShader...volumeFactor.......volumeCurve.Mus
    Offset: 6061010 | Contexto: ...?..soundShadersLimit.......spatial.......loop.......priority......v\....soundShaders...power_station_switch_up_SoundShader...volumeFactor....?..spatial.......
================================================================================
PBO: C:\DayZServer\addons\structures_military.pbo
Tamanho: 19,243,706 bytes
  TERMO: connection | ocorrencias: 22
    Offset: 6912 | Contexto: _smdi.paa................j....Airfield\data\radar_tall_connections.rvmat................jj...Airfield\data\radar_tall_connections_as.paa................j....Airfield
    Offset: 6975 | Contexto: ons.rvmat................jj...Airfield\data\radar_tall_connections_as.paa................j....Airfield\data\radar_tall_connections_co.paa................j....Airfiel
    Offset: 7039 | Contexto: ns_as.paa................j....Airfield\data\radar_tall_connections_co.paa................j....Airfield\data\radar_tall_connections_MC.paa................j....Airfiel
  TERMO: connect | ocorrencias: 22
    Offset: 6912 | Contexto: _smdi.paa................j....Airfield\data\radar_tall_connections.rvmat................jj...Airfield\data\radar_tall_connections_as.paa................j....Ai
    Offset: 6975 | Contexto: ons.rvmat................jj...Airfield\data\radar_tall_connections_as.paa................j....Airfield\data\radar_tall_connections_co.paa................j....A
    Offset: 7039 | Contexto: ns_as.paa................j....Airfield\data\radar_tall_connections_co.paa................j....Airfield\data\radar_tall_connections_MC.paa................j....A
================================================================================
PBO: C:\DayZServer\addons\structures_proxy_parts.pbo
Tamanho: 135,254 bytes
  TERMO: connection | ocorrencias: 2
    Offset: 1696 | Contexto: 3d.............%..j....LightningCond\LightningConductorConnection\LightningConductorConnection.p3d.............%..j....LightningCond\LightningConductorCorner\Lightni
    Offset: 1725 | Contexto: ingCond\LightningConductorConnection\LightningConductorConnection.p3d.............%..j....LightningCond\LightningConductorCorner\LightningConductorCorner.p3d........
  TERMO: connect | ocorrencias: 2
    Offset: 1696 | Contexto: 3d.............%..j....LightningCond\LightningConductorConnection\LightningConductorConnection.p3d.............%..j....LightningCond\LightningConductorCorner\L
    Offset: 1725 | Contexto: ingCond\LightningConductorConnection\LightningConductorConnection.p3d.............%..j....LightningCond\LightningConductorCorner\LightningConductorCorner.p3d..
================================================================================
PBO: C:\DayZServer\addons\structures_residential.pbo
Tamanho: 25,630,439 bytes
  TERMO: connection | ocorrencias: 16
    Offset: 20781563 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........\dz\st
    Offset: 20781592 | Contexto: ingcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........\dz\structures\proxy_buildingparts\
    Offset: 20784662 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....................?..................'AC..@.\..................\dz\st
  TERMO: connect | ocorrencias: 16
    Offset: 20781563 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........
    Offset: 20781592 | Contexto: ingcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........\dz\structures\proxy_building
    Offset: 20784662 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....................?..................'AC..@.\..................
  TERMO: slot | ocorrencias: 55
    Offset: 729184 | Contexto: ..model.DZ\gear\cultivation\tomato_seeds.p3d..inventorySlot...SeedBase_1..SeedBase_2..SeedBase_3..SeedBase_4..SeedBase_5..SeedBase_6..SeedBase_7..SeedBas
    Offset: 14039073 | Contexto: ase_5..seedbase_6..seedbase_7..seedbase_8..seedbase_9..slotcovered_01..slotcovered_02..slotcovered_03..slotcovered_04..slotcovered_05..slotcovered_06..sl
    Offset: 14039089 | Contexto: 6..seedbase_7..seedbase_8..seedbase_9..slotcovered_01..slotcovered_02..slotcovered_03..slotcovered_04..slotcovered_05..slotcovered_06..slotcovered_07..sl
================================================================================
PBO: C:\DayZServer\addons\structures_ruins_bliss.pbo
Tamanho: 15,608,718 bytes
  TERMO: slot | ocorrencias: 1
    Offset: 762737 | Contexto: @. ..F.#.B..#...).B..G.>.*.2..+.A.E.3..'......K.J.M.R..S.L.O.T..T.O.U..U.X.T..V.T.X..Z.V.X..W.].Y..\.].W..U.[.X..a.^.N..Q._.d.b..`.P.e..c.e.P..e.g.`.._.h
================================================================================
PBO: C:\DayZServer\addons\structures_signs.pbo
Tamanho: 8,371,980 bytes
  TERMO: priority | ocorrencias: 2
    Offset: 63061 | Contexto: \sign_pedCrossing.p3d................j.+..Traffic\sign_priority.p3d................j.'..Traffic\sign_priority_new.p3d................jD$..Traffic\sign_railcross_
    Offset: 63107 | Contexto: fic\sign_priority.p3d................j.'..Traffic\sign_priority_new.p3d................jD$..Traffic\sign_railcross_160m.p3d................j?...Traffic\sign_rail
================================================================================
PBO: C:\DayZServer\addons\structures_underground_bliss.pbo
Tamanho: 11,199,255 bytes
  TERMO: connect | ocorrencias: 56
    Offset: 207 | Contexto: ............[8.j._..Corridor\data\underground_corridor_connector_accessories.rvmat.............[8.jh...Corridor\data\underground_corridor_connector_accessories
    Offset: 290 | Contexto: ............[8.jh...Corridor\data\underground_corridor_connector_accessories_mc.paa.............[8.j....Corridor\data\underground_corridor_connector_building_m
    Offset: 374 | Contexto: ............[8.j....Corridor\data\underground_corridor_connector_building_mask.paa.............[8.j....Corridor\data\underground_corridor_connector_building_mc
================================================================================
PBO: C:\DayZServer\addons\vehicles_parts.pbo
Tamanho: 1,183,914 bytes
  TERMO: slot | ocorrencias: 26
    Offset: 331386 | Contexto: it......itemSize..............absorbency......inventorySlot...TruckBattery..LargeBattery...rotationFlags......repairableWithKits........repairCosts......
    Offset: 331585 | Contexto: ttach_SoundSet..carbattery_attach_SoundSet..attachSoundSlot...TruckBattery..LargeBattery..detachSoundSet...carbattery_detach_SoundSet..carbattery_detach_
    Offset: 331704 | Contexto: etach_SoundSet..carbattery_detach_SoundSet..detachSoundSlot...TruckBattery..LargeBattery..EnergyManager......DamageSystem......AnimEvents./...........has
================================================================================
PBO: C:\DayZServer\addons\vehicles_singletrack.pbo
Tamanho: 554,294 bytes
  TERMO: slot | ocorrencias: 56
    Offset: 12853 | Contexto: ....damageFromCoolant................?.......engineBeltSlot.EngineBelt...batterySlot.CarBattery...electricPowerResName.power...electricConsumptionIgnitio
    Offset: 12878 | Contexto: ............?.......engineBeltSlot.EngineBelt...batterySlot.CarBattery...electricPowerResName.power...electricConsumptionIgnition.......electricConsumpti
    Offset: 13750 | Contexto: Wheels.....%......Front.,....Rear.....%.......inventorySlot....animTurn.turnfront...animRotation.wheelfront...animDamper.damperfront...wheelHub.wheel_1_d
================================================================================
PBO: C:\DayZServer\addons\vehicles_water.pbo
Tamanho: 56,337 bytes
  TERMO: slot | ocorrencias: 11
    Offset: 51063 | Contexto: componentNames...dmgZone_chassis..Health......inventorySlots...inventorySlotsCoefs..........hitpoints.X.....transferToGlobalCoef.............displayName.
    Offset: 51080 | Contexto: dmgZone_chassis..Health......inventorySlots...inventorySlotsCoefs..........hitpoints.X.....transferToGlobalCoef.............displayName.$STR_CfgVehicleDm
    Offset: 51334 | Contexto: mgZone_engine..dmgZone_propeller..Health......inventorySlots...Sparkplug..inventorySlotsCoefs......?........hitpoints.,.....transferToGlobalCoef......hea
================================================================================
PBO: C:\DayZServer\addons\vehicles_wheeled.pbo
Tamanho: 18,609,483 bytes
  TERMO: slot | ocorrencias: 300
    Offset: 3605756 | Contexto: Names...dmgZone_window...fatalInjuryCoef......inventorySlots..=.......hitpoints.F.....transferToGlobalCoef......healthLevels........?.....333?........?..
    Offset: 3605956 | Contexto: tNames...dmgZone_doors...fatalInjuryCoef......inventorySlots..........hitpoints.......transferToGlobalCoef......healthLevels........?.....333?........?..
    Offset: 3606669 | Contexto: ....damageFromCoolant................?.......engineBeltSlot.EngineBelt...batterySlot.CarBattery...electricPowerResName.power...electricConsumptionIgnitio
================================================================================
PBO: C:\DayZServer\addons\weapon_lights.pbo
Tamanho: 119,228 bytes
  TERMO: slot | ocorrencias: 5
    Offset: 269 | Contexto: t_TLR.p3d.............M..j....weaponlight_TLR_Mich2001_slothelper.p3d.............M..j....weaponlight_universal.p3d.............M..j"....................
    Offset: 918 | Contexto: versed.......weight.P....itemSize.............inventorySlot...weaponFlashlight..helmetFlashlight..DamageSystem......repairableWithKits........repairCosts
    Offset: 2415 | Contexto: versed.......weight.v....itemSize.............inventorySlot...pistolFlashlight..DamageSystem.^....repairableWithKits........repairCosts......A.hiddenSele
================================================================================
PBO: C:\DayZServer\addons\weapon_magazines.pbo
Tamanho: 1,628,581 bytes
  TERMO: slot | ocorrencias: 49
    Offset: 204723 | Contexto: debug_ItemCategory.......storageCategory......inventorySlot...magazine..magazine2..magazine3..repairableWithKits........repairCosts......A..handheld.true
    Offset: 327223 | Contexto: _20rnd.........ProxyAttachment....scope.......inventorySlot.magazine...model.\dz\weapons\attachments\magazine\magazine_STANAG30.p3d.T...ProxyAttachment..
    Offset: 327344 | Contexto: ANAG30.p3d.T...ProxyAttachment....scope.......inventorySlot.magazine...model.\dz\weapons\attachments\magazine\magazine_pmag_10.p3d.....ProxyAttachment...
================================================================================
PBO: C:\DayZServer\addons\weapon_muzzles.pbo
Tamanho: 336,685 bytes
  TERMO: slot | ocorrencias: 29
    Offset: 181411 | Contexto: y_Base....scope.......debug_ItemCategory......inventorySlot...weaponMuzzle...simulation.ItemSuppressor..itemSize..............selectionFireAnim.zasleh...
    Offset: 182213 | Contexto: y.Attachments..openItemSpillRange.............inventorySlot...weaponBayonetAK..Knife..recoilModifier..................swayModifier..................itemI
    Offset: 182391 | Contexto: .v....MeleeModes.......soundImpactType.metal..InventorySlotsOffsets......AnimEvents............GlobalHealth............Health.............hitpoints......
================================================================================
PBO: C:\DayZServer\addons\weapon_optics.pbo
Tamanho: 4,559,897 bytes
  TERMO: slot | ocorrencias: 38
    Offset: 32991 | Contexto: ................swayModifier..................inventorySlot...weaponOptics...simulation.itemoptics...memoryPointCamera.eyeScope...cameraDir.cameraDir..hi
    Offset: 34406 | Contexto: ................swayModifier..................inventorySlot...weaponOptics..hiddenSelections...camo..hiddenSelectionsTextures...dz\weapons\attachments\da
    Offset: 35622 | Contexto: animClass.Binoculars...simulation.itemoptics..inventorySlot...weaponOptics...selectionFireAnim.zasleh...memoryPointCamera.eyeScope...cameraDir.cameraDir.
================================================================================
PBO: C:\DayZServer\addons\weapon_supports.pbo
Tamanho: 1,708,728 bytes
  TERMO: slot | ocorrencias: 61
    Offset: 583632 | Contexto: m4_oe.p3d...rotationFlags.......reversed......inventorySlot...weaponButtstockM4...weight.b....itemSize.............recoilModifier.....L?...L?...L?.swayMo
    Offset: 584908 | Contexto: m4_mp.p3d...rotationFlags.......reversed......inventorySlot...weaponButtstockM4...weight.J....itemSize.............recoilModifier...fff?.fff?.fff?.swayMo
    Offset: 586192 | Contexto: 4_cqb.p3d...rotationFlags.......reversed......inventorySlot...weaponButtstockM4...weight......itemSize.............recoilModifier...333?.333?.333?.swayMo
================================================================================
PBO: C:\DayZServer\addons\weapons_ammunition.pbo
Tamanho: 797,143 bytes
  TERMO: slot | ocorrencias: 1
    Offset: 574233 | Contexto: ight.......count.......ammo.Bullet_40mm_Base..inventorySlot...IEDExplosiveA..IEDExplosiveB..VestGrenadeA..VestGrenadeB..VestGrenadeC..VestGrenadeD...muzz
================================================================================
PBO: C:\DayZServer\addons\weapons_archery.pbo
Tamanho: 357,220 bytes
  TERMO: slot | ocorrencias: 2
    Offset: 156690 | Contexto: ..Single......NoiseShoot......OpticsInfo......InventorySlotsOffsets.......weaponStateAnim.dz\anims\anm\player\reloads\Crossbow\w_crossbow_states.anm..bon
    Offset: 157468 | Contexto: recoilProne.recoil_crossbow...dispersion...D:..magazineSlot..........strength....@..type.shot.....OpticsInfoRifle....memoryPointCamera.eye..discreteDista
================================================================================
PBO: C:\DayZServer\addons\weapons_explosives.pbo
Tamanho: 290,624 bytes
  TERMO: slot | ocorrencias: 8
    Offset: 39290 | Contexto: enade_Ammo...weight......itemSize.............inventorySlot...IEDExplosiveA..IEDExplosiveB..hiddenSelections...camo..hiddenSelectionsTextures...hiddenSel
    Offset: 42052 | Contexto: inePlacing..itemSize..............weight......inventorySlot...hiddenSelections...LED..hiddenSelectionsTextures...dz\weapons\explosives\data\claymore_co.p
    Offset: 43679 | Contexto: aviour......itemSize..............weight......inventorySlot....slopeTolerance....?..alignHologramToTerain......yawPitchRollLimit...................hologr
================================================================================
PBO: C:\DayZServer\addons\weapons_firearms.pbo
Tamanho: 10,609,341 bytes
  TERMO: slot | ocorrencias: 99
    Offset: 292873 | Contexto: ..SemiAuto......FullAuto......OpticsInfo.<....InventorySlotsOffsets.Q....Particles.......weaponStateAnim.dz\anims\anm\player\reloads\AK101\w_AK101_states
    Offset: 293523 | Contexto: oilProne.recoil_AK101_prone...dispersion.o..;..magazineSlot.magazine.....Mode_FullAuto...soundSetShot1st...AK74_Shot_1st_SoundSet..AK74_Shot_1st_iterior_
    Offset: 294198 | Contexto: oilProne.recoil_AK101_prone...dispersion.o..;..magazineSlot.magazine.<...OpticsInfoRifle..Q......Shoulder.p....Melee............position..........u....#.
================================================================================
PBO: C:\DayZServer\addons\weapons_launchers.pbo
Tamanho: 1,168,652 bytes
  TERMO: slot | ocorrencias: 5
    Offset: 221670 | Contexto: Prone.recoil_flaregun_prone...dispersion....<..magazineSlot.magazine.....LAWBase....scope.......displayName.$STR_cfgWeapons_LAW0...descriptionShort.$STR_
    Offset: 846554 | Contexto: ..modes...Single..Single......OpticsInfo......InventorySlotsOffsets......Particles.G.....weaponStateAnim.dz\anims\anm\player\reloads\M79\w_m79_states.anm
    Offset: 849158 | Contexto: nchers\m79\proxy\dummyscope.p3d...weight......inventorySlot...weaponOpticsAug...reversed......OpticsInfo.............memoryPointCamera.eyeScope...cameraD
================================================================================
PBO: C:\DayZServer\addons\weapons_melee.pbo
Tamanho: 3,810,804 bytes
  TERMO: slot | ocorrencias: 33
    Offset: 79458 | Contexto: ...........itemBehaviour.......fragility...#<.inventorySlot...Shoulder..Melee...lootCategory.Tools..lootTag...Work..Forester..Camping...dismantle_action_
    Offset: 79680 | Contexto: on.......suicideAnim.woodaxe..MeleeModes.W....InventorySlotsOffsets......DamageSystem.......soundImpactType.metal..AnimEvents............Default......Hea
    Offset: 82296 | Contexto: ag...Work..Forester..Camping..itemInfo...Axe..inventorySlot...Backpack_1..openItemSpillRange........(....DamageSystem......MeleeModes.S.....isMeleeWeapon
================================================================================
PBO: C:\DayZServer\addons\weapons_nonlethal.pbo
Tamanho: 265,974 bytes
  TERMO: slot | ocorrencias: 6
    Offset: 1978 | Contexto: it....?..opticsZoomMax..A3?..barrelArmor.......magazineSlot.magazine.....Mode_SemiAuto..c.......strength... A..type.shot.....NonlethalCore...itemSize....
    Offset: 2137 | Contexto: ....cursor.aimGunGhost...cursorAim.aimPistol..inventorySlot...Pistol...animClass.Pistol...armAction.HandGun.....NonlethalCore...itemSize..............cur
    Offset: 2282 | Contexto: .....cursor.aimGunGhost...cursorAim.aimRifle..inventorySlot...Shoulder...animClass.Rifle.........destructengine.....destructdefault.....destructwreck....
================================================================================
PBO: C:\DayZServer\addons\weapons_pistols.pbo
Tamanho: 1,262,898 bytes
  TERMO: slot | ocorrencias: 32
    Offset: 28614 | Contexto: coilProne.recoil_1911_prone...dispersion..t.;..magazineSlot.magazine.....OpticsInfoPistol....memoryPointCamera.eye..discreteDistance.........discreteDist
    Offset: 31199 | Contexto: xy1911.....T...ProxyAttachment....scope.......inventorySlot.pistol...model.\dz\weapons\pistols\1911\1911.p3d.T.......destructengine.....destructdefault..
    Offset: 44138 | Contexto: coilProne.recoil_cz75_prone...dispersion..t.;..magazineSlot.magazine.....OpticsInfoPistol....memoryPointCamera.eye..discreteDistance.........discreteDist
================================================================================
PBO: C:\DayZServer\addons\weapons_shotguns.pbo
Tamanho: 912,414 bytes
  TERMO: slot | ocorrencias: 17
    Offset: 4774 | Contexto: e.......dispersion...#<..firespreadangle....?..magazineSlot.magazine.....OpticsInfoShotgun.........OnFire......OnBulletCasingEject.....u......SmokeCloud.
    Offset: 7133 | Contexto: 8Shotgun.rvmat..DamageSystem......Single.y....InventorySlotsOffsets.{..........GlobalHealth.....y......Health.....y.......hitpoints.,....healthLevels....
    Offset: 47333 | Contexto: .#....Single.D....Double.J....OpticsInfo.u....InventorySlotsOffsets......SecondMuzzle.%....Particles.......weaponStateAnim.dz\anims\anm\player\reloads\IZ
================================================================================
PBO: C:\DayZServer\addons\worlds_chernarusplus.pbo
Tamanho: 235,159,991 bytes
  TERMO: priority | ocorrencias: 2
    Offset: 18115055 | Contexto: es\bridge_wood_50.p3d.dz\structures\signs\traffic\sign_priority_new.p3d.dz\structures\roads\parts\asf3_7 100.p3d.dz\structures\wrecks\vehicles\wreck_sed02_aban2_
    Offset: 18130178 | Contexto: er_pole_conc1_amp.p3d.dz\structures\signs\traffic\sign_priority.p3d.dz\structures\walls\wall_railing_endr.p3d.dz\structures\walls\wall_railing_2_slope.p3d.dz\str
  TERMO: queue | ocorrencias: 2
    Offset: 648146 | Contexto: ."...UER$DAT.RQED.4..T.|.P.."RUUUDDTURDADC.33#v.33...QEQUEUETDEL.h..333213#33]..M.EJ.E%f.TEu.5@...!u.!L..UUQ"UTUDU|...D3....3a.bH..UUE..LS.R.DUz.DD...&3a.&
    Offset: 1020159 | Contexto: ..\..DT.TTU.l.L..""%.QUU%..!RE|..U.43U33"3"&U|.Y..`..!RQUEUEDTQUU\..#3"%V.EDUx.H.."U.ATQ.RU@..5SE3Q!.eV.ED%v.!"Y..T...RU"DUC3E"~.TQ\.x....Q%ReVUDDT.QU%.4CU
================================================================================
PBO: C:\DayZServer\addons\worlds_chernarusplus_ce.pbo
Tamanho: 108,738,678 bytes
  TERMO: login | ocorrencias: 1
    Offset: 84377718 | Contexto: "TimeHopping" type="0" value="60"/>.    <var name="TimeLogin" type="0" value="15"/>.    <var name="TimeLogout" type="0" value="15"/>.    <var name="TimePen
  TERMO: slot | ocorrencias: 3
    Offset: 84138938 | Contexto: age"> <!--was chance="0.30"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 84140499 | Contexto: ity"> <!--was chance="0.20"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 84144053 | Contexto: rmy"> <!--was chance="0.10"; removed coz of attachment slot is missing -->....<item name="TacticalGoggles" chance="0.10" />....<item name="AviatorGlasses
================================================================================
PBO: C:\DayZServer\addons\worlds_enoch.pbo
Tamanho: 237,282,216 bytes
  TERMO: priority | ocorrencias: 2
    Offset: 18863907 | Contexto: k_cncblocks_short.p3d.dz\structures\signs\traffic\sign_priority_new.p3d.dz\structures\signs\misc\sign_roadblock_stop.p3d.dz\structures_bliss\roads\parts\asf1enoc
    Offset: 18895890 | Contexto: ral\statue_enoch1.p3d.dz\structures\signs\traffic\sign_priority.p3d.dz\structures\walls\wall_indvar1_5_d_2.p3d.dz\structures_bliss\residential\slums\slum_house4.
  TERMO: queue | ocorrencias: 1
    Offset: 1520832 | Contexto: 3L....%.""bf"..O.U.S|..""UR...55.U%R"`...1SSUU.QUET..!UQUeUe51..\.@.."".SU5..1.S%R.".X....S.QU@...B..Q3...x.X...D.@...QUU3U.3@.T.T....UU.VU"."|..UUU.33..2"
  TERMO: connect | ocorrencias: 18
    Offset: 18865984 | Contexto: ctures_bliss\underground\corridor\underground_corridor_connector.p3d.dz\structures\ruins\rubble_dirtpile_large.p3d.dz\structures_bliss\underground\tunnel\under
    Offset: 18871485 | Contexto: ctures_bliss\underground\corridor\underground_corridor_connector_inv.p3d.dz\structures_bliss\underground\water\underground_watermaintenance.p3d.dz\structures_b
    Offset: 18971916 | Contexto: ower.p3d.#..D...D.{.D........Land_underground_corridor_connector.dz\structures_bliss\underground\corridor\underground_corridor_connector.p3d..W.D...D...D. ....
================================================================================
PBO: C:\DayZServer\addons\worlds_enoch_ce.pbo
Tamanho: 100,539,910 bytes
  TERMO: login | ocorrencias: 1
    Offset: 75918952 | Contexto: "TimeHopping" type="0" value="60"/>.    <var name="TimeLogin" type="0" value="15"/>.    <var name="TimeLogout" type="0" value="15"/>.    <var name="TimePen
  TERMO: slot | ocorrencias: 3
    Offset: 75679365 | Contexto: age"> <!--was chance="0.30"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 75680926 | Contexto: ity"> <!--was chance="0.20"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 75684628 | Contexto: rmy"> <!--was chance="0.10"; removed coz of attachment slot is missing -->....<item name="TacticalGoggles" chance="0.10" />....<item name="AviatorGlasses
================================================================================
PBO: C:\DayZServer\dta\bin.pbo
Tamanho: 294,513 bytes
  TERMO: connection | ocorrencias: 1
    Offset: 43851 | Contexto: at......Actions......DefaultAction......GroupInfo.%....ConnectionLost......Cursor......PeripheralVision......HitZones............ColNone......ColWhite......ColRed...
  TERMO: connect | ocorrencias: 4
    Offset: 43851 | Contexto: at......Actions......DefaultAction......GroupInfo.%....ConnectionLost......Cursor......PeripheralVision......HitZones............ColNone......ColWhite......Col
    Offset: 55089 | Contexto: playerBriefUnknown.#(argb,8,8,3)color(0,0,0,1)...playerConnecting.#(argb,8,8,3)color(0,0,0,1)........CfgInGameUI......CfgCloudletShapes.............imageCorner
    Offset: 292637 | Contexto: xclude>..  ..  <!-- Inputs excluded when in gamepad disconnect warning screen -->..  <exclude name="gamepaddisconnect">..    <include name="menu" />..  </exclu
  TERMO: slot | ocorrencias: 114
    Offset: 7542 | Contexto: ..model....reversed.......displayWeight.......inventorySlot...attachments....displayName....cargoClass...itemSize..............clothingType....destrType.
    Offset: 8580 | Contexto: Base......DefaultWeapon......DefaultWeapon....inventorySlot.Shoulder..itemSize............. ..DefaultWeapon....inventorySlot.Shoulder..itemSize..........
    Offset: 8645 | Contexto: der..itemSize............. ..DefaultWeapon....inventorySlot.Shoulder..itemSize............] ......access......DefaultAmmo.. ...BulletCore..'...ShotgunCor
================================================================================
PBO: C:\DayZServer\dta\graphics.pbo
Tamanho: 128,013,134 bytes
  TERMO: queue | ocorrencias: 1
    Offset: 58243568 | Contexto: ..... . ."r...0..%"'"i"."....R.Q.....@..@."7...1..o`..;QUeUee.@ ..'@mfCd...............@`...^5U3%2#.@`.. @......0.......@&.%^.%....0..?3$...t...Q.1...".Dp.
================================================================================
PBO: C:\DayZServer\dta\gui.pbo
Tamanho: 149,223,513 bytes
  TERMO: OnEvent | ocorrencias: 3
    Offset: 64323555 | Contexto: etelkatextpro14".        }.        TextWidgetClass ActionEventV {.         position 0.26344 0.96751.         size 0.7039 0.025.         hexactpos 0.         ve
    Offset: 64323772 | Contexto:      text "Test".        }.        TextWidgetClass ActionEventT {.         position 0.02901 0.9669.         size 0.222 0.025.         hexactpos 0.         vexa
    Offset: 64330932 | Contexto: xt "Actions".        }.        TextWidgetClass WeapActionEvents {.         position 4.35675 534.409.         size 0.94581 0.03012.         hexactpos 1.
  TERMO: LoginQueue | ocorrencias: 1
    Offset: 64251422 | Contexto:      "text valign" center.    }.    TextWidgetClass TX_LoginQueue {.     position 0.8071 0.27.     size 0.0892 0.115.     hexactpos 0.     vexactpos 0.     hexactsiz
  TERMO: priority | ocorrencias: 1671
    Offset: 63869187 | Contexto:  hexactpos 1. vexactpos 1. hexactsize 0. vexactsize 0. priority 10. {.  GridSpacerWidgetClass left_panel_spacer {.   ignorepointer 1.   position 40 0.   size 0.2
    Offset: 63869385 | Contexto: os 1.   vexactpos 1.   hexactsize 0.   vexactsize 0.   priority 2.   "no focus" 1.   Padding 10.   Margin 0.   "Size To Content V" 1.   content_halign center.
    Offset: 63884013 | Contexto: os 1.   vexactpos 1.   hexactsize 1.   vexactsize 1.   priority 2.   "no focus" 1.   Padding 8.   Margin 0.   "Size To Content H" 1.   content_halign center.   {
  TERMO: queue | ocorrencias: 4
    Offset: 24956 | Contexto: g_login_time.layout.............;${jS0..layouts\dialog_queue_position.layout.............;${j.+..layouts\examples\ButtonTemplate.layout.............;${j...
    Offset: 64251427 | Contexto: "text valign" center.    }.    TextWidgetClass TX_LoginQueue {.     position 0.8071 0.27.     size 0.0892 0.115.     hexactpos 0.     vexactpos 0.     hexa
    Offset: 64385454 | Contexto: xactsize 0.     style Bold.     text "#str_position_in_queue:".     font "gui/fonts/sdf_MetronBook72".     "exact text" 1.     "exact text size" 32.     "t
  TERMO: reserved | ocorrencias: 33
    Offset: 28101 | Contexto: _area.layout.............;${j....layouts\inventory_new\reserved_icon.layout.............<${j....layouts\inventory_new\wide\cargo_container.layout.............<${
    Offset: 41991 | Contexto: er_reticle_e_ca.edds.meta.............X${j....textures\reserved.edds.............L${jB...textures\reserved.edds.meta.............L${j'...textures\reserved@2x.edd
    Offset: 42034 | Contexto: ...textures\reserved.edds.............L${jB...textures\reserved.edds.meta.............L${j'...textures\reserved@2x.edds.............X${j....textures\reserved@2x.
  TERMO: whitelist | ocorrencias: 14
    Offset: 65965079 | Contexto:        }.         }.        }.        FrameWidgetClass whitelist_setting_container {.         ignorepointer 0.         position 0 0.         size 1 30.         hex
    Offset: 65965304 | Contexto: exactsize 1.         {.          GridSpacerWidgetClass whitelist_setting {.           ignorepointer 0.           position 0 0.           size 1 30.           hexac
    Offset: 65965669 | Contexto:       Rows 1.           {.            FrameWidgetClass whitelist_setting_panel {.             ignorepointer 1.             position 0 0.             size 0.5 0.6.
  TERMO: connection | ocorrencias: 6
    Offset: 22571 | Contexto: y_z_chat_item.layout.............;${j....layouts\day_z_connection_dialogue.layout.............:${j5...layouts\day_z_connection_lost.layout.............;${j....layout
    Offset: 22632 | Contexto: tion_dialogue.layout.............:${j5...layouts\day_z_connection_lost.layout.............;${j....layouts\day_z_digital_lock.layout.............;${j....layouts\day_z
    Offset: 63908136 | Contexto: ctsize 0.     style Bold.     text "#str_layout_dialog_connection_title".     font "gui/fonts/sdf_MetronBook72".     "text color" 1 1 1 1.     "exact text" 1.     "e
  TERMO: connect | ocorrencias: 118
    Offset: 22571 | Contexto: y_z_chat_item.layout.............;${j....layouts\day_z_connection_dialogue.layout.............:${j5...layouts\day_z_connection_lost.layout.............;${j....
    Offset: 22632 | Contexto: tion_dialogue.layout.............:${j5...layouts\day_z_connection_lost.layout.............;${j....layouts\day_z_digital_lock.layout.............;${j....layouts
    Offset: 36917 | Contexto: .layout.............:${j.0..layouts\xbox\day_z_gamepad_connect.layout.............:${j....layouts\xbox\day_z_ingamemenu_xbox.layout.............:${j....layouts
  TERMO: login | ocorrencias: 3
    Offset: 24903 | Contexto: g_input_text.layout.............;${j....layouts\dialog_login_time.layout.............;${jS0..layouts\dialog_queue_position.layout.............;${j.+..layou
    Offset: 64251422 | Contexto:      "text valign" center.    }.    TextWidgetClass TX_LoginQueue {.     position 0.8071 0.27.     size 0.0892 0.115.     hexactpos 0.     vexactpos 0.
    Offset: 64374950 | Contexto: .     hexactsize 1.     vexactsize 1.     text "dialog_login_time.layout".     font "gui/fonts/sdf_MetronLight24".     "exact text" 1.    }.   }.  }.  Pane
  TERMO: slot | ocorrencias: 108
    Offset: 26693 | Contexto: j.+..layouts\inventory_new\day_z_inventory_new_tooltip_slot.layout.............<${j{...layouts\inventory_new\day_z_inventory_new_tooltip_slot_xbox.layout
    Offset: 26775 | Contexto: j{...layouts\inventory_new\day_z_inventory_new_tooltip_slot_xbox.layout.............<${jm...layouts\inventory_new\day_z_inventory_new_tooltip_xbox.layout
    Offset: 27403 | Contexto: ........;${jB...layouts\inventory_new\medium\inventory_slots_container.layout.............;${jJ...layouts\inventory_new\medium\left_area.layout..........
================================================================================
PBO: C:\DayZServer\dta\languagecore.pbo
Tamanho: 5,032,814 bytes
  TERMO: SteamID | ocorrencias: 14
    Offset: 1184978 | Contexto: request","A ticket has already been submitted for this SteamID.","A ticket has already been submitted for this SteamID.","L..stek pro toto SteamID u.. byl odes
    Offset: 1185034 | Contexto: teamID.","A ticket has already been submitted for this SteamID.","L..stek pro toto SteamID u.. byl odesl..n.","Es wurde bereits ein Ticket f..r diese SteamID e
    Offset: 1185062 | Contexto: dy been submitted for this SteamID.","L..stek pro toto SteamID u.. byl odesl..n.","Es wurde bereits ein Ticket f..r diese SteamID eingereicht.",".... ........
  TERMO: queue | ocorrencias: 12
    Offset: 167380 | Contexto: da para a esquerda","L............",.."str_position_in_queue","Position in queue","Position in queue","Pozice ve front..","Position in Warteschlange","....
    Offset: 167400 | Contexto: "L............",.."str_position_in_queue","Position in queue","Position in queue","Pozice ve front..","Position in Warteschlange",".............. .. ......
    Offset: 167420 | Contexto: tr_position_in_queue","Position in queue","Position in queue","Pozice ve front..","Position in Warteschlange",".............. .. ..............","Miejsce w
  TERMO: reserved | ocorrencias: 6
    Offset: 444903 | Contexto: er","Copyright .. 2025 Bohemia Interactive. All rights reserved. Powered by ENFUSION... game engine.","Copyright .. 2025 Bohemia Interactive. All rights reserved
    Offset: 445001 | Contexto: e.","Copyright .. 2025 Bohemia Interactive. All rights reserved. Powered by ENFUSION... game engine.","Copyright .. 2025 Bohemia Interactive. V..echna pr..va vyh
    Offset: 445537 | Contexto: ..","Copyright .. 2025 Bohemia Interactive. All rights reserved. Powered by ENFUSION... game engine.","Copyright .. 2025 Bohemia Interactive. Tutti i diritti ris
  TERMO: whitelist | ocorrencias: 11
    Offset: 520428 | Contexto: ............","JOGADORES","......",.."multi_server_not_whitelisted_message","You are not whitelisted on this server.","You are not whitelisted on this server.","Na
    Offset: 520462 | Contexto: ,.."multi_server_not_whitelisted_message","You are not whitelisted on this server.","You are not whitelisted on this server.","Na tomto serveru nejsi na seznamu po
    Offset: 520504 | Contexto: "You are not whitelisted on this server.","You are not whitelisted on this server.","Na tomto serveru nejsi na seznamu povolen..ch.","Du stehst nicht auf der White
  TERMO: connection | ocorrencias: 49
    Offset: 412892 | Contexto: ETOR DO QUADRANTE","............",.."str_layout_dialog_connection_text","Controls have been disabled until the network connection is restored. Please restore the net
    Offset: 412956 | Contexto: n_text","Controls have been disabled until the network connection is restored. Please restore the network connection or exit to the main menu.","Controls have been d
    Offset: 413007 | Contexto: ork connection is restored. Please restore the network connection or exit to the main menu.","Controls have been disabled until the network connection is restored. P
  TERMO: connect | ocorrencias: 293
    Offset: 49265 | Contexto: ar","......",.."str_titlescreenlayout_text0","Please reconnect and press","Please reconnect and press","Ovlada.. znovu p..ipoj a stisknut..m","Bitte verbinde d
    Offset: 49294 | Contexto: enlayout_text0","Please reconnect and press","Please reconnect and press","Ovlada.. znovu p..ipoj a stisknut..m","Bitte verbinde den Controller erneut und dr..
    Offset: 49511 | Contexto: .......","Po....cz si.. ponownie i wci..nij","Please reconnect and press","Riconnetti il controller e premi","Vuelve a conectarlo y pulsa","Reconnectez-la et a
  TERMO: login | ocorrencias: 11
    Offset: 1169467 | Contexto: .......................",.."STR_player_state_timeout","Login timed out.","Login timed out.","Konec platnosti p..ihl....en...","Zeit..berschreitung beim Log
    Offset: 1169486 | Contexto: ....",.."STR_player_state_timeout","Login timed out.","Login timed out.","Konec platnosti p..ihl....en...","Zeit..berschreitung beim Login.",".......... ..
    Offset: 1169564 | Contexto: c platnosti p..ihl....en...","Zeit..berschreitung beim Login.",".......... ...................... ...............","Up..yn.... limit czasu logowania.","Log
  TERMO: slot | ocorrencias: 204
    Offset: 52179 | Contexto: .........","CONECTADO","......",.."nsw2_inventory_quickslot","Hold in inventory to assign to quickslot","Hold in inventory to assign to quickslot","Podr.
    Offset: 52222 | Contexto: entory_quickslot","Hold in inventory to assign to quickslot","Hold in inventory to assign to quickslot","Podr..en..m v invent....i p..i..adit rychlou poz
    Offset: 52265 | Contexto: ign to quickslot","Hold in inventory to assign to quickslot","Podr..en..m v invent....i p..i..adit rychlou pozici","Im Inventar gedr..ckt halten, um Quic
  TERMO: servermod | ocorrencias: 1
    Offset: 1258372 | Contexto: rveru je nejsp.... po..kozen...","Die Installation des Servermods k..nnte besch..digt sein.",".................. ........ .... .............. .......... ........ .
================================================================================
PBO: C:\DayZServer\dta\scripts.pbo
Tamanho: 14,401,120 bytes
  TERMO: LoginQueueBase | ocorrencias: 8
    Offset: 851534 | Contexto: layerDeathEvent()...{....return false;...}..}....class LoginQueueBase extends LoginScreenBase..{...protected TextWidget m_txtPosition;...protected TextWidget m_txtNote;...pr
    Offset: 851729 | Contexto: _btnLeave;...protected int m_iPosition = -1;......void LoginQueueBase()...{......g_Game.SetKeyboardHandle(this);....}.....void ~LoginQueueBase()...{....g_Game.SetKeyboardHan
    Offset: 851802 | Contexto: .{......g_Game.SetKeyboardHandle(this);....}.....void ~LoginQueueBase()...{....g_Game.SetKeyboardHandle(NULL);....}......override Widget Init()...{......layoutRoot ..= g_Gam
  TERMO: OnClientNewEvent | ocorrencias: 2
    Offset: 14143044 | Contexto: ams;.....Class.CastTo(newParams, params);.....player = OnClientNewEvent(newParams.param1, newParams.param2, newParams.param3);.....if (!player).....{......Debug.Log("ClientNewEv
    Offset: 14149694 | Contexto: ot_ID).Find(attachment_type) > -1;...}......PlayerBase OnClientNewEvent(PlayerIdentity identity, vector pos, ParamsReadContext ctx)...{....string characterType = g_Game.CreateRa
  TERMO: OnClientReadyEvent | ocorrencias: 2
    Offset: 14143751 | Contexto: yEvent: Player is empty");......return;.....}..........OnClientReadyEvent(identity, player);.....InvokeOnConnect(player, identity);.....// Send list of players at all clients.....Sy
    Offset: 14151343 | Contexto: terData());....}........return m_player;...}......void OnClientReadyEvent(PlayerIdentity identity, PlayerBase player)...{....g_Game.SelectPlayer(identity, player);........#ifdef DIA
  TERMO: OnClientDisconnected | ocorrencias: 2
    Offset: 14145207 | Contexto: nEvent: Player is empty");......return;.....}..........OnClientDisconnectedEvent(identity, player, logoutTime, authFailed);.....break;.........case LogoutCancelEventTypeID:.....LogoutCa
    Offset: 14152390 | Contexto: er)....{.....player.OnReconnect();....}...}.......void OnClientDisconnectedEvent(PlayerIdentity identity, PlayerBase player, int logoutTime, bool authFailed)...{....bool disconnectNow =
  TERMO: OnEvent | ocorrencias: 1492
    Offset: 286396 | Contexto: age example:...@code...int m_DbgEventCount = 0;...void OnEvent(EventType eventTypeId, Param params)...{....m_DbgEventCount++;......DbgUI.BeginCleanupScope();..
    Offset: 509645 | Contexto: et w, Widget child);...bool OnUpdate(Widget w);...bool OnEvent(EventType eventType, Widget target, int parameter0, int parameter1);..};....//Common Widget API.
    Offset: 575410 | Contexto: ss to get parameters for particular event....*/...void OnEvent(EventType eventTypeId, Param params)...{....Print("OnEvent");...}...../**...\brief Called after
  TERMO: OnConnect | ocorrencias: 14
    Offset: 895514 | Contexto: level != m_ConnectivityStatsStates[type])....{.....if (OnConnectivityStatChange(type, level, m_ConnectivityStatsStates[type]))//before setting the prev. level to b
    Offset: 895780 | Contexto: ates[type] = level;.....}....}...}......protected bool OnConnectivityStatChange(EConnectivityStatType type, EConnectivityStatLevel newLevel, EConnectivityStatLevel
    Offset: 10184527 | Contexto: ...}......m_PlayerOldPos = GetPosition();...}.....void OnConnect()...{....Debug.Log("Player connected:"+this.ToString(),"Connect");......// analytics....g_Game.Get
  TERMO: OnDisconnect | ocorrencias: 5
    Offset: 10185063 | Contexto: ta........ResetConstructionActionData();...}......void OnDisconnect()...{....Debug.Log("Player disconnected:"+this.ToString(),"Connect");........// analytics....// force
    Offset: 14146067 | Contexto: if (player).....player.OnConnect();...}.....void InvokeOnDisconnect(PlayerBase player)...{....Debug.Log("InvokeOnDisconnect:"+this.ToString(),"Connect");....if (player).
    Offset: 14146123 | Contexto: nDisconnect(PlayerBase player)...{....Debug.Log("InvokeOnDisconnect:"+this.ToString(),"Connect");....if (player).....player.OnDisconnect();...}.....void OnClientPrepareE
  TERMO: GetPlainId | ocorrencias: 5
    Offset: 737874 | Contexto: ....continue;.....}.......sync_player.m_UID = identity.GetPlainId();.....sync_player.m_PlayerName = identity.GetPlainName();....}...}.....static void SyncEvent_OnRec
    Offset: 780578 | Contexto: Identity = identity;......sync_player.m_UID = identity.GetPlainId();......sync_player.m_PlayerName = identity.GetPlainName();......m_PlayerList.Insert(sync_player);.
    Offset: 934701 | Contexto: ute_list.GetElement(i);.........MutePlayer(uid, sender.GetPlainId(), mute);........}.......}.......break;......}............/*......case ERPCs.RPC_SERVER_RESPAWN_MOD
  TERMO: GetIdentity | ocorrencias: 105
    Offset: 704991 | Contexto: YNC, new Param1<CfgGameplayJson>(m_Data), true, player.GetIdentity());...}......//-------------------------------------------------------------------------------------
    Offset: 745719 | Contexto: .{.....SendNotificationToPlayerIdentityExtended(player.GetIdentity(), show_time, title_text, detail_text, icon);....}...}....../**...\brief Send custom notification to
    Offset: 747337 | Contexto: ayer)....{.....SendNotificationToPlayerIdentity(player.GetIdentity(), type, show_time, detail_text);....}...}....../**...\brief Send notification from default types to
  TERMO: GetPlayer | ocorrencias: 973
    Offset: 327307 | Contexto: ..4] matrix to be get....@code.....Man player = g_Game.GetPlayer();........vector mat[4];.....player.GetTransform(mat);.....Print( mat );........>> <0.989879,-0,0.
    Offset: 327722 | Contexto: r[4] matrix to be get....@code.....Man player = g_Game.GetPlayer();........vector mat[4];.....player.GetRenderTransform(mat);.....Print( mat );........>> <0.989879
    Offset: 328164 | Contexto: ..4] matrix to be get....@code.....Man player = g_Game.GetPlayer();........vector mat[4];.....player.GetTransform(mat);.....Print( mat );........>> <0.989879,-0,0.
  TERMO: SteamID | ocorrencias: 2
    Offset: 1514638 | Contexto: tring GetFullName();...//! unique id of player (hashed steamID, database Xbox id...) can be used in database or logs...proto string GetId();...//! plaintext un
    Offset: 1573800 | Contexto: T,.....// A ticket has already been submitted for this steamID...AUTH_INVALID_VERSION,.....// Ticket is from an incompatible interface version...AUTH_GAME_MISM
  TERMO: PlayerIdentity | ocorrencias: 121
    Offset: 638217 | Contexto: .static bool ActivateBillboardSet(string setClassName, PlayerIdentity identity)...{....if (!g_Game).....return false;........if (m_SetIndexCached == -1)....{.....int setCoun
    Offset: 678077 | Contexto: nBunker(proxySpawn);...}......static void SyncDataSend(PlayerIdentity identity)...{....GetGame().RPCSingleParam(null, ERPCs.RPC_BUNKERBROADCAST_CONFIG_SYNC, new Param1<Bunke
    Offset: 705143 | Contexto: -----------------...static void SyncDataSendEx(notnull PlayerIdentity identity)...{....//Debug.Log("SyncDataSendEx");....g_Game.RPCSingleParam(null, ERPCs.RPC_CFG_GAMEPLAY_S
  TERMO: LoginQueue | ocorrencias: 38
    Offset: 851534 | Contexto: layerDeathEvent()...{....return false;...}..}....class LoginQueueBase extends LoginScreenBase..{...protected TextWidget m_txtPosition;...protected TextWidget m_txtNo
    Offset: 851729 | Contexto: _btnLeave;...protected int m_iPosition = -1;......void LoginQueueBase()...{......g_Game.SetKeyboardHandle(this);....}.....void ~LoginQueueBase()...{....g_Game.SetKey
    Offset: 851802 | Contexto: .{......g_Game.SetKeyboardHandle(this);....}.....void ~LoginQueueBase()...{....g_Game.SetKeyboardHandle(NULL);....}......override Widget Init()...{......layoutRoot .
  TERMO: priority | ocorrencias: 318
    Offset: 233157 | Contexto: rnal int GetBackgroundColor();...proto external int GetPriority();...proto external void SetText(string text);...proto external void SetTextColor(int color);...p
    Offset: 233381 | Contexto: id SetBackgroundColor(int color);.../*!...Sets Z order priority....\note Texts with background are always rendered under texts without background....*/...proto e
    Offset: 233503 | Contexto: exts without background....*/...proto external void SetPriority(int priority);..}..../*!..\}..*/..../*!..\addtogroup Debug..\{..*/....enum DebugTextFlags..{...DE
  TERMO: queue | ocorrencias: 930
    Offset: 591498 | Contexto: -;....return false;...}..}..*/../**.. \brief ScriptCallQueue Class provide "lazy" calls - when we don't want to execute function immediately but later duri
    Offset: 591705 | Contexto: ode...class Arkanoid extends Game...{....ref ScriptCallQueue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_Call
    Offset: 591717 | Contexto: Arkanoid extends Game...{....ref ScriptCallQueue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue;....}.
  TERMO: reserved | ocorrencias: 228
    Offset: 518774 | Contexto:  must have all flags set.........it is possible to use reserved flags like EntityFlags.USER1, EntityFlags.USER2, EntityFlags.USER6 for fast finding of entities i
    Offset: 1236450 | Contexto: exChanged;...//Called when an location in this item is reserved (EntityAI item) - cargo...protected ref ScriptInvoker..m_OnSetLock;...//Called when this item is
    Offset: 1236558 | Contexto: ptInvoker..m_OnSetLock;...//Called when this item is unreserved (EntityAI item) - cargo...protected ref ScriptInvoker..m_OnReleaseLock;...//Called when an locati
  TERMO: whitelist | ocorrencias: 28
    Offset: 1568690 | Contexto: hutting down and therefore kicks all players.......NOT_WHITELISTED,.// Player is not whitelisted...NO_IDENTITY,..// No identity received while creating identity...
    Offset: 1568720 | Contexto: ks all players.......NOT_WHITELISTED,.// Player is not whitelisted...NO_IDENTITY,..// No identity received while creating identity...NO_INPUT_INTERFACE, // No inpu
    Offset: 1577983 | Contexto: ;......InsertDialogueErrorProperties(EClientKicked.NOT_WHITELISTED,....."#multi_server_not_whitelisted_message");....InsertDialogueErrorProperties(EClientKicked.NO
  TERMO: connection | ocorrencias: 66
    Offset: 213852 | Contexto: \GUI\Chat\ChatLine.c..............#{j....5_Mission\GUI\ConnectionDialogue.c..............#{jp...5_Mission\GUI\ContinuousActionProgress.c..............#{j....5_Missio
    Offset: 789866 | Contexto: nst int MENU_MISSION_LOADER......= 45;..const int MENU_CONNECTION_DIALOGUE.....= 46;..const int MENU_DIGITAL_CODELOCK......= 47;..const int MENU_UNDERGROUND_TRIGGER_
    Offset: 857754 | Contexto: ......void ~LoginTimeStatic()...{...}..};........class ConnectionLost..{...private ref Widget m_WidgetRoot;...private TextWidget m_TextWidgetTitle;...private float m
  TERMO: connect | ocorrencias: 985
    Offset: 14175 | Contexto: c..............#{jW[..3_Game\Global\ErrorModuleHandler\ConnectErrorClientModule.c..............#{j....3_Game\Global\ErrorModuleHandler\ConnectErrorScriptModule
    Offset: 14255 | Contexto: c..............#{j....3_Game\Global\ErrorModuleHandler\ConnectErrorScriptModule.c..............#{j....3_Game\Global\ErrorModuleHandler\ConnectErrorServerModule
    Offset: 14335 | Contexto: c..............#{j....3_Game\Global\ErrorModuleHandler\ConnectErrorServerModule.c..............#{jM...3_Game\Global\ErrorModuleHandler\ErrorHandlerModule.c....
  TERMO: login | ocorrencias: 204
    Offset: 789186 | Contexto: st int MENU_RADIAL_QUICKBAR......= 29;..const int MENU_LOGIN_QUEUE.......= 30;..const int MENU_SERVER_BROWSER......= 31;..const int MENU_CAMERA_TOOLS......
    Offset: 789500 | Contexto: onst int MENU_INVITE_TIMER.......= 37;..const int MENU_LOGIN_TIME.......= 38;..const int MENU_WARNING_ITEMDROP......= 39;..const int MENU_RESPAWN_DIALOGUE.
    Offset: 850638 | Contexto: sh,sound_set);....return sound_set;...}..};......class LoginScreenBase extends UIScriptedMenu..{...protected ref UiHintPanelLoading m_HintPanel;...protecte
  TERMO: slot | ocorrencias: 6880
    Offset: 26895 | Contexto: ..............#{jpS..3_Game\Systems\Inventory\InventorySlots.c..............#{j~...3_Game\Systems\Inventory\Junctures.c..............#{j. ..3_Game\System
    Offset: 74449 | Contexto: sComponent\ActionComponents\CAContinuousFertilizeGardenSlot.c..............#{j....4_World\Classes\UserActionsComponent\ActionComponents\CAContinuousFill.
    Offset: 76858 | Contexto: UserActionsComponent\ActionComponents\CAContinuousWaterSlot.c..............#{j....4_World\Classes\UserActionsComponent\ActionComponents\CAContinuousWring
  TERMO: servermod | ocorrencias: 59
    Offset: 14347 | Contexto: ...#{j....3_Game\Global\ErrorModuleHandler\ConnectErrorServerModule.c..............#{jM...3_Game\Global\ErrorModuleHandler\ErrorHandlerModule.c..............#{j=+.
    Offset: 760711 | Contexto:  // DEPRECATED...static ref ScriptInvoker............m_ServerModLoadAsyncInvoker.= new ScriptInvoker();......static BiosClientServices............m_ClientServices;
    Offset: 766692 | Contexto: /EBiosError er = m_ClientServices.GetLobbyService().GetServerModList(re.m_Id);......//Print("OnLoadServersAsync GetServerModList returns:" + er);.....//}..........
================================================================================
PBO: C:\DayZServer\dta\system.pbo
Tamanho: 16,042,964 bytes
  TERMO: OnEvent | ocorrencias: 1
    Offset: 13845581 | Contexto:  "&quot;&quot;"/>...</event>...<event name = "AIAnimationEvent">....<arg type = "string" default = "&quot;&quot;"/>...</event>...<event name = "PlaySound">....
================================================================================
PBO: C:\DayZServer\nasdara\addons\ai_nasdara.pbo
Tamanho: 35,742 bytes
  TERMO: slot | ocorrencias: 41
    Offset: 720 | Contexto: h.......proximityAttackRange... @..attackCooldown...@@.SlotCowering......SlotCalmGrazing.$....SlotSiege.f....SlotEating......SlotHunting......SlotCalmRes
    Offset: 738 | Contexto: ttackRange... @..attackCooldown...@@.SlotCowering......SlotCalmGrazing.$....SlotSiege.f....SlotEating......SlotHunting......SlotCalmResting......SlotCalm
    Offset: 759 | Contexto: ckCooldown...@@.SlotCowering......SlotCalmGrazing.$....SlotSiege.f....SlotEating......SlotHunting......SlotCalmResting......SlotCalmTravelling......SlotA
================================================================================
PBO: C:\DayZServer\nasdara\addons\characters_nasdara.pbo
Tamanho: 5,310,747 bytes
  TERMO: slot | ocorrencias: 30
    Offset: 47668 | Contexto: eatherhippack_g.p3d..attachments...Belt_Left..inventorySlot...Hips..itemInfo...Clothing..Hips...quickBarBonus.......weight.T....itemSize.............item
    Offset: 49736 | Contexto: t_proxy.........ProxyAttachment....scope......inventorySlot...Belt_Back...model.\DZ\characters\belts\proxies\belt_back_proxy.p3d.-...ProxyAttachment....s
    Offset: 49853 | Contexto: k_proxy.p3d.-...ProxyAttachment....scope......inventorySlot...Belt_Right...model.\DZ\characters\belts\proxies\belt_right_proxy.p3d.....ProxyAttachment...
================================================================================
PBO: C:\DayZServer\nasdara\addons\gear_nasdara.pbo
Tamanho: 685,613 bytes
  TERMO: slot | ocorrencias: 26
    Offset: 44788 | Contexto: at...soundImpactType.metal..DamageSystem......inventorySlot...Att_CodeLock..Att_CodeLock1_Wood..Att_CodeLock1_Metal..Att_CodeLock2_Wood..Att_CodeLock2_Me
    Offset: 45882 | Contexto: tach_SoundSet..digitallock_Attach_SoundSet..attachSoundSlot...Att_CodeLock..Att_CodeLock1_Wood..Att_CodeLock1_Metal..Att_CodeLock2_Wood..Att_CodeLock2_Me
    Offset: 46952 | Contexto: tach_SoundSet..digitalLock_Detach_SoundSet..detachSoundSlot...Att_CodeLock..Att_CodeLock1_Wood..Att_CodeLock1_Metal..Att_CodeLock2_Wood..Att_CodeLock2_Me
================================================================================
PBO: C:\DayZServer\nasdara\addons\sounds_nasdara.pbo
Tamanho: 18,073,807 bytes
  TERMO: priority | ocorrencias: 2
    Offset: 7032983 | Contexto: ...?..soundShadersLimit.......spatial.......loop.......priority......6_....soundShaders...AnniversaryMusic_Light_SoundShader...volumeFactor.......volumeCurve.Mus
    Offset: 7033317 | Contexto: ...?..soundShadersLimit.......spatial.......loop.......priority.....)8_....soundShaders...power_station_switch_up_SoundShader...volumeFactor....?..spatial.......
================================================================================
PBO: C:\DayZServer\nasdara\addons\structures_industrial_nasdara.pbo
Tamanho: 23,192,523 bytes
  TERMO: connect | ocorrencias: 3
    Offset: 16109 | Contexto: ock_Base.p3d..............V.j....Dam\KirovDam_Penstock_Connector.p3d..............V.j.f..Dam\KirovDam_Penstock_Curved.p3d..............V.j_...Dam\KirovDam_Pens
    Offset: 54201 | Contexto: Obj_KirovDam_Penstock_Base..c...Land_KirovDam_Penstock_Connector..d...StaticObj_KirovDam_Penstock_Curved.~d...StaticObj_KirovDam_Penstock_Manifold..d...StaticO
    Offset: 78062 | Contexto: Z\structures_takistan\Industrial\Dam\KirovDam_Penstock_Connector.p3d.~d..HouseNoDestruct....scope.......model.\DZ\structures_takistan\Industrial\Dam\KirovDam_P
  TERMO: slot | ocorrencias: 12
    Offset: 60522 | Contexto: .d ...!......name.$STR_Rebuilding_Materials..attachmentSlots...RB_LvL1_Rope..RB_LvL1_Stick...icon.set:dayz_inventory_additional image:rope_ladder...selec
    Offset: 60635 | Contexto: ory_additional image:rope_ladder...selection.materials_slot_1.d ......name.$STR_Rebuilding_Materials..attachmentSlots...RB_LvL2_Rope..RB_LvL2_Stick...ico
    Offset: 60692 | Contexto: ot_1.d ......name.$STR_Rebuilding_Materials..attachmentSlots...RB_LvL2_Rope..RB_LvL2_Stick...icon.set:dayz_inventory_additional image:rope_ladder...selec
================================================================================
PBO: C:\DayZServer\nasdara\addons\structures_props_nasdara.pbo
Tamanho: 3,377,496 bytes
  TERMO: slot | ocorrencias: 11
    Offset: 460441 | Contexto: .s#..S$......name.$STR_Rebuilding_Materials..attachmentSlots...RB_LvL1_Log..RB_LvL1_Plank..RB_LvL1_Nail..RB_LvL1_Rope..RB_LvL1_Brick..RB_LvL1_MortarMix..
    Offset: 460608 | Contexto: _inventory_additional image:well...selection.materials_slot_1.S$......can_decay_general......rebuild_rubble..$...rebuild_well..'...rebuild_roof..*..m....
    Offset: 461267 | Contexto: ...'.....related_parts...animation_sources...materials_slot_1..animation_source_behaviors_invert........'.....Material1.Q'...Material2.y'...Material3..'.
================================================================================
PBO: C:\DayZServer\nasdara\addons\structures_residential_nasdara.pbo
Tamanho: 46,958,858 bytes
  TERMO: slot | ocorrencias: 2278
    Offset: 84564 | Contexto: ..soundOpenABit.doorWoodSmallOpenABit..relatedInventorySlots...Att_CodeLock1_Wood..Att_CombinationLock1_Wood...lockCompatibilityBitMask.......doorConstru
    Offset: 85024 | Contexto: .soundOpenABit.doorMetalSmallOpenABit..relatedInventorySlots...Att_CodeLock1_Metal..Att_CombinationLock1_Metal...lockCompatibilityBitMask.......doorConst
    Offset: 92725 | Contexto: .x1..42......name.$STR_Rebuilding_Materials..attachmentSlots...RB_LvL1_Log..RB_LvL1_Plank..RB_LvL1_Nail..RB_LvL1_MetalSheet..RB_LvL1_MetalWire...icon.set
================================================================================
PBO: C:\DayZServer\nasdara\addons\structures_roads_nasdara.pbo
Tamanho: 80,652,105 bytes
  TERMO: connect | ocorrencias: 282
    Offset: 31803 | Contexto: sed_multi.rvmat..............c.j....Tunnel\data\tunnel_connected_mc.paa..............c.j....Tunnel\data\tunnel_connector_details.rvmat..............c.j....Tunn
    Offset: 31859 | Contexto: onnected_mc.paa..............c.j....Tunnel\data\tunnel_connector_details.rvmat..............c.j....Tunnel\data\tunnel_connector_details_as.paa..............c.j
    Offset: 31922 | Contexto: r_details.rvmat..............c.j....Tunnel\data\tunnel_connector_details_as.paa..............c.j....Tunnel\data\tunnel_connector_details_mask.paa..............
================================================================================
PBO: C:\DayZServer\nasdara\addons\weapons_nasdara.pbo
Tamanho: 1,039,827 bytes
  TERMO: slot | ocorrencias: 22
    Offset: 20121 | Contexto: _10Rnd..!..."..ProxyAttachment....scope.......inventorySlot.magazine...model.\DZ\weapons_takistan\attachments\magazine\magazine_mp18_drum.p3d..!..ProxyAt
    Offset: 20252 | Contexto: 8_drum.p3d..!..ProxyAttachment....scope.......inventorySlot.magazine...model.\DZ\weapons_takistan\attachments\magazine\magazine_luger_8rnd.p3d..!..ProxyA
    Offset: 20384 | Contexto: r_8rnd.p3d..!..ProxyAttachment....scope.......inventorySlot.magazine...model.\DZ\weapons_takistan\attachments\magazine\magazine_leeEnfield_10Rnd.p3d.."..
================================================================================
PBO: C:\DayZServer\nasdara\addons\worlds_nasdara_ce.pbo
Tamanho: 101,196,419 bytes
  TERMO: OnConnect | ocorrencias: 4
    Offset: 85487614 | Contexto: elay>10</delay>..        <repeat>50</repeat>..        <onconnect>1</onconnect>..        <text>Check our web page at www.dayz.com</text>..    </message>......4) fol
    Offset: 85487627 | Contexto: y>..        <repeat>50</repeat>..        <onconnect>1</onconnect>..        <text>Check our web page at www.dayz.com</text>..    </message>......4) following messag
    Offset: 85487853 | Contexto: t....    <message>..        <delay>2</delay>..        <onconnect>1</onconnect>..        <text>Welcome to my server #name</text>..    </message>..    -->....</messa
  TERMO: connect | ocorrencias: 8
    Offset: 84263218 | Contexto:        {.            "Comment": "HWTunnel_EastEntrance_Connector_Outter",.            "CustomSpawn": 0,.            "Position": [.                5414.714,.
    Offset: 84290752 | Contexto:  ].        },.        {.            "Comment": "Palace_Connector",.            "CustomSpawn": 0,.            "Position": [.                10101.629,.
    Offset: 85487523 | Contexto: nutes to every player..    and 10 minutes after player connect....    <message>..        <delay>10</delay>..        <repeat>50</repeat>..        <onconnect>1</
  TERMO: login | ocorrencias: 4
    Offset: 84033197 | Contexto: filled in, the group will only be active for that many logins..                The system will choose a new group once this counter has reached 0..
    Offset: 84042099 | Contexto: filled in, the group will only be active for that many logins..                The system will choose a new group once this counter has reached 0..
    Offset: 84050998 | Contexto: filled in, the group will only be active for that many logins..                The system will choose a new group once this counter has reached 0..
  TERMO: slot | ocorrencias: 3
    Offset: 84067081 | Contexto: age"> <!--was chance="0.30"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 84068464 | Contexto: ity"> <!--was chance="0.20"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 84071466 | Contexto: rmy"> <!--was chance="0.10"; removed coz of attachment slot is missing -->....<item name="TacticalGoggles" chance="0.10" />....<item name="AviatorGlasses
================================================================================
PBO: C:\DayZServer\sakhal\addons\structures_sakhal.pbo
Tamanho: 34,823,592 bytes
  TERMO: connection | ocorrencias: 16
    Offset: 25075611 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........\dz\st
    Offset: 25075640 | Contexto: ingcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........\dz\structures\proxy_buildingparts\
    Offset: 25078710 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....................?..................'AC..@.\..................\dz\st
  TERMO: connect | ocorrencias: 16
    Offset: 25075611 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........
    Offset: 25075640 | Contexto: ingcond\lightningconductorconnection\lightningconductorconnection....?...............?...............?..'.C..@v5......n...........\dz\structures\proxy_building
    Offset: 25078710 | Contexto: es\proxy_buildingparts\lightningcond\lightningconductorconnection\lightningconductorconnection....................?..................'AC..@.\..................
  TERMO: slot | ocorrencias: 1
    Offset: 199798 | Contexto: ........name.Generator parts...description...attachmentSlots...GlowPlug...icon.set:dayz_inventory image:glowplug...view_index.............hasIcon.......a
================================================================================
PBO: C:\DayZServer\sakhal\addons\worlds_sakhal_ce.pbo
Tamanho: 93,011,396 bytes
  TERMO: login | ocorrencias: 4
    Offset: 83963272 | Contexto: filled in, the group will only be active for that many logins..                The system will choose a new group once this counter has reached 0..
    Offset: 83973120 | Contexto: filled in, the group will only be active for that many logins..                The system will choose a new group once this counter has reached 0..
    Offset: 83982970 | Contexto: filled in, the group will only be active for that many logins..                The system will choose a new group once this counter has reached 0..
  TERMO: slot | ocorrencias: 3
    Offset: 83999456 | Contexto: age"> <!--was chance="0.30"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 84001067 | Contexto: ity"> <!--was chance="0.20"; removed coz of attachment slot is missing -->....<item name="ThickFramesGlasses" chance="0.10" />....<item name="ThinFramesG
    Offset: 84004367 | Contexto: rmy"> <!--was chance="0.10"; removed coz of attachment slot is missing -->....<item name="TacticalGoggles" chance="0.10" />....<item name="AviatorGlasses

================================================================================
RESUMO
================================================================================
Total de PBOs encontrados: 188
PBOs com termos reconheciveis: 105
Erros de leitura: 0
Nenhum PBO foi extraido ou modificado.


==================================================
3. FIM DA AUDITORIA
==================================================
Nenhum arquivo foi criado ou alterado.
