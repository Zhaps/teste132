
===========================================================================
PBO: C:\DayZServer\@CF\addons\scripts.pbo
Tamanho: 438303 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
            auto objectRadius = object.C
        for(int nObject = 0; nObject < unhidden.C
        if (updatePathGraph && object.C
        m_HiddenObjects.C
        m_HiddenObjectsArray.C
        object.C
        return m_HiddenObjects.C
     * Object hidden = CF.ObjectManager.H
     * [CF_EventSubscriber(ScriptCaller.C
     * [CF_MultiEventSubscriber(ScriptCaller.C
     * array<Object> hidden = CF.ObjectManager.H
 *  int count = str.C
 * EnMath.c
 * under the key  m_WidgetTimers.C
 * www.dayzexpansion.c
// DO NOT REMOVE!!! For some reason without this there is a compile error cf_eventhandler.c
//! 1.30 Experimental broke $ placeholders and bwd slash usage in FindFile, see https://report.bistudio.c
//! Attempt fix if player is not in modstorageplayers.bin
//! Strip '/mission.c
//g_Game.GameScript.C
//g_Script.C
1_Core\CommunityFramework\CF_Byte.c
1_Core\CommunityFramework\CF_Cast.c
1_Core\CommunityFramework\CF_Encoding.c
1_Core\CommunityFramework\CF_Operations.c
1_Core\CommunityFramework\CF_PackedByte.c
1_Core\CommunityFramework\CF_SeekOrigin.c
1_Core\CommunityFramework\CF_String.c
1_Core\CommunityFramework\CF_Uint.c
1_Core\CommunityFramework\EventArgs\CF_EventArgs.c
1_Core\CommunityFramework\EventArgs\CF_EventTimeArgs.c
1_Core\CommunityFramework\EventArgs\CF_EventUpdateArgs.c
1_Core\CommunityFramework\Files\CF_Directory.c
1_Core\CommunityFramework\Files\CF_File.c
1_Core\CommunityFramework\Files\CF_Path.c
1_Core\CommunityFramework\IO\CF_Base16Stream.c
1_Core\CommunityFramework\IO\CF_Base64Stream.c
1_Core\CommunityFramework\IO\CF_BinaryReader.c
1_Core\CommunityFramework\IO\CF_BinaryWriter.c
1_Core\CommunityFramework\IO\CF_FileStream.c
1_Core\CommunityFramework\IO\CF_IO.c
1_Core\CommunityFramework\IO\CF_SerializerStream.c
1_Core\CommunityFramework\IO\CF_Stream.c
1_Core\CommunityFramework\IO\CF_StringStream.c
1_Core\CommunityFramework\IO\CF_TextReader.c
1_Core\CommunityFramework\IO\CF_TextWriter.c
1_Core\CommunityFramework\Logging\CF_Log.c
1_Core\CommunityFramework\Logging\CF_LogLevel.c
1_Core\CommunityFramework\Logging\CF_TimestampHelperCore.c
1_Core\CommunityFramework\Logging\CF_Trace.c
1_Core\CommunityFramework\Module\CF_ModuleCore.c
1_Core\CommunityFramework\Module\CF_ModuleCoreEvent.c
1_Core\CommunityFramework\Module\CF_ModuleCoreManager.c
1_Core\CommunityFramework\Module\CF_Modules.c
1_Core\CommunityFramework\Module\CF_RegisterModule.c
1_Core\CommunityFramework\TypeConverter\CF_RegisterTypeConverter.c
1_Core\CommunityFramework\TypeConverter\CF_TypeConverter.c
1_Core\CommunityFramework\TypeConverter\CF_TypeConverterBase.c
1_Core\CommunityFramework\TypeConverter\CF_TypeConverterT.c
1_Core\CommunityFramework\proto\EnMath.c
2_GameLib\CommunityFramework\Cryptography\CF_SHA256.c
2_GameLib\CommunityFramework\EventHandler\Attributes\CF_EventSubscriber.c
2_GameLib\CommunityFramework\EventHandler\Attributes\CF_MultiEventSubscriber.c
2_GameLib\CommunityFramework\EventHandler\CF_EventHandler.c
2_GameLib\CommunityFramework\LifecycleEvents\CF_LifecycleEvents.c
3_Game\CommunityFramework\Collections\Stack.c
3_Game\CommunityFramework\CommunityFramework.c
3_Game\CommunityFramework\Config\ConfigArray.c
3_Game\CommunityFramework\Config\ConfigArrayParam.c
3_Game\CommunityFramework\Config\ConfigArrayParamArray.c
3_Game\CommunityFramework\Config\ConfigArrayParamFloat.c
3_Game\CommunityFramework\Config\ConfigArrayParamInt.c
3_Game\CommunityFramework\Config\ConfigArrayParamLong.c
3_Game\CommunityFramework\Config\ConfigArrayParamText.c
3_Game\CommunityFramework\Config\ConfigClass.c
3_Game\CommunityFramework\Config\ConfigEntry.c
3_Game\CommunityFramework\Config\ConfigFile.c
3_Game\CommunityFramework\Config\ConfigReader.c
3_Game\CommunityFramework\Config\ConfigValue.c
3_Game\CommunityFramework\Config\ConfigValueFloat.c
3_Game\CommunityFramework\Config\ConfigValueInt.c
3_Game\CommunityFramework\Config\ConfigValueLong.c
3_Game\CommunityFramework\Config\ConfigValueText.c
3_Game\CommunityFramework\Config\ConfigValueTypes.c
3_Game\CommunityFramework\Credits\CreditsLoader.c
3_Game\CommunityFramework\DoublyLinkedNodes\CF_DoublyLinkedNode.c
3_Game\CommunityFramework\DoublyLinkedNodes\CF_DoublyLinkedNode_WeakRef.c
3_Game\CommunityFramework\DoublyLinkedNodes\CF_DoublyLinkedNodes.c
3_Game\CommunityFramework\DoublyLinkedNodes\CF_DoublyLinkedNodes_WeakRef.c
3_Game\CommunityFramework\EventArgs\CF_EventChatArgs.c
3_Game\CommunityFramework\EventArgs\CF_EventLoginArgs.c
3_Game\CommunityFramework\EventArgs\CF_EventRPCArgs.c
3_Game\CommunityFramework\ExpressionVM\CF_Expression.c
3_Game\CommunityFramework\ExpressionVM\CF_ExpressionCompileToken.c
3_Game\CommunityFramework\ExpressionVM\CF_ExpressionFunction.c
3_Game\CommunityFramework\ExpressionVM\CF_ExpressionInstruction.c
3_Game\CommunityFramework\ExpressionVM\CF_ExpressionStackDebug.c
3_Game\CommunityFramework\ExpressionVM\CF_ExpressionTests.c
3_Game\CommunityFramework\ExpressionVM\CF_ExpressionVM.c
3_Game\CommunityFramework\ExpressionVM\CF_MathExpression.c
... e mais 313 nomes

--- OCORRENCIAS DE TERMOS RELEVANTES ---

Termo: (?i)queue
  Offset: 362808
  Contexto: ....//! (identity will already be removed) and we don't want to use a queued ID at that point....PlayerIdentity identity = GetIdentity();....if (identity)....{.....string id =
  Offset: 363618
  Contexto: .m_CF_IdentityID = id;...}.....string CF_GetIdentityId(bool fallBackToQueue=true)...{....PlayerIdentity currentIdentity = GetIdentity();....string id;......//! Always prefer c

Termo: (?i)getplainid
  Offset: 298620
  Contexto: rom invalid sender!");......return;.....}.......recievedFrom = sender.GetPlainId();....}........map< string, ref RPCMetaWrapper > functions;....if ( m_RPCActions.Find( modName, fun

Termo: (?i)onclientnewevent
  Offset: 370443
  Contexto: tyCreated (engine, not exposed in script)... * 4) 14 s MissionServer::OnClientNewEvent... * 5) PlayerBase::OnSelectPlayer... * 6) MissionServer::InvokeOnConnect... * ... * On connect (ex
  Offset: 371280
  Contexto: ntPrepare (engine, not exposed in script)... * 3) -- s MissionServer::OnClientNewEvent (time varies based on respawnTime)... * 4) PlayerBase::OnSelectPlayer... * 5) MissionServer::Invoke
  Offset: 431616
  Contexto: yerDisconnected( player, identity, uid );...}.....override PlayerBase OnClientNewEvent( PlayerIdentity identity, vector pos, ParamsReadContext ctx )...{....CF_Log.Debug("[CF] MissionServ
  Offset: 431736
  Contexto: pos, ParamsReadContext ctx )...{....CF_Log.Debug("[CF] MissionServer::OnClientNewEvent %1 - ID '%2'", "" + identity, identity.GetId());......PlayerBase player = super.OnClientNewEvent( i
  Offset: 431833
  Contexto: 2'", "" + identity, identity.GetId());......PlayerBase player = super.OnClientNewEvent( identity, pos, ctx );......auto args = new CF_EventNewPlayerArgs(player, identity, pos, ctx);....C

Termo: (?i)onclientreadyevent
  Offset: 371035
  Contexto: rageModule::IsEntity (for each item on player)... * 6) MissionServer::OnClientReadyEvent... * 7) PlayerBase::OnSelectPlayer... * 8) MissionServer::InvokeOnConnect... * ... * On respawn:...
  Offset: 429061
  Contexto: sconnect(this, new CF_EventPlayerArgs(player));...}.....override void OnClientReadyEvent( PlayerIdentity identity, PlayerBase player )...{....CF_Log.Debug("[CF] MissionServer::OnClientRead
  Offset: 429167
  Contexto: dentity, PlayerBase player )...{....CF_Log.Debug("[CF] MissionServer::OnClientReadyEvent - %1 %2 - ID '%3' - player.GetIdentity() = %4", "" + identity, "" + player, identity.GetId(), "" +
  Offset: 429319
  Contexto: "" + player, identity.GetId(), "" + player.GetIdentity());......super.OnClientReadyEvent( identity, player );......CF_ModuleWorldManager.OnClientReady(this, new CF_EventPlayerArgs(player,

Termo: (?i)onclientdisconnected
  Offset: 371451
  Contexto: nServer::InvokeOnConnect... * ... * On logout:... * 1) MissionServer::OnClientDisconnectedEvent (calls OnClientLogout for CF modules)... * 2) MissionServer::OnEvent LogoutCancelEventTypeID (
  Offset: 430141
  Contexto: is, new CF_EventPlayerArgs(player, identity));...}......override void OnClientDisconnectedEvent( PlayerIdentity identity, PlayerBase player, int logoutTime, bool authFailed )...{....CF_Log.D
  Offset: 430287
  Contexto: ogoutTime, bool authFailed )...{....CF_Log.Debug("[CF] MissionServer::OnClientDisconnectedEvent - %1 %2 - ID '%3' - player.GetIdentity() = %4", "" + identity, "" + player, identity.GetId(),
  Offset: 430446
  Contexto: "" + player, identity.GetId(), "" + player.GetIdentity());......super.OnClientDisconnectedEvent( identity, player, logoutTime, authFailed );......auto args = new CF_EventPlayerDisconnectedAr

Termo: (?i)login
  Offset: 5038
  Contexto: rgs.c.....".........Jb"...3_Game\CommunityFramework\EventArgs\CF_EventLoginArgs.c...............Jb....3_Game\CommunityFramework\EventArgs\CF_EventRPCArgs.c.....w.........Jbw..
  Offset: 97119
  Contexto: )...{....CF_ModuleCoreManager.s_Respawn.Add(this);...}.....void EnableLoginTime()...{....CF_ModuleCoreManager.s_LoginTime.Add(this);...}.....void EnableLoginStatus()...{....CF
  Offset: 97161
  Contexto: d(this);...}.....void EnableLoginTime()...{....CF_ModuleCoreManager.s_LoginTime.Add(this);...}.....void EnableLoginStatus()...{....CF_ModuleCoreManager.s_LoginStatus.Add(this)
  Offset: 97201
  Contexto: ..{....CF_ModuleCoreManager.s_LoginTime.Add(this);...}.....void EnableLoginStatus()...{....CF_ModuleCoreManager.s_LoginStatus.Add(this);...}.....void EnableLogout()...{....CF_
  Offset: 97245
  Contexto: this);...}.....void EnableLoginStatus()...{....CF_ModuleCoreManager.s_LoginStatus.Add(this);...}.....void EnableLogout()...{....CF_ModuleCoreManager.s_Logout.Add(this);...}...
  Offset: 98724
  Contexto:  OnRespawn(Class sender, CF_EventArgs args);...../**... * @brief See: LoginTimeEventTypeID... */...void OnLoginTime(Class sender, CF_EventArgs args);....../**... * @brief See:
  Offset: 98760
  Contexto: s args);...../**... * @brief See: LoginTimeEventTypeID... */...void OnLoginTime(Class sender, CF_EventArgs args);....../**... * @brief See: LoginStatusEventTypeID... */...void
  Offset: 98830
  Contexto: LoginTime(Class sender, CF_EventArgs args);....../**... * @brief See: LoginStatusEventTypeID... */...void OnLoginStatus(Class sender, CF_EventArgs args);....../**... * @brief
  Offset: 98868
  Contexto: rgs);....../**... * @brief See: LoginStatusEventTypeID... */...void OnLoginStatus(Class sender, CF_EventArgs args);....../**... * @brief See: LogoutEventTypeID... */...void On
  Offset: 104726
  Contexto: pawn(sender, args);.....}.......evt = evt.m_Next;....}...}.....void OnLoginTime(Class sender, CF_EventArgs args)...{....CF_ModuleCoreEvent evt = this.m_Next;....while (evt)...

Termo: (?i)connection
  Offset: 96947
  Contexto: CF_ModuleCoreManager.s_MPConnectAbort.Add(this);...}.....void EnableMPConnectionLost()...{....CF_ModuleCoreManager.s_MPConnectionLost.Add(this);...}.....void EnableRespawn()...{...
  Offset: 96996
  Contexto: ..}.....void EnableMPConnectionLost()...{....CF_ModuleCoreManager.s_MPConnectionLost.Add(this);...}.....void EnableRespawn()...{....CF_ModuleCoreManager.s_Respawn.Add(this);...}...
  Offset: 98506
  Contexto: ectAbort(Class sender, CF_EventArgs args);...../**... * @brief See: MPConnectionLostEventTypeID... */...void OnMPConnectionLost(Class sender, CF_EventArgs args);...../**... * @brie
  Offset: 98549
  Contexto: ..../**... * @brief See: MPConnectionLostEventTypeID... */...void OnMPConnectionLost(Class sender, CF_EventArgs args);...../**... * @brief See: RespawnEventTypeID... */...void OnRe
  Offset: 104086
  Contexto: rt(sender, args);.....}.......evt = evt.m_Next;....}...}.....void OnMPConnectionLost(Class sender, CF_EventArgs args)...{....CF_ModuleCoreEvent evt = this.m_Next;....while (evt)...
  Offset: 104334
  Contexto: meFlag & CF_ModuleCoreManager.s_GameFlag) != 0).....{......module.OnMPConnectionLost(sender, args);.....}.......evt = evt.m_Next;....}...}.....void OnRespawn(Class sender, CF_Event
  Offset: 107360
  Contexto: t = new CF_ModuleCoreEvent();...static autoptr CF_ModuleCoreEvent s_MPConnectionLost = new CF_ModuleCoreEvent();...static autoptr CF_ModuleCoreEvent s_Respawn = new CF_ModuleCoreEv
  Offset: 112430
  Contexto: ConnectAbort(sender, args);......delete args;...}.....static void OnMPConnectionLost(Class sender, CF_EventArgs args)...{....s_MPConnectionLost.OnMPConnectionLost(sender, args);...
  Offset: 112489
  Contexto: c void OnMPConnectionLost(Class sender, CF_EventArgs args)...{....s_MPConnectionLost.OnMPConnectionLost(sender, args);......delete args;...}.....static void OnRespawn(Class sender,
  Offset: 112508
  Contexto: onLost(Class sender, CF_EventArgs args)...{....s_MPConnectionLost.OnMPConnectionLost(sender, args);......delete args;...}.....static void OnRespawn(Class sender, CF_EventArgs args)

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
PBO: C:\DayZServer\@DabsFramework\addons\Scripts.pbo
Tamanho: 781331 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
                ClientPrepareEventParams client_prepare_event_params = ClientPrepareEventParams.C
                MissionSetting mission_setting = MissionSetting.C
                if (!log_file.C
            GetGame().GetCallQueue(CALL_CATEGORY_GAMEPLAY).C
            float radius = object.C
            if (builder_string.C
            image_serializer.C
            string folder = SystemPath.C
        else if (Eat("-".H
        for (int i = 0; i < data.C
        for (int i = 0; i < paths.C
        for (int j = first_component; j < paths.C
        for (int j = image_data.C
        if      (Eat("+".H
        if (!GetGame().IsMultiplayer() || GetGame().IsDedicatedServer() && !path.Contains("intro") && !path.C
        if (!file_save_string || file_save_string.C
        if (Class.C
        if (m_LaunchSettings.LaunchType & (GameLaunchType.C
        image_serializer.C
        log_file_name_split_minor.C
        return DateTime.C
        return LinearColor.C
        return SystemPath.C
        return uint8.Convert(character[0].H
        string profile_folder = SystemPath.C
        while (FGets(open_file_handle, line_content) > 0 && result.C
    log2 = Msb((int)y); // See: https://stackoverflow.c
// Can't do Param1<T>.Cast(value) or Class.C
// Check DabsFramework/GUI/layouts/sample_mvc2.layout
// Check JM/CF/GUI/layouts/sample_LayoutBindingManager.layout
// Did you know that when the compiler checks for ambiguous types, it uses string.C
// Loads .layout
// This is just a wrapper for "DabsFramework/GUI/layouts/sample_mvc.layout
// https://stackoverflow.c
// https://www.patreon.c
// mainly used so people can do m_EventManager.RegisterEvent() in init.c
//! see <exclude> in bin/specific.xml
//DbgUI.C
//Shape.C
//Sort(RegisteredTypes, RegisteredTypes.C
//float_value = Math.C
//g_Game.GetInput().C
//g_Script.C
//if (file_split.C
//int_value = Math.C
//object.C
//raw_value_float = Math.C
//shape = Shape.C
//string caption = "Open External Link?\n\n(https:\/\/patreon.c
1_Core\DabsFramework\DateTime.c
1_Core\DabsFramework\Enum\LogLevel.c
1_Core\DabsFramework\File\!FileSystem.c
1_Core\DabsFramework\File\Directory.c
1_Core\DabsFramework\File\File.c
1_Core\DabsFramework\File\Path.c
1_Core\DabsFramework\FindWidget.c
1_Core\DabsFramework\Managed\Classes\AttributeBase.c
1_Core\DabsFramework\Managed\Classes\RegisterAction.c
1_Core\DabsFramework\Managed\Classes\RegisterDiagMenu.c
1_Core\DabsFramework\Managed\Classes\RegisterEditorObject.c
1_Core\DabsFramework\Managed\Classes\RegisterLogger.c
1_Core\DabsFramework\Managed\Classes\RegisterMissionSetting.c
1_Core\DabsFramework\Managed\Classes\RegisterPlugin.c
1_Core\DabsFramework\Managed\Classes\RegisterProfileSetting.c
1_Core\DabsFramework\Managed\MemberInfo.c
1_Core\DabsFramework\Managed\MemberInfo\FieldInfo.c
1_Core\DabsFramework\Managed\MemberInfo\MethodInfo.c
1_Core\DabsFramework\Managed\SerializableBase.c
1_Core\DabsFramework\Managed\SerializableParam.c
1_Core\DabsFramework\Math.c
1_Core\DabsFramework\Reinterperet.c
1_Core\DabsFramework\Symbols\Brands.c
1_Core\DabsFramework\Symbols\Symbol.c
1_Core\DabsFramework\Symbols\SymbolHandler.c
1_Core\DabsFramework\Symbols\SymbolSize.c
1_Core\DabsFramework\Symbols\Symbols.c
1_Core\DabsFramework\TemplateType.c
1_Core\DabsFramework\Ternary.c
1_Core\DabsFramework\TimeSpan.c
1_Core\DabsFramework\Workbench.c
1_Core\DabsFramework\proto.c
2_GameLib\DabsFramework\Attributes\AttributeBase\ConfigEntryAttribute.c
3_Game\DabsFramework\!Core\Client\Mods\ModStructure.c
3_Game\DabsFramework\!Core\Client\Notifications\NotificationSystem.c
3_Game\DabsFramework\!Core\Color.c
3_Game\DabsFramework\!Core\ConfigObject.c
3_Game\DabsFramework\!Core\DayZGame.c
3_Game\DabsFramework\!Core\Debug.c
3_Game\DabsFramework\!Core\EnScriptVar.c
3_Game\DabsFramework\!Core\Encoding.c
3_Game\DabsFramework\!Core\Enum\DialogResult.c
3_Game\DabsFramework\!Core\Enum\ERPCs.c
3_Game\DabsFramework\!Core\Enum\EventPhase.c
3_Game\DabsFramework\!Core\Enum\LoggerInstanceMask.c
3_Game\DabsFramework\!Core\Enum\MessageBoxButtons.c
3_Game\DabsFramework\!Core\Enum\TownFlags.c
3_Game\DabsFramework\!Core\Enum\WidgetAnimatorProperty.c
3_Game\DabsFramework\!Core\EventPauseParams.c
3_Game\DabsFramework\!Core\Global\DayZPhysics.c
3_Game\DabsFramework\!Core\HttpArguments.c
... e mais 627 nomes

--- OCORRENCIAS DE TERMOS RELEVANTES ---

Termo: (?i)priority
  Offset: 3723
  Contexto: PositionWithRadius2D.c.....+..........j+...3_Game\DabsFramework\!Core\PriorityQueue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFramew
  Offset: 344530
  Contexto: IVE);....Debug.DrawSphere(Position, 0.25, color);...}..#endif..}class PriorityQueue<Class TElement, Class TPriority>..{...static const TElement ELEMENT_DEFAULT;...static const TP
  Offset: 344567
  Contexto: .25, color);...}..#endif..}class PriorityQueue<Class TElement, Class TPriority>..{...static const TElement ELEMENT_DEFAULT;...static const TPriority PRIORITY_DEFAULT;.....protect
  Offset: 344637
  Contexto: Priority>..{...static const TElement ELEMENT_DEFAULT;...static const TPriority PRIORITY_DEFAULT;.....protected int m_Capacity;...protected ref array<ref Managed> m_StrongRefEleme
  Offset: 344646
  Contexto: ..{...static const TElement ELEMENT_DEFAULT;...static const TPriority PRIORITY_DEFAULT;.....protected int m_Capacity;...protected ref array<ref Managed> m_StrongRefElements = {};
  Offset: 344799
  Contexto: m_StrongRefElements = {};...protected ref array<ref Param2<TElement, TPriority>> m_Elements = {};.....ref ScriptInvoker Event_OnEnqueue = new ScriptInvoker();...ref ScriptInvoker
  Offset: 344956
  Contexto: ;...ref ScriptInvoker Event_OnDequeue = new ScriptInvoker();.....void PriorityQueue(int capacity = 0)...{....m_Capacity = capacity;......if (capacity > 0) {.....// resize the que
  Offset: 345235
  Contexto: capacity);....}...}.....// adds the specified element with associated priority...void Enqueue(TElement item, TPriority priority)...{....if (TemplateType<TElement>.GetType().IsInh
  Offset: 345275
  Contexto: ified element with associated priority...void Enqueue(TElement item, TPriority priority)...{....if (TemplateType<TElement>.GetType().IsInherited(Managed)) {.....// insert anonymo
  Offset: 345284
  Contexto: ment with associated priority...void Enqueue(TElement item, TPriority priority)...{....if (TemplateType<TElement>.GetType().IsInherited(Managed)) {.....// insert anonymously, els

Termo: (?i)queue
  Offset: 3731
  Contexto: WithRadius2D.c.....+..........j+...3_Game\DabsFramework\!Core\PriorityQueue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFramework\!
  Offset: 3786
  Contexto: \!Core\PriorityQueue.c.............7W.j....3_Game\DabsFramework\!Core\Queue.c.....9.......7W.j9...3_Game\DabsFramework\!Core\Ray.c................j....3_Game\DabsFramework\!Co
  Offset: 315997
  Contexto: EventTypeID: return "NetworkManagerServerEventTypeID";.....case DialogQueuedEventTypeID: return "DialogQueuedEventTypeID";.....case ChatMessageEventTypeID: return "ChatMessage
  Offset: 316030
  Contexto: erServerEventTypeID";.....case DialogQueuedEventTypeID: return "DialogQueuedEventTypeID";.....case ChatMessageEventTypeID: return "ChatMessageEventTypeID";.....case ChatChanne
  Offset: 344538
  Contexto: .Debug.DrawSphere(Position, 0.25, color);...}..#endif..}class PriorityQueue<Class TElement, Class TPriority>..{...static const TElement ELEMENT_DEFAULT;...static const TPriori
  Offset: 344859
  Contexto: Element, TPriority>> m_Elements = {};.....ref ScriptInvoker Event_OnEnqueue = new ScriptInvoker();...ref ScriptInvoker Event_OnDequeue = new ScriptInvoker();.....void Priority
  Offset: 344918
  Contexto:  Event_OnEnqueue = new ScriptInvoker();...ref ScriptInvoker Event_OnDequeue = new ScriptInvoker();.....void PriorityQueue(int capacity = 0)...{....m_Capacity = capacity;......
  Offset: 344964
  Contexto: ScriptInvoker Event_OnDequeue = new ScriptInvoker();.....void PriorityQueue(int capacity = 0)...{....m_Capacity = capacity;......if (capacity > 0) {.....// resize the queue ar
  Offset: 345061
  Contexto: ....m_Capacity = capacity;......if (capacity > 0) {.....// resize the queue arrays internally, optimization.....m_StrongRefElements.Reserve(capacity);.....m_Elements.Reserve(c
  Offset: 345253
  Contexto: }.....// adds the specified element with associated priority...void Enqueue(TElement item, TPriority priority)...{....if (TemplateType<TElement>.GetType().IsInherited(Managed)

Termo: (?i)steamid
  Offset: 329494
  Contexto:     return hex;..    }......// todo base64 encoding so we can convert Steamid64 to DayZ ID..}class EnScriptVar<Class T>..{....static T Get(Class instance, string variable_name,
  Offset: 413838
  Contexto: static const int Version = 8;...string MapName;...string AuthorId; // Steamid64 of original author...ref array<string> CreditIds = {}; // SteamId64 of all users that have edited
  Offset: 413906
  Contexto: / Steamid64 of original author...ref array<string> CreditIds = {}; // SteamId64 of all users that have edited / saved this build...DateTime LastModified;...DateTime CreationDate

Termo: (?i)getplainid
  Offset: 340850
  Contexto:      }..        }........return null;...}......// use PlayerIdentity::GetPlainId()...static PlayerIdentity FindByPlainId(string plain_id)...{....array<PlayerIdentity> player_identi
  Offset: 341133
  Contexto: tities.Count(); i++)..        {..            if (player_identities[i].GetPlainId() == plain_id)..            {..                return player_identities[i];..            }..

Termo: (?i)onclientdisconnected
  Offset: 699136
  Contexto: Game.OnIdentityDestroyed(identity, uid);....}...}.......override void OnClientDisconnectedEvent(PlayerIdentity identity, PlayerBase player, int logoutTime, bool authFailed)...{....super.OnCl
  Offset: 699252
  Contexto: ity, PlayerBase player, int logoutTime, bool authFailed)...{....super.OnClientDisconnectedEvent(identity, player, logoutTime, authFailed);........if (m_JoinedPlayers.Find(identity.GetId()) !

Termo: (?i)login
  Offset: 317075
  Contexto: e LogoutCancelEventTypeID: return "LogoutCancelEventTypeID";.....case LoginTimeEventTypeID: return "LoginTimeEventTypeID";.....case RespawnEventTypeID: return "RespawnEventTyp
  Offset: 317105
  Contexto: urn "LogoutCancelEventTypeID";.....case LoginTimeEventTypeID: return "LoginTimeEventTypeID";.....case RespawnEventTypeID: return "RespawnEventTypeID";.....case PreloadEventTyp
  Offset: 317309
  Contexto: ID";.....case LogoutEventTypeID: return "LogoutEventTypeID";.....case LoginStatusEventTypeID: return "LoginStatusEventTypeID";.....case SelectedUserChangedEventTypeID: return
  Offset: 317341
  Contexto:  return "LogoutEventTypeID";.....case LoginStatusEventTypeID: return "LoginStatusEventTypeID";.....case SelectedUserChangedEventTypeID: return "SelectedUserChangedEventTypeID"
  Offset: 708008
  Contexto: o) )]...bool FilePatching;.......[Attribute("", "combobox", "Enable Deloginator", "", ParamEnumArray.FromEnum(YesNo) )]...bool Deloginator;......[Attribute("", "combobox", "Au
  Offset: 708067
  Contexto:  "Enable Deloginator", "", ParamEnumArray.FromEnum(YesNo) )]...bool Deloginator;......[Attribute("", "combobox", "Auto Close Game", "", ParamEnumArray.FromEnum(YesNo) )]...boo
  Offset: 710386
  Contexto: Map = "ChernarusPlus";....settings.FilePatching = true;....settings.Deloginator = true;....settings.AutoClose = true;....settings.LoadMission = true;....settings.Port = 2302;.

Termo: (?i)connection
  Offset: 315611
  Contexto: dyEventTypeID: return "MPSessionPlayerReadyEventTypeID";.....//case MPConnectionLostEventTypeID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return
  Offset: 315648
  Contexto: rReadyEventTypeID";.....//case MPConnectionLostEventTypeID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return "MPConnectionCloseEventTypeID";.....
  Offset: 315687
  Contexto: tionLostEventTypeID: return "MPConnectionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return "MPConnectionCloseEventTypeID";.....case ProgressEventTypeID: return "Progr
  Offset: 315725
  Contexto: ionLostEventTypeID";.....case MPConnectionCloseEventTypeID: return "MPConnectionCloseEventTypeID";.....case ProgressEventTypeID: return "ProgressEventTypeID";.....case NetworkManag
  Offset: 764323
  Contexto: ...string ip, password;....int port;....array<string> args;....if (GetConnectionArguments(ip, port, password, args)) {.....client_launch_params += string.Format(" -connect=%1 -port
  Offset: 767071
  Contexto: RunCmd(game_exe + " " + offline_launch_params);....}...}......bool GetConnectionArguments(out string ip, out int port, out string password, out array<string> args)...{....if ((m_La
  Offset: 768460
  Contexto: tonAttribute("Cancel")]...void Cancel()...{...}......override bool GetConnectionArguments(out string ip, out int port, out string password, out array<string> args)...{......ip = m_
  Offset: 768996
  Contexto: Run();........LaunchGame(m_LaunchSettings);...}......override bool GetConnectionArguments(out string ip, out int port, out string password, out array<string> args)...{....if ((m_La

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
PBO: C:\DayZServer\@VPPAdminTools\addons\VPPAdminTools.pbo
Tamanho: 79657389 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
                        GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).C
                        adminMenu.H
                        banReason += string.Format("\n Expiration Date %1/%2/%3  %4%5%6",expireDate.Year.ToString(),expireDate.Month.ToString(),expireDate.Day.ToString(),expireDate.H
                    DayZPlayer.C
                    GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).C
                    GetGame().GetInput().C
                    HumanCommandScript_VPPCam hcs = HumanCommandScript_VPPCam.C
                    MenuCommandsConsole.C
                    VPPDialogBox dialogBox = GetVPPUIManager().C
                    announceLogin = !GetPlayerListManager().H
                    caller.GetHumanInventory().C
                    caller.GetInventory().C
                    dialogBox.H
                    if (!m_KickQueue.C
                    if(GetPermissionManager().VerifyPermission(id, command.GetPermissionName(), PlayerBase.C
                    rootMenu.C
                AdminTab.H
                Class.C
                DayZPlayerCameraFree cam = DayZPlayerCameraFree.Cast(PlayerBase.C
                DayZPlayerImplement player = DayZPlayerImplement.C
                EspToolsMenu espMenu = EspToolsMenu.Cast(VPPAdminHud.C
                GetGame().C
                GetGame().GetInput().C
                GetTeleportManager().BringPlayer(PlayerBase.C
                HumanCommandScript_VPPCam hcs = HumanCommandScript_VPPCam.C
                VPPAdminHud rootMenu = VPPAdminHud.C
                VPPDialogBox dialogBox = GetVPPUIManager().C
                adminMenu.H
                bool baseType = GetGame().C
                caller.GetHumanInventory().C
                dialogBox.H
                float x1 = fpos[0] + (size * Math.C
                float x2 = fpos[0] + (size * Math.C
                fullPathToConfig = string.Format("$CurrentDir:%1\\%2", output[output.Count() - 2], output[output.C
                if (!m_LogoutQueueInital.Get(player) || !m_LogoutQueueInital.C
                if ((strSearch != "" && (!lowerCasedName.C
                if (Class.C
                if (GetPermissionManager().H
                if(GetPermissionManager().VerifyPermission(id, command.GetPermissionName(), PlayerBase.C
                if(PlayerBase.C
                int scope = GetGame().C
                int total = VPPUIManager.WIDGET_PTRs.C
                itemBase = ItemBase.C
                nextIdx = ((currentIdx - 1) + keys.Count()) % keys.C
                nextIdx = (currentIdx + 1) % keys.C
                player   = PlayerBase.C
                rootMenu.C
                while(line.C
            ChatMessageEventParams chat_params = ChatMessageEventParams.C
            DayZPlayerImplement player = DayZPlayerImplement.C
            EspToolsMenu espMenu = EspToolsMenu.Cast(VPPAdminHud.C
            GetGame().GetCallQueue(CALL_CATEGORY_GUI).C
            GetVPPUIManager().C
            GetVPPUIManager().DisplayNotification(string.Format("The server has no set password! Please read the instructions found within [profile/VPPAdminTools/Permissions/credentials.txt
            PlayerBase playerPB = PlayerBase.C
            PlayerBase playerTarget = PlayerBase.C
            SurvivorBase target = SurvivorBase.C
            TextWidget groupTitle = TextWidget.C
            Transport targetVehicle = Transport.C
            VPPAdminHud AdminTab = VPPAdminHud.C
            VPPAdminHud.Cast(GetVPPUIManager().GetMenuByType(VPPAdminHud)).C
            VPPContextActionManager.C
            adminHud.H
            bool baseType = GetGame().C
            espMenu = EspToolsMenu.Cast(VPPAdminHud.C
            fullPathToConfig = "$CurrentDir:serverDZ.c
            if (!GetGame().C
            if (!objType.C
            if ((strSearch != "" && (!lowerCasedName.C
            if (output && output.C
            if(GetPermissionManager().H
            int nClasses = g_Game.C
            itemEntity = EntityAI.Cast( GetGame().C
            m_DrawCanvasWidget.C
            m_EspCanvasWidget.C
            m_Stats.Insert(str, TextWidget.C
            pos_x = Math.C
            pos_y = Math.C
            return this.h
            t1 = h.Add( e.EP1() ).Add( e.C
        = MapWidget.C
        DayZPlayer player = DayZPlayer.C
        DayZPlayerImplement player = DayZPlayerImplement.C
        EspToolsMenu espMenu = EspToolsMenu.Cast(VPPAdminHud.C
        GetGame().C
        GetGame().GetCallQueue(CALL_CATEGORY_GUI).C
        GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).C
        GetGame().GetInput().C
        GetRPCManager().AddRPC("RPC_HandleFreeCam", "HandleFreeCam", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_HandleMeshEspToggle", "HandleMeshEspToggle", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_MissionGameplay", "ApplyObjectScale", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_MissionGameplay", "AuthCheck", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_MissionGameplay", "EnableToggles", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_MissionGameplay", "EnableTogglesNonPassword", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_MissionGameplay", "LoginAttemptFail", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("RPC_MissionGameplay", "ServerLoginError", this, SingleplayerExecutionType.C
        InventoryItem item = InventoryItem.C
        PlayerBase admin = PlayerBase.C
        PlayerBase player = PlayerBase.C
        VPPAdminHud rootMenu = VPPAdminHud.C
... e mais 4655 nomes

--- OCORRENCIAS DE TERMOS RELEVANTES ---

Termo: (?i)priority
  Offset: 432057
  Contexto: ------------------------..// ADS sight resolution (mode-aware vanilla priority, all off the REMOTE target)..//--------------------------------------------------------------------
  Offset: 2030968
  Contexto: r).....Returning true keeps the HUD select box and the generic window-priority path out of it....*/...override bool OnMouseButtonDown(Widget w, int x, int y, int button)...{....i
  Offset: 2239527
  Contexto: es the map visible: keep it hidden while another admin window has the priority....if (m_BrokenHidden)....{.....m_MapTab.SetMapVisible(false);....}...}..}...protected void ApplyRa
  Offset: 2304527
  Contexto: st the 50 GridSpacer rows are never..// laid out). Keys are chosen by priority (the current filter, the Types scope, files with backups, editable..// types files, other editable
  Offset: 2306916
  Contexto: .SetText(FileEntryText(index));..}...// Adds the session files of one priority pass (0 editable types files, 1 other editable files, 2 the rest)..// in session order until the dr
  Offset: 2509165
  Contexto: LEditor: false while a dialog is open or another admin window has the priority (MapWidget ignores..// z-order, like on the MAP tab)...void SetMapAllowed(bool allowed)..{...m_MapA
  Offset: 2567172
  Contexto: "";....RebuildIssues();...}....UpdateRemoveButton();..}...// State by priority: interrupted, parse/read error, missing, changed outside, restart pending,..// read only, OK...// S
  Offset: 3214815
  Contexto: ..{.......//Call to hide any map widgets, they are stubborn on screen priority.......if (M_SUB_MENUS[x] != subMenu).......{........M_SUB_MENUS[x].HideBrokenWidgets(true);.......}
  Offset: 69361985
  Contexto: ign center_ref. hexactpos 1. vexactpos 1. hexactsize 0. vexactsize 0. priority 85. draggable 0. {.  PanelWidgetClass Panel_Content {.   clipchildren 1.   ignorepointer 1.   posit
  Offset: 69362178
  Contexto:  1 1.   hexactpos 0.   vexactpos 0.   hexactsize 0.   vexactsize 0.   priority 90.  }.  PanelWidgetClass IconsPanel {.   visible 1.   ignorepointer 0.   color 0 0 0 0.784.   posi

Termo: (?i)queue
  Offset: 2152
  Contexto: XEEvents.c.....C.......l..jC...3_Game\VPPAdminTools\XMLEditor\VPPXEJobQueue.c.....`8.........j`8..3_Game\VPPAdminTools\XMLEditor\VPPXEMessages.c......!......J..j.!..3_Game\VPP
  Offset: 74741
  Contexto: _players;...int    bots;...string Map;...string gametype;......int GetQueuedPlayers()...{....string temp = gametype;....temp.Replace("battleye,external,privHive,shard,", "");.
  Offset: 127553
  Contexto: .m_Phase = PHASE_SPLIT;..}...// Splits, then tokenizes, while VPPXEJobQueue.BudgetOk(); true when done (ok or error)...bool Step()..{...if (m_Phase == PHASE_DONE)...{....retur
  Offset: 128860
  Contexto: ue()..{...if (m_Unbudgeted)...{....return true;...}....return VPPXEJobQueue.BudgetOk();..}...void StartParse()..{...m_Lines = m_Splitter.GetLines();...m_CRFlags = m_Splitter.G
  Offset: 175646
  Contexto: min Tools.");....vppatEventHandler = new VPPEventHandler();....GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.RegisterRPCs, 500, false); //Register RPCs after 10 seconds of
  Offset: 180642
  Contexto: 4)....{.....LogoutRequestTime();.....GetMission().Pause();.....GetCallQueue(CALL_CATEGORY_GUI).Call(GetMission().CreateLogoutMenu, GetGame().GetUIManager().GetMenu());.....Get
  Offset: 180751
  Contexto: n().CreateLogoutMenu, GetGame().GetUIManager().GetMenu());.....GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(GetMission().AbortMission, 1000);.....GetCallQueue(CALL_CATEGORY_SY
  Offset: 180834
  Contexto: TEGORY_SYSTEM).CallLater(GetMission().AbortMission, 1000);.....GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.RequestExit, 500, false, 0);....}...}......override void OnKey
  Offset: 184486
  Contexto: RNING, g_Game.GetUIManager().GetMenu());...        ..GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(GetGame().DisconnectSessionForce, 100, false);.......done = true;..
  Offset: 332515
  Contexto: hild>;...SentKeys = new array<string>;..}.};.// Two-lane budgeted job queue (INTERFACES v2.1 section 3). All heavy XML Editor work runs as VPPXEJob steps inside.// a per-frame

Termo: (?i)steam64
  Offset: 73663
  Contexto: ;..};class VPPUser..{...private string m_UserName;...private string m_Steam64ID;...private int    m_SessionId;......void VPPUser(string name, string id, int sessionId = -1)...{.
  Offset: 73798
  Contexto:  name, string id, int sessionId = -1)...{....m_UserName  = name;....m_Steam64ID = id;....m_SessionId = sessionId;...}.......string GetUserId()...{....return m_Steam64ID;...}....
  Offset: 73887
  Contexto: m_SessionId = sessionId;...}.......string GetUserId()...{....return m_Steam64ID;...}......string GetUserName()...{....return m_UserName;...}.....int GetSessionId()...{....return
  Offset: 74176
  Contexto: .class Old_VPPUser..{...private string m_UserName;...private string m_Steam64ID;......void Old_VPPUser(string name, string id)...{...}..};class VPPATSteamAPIResponse..{...ref VP
  Offset: 187545
  Contexto:  password;....}....return m_ConnectPassword;...}......string VPPAT_GetSteam64Id()...{....if ( !m_VPPATOnlineServicesInit )....{.....OnlineServices.Init();.....m_VPPATOnlineServi
  Offset: 226332
  Contexto: ame:", "{{admin.name|default:Unknown}}", true, "");...piece.AddField("Steam64ID:", "{{admin.id}} " + steamLink, true, "");...piece.AddField("Details:", "**{{action}}**", false,
  Offset: 229723
  Contexto: kPiece("Player: {{player.name}} {{action}}", 255);....piece.AddField("Steam64ID:", "{{player.id}}\\n[Steam Profile]({{player.id|steamurl}})", true, "");....piece.AddField("Playe
  Offset: 656332
  Contexto: if (!t)....return false;....return t.GetPlayerId() == g_Game.VPPAT_GetSteam64Id();..}...protected EntityAI HandsOf(VPPContextTarget t)..{...if (!t)....return null;....PlayerBase
  Offset: 670974
  Contexto: );....return false;..}...//RequestInvisibility takes SESSION ids, not steam64s..override bool OnExecuteClient(VPPContextTarget target, VPPContextArgs args)..{...array<int> sessi
  Offset: 746277
  Contexto: target: an id that resolves to an online player must be that player's steam64..protected bool IsCanonicalPlayerId(PermissionManager pm, string playerId)..{...if (playerId == "")

Termo: (?i)steamid
  Offset: 74530
  Contexto: ss VPPATSteamGameServer..{...string addr;...int    gameport;...string steamid;...string name;...int    appid;...string gamedir;...string version;...string product;...int    regi
  Offset: 388588
  Contexto: _BUILD_PART);......GetSimpleLogger().Log(string.Format("Admin \"%1\" (steamId=%2) built part %3 at position: %4", action_data.m_Player.GetIdentity().GetName(), plainId, part_nam
  Offset: 396787
  Contexto: continue;.......if (!GetPermissionManager().HasUserGroup(pb.VPlayerGetSteamId()))......continue;.......GetGame().RPCSingleParam(player, VPPATRPCs.RPC_SYNC_TRANSFER_VALUES, new P
  Offset: 468420
  Contexto: zePlayer;...private string  m_VPlayerName;...private string  m_VPlayerSteamId;...private string  m_VPlayerHashedId;...private int     m_VPlayerSessionId;.....private InvisToggle
  Offset: 469361
  Contexto: ity())....{.....m_VPlayerName = GetIdentity().GetName();.....m_VPlayerSteamId = GetIdentity().GetPlainId();.....m_VPlayerHashedId = GetIdentity().GetId();.....m_VPlayerSessionId
  Offset: 469521
  Contexto: _VPlayerSessionId = GetIdentity().GetPlayerId();.....SetName(m_VPlayerSteamId);....}...}.....override bool CanBeTargetedByAI(EntityAI ai)...{....if (InvisibilityStatus())....{..
  Offset: 474895
  Contexto: VPlayerGetHashedId() { return m_VPlayerHashedId; }...string VPlayerGetSteamId() { return m_VPlayerSteamId; }...string VPlayerGetName() { return m_VPlayerName; }...int VPlayerGet
  Offset: 474923
  Contexto: n m_VPlayerHashedId; }...string VPlayerGetSteamId() { return m_VPlayerSteamId; }...string VPlayerGetName() { return m_VPlayerName; }...int VPlayerGetSessionId() { return m_VPlay
  Offset: 506058
  Contexto: pe()));..                GetSimpleLogger().Log(string.Format("\"%1\" (steamid=%2) deleted object \"%3\" (pos=%4)", sender.GetName(), sender.GetPlainId(), target.GetType(), targe
  Offset: 508244
  Contexto: rue), true, sender);.....GetSimpleLogger().Log(string.Format("\"%1\" (steamid=%2) toggled freecam", sender.GetName(), sender.GetPlainId()));.....GetWebHooksManager().PostData(Ad

Termo: (?i)getplainid
  Offset: 41888
  Contexto: ing from client must have a valid sender........recievedFrom = sender.GetPlainId();.......Param3<string, string, string> serverMetaData;.....if (!ctx.Read(serverMetaData))......ret
  Offset: 71155
  Contexto: ..PLAYERS_CLIENT.Insert(uid, new VPPUser(identity.GetName(), identity.GetPlainId(), identity.GetPlayerId()));....}...}...../*...* Sends entire Sync list to a specified client via R
  Offset: 387553
  Contexto: .....return;......string plainId = action_data.m_Player.GetIdentity().GetPlainId();....if (!GetPermissionManager().VerifyPermission(plainId, "EspToolsMenu:InstantBaseBuild")).....r
  Offset: 469385
  Contexto: rName = GetIdentity().GetName();.....m_VPlayerSteamId = GetIdentity().GetPlainId();.....m_VPlayerHashedId = GetIdentity().GetId();.....m_VPlayerSessionId = GetIdentity().GetPlayerI
  Offset: 473509
  Contexto: ...return;.....if (GetIdentity() == null)......return;.....if (sender.GetPlainId() != GetIdentity().GetPlainId())......return;.......float lookYaw;.....float lookPitch;.....if (!ct
  Offset: 473539
  Contexto: () == null)......return;.....if (sender.GetPlainId() != GetIdentity().GetPlainId())......return;.......float lookYaw;.....float lookPitch;.....if (!ctx.Read(lookYaw))......return;.
  Offset: 473771
  Contexto: (GetSpectateManager())......GetSpectateManager().RelayLookData(sender.GetPlainId(), lookYaw, lookPitch);....}...}.....void VPPSetScaleValue(float scale)...{....if (GetGame().IsServ
  Offset: 505695
  Contexto: r)..        {.....if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "DeleteObjectAtCrosshair")) return;..            ..            if (target)..            {..
  Offset: 505897
  Contexto: ager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[AdminTools] Deleted Object @ crosshair: "  + target.GetType()));..
  Offset: 506128
  Contexto: steamid=%2) deleted object \"%3\" (pos=%4)", sender.GetName(), sender.GetPlainId(), target.GetType(), target.GetPosition().ToString()));..                GetGame().ObjectDelete(tar

Termo: (?i)onclientdisconnected
  Offset: 3303441
  Contexto: r already in "m_LogoutQueueInital"..                    ScriptInvoker onClientDisconnectedEvent = VPPATGetEventHandler().GetEventInvoker("OnPlayerDisconnected");..                    onClien
  Offset: 3303554
  Contexto: ndler().GetEventInvoker("OnPlayerDisconnected");..                    onClientDisconnectedEvent.Invoke(player, identity, false);..                }..                else if (!IsLogoutTimeExp
  Offset: 3306082
  Contexto: Manager.RemoveEntry ... " + uid);..        }....        ScriptInvoker onClientDisconnectedEvent = VPPATGetEventHandler().GetEventInvoker("OnPlayerDisconnected");    ..        onClientDisconn
  Offset: 3306187
  Contexto: tEventHandler().GetEventInvoker("OnPlayerDisconnected");    ..        onClientDisconnectedEvent.Invoke(player, identity, true); //at this point the logout process is complete, we invoke just

Termo: (?i)login
  Offset: 41348
  Contexto: ;...}..};modded class RPCManager..{...protected ref map<string,int> m_LoginAttempts = new map<string,int>;...const int VPPAT_FRAMEWORK_RPC_ID = 10420;.....void RPCManager()...
  Offset: 42676
  Contexto: sions/credentials.txt");.......VSendRPC("RPC_MissionGameplay", "ServerLoginError", NULL, true, sender, NULL);.......return;......}........if (m_LoginAttempts[recievedFrom] >=
  Offset: 42750
  Contexto: nError", NULL, true, sender, NULL);.......return;......}........if (m_LoginAttempts[recievedFrom] >= 6).......return;........string hash = VSHA256.ComputeString(pw);......if (
  Offset: 42909
  Contexto: g(pw);......if (hash != g_Game.GetAdminPasswordHash())......{.......m_LoginAttempts.Set(recievedFrom, m_LoginAttempts[recievedFrom] + 1);.......VSendRPC("RPC_MissionGameplay",
  Offset: 42943
  Contexto: AdminPasswordHash())......{.......m_LoginAttempts.Set(recievedFrom, m_LoginAttempts[recievedFrom] + 1);.......VSendRPC("RPC_MissionGameplay", "LoginAttemptFail", NULL, true, s
  Offset: 43016
  Contexto: inAttempts[recievedFrom] + 1);.......VSendRPC("RPC_MissionGameplay", "LoginAttemptFail", NULL, true, sender, NULL);.......WriteToLogs(string.Format("Player %1 attempted login,
  Offset: 43115
  Contexto: , sender, NULL);.......WriteToLogs(string.Format("Player %1 attempted login, and failed! Total Attempts: %2", recievedFrom, m_LoginAttempts[recievedFrom]));.......return;.....
  Offset: 43171
  Contexto:  %1 attempted login, and failed! Total Attempts: %2", recievedFrom, m_LoginAttempts[recievedFrom]));.......return;......}.....}....}......if (GetGame().IsClient() && !GetGame(
  Offset: 174997
  Contexto: .private bool   m_DisablePasswordProtection;...private int    m_FailedLoginCount = 0;...private string m_AdminPassword;.....private string ...  m_VServerIP;.....private string
  Offset: 186906
  Contexto: LShiftHolding()...{....return m_IsLShiftHolding;...}.....int GetFailedLoginAttempts()...{....return m_FailedLoginCount;...}.....void IncrementFailedLoginAttempts()...{....m_Fa

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
PBO: C:\DayZServer\@CodeLock\Addons\CodeLock.pbo
Tamanho: 10312938 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
 +>.H
 =g6.C
2(CLW@s/t.c
A@@@.H
Codelock\config.bin
Const.c
Copyright (c) 2017, Datto Inc. (fonts@datto.c
DDH.c
config.bin
gui\fonts\ddin.xml
gui\layouts\adminComboCode.layout
gui\layouts\claimComboCode.layout
gui\layouts\donor.layout
gui\layouts\enterComboCode.layout
gui\layouts\guestComboCode.layout
gui\layouts\raid.layout
gui\layouts\setComboCode.layout
https://www.datto.c
s&^.c
scripts\3_game\Config\CodeLockConfig.c
scripts\3_game\Const\CLConst.c
scripts\3_game\Const\Enum\CLMenu.c
scripts\3_game\Const\Enum\CLRPC.c
scripts\3_game\DayZGame.c
scripts\4_world\Actions\actionconstructor.c
scripts\4_world\Actions\continuous\ActionDestroyCodeLockOnFence.c
scripts\4_world\Actions\continuous\ActionDestroyCodeLockOnTent.c
scripts\4_world\Actions\continuous\ActionDismantlePart.c
scripts\4_world\Actions\interact\ActionCloseFence.c
scripts\4_world\Actions\interact\ActionInteractLockOnFence.c
scripts\4_world\Actions\interact\ActionInteractLockOnTent.c
scripts\4_world\Actions\interact\ActionLockAdminOnFence.c
scripts\4_world\Actions\interact\ActionLockAdminOnTent.c
scripts\4_world\Actions\interact\ActionManageLockOnFence.c
scripts\4_world\Actions\interact\ActionManageLockOnTent.c
scripts\4_world\Actions\interact\ActionPackTent.c
scripts\4_world\Actions\interact\ActionToggleTentOpen.c
scripts\4_world\Actions\singleuse\ActionAttachCodeLockToFence.c
scripts\4_world\Actions\singleuse\ActionAttachCodeLockToTent.c
scripts\4_world\Entities\CodeLock.c
scripts\4_world\Entities\Fence.c
scripts\4_world\Entities\Hacksaw.c
scripts\4_world\Entities\ItemBase.c
scripts\4_world\Entities\TentBase.c
scripts\4_world\PluginManager\PluginBase\Logger\CodeLockLogger.c
scripts\4_world\PluginManager\PluginBase\Permissions\CodeLockAdmin.c
scripts\4_world\PluginManager\PluginBase\Permissions\CodeLockPermissionManager.c
scripts\4_world\PluginManager\PluginBase\Permissions\CodeLockPerms.c
scripts\4_world\PluginManager\PluginBase\PluginRepairing.c
scripts\4_world\PluginManager\PluginBase\RPCHandler\CodeLockClientRPC.c
scripts\4_world\PluginManager\PluginBase\RPCHandler\CodeLockServerRPC.c
scripts\4_world\PluginManager\PluginBase\UIManager\CodeLockUIManager.c
scripts\4_world\PluginManager\PluginManager.c
scripts\4_world\gui\AdminCodeMenu.c
scripts\4_world\gui\ClaimCodeMenu.c
scripts\4_world\gui\CodeLockMenu.c
scripts\4_world\gui\EnterCodeMenu.c
scripts\4_world\gui\GuestCodeMenu.c
scripts\4_world\gui\SetCodeMenu.c
scripts\5_mission\MissionBase.c
scripts\5_mission\MissionServer.c
scripts\Common\Common.c
stants.C
texHeaders.bin
z!|.H
})b.c

--- OCORRENCIAS DE TERMOS RELEVANTES ---

Termo: (?i)queue
  Offset: 10290496
  Contexto: ERV.ER_SYNCH..., null,.6"._.].W..._.t.c. shi.{.l...`...StS`3/](.`C.allQueue.(CALL_CA.TEGORY_G.AMEPLAY)u.".L.`r(H.`...Ur..*.[.[.[.[..ShowAttacch.._.fp e~..........q..........'.

Termo: (?i)connection
  Offset: 10275671
  Contexto:  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,.OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE.SOFTWARE..# CodeLock.CodeLock modification av

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
PBO: C:\DayZServer\@ZensCoreMod\addons\ZenModCore.pbo
Tamanho: 2430897 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
                g_Game.C
            string from = "[" + profileName + "](http://steamcommunity.c
        g_Game.GetCallQueue(CALL_CATEGORY_SYSTEM).C
        if (cmd == "reload" && params.C
        if (type == CallType.C
        obj = g_Game.C
    PlayerBase player = PlayerBase.C
    if (obj.C
    if (type.C
    string cfgName = cfg.C
// Version control is handled in mod.c
// without needing to alter ActionConstructor/Entity.c
//target_wpn.C
AdminIDs_Temp.C
Ammunition_Base ammoNew = Ammunition_Base.C
Ammunition_Base ammoOld = Ammunition_Base.C
CarScript vehicle = CarScript.C
CommandURLs.Set("zenarchist", "https://zenarchist.c
DumpedPositions.C
EntityAI killerAI = EntityAI.C
Entries.C
Error("DUPLICATE OBJECT FOUND SPAWNED BY INIT.C
ExpansionTerritoryModule expansionTerritoryModule = ExpansionTerritoryModule.C
ExplosivesBase explosive = ExplosivesBase.C
GetRPCManager().AddRPC(ZEN_RPC, "RPC_ReceiveZenAdminCommandFailed", this, SingeplayerExecutionType.C
GetRPCManager().AddRPC(ZEN_RPC, "RPC_ReceiveZenOpenURL", this, SingleplayerExecutionType.C
GetZenCoreConfig().MapIzurviveURL = "https://www.izurvive.c
Grenade_Base grenade = Grenade_Base.C
ItemBase deployedItem = ItemBase.Cast(g_Game.C
ItemBase ib = ItemBase.C
ItemBase newItemBase = ItemBase.C
ItemBase oldItemBase = ItemBase.C
Magazine magNew = Magazine.C
Magazine magOld = Magazine.C
MissionBase mb = MissionBase.C
MissionGameplay mission = MissionGameplay.C
ModeratorIDs_Temp.C
Object obj = g_Game.C
Options.C
PasswordEditBoxWidget passwordEditBox = PasswordEditBoxWidget.C
PlayerBase pb = PlayerBase.C
PlayerBase player = PlayerBase.C
PlayerBase playerKiller = PlayerBase.C
ProcessDirectDamage(DamageType.C
ScrollWidget scroll = ScrollWidget.C
TestMap.C
TextWidget headerText = TextWidget.C
TrapBase trap = TrapBase.C
Want to learn how to make your own mods? Check out my guides on YouTube: https://www.youtube.c
Weapon_Base source_wpn = Weapon_Base.C
Weapon_Base target_wpn = Weapon_Base.C
Widget section = g_Game.GetWorkspace().C
ZMPrint("Config sync received from ScriptInvoker: " + cfg.C
ZMPrint("EnablePumps=" + EnablePumps + " NewVar=" + NewVar + " AllowedPumpTypesCount=" + AllowedPumpTypes.C
ZMPrint("[" + ClassName() + "] DB file already exists: " + db.DumpedPositions.C
ZMPrint("[ZenConfigRegister::SyncCheck] [" + cfg.C
ZMPrint("[ZenModCore::ZenConfigRegister] Deleting client-side only config on server: " + cfg.C
ZMPrint("[ZenModCore::ZenConfigRegister] Deleting server-side only config on client: " + cfg.C
ZMPrint("[ZenObjectHookSpawner] " + m_HookConfigs.Get(i).C
ZMPrint("[ZenObjectHookSpawner] Added hook config to scan list: " + cfg.C
ZMPrint("[ZenObjectHookSpawner] Finish object dump - no objects found (duration=" + duration + "ms - total objects scanned=" + objectsOnMap.C
ZMPrint("[ZenObjectHookSpawner] Finish object dump - total objects found=" + objCount + "/" + objectsOnMap.C
ZenConfigBase cfg = ZenConfigBase.C
ZenCore_AdminConfig.AdminIDs.C
ZenCore_AdminConfig.C
ZenCore_AdminConfig.CommandPrefix = ZenCore_AdminConfig.C
ZenCore_AdminConfig.ModeratorIDs.C
ZenKitBase kit = ZenKitBase.C
ZenKitBase zenkit = ZenKitBase.C
ZenLogger.C
ZenMapGroupPosWriter.C
ZenObjectHookConfigBase hookConfig = ZenObjectHookConfigBase.C
_LogPlayerEx logObjectPlayer = new _LogPlayerEx(PlayerBase.C
buf.C
cfg = ZenConfigBase.C
cfgName.Replace(".json
child_dst.C
chunks.C
config.bin
data\models\ZenKitBox\credit.txt
dbClear.C
deployedItemType = g_Game.C
embed.c
findCfgName.Replace(".json
float x = distance * Math.C
for (int c = 0; c < cats.C
for (int i = 0; i < cat.Settings.C
for (int i = 0; i < itemsArray.C
for (int i = 0; i < m_AllTypes.C
for (int i = 0; i < msg.GetWebhooks().C
for (int i = 0; i < newOptions.C
for (int i = 0; i < objects.C
for (int i = 0; i < options.C
for (int i = 0; i < parts.C
for (int i = 0; i < results.C
for (int i = 1; i < m_SelectActions.C
for (int i = m_HookConfigs.C
for (int index = 0; index < vehicle.C
for (int t = tokens.C
for (int x = 0; x < players.C
... e mais 146 nomes

--- OCORRENCIAS DE TERMOS RELEVANTES ---

Termo: (?i)priority
  Offset: 2276417
  Contexto: .int DefaultIndex;...int SavedIndex;...int PendingIndex;...int DisplayPriority;.....void ZenModSetting(string id, string categoryId, string title, array<string> options, int defa
  Offset: 2276575
  Contexto: g> options, int defaultIndex = 0, string description = "", int displayPriority = 0)...{....Id = id;....CategoryId = categoryId;....Title = title;....Description = description;...
  Offset: 2276691
  Contexto: categoryId;....Title = title;....Description = description;....DisplayPriority = displayPriority;......Options = new array<string>;....if (options)....{.....for (int i = 0; i < o
  Offset: 2276709
  Contexto: le = title;....Description = description;....DisplayPriority = displayPriority;......Options = new array<string>;....if (options)....{.....for (int i = 0; i < options.Count(); i+
  Offset: 2280662
  Contexto: g> options, int defaultIndex = 0, string description = "", int displayPriority = 0)...{....string fullId = BuildId(categoryId, key);....return Get().RegisterOrUpdateSetting(fullI
  Offset: 2280835
  Contexto: fullId, categoryId, title, options, defaultIndex, description, displayPriority);...}.....static ZenModSetting AddSetting2(string categoryId, string key, string title, string opt0
  Offset: 2281016
  Contexto: tring opt1, int defaultIndex = 0, string description = "", int displayPriority = 0)...{....array<string> opts = { opt0, opt1 };....return AddSetting(categoryId, key, title, opts,
  Offset: 2281159
  Contexto: tting(categoryId, key, title, opts, defaultIndex, description, displayPriority);...}.....static ZenModSetting AddBoolSetting(string categoryId, string key, string title, bool def
  Offset: 2281416
  Contexto: ls_disabled", string onText = "#options_controls_enabled", int displayPriority = 0)...{....array<string> opts = { offText, onText };......int defIndex;....if (defaultEnabled)....
  Offset: 2281648
  Contexto: ddSetting(categoryId, key, title, opts, defIndex, description, displayPriority);...}.....static string BuildId(string categoryId, string key)...{....return categoryId + "." + key

Termo: (?i)queue
  Offset: 2270608
  Contexto: .Set(className, true);....cfg.AfterConfigReceived();....g_Game.GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(DeferredInvokeAfterSync, 0, false, cfg);...}......void DeferredInvo
  Offset: 2302381
  Contexto: ...    if (obj.CanAffectPathgraph()) ...    {...        g_Game.GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(g_Game.UpdatePathgraphRegionByObject, 100, false, obj);...    }...
  Offset: 2321285
  Contexto: ..static const int MAX_BUFFER_LINES  = 50;     // or when >= 50 lines queued.....protected static ref map<string, ref TStringArray> s_Buffers = new map<string, ref TStringArra
  Offset: 2321512
  Contexto: uredFolders = new map<string, bool>();...protected static bool s_FlushQueued;.....// Public: write one log line...// subFolder: e.g. "Chat"...// baseFileName:...//   - "chat"
  Offset: 2322883
  Contexto: down to ensure nothing is lost...static void FlushAll()...{....s_FlushQueued = false;......foreach (string path, TStringArray buf : s_Buffers)....{.....if (buf && buf.Count()
  Offset: 2324828
  Contexto: buf.Insert("[" + ZMGetDate() + "] " + line);......// If we have a lot queued, flush immediately....if (buf.Count() >= MAX_BUFFER_LINES).....FlushPath(path);......QueueFlush();
  Offset: 2324920
  Contexto: ely....if (buf.Count() >= MAX_BUFFER_LINES).....FlushPath(path);......QueueFlush();...}.....private static void QueueFlush()...{....if (s_FlushQueued).....return;......s_Flush
  Offset: 2324962
  Contexto: ).....FlushPath(path);......QueueFlush();...}.....private static void QueueFlush()...{....if (s_FlushQueued).....return;......s_FlushQueued = true;......// flush later (avoids
  Offset: 2324993
  Contexto: ueFlush();...}.....private static void QueueFlush()...{....if (s_FlushQueued).....return;......s_FlushQueued = true;......// flush later (avoids disk IO on every chat message)
  Offset: 2325025
  Contexto: c void QueueFlush()...{....if (s_FlushQueued).....return;......s_FlushQueued = true;......// flush later (avoids disk IO on every chat message)....g_Game.GetCallQueue(CALL_CAT

Termo: (?i)steamid
  Offset: 2243280
  Contexto: leKillfeed;...ref array<string> KillfeedWebhooks;...bool DisplayPlayerSteamID;...bool DisplayKillLocation;...bool DisplayKillsByAI;......void ZenKillfeedConfig()...{....EnableKi
  Offset: 2243529
  Contexto: ooks.Insert("Insert killfeed channel webhooks here");....DisplayPlayerSteamID = false;....DisplayKillLocation = false;....DisplayKillsByAI = false;...}..}/*..This is purely for
  Offset: 2355094
  Contexto: (GetZenCoreConfig().ZenCore_DiscordConfig.KillfeedConfig.DisplayPlayerSteamID)....{.....if (!playerKiller.GetIdentity()).....{......killerText = playerKiller.GetType();.....} el
  Offset: 2357806
  Contexto: (GetZenCoreConfig().ZenCore_DiscordConfig.KillfeedConfig.DisplayPlayerSteamID)....{.....discordMsg = discordMsg + "\n\n" + Widget.TranslateString("#STR_ZenVictim") + ": " + GetI
  Offset: 2413143
  Contexto: .....string profileName = player.GetCachedName();..            string steamid = player.GetIdentity().GetPlainId();..            string from = "[" + profileName + "](http://steam
  Offset: 2413277
  Contexto:  from = "[" + profileName + "](http://steamcommunity.com/profiles/" + steamid + ")\n" + uid + "\n" + steamid;..            string status = ZenGameFunctions.GetMapLinkPosition(pl
  Offset: 2413308
  Contexto: http://steamcommunity.com/profiles/" + steamid + ")\n" + uid + "\n" + steamid;..            string status = ZenGameFunctions.GetMapLinkPosition(player.GetPosition()) + "\nHP=" +

Termo: (?i)getplainid
  Offset: 2236974
  Contexto: ......if (IsAdmin(id.GetId())).....return true;........if (IsAdmin(id.GetPlainId())).....return true;........return false;...}......bool IsModerator(string uid)...{....return ZenCo
  Offset: 2355471
  Contexto: ler.GetZenKillFeedName() + "](" + idLink + playerKiller.GetIdentity().GetPlainId() + ")";.....}..........victimText = "[" + GetZenKillFeedName() + "](http://steamcommunity.com/prof
  Offset: 2355604
  Contexto: lFeedName() + "](http://steamcommunity.com/profiles/" + GetIdentity().GetPlainId() + ")";....}......string weaponText = "";....if (object.GetType() == playerKiller.GetType()).....w
  Offset: 2380262
  Contexto: ));.....if (pb && (pb.GetIdentity().GetId() == id || pb.GetIdentity().GetPlainId() == id)).....{......return pb;.....}....}......return null;...}......//! Get the PlayerBase who se
  Offset: 2407813
  Contexto: layer.GetPosition()) + "\n\n" + identity.GetId() + "\n\n[" + identity.GetPlainId() + "](http://steamcommunity.com/profiles/" + identity.GetPlainId() + ")");.....playerWatchlistMsg.
  Offset: 2407879
  Contexto: ity.GetPlainId() + "](http://steamcommunity.com/profiles/" + identity.GetPlainId() + ")");.....playerWatchlistMsg.SetColor(255, 255, 0);.......foreach (string s : GetZenCoreConfig(
  Offset: 2413174
  Contexto: r.GetCachedName();..            string steamid = player.GetIdentity().GetPlainId();..            string from = "[" + profileName + "](http://steamcommunity.com/profiles/" + steamid

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
PBO: C:\DayZServer\@SuppressionMod\addons\Scripts.pbo
Tamanho: 28694 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
                        if (PlayerBase.C
            JsonFileLoader<SuppressionConfigSettings>.Json
            if (DayZPhysics.RaycastRVProxy(rayvectorParams, results) && results.C
            if( Class.C
        //GetRPCManager().AddRPC("Suppression", "RPC_AttachSuppressionTriggerToBullet", this, SingeplayerExecutionType.C
        //GetRPCManager().AddRPC("Suppression", "RPC_Client_SetSuppression", this, SingeplayerExecutionType.C
        //Print("[Suppression Config] :: MissionServer.c
        GetRPCManager().AddRPC("Suppression", "GetEarProtectionConfig", this, SingleplayerExecutionType.C
        GetRPCManager().AddRPC("Suppression", "RPC_SendPPEStartToClient", this, SingeplayerExecutionType.C
        JsonFileLoader<SuppressionConfigSettings>.Json
        PlayerBase player = PlayerBase.C
        Print("[Suppression Config] :: MissionServer.c
        auto cArgs = CF_EventPlayerPrepareArgs.C
        if (PlayerBase.C
        if (type != CallType.C
        if(type != CallType.C
    //     if( Class.C
    //     if(type != CallType.C
// Values defined in enums. See estaminamodifiers.c
3_Game\ConfigFileManager\SuppressionConfigConsts.c
3_Game\ConfigFileManager\SuppressionConfigStatic.c
3_Game\ConfigFileManager\SuppressionSettings.c
3_Game\enums\erpcs.c
3_Game\enums\estaminamodifiers.c
3_Game\playerconstants.c
4_World\classes\playermodifiers\emodifiers.c
4_World\classes\playermodifiers\modifiers\suppression.c
4_World\classes\playermodifiers\modifiersmanager.c
4_World\classes\staminahandler.c
4_World\entities\firearms\weapon_base.c
4_World\entities\manbase\playerbase.c
4_World\static\miscgameplayfunctions.c
5_Mission\ConfigFileManager\EarProtectionConfig.c
5_Mission\ConfigFileManager\EarprotectionRPC.c
5_Mission\Suppression\MissionServer.c
5_Mission\Suppression\missionGameplay.c
Data\Credits.json
Data\Inputs.xml
SuppressionConfigSettings.GetInstance().C
bool interacts = dGetInteractionLayer(obj, PhxInteractionLayers.C
config.bin
if (!PlayerBase.C
if (PlayerBase.C
if( PlayerBase.C
int suppressionAmount = MiscGameplayFunctions.C
m_HearingLossLevel = Math.C
m_SuppressionLevel = Math.C
m_TinnitusSoundEffect = SEffectManager.C
static const string SUPPRESSION_EARPROTECTION_CONFIG = SUPPRESSION_ROOT_DIR + "EarProtectionItems.txt
static const string SUPPRESSION_SUPPRESSION_SETTINGS_CONFIG = SUPPRESSION_ROOT_DIR + "SuppressionSettings.json
super.C

--- OCORRENCIAS DE TERMOS RELEVANTES ---
Nenhuma ocorrencia dos termos pesquisados.

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
PBO: C:\DayZServer\dta\scripts.pbo
Tamanho: 14401120 bytes

--- NOMES DE ARQUIVOS INTERNOS VISIVEIS ---
                        "Copyright (c) 1995-1998 Eric Young (eay@cryptsoft.c
                    "SectionName": "Data compression by oberhumer.c
                GetInventory().C
                Print(string.Format("[VFX] group '%1'[%2] cooldown=%3s canPlay=%4 remaining=%5s", EnumTools.EnumToString(EVehicleVFXEffectGroup, groupId), index, groupEffectData.GetCooldown(), groupEffectData.C
                data.m_ParticleParamsData.C
            Particle particle = Particle.C
            Print(string.Format("[VFX] '%1' cooldown=%2s canPlay=%3 remaining=%4s", EnumTools.EnumToString(EVehicleVFXEffect, effectId), data.GetCooldown(), data.C
            Print(string.Format("[VFX] group '%1' members=%2", EnumTools.EnumToString(EVehicleVFXEffectGroup, groupId), groupData.C
            data.m_ParticleParamsData.C
            m_StatCache = PlayerStat<float>.C
            mortarMixOpen = ItemBase.Cast(GetGame().C
            return data.C
        InsertIngredient(0,"DeadLizard", DayZPlayerConstants.C
        ItemBase mortarMixOpen = ItemBase.Cast(action_data.m_Player.GetInventory().C
        ItemBase result = ItemBase.C
        PlayerBase playerBase = PlayerBase.C
        PlayerBaseMove move = PlayerBaseMove.C
        Weapon_Base wpn = Weapon_Base.Cast(g_Game.C
        bool called = g_Game.GameScript.C
        float time_rel = Math.C
        g_Game.GetCallQueue(CALL_CATEGORY_SYSTEM).C
        if (!Class.C
        if (!data.C
        if (!m_EffectGroupsMap.C
        if (!m_EffectsMap.C
        if (!super.C
        if (m_Done.C
        int count = Math.Min(groupData.Count(), positions.C
        inventory.C
        m_CodeLock = DigitalCodeLock_Bunker.C
        m_CommandUID      = DayZPlayerConstants.C
        m_Player.ProcessDirectDamage(DamageType.C
        m_TargetIntensity = Math.C
        m_TemporaryResistanceTime = Math.C
        return GetCurrentWaterLevel() <= GetDayZPlayerType().C
        return m_Done.C
        t = Math.C
    float c = Math.C
    if (!ItemBase.C
    if (!g_Game.H
    if (parts.C
    int n = available.C
    m_FallDamageData.m_BleedingChanceCoef = Math.C
    m_FallDamageData.m_BleedingFeetCoef = Math.C
    m_FallDamageData.m_BleedingHandsCoef = Math.C
    m_FallDamageData.m_BleedingLegsCoef = Math.C
    m_FallDamageData.m_BrokenLegsCoef = Math.C
    m_FallDamageData.m_GlovesHealthCoef = Math.C
    m_FallDamageData.m_HealthCoef = Math.C
    m_FallDamageData.m_PantsHealthCoef = Math.C
    m_FallDamageData.m_ShockCoef = Math.C
    m_FallDamageData.m_ShoesHealthCoef = Math.C
    m_HandleHelper = UndergroundBreadcrumbHandle.Cast(g_Game.C
    m_HandleHelper = UndergroundTriggerHandle.Cast(g_Game.C
    normalizedSpeed = Math.C
    opacity = Math.C
    return obj.IsTransport() || obj.C
    t = Math.C
    targetHeatComfort = Math.C
    value = Math.C
    while (selected.C
   OnKeyPress() Scripts/DayZGame.c
   OnKeyPress() Scripts/mission/missionGameplay.c
   PresetAdd() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile\ModuleLocalProfileUI.h
   SaveConfigToFile() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile.c
   SaveFile() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler.c
   SaveParameterArray() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile.c
   SetParameterArray() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile.c
  OnKeyPress() Scripts/DayZGame.c
  OnKeyPress() Scripts/mission/missionGameplay.c
  PresetAdd() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile\ModuleLocalProfileUI.h
  SaveConfigToFile() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile.c
  SaveFile() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler.c
  SaveParameterArray() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile.c
  SetParameterArray() Scripts\Entities\Modules\ModuleBase\ModuleFileHandler\ModuleLocalProfile.c
  ipw = ItemPreviewWidget.C
  iw = ItemPreviewWidget.C
 "FirewoodSplit_Axe", DayZPlayerConstants.C
 "FirewoodSplit_Saw", DayZPlayerConstants.C
 *   Entity bino = g_Game.C
 *   if (Class.C
 * @NOTE the example looks in the DZ/data/config.c
 * @NOTE: slot id is related to order of entries in DZ/data/config.c
 * @param type Type of protection (see DEF_BIOLOGICAL in constants.c
 * @param[in] index of configured step, range [0..c
 * @param[in] index of zeroing to set [0..c
 * \desc constants for input device - inputInterfaceDef.h
 g_Game.GetCallQueue(CALL_CATEGORY_GUI).C
 g_Game.GetDragQueue().C
 if (!g_Game.H
"$profile:missionlist.json
"ps4/pagedatacontroller.json
"xbox/pagedatacontroller.json
( AttachmentCategoriesRow.C
( Container.C
( ContainerWithCargo.C
( ContainerWithCargoAndAttachments.C
( HandsContainer.C
( IconsContainer.C
( ItemBase.Cast( receiver_item ) ).CombineItemsClient( ItemBase.C
... e mais 11204 nomes

--- OCORRENCIAS DE TERMOS RELEVANTES ---

Termo: (?i)priority
  Offset: 233157
  Contexto: );...proto external int GetBackgroundColor();...proto external int GetPriority();...proto external void SetText(string text);...proto external void SetTextColor(int color);...pro
  Offset: 233381
  Contexto: oto external void SetBackgroundColor(int color);.../*!...Sets Z order priority....\note Texts with background are always rendered under texts without background....*/...proto ext
  Offset: 233503
  Contexto: endered under texts without background....*/...proto external void SetPriority(int priority);..}..../*!..\}..*/..../*!..\addtogroup Debug..\{..*/....enum DebugTextFlags..{...DEFA
  Offset: 233516
  Contexto:  texts without background....*/...proto external void SetPriority(int priority);..}..../*!..\}..*/..../*!..\addtogroup Debug..\{..*/....enum DebugTextFlags..{...DEFAULT,...CENTER
  Offset: 234641
  Contexto: .\param bgColor Color of the back background behind the text...\param priority Z order priority. Note: texts with background are always rendered under texts without background...
  Offset: 234658
  Contexto: olor of the back background behind the text...\param priority Z order priority. Note: texts with background are always rendered under texts without background....\return DebugTex
  Offset: 235047
  Contexto: at size = 20.0, int color = 0xFFFFFFFF, int bgColor = 0x00000000, int priority = 1000);..}..../*!..\}..*/..../*!..\addtogroup Debug..\{..*/....class DebugTextWorldSpace: DebugTex
  Offset: 236288
  Contexto: .\param bgColor Color of the back background behind the text...\param priority Z order priority. Note: texts with background are always rendered under texts without background...
  Offset: 236305
  Contexto: olor of the back background behind the text...\param priority Z order priority. Note: texts with background are always rendered under texts without background....\return DebugTex
  Offset: 236702
  Contexto: at size = 20.0, int color = 0xFFFFFFFF, int bgColor = 0x00000000, int priority = 1000);.../*!...The text is placed in world and is occluded by other objects. The size is in meter

Termo: (?i)queue
  Offset: 591498
  Contexto: ;......counter--;....return false;...}..}..*/../**.. \brief ScriptCallQueue Class provide "lazy" calls - when we don't want to execute function immediately but later during fr
  Offset: 591705
  Contexto:  \n usage:.. @code...class Arkanoid extends Game...{....ref ScriptCallQueue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue
  Offset: 591717
  Contexto:  @code...class Arkanoid extends Game...{....ref ScriptCallQueue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue;....}......
  Offset: 591739
  Contexto: d extends Game...{....ref ScriptCallQueue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue;....}.......override void OnUpdat
  Offset: 591764
  Contexto:  ScriptCallQueue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue;....}.......override void OnUpdate(float timeslice)....{..
  Offset: 591777
  Contexto: eue m_CallQueue = new ScriptCallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue;....}.......override void OnUpdate(float timeslice)....{.....m_CallQueu
  Offset: 591805
  Contexto: CallQueue();.......ScriptCallQueue GetCallQueue() { .....return m_CallQueue;....}.......override void OnUpdate(float timeslice)....{.....m_CallQueue.Tick(timeslice);..........
  Offset: 591878
  Contexto: ue;....}.......override void OnUpdate(float timeslice)....{.....m_CallQueue.Tick(timeslice);............}..........}.....class MyObject...{....int m_cnt = 0;.......void Hello(
  Offset: 592158
  Contexto: nt(m_cnt);.....m_cnt++;..........if (m_cnt > 10).....{......ScriptCallQueue queue = g_Game.GetCallQueue();......queue.Remove(Test);.....}....}...}.....void Test(MyObject obj).
  Offset: 592164
  Contexto: nt);.....m_cnt++;..........if (m_cnt > 10).....{......ScriptCallQueue queue = g_Game.GetCallQueue();......queue.Remove(Test);.....}....}...}.....void Test(MyObject obj)...{...

Termo: (?i)whitelist
  Offset: 1568690
  Contexto: .// Server is shutting down and therefore kicks all players.......NOT_WHITELISTED,.// Player is not whitelisted...NO_IDENTITY,..// No identity received while creating identity...N
  Offset: 1568720
  Contexto: d therefore kicks all players.......NOT_WHITELISTED,.// Player is not whitelisted...NO_IDENTITY,..// No identity received while creating identity...NO_INPUT_INTERFACE, // No input
  Offset: 1577983
  Contexto: rver_shutdown");......InsertDialogueErrorProperties(EClientKicked.NOT_WHITELISTED,....."#multi_server_not_whitelisted_message");....InsertDialogueErrorProperties(EClientKicked.NO_
  Offset: 1578019
  Contexto: ErrorProperties(EClientKicked.NOT_WHITELISTED,....."#multi_server_not_whitelisted_message");....InsertDialogueErrorProperties(EClientKicked.NO_IDENTITY,......"#STR_no_identity");.
  Offset: 2303903
  Contexto: dAt;...string.m_UpdatedAt;...bool.m_MouseAndKeyboardEnabled;...bool.m_WhitelistEnabled;...int..m_DLCs;......//Scripted...bool..m_IsExpanded;...int ..m_SortName;....int...m_SortTim
  Offset: 2308521
  Contexto: ring..m_FavoriteServers;...bool..m_MouseAndKeyboardEnabled;...bool..m_WhitelistEnabled;...int...m_DLCs;.....bool m_UseAntiCheat;...bool m_UseName;...bool m_UseGameType;...bool m_U
  Offset: 2309049
  Contexto: ..bool m_UseHostIps;...bool m_UseMouseAndKeyboardEnabled;...bool m_UseWhitelistEnabled;...bool m_UseDLCs;......void SetAntiCheatFilter( bool anti_cheat )...{....m_AntiCheat.....=
  Offset: 2312628
  Contexto: )...{....m_FavoriteServers += ip + ";" + port + ";";...}......void SetWhitelistEnabled(bool whitelistEnabled)...{....m_WhitelistEnabled = whitelistEnabled;....m_UseWhitelistEnable
  Offset: 2312650
  Contexto: vers += ip + ";" + port + ";";...}......void SetWhitelistEnabled(bool whitelistEnabled)...{....m_WhitelistEnabled = whitelistEnabled;....m_UseWhitelistEnabled = true;........m_Sor
  Offset: 2312677
  Contexto: ;";...}......void SetWhitelistEnabled(bool whitelistEnabled)...{....m_WhitelistEnabled = whitelistEnabled;....m_UseWhitelistEnabled = true;........m_SortBy += "W";....AddShow(whit

Termo: (?i)steamid
  Offset: 1514638
  Contexto: layer...proto string GetFullName();...//! unique id of player (hashed steamID, database Xbox id...) can be used in database or logs...proto string GetId();...//! plaintext uniqu
  Offset: 1573800
  Contexto: UPLICATE_REQUEST,.....// A ticket has already been submitted for this steamID...AUTH_INVALID_VERSION,.....// Ticket is from an incompatible interface version...AUTH_GAME_MISMATC

Termo: (?i)getplainid
  Offset: 737874
  Contexto: ity.WARNING);......continue;.....}.......sync_player.m_UID = identity.GetPlainId();.....sync_player.m_PlayerName = identity.GetPlainName();....}...}.....static void SyncEvent_OnRec
  Offset: 780578
  Contexto: .sync_player.m_Identity = identity;......sync_player.m_UID = identity.GetPlainId();......sync_player.m_PlayerName = identity.GetPlainName();......m_PlayerList.Insert(sync_player);.
  Offset: 934701
  Contexto: ..bool mute = mute_list.GetElement(i);.........MutePlayer(uid, sender.GetPlainId(), mute);........}.......}.......break;......}............/*......case ERPCs.RPC_SERVER_RESPAWN_MOD
  Offset: 1514812
  Contexto: ique id of player (cannot be used in database or logs)...proto string GetPlainId();...//! id of player in one session (is reused after player disconnects)...proto int GetPlayerId()
  Offset: 10157291
  Contexto: d) && ctx.Read(mute)).....{......g_Game.MutePlayer(uid, GetIdentity().GetPlainId(), mute);......// commented because plainID should not be present in logs......//Print("Player: " +

Termo: (?i)onclientnewevent
  Offset: 14143044
  Contexto: ntParams newParams;.....Class.CastTo(newParams, params);.....player = OnClientNewEvent(newParams.param1, newParams.param2, newParams.param3);.....if (!player).....{......Debug.Log("Clien
  Offset: 14149694
  Contexto: achmentTypes(slot_ID).Find(attachment_type) > -1;...}......PlayerBase OnClientNewEvent(PlayerIdentity identity, vector pos, ParamsReadContext ctx)...{....string characterType = g_Game.Cr

Termo: (?i)onclientreadyevent
  Offset: 14143751
  Contexto: Log("ClientReadyEvent: Player is empty");......return;.....}..........OnClientReadyEvent(identity, player);.....InvokeOnConnect(player, identity);.....// Send list of players at all client
  Offset: 14151343
  Contexto: nuDefaultCharacterData());....}........return m_player;...}......void OnClientReadyEvent(PlayerIdentity identity, PlayerBase player)...{....g_Game.SelectPlayer(identity, player);........#i

Termo: (?i)onclientdisconnected
  Offset: 14145207
  Contexto: ientDisconnectenEvent: Player is empty");......return;.....}..........OnClientDisconnectedEvent(identity, player, logoutTime, authFailed);.....break;.........case LogoutCancelEventTypeID:...
  Offset: 14152390
  Contexto: ..{....if (player)....{.....player.OnReconnect();....}...}.......void OnClientDisconnectedEvent(PlayerIdentity identity, PlayerBase player, int logoutTime, bool authFailed)...{....bool disco

Termo: (?i)login
  Offset: 789186
  Contexto: .....= 28;..const int MENU_RADIAL_QUICKBAR......= 29;..const int MENU_LOGIN_QUEUE.......= 30;..const int MENU_SERVER_BROWSER......= 31;..const int MENU_CAMERA_TOOLS.......= 32
  Offset: 789500
  Contexto: .......= 36;..const int MENU_INVITE_TIMER.......= 37;..const int MENU_LOGIN_TIME.......= 38;..const int MENU_WARNING_ITEMDROP......= 39;..const int MENU_RESPAWN_DIALOGUE......
  Offset: 850638
  Contexto: appings.Find(hash,sound_set);....return sound_set;...}..};......class LoginScreenBase extends UIScriptedMenu..{...protected ref UiHintPanelLoading m_HintPanel;...protected boo
  Offset: 851534
  Contexto: ool IsHandlingPlayerDeathEvent()...{....return false;...}..}....class LoginQueueBase extends LoginScreenBase..{...protected TextWidget m_txtPosition;...protected TextWidget m_
  Offset: 851557
  Contexto: thEvent()...{....return false;...}..}....class LoginQueueBase extends LoginScreenBase..{...protected TextWidget m_txtPosition;...protected TextWidget m_txtNote;...protected Bu
  Offset: 851729
  Contexto:  ButtonWidget m_btnLeave;...protected int m_iPosition = -1;......void LoginQueueBase()...{......g_Game.SetKeyboardHandle(this);....}.....void ~LoginQueueBase()...{....g_Game.S
  Offset: 851802
  Contexto: inQueueBase()...{......g_Game.SetKeyboardHandle(this);....}.....void ~LoginQueueBase()...{....g_Game.SetKeyboardHandle(NULL);....}......override Widget Init()...{......layoutR
  Offset: 853953
  Contexto: eAccu >= GameConstants.LOADING_SCREEN_HINT_INTERVAL;...}..};......//! LoginQueue position when using -connect since mission is not created yet ..class LoginQueueStatic extends
  Offset: 854034
  Contexto: position when using -connect since mission is not created yet ..class LoginQueueStatic extends LoginQueueBase..{...void LoginQueueStatic()...{....Init();........m_IsStatic = t
  Offset: 854059
  Contexto: ect since mission is not created yet ..class LoginQueueStatic extends LoginQueueBase..{...void LoginQueueStatic()...{....Init();........m_IsStatic = true;...}..};....class Log

Termo: (?i)connection
  Offset: 213852
  Contexto: {j....5_Mission\GUI\Chat\ChatLine.c..............#{j....5_Mission\GUI\ConnectionDialogue.c..............#{jp...5_Mission\GUI\ContinuousActionProgress.c..............#{j....5_Missio
  Offset: 789866
  Contexto: IALOG.= 44;..const int MENU_MISSION_LOADER......= 45;..const int MENU_CONNECTION_DIALOGUE.....= 46;..const int MENU_DIGITAL_CODELOCK......= 47;..const int MENU_UNDERGROUND_TRIGGER_
  Offset: 857754
  Contexto: tic = true;...}......void ~LoginTimeStatic()...{...}..};........class ConnectionLost..{...private ref Widget m_WidgetRoot;...private TextWidget m_TextWidgetTitle;...private float m
  Offset: 857886
  Contexto:  TextWidget m_TextWidgetTitle;...private float m_duration;.......void ConnectionLost(DayZGame game)...{......m_WidgetRoot = game.GetWorkspace().CreateWidgets("gui/layouts/day_z_con
  Offset: 857993
  Contexto: ..m_WidgetRoot = game.GetWorkspace().CreateWidgets("gui/layouts/day_z_connection_lost.layout");....m_WidgetRoot.Show(false);........Class.CastTo(m_TextWidgetTitle, m_WidgetRoot.Fin
  Offset: 872782
  Contexto: inQueueBase m_LoginQueue;...private int m_LoginTime;......private ref ConnectionLost m_connectionLost;...private ref TimerQueue m_timerQueue[CALL_CATEGORY_COUNT];...private ref Scr
  Offset: 872799
  Contexto: inQueue;...private int m_LoginTime;......private ref ConnectionLost m_connectionLost;...private ref TimerQueue m_timerQueue[CALL_CATEGORY_COUNT];...private ref ScriptCallQueue m_ca
  Offset: 890358
  Contexto: ateInputDeviceDisconnectWarning();............break;.....}.....case MPConnectionLostEventTypeID:.....{......MPConnectionLostEventParams conLost_params;......if (Class.CastTo(conLos
  Offset: 890398
  Contexto: ......break;.....}.....case MPConnectionLostEventTypeID:.....{......MPConnectionLostEventParams conLost_params;......if (Class.CastTo(conLost_params, params))......{.......int dura
  Offset: 890548
  Contexto: params))......{.......int duration = conLost_params.param1;.......OnMPConnectionLostEvent(duration);......}......break;.....}.....case WorldCleaupEventTypeID:.....{......LoadingSho

Nota: ocorrencias podem estar em metadados, nomes ou dados binarios.
Ausencia de ocorrencia nao prova ausencia de codigo compilado.

===========================================================================
VARREDURA CONCLUIDA - SOMENTE LEITURA
Nenhum PBO foi extraido, executado ou modificado.
PS C:\RavenRP\ControlCenter\API>
