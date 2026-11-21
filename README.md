**********************
Início da transcrição do Windows PowerShell
Hora de início: 20261121004207
Nome de Usuário: DESKTOP-LDECQT3\Nasdara
Executar como Usuário: DESKTOP-LDECQT3\Nasdara
Nome da Configuração: 
Computador: DESKTOP-LDECQT3 (Microsoft Windows NT 10.0.19045.0)
Aplicativo Host: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
ID do Processo: 8092
PSVersion: 5.1.19041.6456
PSEdition: Desktop
PSCompatibleVersions: 1.0, 2.0, 3.0, 4.0, 5.0, 5.1.19041.6456
BuildVersion: 10.0.19041.6456
CLRVersion: 4.0.30319.42000
WSManStackVersion: 3.0
PSRemotingProtocolVersion: 2.3
SerializationVersion: 1.1.0.1
**********************

========== 1. LOCALIZAR ARQUIVOS ==========
Sender: C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c
Manager: C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c
Status: C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted\VPPAdminTools\4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c

========== 2. SENDER: ENVIO HTTP E CORPO ==========

Linha 2
// An event to send: its id and variables (VPPWebhookDefs lists the built-in ones). Other mods can emit their own ids
>> // with any variables through GetWebHooksManager().Emit(); templates for them are not name-checked.
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

Linha 150
		if (s_Free.Find(callback) < 0)
		{
			s_Free.Insert(callback);
		}
	}
};

/*
>> 	Runtime of one webhook (server): its compiled templates, the send queue (rate limited per minute, retried with
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

Linha 173
	// curl timeout, or a 2xx without a body (Discord without ?wait=true answers 204)
	const static int RESULT_NO_REPLY = 8;

	const static int MAX_QUEUE = 100;
	const static int MAX_IN_FLIGHT = 50;
	const static int MAX_ATTEMPTS = 4;

	protected WebHook m_Hook;
>> 	protected ref map<string, ref VPPWebhookTemplate> m_Templates;
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

Linha 185
	protected ref map<int, ref VPPWebhookRequestCallback> m_Callbacks;
	protected ref array<int> m_SentTimes;
	protected int m_NextJobId;
	ref VPPWebhookStats Stats;

	void VPPWebhookSender(WebHook hook)
	{
		m_Hook = hook;
>> 		m_Templates = new map<string, ref VPPWebhookTemplate>();
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


Linha 198
		Stats = new VPPWebhookStats();
	}

	WebHook GetHook()
	{
		return m_Hook;
	}

>> 	void SetTemplate(string eventId, VPPWebhookTemplate tpl)
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

Linha 200

	WebHook GetHook()
	{
		return m_Hook;
	}

	void SetTemplate(string eventId, VPPWebhookTemplate tpl)
	{
>> 		m_Templates.Set(eventId, tpl);
	}

	VPPWebhookTemplate GetTemplate(string eventId)
	{
		return m_Templates.Get(eventId);
	}

	bool IsJson()
	{
		return m_Hook.m_ContentType.Contains("json");
	}


Linha 203
		return m_Hook;
	}

	void SetTemplate(string eventId, VPPWebhookTemplate tpl)
	{
		m_Templates.Set(eventId, tpl);
	}

>> 	VPPWebhookTemplate GetTemplate(string eventId)
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

Linha 205

	void SetTemplate(string eventId, VPPWebhookTemplate tpl)
	{
		m_Templates.Set(eventId, tpl);
	}

	VPPWebhookTemplate GetTemplate(string eventId)
	{
>> 		return m_Templates.Get(eventId);
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

Linha 210

	VPPWebhookTemplate GetTemplate(string eventId)
	{
		return m_Templates.Get(eventId);
	}

	bool IsJson()
	{
>> 		return m_Hook.m_ContentType.Contains("json");
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

Linha 213
		return m_Templates.Get(eventId);
	}

	bool IsJson()
	{
		return m_Hook.m_ContentType.Contains("json");
	}

>> 	// Render with the webhook's variables added (hook.*) and its redaction applied; "" when there is no usable template.
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

Linha 214
	}

	bool IsJson()
	{
		return m_Hook.m_ContentType.Contains("json");
	}

	// Render with the webhook's variables added (hook.*) and its redaction applied; "" when there is no usable template.
>> 	string Render(VPPWebhookEvent webhookEvent)
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

Linha 216
	bool IsJson()
	{
		return m_Hook.m_ContentType.Contains("json");
	}

	// Render with the webhook's variables added (hook.*) and its redaction applied; "" when there is no usable template.
	string Render(VPPWebhookEvent webhookEvent)
	{
>> 		VPPWebhookTemplate tpl = m_Templates.Get(webhookEvent.Id);
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

Linha 232
		for (int i = 0; i < m_Hook.m_Vars.Count(); i++)
		{
			string hookKey = m_Hook.m_Vars.GetKey(i);
			string hookValue = m_Hook.m_Vars.GetElement(i);
			vars.Set("hook." + hookKey, hookValue);
		}

		Redact(vars);
>> 		bool jsonBody = IsJson();
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

Linha 233
		{
			string hookKey = m_Hook.m_Vars.GetKey(i);
			string hookValue = m_Hook.m_Vars.GetElement(i);
			vars.Set("hook." + hookKey, hookValue);
		}

		Redact(vars);
		bool jsonBody = IsJson();
>> 		return tpl.Render(vars, jsonBody);
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

Linha 263
			}
		}
	}

	// ---------------------------------------------------------------- queue

	void Enqueue(string eventId, string body, string testBy, int testReqId)
	{
>> 		if (body == "")
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

Linha 278
			m_Queue.RemoveOrdered(0);
			Stats.Dropped++;
		}

		VPPWebhookJob job = new VPPWebhookJob();
		m_NextJobId++;
		job.Id = m_NextJobId;
		job.EventId = eventId;
>> 		job.Body = body;
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

Linha 345
			Finish(job, false, "no URL or no RestApi");
			return;
		}

		job.Attempts++;
		VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
		m_Callbacks.Set(job.Id, callback);
		m_InFlight.Set(job.Id, job);
>> 		RestContext context = GetRestApi().GetRestContext(url);
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

Linha 346
			return;
		}

		job.Attempts++;
		VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
		m_Callbacks.Set(job.Id, callback);
		m_InFlight.Set(job.Id, job);
		RestContext context = GetRestApi().GetRestContext(url);
>> 		context.SetHeader(m_Hook.m_ContentType);
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

Linha 347
		}

		job.Attempts++;
		VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
		m_Callbacks.Set(job.Id, callback);
		m_InFlight.Set(job.Id, job);
		RestContext context = GetRestApi().GetRestContext(url);
		context.SetHeader(m_Hook.m_ContentType);
>> 		context.POST(callback, "", job.Body);
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

Linha 457
		VPPJsonCheckResult verdict = null;
		array<string> problems = new array<string>();
		if (!FileExist(dir))
		{
			MakeDirectory(dir);
		}

		path = dir + "/" + m_Hook.m_Id + "_" + job.EventId + ".txt";
>> 		VPPXmlText.WriteAll(path, job.Body);
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

Linha 464
		path = dir + "/" + m_Hook.m_Id + "_" + job.EventId + ".txt";
		VPPXmlText.WriteAll(path, job.Body);
		Print("[WebHooksManager] Rejected body saved to " + path);
		if (!IsJson())
		{
			return;
		}

>> 		verdict = VPPJsonCheck.Check(job.Body);
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

Linha 484
		{
			string presetName = m_Hook.m_Preset;
			Print("[WebHooksManager] The URL is a Discord webhook but the preset is " + presetName + ": Discord only accepts the discord_embed / discord_simple formats");
			return;
		}

		if (discordPreset)
		{
>> 			VPPDiscordLint.Check(job.Body, problems);
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

Linha 540
		int second;
		GetYearMonthDayUTC(year, month, day);
		GetHourMinuteSecondUTC(hour, minute, second);
		string dateText = VPPWebhookClock.Pad(year, 4) + "-" + VPPWebhookClock.Pad(month, 2) + "-" + VPPWebhookClock.Pad(day, 2);
		return dateText + " " + VPPWebhookClock.Pad(hour, 2) + ":" + VPPWebhookClock.Pad(minute, 2) + ":" + VPPWebhookClock.Pad(second, 2) + " UTC";
	}
};

>> // UTC time texts for the common template variables.
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

========== 3. MANAGER: EMIT E TEMPLATE ==========

Linha 2
/*
>> 	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
	- Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
	  its preset when missing, so server owners can also edit them in a text editor (ReloadTemplates picks changes up).
	- Delivery: VPPWebhookSender (rate limit, retries, stats), pumped here once a second.
	- Old configs (v0: per-category switches + "simplified") are migrated to events + the Discord preset with the same
	  switches, so nothing changes until an admin edits a template.
*/
class WebHooksManager: ConfigurablePlugin

Linha 4
/*
	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

>> 	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
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

Linha 5
/*
	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
>> 	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
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

Linha 6
/*
	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
>> 	- Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
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

Linha 7
	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.

	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
	- Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
>> 	  its preset when missing, so server owners can also edit them in a text editor (ReloadTemplates picks changes up).
	- Delivery: VPPWebhookSender (rate limit, retries, stats), pumped here once a second.
	- Old configs (v0: per-category switches + "simplified") are migrated to events + the Discord preset with the same
	  switches, so nothing changes until an admin edits a template.
*/
class WebHooksManager: ConfigurablePlugin
{
	const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
	const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
	const static string TEMPLATE_EXT = ".tpl";


Linha 10
	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
	- Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
	  its preset when missing, so server owners can also edit them in a text editor (ReloadTemplates picks changes up).
	- Delivery: VPPWebhookSender (rate limit, retries, stats), pumped here once a second.
	- Old configs (v0: per-category switches + "simplified") are migrated to events + the Discord preset with the same
>> 	  switches, so nothing changes until an admin edits a template.
*/
class WebHooksManager: ConfigurablePlugin
{
	const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
	const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
	const static string TEMPLATE_EXT = ".tpl";

	private ref array<ref WebHook> 		 M_DATA;

	[NonSerialized()]

Linha 15
	  switches, so nothing changes until an admin edits a template.
*/
class WebHooksManager: ConfigurablePlugin
{
	const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
>> 	const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
	const static string TEMPLATE_EXT = ".tpl";

	private ref array<ref WebHook> 		 M_DATA;

	[NonSerialized()]
	protected ref map<string, ref VPPWebhookSender> m_Senders;
	// senders of deleted / replaced webhooks: kept until the engine answered their requests
	[NonSerialized()]
	protected ref array<ref VPPWebhookSender> m_Retired;
	// next server status time (GetGame().GetTime()) per webhook id

Linha 16
*/
class WebHooksManager: ConfigurablePlugin
{
	const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
	const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
>> 	const static string TEMPLATE_EXT = ".tpl";

	private ref array<ref WebHook> 		 M_DATA;

	[NonSerialized()]
	protected ref map<string, ref VPPWebhookSender> m_Senders;
	// senders of deleted / replaced webhooks: kept until the engine answered their requests
	[NonSerialized()]
	protected ref array<ref VPPWebhookSender> m_Retired;
	// next server status time (GetGame().GetTime()) per webhook id
	[NonSerialized()]

Linha 32
	protected ref map<string, int> m_StatusDue;
	[NonSerialized()]
	protected bool m_Ticking;
	[NonSerialized()]
	protected int m_IdSerial;
>> 	// a preset template hash changed (WebHooks.json needs saving)
	[NonSerialized()]
	protected bool m_TemplatesDirty;

	void WebHooksManager()
	{
		M_DATA = new array<ref WebHook>;
		m_Senders = new map<string, ref VPPWebhookSender>();
		m_Retired = new array<ref VPPWebhookSender>();
		m_StatusDue = new map<string, int>();


Linha 34
	protected bool m_Ticking;
	[NonSerialized()]
	protected int m_IdSerial;
	// a preset template hash changed (WebHooks.json needs saving)
	[NonSerialized()]
>> 	protected bool m_TemplatesDirty;

	void WebHooksManager()
	{
		M_DATA = new array<ref WebHook>;
		m_Senders = new map<string, ref VPPWebhookSender>();
		m_Retired = new array<ref VPPWebhookSender>();
		m_StatusDue = new map<string, int>();

		if (!FileExist(ROOT_DIR))
			MakeDirectory(ROOT_DIR);

Linha 52

		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "CreateWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
>> 		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
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

Linha 53
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "CreateWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
>> 		GetRPCManager().AddRPC("RPC_WebHooksManager", "ValidateTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ReloadTemplates", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebhookById", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DuplicateWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ResetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebhookStats", this, SingleplayerExecutionType.Server);
	}


Linha 54
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "CreateWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ValidateTemplate", this, SingleplayerExecutionType.Server);
>> 		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ReloadTemplates", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebhookById", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DuplicateWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ResetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebhookStats", this, SingleplayerExecutionType.Server);
	}

	void ~WebHooksManager()

Linha 56
		GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ValidateTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
>> 		GetRPCManager().AddRPC("RPC_WebHooksManager", "ReloadTemplates", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebhookById", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DuplicateWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ResetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebhookStats", this, SingleplayerExecutionType.Server);
	}

	void ~WebHooksManager()
	{
		if (GetGame())

Linha 60
		GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "ReloadTemplates", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveWebhook", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebhookById", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "DuplicateWebhook", this, SingleplayerExecutionType.Server);
>> 		GetRPCManager().AddRPC("RPC_WebHooksManager", "ResetTemplate", this, SingleplayerExecutionType.Server);
		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebhookStats", this, SingleplayerExecutionType.Server);
	}

	void ~WebHooksManager()
	{
		if (GetGame())
		{
			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).Remove(this.Tick);
		}
	}

Linha 92
		}

		if (migrated)
		{
			Save();
>> 			Print("[WebHooksManager] Webhooks migrated to templated events (v" + WebHook.VERSION.ToString() + ")");
		}

		WriteReadme();
		foreach (WebHook loaded : M_DATA)
		{
			if (loaded)
			{
				StartSender(loaded);
			}
		}

Linha 100
		WriteReadme();
		foreach (WebHook loaded : M_DATA)
		{
			if (loaded)
			{
>> 				StartSender(loaded);
			}
		}

		SaveIfTemplatesChanged();

		if (!m_Ticking)
		{
			m_Ticking = true;
			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.Tick, 1000, true);
		}

Linha 104
			{
				StartSender(loaded);
			}
		}

>> 		SaveIfTemplatesChanged();

		if (!m_Ticking)
		{
			m_Ticking = true;
			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.Tick, 1000, true);
		}
	}

	override void Load()
	{

Linha 143
	// ---------------------------------------------------------------- events

	/*
		Called from many other instances such as admin logs and vppat plugins
	*/
>> 	void PostData(typename messageType, WebHookMessageBase dataClass)
	{
		if (!dataClass)
		{
			return;
		}

		VPPWebhookEvent webhookEvent = dataClass.ToEvent();
		if (webhookEvent)
		{
			Emit(webhookEvent);

Linha 153
		}

		VPPWebhookEvent webhookEvent = dataClass.ToEvent();
		if (webhookEvent)
		{
>> 			Emit(webhookEvent);
		}
	}

	void PostServerBootup()
	{
		VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
		Emit(bootEvent);
	}

	// Sends an event to every webhook that has it enabled and whose filters let it through.

Linha 160
	}

	void PostServerBootup()
	{
		VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
>> 		Emit(bootEvent);
	}

	// Sends an event to every webhook that has it enabled and whose filters let it through.
	void Emit(VPPWebhookEvent webhookEvent)
	{
		if (!webhookEvent || !CanSend() || !M_DATA || M_DATA.Count() == 0)
		{
			return;
		}


Linha 164
		VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
		Emit(bootEvent);
	}

	// Sends an event to every webhook that has it enabled and whose filters let it through.
>> 	void Emit(VPPWebhookEvent webhookEvent)
	{
		if (!webhookEvent || !CanSend() || !M_DATA || M_DATA.Count() == 0)
		{
			return;
		}

		FillCommonVars(webhookEvent);
		foreach (WebHook hook : M_DATA)
		{
			if (!hook || !hook.IsEventEnabled(webhookEvent.Id))

Linha 189

			SendTo(hook, webhookEvent, "", 0);
		}
	}

>> 	// false when the webhook has no sender or no usable template for the event (nothing is sent)
	protected bool SendTo(WebHook hook, VPPWebhookEvent webhookEvent, string testBy, int testReqId)
	{
		VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
		if (!sender)
		{
			return false;
		}

		string body = sender.Render(webhookEvent);
		if (body == "")

Linha 198
		if (!sender)
		{
			return false;
		}

>> 		string body = sender.Render(webhookEvent);
		if (body == "")
		{
			return false;
		}

		sender.Enqueue(webhookEvent.Id, body, testBy, testReqId);
		return true;
	}

	protected bool CanSend()

Linha 305
		}

		return true;
	}

>> 	// ---------------------------------------------------------------- senders, templates

	protected void StartSender(WebHook hook)
	{
		VPPWebhookSender sender = new VPPWebhookSender(hook);
		m_Senders.Set(hook.m_Id, sender);
		LoadTemplates(hook, sender, true);
		int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
		m_StatusDue.Set(hook.m_Id, due);
	}


Linha 307
		return true;
	}

	// ---------------------------------------------------------------- senders, templates

>> 	protected void StartSender(WebHook hook)
	{
		VPPWebhookSender sender = new VPPWebhookSender(hook);
		m_Senders.Set(hook.m_Id, sender);
		LoadTemplates(hook, sender, true);
		int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
		m_StatusDue.Set(hook.m_Id, due);
	}

	// The old sender keeps living until its requests are answered (the engine holds its callbacks).
	protected void RetireSender(string hookId)

Linha 311

	protected void StartSender(WebHook hook)
	{
		VPPWebhookSender sender = new VPPWebhookSender(hook);
		m_Senders.Set(hook.m_Id, sender);
>> 		LoadTemplates(hook, sender, true);
		int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
		m_StatusDue.Set(hook.m_Id, due);
	}

	// The old sender keeps living until its requests are answered (the engine holds its callbacks).
	protected void RetireSender(string hookId)
	{
		VPPWebhookSender sender = m_Senders.Get(hookId);
		if (sender)
		{

Linha 329

		m_Senders.Remove(hookId);
		m_StatusDue.Remove(hookId);
	}

>> 	string TemplatePath(WebHook hook, string eventId)
	{
		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
	}

	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
	// Returns how many templates have errors (they are logged; such an event sends nothing until fixed).
	protected int LoadTemplates(WebHook hook, VPPWebhookSender sender, bool logIssues)
	{
		EnsureHookDir(hook);
		int broken = 0;

Linha 331
		m_StatusDue.Remove(hookId);
	}

	string TemplatePath(WebHook hook, string eventId)
	{
>> 		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
	}

	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
	// Returns how many templates have errors (they are logged; such an event sends nothing until fixed).
	protected int LoadTemplates(WebHook hook, VPPWebhookSender sender, bool logIssues)
	{
		EnsureHookDir(hook);
		int broken = 0;
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)

Linha 334
	string TemplatePath(WebHook hook, string eventId)
	{
		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
	}

>> 	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
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

Linha 335
	{
		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
	}

	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
>> 	// Returns how many templates have errors (they are logged; such an event sends nothing until fixed).
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

Linha 336
		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
	}

	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
	// Returns how many templates have errors (they are logged; such an event sends nothing until fixed).
>> 	protected int LoadTemplates(WebHook hook, VPPWebhookSender sender, bool logIssues)
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

Linha 343
		EnsureHookDir(hook);
		int broken = 0;
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
>> 			string path = TemplatePath(hook, def.Id);
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

Linha 344
		int broken = 0;
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			string path = TemplatePath(hook, def.Id);
>> 			RefreshPresetTemplate(hook, def.Id, false);
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

Linha 347
		{
			string path = TemplatePath(hook, def.Id);
			RefreshPresetTemplate(hook, def.Id, false);
			string text = "";
			VPPXmlText.ReadAll(path, text);
>> 			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
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

Linha 349
			RefreshPresetTemplate(hook, def.Id, false);
			string text = "";
			VPPXmlText.ReadAll(path, text);
			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
>> 			sender.SetTemplate(def.Id, tpl);
			if (tpl.HasErrors())
			{
				broken++;
				if (logIssues)
				{
					LogIssues(hook, def.Id, tpl);
				}
			}
		}


Linha 363
		}

		return broken;
	}

>> 	protected void LogIssues(WebHook hook, string eventId, VPPWebhookTemplate tpl)
	{
		string hookName = hook.GetName();
		foreach (VPPWebhookIssue issue : tpl.Issues)
		{
			string where = eventId + TEMPLATE_EXT + ":" + issue.Line.ToString() + ":" + issue.Col.ToString();
			Print("[WebHooksManager] \"" + hookName + "\" " + where + " " + issue.Message);
		}
	}

	protected void EnsureHookDir(WebHook hook)

Linha 368
	protected void LogIssues(WebHook hook, string eventId, VPPWebhookTemplate tpl)
	{
		string hookName = hook.GetName();
		foreach (VPPWebhookIssue issue : tpl.Issues)
		{
>> 			string where = eventId + TEMPLATE_EXT + ":" + issue.Line.ToString() + ":" + issue.Col.ToString();
			Print("[WebHooksManager] \"" + hookName + "\" " + where + " " + issue.Message);
		}
	}

	protected void EnsureHookDir(WebHook hook)
	{
		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

Linha 375
		}
	}

	protected void EnsureHookDir(WebHook hook)
	{
>> 		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

		string hookDir = TEMPLATE_DIR + "/" + hook.m_Id;
		if (!FileExist(hookDir))
		{
			MakeDirectory(hookDir);
		}
	}

Linha 377

	protected void EnsureHookDir(WebHook hook)
	{
		if (!FileExist(TEMPLATE_DIR))
		{
>> 			MakeDirectory(TEMPLATE_DIR);
		}

		string hookDir = TEMPLATE_DIR + "/" + hook.m_Id;
		if (!FileExist(hookDir))
		{
			MakeDirectory(hookDir);
		}
	}

	// (Re)writes every template of the webhook from its preset.

Linha 380
		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

>> 		string hookDir = TEMPLATE_DIR + "/" + hook.m_Id;
		if (!FileExist(hookDir))
		{
			MakeDirectory(hookDir);
		}
	}

	// (Re)writes every template of the webhook from its preset.
	protected void WritePresetTemplates(WebHook hook)
	{
		EnsureHookDir(hook);

Linha 387
		{
			MakeDirectory(hookDir);
		}
	}

>> 	// (Re)writes every template of the webhook from its preset.
	protected void WritePresetTemplates(WebHook hook)
	{
		EnsureHookDir(hook);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			RefreshPresetTemplate(hook, def.Id, true);
		}
	}


Linha 388
			MakeDirectory(hookDir);
		}
	}

	// (Re)writes every template of the webhook from its preset.
>> 	protected void WritePresetTemplates(WebHook hook)
	{
		EnsureHookDir(hook);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			RefreshPresetTemplate(hook, def.Id, true);
		}
	}

	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still

Linha 394
	{
		EnsureHookDir(hook);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
>> 			RefreshPresetTemplate(hook, def.Id, true);
		}
	}

	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still
	// exactly the preset text this server wrote earlier (so preset fixes reach untouched files). A file an admin
	// edited, or one written before hashes were tracked that differs from the preset, is left alone.
	protected void RefreshPresetTemplate(WebHook hook, string eventId, bool force)
	{
		string path = TemplatePath(hook, eventId);
		string presetText = VPPWebhookPresets.TemplateFor(hook.m_Preset, eventId);

Linha 398
		{
			RefreshPresetTemplate(hook, def.Id, true);
		}
	}

>> 	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still
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

Linha 401
	}

	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still
	// exactly the preset text this server wrote earlier (so preset fixes reach untouched files). A file an admin
	// edited, or one written before hashes were tracked that differs from the preset, is left alone.
>> 	protected void RefreshPresetTemplate(WebHook hook, string eventId, bool force)
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

Linha 403
	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still
	// exactly the preset text this server wrote earlier (so preset fixes reach untouched files). A file an admin
	// edited, or one written before hashes were tracked that differs from the preset, is left alone.
	protected void RefreshPresetTemplate(WebHook hook, string eventId, bool force)
	{
>> 		string path = TemplatePath(hook, eventId);
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

Linha 404
	// exactly the preset text this server wrote earlier (so preset fixes reach untouched files). A file an admin
	// edited, or one written before hashes were tracked that differs from the preset, is left alone.
	protected void RefreshPresetTemplate(WebHook hook, string eventId, bool force)
	{
		string path = TemplatePath(hook, eventId);
>> 		string presetText = VPPWebhookPresets.TemplateFor(hook.m_Preset, eventId);
		int presetHash = VPPXmlText.NormalizedHash(presetText);
		string current = "";
		int currentHash = 0;
		int writtenHash = 0;
		bool known = hook.m_PresetHashes.Contains(eventId);
		if (known)
		{
			writtenHash = hook.m_PresetHashes.Get(eventId);
		}


Linha 424
			if (currentHash == presetHash)
			{
				if (!known || writtenHash != presetHash)
				{
					hook.m_PresetHashes.Set(eventId, presetHash);
>> 					m_TemplatesDirty = true;
				}

				return;
			}

			if (!known || writtenHash != currentHash)
			{
				return;
			}


Linha 436
			{
				return;
			}

			string hookName = hook.GetName();
>> 			Print("[WebHooksManager] \"" + hookName + "\" " + eventId + TEMPLATE_EXT + " updated to the current preset");
		}

		VPPXmlText.WriteAll(path, presetText);
		hook.m_PresetHashes.Set(eventId, presetHash);
		m_TemplatesDirty = true;
	}

	protected void SaveIfTemplatesChanged()
	{
		if (!m_TemplatesDirty)

Linha 441
			Print("[WebHooksManager] \"" + hookName + "\" " + eventId + TEMPLATE_EXT + " updated to the current preset");
		}

		VPPXmlText.WriteAll(path, presetText);
		hook.m_PresetHashes.Set(eventId, presetHash);
>> 		m_TemplatesDirty = true;
	}

	protected void SaveIfTemplatesChanged()
	{
		if (!m_TemplatesDirty)
		{
			return;
		}

		m_TemplatesDirty = false;

Linha 444
		VPPXmlText.WriteAll(path, presetText);
		hook.m_PresetHashes.Set(eventId, presetHash);
		m_TemplatesDirty = true;
	}

>> 	protected void SaveIfTemplatesChanged()
	{
		if (!m_TemplatesDirty)
		{
			return;
		}

		m_TemplatesDirty = false;
		Save();
	}


Linha 446
		m_TemplatesDirty = true;
	}

	protected void SaveIfTemplatesChanged()
	{
>> 		if (!m_TemplatesDirty)
		{
			return;
		}

		m_TemplatesDirty = false;
		Save();
	}

	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
	protected void WriteReadme()

Linha 451
		if (!m_TemplatesDirty)
		{
			return;
		}

>> 		m_TemplatesDirty = false;
		Save();
	}

	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
	protected void WriteReadme()
	{
		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

Linha 455

		m_TemplatesDirty = false;
		Save();
	}

>> 	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
	protected void WriteReadme()
	{
		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

		string nl = "\n";
		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
		text = text + "Each webhook has a folder named after its id with one <event>.tpl per event: the request body sent for it." + nl;

Linha 458
	}

	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
	protected void WriteReadme()
	{
>> 		if (!FileExist(TEMPLATE_DIR))
		{
			MakeDirectory(TEMPLATE_DIR);
		}

		string nl = "\n";
		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
		text = text + "Each webhook has a folder named after its id with one <event>.tpl per event: the request body sent for it." + nl;
		text = text + "Edit them here or in the WebHooks menu; the server reads them at start (or on Reload in the menu)." + nl;
		text = text + "Delete a file to get the webhook's preset template back." + nl + nl;
		text = text + "Syntax:" + nl;

Linha 460
	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
	protected void WriteReadme()
	{
		if (!FileExist(TEMPLATE_DIR))
		{
>> 			MakeDirectory(TEMPLATE_DIR);
		}

		string nl = "\n";
		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
		text = text + "Each webhook has a folder named after its id with one <event>.tpl per event: the request body sent for it." + nl;
		text = text + "Edit them here or in the WebHooks menu; the server reads them at start (or on Reload in the menu)." + nl;
		text = text + "Delete a file to get the webhook's preset template back." + nl + nl;
		text = text + "Syntax:" + nl;
		text = text + "  {{victim.name}}                        a variable (JSON-escaped for JSON webhooks)" + nl;
		text = text + "  {{victim.id|steamurl}}                 filters: upper lower trim truncate:N default:TEXT round:N number steamurl raw json" + nl;

Linha 464
		{
			MakeDirectory(TEMPLATE_DIR);
		}

		string nl = "\n";
>> 		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
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

Linha 467

		string nl = "\n";
		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
		text = text + "Each webhook has a folder named after its id with one <event>.tpl per event: the request body sent for it." + nl;
		text = text + "Edit them here or in the WebHooks menu; the server reads them at start (or on Reload in the menu)." + nl;
>> 		text = text + "Delete a file to get the webhook's preset template back." + nl + nl;
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

Linha 497
			{
				text = text + "    {{" + webhookVar.Name + "}}  e.g. " + webhookVar.Sample + nl;
			}
		}

>> 		string readmePath = TEMPLATE_DIR + "/README.txt";
		VPPXmlText.WriteAll(readmePath, text);
	}

	// ---------------------------------------------------------------- tick

	void Tick()
	{
		int now = GetGame().GetTime();
		foreach (WebHook hook : M_DATA)
		{

Linha 599
		if (perms.VerifyPermission(plainId, "MenuWebHooks:Delete", "", false))
		{
			access = access | VPPWebhookAccess.DELETE;
		}

>> 		if (perms.VerifyPermission(plainId, "MenuWebHooks:EditTemplates", "", false))
		{
			access = access | VPPWebhookAccess.EDIT_TEMPLATES;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:TestSend", "", false))
		{
			access = access | VPPWebhookAccess.TEST_SEND;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:ViewURL", "", false))

Linha 601
			access = access | VPPWebhookAccess.DELETE;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:EditTemplates", "", false))
		{
>> 			access = access | VPPWebhookAccess.EDIT_TEMPLATES;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:TestSend", "", false))
		{
			access = access | VPPWebhookAccess.TEST_SEND;
		}

		if (perms.VerifyPermission(plainId, "MenuWebHooks:ViewURL", "", false))
		{
			access = access | VPPWebhookAccess.VIEW_URL;

Linha 643

			if (data.param1 >= 0 && data.param1 < M_DATA.Count() && M_DATA.Get(data.param1).GetName() == data.param2)
			{
				WebHook removed = M_DATA.Get(data.param1);
				string removedName = removed.GetName();
>> 				GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Deleted WebHook: " + removedName));
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

Linha 685
			webHook.m_Version = 0;
			webHook.m_Preset = "";
			webHook.m_ContentType = "";
			webHook.Migrate(NextSerial());
			M_DATA.Insert(webHook);
>> 			WritePresetTemplates(webHook);
			StartSender(webHook);

			string createdName = webHook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Created new WebHook: " + createdName));
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"New WebHook: " + createdName + " successfully created and saved!", NotifyTypes.NOTIFY);
			Save();
			WriteReadme();
			SendList(sender);
		}
	}

Linha 686
			webHook.m_Preset = "";
			webHook.m_ContentType = "";
			webHook.Migrate(NextSerial());
			M_DATA.Insert(webHook);
			WritePresetTemplates(webHook);
>> 			StartSender(webHook);

			string createdName = webHook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Created new WebHook: " + createdName));
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"New WebHook: " + createdName + " successfully created and saved!", NotifyTypes.NOTIFY);
			Save();
			WriteReadme();
			SendList(sender);
		}
	}


Linha 689
			M_DATA.Insert(webHook);
			WritePresetTemplates(webHook);
			StartSender(webHook);

			string createdName = webHook.GetName();
>> 			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Created new WebHook: " + createdName));
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"New WebHook: " + createdName + " successfully created and saved!", NotifyTypes.NOTIFY);
			Save();
			WriteReadme();
			SendList(sender);
		}
	}

	// The current menu edits name, URL, the category switches, the status interval and "simplified": they are merged
	// into the stored webhook, which keeps its id, templates, variables and filters.
	void EditWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)

Linha 698
			SendList(sender);
		}
	}

	// The current menu edits name, URL, the category switches, the status interval and "simplified": they are merged
>> 	// into the stored webhook, which keeps its id, templates, variables and filters.
	void EditWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if(type == CallType.Server && sender)
		{
			Param3<int,string,ref WebHook> data;

			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Edit"))
				return;

			if (!ctx.Read(data))

Linha 727
			{
				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"Failed to save changes to webhook: " + editedName + "\n\nCould not find old instance, another admin deleted it?", NotifyTypes.NOTIFY);
				return;
			}

>> 			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Edited WebHook: " + storedName));
			stored.SetName(editedName);
			string newUrl = edited.GetURL();
			if (newUrl != "" && !WebHook.IsMasked(newUrl))
				stored.SetURL(newUrl);

			stored.m_deathKillLogs = edited.m_deathKillLogs;
			stored.m_adminActivityLog = edited.m_adminActivityLog;
			stored.m_admHitLog = edited.m_admHitLog;
			stored.m_joinLeaveLog = edited.m_joinLeaveLog;
			stored.m_serverStatusLog = edited.m_serverStatusLog;

Linha 731

			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Edited WebHook: " + storedName));
			stored.SetName(editedName);
			string newUrl = edited.GetURL();
			if (newUrl != "" && !WebHook.IsMasked(newUrl))
>> 				stored.SetURL(newUrl);

			stored.m_deathKillLogs = edited.m_deathKillLogs;
			stored.m_adminActivityLog = edited.m_adminActivityLog;
			stored.m_admHitLog = edited.m_admHitLog;
			stored.m_joinLeaveLog = edited.m_joinLeaveLog;
			stored.m_serverStatusLog = edited.m_serverStatusLog;
			VPPWebHookServerStatsTime editedInterval = edited.GetServerStatsInterval();
			stored.SetServerStatsInterval(editedInterval);
			stored.SyncEventsFromSwitches();
			bool presetChanged = false;

Linha 754
			}

			stored.m_simplifiedMessages = edited.m_simplifiedMessages;
			stored.Migrate(NextSerial());
			if (presetChanged)
>> 				WritePresetTemplates(stored);

			RetireSender(stored.m_Id);
			StartSender(stored);
			Save();
			WriteReadme();
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"WebHook: " + editedName + " was successfully edited & saved!", NotifyTypes.NOTIFY);
			SendList(sender);
		}
	}


Linha 757
			stored.Migrate(NextSerial());
			if (presetChanged)
				WritePresetTemplates(stored);

			RetireSender(stored.m_Id);
>> 			StartSender(stored);
			Save();
			WriteReadme();
			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"WebHook: " + editedName + " was successfully edited & saved!", NotifyTypes.NOTIFY);
			SendList(sender);
		}
	}

	// ---------------------------------------------------------------- webhook RPCs of the new menu

	protected void ReplySaved(PlayerIdentity sender, int reqId, bool ok, string hookId, string error)

Linha 800

		return false;
	}

	// Creates (empty or unknown m_Id) or updates a webhook with everything the menu edits. A changed preset rewrites
>> 	// the webhook's templates from the new preset; the legacy switches are kept in step for older tools.
	void SaveWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param2<int, ref WebHook> data;
		if (!ctx.Read(data))
		{

Linha 887

		bool presetChanged = stored.m_Preset != newPreset;
		stored.SetName(newName);
		if (urlGiven)
		{
>> 			stored.SetURL(newUrl);
		}

		stored.m_Preset = newPreset;
		string contentType = incoming.m_ContentType;
		contentType = contentType.Trim();
		if (contentType == "")
		{
			contentType = VPPWebhookPresets.ContentTypeOf(newPreset);
		}


Linha 921
		CopyVars(incoming, stored);
		CopyEvents(incoming, stored);
		stored.SyncSwitchesFromEvents();
		if (creating || presetChanged)
		{
>> 			WritePresetTemplates(stored);
		}

		RetireSender(stored.m_Id);
		StartSender(stored);
		Save();
		SaveIfTemplatesChanged();
		WriteReadme();
		string verb = "Edited";
		if (creating)
		{

Linha 925
		{
			WritePresetTemplates(stored);
		}

		RetireSender(stored.m_Id);
>> 		StartSender(stored);
		Save();
		SaveIfTemplatesChanged();
		WriteReadme();
		string verb = "Edited";
		if (creating)
		{
			verb = "Created";
		}

		string logText = "[WebHooksManager] " + verb + " WebHook: " + newName;

Linha 927
		}

		RetireSender(stored.m_Id);
		StartSender(stored);
		Save();
>> 		SaveIfTemplatesChanged();
		WriteReadme();
		string verb = "Edited";
		if (creating)
		{
			verb = "Created";
		}

		string logText = "[WebHooksManager] " + verb + " WebHook: " + newName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, reqId, true, stored.m_Id, "");

Linha 936
		{
			verb = "Created";
		}

		string logText = "[WebHooksManager] " + verb + " WebHook: " + newName;
>> 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, reqId, true, stored.m_Id, "");
		SendList(sender);
	}

	protected VPPWebHookServerStatsTime ValidInterval(VPPWebHookServerStatsTime interval)
	{
		if (interval == VPPWebHookServerStatsTime.ONE_MINUTE || interval == VPPWebHookServerStatsTime.FIVE_MINUTES)
		{
			return interval;
		}

Linha 1086
		RetireSender(removed.m_Id);
		M_DATA.RemoveOrdered(index);
		Save();
		WriteReadme();
		string logText = "[WebHooksManager] Deleted WebHook: " + removedName;
>> 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		SendList(sender);
	}

	// A copy with a new id, " (copy)" name and copies of all its template files.
	void DuplicateWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

Linha 1090
		string logText = "[WebHooksManager] Deleted WebHook: " + removedName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		SendList(sender);
	}

>> 	// A copy with a new id, " (copy)" name and copies of all its template files.
	void DuplicateWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param2<int, string> data;
		if (!ctx.Read(data))
		{

Linha 1134
		copy.m_PresetHashes.Copy(source.m_PresetHashes);
		EnsureHookDir(copy);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
>> 			string fromPath = TemplatePath(source, def.Id);
			string toPath = TemplatePath(copy, def.Id);
			string text = "";
			bool readOk = false;
			if (FileExist(fromPath))
			{
				readOk = VPPXmlText.ReadAll(fromPath, text);
			}

			if (readOk)
			{

Linha 1135
		EnsureHookDir(copy);
		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
		foreach (VPPWebhookEventDef def : eventDefs)
		{
			string fromPath = TemplatePath(source, def.Id);
>> 			string toPath = TemplatePath(copy, def.Id);
			string text = "";
			bool readOk = false;
			if (FileExist(fromPath))
			{
				readOk = VPPXmlText.ReadAll(fromPath, text);
			}

			if (readOk)
			{
				VPPXmlText.WriteAll(toPath, text);

Linha 1150
				VPPXmlText.WriteAll(toPath, text);
			}
		}

		M_DATA.Insert(copy);
>> 		StartSender(copy);
		Save();
		SaveIfTemplatesChanged();
		WriteReadme();
		string logText = "[WebHooksManager] Duplicated WebHook: " + copyName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, data.param1, true, copy.m_Id, "");
		SendList(sender);
	}

	// Puts one event template back to the webhook's preset and answers like GetTemplate.

Linha 1152
		}

		M_DATA.Insert(copy);
		StartSender(copy);
		Save();
>> 		SaveIfTemplatesChanged();
		WriteReadme();
		string logText = "[WebHooksManager] Duplicated WebHook: " + copyName;
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, data.param1, true, copy.m_Id, "");
		SendList(sender);
	}

	// Puts one event template back to the webhook's preset and answers like GetTemplate.
	void ResetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{

Linha 1155
		StartSender(copy);
		Save();
		SaveIfTemplatesChanged();
		WriteReadme();
		string logText = "[WebHooksManager] Duplicated WebHook: " + copyName;
>> 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, data.param1, true, copy.m_Id, "");
		SendList(sender);
	}

	// Puts one event template back to the webhook's preset and answers like GetTemplate.
	void ResetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;

Linha 1160
		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
		ReplySaved(sender, data.param1, true, copy.m_Id, "");
		SendList(sender);
	}

>> 	// Puts one event template back to the webhook's preset and answers like GetTemplate.
	void ResetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param3<int, string, string> data;
		if (!ctx.Read(data))
		{

Linha 1161
		ReplySaved(sender, data.param1, true, copy.m_Id, "");
		SendList(sender);
	}

	// Puts one event template back to the webhook's preset and answers like GetTemplate.
>> 	void ResetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param3<int, string, string> data;
		if (!ctx.Read(data))
		{
			return;

Linha 1175
		{
			return;
		}

		string plainId = sender.GetPlainId();
>> 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
		if (!hook || !def)
		{
			return;
		}

Linha 1188
		{
			return;
		}

		EnsureHookDir(hook);
>> 		RefreshPresetTemplate(hook, def.Id, true);
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

Linha 1190
		}

		EnsureHookDir(hook);
		RefreshPresetTemplate(hook, def.Id, true);
		string text = "";
>> 		string path = TemplatePath(hook, def.Id);
		VPPXmlText.ReadAll(path, text);
		VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
		if (hookSender)
		{
			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
			hookSender.SetTemplate(def.Id, tpl);
		}

		SaveIfTemplatesChanged();

Linha 1195
		string path = TemplatePath(hook, def.Id);
		VPPXmlText.ReadAll(path, text);
		VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
		if (hookSender)
		{
>> 			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
			hookSender.SetTemplate(def.Id, tpl);
		}

		SaveIfTemplatesChanged();
		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		reply.Text = text;

Linha 1197
		VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
		if (hookSender)
		{
			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
>> 			hookSender.SetTemplate(def.Id, tpl);
		}

		SaveIfTemplatesChanged();
		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

Linha 1200
			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
			tpl.Parse(text, def);
			hookSender.SetTemplate(def.Id, tpl);
		}

>> 		SaveIfTemplatesChanged();
		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void GetWebhookStats(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{

Linha 1201
			tpl.Parse(text, def);
			hookSender.SetTemplate(def.Id, tpl);
		}

		SaveIfTemplatesChanged();
>> 		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void GetWebhookStats(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)

Linha 1206
		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		reply.Text = text;
>> 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void GetWebhookStats(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks", "", false))

Linha 1253
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnStats", new Param1<ref array<ref VPPWebhookStatsWire>>(rows), true, sender);
	}

>> 	// ---------------------------------------------------------------- template RPCs (webhook editor)

	protected WebHook FindHook(string hookId)
	{
		foreach (WebHook hook : M_DATA)
		{
			if (hook && hook.m_Id == hookId)
			{
				return hook;
			}
		}

Linha 1268
		}

		return null;
	}

>> 	void GetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param3<int, string, string> data;
		if (!ctx.Read(data))
		{
			return;

Linha 1281
		if (!ctx.Read(data))
		{
			return;
		}

>> 		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		if (!hook || !VPPWebhookDefs.Get(data.param3))
		{
			return;
		}


Linha 1292
		if (!hook || !VPPWebhookDefs.Get(data.param3))
		{
			return;
		}

>> 		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = data.param2;
		reply.EventId = data.param3;
		string text = "";
		string path = TemplatePath(hook, data.param3);
		VPPXmlText.ReadAll(path, text);
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}


Linha 1297
		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
		reply.ReqId = data.param1;
		reply.HookId = data.param2;
		reply.EventId = data.param3;
		string text = "";
>> 		string path = TemplatePath(hook, data.param3);
		VPPXmlText.ReadAll(path, text);
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, false);
	}


Linha 1300
		reply.EventId = data.param3;
		string text = "";
		string path = TemplatePath(hook, data.param3);
		VPPXmlText.ReadAll(path, text);
		reply.Text = text;
>> 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, false);
	}

	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, true);

Linha 1303
		VPPXmlText.ReadAll(path, text);
		reply.Text = text;
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

>> 	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, false);
	}

	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, true);
	}

	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON

Linha 1305
		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
	}

	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
>> 		HandleTemplate(type, ctx, sender, false);
	}

	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, true);
	}

	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)

Linha 1308
	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, false);
	}

>> 	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, true);
	}

	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)
	{
		if (type != CallType.Server || !sender)
		{

Linha 1310
		HandleTemplate(type, ctx, sender, false);
	}

	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
>> 		HandleTemplate(type, ctx, sender, true);
	}

	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

Linha 1313
	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		HandleTemplate(type, ctx, sender, true);
	}

>> 	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param4<int, string, string, string> data;
		if (!ctx.Read(data))

Linha 1315
		HandleTemplate(type, ctx, sender, true);
	}

	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
>> 	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param4<int, string, string, string> data;
		if (!ctx.Read(data))
		{
			return;

Linha 1329
		{
			return;
		}

		string plainId = sender.GetPlainId();
>> 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		WebHook hook = FindHook(data.param2);
		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
		if (!hook || !def)
		{
			return;
		}

Linha 1341
		if (!hook || !def)
		{
			return;
		}

>> 		VPPWebhookCheckReply reply = CheckTemplate(hook, def, data.param4);
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

Linha 1343
			return;
		}

		VPPWebhookCheckReply reply = CheckTemplate(hook, def, data.param4);
		reply.ReqId = data.param1;
>> 		if (save && reply.TemplateOk)
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

Linha 1346
		VPPWebhookCheckReply reply = CheckTemplate(hook, def, data.param4);
		reply.ReqId = data.param1;
		if (save && reply.TemplateOk)
		{
			EnsureHookDir(hook);
>> 			string path = TemplatePath(hook, def.Id);
			VPPXmlText.WriteAll(path, data.param4);
			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (hookSender)
			{
				VPPWebhookTemplate tpl = new VPPWebhookTemplate();
				tpl.Parse(data.param4, def);
				hookSender.SetTemplate(def.Id, tpl);
			}

			reply.Saved = true;

Linha 1351
			string path = TemplatePath(hook, def.Id);
			VPPXmlText.WriteAll(path, data.param4);
			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (hookSender)
			{
>> 				VPPWebhookTemplate tpl = new VPPWebhookTemplate();
				tpl.Parse(data.param4, def);
				hookSender.SetTemplate(def.Id, tpl);
			}

			reply.Saved = true;
			string hookName = hook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Edited the " + def.Id + " template of WebHook: " + hookName));
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);

Linha 1353
			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (hookSender)
			{
				VPPWebhookTemplate tpl = new VPPWebhookTemplate();
				tpl.Parse(data.param4, def);
>> 				hookSender.SetTemplate(def.Id, tpl);
			}

			reply.Saved = true;
			string hookName = hook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Edited the " + def.Id + " template of WebHook: " + hookName));
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);
	}


Linha 1358
				hookSender.SetTemplate(def.Id, tpl);
			}

			reply.Saved = true;
			string hookName = hook.GetName();
>> 			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Edited the " + def.Id + " template of WebHook: " + hookName));
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);
	}

	VPPWebhookCheckReply CheckTemplate(WebHook hook, VPPWebhookEventDef def, string text)
	{
		VPPWebhookCheckReply reply = new VPPWebhookCheckReply();
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;

Linha 1361
			reply.Saved = true;
			string hookName = hook.GetName();
			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Edited the " + def.Id + " template of WebHook: " + hookName));
		}

>> 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);
	}

	VPPWebhookCheckReply CheckTemplate(WebHook hook, VPPWebhookEventDef def, string text)
	{
		VPPWebhookCheckReply reply = new VPPWebhookCheckReply();
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
		VPPWebhookTemplate tpl = new VPPWebhookTemplate();
		tpl.Parse(text, def);
		foreach (VPPWebhookIssue issue : tpl.Issues)

Linha 1364
		}

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);
	}

>> 	VPPWebhookCheckReply CheckTemplate(WebHook hook, VPPWebhookEventDef def, string text)
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

Linha 1369
	VPPWebhookCheckReply CheckTemplate(WebHook hook, VPPWebhookEventDef def, string text)
	{
		VPPWebhookCheckReply reply = new VPPWebhookCheckReply();
		reply.HookId = hook.m_Id;
		reply.EventId = def.Id;
>> 		VPPWebhookTemplate tpl = new VPPWebhookTemplate();
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

Linha 1383
			wire.Arg = issue.Arg;
			wire.Message = issue.Message;
			reply.Issues.Insert(wire);
		}

>> 		reply.TemplateOk = !tpl.HasErrors();
		if (!reply.TemplateOk)
		{
			return reply;
		}

		map<string, string> samples = new map<string, string>();
		def.FillSamples(samples);
		for (int i = 0; i < hook.m_Vars.Count(); i++)
		{
			string hookKey = hook.m_Vars.GetKey(i);

Linha 1384
			wire.Message = issue.Message;
			reply.Issues.Insert(wire);
		}

		reply.TemplateOk = !tpl.HasErrors();
>> 		if (!reply.TemplateOk)
		{
			return reply;
		}

		map<string, string> samples = new map<string, string>();
		def.FillSamples(samples);
		for (int i = 0; i < hook.m_Vars.Count(); i++)
		{
			string hookKey = hook.m_Vars.GetKey(i);
			string hookValue = hook.m_Vars.GetElement(i);

Linha 1399
			string hookValue = hook.m_Vars.GetElement(i);
			samples.Set("hook." + hookKey, hookValue);
		}

		bool jsonBody = hook.m_ContentType.Contains("json");
>> 		string preview = tpl.Render(samples, jsonBody);
		reply.Preview = preview;
		if (!jsonBody)
		{
			return reply;
		}

		reply.JsonChecked = true;
		VPPJsonCheckResult verdict = VPPJsonCheck.Check(preview);
		reply.JsonValid = verdict.Valid;
		reply.JsonMessage = verdict.Message;

Linha 1453
		def.FillSamples(sample.Vars);
		FillCommonVars(sample);
		string hookName = hook.GetName();
		if (!SendTo(hook, sample, plainId, data.param1))
		{
>> 			OnTestResult(plainId, data.param1, hook.m_Id, def.Id, false, "TEMPLATE_ERROR");
			return;
		}

		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Test send of " + def.Id + " to WebHook: " + hookName));
	}

	void OnTestResult(string plainId, int reqId, string hookId, string eventId, bool ok, string reason)
	{
		PlayerIdentity admin = FindIdentity(plainId);
		if (!admin)

Linha 1457
		{
			OnTestResult(plainId, data.param1, hook.m_Id, def.Id, false, "TEMPLATE_ERROR");
			return;
		}

>> 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Test send of " + def.Id + " to WebHook: " + hookName));
	}

	void OnTestResult(string plainId, int reqId, string hookId, string eventId, bool ok, string reason)
	{
		PlayerIdentity admin = FindIdentity(plainId);
		if (!admin)
		{
			return;
		}


Linha 1499
		}

		return null;
	}

>> 	// Re-reads every template file (edits made on disk) and reports which webhooks have broken templates.
	void ReloadTemplates(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param1<int> data;
		if (!ctx.Read(data))
		{

Linha 1500

		return null;
	}

	// Re-reads every template file (edits made on disk) and reports which webhooks have broken templates.
>> 	void ReloadTemplates(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
	{
		if (type != CallType.Server || !sender)
		{
			return;
		}

		Param1<int> data;
		if (!ctx.Read(data))
		{
			return;

Linha 1513
		if (!ctx.Read(data))
		{
			return;
		}

>> 		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks:EditTemplates"))
		{
			return;
		}

		VPPWebhookReloadReply reply = new VPPWebhookReloadReply();
		reply.ReqId = data.param1;
		foreach (WebHook hook : M_DATA)
		{
			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
			if (!hookSender)

Linha 1528
			if (!hookSender)
			{
				continue;
			}

>> 			int broken = LoadTemplates(hook, hookSender, true);
			reply.HookIds.Insert(hook.m_Id);
			reply.TemplateErrors.Insert(broken);
		}

		SaveIfTemplatesChanged();

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplatesReloaded", new Param1<ref VPPWebhookReloadReply>(reply), true, sender);
	}
};


Linha 1530
				continue;
			}

			int broken = LoadTemplates(hook, hookSender, true);
			reply.HookIds.Insert(hook.m_Id);
>> 			reply.TemplateErrors.Insert(broken);
		}

		SaveIfTemplatesChanged();

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplatesReloaded", new Param1<ref VPPWebhookReloadReply>(reply), true, sender);
	}
};

WebHooksManager GetWebHooksManager()
{

Linha 1533
			int broken = LoadTemplates(hook, hookSender, true);
			reply.HookIds.Insert(hook.m_Id);
			reply.TemplateErrors.Insert(broken);
		}

>> 		SaveIfTemplatesChanged();

		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplatesReloaded", new Param1<ref VPPWebhookReloadReply>(reply), true, sender);
	}
};

WebHooksManager GetWebHooksManager()
{
	return WebHooksManager.Cast(GetPluginManager().GetPluginByType(WebHooksManager));
};

Linha 1535
			reply.TemplateErrors.Insert(broken);
		}

		SaveIfTemplatesChanged();

>> 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplatesReloaded", new Param1<ref VPPWebhookReloadReply>(reply), true, sender);
	}
};

WebHooksManager GetWebHooksManager()
{
	return WebHooksManager.Cast(GetPluginManager().GetPluginByType(WebHooksManager));
};

========== 4. SERVER STATUS: EVENTO ==========

Linha 46
			content += string.Format("Server FPS: **%1** ", g_Game.GetServerFPS());
			content += string.Format("Players: **%1**", GetSteamAPIManager().GetTotalPlayerCount());
		}
	}

>> 	override VPPWebhookEvent ToEvent()
	{
		if (m_BoottUp)
		{
			return new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
		}

		VPPWebhookEvent webhookEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_STATUS);
		int fps = g_Game.GetServerFPS();
		webhookEvent.Set("server.fps", fps.ToString());
		string upTime = FormatUpTime();

Linha 55
			return new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
		}

		VPPWebhookEvent webhookEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_STATUS);
		int fps = g_Game.GetServerFPS();
>> 		webhookEvent.Set("server.fps", fps.ToString());
		string upTime = FormatUpTime();
		webhookEvent.Set("uptime", upTime);
		int upSeconds = ConvertTime(GetGame().GetTime(), 1000);
		webhookEvent.Set("uptime.seconds", upSeconds.ToString());
		AddExtras(webhookEvent);
		return webhookEvent;
	}

	string FormatUpTime()
	{

Linha 57

		VPPWebhookEvent webhookEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_STATUS);
		int fps = g_Game.GetServerFPS();
		webhookEvent.Set("server.fps", fps.ToString());
		string upTime = FormatUpTime();
>> 		webhookEvent.Set("uptime", upTime);
		int upSeconds = ConvertTime(GetGame().GetTime(), 1000);
		webhookEvent.Set("uptime.seconds", upSeconds.ToString());
		AddExtras(webhookEvent);
		return webhookEvent;
	}

	string FormatUpTime()
	{
		int secs = ConvertTime(GetGame().GetTime(), 1000);
	   	int days = secs / (24 * 3600);

Linha 59
		int fps = g_Game.GetServerFPS();
		webhookEvent.Set("server.fps", fps.ToString());
		string upTime = FormatUpTime();
		webhookEvent.Set("uptime", upTime);
		int upSeconds = ConvertTime(GetGame().GetTime(), 1000);
>> 		webhookEvent.Set("uptime.seconds", upSeconds.ToString());
		AddExtras(webhookEvent);
		return webhookEvent;
	}

	string FormatUpTime()
	{
		int secs = ConvertTime(GetGame().GetTime(), 1000);
	   	int days = secs / (24 * 3600);
        	secs = secs % (24 * 3600);


Linha 60
		webhookEvent.Set("server.fps", fps.ToString());
		string upTime = FormatUpTime();
		webhookEvent.Set("uptime", upTime);
		int upSeconds = ConvertTime(GetGame().GetTime(), 1000);
		webhookEvent.Set("uptime.seconds", upSeconds.ToString());
>> 		AddExtras(webhookEvent);
		return webhookEvent;
	}

	string FormatUpTime()
	{
		int secs = ConvertTime(GetGame().GetTime(), 1000);
	   	int days = secs / (24 * 3600);
        	secs = secs % (24 * 3600);

       	int hours = secs / 3600;

========== 5. RESULTADO ==========
[OK] Inspecao somente leitura concluida.
[OK] Nenhum arquivo do projeto foi alterado.
[OK] Nenhum servico foi iniciado ou reiniciado.
[OK] Nenhuma comunicacao foi enviada.
**********************
Fim da transcrição do Windows PowerShell
Hora de término: 20261121004209
**********************
