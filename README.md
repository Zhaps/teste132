========== 1. ARQUIVOS RELACIONADOS AO ENVIO ==========

FullName
--------
C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\3_Game\VPPAdminTools\WebHoo...
C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugi...
C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugi...
C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugi...
C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugi...
C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugi...



========== VPPWebhookDefs.c ==========

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c:72]
        const static string EV_JOIN = "join";
        const static string EV_LEAVE = "leave";
        const static string EV_LEAVE_EARLY = "leave.early";
        const static string EV_LOGOUT_START = "logout.start";
        const static string EV_LOGOUT_CANCEL = "logout.cancel";
>>      const static string EV_STATUS = "server.status";
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c:199]
        {
                return name.IndexOf("hook.") == 0;
        }
};

>> // What an admin may do in the webhooks menu (the server sends the mask with the list; the server checks again).
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c:206]
{
        const static int CREATE = 1;
        const static int EDIT = 2;
        const static int DELETE = 4;
        const static int EDIT_TEMPLATES = 8;
>>      const static int TEST_SEND = 16;
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c:207]
        const static int CREATE = 1;
        const static int EDIT = 2;
        const static int DELETE = 4;
        const static int EDIT_TEMPLATES = 8;
        const static int TEST_SEND = 16;
>>      const static int VIEW_URL = 32;
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

========== WebHooksManager.c ==========

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:4]
/*
        Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

>>      - Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
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

        private ref array<ref WebHook>           M_DATA;

        [NonSerialized()]
        protected ref map<string, ref VPPWebhookSender> m_Senders;
        // senders of deleted / replaced webhooks: kept until the engine answered their requests

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:8]

        - Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
          Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
        - Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
          its preset when missing, so server owners can also edit them in a text editor (ReloadTemplates picks changes up).
>>      - Delivery: VPPWebhookSender (rate limit, retries, stats), pumped here once a second.
        - Old configs (v0: per-category switches + "simplified") are migrated to events + the Discord preset with the same
          switches, so nothing changes until an admin edits a template.
*/
class WebHooksManager: ConfigurablePlugin
{
        const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
        const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
        const static string TEMPLATE_EXT = ".tpl";

        private ref array<ref WebHook>           M_DATA;

        [NonSerialized()]
        protected ref map<string, ref VPPWebhookSender> m_Senders;
        // senders of deleted / replaced webhooks: kept until the engine answered their requests
        [NonSerialized()]
        protected ref array<ref VPPWebhookSender> m_Retired;
        // next server status time (GetGame().GetTime()) per webhook id
        [NonSerialized()]

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:21]
        const static string TEMPLATE_EXT = ".tpl";

        private ref array<ref WebHook>           M_DATA;

        [NonSerialized()]
>>      protected ref map<string, ref VPPWebhookSender> m_Senders;
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:22]

        private ref array<ref WebHook>           M_DATA;

        [NonSerialized()]
        protected ref map<string, ref VPPWebhookSender> m_Senders;
>>      // senders of deleted / replaced webhooks: kept until the engine answered their requests
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:24]

        [NonSerialized()]
        protected ref map<string, ref VPPWebhookSender> m_Senders;
        // senders of deleted / replaced webhooks: kept until the engine answered their requests
        [NonSerialized()]
>>      protected ref array<ref VPPWebhookSender> m_Retired;
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:25]
        [NonSerialized()]
        protected ref map<string, ref VPPWebhookSender> m_Senders;
        // senders of deleted / replaced webhooks: kept until the engine answered their requests
        [NonSerialized()]
        protected ref array<ref VPPWebhookSender> m_Retired;
>>      // next server status time (GetGame().GetTime()) per webhook id
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:39]
        protected bool m_TemplatesDirty;

        void WebHooksManager()
        {
                M_DATA = new array<ref WebHook>;
>>              m_Senders = new map<string, ref VPPWebhookSender>();
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:40]

        void WebHooksManager()
        {
                M_DATA = new array<ref WebHook>;
                m_Senders = new map<string, ref VPPWebhookSender>();
>>              m_Retired = new array<ref VPPWebhookSender>();
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:55]
                GetRPCManager().AddRPC("RPC_WebHooksManager", "CreateWebHooks", this, SingleplayerExecutionType.Server);
                GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
                GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
                GetRPCManager().AddRPC("RPC_WebHooksManager", "ValidateTemplate", this, SingleplayerExecutionType.Server);
                GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveTemplate", this, SingleplayerExecutionType.Server);
>>              GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:100]
                WriteReadme();
                foreach (WebHook loaded : M_DATA)
                {
                        if (loaded)
                        {
>>                              StartSender(loaded);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:117]

        override void Load()
        {
                if (FileExist( JSONPATH ))
                {
>>                      JsonFileLoader<WebHooksManager>.JsonLoadFile(JSONPATH, this);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:129]
                }
        }

        override void Save()
        {
>>              JsonFileLoader<WebHooksManager>.JsonSaveFile(JSONPATH, this);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:143]
        // ---------------------------------------------------------------- events

        /*
                Called from many other instances such as admin logs and vppat plugins
        */
>>      void PostData(typename messageType, WebHookMessageBase dataClass)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:150]
                if (!dataClass)
                {
                        return;
                }

>>              VPPWebhookEvent webhookEvent = dataClass.ToEvent();
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:157]
                {
                        Emit(webhookEvent);
                }
        }

>>      void PostServerBootup()
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:163]
        {
                VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
                Emit(bootEvent);
        }

>>      // Sends an event to every webhook that has it enabled and whose filters let it through.
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:164]
                VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
                Emit(bootEvent);
        }

        // Sends an event to every webhook that has it enabled and whose filters let it through.
>>      void Emit(VPPWebhookEvent webhookEvent)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:166]
        }

        // Sends an event to every webhook that has it enabled and whose filters let it through.
        void Emit(VPPWebhookEvent webhookEvent)
        {
>>              if (!webhookEvent || !CanSend() || !M_DATA || M_DATA.Count() == 0)
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:185]
                        if (!Passes(cfg, webhookEvent))
                        {
                                continue;
                        }

>>                      SendTo(hook, webhookEvent, "", 0);
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:189]

                        SendTo(hook, webhookEvent, "", 0);
                }
        }

>>      // false when the webhook has no sender or no usable template for the event (nothing is sent)
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:190]
                        SendTo(hook, webhookEvent, "", 0);
                }
        }

        // false when the webhook has no sender or no usable template for the event (nothing is sent)
>>      protected bool SendTo(WebHook hook, VPPWebhookEvent webhookEvent, string testBy, int testReqId)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:192]
        }

        // false when the webhook has no sender or no usable template for the event (nothing is sent)
        protected bool SendTo(WebHook hook, VPPWebhookEvent webhookEvent, string testBy, int testReqId)
        {
>>              VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:193]

        // false when the webhook has no sender or no usable template for the event (nothing is sent)
        protected bool SendTo(WebHook hook, VPPWebhookEvent webhookEvent, string testBy, int testReqId)
        {
                VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
>>              if (!sender)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:198]
                if (!sender)
                {
                        return false;
                }

>>              string body = sender.Render(webhookEvent);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:204]
                if (body == "")
                {
                        return false;
                }

>>              sender.Enqueue(webhookEvent.Id, body, testBy, testReqId);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:208]

                sender.Enqueue(webhookEvent.Id, body, testBy, testReqId);
                return true;
        }

>>      protected bool CanSend()
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:305]
                }

                return true;
        }

>>      // ---------------------------------------------------------------- senders, templates

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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:307]
                return true;
        }

        // ---------------------------------------------------------------- senders, templates

>>      protected void StartSender(WebHook hook)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:309]

        // ---------------------------------------------------------------- senders, templates

        protected void StartSender(WebHook hook)
        {
>>              VPPWebhookSender sender = new VPPWebhookSender(hook);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:310]
        // ---------------------------------------------------------------- senders, templates

        protected void StartSender(WebHook hook)
        {
                VPPWebhookSender sender = new VPPWebhookSender(hook);
>>              m_Senders.Set(hook.m_Id, sender);
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:311]

        protected void StartSender(WebHook hook)
        {
                VPPWebhookSender sender = new VPPWebhookSender(hook);
                m_Senders.Set(hook.m_Id, sender);
>>              LoadTemplates(hook, sender, true);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:316]
                LoadTemplates(hook, sender, true);
                int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
                m_StatusDue.Set(hook.m_Id, due);
        }

>>      // The old sender keeps living until its requests are answered (the engine holds its callbacks).
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:317]
                int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
                m_StatusDue.Set(hook.m_Id, due);
        }

        // The old sender keeps living until its requests are answered (the engine holds its callbacks).
>>      protected void RetireSender(string hookId)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:319]
        }

        // The old sender keeps living until its requests are answered (the engine holds its callbacks).
        protected void RetireSender(string hookId)
        {
>>              VPPWebhookSender sender = m_Senders.Get(hookId);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c:320]

        // The old sender keeps living until its requests are answered (the engine holds its callbacks).
        protected void RetireSender(string hookId)
        {
                VPPWebhookSender sender = m_Senders.Get(hookId);
>>              if (sender)
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

========== VPPWebhookSender.c ==========

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:1]
>> // An event to send: its id and variables (VPPWebhookDefs lists the built-in ones). Other mods can emit their own ids
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:55]
        string EventId;
        string Body;
        int Attempts;
        // GetGame().GetTime() before which it is not sent (retry backoff)
        int NotBefore;
>>      // a test send: who asked (plain id) and their request id
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:60]
        // a test send: who asked (plain id) and their request id
        string TestBy;
        int TestReqId;
};

>> // One request's answer. Bound to a sender + job while the request runs, unbound on the first answer (a second
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:64]

// One request's answer. Bound to a sender + job while the request runs, unbound on the first answer (a second
// answer for the same request is ignored) and then reused through VPPWebhookCallbackPool.
class VPPWebhookRequestCallback : RestCallback
{
>>      protected VPPWebhookSender m_Owner;
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:67]
class VPPWebhookRequestCallback : RestCallback
{
        protected VPPWebhookSender m_Owner;
        protected int m_JobId;

>>      void Bind(VPPWebhookSender owner, int jobId)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:75]
                m_JobId = jobId;
        }

        protected void Answer(int state)
        {
>>              VPPWebhookSender owner = m_Owner;
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:86]
                }
        }

        override void OnSuccess(string data, int dataSize)
        {
>>              Answer(VPPWebhookSender.RESULT_SUCCESS);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:96]
                Answer(errorCode);
        }

        override void OnTimeout()
        {
>>              Answer(VPPWebhookSender.RESULT_NO_REPLY);
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:107]
// callbacks go back here and are bound to the next request; the pool never holds more than were in flight at once.
class VPPWebhookCallbackPool
{
        protected static ref array<ref VPPWebhookRequestCallback> s_Free;

>>      static VPPWebhookRequestCallback Acquire(VPPWebhookSender owner, int jobId)
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:150]
                }
        }
};

/*
>>      Runtime of one webhook (server): its compiled templates, the send queue (rate limited per minute, retried with
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:154]
/*
        Runtime of one webhook (server): its compiled templates, the send queue (rate limited per minute, retried with
        backoff) and the delivery stats. Request callbacks stay referenced until the engine calls them: the engine keeps a
        raw pointer, so they are never freed early.
*/
>> class VPPWebhookSender : Managed
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:159]
class VPPWebhookSender : Managed
{
        // Result codes as the engine really reports them (DayZServer 1.30 sub_1408B07C0 / sub_1408C9260). The script
        // ERestResultState names are one step off (its EREST_ERROR is 5, the engine's 4xx code), so they are not used.
        const static int RESULT_SUCCESS = 3;
>>      // HTTP 4xx (bad body, bad / deleted webhook URL, rate limited)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:163]
        const static int RESULT_SUCCESS = 3;
        // HTTP 4xx (bad body, bad / deleted webhook URL, rate limited)
        const static int RESULT_HTTP_4XX = 5;
        // HTTP 5xx
        const static int RESULT_HTTP_5XX = 6;
>>      // any other curl failure: connect, DNS, TLS, or a 3xx redirect (redirects are not followed)
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


[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:165]
        const static int RESULT_HTTP_4XX = 5;
        // HTTP 5xx
        const static int RESULT_HTTP_5XX = 6;
        // any other curl failure: connect, DNS, TLS, or a 3xx redirect (redirects are not followed)
        const static int RESULT_NETWORK = 7;
>>      // curl timeout, or a 2xx without a body (Discord without ?wait=true answers 204)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:182]
        protected ref map<int, ref VPPWebhookRequestCallback> m_Callbacks;
        protected ref array<int> m_SentTimes;
        protected int m_NextJobId;
        ref VPPWebhookStats Stats;

>>      void VPPWebhookSender(WebHook hook)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:285]
                job.TestReqId = testReqId;
                m_Queue.Insert(job);
                Stats.Queued++;
        }

>>      // Called every second by the manager: sends what the rate limit and the in-flight cap allow.
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:314]
                                index++;
                                continue;
                        }

                        m_Queue.RemoveOrdered(index);
>>                      Send(job);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:326]
        int QueueCount()
        {
                return m_Queue.Count();
        }

>>      // Requests still waiting for the engine (the manager keeps a sender alive until this is 0).
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:332]
        int PendingRequests()
        {
                return m_InFlight.Count();
        }

>>      protected void Send(VPPWebhookJob job)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:334]
                return m_InFlight.Count();
        }

        protected void Send(VPPWebhookJob job)
        {
>>              string url = m_Hook.GetSendUrl();
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:335]
        }

        protected void Send(VPPWebhookJob job)
        {
                string url = m_Hook.GetSendUrl();
>>              if (url == "" || !GetRestApi())
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:337]
        protected void Send(VPPWebhookJob job)
        {
                string url = m_Hook.GetSendUrl();
                if (url == "" || !GetRestApi())
                {
>>                      Finish(job, false, "no URL or no RestApi");
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:345]

                job.Attempts++;
                VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
                m_Callbacks.Set(job.Id, callback);
                m_InFlight.Set(job.Id, job);
>>              RestContext context = GetRestApi().GetRestContext(url);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:346]
                job.Attempts++;
                VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
                m_Callbacks.Set(job.Id, callback);
                m_InFlight.Set(job.Id, job);
                RestContext context = GetRestApi().GetRestContext(url);
>>              context.SetHeader(m_Hook.m_ContentType);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:347]
                VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
                m_Callbacks.Set(job.Id, callback);
                m_InFlight.Set(job.Id, job);
                RestContext context = GetRestApi().GetRestContext(url);
                context.SetHeader(m_Hook.m_ContentType);
>>              context.POST(callback, "", job.Body);
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:356]
        {
                VPPWebhookJob job = m_InFlight.Get(jobId);
                m_InFlight.Remove(jobId);
                VPPWebhookCallbackPool.Release(callback);
                m_Callbacks.Remove(jobId);
>>              // a retired sender (its webhook was deleted / replaced) only waits for its callbacks
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:380]
                        ReportTest(job, true, "NO_REPLY");
                        return;
                }

                string reason = StateName(state);
>>              // 4xx is usually a bad payload or URL: one retry (covers a 429 rate limit); server / network errors retry more
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:440]
                }
        }

        // A 4xx: the full body goes to Rejected/<webhook id>_<event>.txt (the newest one per event), and the log says
        // whether the game's JSON parser accepts it (with line / column) and which Discord limits it breaks. Valid JSON
>>      // with no limit problems points at the URL or the service's rate limit instead.
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:475]
                        Print(verdictText);
                        return;
                }

                bool discordPreset = VPPWebhookPresets.UsesDiscordLimits(m_Hook.m_Preset);
>>              if (m_Hook.IsDiscordUrl() && !discordPreset)
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:478]

                bool discordPreset = VPPWebhookPresets.UsesDiscordLimits(m_Hook.m_Preset);
                if (m_Hook.IsDiscordUrl() && !discordPreset)
                {
                        string presetName = m_Hook.m_Preset;
>>                      Print("[WebHooksManager] The URL is a Discord webhook but the preset is " + presetName + ": Discord only accepts the discord_embed / discord_simple formats");
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:489]
                        VPPDiscordLint.Check(job.Body, problems);
                }

                if (problems.Count() == 0)
                {
>>                      Print("[WebHooksManager] The body is valid JSON within Discord limits: check the URL, or the service is rate limiting");
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:504]

        static string StateName(int state)
        {
                if (state == RESULT_HTTP_4XX)
                {
>>                      return "HTTP_4XX (bad body, wrong or deleted URL, or rate limited)";
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c:514]
                        return "HTTP_5XX (the service had an error)";
                }

                if (state == RESULT_NETWORK)
                {
>>                      return "NETWORK_ERROR (connect, DNS, TLS, or a redirecting URL)";
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

========== ServerStatusMessage.c ==========

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c:39]
                {
                        content = string.Format("Server [**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>) successfully started, player connect enabled.", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
                }
                else
                {
>>                      content = string.Format("**Server Status:** [%1](<http://dayzsalauncher.com/#/servercheck/%3:%2>) ", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c:46]
                        content += string.Format("Server FPS: **%1** ", g_Game.GetServerFPS());
                        content += string.Format("Players: **%1**", GetSteamAPIManager().GetTotalPlayerCount());
                }
        }

>>      override VPPWebhookEvent ToEvent()
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

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c:100]
                        embeds.Insert( embed );
                        return embed;
                }
                else
                {
>>                      embed = new WbEmbed(string.Format("**SERVER STATUS REPORT:**\n**%1**", g_Game.GetServerName()), 16766720, "", "", "");
                        field;
                        //---
                        field = embed.AddField();
                        field.SetName("Server Status:");

                string final;
                final                    += string.Format("[**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>)", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
                        final                    += string.Format("\nUp-Time: %1", FormatUpTime());
                        final                    += string.Format("\nServer FPS: %1", g_Game.GetServerFPS());

                        final                    += string.Format("\nPlayers: %1", GetSteamAPIManager().GetTotalPlayerCount());

                        field.SetValue(final);
                        field.Inline(false);
                        embeds.Insert( embed );
                        return embed;
                }
                return NULL;

[C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c:104]
                {
                        embed = new WbEmbed(string.Format("**SERVER STATUS REPORT:**\n**%1**", g_Game.GetServerName()), 16766720, "", "", "");
                        field;
                        //---
                        field = embed.AddField();
>>                      field.SetName("Server Status:");

                string final;
                final                    += string.Format("[**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>)", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
                        final                    += string.Format("\nUp-Time: %1", FormatUpTime());
                        final                    += string.Format("\nServer FPS: %1", g_Game.GetServerFPS());

                        final                    += string.Format("\nPlayers: %1", GetSteamAPIManager().GetTotalPlayerCount());

                        field.SetValue(final);
                        field.Inline(false);
                        embeds.Insert( embed );
                        return embed;
                }
                return NULL;
        }
};

========== 3. RESUMO ==========
[OK] Inspecao somente leitura concluida.
[OK] Nenhum arquivo foi alterado.
[OK] Nenhuma credencial foi exibida.
[OK] Nenhum servico foi iniciado ou reiniciado.
[OK] Nenhuma comunicacao foi enviada.
PS C:\RavenRP\ControlCenter\API>
