RAVEN CONTROL CENTER - AUDITORIA VPP WEBHOOKS
Data: 2026-11-21 01:02:43
Origem: C:\Users\Nasdara\AppData\Local\RavenControlCenter\VPP_Inspection\Extracted_WebHooks_20261121_010109
Modo: SOMENTE LEITURA


==========================================================================================
ARQUIVO: 3_Game\VPPAdminTools\WebHooks\VPPWebhookTemplate.c
==========================================================================================
    1: /*
    2: 	Webhook body templates: the request body as text with placeholders.
    3: 
    4: 		{{victim.name}}                    a variable (JSON-escaped when the webhook sends JSON)
    5: 		{{victim.id|steamurl}}             filters, applied left to right
    6: 		{{weapon|default:"unknown"|upper}} filter arguments may be quoted
    7: 		{{#if killer.id}}...{{else}}...{{/if}}      shown when the variable is not empty
    8: 		{{#unless killer.id}}...{{/unless}}          shown when it is empty
    9: 		{{#ifeq cause "suicide"}}...{{/ifeq}}         shown when it equals the value
   10: 		{{! a comment }}
   11: 
   12: 	Filters: upper, lower, trim, truncate:N, default:TEXT, round:N, number, steamurl, raw (no escaping: insert JSON),
   13: 	json (a complete JSON string literal, quotes included).
   14: 
   15: 	Parse once, render many times. Problems carry line / column and a stable code (the admin UI localizes them).
   16: */
   17: class VPPWebhookIssue : Managed
   18: {
   19: 	bool IsError;
   20: 	int Line;
   21: 	int Col;
   22: 	// stable id of the problem (UI text key suffix), e.g. "UNKNOWN_VAR"
   23: 	string Code;
   24: 	string Arg;
   25: 	// English text for the server log
   26: 	string Message;
   27: };
   28: 
   29: class VPPWebhookNode : Managed
   30: {
   31: 	const static int TEXT = 0;
   32: 	const static int VAR = 1;
   33: 	const static int COND = 2;
   34: 	const static int TEST_IF = 0;
   35: 	const static int TEST_UNLESS = 1;
   36: 	const static int TEST_IFEQ = 2;
   37: 
   38: 	int Kind;
   39: 	int CondTest;
   40: 	int Line;
   41: 	int Col;
   42: 	string Text;
   43: 	string Name;
   44: 	string Value;
   45: 	ref array<string> Filters;
   46: 	ref array<string> FilterArgs;
   47: 	ref array<ref VPPWebhookNode> Kids;
   48: 	ref array<ref VPPWebhookNode> ElseKids;
   49: 	bool InElse;
   50: 
   51: 	void VPPWebhookNode(int kind)
   52: 	{
   53: 		Kind = kind;
   54: 		Text = "";
   55: 		Name = "";
   56: 		Value = "";
   57: 		Filters = new array<string>();
   58: 		FilterArgs = new array<string>();
   59: 		Kids = new array<ref VPPWebhookNode>();
   60: 		ElseKids = new array<ref VPPWebhookNode>();
   61: 	}
   62: };
   63: 
   64: class VPPWebhookTemplate : Managed
   65: {
   66: 	// engine Substring returns at most 8191 bytes: a template stays below that
   67: 	const static int MAX_LENGTH = 8000;
   68: 
   69: 	protected ref array<ref VPPWebhookNode> m_Root;
   70: 	protected string m_Source;
   71: 	ref array<ref VPPWebhookIssue> Issues;
   72: 
   73: 	void VPPWebhookTemplate()
   74: 	{
   75: 		m_Root = new array<ref VPPWebhookNode>();
   76: 		Issues = new array<ref VPPWebhookIssue>();
   77: 		m_Source = "";
   78: 	}
   79: 
   80: 	bool HasErrors()
   81: 	{
   82: 		foreach (VPPWebhookIssue issue : Issues)
   83: 		{
   84: 			if (issue.IsError)
   85: 			{
   86: 				return true;
   87: 			}
   88: 		}
   89: 
   90: 		return false;
   91: 	}
   92: 
   93: 	// def: the event the template is for (null = custom event, variable names are not checked).
   94: 	bool Parse(string source, VPPWebhookEventDef def)
   95: 	{
   96: 		m_Source = source;
   97: 		m_Root.Clear();
   98: 		Issues.Clear();
   99: 		if (source.Length() > MAX_LENGTH)
  100: 		{
  101: 			string maxText = MAX_LENGTH.ToString();
  102: 			string tooLong = "The template is longer than " + maxText + " characters.";
  103: 			AddIssue(true, 0, "TOO_LONG", maxText, tooLong);
  104: 			return false;
  105: 		}
  106: 
  107: 		array<VPPWebhookNode> openConds = new array<VPPWebhookNode>();
  108: 		int pos = 0;
  109: 		int total = source.Length();
  110: 		while (pos < total)
  111: 		{
  112: 			int open = source.IndexOfFrom(pos, "{{");
  113: 			if (open < 0)
  114: 			{
  115: 				string tail = source.Substring(pos, total - pos);
  116: 				AddText(openConds, tail);
  117: 				break;
  118: 			}
  119: 
  120: 			if (open > pos)
  121: 			{
  122: 				string before = source.Substring(pos, open - pos);
  123: 				AddText(openConds, before);
  124: 			}
  125: 
  126: 			int close = source.IndexOfFrom(open + 2, "}}");
  127: 			if (close < 0)
  128: 			{
  129: 				AddIssue(true, open, "UNCLOSED_TAG", "", "A {{ tag is never closed with }}.");
  130: 				break;
  131: 			}
  132: 
  133: 			string inner = source.Substring(open + 2, close - open - 2);
  134: 			ParseTag(inner, open, def, openConds);
  135: 			pos = close + 2;
  136: 		}
  137: 
  138: 		foreach (VPPWebhookNode stillOpen : openConds)
  139: 		{
  140: 			string unclosed = "A {{#...}} block for " + stillOpen.Name + " is never closed.";
  141: 			AddIssueAt(true, stillOpen.Line, stillOpen.Col, "UNCLOSED_BLOCK", stillOpen.Name, unclosed);
  142: 		}
  143: 
  144: 		return !HasErrors();
  145: 	}
  146: 
  147: 	protected void ParseTag(string inner, int tagPos, VPPWebhookEventDef def, array<VPPWebhookNode> openConds)
  148: 	{
  149: 		string tag = inner.Trim();
  150: 		if (tag == "")
  151: 		{
  152: 			AddIssue(true, tagPos, "EMPTY_TAG", "", "Empty {{ }} tag.");
  153: 			return;
  154: 		}
  155: 
  156: 		string first = tag.Substring(0, 1);
  157: 		if (first == "!")
  158: 		{
  159: 			return;
  160: 		}
  161: 
  162: 		if (first == "#")
  163: 		{
  164: 			ParseOpen(tag, tagPos, def, openConds);
  165: 			return;
  166: 		}
  167: 
  168: 		if (first == "/")
  169: 		{
  170: 			ParseClose(tag, tagPos, openConds);
  171: 			return;
  172: 		}
  173: 
  174: 		if (tag == "else")
  175: 		{
  176: 			int depth = openConds.Count();
  177: 			if (depth == 0)
  178: 			{
  179: 				AddIssue(true, tagPos, "STRAY_ELSE", "", "{{else}} outside of an {{#if}} block.");
  180: 				return;
  181: 			}
  182: 
  183: 			VPPWebhookNode top = openConds[depth - 1];
  184: 			if (top.InElse)
  185: 			{
  186: 				AddIssue(true, tagPos, "DOUBLE_ELSE", top.Name, "A second {{else}} in the same block.");
  187: 				return;
  188: 			}
  189: 
  190: 			top.InElse = true;
  191: 			return;
  192: 		}
  193: 
  194: 		ParseVar(tag, tagPos, def, openConds);
  195: 	}
  196: 
  197: 	protected void ParseOpen(string tag, int tagPos, VPPWebhookEventDef def, array<VPPWebhookNode> openConds)
  198: 	{
  199: 		int space = tag.IndexOf(" ");
  200: 		string word = tag;
  201: 		string rest = "";
  202: 		if (space > 0)
  203: 		{
  204: 			word = tag.Substring(0, space);
  205: 			rest = tag.Substring(space + 1, tag.Length() - space - 1);
  206: 			rest = rest.Trim();
  207: 		}
  208: 
  209: 		VPPWebhookNode cond = new VPPWebhookNode(VPPWebhookNode.COND);
  210: 		SetPos(cond, tagPos);
  211: 		if (word == "#if")
  212: 		{
  213: 			cond.CondTest = VPPWebhookNode.TEST_IF;
  214: 		}
  215: 		else if (word == "#unless")
  216: 		{
  217: 			cond.CondTest = VPPWebhookNode.TEST_UNLESS;
  218: 		}
  219: 		else if (word == "#ifeq")
  220: 		{
  221: 			cond.CondTest = VPPWebhookNode.TEST_IFEQ;
  222: 		}
  223: 		else
  224: 		{
  225: 			string unknownBlock = "Unknown block " + word + " (use #if, #unless or #ifeq).";
  226: 			AddIssue(true, tagPos, "UNKNOWN_BLOCK", word, unknownBlock);
  227: 			return;
  228: 		}
  229: 
  230: 		string varName = rest;
  231: 		if (cond.CondTest == VPPWebhookNode.TEST_IFEQ)
  232: 		{
  233: 			int valueStart = rest.IndexOf(" ");
  234: 			if (valueStart < 0)
  235: 			{
  236: 				AddIssue(true, tagPos, "IFEQ_VALUE", rest, "{{#ifeq}} needs a variable and a value.");
  237: 				return;
  238: 			}
  239: 
  240: 			varName = rest.Substring(0, valueStart);
  241: 			string compared = rest.Substring(valueStart + 1, rest.Length() - valueStart - 1);
  242: 			compared = compared.Trim();
  243: 			cond.Value = Unquote(compared);
  244: 		}
  245: 
  246: 		if (varName == "")
  247: 		{
  248: 			string blockVar = word + " needs a variable name.";
  249: 			AddIssue(true, tagPos, "BLOCK_VAR", word, blockVar);
  250: 			return;
  251: 		}
  252: 
  253: 		cond.Name = varName;
  254: 		CheckVarName(varName, tagPos, def);
  255: 		AppendNode(openConds, cond);
  256: 		openConds.Insert(cond);
  257: 	}
  258: 
  259: 	protected void ParseClose(string tag, int tagPos, array<VPPWebhookNode> openConds)
  260: 	{
  261: 		int depth = openConds.Count();
  262: 		if (depth == 0)
  263: 		{
  264: 			string strayClose = tag + " has no matching opening block.";
  265: 			AddIssue(true, tagPos, "STRAY_CLOSE", tag, strayClose);
  266: 			return;
  267: 		}
  268: 
  269: 		VPPWebhookNode top = openConds[depth - 1];
  270: 		string expected = "/if";
  271: 		if (top.CondTest == VPPWebhookNode.TEST_UNLESS)
  272: 		{
  273: 			expected = "/unless";
  274: 		}
  275: 		else if (top.CondTest == VPPWebhookNode.TEST_IFEQ)
  276: 		{
  277: 			expected = "/ifeq";
  278: 		}
  279: 
  280: 		if (tag != expected)
  281: 		{
  282: 			string wrongClose = tag + " closes a block that needs {{" + expected + "}}.";
  283: 			AddIssue(true, tagPos, "WRONG_CLOSE", expected, wrongClose);
  284: 		}
  285: 
  286: 		openConds.Remove(depth - 1);
  287: 	}
  288: 
  289: 	protected void ParseVar(string tag, int tagPos, VPPWebhookEventDef def, array<VPPWebhookNode> openConds)
  290: 	{
  291: 		array<string> parts = new array<string>();
  292: 		SplitFilters(tag, parts);
  293: 		VPPWebhookNode varNode = new VPPWebhookNode(VPPWebhookNode.VAR);
  294: 		SetPos(varNode, tagPos);
  295: 		string varName = parts[0];
  296: 		varName = varName.Trim();
  297: 		varNode.Name = varName;
  298: 		CheckVarName(varName, tagPos, def);
  299: 		for (int i = 1; i < parts.Count(); i++)
  300: 		{
  301: 			string filterText = parts[i];
  302: 			filterText = filterText.Trim();
  303: 			string filterName = filterText;
  304: 			string filterArg = "";
  305: 			int colon = filterText.IndexOf(":");
  306: 			if (colon > 0)
  307: 			{
  308: 				filterName = filterText.Substring(0, colon);
  309: 				string rawArg = filterText.Substring(colon + 1, filterText.Length() - colon - 1);
  310: 				filterArg = Unquote(rawArg.Trim());
  311: 			}
  312: 
  313: 			if (!CheckFilter(filterName, filterArg, tagPos))
  314: 			{
  315: 				continue;
  316: 			}
  317: 
  318: 			varNode.Filters.Insert(filterName);
  319: 			varNode.FilterArgs.Insert(filterArg);
  320: 		}
  321: 
  322: 		AppendNode(openConds, varNode);
  323: 	}
  324: 
  325: 	// "a|b:\"x|y\"" -> a, b:"x|y" (a | inside quotes stays in the argument)
  326: 	protected void SplitFilters(string tag, array<string> outParts)
  327: 	{
  328: 		string current = "";
  329: 		bool quoted = false;
  330: 		int total = tag.Length();
  331: 		for (int i = 0; i < total; i++)
  332: 		{
  333: 			string ch = tag.Get(i);
  334: 			if (ch == "\"")
  335: 			{
  336: 				quoted = !quoted;
  337: 			}
  338: 
  339: 			if (ch == "|" && !quoted)
  340: 			{
  341: 				outParts.Insert(current);
  342: 				current = "";
  343: 				continue;
  344: 			}
  345: 
  346: 			current = current + ch;
  347: 		}
  348: 
  349: 		outParts.Insert(current);
  350: 	}
  351: 
  352: 	protected bool CheckFilter(string filterName, string filterArg, int tagPos)
  353: 	{
  354: 		if (filterName == "upper" || filterName == "lower" || filterName == "trim" || filterName == "steamurl")
  355: 		{
  356: 			return true;
  357: 		}
  358: 
  359: 		if (filterName == "raw" || filterName == "json" || filterName == "number" || filterName == "default")
  360: 		{
  361: 			return true;
  362: 		}
  363: 
  364: 		if (filterName == "truncate" || filterName == "round")
  365: 		{
  366: 			int argNumber = filterArg.ToInt();
  367: 			string argBack = argNumber.ToString();
  368: 			if (filterArg == "" || argBack != filterArg || argNumber < 0)
  369: 			{
  370: 				string argMessage = "The " + filterName + " filter needs a whole number, e.g. " + filterName + ":2.";
  371: 				AddIssue(true, tagPos, "FILTER_ARG", filterName, argMessage);
  372: 				return false;
  373: 			}
  374: 
  375: 			return true;
  376: 		}
  377: 
  378: 		string unknownFilter = "Unknown filter " + filterName + ".";
  379: 		AddIssue(true, tagPos, "UNKNOWN_FILTER", filterName, unknownFilter);
  380: 		return false;
  381: 	}
  382: 
  383: 	protected void CheckVarName(string varName, int tagPos, VPPWebhookEventDef def)
  384: 	{
  385: 		if (!IsPlainVarName(varName))
  386: 		{
  387: 			string badVar = varName + " is not a valid variable name (letters, digits, dots, _).";
  388: 			AddIssue(true, tagPos, "BAD_VAR", varName, badVar);
  389: 			return;
  390: 		}
  391: 
  392: 		if (!def || VPPWebhookDefs.IsHookVar(varName) || def.HasVar(varName))
  393: 		{
  394: 			return;
  395: 		}
  396: 
  397: 		string unknownVar = "The " + def.Id + " event has no variable " + varName + ".";
  398: 		AddIssue(true, tagPos, "UNKNOWN_VAR", varName, unknownVar);
  399: 	}
  400: 
  401: 	protected bool IsPlainVarName(string varName)
  402: 	{
  403: 		int total = varName.Length();
  404: 		if (total == 0)
  405: 		{
  406: 			return false;
  407: 		}
  408: 
  409: 		for (int i = 0; i < total; i++)
  410: 		{
  411: 			string ch = varName.Get(i);
  412: 			int code = ch.ToAscii();
  413: 			bool lower = code >= 97 && code <= 122;
  414: 			bool upper = code >= 65 && code <= 90;
  415: 			bool digit = code >= 48 && code <= 57;
  416: 			if (!lower && !upper && !digit && ch != "." && ch != "_")
  417: 			{
  418: 				return false;
  419: 			}
  420: 		}
  421: 
  422: 		return true;
  423: 	}
  424: 
  425: 	protected void AddText(array<VPPWebhookNode> openConds, string text)
  426: 	{
  427: 		if (text == "")
  428: 		{
  429: 			return;
  430: 		}
  431: 
  432: 		VPPWebhookNode textNode = new VPPWebhookNode(VPPWebhookNode.TEXT);
  433: 		textNode.Text = text;
  434: 		AppendNode(openConds, textNode);
  435: 	}
  436: 
  437: 	protected void AppendNode(array<VPPWebhookNode> openConds, VPPWebhookNode child)
  438: 	{
  439: 		int depth = openConds.Count();
  440: 		if (depth == 0)
  441: 		{
  442: 			m_Root.Insert(child);
  443: 			return;
  444: 		}
  445: 
  446: 		VPPWebhookNode top = openConds[depth - 1];
  447: 		if (top.InElse)
  448: 		{
  449: 			top.ElseKids.Insert(child);
  450: 		}
  451: 		else
  452: 		{
  453: 			top.Kids.Insert(child);
  454: 		}
  455: 	}
  456: 
  457: 	// ---------------------------------------------------------------- render
  458: 
  459: 	// vars: event + hook variables. jsonEscape: the body is JSON (values are escaped for a JSON string).
  460: 	const static int BRANCH_ROOT = 0;
  461: 	const static int BRANCH_KIDS = 1;
  462: 	const static int BRANCH_ELSE = 2;
  463: 
  464: 	// A flat walk with an explicit stack: recursion is unreliable in Enforce (proven here twice, an inner call
  465: 	// clobbered the outer frame: first a null node, then the outer loops stopped and the rest of the body was lost).
  466: 	// A stack entry is the node whose children are walked (null = the root), which child list and the next index.
  467: 	string Render(map<string, string> vars, bool jsonEscape)
  468: 	{
  469: 		string output = "";
  470: 		string current = "";
  471: 		string rendered = "";
  472: 		bool passed = false;
  473: 		int depth = 0;
  474: 		int branch = 0;
  475: 		int index = 0;
  476: 		int count = 0;
  477: 		VPPWebhookNode parentNode = null;
  478: 		VPPWebhookNode tplNode = null;
  479: 		array<VPPWebhookNode> stackNodes = new array<VPPWebhookNode>();
  480: 		array<int> stackBranches = new array<int>();
  481: 		array<int> stackIndexes = new array<int>();
  482: 		stackNodes.Insert(null);
  483: 		stackBranches.Insert(BRANCH_ROOT);
  484: 		stackIndexes.Insert(0);
  485: 		while (stackIndexes.Count() > 0)
  486: 		{
  487: 			depth = stackIndexes.Count() - 1;
  488: 			parentNode = stackNodes[depth];
  489: 			branch = stackBranches[depth];
  490: 			index = stackIndexes[depth];
  491: 			count = ChildCount(parentNode, branch);
  492: 			if (index >= count)
  493: 			{
  494: 				stackNodes.RemoveOrdered(depth);
  495: 				stackBranches.RemoveOrdered(depth);
  496: 				stackIndexes.RemoveOrdered(depth);
  497: 				continue;
  498: 			}
  499: 
  500: 			stackIndexes.Set(depth, index + 1);
  501: 			tplNode = ChildAt(parentNode, branch, index);
  502: 			if (!tplNode)
  503: 			{
  504: 				continue;
  505: 			}
  506: 
  507: 			if (tplNode.Kind == VPPWebhookNode.TEXT)
  508: 			{
  509: 				output = output + tplNode.Text;
  510: 				continue;
  511: 			}
  512: 
  513: 			current = "";
  514: 			if (vars.Contains(tplNode.Name))
  515: 			{
  516: 				current = vars.Get(tplNode.Name);
  517: 			}
  518: 
  519: 			if (tplNode.Kind == VPPWebhookNode.VAR)
  520: 			{
  521: 				rendered = RenderVar(tplNode, current, jsonEscape);
  522: 				output = output + rendered;
  523: 				continue;
  524: 			}
  525: 
  526: 			passed = current != "";
  527: 			if (tplNode.CondTest == VPPWebhookNode.TEST_UNLESS)
  528: 			{
  529: 				passed = current == "";
  530: 			}
  531: 			else if (tplNode.CondTest == VPPWebhookNode.TEST_IFEQ)
  532: 			{
  533: 				passed = current == tplNode.Value;
  534: 			}
  535: 
  536: 			stackNodes.Insert(tplNode);
  537: 			if (passed)
  538: 			{
  539: 				stackBranches.Insert(BRANCH_KIDS);
  540: 			}
  541: 			else
  542: 			{
  543: 				stackBranches.Insert(BRANCH_ELSE);
  544: 			}
  545: 
  546: 			stackIndexes.Insert(0);
  547: 		}
  548: 
  549: 		return output;
  550: 	}
  551: 
  552: 	protected int ChildCount(VPPWebhookNode parentNode, int branch)
  553: 	{
  554: 		if (branch == BRANCH_ROOT)
  555: 		{
  556: 			return m_Root.Count();
  557: 		}
  558: 
  559: 		if (!parentNode)
  560: 		{
  561: 			return 0;
  562: 		}
  563: 
  564: 		if (branch == BRANCH_KIDS)
  565: 		{
  566: 			return parentNode.Kids.Count();
  567: 		}
  568: 
  569: 		return parentNode.ElseKids.Count();
  570: 	}
  571: 
  572: 	protected VPPWebhookNode ChildAt(VPPWebhookNode parentNode, int branch, int index)
  573: 	{
  574: 		if (branch == BRANCH_ROOT)
  575: 		{
  576: 			return m_Root[index];
  577: 		}
  578: 
  579: 		if (!parentNode)
  580: 		{
  581: 			return null;
  582: 		}
  583: 
  584: 		if (branch == BRANCH_KIDS)
  585: 		{
  586: 			return parentNode.Kids[index];
  587: 		}
  588: 
  589: 		return parentNode.ElseKids[index];
  590: 	}
  591: 
  592: 	protected string RenderVar(VPPWebhookNode varNode, string rawValue, bool jsonEscape)
  593: 	{
  594: 		string value = rawValue;
  595: 		string filterName = "";
  596: 		string filterArg = "";
  597: 		string escapedValue = "";
  598: 		bool escape = jsonEscape;
  599: 		int total = varNode.Filters.Count();
  600: 		int i = 0;
  601: 		for (i = 0; i < total; i++)
  602: 		{
  603: 			filterName = varNode.Filters[i];
  604: 			filterArg = varNode.FilterArgs[i];
  605: 			if (filterName == "raw")
  606: 			{
  607: 				escape = false;
  608: 			}
  609: 			else if (filterName == "json")
  610: 			{
  611: 				escapedValue = EscapeJson(value);
  612: 				value = "\"" + escapedValue + "\"";
  613: 				escape = false;
  614: 			}
  615: 			else
  616: 			{
  617: 				value = ApplyFilter(filterName, filterArg, value);
  618: 			}
  619: 		}
  620: 
  621: 		if (escape)
  622: 		{
  623: 			escapedValue = EscapeJson(value);
  624: 			return escapedValue;
  625: 		}
  626: 
  627: 		return value;
  628: 	}
  629: 
  630: 	protected string ApplyFilter(string filterName, string filterArg, string rawValue)
  631: 	{
  632: 		string value = rawValue;
  633: 		string result = "";
  634: 		int maxChars = 0;
  635: 		int decimals = 0;
  636: 		float numeric = 0;
  637: 		if (filterName == "upper")
  638: 		{
  639: 			value.ToUpper();
  640: 			return value;
  641: 		}
  642: 
  643: 		if (filterName == "lower")
  644: 		{
  645: 			value.ToLower();
  646: 			return value;
  647: 		}
  648: 
  649: 		if (filterName == "trim")
  650: 		{
  651: 			result = value.Trim();
  652: 			return result;
  653: 		}
  654: 
  655: 		if (filterName == "default")
  656: 		{
  657: 			if (value == "")
  658: 			{
  659: 				return filterArg;
  660: 			}
  661: 
  662: 			return value;
  663: 		}
  664: 
  665: 		if (filterName == "steamurl")
  666: 		{
  667: 			if (value == "")
  668: 			{
  669: 				return "";
  670: 			}
  671: 
  672: 			result = "https://steamcommunity.com/profiles/" + value;
  673: 			return result;
  674: 		}
  675: 
  676: 		if (filterName == "truncate")
  677: 		{
  678: 			maxChars = filterArg.ToInt();
  679: 			if (value.LengthUtf8() <= maxChars || maxChars < 1)
  680: 			{
  681: 				return value;
  682: 			}
  683: 
  684: 			result = value.SubstringUtf8(0, maxChars - 1);
  685: 			result = result + "â€¦";
  686: 			return result;
  687: 		}
  688: 
  689: 		if (filterName == "number")
  690: 		{
  691: 			if (IsNumberText(value))
  692: 			{
  693: 				return value;
  694: 			}
  695: 
  696: 			return "0";
  697: 		}
  698: 
  699: 		if (filterName == "round")
  700: 		{
  701: 			if (!IsNumberText(value))
  702: 			{
  703: 				return value;
  704: 			}
  705: 
  706: 			numeric = value.ToFloat();
  707: 			decimals = filterArg.ToInt();
  708: 			result = RoundText(numeric, decimals);
  709: 			return result;
  710: 		}
  711: 
  712: 		return value;
  713: 	}
  714: 
  715: 	// ---------------------------------------------------------------- helpers
  716: 
  717: 	// The special characters are built from their codes: a string literal holding an escaped backslash followed by
  718: 	// another escape (backslash backslash backslash quote) makes the script preprocessor (CParser) fail with a
  719: 	// quoted string not closed error.
  720: 	static string EscapeJson(string value)
  721: 	{
  722: 		int backslashCode = 92;
  723: 		int quoteCode = 34;
  724: 		int newlineCode = 10;
  725: 		int carriageCode = 13;
  726: 		int tabCode = 9;
  727: 		string backslash = backslashCode.AsciiToString();
  728: 		string quote = quoteCode.AsciiToString();
  729: 		string newline = newlineCode.AsciiToString();
  730: 		string carriage = carriageCode.AsciiToString();
  731: 		string tab = tabCode.AsciiToString();
  732: 		string escaped = value;
  733: 		escaped.Replace(backslash, backslash + backslash);
  734: 		escaped.Replace(quote, backslash + quote);
  735: 		escaped.Replace(newline, backslash + "n");
  736: 		escaped.Replace(carriage, backslash + "r");
  737: 		escaped.Replace(tab, backslash + "t");
  738: 		return escaped;
  739: 	}
  740: 
  741: 	static bool IsNumberText(string text)
  742: 	{
  743: 		int total = text.Length();
  744: 		if (total == 0)
  745: 		{
  746: 			return false;
  747: 		}
  748: 
  749: 		bool digits = false;
  750: 		for (int i = 0; i < total; i++)
  751: 		{
  752: 			string ch = text.Get(i);
  753: 			int code = ch.ToAscii();
  754: 			if (code >= 48 && code <= 57)
  755: 			{
  756: 				digits = true;
  757: 				continue;
  758: 			}
  759: 
  760: 			bool sign = i == 0 && (ch == "-" || ch == "+");
  761: 			if (!sign && ch != ".")
  762: 			{
  763: 				return false;
  764: 			}
  765: 		}
  766: 
  767: 		return digits;
  768: 	}
  769: 
  770: 	// value with at most decimals decimals, no trailing zeros ("61.4", "61")
  771: 	static string RoundText(float value, int decimals)
  772: 	{
  773: 		float scale = Math.Pow(10, decimals);
  774: 		float rounded = Math.Round(value * scale) / scale;
  775: 		if (decimals == 0)
  776: 		{
  777: 			int whole = Math.Round(rounded);
  778: 			return whole.ToString();
  779: 		}
  780: 
  781: 		return rounded.ToString();
  782: 	}
  783: 
  784: 	protected string Unquote(string text)
  785: 	{
  786: 		int total = text.Length();
  787: 		if (total >= 2 && text.Substring(0, 1) == "\"" && text.Substring(total - 1, 1) == "\"")
  788: 		{
  789: 			return text.Substring(1, total - 2);
  790: 		}
  791: 
  792: 		return text;
  793: 	}
  794: 
  795: 	protected void SetPos(VPPWebhookNode tplNode, int pos)
  796: 	{
  797: 		int line = VPPWebhookText.LineOf(m_Source, pos);
  798: 		int col = VPPWebhookText.ColOf(m_Source, pos);
  799: 		tplNode.Line = line;
  800: 		tplNode.Col = col;
  801: 	}
  802: 
  803: 	protected void AddIssue(bool isError, int pos, string code, string arg, string message)
  804: 	{
  805: 		int line = VPPWebhookText.LineOf(m_Source, pos);
  806: 		int col = VPPWebhookText.ColOf(m_Source, pos);
  807: 		AddIssueAt(isError, line, col, code, arg, message);
  808: 	}
  809: 
  810: 	protected void AddIssueAt(bool isError, int line, int col, string code, string arg, string message)
  811: 	{
  812: 		VPPWebhookIssue issue = new VPPWebhookIssue();
  813: 		issue.IsError = isError;
  814: 		issue.Line = line;
  815: 		issue.Col = col;
  816: 		issue.Code = code;
  817: 		issue.Arg = arg;
  818: 		issue.Message = message;
  819: 		Issues.Insert(issue);
  820: 	}
  821: };
  822: 
  823: class VPPWebhookText
  824: {
  825: 	// 1-based line of a byte position.
  826: 	static int LineOf(string text, int pos)
  827: 	{
  828: 		int line = 1;
  829: 		int search = 0;
  830: 		int newline = 0;
  831: 		while (true)
  832: 		{
  833: 			newline = text.IndexOfFrom(search, "\n");
  834: 			if (newline < 0 || newline >= pos)
  835: 			{
  836: 				break;
  837: 			}
  838: 
  839: 			line++;
  840: 			search = newline + 1;
  841: 		}
  842: 
  843: 		return line;
  844: 	}
  845: 
  846: 	// 1-based column (bytes) of a byte position.
  847: 	static int ColOf(string text, int pos)
  848: 	{
  849: 		int lineStart = 0;
  850: 		int search = 0;
  851: 		int newline = 0;
  852: 		while (true)
  853: 		{
  854: 			newline = text.IndexOfFrom(search, "\n");
  855: 			if (newline < 0 || newline >= pos)
  856: 			{
  857: 				break;
  858: 			}
  859: 
  860: 			lineStart = newline + 1;
  861: 			search = newline + 1;
  862: 		}
  863: 
  864: 		return pos - lineStart + 1;
  865: 	}
  866: };

==========================================================================================
ARQUIVO: 3_Game\VPPAdminTools\WebHooks\VPPJsonCheck.c
==========================================================================================
    1: /*
    2: 	JSON validation with the game's own parser (JsonSerializer.ReadFromString = RapidJSON, memory:
    3: 	dayz-restapi-json-internals): the whole text is parsed before it is mapped to the target, so any target works as a
    4: 	strict syntax check. The engine's message says what is wrong but not where; VPPJsonLocator finds the line / column.
    5: 	Discord payloads are also read into typed classes to check Discord's limits.
    6: */
    7: class VPPJsonProbe
    8: {
    9: };
   10: 
   11: class VPPJsonCheckResult : Managed
   12: {
   13: 	bool Valid;
   14: 	// the engine's message ("Missing a comma or '}' after an object member.") when not valid
   15: 	string Message;
   16: 	int Line;
   17: 	int Col;
   18: 
   19: 	void VPPJsonCheckResult()
   20: 	{
   21: 		Valid = true;
   22: 		Message = "";
   23: 	}
   24: };
   25: 
   26: class VPPJsonCheck
   27: {
   28: 	// RapidJSON's parse error texts: a ReadFromString error without one of them is a mapping error after a good parse.
   29: 	protected static ref array<string> s_SyntaxMessages;
   30: 
   31: 	static VPPJsonCheckResult Check(string text)
   32: 	{
   33: 		VPPJsonCheckResult result = new VPPJsonCheckResult();
   34: 		JsonSerializer serializer = new JsonSerializer();
   35: 		VPPJsonProbe probe = new VPPJsonProbe();
   36: 		string error = "";
   37: 		if (serializer.ReadFromString(probe, text, error))
   38: 		{
   39: 			return result;
   40: 		}
   41: 
   42: 		string syntaxMessage = SyntaxMessageOf(error);
   43: 		if (syntaxMessage == "")
   44: 		{
   45: 			// parsed fine, only the probe mapping complained (e.g. the root is an array)
   46: 			return result;
   47: 		}
   48: 
   49: 		result.Valid = false;
   50: 		result.Message = syntaxMessage;
   51: 		int errorPos = VPPJsonLocator.FirstError(text);
   52: 		result.Line = VPPWebhookText.LineOf(text, errorPos);
   53: 		result.Col = VPPWebhookText.ColOf(text, errorPos);
   54: 		return result;
   55: 	}
   56: 
   57: 	protected static string SyntaxMessageOf(string error)
   58: 	{
   59: 		if (!s_SyntaxMessages)
   60: 		{
   61: 			s_SyntaxMessages = new array<string>();
   62: 			s_SyntaxMessages.Insert("The document is empty.");
   63: 			s_SyntaxMessages.Insert("The document root must not be followed by other values.");
   64: 			s_SyntaxMessages.Insert("Invalid value.");
   65: 			s_SyntaxMessages.Insert("Missing a name for object member.");
   66: 			s_SyntaxMessages.Insert("Missing a colon after a name of object member.");
   67: 			s_SyntaxMessages.Insert("Missing a comma or '}' after an object member.");
   68: 			s_SyntaxMessages.Insert("Missing a comma or ']' after an array element.");
   69: 			s_SyntaxMessages.Insert("Incorrect hex digit after \\u escape in string.");
   70: 			s_SyntaxMessages.Insert("The surrogate pair in string is invalid.");
   71: 			s_SyntaxMessages.Insert("Invalid escape character in string.");
   72: 			s_SyntaxMessages.Insert("Missing a closing quotation mark in string.");
   73: 			s_SyntaxMessages.Insert("Invalid encoding in string.");
   74: 			s_SyntaxMessages.Insert("Number too big to be stored in double.");
   75: 			s_SyntaxMessages.Insert("Miss fraction part in number.");
   76: 			s_SyntaxMessages.Insert("Miss exponent in number.");
   77: 			s_SyntaxMessages.Insert("Unspecific syntax error.");
   78: 		}
   79: 
   80: 		foreach (string known : s_SyntaxMessages)
   81: 		{
   82: 			if (error.Contains(known))
   83: 			{
   84: 				return known;
   85: 			}
   86: 		}
   87: 
   88: 		return "";
   89: 	}
   90: };
   91: 
   92: // Where the first JSON error is (byte position): a small strict scanner, used only to point at the problem the engine
   93: // reported.
   94: class VPPJsonLocator
   95: {
   96: 	protected string m_Text;
   97: 	protected int m_Pos;
   98: 	protected int m_Len;
   99: 	protected bool m_Failed;
  100: 	protected int m_FailPos;
  101: 
  102: 	static int FirstError(string text)
  103: 	{
  104: 		VPPJsonLocator locator = new VPPJsonLocator();
  105: 		return locator.Run(text);
  106: 	}
  107: 
  108: 	const static int STATE_VALUE = 0;
  109: 	const static int STATE_KEY = 1;
  110: 	const static int STATE_AFTER = 2;
  111: 	const static int IN_OBJECT = 1;
  112: 	const static int IN_ARRAY = 2;
  113: 	const static int MAX_DEPTH = 64;
  114: 
  115: 	// A flat state machine with an explicit container stack (recursion is unreliable in Enforce). Returns the byte
  116: 	// position of the first error, or the text length when the text is valid.
  117: 	int Run(string text)
  118: 	{
  119: 		int state = STATE_VALUE;
  120: 		int top = 0;
  121: 		string ch = "";
  122: 		array<int> containers = new array<int>();
  123: 		m_Text = text;
  124: 		m_Pos = 0;
  125: 		m_Len = text.Length();
  126: 		m_Failed = false;
  127: 		m_FailPos = 0;
  128: 		while (!m_Failed)
  129: 		{
  130: 			SkipSpace();
  131: 			if (state == STATE_VALUE)
  132: 			{
  133: 				ch = Peek();
  134: 				if (ch == "{" || ch == "[")
  135: 				{
  136: 					m_Pos++;
  137: 					SkipSpace();
  138: 					if ((ch == "{" && Peek() == "}") || (ch == "[" && Peek() == "]"))
  139: 					{
  140: 						m_Pos++;
  141: 						state = STATE_AFTER;
  142: 						continue;
  143: 					}
  144: 
  145: 					if (containers.Count() >= MAX_DEPTH)
  146: 					{
  147: 						Fail();
  148: 						break;
  149: 					}
  150: 
  151: 					if (ch == "{")
  152: 					{
  153: 						containers.Insert(IN_OBJECT);
  154: 						state = STATE_KEY;
  155: 					}
  156: 					else
  157: 					{
  158: 						containers.Insert(IN_ARRAY);
  159: 						state = STATE_VALUE;
  160: 					}
  161: 
  162: 					continue;
  163: 				}
  164: 
  165: 				ReadScalar(ch);
  166: 				state = STATE_AFTER;
  167: 				continue;
  168: 			}
  169: 
  170: 			if (state == STATE_KEY)
  171: 			{
  172: 				if (Peek() != "\"")
  173: 				{
  174: 					Fail();
  175: 					break;
  176: 				}
  177: 
  178: 				ReadString();
  179: 				SkipSpace();
  180: 				if (Peek() != ":")
  181: 				{
  182: 					Fail();
  183: 					break;
  184: 				}
  185: 
  186: 				m_Pos++;
  187: 				state = STATE_VALUE;
  188: 				continue;
  189: 			}
  190: 
  191: 			if (containers.Count() == 0)
  192: 			{
  193: 				break;
  194: 			}
  195: 
  196: 			top = containers[containers.Count() - 1];
  197: 			ch = Peek();
  198: 			if (ch == ",")
  199: 			{
  200: 				m_Pos++;
  201: 				if (top == IN_OBJECT)
  202: 				{
  203: 					state = STATE_KEY;
  204: 				}
  205: 				else
  206: 				{
  207: 					state = STATE_VALUE;
  208: 				}
  209: 
  210: 				continue;
  211: 			}
  212: 
  213: 			if ((top == IN_OBJECT && ch == "}") || (top == IN_ARRAY && ch == "]"))
  214: 			{
  215: 				m_Pos++;
  216: 				containers.RemoveOrdered(containers.Count() - 1);
  217: 				continue;
  218: 			}
  219: 
  220: 			Fail();
  221: 		}
  222: 
  223: 		if (!m_Failed)
  224: 		{
  225: 			SkipSpace();
  226: 			if (m_Pos < m_Len)
  227: 			{
  228: 				Fail();
  229: 			}
  230: 		}
  231: 
  232: 		if (!m_Failed)
  233: 		{
  234: 			return m_Len;
  235: 		}
  236: 
  237: 		return m_FailPos;
  238: 	}
  239: 
  240: 	protected void Fail()
  241: 	{
  242: 		if (!m_Failed)
  243: 		{
  244: 			m_Failed = true;
  245: 			m_FailPos = m_Pos;
  246: 		}
  247: 	}
  248: 
  249: 	protected string Peek()
  250: 	{
  251: 		if (m_Pos >= m_Len)
  252: 		{
  253: 			return "";
  254: 		}
  255: 
  256: 		return m_Text.Get(m_Pos);
  257: 	}
  258: 
  259: 	protected void SkipSpace()
  260: 	{
  261: 		while (m_Pos < m_Len)
  262: 		{
  263: 			string ch = m_Text.Get(m_Pos);
  264: 			int code = ch.ToAscii();
  265: 			if (code != 32 && code != 9 && code != 10 && code != 13)
  266: 			{
  267: 				return;
  268: 			}
  269: 
  270: 			m_Pos++;
  271: 		}
  272: 	}
  273: 
  274: 	// A string, true / false / null or a number; anything else is an error.
  275: 	protected void ReadScalar(string ch)
  276: 	{
  277: 		if (ch == "\"")
  278: 		{
  279: 			ReadString();
  280: 		}
  281: 		else if (ch == "t")
  282: 		{
  283: 			ReadWord("true");
  284: 		}
  285: 		else if (ch == "f")
  286: 		{
  287: 			ReadWord("false");
  288: 		}
  289: 		else if (ch == "n")
  290: 		{
  291: 			ReadWord("null");
  292: 		}
  293: 		else if (ch == "-" || IsDigit(ch))
  294: 		{
  295: 			ReadNumber();
  296: 		}
  297: 		else
  298: 		{
  299: 			Fail();
  300: 		}
  301: 	}
  302: 
  303: 	protected void ReadString()
  304: 	{
  305: 		m_Pos++;
  306: 		while (m_Pos < m_Len)
  307: 		{
  308: 			string ch = m_Text.Get(m_Pos);
  309: 			int code = ch.ToAscii();
  310: 			if (ch == "\"")
  311: 			{
  312: 				m_Pos++;
  313: 				return;
  314: 			}
  315: 
  316: 			if (code >= 0 && code < 32)
  317: 			{
  318: 				Fail();
  319: 				return;
  320: 			}
  321: 
  322: 			if (ch == "\\")
  323: 			{
  324: 				m_Pos++;
  325: 				string escaped = Peek();
  326: 				if (escaped == "u")
  327: 				{
  328: 					m_Pos += 5;
  329: 					continue;
  330: 				}
  331: 
  332: 				if (escaped != "\"" && escaped != "\\" && escaped != "/" && escaped != "b" && escaped != "f" && escaped != "n" && escaped != "r" && escaped != "t")
  333: 				{
  334: 					Fail();
  335: 					return;
  336: 				}
  337: 			}
  338: 
  339: 			m_Pos++;
  340: 		}
  341: 
  342: 		Fail();
  343: 	}
  344: 
  345: 	protected void ReadWord(string word)
  346: 	{
  347: 		int wordLen = word.Length();
  348: 		if (m_Pos + wordLen > m_Len || m_Text.Substring(m_Pos, wordLen) != word)
  349: 		{
  350: 			Fail();
  351: 			return;
  352: 		}
  353: 
  354: 		m_Pos += wordLen;
  355: 	}
  356: 
  357: 	protected void ReadNumber()
  358: 	{
  359: 		if (Peek() == "-")
  360: 		{
  361: 			m_Pos++;
  362: 		}
  363: 
  364: 		if (!IsDigit(Peek()))
  365: 		{
  366: 			Fail();
  367: 			return;
  368: 		}
  369: 
  370: 		while (IsDigit(Peek()))
  371: 		{
  372: 			m_Pos++;
  373: 		}
  374: 
  375: 		if (Peek() == ".")
  376: 		{
  377: 			m_Pos++;
  378: 			if (!IsDigit(Peek()))
  379: 			{
  380: 				Fail();
  381: 				return;
  382: 			}
  383: 
  384: 			while (IsDigit(Peek()))
  385: 			{
  386: 				m_Pos++;
  387: 			}
  388: 		}
  389: 
  390: 		string exponent = Peek();
  391: 		if (exponent == "e" || exponent == "E")
  392: 		{
  393: 			m_Pos++;
  394: 			string sign = Peek();
  395: 			if (sign == "+" || sign == "-")
  396: 			{
  397: 				m_Pos++;
  398: 			}
  399: 
  400: 			if (!IsDigit(Peek()))
  401: 			{
  402: 				Fail();
  403: 				return;
  404: 			}
  405: 
  406: 			while (IsDigit(Peek()))
  407: 			{
  408: 				m_Pos++;
  409: 			}
  410: 		}
  411: 	}
  412: 
  413: 	protected bool IsDigit(string ch)
  414: 	{
  415: 		if (ch == "")
  416: 		{
  417: 			return false;
  418: 		}
  419: 
  420: 		int code = ch.ToAscii();
  421: 		return code >= 48 && code <= 57;
  422: 	}
  423: };
  424: 
  425: // ---------------------------------------------------------------- Discord payload limits
  426: 
  427: class VPPDiscordField
  428: {
  429: 	string name;
  430: 	string value;
  431: };
  432: 
  433: class VPPDiscordFooter
  434: {
  435: 	string text;
  436: };
  437: 
  438: class VPPDiscordAuthor
  439: {
  440: 	string name;
  441: };
  442: 
  443: class VPPDiscordEmbed
  444: {
  445: 	string title;
  446: 	string description;
  447: 	ref array<ref VPPDiscordField> fields;
  448: 	ref VPPDiscordFooter footer;
  449: 	ref VPPDiscordAuthor author;
  450: };
  451: 
  452: class VPPDiscordPayload
  453: {
  454: 	string content;
  455: 	string username;
  456: 	ref array<ref VPPDiscordEmbed> embeds;
  457: };
  458: 
  459: class VPPDiscordLint
  460: {
  461: 	// Discord's documented limits; problems are English lines (codes for the UI later).
  462: 	static void Check(string body, array<string> outProblems)
  463: 	{
  464: 		outProblems.Clear();
  465: 		JsonSerializer serializer = new JsonSerializer();
  466: 		VPPDiscordPayload payload = new VPPDiscordPayload();
  467: 		string error = "";
  468: 		if (!serializer.ReadFromString(payload, body, error))
  469: 		{
  470: 			outProblems.Insert("Discord could not read this payload: a field has the wrong type (" + error.Trim() + ").");
  471: 			return;
  472: 		}
  473: 
  474: 		int contentLen = payload.content.LengthUtf8();
  475: 		if (contentLen > 2000)
  476: 		{
  477: 			outProblems.Insert("content is " + contentLen.ToString() + " characters (Discord allows 2000).");
  478: 		}
  479: 
  480: 		int embedCount = 0;
  481: 		if (payload.embeds)
  482: 		{
  483: 			embedCount = payload.embeds.Count();
  484: 		}
  485: 
  486: 		if (contentLen == 0 && embedCount == 0)
  487: 		{
  488: 			outProblems.Insert("Discord needs content or at least one embed.");
  489: 		}
  490: 
  491: 		if (embedCount > 10)
  492: 		{
  493: 			outProblems.Insert("There are " + embedCount.ToString() + " embeds (Discord allows 10).");
  494: 		}
  495: 
  496: 		int total = 0;
  497: 		for (int e = 0; e < embedCount; e++)
  498: 		{
  499: 			VPPDiscordEmbed embed = payload.embeds[e];
  500: 			if (!embed)
  501: 			{
  502: 				continue;
  503: 			}
  504: 
  505: 			total += CheckText(embed.title, 256, "embed title", outProblems);
  506: 			total += CheckText(embed.description, 4096, "embed description", outProblems);
  507: 			if (embed.author)
  508: 			{
  509: 				total += CheckText(embed.author.name, 256, "embed author name", outProblems);
  510: 			}
  511: 
  512: 			if (embed.footer)
  513: 			{
  514: 				total += CheckText(embed.footer.text, 2048, "embed footer", outProblems);
  515: 			}
  516: 
  517: 			if (!embed.fields)
  518: 			{
  519: 				continue;
  520: 			}
  521: 
  522: 			if (embed.fields.Count() > 25)
  523: 			{
  524: 				outProblems.Insert("An embed has more than 25 fields.");
  525: 			}
  526: 
  527: 			foreach (VPPDiscordField field : embed.fields)
  528: 			{
  529: 				if (!field)
  530: 				{
  531: 					continue;
  532: 				}
  533: 
  534: 				if (field.name == "" || field.value == "")
  535: 				{
  536: 					outProblems.Insert("An embed field has an empty name or value (Discord rejects it).");
  537: 				}
  538: 
  539: 				total += CheckText(field.name, 256, "field name", outProblems);
  540: 				total += CheckText(field.value, 1024, "field value", outProblems);
  541: 			}
  542: 		}
  543: 
  544: 		if (total > 6000)
  545: 		{
  546: 			outProblems.Insert("The embeds hold " + total.ToString() + " characters in total (Discord allows 6000).");
  547: 		}
  548: 	}
  549: 
  550: 	protected static int CheckText(string text, int limit, string label, array<string> outProblems)
  551: 	{
  552: 		int textLen = text.LengthUtf8();
  553: 		if (textLen > limit)
  554: 		{
  555: 			outProblems.Insert("A " + label + " is " + textLen.ToString() + " characters (Discord allows " + limit.ToString() + ").");
  556: 		}
  557: 
  558: 		return textLen;
  559: 	}
  560: };

==========================================================================================
ARQUIVO: 3_Game\VPPAdminTools\WebHooks\VPPWebhookDefs.c
==========================================================================================
    1: /*
    2: 	Webhook events and the variables each one offers to templates. Shared (3_Game) so the server renders and validates
    3: 	with them and the admin client can list them (variable reference, previews).
    4: 
    5: 	Every event also gets the common variables (server, players, time, event id). A variable's Sample is what previews
    6: 	and validation render with.
    7: */
    8: class VPPWebhookVar : Managed
    9: {
   10: 	string Name;
   11: 	string Sample;
   12: 
   13: 	void VPPWebhookVar(string name, string sample)
   14: 	{
   15: 		Name = name;
   16: 		Sample = sample;
   17: 	}
   18: };
   19: 
   20: class VPPWebhookEventDef : Managed
   21: {
   22: 	string Id;
   23: 	// legacy switch this event followed in old configs ("" = none): death, admin, hit, joinleave, status
   24: 	string LegacyGroup;
   25: 	ref array<ref VPPWebhookVar> Vars;
   26: 
   27: 	void VPPWebhookEventDef(string id, string legacyGroup)
   28: 	{
   29: 		Id = id;
   30: 		LegacyGroup = legacyGroup;
   31: 		Vars = new array<ref VPPWebhookVar>();
   32: 	}
   33: 
   34: 	void AddVar(string name, string sample)
   35: 	{
   36: 		Vars.Insert(new VPPWebhookVar(name, sample));
   37: 	}
   38: 
   39: 	bool HasVar(string name)
   40: 	{
   41: 		foreach (VPPWebhookVar webhookVar : Vars)
   42: 		{
   43: 			if (webhookVar.Name == name)
   44: 			{
   45: 				return true;
   46: 			}
   47: 		}
   48: 
   49: 		return false;
   50: 	}
   51: 
   52: 	// The sample values of every variable (common ones included), for previews and validation.
   53: 	void FillSamples(map<string, string> outVars)
   54: 	{
   55: 		foreach (VPPWebhookVar webhookVar : Vars)
   56: 		{
   57: 			outVars.Set(webhookVar.Name, webhookVar.Sample);
   58: 		}
   59: 	}
   60: };
   61: 
   62: class VPPWebhookDefs
   63: {
   64: 	const static string EV_ADMIN = "admin.action";
   65: 	const static string EV_KILL = "kill";
   66: 	const static string EV_HIT = "hit";
   67: 	const static string EV_JOIN = "join";
   68: 	const static string EV_LEAVE = "leave";
   69: 	const static string EV_LEAVE_EARLY = "leave.early";
   70: 	const static string EV_LOGOUT_START = "logout.start";
   71: 	const static string EV_LOGOUT_CANCEL = "logout.cancel";
   72: 	const static string EV_STATUS = "server.status";
   73: 	const static string EV_BOOT = "server.boot";
   74: 
   75: 	const static string GROUP_DEATH = "death";
   76: 	const static string GROUP_ADMIN = "admin";
   77: 	const static string GROUP_HIT = "hit";
   78: 	const static string GROUP_JOINLEAVE = "joinleave";
   79: 	const static string GROUP_STATUS = "status";
   80: 
   81: 	protected static ref array<ref VPPWebhookEventDef> s_Defs;
   82: 
   83: 	static array<ref VPPWebhookEventDef> All()
   84: 	{
   85: 		Ensure();
   86: 		return s_Defs;
   87: 	}
   88: 
   89: 	static VPPWebhookEventDef Get(string eventId)
   90: 	{
   91: 		Ensure();
   92: 		foreach (VPPWebhookEventDef def : s_Defs)
   93: 		{
   94: 			if (def.Id == eventId)
   95: 			{
   96: 				return def;
   97: 			}
   98: 		}
   99: 
  100: 		return null;
  101: 	}
  102: 
  103: 	protected static void Ensure()
  104: 	{
  105: 		if (s_Defs)
  106: 		{
  107: 			return;
  108: 		}
  109: 
  110: 		s_Defs = new array<ref VPPWebhookEventDef>();
  111: 		VPPWebhookEventDef def = NewDef(EV_ADMIN, GROUP_ADMIN);
  112: 		def.AddVar("admin.name", "SurvivorAdmin");
  113: 		def.AddVar("admin.id", "76561198000000000");
  114: 		def.AddVar("action", "[ItemManager] Spawned Item: M4A1 on self");
  115: 		def.AddVar("action.text", "Spawned Item: M4A1 on self");
  116: 		def.AddVar("module", "ItemManager");
  117: 
  118: 		def = NewDef(EV_KILL, GROUP_DEATH);
  119: 		def.AddVar("victim.name", "Survivor");
  120: 		def.AddVar("victim.id", "76561198000000001");
  121: 		def.AddVar("victim.pos", "7500.1, 290.5, 7700.2");
  122: 		def.AddVar("killer.name", "Bandit");
  123: 		def.AddVar("killer.id", "76561198000000002");
  124: 		def.AddVar("killer.pos", "7560.3, 291.0, 7712.8");
  125: 		def.AddVar("cause", "player");
  126: 		def.AddVar("weapon", "M4-A1");
  127: 		def.AddVar("distance", "61.4");
  128: 		def.AddVar("details", "Survivor (7500, 7700) killed by: Bandit (7560, 7712) with [M4-A1] from [61.4] meters");
  129: 
  130: 		def = NewDef(EV_HIT, GROUP_HIT);
  131: 		def.AddVar("victim.name", "Survivor");
  132: 		def.AddVar("victim.id", "76561198000000001");
  133: 		def.AddVar("victim.pos", "7500.1, 290.5, 7700.2");
  134: 		def.AddVar("source.name", "Bandit");
  135: 		def.AddVar("source.id", "76561198000000002");
  136: 		def.AddVar("source.kind", "player");
  137: 		def.AddVar("weapon", "M4-A1");
  138: 		def.AddVar("ammo", "Bullet_556x45");
  139: 		def.AddVar("zone", "Torso");
  140: 		def.AddVar("distance", "61.4");
  141: 		def.AddVar("health", "72.5");
  142: 		def.AddVar("details", "Survivor (7500, 7700) hit by Bandit (7560, 7712) into Torso(72.5 HP left) with (M4-A1) from (61.4) meters");
  143: 
  144: 		AddPlayerEvent(EV_JOIN, "joined the server!");
  145: 		AddPlayerEvent(EV_LEAVE, "left the server!");
  146: 		AddPlayerEvent(EV_LEAVE_EARLY, "disconnected early from server (EXIT NOW).");
  147: 		AddPlayerEvent(EV_LOGOUT_START, "initiated disconnect process..");
  148: 		AddPlayerEvent(EV_LOGOUT_CANCEL, "canceled logout");
  149: 
  150: 		def = NewDef(EV_STATUS, GROUP_STATUS);
  151: 		def.AddVar("server.fps", "58");
  152: 		def.AddVar("uptime", "0d 5h 12m 40s");
  153: 		def.AddVar("uptime.seconds", "18760");
  154: 
  155: 		NewDef(EV_BOOT, GROUP_STATUS);
  156: 
  157: 		foreach (VPPWebhookEventDef common : s_Defs)
  158: 		{
  159: 			AddCommonVars(common);
  160: 		}
  161: 	}
  162: 
  163: 	protected static VPPWebhookEventDef NewDef(string eventId, string legacyGroup)
  164: 	{
  165: 		VPPWebhookEventDef def = new VPPWebhookEventDef(eventId, legacyGroup);
  166: 		s_Defs.Insert(def);
  167: 		return def;
  168: 	}
  169: 
  170: 	protected static void AddPlayerEvent(string eventId, string actionSample)
  171: 	{
  172: 		VPPWebhookEventDef def = NewDef(eventId, GROUP_JOINLEAVE);
  173: 		def.AddVar("player.name", "Survivor");
  174: 		def.AddVar("player.id", "76561198000000001");
  175: 		def.AddVar("action", actionSample);
  176: 	}
  177: 
  178: 	protected static void AddCommonVars(VPPWebhookEventDef def)
  179: 	{
  180: 		def.AddVar("event", def.Id);
  181: 		def.AddVar("server.name", "My DayZ Server");
  182: 		def.AddVar("server.ip", "203.0.113.10");
  183: 		def.AddVar("server.port", "27016");
  184: 		def.AddVar("server.map", "chernarusplus");
  185: 		def.AddVar("players", "12");
  186: 		def.AddVar("time.iso", "2026-09-29T18:04:00.000Z");
  187: 		def.AddVar("time.unix", "1790705040");
  188: 		def.AddVar("time.date", "2026-09-29");
  189: 		def.AddVar("time.time", "18:04:00");
  190: 	}
  191: 
  192: 	// "hook.*" variables come from the webhook's own custom variables; they are always allowed in templates.
  193: 	static bool IsHookVar(string name)
  194: 	{
  195: 		return name.IndexOf("hook.") == 0;
  196: 	}
  197: };
  198: 
  199: // What an admin may do in the webhooks menu (the server sends the mask with the list; the server checks again).
  200: class VPPWebhookAccess
  201: {
  202: 	const static int CREATE = 1;
  203: 	const static int EDIT = 2;
  204: 	const static int DELETE = 4;
  205: 	const static int EDIT_TEMPLATES = 8;
  206: 	const static int TEST_SEND = 16;
  207: 	const static int VIEW_URL = 32;
  208: };
  209: 
  210: class VPPWebhookVarNames
  211: {
  212: 	// Letters, digits, "_" and "." (template variable and hook.* names).
  213: 	static bool IsPlain(string name)
  214: 	{
  215: 		int total = name.Length();
  216: 		int i = 0;
  217: 		int code = 0;
  218: 		string ch = "";
  219: 		if (total == 0)
  220: 		{
  221: 			return false;
  222: 		}
  223: 
  224: 		for (i = 0; i < total; i++)
  225: 		{
  226: 			ch = name.Get(i);
  227: 			code = ch.ToAscii();
  228: 			if (code >= 97 && code <= 122)
  229: 			{
  230: 				continue;
  231: 			}
  232: 
  233: 			if (code >= 65 && code <= 90)
  234: 			{
  235: 				continue;
  236: 			}
  237: 
  238: 			if (code >= 48 && code <= 57)
  239: 			{
  240: 				continue;
  241: 			}
  242: 
  243: 			if (ch != "." && ch != "_")
  244: 			{
  245: 				return false;
  246: 			}
  247: 		}
  248: 
  249: 		return true;
  250: 	}
  251: };

==========================================================================================
ARQUIVO: 3_Game\VPPAdminTools\WebHooks\VPPWebhookPresets.c
==========================================================================================
    1: /*
    2: 	Webhook presets: complete template sets for common services, built from one set of pieces per event (title, color,
    3: 	fields, a Discord markdown line and a plain line). The Discord presets reproduce the messages VPP sent before
    4: 	templates existed, so migrated webhooks look the same until an admin edits them.
    5: 
    6: 	Piece texts are written as they appear inside a JSON string (\n = newline). Webhook custom variables used here:
    7: 	hook.username, hook.avatar (Discord, Lolka), hook.chat_id (Telegram).
    8: 
    9: 	Lolka (lolka.app/developers/webhooks) takes Discord's webhook body (content, username, avatar_url, embeds with the
   10: 	same fields and limits); its presets are the Discord ones with plain markdown links (no Discord "(<url>)" preview
   11: 	suppression) and HTTPS links, as Lolka requires external URLs to be HTTPS.
   12: */
   13: class VPPWebhookPieceField : Managed
   14: {
   15: 	string Name;
   16: 	string Value;
   17: 	bool Inline;
   18: 	// the field is only sent when this variable is not empty ("" = always)
   19: 	string OnlyIf;
   20: };
   21: 
   22: class VPPWebhookPiece : Managed
   23: {
   24: 	string Title;
   25: 	int Color;
   26: 	string Line;
   27: 	string PlainLine;
   28: 	ref array<ref VPPWebhookPieceField> Fields;
   29: 
   30: 	void VPPWebhookPiece(string title, int color)
   31: 	{
   32: 		Title = title;
   33: 		Color = color;
   34: 		Line = "";
   35: 		PlainLine = "";
   36: 		Fields = new array<ref VPPWebhookPieceField>();
   37: 	}
   38: 
   39: 	void AddField(string name, string value, bool inline, string onlyIf)
   40: 	{
   41: 		VPPWebhookPieceField field = new VPPWebhookPieceField();
   42: 		field.Name = name;
   43: 		field.Value = value;
   44: 		field.Inline = inline;
   45: 		field.OnlyIf = onlyIf;
   46: 		Fields.Insert(field);
   47: 	}
   48: };
   49: 
   50: class VPPWebhookPresets
   51: {
   52: 	const static string DISCORD_EMBED = "discord_embed";
   53: 	const static string DISCORD_SIMPLE = "discord_simple";
   54: 	const static string LOLKA_EMBED = "lolka_embed";
   55: 	const static string LOLKA_SIMPLE = "lolka_simple";
   56: 	const static string SLACK = "slack";
   57: 	const static string TEAMS = "teams";
   58: 	const static string TELEGRAM = "telegram";
   59: 	const static string GENERIC_JSON = "generic_json";
   60: 	const static string PLAIN_TEXT = "plain_text";
   61: 
   62: 	const static string CT_JSON = "application/json";
   63: 	const static string CT_TEXT = "text/plain";
   64: 
   65: 	protected static ref map<string, ref VPPWebhookPiece> s_Pieces;
   66: 
   67: 	static void Ids(array<string> outIds)
   68: 	{
   69: 		outIds.Clear();
   70: 		outIds.Insert(DISCORD_EMBED);
   71: 		outIds.Insert(DISCORD_SIMPLE);
   72: 		outIds.Insert(LOLKA_EMBED);
   73: 		outIds.Insert(LOLKA_SIMPLE);
   74: 		outIds.Insert(SLACK);
   75: 		outIds.Insert(TEAMS);
   76: 		outIds.Insert(TELEGRAM);
   77: 		outIds.Insert(GENERIC_JSON);
   78: 		outIds.Insert(PLAIN_TEXT);
   79: 	}
   80: 
   81: 	static bool IsPreset(string presetId)
   82: 	{
   83: 		array<string> ids = new array<string>();
   84: 		Ids(ids);
   85: 		return ids.Find(presetId) >= 0;
   86: 	}
   87: 
   88: 	static string ContentTypeOf(string presetId)
   89: 	{
   90: 		if (presetId == PLAIN_TEXT)
   91: 		{
   92: 			return CT_TEXT;
   93: 		}
   94: 
   95: 		return CT_JSON;
   96: 	}
   97: 
   98: 	static bool IsDiscord(string presetId)
   99: 	{
  100: 		return presetId == DISCORD_EMBED || presetId == DISCORD_SIMPLE;
  101: 	}
  102: 
  103: 	static bool IsLolka(string presetId)
  104: 	{
  105: 		return presetId == LOLKA_EMBED || presetId == LOLKA_SIMPLE;
  106: 	}
  107: 
  108: 	// Presets whose body follows Discord's webhook format and limits (checked with VPPDiscordLint).
  109: 	static bool UsesDiscordLimits(string presetId)
  110: 	{
  111: 		return IsDiscord(presetId) || IsLolka(presetId);
  112: 	}
  113: 
  114: 	// The template of an event in a preset ("" when the event is unknown).
  115: 	static string TemplateFor(string presetId, string eventId)
  116: 	{
  117: 		EnsurePieces();
  118: 		VPPWebhookPiece piece = s_Pieces.Get(eventId);
  119: 		VPPWebhookEventDef def = VPPWebhookDefs.Get(eventId);
  120: 		if (!piece || !def)
  121: 		{
  122: 			return "";
  123: 		}
  124: 
  125: 		if (presetId == DISCORD_SIMPLE)
  126: 		{
  127: 			return DiscordSimple(piece);
  128: 		}
  129: 
  130: 		if (presetId == LOLKA_EMBED)
  131: 		{
  132: 			string lolkaEmbed = DiscordEmbed(piece);
  133: 			return ForLolka(lolkaEmbed);
  134: 		}
  135: 
  136: 		if (presetId == LOLKA_SIMPLE)
  137: 		{
  138: 			string lolkaSimple = DiscordSimple(piece);
  139: 			return ForLolka(lolkaSimple);
  140: 		}
  141: 
  142: 		if (presetId == SLACK)
  143: 		{
  144: 			return "{\n  \"text\": \"" + piece.PlainLine + "\"\n}\n";
  145: 		}
  146: 
  147: 		if (presetId == TEAMS)
  148: 		{
  149: 			return Teams(piece);
  150: 		}
  151: 
  152: 		if (presetId == TELEGRAM)
  153: 		{
  154: 			return "{\n  \"chat_id\": \"{{hook.chat_id}}\",\n  \"text\": \"" + piece.PlainLine + "\",\n  \"disable_web_page_preview\": true\n}\n";
  155: 		}
  156: 
  157: 		if (presetId == GENERIC_JSON)
  158: 		{
  159: 			return GenericJson(def);
  160: 		}
  161: 
  162: 		if (presetId == PLAIN_TEXT)
  163: 		{
  164: 			return piece.PlainLine + "\n";
  165: 		}
  166: 
  167: 		return DiscordEmbed(piece);
  168: 	}
  169: 
  170: 	protected static string DiscordEmbed(VPPWebhookPiece piece)
  171: 	{
  172: 		string colorText = piece.Color.ToString();
  173: 		string text = "{\n  \"embeds\": [\n    {\n      \"title\": \"" + piece.Title + "\",\n      \"color\": " + colorText + ",\n";
  174: 		text = text + "      \"author\": {\n        \"name\": \"{{hook.username|default:VPPAdminTools}}\",\n";
  175: 		text = text + "        \"url\": \"https://steamcommunity.com/sharedfiles/filedetails/?id=1828439124\",\n";
  176: 		text = text + "        \"icon_url\": \"{{hook.avatar|default:https://i.imgur.com/oSEhCJV.png}}\"\n      },\n";
  177: 		text = text + "      \"fields\": [\n";
  178: 		for (int i = 0; i < piece.Fields.Count(); i++)
  179: 		{
  180: 			VPPWebhookPieceField field = piece.Fields[i];
  181: 			string inlineText = "false";
  182: 			if (field.Inline)
  183: 			{
  184: 				inlineText = "true";
  185: 			}
  186: 
  187: 			string entry = "        { \"name\": \"" + field.Name + "\", \"value\": \"" + field.Value + "\", \"inline\": " + inlineText + " }";
  188: 			text = text + FieldSeparator(i, field, entry);
  189: 		}
  190: 
  191: 		text = text + "\n      ],\n      \"timestamp\": \"{{time.iso}}\"\n    }\n  ]\n}\n";
  192: 		return text;
  193: 	}
  194: 
  195: 	protected static string DiscordSimple(VPPWebhookPiece piece)
  196: 	{
  197: 		string text = "{\n  \"content\": \"" + piece.Line + "\",\n";
  198: 		text = text + "  \"username\": \"{{hook.username|default:VPPAdminTools}}\",\n";
  199: 		text = text + "  \"avatar_url\": \"{{hook.avatar|default:https://i.imgur.com/oSEhCJV.png}}\"\n}\n";
  200: 		return text;
  201: 	}
  202: 
  203: 	// Discord text -> Lolka: "[x](<url>)" becomes "[x](url)" and the server check link uses HTTPS.
  204: 	protected static string ForLolka(string text)
  205: 	{
  206: 		string converted = text;
  207: 		converted.Replace("(<", "(");
  208: 		converted.Replace(">)", ")");
  209: 		converted.Replace("http://dayzsalauncher.com", "https://dayzsalauncher.com");
  210: 		return converted;
  211: 	}
  212: 
  213: 	protected static string Teams(VPPWebhookPiece piece)
  214: 	{
  215: 		string colorHex = HexColor(piece.Color);
  216: 		string text = "{\n  \"@type\": \"MessageCard\",\n  \"@context\": \"https://schema.org/extensions\",\n";
  217: 		text = text + "  \"themeColor\": \"" + colorHex + "\",\n  \"summary\": \"" + piece.Title + "\",\n  \"title\": \"" + piece.Title + "\",\n";
  218: 		text = text + "  \"sections\": [\n    {\n      \"facts\": [\n";
  219: 		for (int i = 0; i < piece.Fields.Count(); i++)
  220: 		{
  221: 			VPPWebhookPieceField field = piece.Fields[i];
  222: 			string entry = "        { \"name\": \"" + field.Name + "\", \"value\": \"" + field.Value + "\" }";
  223: 			text = text + FieldSeparator(i, field, entry);
  224: 		}
  225: 
  226: 		text = text + "\n      ]\n    }\n  ]\n}\n";
  227: 		return text;
  228: 	}
  229: 
  230: 	// Every variable of the event as one flat JSON object (for services that do their own formatting).
  231: 	protected static string GenericJson(VPPWebhookEventDef def)
  232: 	{
  233: 		string text = "{\n";
  234: 		int total = def.Vars.Count();
  235: 		for (int i = 0; i < total; i++)
  236: 		{
  237: 			VPPWebhookVar webhookVar = def.Vars[i];
  238: 			string comma = ",";
  239: 			if (i == total - 1)
  240: 			{
  241: 				comma = "";
  242: 			}
  243: 
  244: 			text = text + "  \"" + webhookVar.Name + "\": \"{{" + webhookVar.Name + "}}\"" + comma + "\n";
  245: 		}
  246: 
  247: 		return text + "}\n";
  248: 	}
  249: 
  250: 	// The first field is always sent; a later conditional field carries its own leading comma inside the condition.
  251: 	protected static string FieldSeparator(int index, VPPWebhookPieceField field, string entry)
  252: 	{
  253: 		if (index == 0)
  254: 		{
  255: 			return entry;
  256: 		}
  257: 
  258: 		if (field.OnlyIf == "")
  259: 		{
  260: 			return ",\n" + entry;
  261: 		}
  262: 
  263: 		return "{{#if " + field.OnlyIf + "}},\n" + entry + "{{/if}}";
  264: 	}
  265: 
  266: 	static string HexColor(int color)
  267: 	{
  268: 		string digits = "0123456789ABCDEF";
  269: 		string hex = "";
  270: 		int remaining = color;
  271: 		for (int i = 0; i < 6; i++)
  272: 		{
  273: 			int nibble = remaining % 16;
  274: 			hex = digits.Get(nibble) + hex;
  275: 			remaining = remaining / 16;
  276: 		}
  277: 
  278: 		return hex;
  279: 	}
  280: 
  281: 	protected static void EnsurePieces()
  282: 	{
  283: 		if (s_Pieces)
  284: 		{
  285: 			return;
  286: 		}
  287: 
  288: 		s_Pieces = new map<string, ref VPPWebhookPiece>();
  289: 		string steamLink = "[Steam Profile]({{admin.id|steamurl}})";
  290: 		string victimValue = "{{victim.name}}\\n[{{victim.id}}]\\n[Steam Profile]({{victim.id|steamurl}})";
  291: 		string serverLink = "(<http://dayzsalauncher.com/#/servercheck/{{server.ip}}:{{server.port}}>)";
  292: 
  293: 		VPPWebhookPiece piece = new VPPWebhookPiece("Admin Activity Report:", 16766720);
  294: 		piece.AddField("Name:", "{{admin.name|default:Unknown}}", true, "");
  295: 		piece.AddField("Steam64ID:", "{{admin.id}} " + steamLink, true, "");
  296: 		piece.AddField("Details:", "**{{action}}**", false, "");
  297: 		piece.Line = "**Admin Activity:** [{{admin.name}}](<{{admin.id|steamurl}}>) Details: **{{action}}**";
  298: 		piece.PlainLine = "Admin activity: {{admin.name}} ({{admin.id}}): {{action}}";
  299: 		s_Pieces.Set(VPPWebhookDefs.EV_ADMIN, piece);
  300: 
  301: 		piece = new VPPWebhookPiece("Kill / Death Report:", 16711680);
  302: 		piece.AddField("Victim:", victimValue, true, "");
  303: 		string killerValue = "{{#ifeq cause suicide}}Suicide{{else}}{{#if killer.id}}{{killer.name}}\\n[{{killer.id}}]\\n[Steam Profile]({{killer.id|steamurl}}){{else}}{{killer.name}}{{/if}}{{/ifeq}}";
  304: 		piece.AddField("Killer:", killerValue, true, "killer.name");
  305: 		piece.AddField("Details:", "**{{details}}**", false, "");
  306: 		string killLine = "**Player Activity:** [{{victim.name}}](<{{victim.id|steamurl}}>) ";
  307: 		killLine = killLine + "{{#ifeq cause infected}}died to an **Infected**.{{else}}{{#ifeq cause suicide}}killed **themselves**.{{else}}";
  308: 		killLine = killLine + "{{#if killer.id}}**killed by** [{{killer.name}}](<{{killer.id|steamurl}}>){{/if}}{{/ifeq}}{{/ifeq}} {{details}}";
  309: 		piece.Line = killLine;
  310: 		string killPlain = "{{victim.name}} died{{#ifeq cause suicide}} (suicide){{/ifeq}}{{#if killer.id}}, killed by {{killer.name}}{{/if}}";
  311: 		killPlain = killPlain + "{{#ifeq cause infected}}, killed by infected{{/ifeq}}{{#if weapon}} with {{weapon}}{{/if}}{{#if distance}} from {{distance}} m{{/if}}.";
  312: 		piece.PlainLine = killPlain;
  313: 		s_Pieces.Set(VPPWebhookDefs.EV_KILL, piece);
  314: 
  315: 		piece = new VPPWebhookPiece("Hit Report:", 16711680);
  316: 		piece.AddField("Victim:", victimValue, true, "");
  317: 		string sourceValue = "{{#ifeq source.kind object}}{{source.name|default:Unknown}}{{else}}{{#ifeq source.kind self}}Self Harm{{else}}";
  318: 		sourceValue = sourceValue + "{{#ifeq source.kind explosion}}Explosion of Type: [ {{source.name}} ]{{else}}";
  319: 		sourceValue = sourceValue + "{{#if source.id}}{{source.name}}\\n[{{source.id}}]\\n[Steam Profile]({{source.id|steamurl}}){{else}}{{source.name|default:Unknown}}{{/if}}{{/ifeq}}{{/ifeq}}{{/ifeq}}";
  320: 		piece.AddField("Source:", sourceValue, true, "");
  321: 		piece.AddField("Details:", "**{{details}}**", false, "");
  322: 		string hitLine = "**Hit Damage:** [{{victim.name}}](<{{victim.id|steamurl}}>) {{#ifeq source.kind object}}got hit by: **{{source.name}}**{{else}}";
  323: 		hitLine = hitLine + "{{#ifeq source.kind self}}caused damaged to themselves.{{else}}{{#ifeq source.kind explosion}}got hit by an explosion of type: **{{source.name}}**{{else}}";
  324: 		hitLine = hitLine + "got hit by: {{#if source.id}}[**{{source.name}}**](<{{source.id|steamurl}}>){{else}}**{{source.name}}**{{/if}}{{/ifeq}}{{/ifeq}}{{/ifeq}} {{details}}";
  325: 		piece.Line = hitLine;
  326: 		piece.PlainLine = "{{victim.name}} was hit by {{source.name}}{{#if weapon}} with {{weapon}}{{/if}}{{#if zone}} in the {{zone}}{{/if}}.";
  327: 		s_Pieces.Set(VPPWebhookDefs.EV_HIT, piece);
  328: 
  329: 		array<string> playerEvents = new array<string>();
  330: 		playerEvents.Insert(VPPWebhookDefs.EV_JOIN);
  331: 		playerEvents.Insert(VPPWebhookDefs.EV_LEAVE);
  332: 		playerEvents.Insert(VPPWebhookDefs.EV_LEAVE_EARLY);
  333: 		playerEvents.Insert(VPPWebhookDefs.EV_LOGOUT_START);
  334: 		playerEvents.Insert(VPPWebhookDefs.EV_LOGOUT_CANCEL);
  335: 		foreach (string playerEvent : playerEvents)
  336: 		{
  337: 			piece = new VPPWebhookPiece("Player: {{player.name}} {{action}}", 255);
  338: 			piece.AddField("Steam64ID:", "{{player.id}}\\n[Steam Profile]({{player.id|steamurl}})", true, "");
  339: 			piece.AddField("Players:", "{{players|default:0}}", true, "");
  340: 			piece.Line = "[{{player.name}}](<{{player.id|steamurl}}>) {{action}} **{{players}}**";
  341: 			piece.PlainLine = "{{player.name}} {{action}} ({{players}} online)";
  342: 			s_Pieces.Set(playerEvent, piece);
  343: 		}
  344: 
  345: 		piece = new VPPWebhookPiece("**SERVER STATUS REPORT:**\\n**{{server.name}}**", 16766720);
  346: 		string statusValue = "[**{{server.name}}**]" + serverLink + "\\nUp-Time: {{uptime}}\\nServer FPS: {{server.fps}}\\nPlayers: {{players}}";
  347: 		piece.AddField("Server Status:", statusValue, false, "");
  348: 		piece.Line = "**Server Status:** [{{server.name}}]" + serverLink + " Up-Time: **{{uptime}}** Server FPS: **{{server.fps}}** Players: **{{players}}**";
  349: 		piece.PlainLine = "{{server.name}}: up {{uptime}}, {{server.fps}} FPS, {{players}} players";
  350: 		s_Pieces.Set(VPPWebhookDefs.EV_STATUS, piece);
  351: 
  352: 		piece = new VPPWebhookPiece("**SERVER BOOT-UP REPORT**", 65280);
  353: 		piece.AddField("Server Online!", "Server [**{{server.name}}**]" + serverLink + " has **booted-up** successfully!", true, "");
  354: 		piece.Line = "Server [**{{server.name}}**]" + serverLink + " successfully started, player connect enabled.";
  355: 		piece.PlainLine = "{{server.name}} started, players can connect.";
  356: 		s_Pieces.Set(VPPWebhookDefs.EV_BOOT, piece);
  357: 	}
  358: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookSender.c
==========================================================================================
    1: // An event to send: its id and variables (VPPWebhookDefs lists the built-in ones). Other mods can emit their own ids
    2: // with any variables through GetWebHooksManager().Emit(); templates for them are not name-checked.
    3: class VPPWebhookEvent : Managed
    4: {
    5: 	string Id;
    6: 	ref map<string, string> Vars;
    7: 
    8: 	void VPPWebhookEvent(string eventId)
    9: 	{
   10: 		Id = eventId;
   11: 		Vars = new map<string, string>();
   12: 	}
   13: 
   14: 	void Set(string name, string value)
   15: 	{
   16: 		Vars.Set(name, value);
   17: 	}
   18: 
   19: 	string Get(string name)
   20: 	{
   21: 		string value = "";
   22: 		if (Vars.Contains(name))
   23: 		{
   24: 			value = Vars.Get(name);
   25: 		}
   26: 
   27: 		return value;
   28: 	}
   29: };
   30: 
   31: // Delivery numbers of one webhook (since the server started).
   32: class VPPWebhookStats : Managed
   33: {
   34: 	int Queued;
   35: 	int Delivered;
   36: 	// accepted without an answer (a 2xx without body is reported by the engine like a timeout)
   37: 	int NoReply;
   38: 	int Failed;
   39: 	int Dropped;
   40: 	int ConsecutiveFailures;
   41: 	string LastError;
   42: 	string LastErrorTime;
   43: 	string LastSuccessTime;
   44: };
   45: 
   46: // A request in flight or waiting in the queue.
   47: class VPPWebhookJob : Managed
   48: {
   49: 	int Id;
   50: 	string EventId;
   51: 	string Body;
   52: 	int Attempts;
   53: 	// GetGame().GetTime() before which it is not sent (retry backoff)
   54: 	int NotBefore;
   55: 	// a test send: who asked (plain id) and their request id
   56: 	string TestBy;
   57: 	int TestReqId;
   58: };
   59: 
   60: // One request's answer. Bound to a sender + job while the request runs, unbound on the first answer (a second
   61: // answer for the same request is ignored) and then reused through VPPWebhookCallbackPool.
   62: class VPPWebhookRequestCallback : RestCallback
   63: {
   64: 	protected VPPWebhookSender m_Owner;
   65: 	protected int m_JobId;
   66: 
   67: 	void Bind(VPPWebhookSender owner, int jobId)
   68: 	{
   69: 		m_Owner = owner;
   70: 		m_JobId = jobId;
   71: 	}
   72: 
   73: 	protected void Answer(int state)
   74: 	{
   75: 		VPPWebhookSender owner = m_Owner;
   76: 		int jobId = m_JobId;
   77: 		m_Owner = null;
   78: 		if (owner)
   79: 		{
   80: 			owner.OnRequestDone(jobId, state, this);
   81: 		}
   82: 	}
   83: 
   84: 	override void OnSuccess(string data, int dataSize)
   85: 	{
   86: 		Answer(VPPWebhookSender.RESULT_SUCCESS);
   87: 	}
   88: 
   89: 	override void OnError(int errorCode)
   90: 	{
   91: 		Answer(errorCode);
   92: 	}
   93: 
   94: 	override void OnTimeout()
   95: 	{
   96: 		Answer(VPPWebhookSender.RESULT_NO_REPLY);
   97: 	}
   98: };
   99: 
  100: // The engine keeps a reference to every RestCallback it is given (proven 2026-09-29: every callback, also the older
  101: // VPPAT_IPIFY one, showed as leaked at shutdown), so one new callback per message would grow without end. Answered
  102: // callbacks go back here and are bound to the next request; the pool never holds more than were in flight at once.
  103: class VPPWebhookCallbackPool
  104: {
  105: 	protected static ref array<ref VPPWebhookRequestCallback> s_Free;
  106: 
  107: 	static VPPWebhookRequestCallback Acquire(VPPWebhookSender owner, int jobId)
  108: 	{
  109: 		VPPWebhookRequestCallback callback = null;
  110: 		if (!s_Free)
  111: 		{
  112: 			s_Free = new array<ref VPPWebhookRequestCallback>();
  113: 		}
  114: 
  115: 		int last = s_Free.Count() - 1;
  116: 		if (last >= 0)
  117: 		{
  118: 			callback = s_Free[last];
  119: 			s_Free.Remove(last);
  120: 		}
  121: 		else
  122: 		{
  123: 			callback = new VPPWebhookRequestCallback();
  124: 		}
  125: 
  126: 		callback.Bind(owner, jobId);
  127: 		return callback;
  128: 	}
  129: 
  130: 	static void Release(VPPWebhookRequestCallback callback)
  131: 	{
  132: 		if (!callback)
  133: 		{
  134: 			return;
  135: 		}
  136: 
  137: 		if (!s_Free)
  138: 		{
  139: 			s_Free = new array<ref VPPWebhookRequestCallback>();
  140: 		}
  141: 
  142: 		if (s_Free.Find(callback) < 0)
  143: 		{
  144: 			s_Free.Insert(callback);
  145: 		}
  146: 	}
  147: };
  148: 
  149: /*
  150: 	Runtime of one webhook (server): its compiled templates, the send queue (rate limited per minute, retried with
  151: 	backoff) and the delivery stats. Request callbacks stay referenced until the engine calls them: the engine keeps a
  152: 	raw pointer, so they are never freed early.
  153: */
  154: class VPPWebhookSender : Managed
  155: {
  156: 	// Result codes as the engine really reports them (DayZServer 1.30 sub_1408B07C0 / sub_1408C9260). The script
  157: 	// ERestResultState names are one step off (its EREST_ERROR is 5, the engine's 4xx code), so they are not used.
  158: 	const static int RESULT_SUCCESS = 3;
  159: 	// HTTP 4xx (bad body, bad / deleted webhook URL, rate limited)
  160: 	const static int RESULT_HTTP_4XX = 5;
  161: 	// HTTP 5xx
  162: 	const static int RESULT_HTTP_5XX = 6;
  163: 	// any other curl failure: connect, DNS, TLS, or a 3xx redirect (redirects are not followed)
  164: 	const static int RESULT_NETWORK = 7;
  165: 	// curl timeout, or a 2xx without a body (Discord without ?wait=true answers 204)
  166: 	const static int RESULT_NO_REPLY = 8;
  167: 
  168: 	const static int MAX_QUEUE = 100;
  169: 	const static int MAX_IN_FLIGHT = 50;
  170: 	const static int MAX_ATTEMPTS = 4;
  171: 
  172: 	protected WebHook m_Hook;
  173: 	protected ref map<string, ref VPPWebhookTemplate> m_Templates;
  174: 	protected ref array<ref VPPWebhookJob> m_Queue;
  175: 	protected ref map<int, ref VPPWebhookJob> m_InFlight;
  176: 	// callbacks of the requests in flight (back to VPPWebhookCallbackPool when answered)
  177: 	protected ref map<int, ref VPPWebhookRequestCallback> m_Callbacks;
  178: 	protected ref array<int> m_SentTimes;
  179: 	protected int m_NextJobId;
  180: 	ref VPPWebhookStats Stats;
  181: 
  182: 	void VPPWebhookSender(WebHook hook)
  183: 	{
  184: 		m_Hook = hook;
  185: 		m_Templates = new map<string, ref VPPWebhookTemplate>();
  186: 		m_Queue = new array<ref VPPWebhookJob>();
  187: 		m_InFlight = new map<int, ref VPPWebhookJob>();
  188: 		m_Callbacks = new map<int, ref VPPWebhookRequestCallback>();
  189: 		m_SentTimes = new array<int>();
  190: 		Stats = new VPPWebhookStats();
  191: 	}
  192: 
  193: 	WebHook GetHook()
  194: 	{
  195: 		return m_Hook;
  196: 	}
  197: 
  198: 	void SetTemplate(string eventId, VPPWebhookTemplate tpl)
  199: 	{
  200: 		m_Templates.Set(eventId, tpl);
  201: 	}
  202: 
  203: 	VPPWebhookTemplate GetTemplate(string eventId)
  204: 	{
  205: 		return m_Templates.Get(eventId);
  206: 	}
  207: 
  208: 	bool IsJson()
  209: 	{
  210: 		return m_Hook.m_ContentType.Contains("json");
  211: 	}
  212: 
  213: 	// Render with the webhook's variables added (hook.*) and its redaction applied; "" when there is no usable template.
  214: 	string Render(VPPWebhookEvent webhookEvent)
  215: 	{
  216: 		VPPWebhookTemplate tpl = m_Templates.Get(webhookEvent.Id);
  217: 		if (!tpl || tpl.HasErrors())
  218: 		{
  219: 			return "";
  220: 		}
  221: 
  222: 		map<string, string> vars = new map<string, string>();
  223: 		vars.Copy(webhookEvent.Vars);
  224: 		for (int i = 0; i < m_Hook.m_Vars.Count(); i++)
  225: 		{
  226: 			string hookKey = m_Hook.m_Vars.GetKey(i);
  227: 			string hookValue = m_Hook.m_Vars.GetElement(i);
  228: 			vars.Set("hook." + hookKey, hookValue);
  229: 		}
  230: 
  231: 		Redact(vars);
  232: 		bool jsonBody = IsJson();
  233: 		return tpl.Render(vars, jsonBody);
  234: 	}
  235: 
  236: 	protected void Redact(map<string, string> vars)
  237: 	{
  238: 		if (m_Hook.m_HideServerAddress)
  239: 		{
  240: 			vars.Set("server.ip", "hidden");
  241: 			vars.Set("server.port", "hidden");
  242: 		}
  243: 
  244: 		if (!m_Hook.m_HideIds)
  245: 		{
  246: 			return;
  247: 		}
  248: 
  249: 		for (int i = 0; i < vars.Count(); i++)
  250: 		{
  251: 			string varName = vars.GetKey(i);
  252: 			if (varName.Length() > 3 && varName.Substring(varName.Length() - 3, 3) == ".id")
  253: 			{
  254: 				vars.Set(varName, "hidden");
  255: 			}
  256: 		}
  257: 	}
  258: 
  259: 	// ---------------------------------------------------------------- queue
  260: 
  261: 	void Enqueue(string eventId, string body, string testBy, int testReqId)
  262: 	{
  263: 		if (body == "")
  264: 		{
  265: 			return;
  266: 		}
  267: 
  268: 		if (m_Queue.Count() >= MAX_QUEUE)
  269: 		{
  270: 			m_Queue.RemoveOrdered(0);
  271: 			Stats.Dropped++;
  272: 		}
  273: 
  274: 		VPPWebhookJob job = new VPPWebhookJob();
  275: 		m_NextJobId++;
  276: 		job.Id = m_NextJobId;
  277: 		job.EventId = eventId;
  278: 		job.Body = body;
  279: 		job.TestBy = testBy;
  280: 		job.TestReqId = testReqId;
  281: 		m_Queue.Insert(job);
  282: 		Stats.Queued++;
  283: 	}
  284: 
  285: 	// Called every second by the manager: sends what the rate limit and the in-flight cap allow.
  286: 	void Pump()
  287: 	{
  288: 		int now = GetGame().GetTime();
  289: 		if (m_Queue.Count() == 0 || !m_Hook)
  290: 		{
  291: 			return;
  292: 		}
  293: 
  294: 		for (int i = m_SentTimes.Count() - 1; i >= 0; i--)
  295: 		{
  296: 			if (now - m_SentTimes[i] > 60000)
  297: 			{
  298: 				m_SentTimes.Remove(i);
  299: 			}
  300: 		}
  301: 
  302: 		int budget = m_Hook.GetRateLimit() - m_SentTimes.Count();
  303: 		int index = 0;
  304: 		while (budget > 0 && index < m_Queue.Count() && m_InFlight.Count() < MAX_IN_FLIGHT)
  305: 		{
  306: 			VPPWebhookJob job = m_Queue[index];
  307: 			if (job.NotBefore > now)
  308: 			{
  309: 				index++;
  310: 				continue;
  311: 			}
  312: 
  313: 			m_Queue.RemoveOrdered(index);
  314: 			Send(job);
  315: 			m_SentTimes.Insert(now);
  316: 			budget--;
  317: 		}
  318: 	}
  319: 
  320: 	// Messages waiting in the queue (not sent yet).
  321: 	int QueueCount()
  322: 	{
  323: 		return m_Queue.Count();
  324: 	}
  325: 
  326: 	// Requests still waiting for the engine (the manager keeps a sender alive until this is 0).
  327: 	int PendingRequests()
  328: 	{
  329: 		return m_InFlight.Count();
  330: 	}
  331: 
  332: 	protected void Send(VPPWebhookJob job)
  333: 	{
  334: 		string url = m_Hook.GetSendUrl();
  335: 		if (url == "" || !GetRestApi())
  336: 		{
  337: 			Finish(job, false, "no URL or no RestApi");
  338: 			return;
  339: 		}
  340: 
  341: 		job.Attempts++;
  342: 		VPPWebhookRequestCallback callback = VPPWebhookCallbackPool.Acquire(this, job.Id);
  343: 		m_Callbacks.Set(job.Id, callback);
  344: 		m_InFlight.Set(job.Id, job);
  345: 		RestContext context = GetRestApi().GetRestContext(url);
  346: 		context.SetHeader(m_Hook.m_ContentType);
  347: 		context.POST(callback, "", job.Body);
  348: 	}
  349: 
  350: 	void OnRequestDone(int jobId, int state, VPPWebhookRequestCallback callback)
  351: 	{
  352: 		VPPWebhookJob job = m_InFlight.Get(jobId);
  353: 		m_InFlight.Remove(jobId);
  354: 		VPPWebhookCallbackPool.Release(callback);
  355: 		m_Callbacks.Remove(jobId);
  356: 		// a retired sender (its webhook was deleted / replaced) only waits for its callbacks
  357: 		if (!job || !m_Hook)
  358: 		{
  359: 			return;
  360: 		}
  361: 
  362: 		if (state == RESULT_SUCCESS)
  363: 		{
  364: 			Finish(job, true, "");
  365: 			return;
  366: 		}
  367: 
  368: 		// a bodyless 2xx and a real timeout look the same; with Discord's ?wait=true a delivered message has a body
  369: 		if (state == RESULT_NO_REPLY && !m_Hook.ExpectsReply())
  370: 		{
  371: 			Stats.NoReply++;
  372: 			Stats.ConsecutiveFailures = 0;
  373: 			string noReplyTime = TimeText();
  374: 			Stats.LastSuccessTime = noReplyTime;
  375: 			ReportTest(job, true, "NO_REPLY");
  376: 			return;
  377: 		}
  378: 
  379: 		string reason = StateName(state);
  380: 		// 4xx is usually a bad payload or URL: one retry (covers a 429 rate limit); server / network errors retry more
  381: 		int maxAttempts = MAX_ATTEMPTS;
  382: 		if (state == RESULT_HTTP_4XX)
  383: 		{
  384: 			maxAttempts = 2;
  385: 		}
  386: 
  387: 		if (job.Attempts < maxAttempts && job.TestBy == "")
  388: 		{
  389: 			int delay = 10000 * job.Attempts * job.Attempts;
  390: 			job.NotBefore = GetGame().GetTime() + delay;
  391: 			m_Queue.InsertAt(job, 0);
  392: 			return;
  393: 		}
  394: 
  395: 		Finish(job, false, reason);
  396: 	}
  397: 
  398: 	protected void Finish(VPPWebhookJob job, bool ok, string reason)
  399: 	{
  400: 		string now = TimeText();
  401: 		if (ok)
  402: 		{
  403: 			Stats.Delivered++;
  404: 			Stats.ConsecutiveFailures = 0;
  405: 			Stats.LastSuccessTime = now;
  406: 			ReportTest(job, true, "DELIVERED");
  407: 			return;
  408: 		}
  409: 
  410: 		Stats.Failed++;
  411: 		Stats.ConsecutiveFailures++;
  412: 		Stats.LastError = reason;
  413: 		Stats.LastErrorTime = now;
  414: 		string hookName = m_Hook.GetName();
  415: 		Print("[WebHooksManager] Webhook \"" + hookName + "\" failed to deliver " + job.EventId + ": " + reason);
  416: 		if (reason.IndexOf("HTTP_4XX") == 0)
  417: 		{
  418: 			DiagnoseRejected(job);
  419: 		}
  420: 
  421: 		ReportTest(job, false, reason);
  422: 	}
  423: 
  424: 	protected void ReportTest(VPPWebhookJob job, bool ok, string reason)
  425: 	{
  426: 		if (job.TestBy == "")
  427: 		{
  428: 			return;
  429: 		}
  430: 
  431: 		WebHooksManager manager = GetWebHooksManager();
  432: 		if (manager)
  433: 		{
  434: 			manager.OnTestResult(job.TestBy, job.TestReqId, m_Hook.m_Id, job.EventId, ok, reason);
  435: 		}
  436: 	}
  437: 
  438: 	// A 4xx: the full body goes to Rejected/<webhook id>_<event>.txt (the newest one per event), and the log says
  439: 	// whether the game's JSON parser accepts it (with line / column) and which Discord limits it breaks. Valid JSON
  440: 	// with no limit problems points at the URL or the service's rate limit instead.
  441: 	protected void DiagnoseRejected(VPPWebhookJob job)
  442: 	{
  443: 		string dir = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Rejected";
  444: 		string path = "";
  445: 		string verdictText = "";
  446: 		string lineText = "";
  447: 		string colText = "";
  448: 		string problem = "";
  449: 		VPPJsonCheckResult verdict = null;
  450: 		array<string> problems = new array<string>();
  451: 		if (!FileExist(dir))
  452: 		{
  453: 			MakeDirectory(dir);
  454: 		}
  455: 
  456: 		path = dir + "/" + m_Hook.m_Id + "_" + job.EventId + ".txt";
  457: 		VPPXmlText.WriteAll(path, job.Body);
  458: 		Print("[WebHooksManager] Rejected body saved to " + path);
  459: 		if (!IsJson())
  460: 		{
  461: 			return;
  462: 		}
  463: 
  464: 		verdict = VPPJsonCheck.Check(job.Body);
  465: 		if (!verdict.Valid)
  466: 		{
  467: 			lineText = verdict.Line.ToString();
  468: 			colText = verdict.Col.ToString();
  469: 			verdictText = "[WebHooksManager] The body is NOT valid JSON at line " + lineText + ", column " + colText + ": " + verdict.Message;
  470: 			Print(verdictText);
  471: 			return;
  472: 		}
  473: 
  474: 		bool discordPreset = VPPWebhookPresets.UsesDiscordLimits(m_Hook.m_Preset);
  475: 		if (m_Hook.IsDiscordUrl() && !discordPreset)
  476: 		{
  477: 			string presetName = m_Hook.m_Preset;
  478: 			Print("[WebHooksManager] The URL is a Discord webhook but the preset is " + presetName + ": Discord only accepts the discord_embed / discord_simple formats");
  479: 			return;
  480: 		}
  481: 
  482: 		if (discordPreset)
  483: 		{
  484: 			VPPDiscordLint.Check(job.Body, problems);
  485: 		}
  486: 
  487: 		if (problems.Count() == 0)
  488: 		{
  489: 			Print("[WebHooksManager] The body is valid JSON within Discord limits: check the URL, or the service is rate limiting");
  490: 			return;
  491: 		}
  492: 
  493: 		foreach (string lintProblem : problems)
  494: 		{
  495: 			problem = "[WebHooksManager] Discord limit: " + lintProblem;
  496: 			Print(problem);
  497: 		}
  498: 	}
  499: 
  500: 	static string StateName(int state)
  501: 	{
  502: 		if (state == RESULT_HTTP_4XX)
  503: 		{
  504: 			return "HTTP_4XX (bad body, wrong or deleted URL, or rate limited)";
  505: 		}
  506: 
  507: 		if (state == RESULT_HTTP_5XX)
  508: 		{
  509: 			return "HTTP_5XX (the service had an error)";
  510: 		}
  511: 
  512: 		if (state == RESULT_NETWORK)
  513: 		{
  514: 			return "NETWORK_ERROR (connect, DNS, TLS, or a redirecting URL)";
  515: 		}
  516: 
  517: 		if (state == RESULT_NO_REPLY)
  518: 		{
  519: 			return "TIMEOUT (or an empty reply)";
  520: 		}
  521: 
  522: 		return "ERROR_" + state.ToString();
  523: 	}
  524: 
  525: 	static string TimeText()
  526: 	{
  527: 		int year;
  528: 		int month;
  529: 		int day;
  530: 		int hour;
  531: 		int minute;
  532: 		int second;
  533: 		GetYearMonthDayUTC(year, month, day);
  534: 		GetHourMinuteSecondUTC(hour, minute, second);
  535: 		string dateText = VPPWebhookClock.Pad(year, 4) + "-" + VPPWebhookClock.Pad(month, 2) + "-" + VPPWebhookClock.Pad(day, 2);
  536: 		return dateText + " " + VPPWebhookClock.Pad(hour, 2) + ":" + VPPWebhookClock.Pad(minute, 2) + ":" + VPPWebhookClock.Pad(second, 2) + " UTC";
  537: 	}
  538: };
  539: 
  540: // UTC time texts for the common template variables.
  541: class VPPWebhookClock
  542: {
  543: 	static string Pad(int value, int width)
  544: 	{
  545: 		string text = value.ToString();
  546: 		while (text.Length() < width)
  547: 		{
  548: 			text = "0" + text;
  549: 		}
  550: 
  551: 		return text;
  552: 	}
  553: 
  554: 	// Seconds since 1970-01-01 UTC (days-from-civil, no CF dependency).
  555: 	static int UnixTime(int year, int month, int day, int hour, int minute, int second)
  556: 	{
  557: 		int y = year;
  558: 		if (month <= 2)
  559: 		{
  560: 			y = y - 1;
  561: 		}
  562: 
  563: 		int era = y / 400;
  564: 		if (y < 0)
  565: 		{
  566: 			era = (y - 399) / 400;
  567: 		}
  568: 
  569: 		int yoe = y - era * 400;
  570: 		int shiftedMonth = month + 9;
  571: 		if (month > 2)
  572: 		{
  573: 			shiftedMonth = month - 3;
  574: 		}
  575: 
  576: 		int doy = (153 * shiftedMonth + 2) / 5 + day - 1;
  577: 		int doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
  578: 		int days = era * 146097 + doe - 719468;
  579: 		return days * 86400 + hour * 3600 + minute * 60 + second;
  580: 	}
  581: 
  582: 	static void Fill(map<string, string> vars)
  583: 	{
  584: 		int year;
  585: 		int month;
  586: 		int day;
  587: 		int hour;
  588: 		int minute;
  589: 		int second;
  590: 		GetYearMonthDayUTC(year, month, day);
  591: 		GetHourMinuteSecondUTC(hour, minute, second);
  592: 		string dateText = Pad(year, 4) + "-" + Pad(month, 2) + "-" + Pad(day, 2);
  593: 		string timeText = Pad(hour, 2) + ":" + Pad(minute, 2) + ":" + Pad(second, 2);
  594: 		int unix = UnixTime(year, month, day, hour, minute, second);
  595: 		vars.Set("time.date", dateText);
  596: 		vars.Set("time.time", timeText);
  597: 		vars.Set("time.iso", dateText + "T" + timeText + ".000Z");
  598: 		vars.Set("time.unix", unix.ToString());
  599: 	}
  600: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\VPPWebhookWire.c
==========================================================================================
    1: // Server -> admin client replies of the webhook editor RPCs (RPC_MenuWebHooks).
    2: 
    3: class VPPWebhookIssueWire : Managed
    4: {
    5: 	bool IsError;
    6: 	int Line;
    7: 	int Col;
    8: 	string Code;
    9: 	string Arg;
   10: 	string Message;
   11: };
   12: 
   13: // ValidateTemplate / SaveTemplate: template problems, the preview rendered with sample values and the JSON verdict.
   14: class VPPWebhookCheckReply : Managed
   15: {
   16: 	int ReqId;
   17: 	string HookId;
   18: 	string EventId;
   19: 	bool Saved;
   20: 	bool TemplateOk;
   21: 	ref array<ref VPPWebhookIssueWire> Issues;
   22: 	string Preview;
   23: 	bool JsonChecked;
   24: 	bool JsonValid;
   25: 	string JsonMessage;
   26: 	int JsonLine;
   27: 	int JsonCol;
   28: 	ref array<string> ServiceProblems;
   29: 
   30: 	void VPPWebhookCheckReply()
   31: 	{
   32: 		Issues = new array<ref VPPWebhookIssueWire>();
   33: 		ServiceProblems = new array<string>();
   34: 		Preview = "";
   35: 		JsonMessage = "";
   36: 	}
   37: };
   38: 
   39: // GetTemplate: the template text of one event of one webhook.
   40: class VPPWebhookTemplateReply : Managed
   41: {
   42: 	int ReqId;
   43: 	string HookId;
   44: 	string EventId;
   45: 	string Text;
   46: };
   47: 
   48: // TestSend: what the endpoint answered (DELIVERED, NO_REPLY or an error name).
   49: class VPPWebhookTestReply : Managed
   50: {
   51: 	int ReqId;
   52: 	string HookId;
   53: 	string EventId;
   54: 	bool Ok;
   55: 	string Reason;
   56: };
   57: 
   58: // SaveWebhook / DuplicateWebhook: the webhook id on success, else Error (a stable code the menu localizes:
   59: // NAME_SHORT, NAME_IN_USE, URL_MISSING, NOT_FOUND).
   60: class VPPWebhookSaveReply : Managed
   61: {
   62: 	int ReqId;
   63: 	bool Ok;
   64: 	string HookId;
   65: 	string Error;
   66: };
   67: 
   68: // GetWebhookStats: delivery numbers of one webhook since the server started.
   69: class VPPWebhookStatsWire : Managed
   70: {
   71: 	string HookId;
   72: 	int Queued;
   73: 	int Delivered;
   74: 	int NoReply;
   75: 	int Failed;
   76: 	int Dropped;
   77: 	int Waiting;
   78: 	int ConsecutiveFailures;
   79: 	string LastError;
   80: 	string LastErrorTime;
   81: 	string LastSuccessTime;
   82: };
   83: 
   84: // ReloadTemplates: per webhook, how many templates have problems (details are in the server log).
   85: class VPPWebhookReloadReply : Managed
   86: {
   87: 	int ReqId;
   88: 	ref array<string> HookIds;
   89: 	ref array<int> TemplateErrors;
   90: 
   91: 	void VPPWebhookReloadReply()
   92: 	{
   93: 		HookIds = new array<string>();
   94: 		TemplateErrors = new array<int>();
   95: 	}
   96: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\WebHook.c
==========================================================================================
    1: enum VPPWebHookServerStatsTime
    2: {
    3: 	ONE_MINUTE 		= 60,
    4: 	FIVE_MINUTES    = 300,
    5: 	TEN_MINUTES     = 600,
    6: 	FIFTEEN_MINUTES = 900,
    7: };
    8: 
    9: // Per event settings of a webhook: on/off and what gets through.
   10: class VPPWebhookEventCfg : Managed
   11: {
   12: 	bool Enabled;
   13: 	// kill / hit: only player vs player
   14: 	bool PvPOnly;
   15: 	// kill / hit: skip infected and animals
   16: 	bool SkipAI;
   17: 	// kill / hit: minimum distance in meters (0 = any)
   18: 	float MinDistance;
   19: 	// admin.action: only these modules (lower case, empty = all) / never these
   20: 	ref array<string> Modules;
   21: 	ref array<string> ExcludedModules;
   22: 
   23: 	void VPPWebhookEventCfg()
   24: 	{
   25: 		Modules = new array<string>();
   26: 		ExcludedModules = new array<string>();
   27: 	}
   28: };
   29: 
   30: /*
   31: 	One webhook. The legacy fields (the per-category switches and "simplified messages") are kept so old configs load
   32: 	and the current menu keeps working: on load a v0 config is migrated to events + a Discord preset with the same
   33: 	switches (Migrate). Templates live in files (Templates/<m_Id>/<event>.tpl), runtime state in VPPWebhookSender.
   34: */
   35: class WebHook : Managed
   36: {
   37: 	const static int VERSION = 2;
   38: 
   39: 	private string 			  m_Name;
   40: 	private string 			  m_URL;
   41: 	bool   					  m_deathKillLogs;
   42: 	bool   					  m_adminActivityLog;
   43: 	bool   					  m_admHitLog;
   44: 	bool   					  m_joinLeaveLog;
   45: 	bool   					  m_serverStatusLog;
   46: 	VPPWebHookServerStatsTime m_serverStatsInterval;
   47: 	bool 					  m_simplifiedMessages;
   48: 
   49: 	// v2
   50: 	int m_Version;
   51: 	// stable id (template folder name)
   52: 	string m_Id;
   53: 	bool m_Disabled;
   54: 	string m_Preset;
   55: 	string m_ContentType;
   56: 	// messages per minute (0 = the preset default)
   57: 	int m_RateLimit;
   58: 	bool m_HideIds;
   59: 	bool m_HideServerAddress;
   60: 	// "hook.<key>" template variables (Discord username / avatar, Telegram chat_id, role mentions, ...)
   61: 	ref map<string, string> m_Vars;
   62: 	ref map<string, ref VPPWebhookEventCfg> m_Events;
   63: 	// per event: hash of the preset template text the server wrote to disk. A file still matching it is untouched
   64: 	// and follows preset updates; a file an admin edited no longer matches and is never overwritten.
   65: 	ref map<string, int> m_PresetHashes;
   66: 
   67: 	void WebHook(string name, string url)
   68: 	{
   69: 		m_Name = name;
   70: 		m_URL  = url;
   71: 		m_Vars = new map<string, string>();
   72: 		m_Events = new map<string, ref VPPWebhookEventCfg>();
   73: 		m_PresetHashes = new map<string, int>();
   74: 	}
   75: 
   76: 	// ---------------------------------------------------------------- migration
   77: 
   78: 	// v0 (switches only) -> v2: an id, a Discord preset and one event config per event, enabled from the old switches.
   79: 	bool Migrate(int serial)
   80: 	{
   81: 		if (!m_Vars)
   82: 		{
   83: 			m_Vars = new map<string, string>();
   84: 		}
   85: 
   86: 		if (!m_Events)
   87: 		{
   88: 			m_Events = new map<string, ref VPPWebhookEventCfg>();
   89: 		}
   90: 
   91: 		if (!m_PresetHashes)
   92: 		{
   93: 			m_PresetHashes = new map<string, int>();
   94: 		}
   95: 
   96: 		bool changed = false;
   97: 		if (m_Id == "")
   98: 		{
   99: 			m_Id = NewId(serial);
  100: 			changed = true;
  101: 		}
  102: 
  103: 		if (m_Version < VERSION)
  104: 		{
  105: 			if (m_Preset == "")
  106: 			{
  107: 				m_Preset = VPPWebhookPresets.DISCORD_EMBED;
  108: 				if (m_simplifiedMessages)
  109: 				{
  110: 					m_Preset = VPPWebhookPresets.DISCORD_SIMPLE;
  111: 				}
  112: 			}
  113: 
  114: 			SyncEventsFromSwitches();
  115: 			m_Version = VERSION;
  116: 			changed = true;
  117: 		}
  118: 
  119: 		if (!VPPWebhookPresets.IsPreset(m_Preset))
  120: 		{
  121: 			m_Preset = VPPWebhookPresets.DISCORD_EMBED;
  122: 			changed = true;
  123: 		}
  124: 
  125: 		if (m_ContentType == "")
  126: 		{
  127: 			m_ContentType = VPPWebhookPresets.ContentTypeOf(m_Preset);
  128: 			changed = true;
  129: 		}
  130: 
  131: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  132: 		foreach (VPPWebhookEventDef def : eventDefs)
  133: 		{
  134: 			if (!m_Events.Contains(def.Id))
  135: 			{
  136: 				VPPWebhookEventCfg added = new VPPWebhookEventCfg();
  137: 				added.Enabled = SwitchOf(def.LegacyGroup);
  138: 				m_Events.Set(def.Id, added);
  139: 				changed = true;
  140: 			}
  141: 		}
  142: 
  143: 		if (m_serverStatsInterval <= 0)
  144: 		{
  145: 			m_serverStatsInterval = VPPWebHookServerStatsTime.FIVE_MINUTES;
  146: 			changed = true;
  147: 		}
  148: 
  149: 		return changed;
  150: 	}
  151: 
  152: 	static string NewId(int serial)
  153: 	{
  154: 		int year;
  155: 		int month;
  156: 		int day;
  157: 		int hour;
  158: 		int minute;
  159: 		int second;
  160: 		GetYearMonthDayUTC(year, month, day);
  161: 		GetHourMinuteSecondUTC(hour, minute, second);
  162: 		int stamp = ((day * 24 + hour) * 60 + minute) * 60 + second;
  163: 		int random = Math.RandomInt(1000, 9999);
  164: 		return "wh" + stamp.ToString() + serial.ToString() + random.ToString();
  165: 	}
  166: 
  167: 	// Makes the webhook safe to read: missing maps and lists are created, and a missing (null) event setting is
  168: 	// rebuilt from the legacy switch of its group (the server keeps those in step). Returns how many settings were
  169: 	// missing, so a caller can report data that arrived damaged.
  170: 	int RepairEvents()
  171: 	{
  172: 		int repaired = 0;
  173: 		if (!m_Vars)
  174: 		{
  175: 			m_Vars = new map<string, string>();
  176: 		}
  177: 
  178: 		if (!m_Events)
  179: 		{
  180: 			m_Events = new map<string, ref VPPWebhookEventCfg>();
  181: 		}
  182: 
  183: 		if (!m_PresetHashes)
  184: 		{
  185: 			m_PresetHashes = new map<string, int>();
  186: 		}
  187: 
  188: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  189: 		foreach (VPPWebhookEventDef def : eventDefs)
  190: 		{
  191: 			VPPWebhookEventCfg cfg = m_Events.Get(def.Id);
  192: 			if (!cfg)
  193: 			{
  194: 				cfg = new VPPWebhookEventCfg();
  195: 				cfg.Enabled = SwitchOf(def.LegacyGroup);
  196: 				m_Events.Set(def.Id, cfg);
  197: 				repaired++;
  198: 				continue;
  199: 			}
  200: 
  201: 			if (!cfg.Modules)
  202: 			{
  203: 				cfg.Modules = new array<string>();
  204: 			}
  205: 
  206: 			if (!cfg.ExcludedModules)
  207: 			{
  208: 				cfg.ExcludedModules = new array<string>();
  209: 			}
  210: 		}
  211: 
  212: 		return repaired;
  213: 	}
  214: 
  215: 	// The old per-category switches decide which events are on (old menu and old configs).
  216: 	void SyncEventsFromSwitches()
  217: 	{
  218: 		if (!m_Events)
  219: 		{
  220: 			m_Events = new map<string, ref VPPWebhookEventCfg>();
  221: 		}
  222: 
  223: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  224: 		foreach (VPPWebhookEventDef def : eventDefs)
  225: 		{
  226: 			VPPWebhookEventCfg cfg = m_Events.Get(def.Id);
  227: 			if (!cfg)
  228: 			{
  229: 				cfg = new VPPWebhookEventCfg();
  230: 				m_Events.Set(def.Id, cfg);
  231: 			}
  232: 
  233: 			cfg.Enabled = SwitchOf(def.LegacyGroup);
  234: 		}
  235: 	}
  236: 
  237: 	// The legacy per-category switches follow the event settings (a group is on when any of its events is).
  238: 	void SyncSwitchesFromEvents()
  239: 	{
  240: 		m_deathKillLogs = IsEventEnabled(VPPWebhookDefs.EV_KILL);
  241: 		m_adminActivityLog = IsEventEnabled(VPPWebhookDefs.EV_ADMIN);
  242: 		m_admHitLog = IsEventEnabled(VPPWebhookDefs.EV_HIT);
  243: 		m_joinLeaveLog = false;
  244: 		m_serverStatusLog = false;
  245: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  246: 		foreach (VPPWebhookEventDef def : eventDefs)
  247: 		{
  248: 			VPPWebhookEventCfg cfg = m_Events.Get(def.Id);
  249: 			if (!cfg || !cfg.Enabled)
  250: 			{
  251: 				continue;
  252: 			}
  253: 
  254: 			if (def.LegacyGroup == VPPWebhookDefs.GROUP_JOINLEAVE)
  255: 			{
  256: 				m_joinLeaveLog = true;
  257: 			}
  258: 
  259: 			if (def.LegacyGroup == VPPWebhookDefs.GROUP_STATUS)
  260: 			{
  261: 				m_serverStatusLog = true;
  262: 			}
  263: 		}
  264: 
  265: 		m_simplifiedMessages = m_Preset == VPPWebhookPresets.DISCORD_SIMPLE;
  266: 	}
  267: 
  268: 	protected bool SwitchOf(string legacyGroup)
  269: 	{
  270: 		if (legacyGroup == VPPWebhookDefs.GROUP_DEATH)
  271: 		{
  272: 			return m_deathKillLogs;
  273: 		}
  274: 
  275: 		if (legacyGroup == VPPWebhookDefs.GROUP_ADMIN)
  276: 		{
  277: 			return m_adminActivityLog;
  278: 		}
  279: 
  280: 		if (legacyGroup == VPPWebhookDefs.GROUP_HIT)
  281: 		{
  282: 			return m_admHitLog;
  283: 		}
  284: 
  285: 		if (legacyGroup == VPPWebhookDefs.GROUP_JOINLEAVE)
  286: 		{
  287: 			return m_joinLeaveLog;
  288: 		}
  289: 
  290: 		if (legacyGroup == VPPWebhookDefs.GROUP_STATUS)
  291: 		{
  292: 			return m_serverStatusLog;
  293: 		}
  294: 
  295: 		return false;
  296: 	}
  297: 
  298: 	// ---------------------------------------------------------------- client copy
  299: 
  300: 	// What an admin client gets: the URL masked unless showUrl (a webhook URL is a secret), no runtime state.
  301: 	WebHook CopyForClient(bool showUrl)
  302: 	{
  303: 		WebHook copy = new WebHook(m_Name, m_URL);
  304: 		if (!showUrl)
  305: 		{
  306: 			copy.SetURL(MaskUrl(m_URL));
  307: 		}
  308: 
  309: 		copy.m_deathKillLogs = m_deathKillLogs;
  310: 		copy.m_adminActivityLog = m_adminActivityLog;
  311: 		copy.m_admHitLog = m_admHitLog;
  312: 		copy.m_joinLeaveLog = m_joinLeaveLog;
  313: 		copy.m_serverStatusLog = m_serverStatusLog;
  314: 		copy.m_serverStatsInterval = m_serverStatsInterval;
  315: 		copy.m_simplifiedMessages = m_simplifiedMessages;
  316: 		copy.m_Version = m_Version;
  317: 		copy.m_Id = m_Id;
  318: 		copy.m_Disabled = m_Disabled;
  319: 		copy.m_Preset = m_Preset;
  320: 		copy.m_ContentType = m_ContentType;
  321: 		copy.m_RateLimit = m_RateLimit;
  322: 		copy.m_HideIds = m_HideIds;
  323: 		copy.m_HideServerAddress = m_HideServerAddress;
  324: 		if (m_Vars)
  325: 		{
  326: 			copy.m_Vars.Copy(m_Vars);
  327: 		}
  328: 
  329: 		RepairEvents();
  330: 		int total = m_Events.Count();
  331: 		for (int i = 0; i < total; i++)
  332: 		{
  333: 			string eventId = m_Events.GetKey(i);
  334: 			VPPWebhookEventCfg source = m_Events.GetElement(i);
  335: 			VPPWebhookEventCfg cloned = new VPPWebhookEventCfg();
  336: 			if (source)
  337: 			{
  338: 				cloned.Enabled = source.Enabled;
  339: 				cloned.PvPOnly = source.PvPOnly;
  340: 				cloned.SkipAI = source.SkipAI;
  341: 				cloned.MinDistance = source.MinDistance;
  342: 				if (source.Modules)
  343: 				{
  344: 					cloned.Modules.Copy(source.Modules);
  345: 				}
  346: 
  347: 				if (source.ExcludedModules)
  348: 				{
  349: 					cloned.ExcludedModules.Copy(source.ExcludedModules);
  350: 				}
  351: 			}
  352: 
  353: 			copy.m_Events.Set(eventId, cloned);
  354: 		}
  355: 
  356: 		return copy;
  357: 	}
  358: 
  359: 	// "https://discord.com/api/webhooks/â€¦Ab3F": scheme and host, then â€¦ and the last 4 characters.
  360: 	static string MaskUrl(string url)
  361: 	{
  362: 		if (url == "")
  363: 		{
  364: 			return "";
  365: 		}
  366: 
  367: 		int schemeEnd = url.IndexOf("://");
  368: 		int hostEnd = -1;
  369: 		if (schemeEnd >= 0)
  370: 		{
  371: 			hostEnd = url.IndexOfFrom(schemeEnd + 3, "/");
  372: 		}
  373: 
  374: 		string head = url;
  375: 		if (hostEnd > 0)
  376: 		{
  377: 			head = url.Substring(0, hostEnd + 1);
  378: 		}
  379: 
  380: 		int total = url.Length();
  381: 		string tail = "";
  382: 		if (total > 4)
  383: 		{
  384: 			tail = url.Substring(total - 4, 4);
  385: 		}
  386: 
  387: 		return head + MASK_MARK + tail;
  388: 	}
  389: 
  390: 	const static string MASK_MARK = "â€¦";
  391: 
  392: 	static bool IsMasked(string url)
  393: 	{
  394: 		return url.Contains(MASK_MARK);
  395: 	}
  396: 
  397: 	// ---------------------------------------------------------------- accessors
  398: 
  399: 	void SetURL(string url)
  400: 	{
  401: 		m_URL = url;
  402: 	}
  403: 
  404: 	void SetServerStatsInterval(VPPWebHookServerStatsTime interval)
  405: 	{
  406: 		m_serverStatsInterval = interval;
  407: 	}
  408: 
  409: 	void SetName(string name)
  410: 	{
  411: 		m_Name = name;
  412: 	}
  413: 
  414: 	string GetName()
  415: 	{
  416: 		return m_Name;
  417: 	}
  418: 
  419: 	string GetURL()
  420: 	{
  421: 		return m_URL;
  422: 	}
  423: 
  424: 	bool SendDeathKillLogs()
  425: 	{
  426: 		return m_deathKillLogs;
  427: 	}
  428: 
  429: 	bool SendAdminActivityLogs()
  430: 	{
  431: 		return m_adminActivityLog;
  432: 	}
  433: 
  434: 	bool SendHitLogs()
  435: 	{
  436: 		return m_admHitLog;
  437: 	}
  438: 
  439: 	bool SendJoinLeaveLogs()
  440: 	{
  441: 		return m_joinLeaveLog;
  442: 	}
  443: 
  444: 	bool ReportServerStatus()
  445: 	{
  446: 		return m_serverStatusLog;
  447: 	}
  448: 
  449: 	VPPWebHookServerStatsTime GetServerStatsInterval()
  450: 	{
  451: 		return m_serverStatsInterval;
  452: 	}
  453: 
  454: 	bool SimplifyMessages()
  455: 	{
  456: 		return m_simplifiedMessages;
  457: 	}
  458: 
  459: 	bool IsEventEnabled(string eventId)
  460: 	{
  461: 		if (m_Disabled || !m_Events)
  462: 		{
  463: 			return false;
  464: 		}
  465: 
  466: 		VPPWebhookEventCfg cfg = m_Events.Get(eventId);
  467: 		return cfg && cfg.Enabled;
  468: 	}
  469: 
  470: 	VPPWebhookEventCfg GetEventCfg(string eventId)
  471: 	{
  472: 		if (!m_Events)
  473: 		{
  474: 			return null;
  475: 		}
  476: 
  477: 		return m_Events.Get(eventId);
  478: 	}
  479: 
  480: 	// Messages per minute this webhook may send (Discord allows about 30 per webhook).
  481: 	int GetRateLimit()
  482: 	{
  483: 		if (m_RateLimit > 0)
  484: 		{
  485: 			return m_RateLimit;
  486: 		}
  487: 
  488: 		// Discord allows about 30 per minute per webhook, Lolka 30 (then 429)
  489: 		if (VPPWebhookPresets.UsesDiscordLimits(m_Preset))
  490: 		{
  491: 			return 25;
  492: 		}
  493: 
  494: 		return 60;
  495: 	}
  496: 
  497: 	// The URL requests go to: Discord gets ?wait=true so a delivered message answers with a body (the engine reports a
  498: 	// bodyless 204 as a timeout, memory dayz-restapi-json-internals).
  499: 	bool IsDiscordUrl()
  500: 	{
  501: 		string lower = m_URL;
  502: 		lower.ToLower();
  503: 		return lower.Contains("discord.com/api/webhooks") || lower.Contains("discordapp.com/api/webhooks");
  504: 	}
  505: 
  506: 	bool IsLolkaUrl()
  507: 	{
  508: 		string lower = m_URL;
  509: 		lower.ToLower();
  510: 		return lower.Contains("lolka.app/api/webhooks");
  511: 	}
  512: 
  513: 	string GetSendUrl()
  514: 	{
  515: 		string url = m_URL;
  516: 		string lower = url;
  517: 		lower.ToLower();
  518: 		// Lolka answers 200 + the message by default too; wait=true makes it explicit
  519: 		bool discord = IsDiscordUrl() || IsLolkaUrl();
  520: 		if (!discord || lower.Contains("wait="))
  521: 		{
  522: 			return url;
  523: 		}
  524: 
  525: 		if (url.Contains("?"))
  526: 		{
  527: 			return url + "&wait=true";
  528: 		}
  529: 
  530: 		return url + "?wait=true";
  531: 	}
  532: 
  533: 	bool ExpectsReply()
  534: 	{
  535: 		string sendUrl = GetSendUrl();
  536: 		return sendUrl.Contains("wait=true");
  537: 	}
  538: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\WebHookMessageBase.c
==========================================================================================
    1: class WebHookMessageBase
    2: {
    3: 	protected ref array<ref WbEmbed> embeds;
    4: 	ref JsonSerializer serializer;
    5: 	string content;
    6: 	// structured values the producer adds for templates (weapon, distance, positions, ...)
    7: 	[NonSerialized()]
    8: 	ref map<string, string> m_Extra;
    9: 
   10: 	void WebHookMessageBase()
   11: 	{
   12: 		embeds = new array<ref WbEmbed>;
   13: 		serializer = new JsonSerializer;
   14: 	}
   15: 
   16: 	void ~WebHookMessageBase()
   17: 	{
   18: 		if (serializer)
   19: 			delete serializer;
   20: 	}
   21: 
   22: 	WbEmbed AddEmbed()
   23: 	{
   24: 		return null;
   25: 	}
   26: 
   27: 	void SetContent(string str = string.Empty)
   28: 	{
   29: 		content = str;
   30: 	}
   31: 
   32: 	string GetContent()
   33: 	{
   34: 		return content;
   35: 	}
   36: 
   37: 	// The event this message becomes for templated webhooks (null = this message type has no event).
   38: 	VPPWebhookEvent ToEvent()
   39: 	{
   40: 		return null;
   41: 	}
   42: 
   43: 	void SetVar(string name, string value)
   44: 	{
   45: 		if (!m_Extra)
   46: 		{
   47: 			m_Extra = new map<string, string>();
   48: 		}
   49: 
   50: 		m_Extra.Set(name, value);
   51: 	}
   52: 
   53: 	string GetVar(string name)
   54: 	{
   55: 		string value = "";
   56: 		if (m_Extra && m_Extra.Contains(name))
   57: 		{
   58: 			value = m_Extra.Get(name);
   59: 		}
   60: 
   61: 		return value;
   62: 	}
   63: 
   64: 	protected void AddExtras(VPPWebhookEvent webhookEvent)
   65: 	{
   66: 		if (!m_Extra)
   67: 		{
   68: 			return;
   69: 		}
   70: 
   71: 		for (int i = 0; i < m_Extra.Count(); i++)
   72: 		{
   73: 			string extraName = m_Extra.GetKey(i);
   74: 			string extraValue = m_Extra.GetElement(i);
   75: 			webhookEvent.Set(extraName, extraValue);
   76: 		}
   77: 	}
   78: 
   79: 	string BuildMessage(bool simplified = false)
   80: 	{
   81: 		string result = "";
   82: 		serializer.WriteToString(embeds, true, result);
   83: 		if (!simplified)
   84: 			return "{" + "\"embeds\": " + result + "}";
   85: 
   86: 		return "{ \"content\": \""+ GetContent() + "\", \"embeds\": null, \"username\": \"VPPAdminTools\", \"avatar_url\": \"https://i.imgur.com/oSEhCJV.png\", \"attachments\": [] }";
   87: 	}
   88: };
   89: 
   90: class WbEmbed
   91: {
   92: 	string title;
   93: 	int color;
   94: 	ref WbAuthor author;
   95: 	ref array<ref WbField> fields;
   96: 	string timestamp;
   97: 	
   98: 	void WbEmbed(string ltitle = "WebHook Title", int lcolor = 25500, string authorName = "", string authorURL = "", string authorImg = "")
   99: 	{
  100: 		fields = new array<ref WbField>;
  101: 		this.title = ltitle;
  102: 		this.color = lcolor;
  103: 		author = new WbAuthor();
  104: 		author.SetName(authorName);
  105: 		author.SetURL(authorURL);
  106: 		author.SetIconURL(authorImg);
  107: 
  108: 		int year, month, day, hour, minute, second;
  109: 		GetHourMinuteSecondUTC(hour, minute, second);
  110: 		GetYearMonthDayUTC(year, month, day);
  111: 
  112: 		string strHour = hour.ToString(), strMin = minute.ToString();
  113: 		if (hour.ToString().Length() == 1)
  114: 			strHour = string.Format("%2%1", hour, 0);
  115: 
  116: 		if (minute.ToString().Length() == 1)
  117: 			strMin = string.Format("%2%1", minute, 0);
  118: 
  119: 		timestamp = string.Format( "%3-%2-%1T%4:%5:00.000Z", day, month, year, strHour, strMin);
  120: 	}
  121: 
  122: 	WbField AddField()
  123: 	{
  124: 		ref WbField field = new WbField();
  125: 		fields.Insert( field );
  126: 		return field;
  127: 	}
  128: };
  129: 
  130: class WbField
  131: {
  132: 	string name  = "field";
  133: 	string value = "content";
  134: 	bool inline  = false;
  135: 
  136: 	void SetName(string n)
  137: 	{
  138: 		if (n == "") return;
  139: 		name = n;
  140: 	}
  141: 
  142: 	void SetValue(string v)
  143: 	{
  144: 		if (v == "") return;
  145: 		value = v;
  146: 	}
  147: 
  148: 	void Inline(bool state)
  149: 	{
  150: 		inline = state;
  151: 	}
  152: };
  153: 
  154: class WbAuthor
  155: {
  156: 	string name     = "VPPAdminTools";
  157: 	string url      = "https://steamcommunity.com/sharedfiles/filedetails/?id=1828439124";
  158: 	string icon_url = "https://i.imgur.com/oSEhCJV.png";
  159: 	
  160: 	void SetName(string n)
  161: 	{
  162: 		if (n == "") return;
  163: 		name = n;
  164: 	}
  165: 
  166: 	void SetURL(string u)
  167: 	{
  168: 		if (u == "") return;
  169: 		url = u;
  170: 	}
  171: 
  172: 	void SetIconURL(string iconurl)
  173: 	{
  174: 		if (iconurl == "") return;
  175: 		icon_url = iconurl;
  176: 	}
  177: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\Classes\MessageTypes\ServerStatusMessage.c
==========================================================================================
    1: class ServerStatusMessage: WebHookMessageBase
    2: {
    3: 	bool m_BoottUp;
    4: 
    5: 	void ServerStatusMessage(bool bootUp = false)
    6: 	{
    7: 		m_BoottUp = bootUp;
    8: 		AddEmbed();
    9: 		SetContent();
   10: 	}
   11: 
   12: 	int RGB(int r, int g, int b)
   13: 	{
   14: 		r = r << 16;
   15: 		g = g << 8;
   16: 		return r | g | b;
   17: 	}
   18: 
   19: 	int ConvertTime(int ms, int div, bool floor = true)
   20: 	{
   21: 		if (floor){
   22: 		return Math.Floor((ms / div));
   23: 		}
   24: 		return (ms / div);
   25: 	}
   26: 
   27: 	/*
   28: 	* We use this for simplified versions of the webhook messages (without embeds)
   29: 	*/
   30: 	override void SetContent(string str = string.Empty)
   31: 	{
   32: 		int queryPort = GetGame().ServerConfigGetInt("steamQueryPort");
   33: 		if (m_BoottUp)
   34: 		{
   35: 			content = string.Format("Server [**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>) successfully started, player connect enabled.", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
   36: 		}
   37: 		else
   38: 		{
   39: 			content = string.Format("**Server Status:** [%1](<http://dayzsalauncher.com/#/servercheck/%3:%2>) ", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
   40: 			content += string.Format("Up-Time: **%1** ", FormatUpTime());
   41: 			content += string.Format("Server FPS: **%1** ", g_Game.GetServerFPS());
   42: 			content += string.Format("Players: **%1**", GetSteamAPIManager().GetTotalPlayerCount());
   43: 		}
   44: 	}
   45: 
   46: 	override VPPWebhookEvent ToEvent()
   47: 	{
   48: 		if (m_BoottUp)
   49: 		{
   50: 			return new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
   51: 		}
   52: 
   53: 		VPPWebhookEvent webhookEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_STATUS);
   54: 		int fps = g_Game.GetServerFPS();
   55: 		webhookEvent.Set("server.fps", fps.ToString());
   56: 		string upTime = FormatUpTime();
   57: 		webhookEvent.Set("uptime", upTime);
   58: 		int upSeconds = ConvertTime(GetGame().GetTime(), 1000);
   59: 		webhookEvent.Set("uptime.seconds", upSeconds.ToString());
   60: 		AddExtras(webhookEvent);
   61: 		return webhookEvent;
   62: 	}
   63: 
   64: 	string FormatUpTime()
   65: 	{
   66: 		int secs = ConvertTime(GetGame().GetTime(), 1000);
   67: 	   	int days = secs / (24 * 3600);
   68:         	secs = secs % (24 * 3600);
   69: 
   70:        	int hours = secs / 3600;
   71:         	secs = secs % 3600;
   72: 
   73:         int minutes = secs / 60;
   74:         	secs = secs % 60;
   75: 		
   76: 		return string.Format("%1d %2h %3m %4s", days, hours, minutes, secs);
   77: 	}
   78: 
   79: 	override WbEmbed AddEmbed()
   80: 	{
   81: 		WbEmbed embed;
   82: 		WbField field;
   83: 		int queryPort = GetGame().ServerConfigGetInt("steamQueryPort");
   84: 
   85: 		if ( m_BoottUp )
   86: 		{
   87: 			embed = new WbEmbed("**SERVER BOOT-UP REPORT**", RGB(0, 255, 0), "", "", "");
   88: 			field;
   89: 			//---
   90: 			field = embed.AddField();
   91: 			field.SetName("Server Online!");
   92: 			field.SetValue(string.Format("Server [**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>) has **booted-up** successfully!", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP()));
   93: 			field.Inline(true);
   94: 
   95: 			embeds.Insert( embed );
   96: 			return embed;
   97: 		}
   98: 		else
   99: 		{
  100: 			embed = new WbEmbed(string.Format("**SERVER STATUS REPORT:**\n**%1**", g_Game.GetServerName()), 16766720, "", "", "");
  101: 			field;
  102: 			//---
  103: 			field = embed.AddField();
  104: 			field.SetName("Server Status:");
  105: 
  106: 	        string final;
  107: 	        final 			 += string.Format("[**%1**](<http://dayzsalauncher.com/#/servercheck/%3:%2>)", g_Game.GetServerName(), queryPort.ToString(), g_Game.VGetServerIP());
  108: 			final 			 += string.Format("\nUp-Time: %1", FormatUpTime());
  109: 			final 			 += string.Format("\nServer FPS: %1", g_Game.GetServerFPS());
  110: 
  111: 			final 			 += string.Format("\nPlayers: %1", GetSteamAPIManager().GetTotalPlayerCount());
  112: 
  113: 			field.SetValue(final);
  114: 			field.Inline(false);
  115: 			embeds.Insert( embed );
  116: 			return embed;
  117: 		}
  118: 		return NULL;
  119: 	}
  120: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\SteamAPIManager\SteamAPIManager.c
==========================================================================================
    1: class SteamAPIManager: ConfigurablePlugin
    2: {
    3: 	private string STEAM_API_KEY;
    4: 	private float  QUERY_INTERVAL_SEC = 60.0; //seconds
    5: 	private string QUERY_PORT;
    6: 	private string SERVER_IP;
    7: 
    8: 	[NonSerialized()]
    9: 	private ref Timer m_QueryTimer;
   10: 	[NonSerialized()]
   11: 	private string m_QueryPort;
   12: 	[NonSerialized()]
   13: 	ref VPPATSteamGameServer m_ServerDataCache;
   14: 
   15: 	void SteamAPIManager()
   16: 	{
   17: 		JSONPATH = "$profile:VPPAdminTools/ConfigurablePlugins/SteamAPI.json";
   18: 	}
   19: 
   20: 	override void OnInit()
   21: 	{
   22: 		if (!FileExist(JSONPATH))
   23: 		{
   24: 			GetSimpleLogger().Log("[SteamAPIManager] configuration file missing...creating default.");
   25: 			Save();
   26: 			return;
   27: 		}
   28: 
   29: 		//load settings
   30: 		JsonFileLoader<SteamAPIManager>.JsonLoadFile(JSONPATH, this);
   31: 		g_Game.VSetServerIP(SERVER_IP);
   32: 
   33: 		//Query port
   34: 		if (!QUERY_PORT || QUERY_PORT == string.Empty)
   35: 		{
   36: 			QUERY_PORT = GetGame().ServerConfigGetInt("steamQueryPort").ToString();
   37: 			if (!QUERY_PORT || QUERY_PORT == string.Empty)
   38: 			{
   39: 				GetSimpleLogger().Log("[SteamAPIManager] ERROR couldn't fetch server query port from configs...");
   40: 			}
   41: 		}
   42: 
   43: 		//Fetch current server's IP, either from config, launch params or last resort via cURL
   44: 		if (SERVER_IP == string.Empty)
   45: 		{
   46: 			bool foundIp = GetCLIParam("ip", SERVER_IP);
   47: 	        if (!foundIp || SERVER_IP == string.Empty)
   48: 	        {
   49: 	        	//Resort to using cURL to get server's IP
   50: 	        	GetSimpleLogger().Log("[SteamAPIManager] WARNING couldn't fetch server IP from configs; using cURL...");
   51: 	        	VPPAT_IPIFY cb = new VPPAT_IPIFY();
   52: 				GetRestApi().GetRestContext("http://api.ipify.org/").GET(cb, "");
   53: 	        }
   54: 	        else
   55: 	        {
   56: 	        	g_Game.VSetServerIP(SERVER_IP);
   57: 	        }
   58: 		}
   59: 
   60: 		if (STEAM_API_KEY != string.Empty && STEAM_API_KEY.Length() == 32)
   61: 		{
   62: 			//start timed task to query Steam
   63: 			m_QueryTimer = new Timer();
   64: 			if (QUERY_INTERVAL_SEC < 30.0)
   65: 			{
   66: 				GetSimpleLogger().Log("[SteamAPIManager] WARNING QUERY_INTERVAL_SEC is too short, minimum 30 seconds! Interval set to 30 seconds.");
   67: 				QUERY_INTERVAL_SEC = 30.0;
   68: 			}
   69: 			QueryServerData();
   70: 			m_QueryTimer.Run(QUERY_INTERVAL_SEC, this, "QueryServerData", NULL, true);
   71: 			GetSimpleLogger().Log("[SteamAPIManager] loaded configuration...query timer active! @ interval: " + QUERY_INTERVAL_SEC);
   72: 		}
   73: 		else
   74: 		{
   75: 			GetSimpleLogger().Log("[SteamAPIManager] ERROR No steam API key configured, and or key is invalid.");
   76: 		}
   77: 	}
   78: 
   79: 	override void Save()
   80: 	{
   81: 		JsonFileLoader<SteamAPIManager>.JsonSaveFile(JSONPATH, this);
   82: 	}
   83: 
   84: 	/*
   85: 	* Called by the timer setup with the interval of your choice, and or manually if you wish.
   86: 	* updates cached data about current server (players, pop, queue etc)
   87: 	*/
   88: 	void QueryServerData()
   89: 	{
   90: 		if (!g_Game.VGetServerIP() || g_Game.VGetServerIP() == string.Empty)
   91: 		{
   92: 			GetSimpleLogger().Log("[SteamAPIManager] ERROR Failed to query Steam for server data, invalid server IP: " + g_Game.VGetServerIP());
   93: 			return;
   94: 		}
   95: 
   96: 		VPPATSteamAPICB steamCb = new VPPATSteamAPICB();
   97: 		string req = string.Format("?key=%1&filter=\\addr\\%2&limit=10", GetSteamAPIKey(), g_Game.VGetServerIP());
   98: 		GetRestApi().GetRestContext("https://api.steampowered.com/IGameServersService/GetServerList/v1/").GET(steamCb, req);
   99: 	}
  100: 
  101: 	/*
  102: 	* Don't call this manually unless you wan't to reload the same data into Cache
  103: 	* Called by VPPATSteamAPICB after query was return with data successfully from Steam.
  104: 	*/
  105: 	void HandleSteamQueryCb()
  106: 	{
  107: 		VPPATSteamAPIResponse dta;
  108: 		JsonFileLoader<ref VPPATSteamAPIResponse>.JsonLoadFile(string.Format("$profile:GameServer_%1.json", g_Game.VGetServerIP()), dta);
  109: 		if (dta == NULL)
  110: 			return;
  111: 
  112: 		array<ref VPPATSteamGameServer> servers = dta.response.servers;
  113: 		foreach(VPPATSteamGameServer server: servers)
  114: 		{
  115: 			if (server && server.addr == (string.Format("%1:%2", g_Game.VGetServerIP(), QUERY_PORT)))
  116: 			{
  117: 				m_ServerDataCache = server;
  118: 				g_Game.SetServerName(server.name);
  119: 				break;
  120: 			}
  121: 		}
  122: 	}
  123: 
  124: 	string GetSteamAPIKey()
  125: 	{
  126: 		return STEAM_API_KEY;
  127: 	}
  128: 
  129: 	string GetTotalPlayerCount()
  130: 	{
  131: 		array<Man> players = {};
  132: 		GetGame().GetWorld().GetPlayerList(players);
  133: 
  134: 		string count  	= players.Count().ToString();
  135: 		string maxCount = GetGame().ServerConfigGetInt("maxPlayers").ToString();
  136: 		string result   = string.Format("%1/%2", count, maxCount);
  137: 		if (m_ServerDataCache && m_ServerDataCache.GetQueuedPlayers() > 0)
  138: 		{
  139: 			result += string.Format(" (+%1)", m_ServerDataCache.GetQueuedPlayers());
  140: 		}
  141: 		return result;
  142: 	}
  143: };
  144: 
  145: SteamAPIManager GetSteamAPIManager()
  146: {
  147: 	return SteamAPIManager.Cast(GetPluginManager().GetPluginByType(SteamAPIManager));
  148: };

==========================================================================================
ARQUIVO: 4_World\VPPAdminTools\Plugins\PluginBase\WebHooksManager\WebHooksManager.c
==========================================================================================
    1: /*
    2: 	Webhooks: events (VPPWebhookDefs) rendered through per-webhook templates and sent through the engine's RestApi.
    3: 
    4: 	- Producers call PostData(<MessageType>, message) as before (the message becomes an event through ToEvent) or
    5: 	  Emit(VPPWebhookEvent) directly (other mods can emit their own event ids).
    6: 	- Each webhook has a template per event in $profile:.../WebHooksManager/Templates/<id>/<event>.tpl, created from
    7: 	  its preset when missing, so server owners can also edit them in a text editor (ReloadTemplates picks changes up).
    8: 	- Delivery: VPPWebhookSender (rate limit, retries, stats), pumped here once a second.
    9: 	- Old configs (v0: per-category switches + "simplified") are migrated to events + the Discord preset with the same
   10: 	  switches, so nothing changes until an admin edits a template.
   11: */
   12: class WebHooksManager: ConfigurablePlugin
   13: {
   14: 	const static string ROOT_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager";
   15: 	const static string TEMPLATE_DIR = "$profile:VPPAdminTools/ConfigurablePlugins/WebHooksManager/Templates";
   16: 	const static string TEMPLATE_EXT = ".tpl";
   17: 
   18: 	private ref array<ref WebHook> 		 M_DATA;
   19: 
   20: 	[NonSerialized()]
   21: 	protected ref map<string, ref VPPWebhookSender> m_Senders;
   22: 	// senders of deleted / replaced webhooks: kept until the engine answered their requests
   23: 	[NonSerialized()]
   24: 	protected ref array<ref VPPWebhookSender> m_Retired;
   25: 	// next server status time (GetGame().GetTime()) per webhook id
   26: 	[NonSerialized()]
   27: 	protected ref map<string, int> m_StatusDue;
   28: 	[NonSerialized()]
   29: 	protected bool m_Ticking;
   30: 	[NonSerialized()]
   31: 	protected int m_IdSerial;
   32: 	// a preset template hash changed (WebHooks.json needs saving)
   33: 	[NonSerialized()]
   34: 	protected bool m_TemplatesDirty;
   35: 
   36: 	void WebHooksManager()
   37: 	{
   38: 		M_DATA = new array<ref WebHook>;
   39: 		m_Senders = new map<string, ref VPPWebhookSender>();
   40: 		m_Retired = new array<ref VPPWebhookSender>();
   41: 		m_StatusDue = new map<string, int>();
   42: 
   43: 		if (!FileExist(ROOT_DIR))
   44: 			MakeDirectory(ROOT_DIR);
   45: 
   46: 		JSONPATH = ROOT_DIR + "/WebHooks.json";
   47: 
   48: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebHooks", this, SingleplayerExecutionType.Server);
   49: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebHooks", this, SingleplayerExecutionType.Server);
   50: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "CreateWebHooks", this, SingleplayerExecutionType.Server);
   51: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "EditWebHooks", this, SingleplayerExecutionType.Server);
   52: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetTemplate", this, SingleplayerExecutionType.Server);
   53: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "ValidateTemplate", this, SingleplayerExecutionType.Server);
   54: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveTemplate", this, SingleplayerExecutionType.Server);
   55: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "TestSend", this, SingleplayerExecutionType.Server);
   56: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "ReloadTemplates", this, SingleplayerExecutionType.Server);
   57: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "SaveWebhook", this, SingleplayerExecutionType.Server);
   58: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "DeleteWebhookById", this, SingleplayerExecutionType.Server);
   59: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "DuplicateWebhook", this, SingleplayerExecutionType.Server);
   60: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "ResetTemplate", this, SingleplayerExecutionType.Server);
   61: 		GetRPCManager().AddRPC("RPC_WebHooksManager", "GetWebhookStats", this, SingleplayerExecutionType.Server);
   62: 	}
   63: 
   64: 	void ~WebHooksManager()
   65: 	{
   66: 		if (GetGame())
   67: 		{
   68: 			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).Remove(this.Tick);
   69: 		}
   70: 	}
   71: 
   72: 	override void OnInit()
   73: 	{
   74: 		Load();
   75: 		if (!GetGame().IsServer())
   76: 		{
   77: 			return;
   78: 		}
   79: 
   80: 		bool migrated = false;
   81: 		foreach (WebHook hook : M_DATA)
   82: 		{
   83: 			if (hook && hook.Migrate(NextSerial()))
   84: 			{
   85: 				migrated = true;
   86: 			}
   87: 		}
   88: 
   89: 		if (migrated)
   90: 		{
   91: 			Save();
   92: 			Print("[WebHooksManager] Webhooks migrated to templated events (v" + WebHook.VERSION.ToString() + ")");
   93: 		}
   94: 
   95: 		WriteReadme();
   96: 		foreach (WebHook loaded : M_DATA)
   97: 		{
   98: 			if (loaded)
   99: 			{
  100: 				StartSender(loaded);
  101: 			}
  102: 		}
  103: 
  104: 		SaveIfTemplatesChanged();
  105: 
  106: 		if (!m_Ticking)
  107: 		{
  108: 			m_Ticking = true;
  109: 			GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(this.Tick, 1000, true);
  110: 		}
  111: 	}
  112: 
  113: 	override void Load()
  114: 	{
  115: 		if (FileExist( JSONPATH ))
  116: 		{
  117: 			JsonFileLoader<WebHooksManager>.JsonLoadFile(JSONPATH, this);
  118: 			Print("[WebHooksManager] Loading Saved Webhooks configuration");
  119: 		}
  120: 
  121: 		if (!M_DATA)
  122: 		{
  123: 			M_DATA = new array<ref WebHook>;
  124: 		}
  125: 	}
  126: 
  127: 	override void Save()
  128: 	{
  129: 		JsonFileLoader<WebHooksManager>.JsonSaveFile(JSONPATH, this);
  130: 	}
  131: 
  132: 	protected int NextSerial()
  133: 	{
  134: 		m_IdSerial++;
  135: 		return m_IdSerial;
  136: 	}
  137: 
  138: 	// ---------------------------------------------------------------- events
  139: 
  140: 	/*
  141: 		Called from many other instances such as admin logs and vppat plugins
  142: 	*/
  143: 	void PostData(typename messageType, WebHookMessageBase dataClass)
  144: 	{
  145: 		if (!dataClass)
  146: 		{
  147: 			return;
  148: 		}
  149: 
  150: 		VPPWebhookEvent webhookEvent = dataClass.ToEvent();
  151: 		if (webhookEvent)
  152: 		{
  153: 			Emit(webhookEvent);
  154: 		}
  155: 	}
  156: 
  157: 	void PostServerBootup()
  158: 	{
  159: 		VPPWebhookEvent bootEvent = new VPPWebhookEvent(VPPWebhookDefs.EV_BOOT);
  160: 		Emit(bootEvent);
  161: 	}
  162: 
  163: 	// Sends an event to every webhook that has it enabled and whose filters let it through.
  164: 	void Emit(VPPWebhookEvent webhookEvent)
  165: 	{
  166: 		if (!webhookEvent || !CanSend() || !M_DATA || M_DATA.Count() == 0)
  167: 		{
  168: 			return;
  169: 		}
  170: 
  171: 		FillCommonVars(webhookEvent);
  172: 		foreach (WebHook hook : M_DATA)
  173: 		{
  174: 			if (!hook || !hook.IsEventEnabled(webhookEvent.Id))
  175: 			{
  176: 				continue;
  177: 			}
  178: 
  179: 			VPPWebhookEventCfg cfg = hook.GetEventCfg(webhookEvent.Id);
  180: 			if (!Passes(cfg, webhookEvent))
  181: 			{
  182: 				continue;
  183: 			}
  184: 
  185: 			SendTo(hook, webhookEvent, "", 0);
  186: 		}
  187: 	}
  188: 
  189: 	// false when the webhook has no sender or no usable template for the event (nothing is sent)
  190: 	protected bool SendTo(WebHook hook, VPPWebhookEvent webhookEvent, string testBy, int testReqId)
  191: 	{
  192: 		VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
  193: 		if (!sender)
  194: 		{
  195: 			return false;
  196: 		}
  197: 
  198: 		string body = sender.Render(webhookEvent);
  199: 		if (body == "")
  200: 		{
  201: 			return false;
  202: 		}
  203: 
  204: 		sender.Enqueue(webhookEvent.Id, body, testBy, testReqId);
  205: 		return true;
  206: 	}
  207: 
  208: 	protected bool CanSend()
  209: 	{
  210: 		return GetGame().IsServer() && GetGame().IsDedicatedServer();
  211: 	}
  212: 
  213: 	// server / players / time variables every event has (a producer's own values win)
  214: 	protected void FillCommonVars(VPPWebhookEvent webhookEvent)
  215: 	{
  216: 		map<string, string> common = new map<string, string>();
  217: 		common.Set("event", webhookEvent.Id);
  218: 		string serverName = g_Game.GetServerName();
  219: 		common.Set("server.name", serverName);
  220: 		string serverIp = g_Game.VGetServerIP();
  221: 		common.Set("server.ip", serverIp);
  222: 		int queryPort = GetGame().ServerConfigGetInt("steamQueryPort");
  223: 		common.Set("server.port", queryPort.ToString());
  224: 		string worldName = "";
  225: 		GetGame().GetWorldName(worldName);
  226: 		worldName.ToLower();
  227: 		common.Set("server.map", worldName);
  228: 		string playerCount = "0";
  229: 		if (GetSteamAPIManager())
  230: 		{
  231: 			playerCount = GetSteamAPIManager().GetTotalPlayerCount();
  232: 		}
  233: 
  234: 		common.Set("players", playerCount);
  235: 		VPPWebhookClock.Fill(common);
  236: 		for (int i = 0; i < common.Count(); i++)
  237: 		{
  238: 			string commonName = common.GetKey(i);
  239: 			if (!webhookEvent.Vars.Contains(commonName))
  240: 			{
  241: 				string commonValue = common.GetElement(i);
  242: 				webhookEvent.Set(commonName, commonValue);
  243: 			}
  244: 		}
  245: 	}
  246: 
  247: 	// The per event filters of a webhook.
  248: 	protected bool Passes(VPPWebhookEventCfg cfg, VPPWebhookEvent webhookEvent)
  249: 	{
  250: 		if (!cfg)
  251: 		{
  252: 			return true;
  253: 		}
  254: 
  255: 		string eventId = webhookEvent.Id;
  256: 		if (eventId == VPPWebhookDefs.EV_KILL || eventId == VPPWebhookDefs.EV_HIT)
  257: 		{
  258: 			string kind = webhookEvent.Get("cause");
  259: 			if (eventId == VPPWebhookDefs.EV_HIT)
  260: 			{
  261: 				kind = webhookEvent.Get("source.kind");
  262: 			}
  263: 
  264: 			if (cfg.PvPOnly && kind != "player")
  265: 			{
  266: 				return false;
  267: 			}
  268: 
  269: 			if (cfg.SkipAI && (kind == "infected" || kind == "animal"))
  270: 			{
  271: 				return false;
  272: 			}
  273: 
  274: 			if (cfg.MinDistance > 0)
  275: 			{
  276: 				string distanceText = webhookEvent.Get("distance");
  277: 				float distance = distanceText.ToFloat();
  278: 				if (distanceText == "" || distance < cfg.MinDistance)
  279: 				{
  280: 					return false;
  281: 				}
  282: 			}
  283: 
  284: 			return true;
  285: 		}
  286: 
  287: 		if (eventId == VPPWebhookDefs.EV_ADMIN)
  288: 		{
  289: 			string moduleName = webhookEvent.Get("module");
  290: 			moduleName.ToLower();
  291: 			if (cfg.ExcludedModules && cfg.ExcludedModules.Find(moduleName) >= 0)
  292: 			{
  293: 				return false;
  294: 			}
  295: 
  296: 			if (cfg.Modules && cfg.Modules.Count() > 0 && cfg.Modules.Find(moduleName) < 0)
  297: 			{
  298: 				return false;
  299: 			}
  300: 		}
  301: 
  302: 		return true;
  303: 	}
  304: 
  305: 	// ---------------------------------------------------------------- senders, templates
  306: 
  307: 	protected void StartSender(WebHook hook)
  308: 	{
  309: 		VPPWebhookSender sender = new VPPWebhookSender(hook);
  310: 		m_Senders.Set(hook.m_Id, sender);
  311: 		LoadTemplates(hook, sender, true);
  312: 		int due = GetGame().GetTime() + hook.GetServerStatsInterval() * 1000;
  313: 		m_StatusDue.Set(hook.m_Id, due);
  314: 	}
  315: 
  316: 	// The old sender keeps living until its requests are answered (the engine holds its callbacks).
  317: 	protected void RetireSender(string hookId)
  318: 	{
  319: 		VPPWebhookSender sender = m_Senders.Get(hookId);
  320: 		if (sender)
  321: 		{
  322: 			m_Retired.Insert(sender);
  323: 		}
  324: 
  325: 		m_Senders.Remove(hookId);
  326: 		m_StatusDue.Remove(hookId);
  327: 	}
  328: 
  329: 	string TemplatePath(WebHook hook, string eventId)
  330: 	{
  331: 		return TEMPLATE_DIR + "/" + hook.m_Id + "/" + eventId + TEMPLATE_EXT;
  332: 	}
  333: 
  334: 	// Reads every event template of the webhook (missing files are written from the preset first) and compiles it.
  335: 	// Returns how many templates have errors (they are logged; such an event sends nothing until fixed).
  336: 	protected int LoadTemplates(WebHook hook, VPPWebhookSender sender, bool logIssues)
  337: 	{
  338: 		EnsureHookDir(hook);
  339: 		int broken = 0;
  340: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  341: 		foreach (VPPWebhookEventDef def : eventDefs)
  342: 		{
  343: 			string path = TemplatePath(hook, def.Id);
  344: 			RefreshPresetTemplate(hook, def.Id, false);
  345: 			string text = "";
  346: 			VPPXmlText.ReadAll(path, text);
  347: 			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
  348: 			tpl.Parse(text, def);
  349: 			sender.SetTemplate(def.Id, tpl);
  350: 			if (tpl.HasErrors())
  351: 			{
  352: 				broken++;
  353: 				if (logIssues)
  354: 				{
  355: 					LogIssues(hook, def.Id, tpl);
  356: 				}
  357: 			}
  358: 		}
  359: 
  360: 		return broken;
  361: 	}
  362: 
  363: 	protected void LogIssues(WebHook hook, string eventId, VPPWebhookTemplate tpl)
  364: 	{
  365: 		string hookName = hook.GetName();
  366: 		foreach (VPPWebhookIssue issue : tpl.Issues)
  367: 		{
  368: 			string where = eventId + TEMPLATE_EXT + ":" + issue.Line.ToString() + ":" + issue.Col.ToString();
  369: 			Print("[WebHooksManager] \"" + hookName + "\" " + where + " " + issue.Message);
  370: 		}
  371: 	}
  372: 
  373: 	protected void EnsureHookDir(WebHook hook)
  374: 	{
  375: 		if (!FileExist(TEMPLATE_DIR))
  376: 		{
  377: 			MakeDirectory(TEMPLATE_DIR);
  378: 		}
  379: 
  380: 		string hookDir = TEMPLATE_DIR + "/" + hook.m_Id;
  381: 		if (!FileExist(hookDir))
  382: 		{
  383: 			MakeDirectory(hookDir);
  384: 		}
  385: 	}
  386: 
  387: 	// (Re)writes every template of the webhook from its preset.
  388: 	protected void WritePresetTemplates(WebHook hook)
  389: 	{
  390: 		EnsureHookDir(hook);
  391: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  392: 		foreach (VPPWebhookEventDef def : eventDefs)
  393: 		{
  394: 			RefreshPresetTemplate(hook, def.Id, true);
  395: 		}
  396: 	}
  397: 
  398: 	// Writes the preset template of an event when the file is missing, when force is set, or when the file is still
  399: 	// exactly the preset text this server wrote earlier (so preset fixes reach untouched files). A file an admin
  400: 	// edited, or one written before hashes were tracked that differs from the preset, is left alone.
  401: 	protected void RefreshPresetTemplate(WebHook hook, string eventId, bool force)
  402: 	{
  403: 		string path = TemplatePath(hook, eventId);
  404: 		string presetText = VPPWebhookPresets.TemplateFor(hook.m_Preset, eventId);
  405: 		int presetHash = VPPXmlText.NormalizedHash(presetText);
  406: 		string current = "";
  407: 		int currentHash = 0;
  408: 		int writtenHash = 0;
  409: 		bool known = hook.m_PresetHashes.Contains(eventId);
  410: 		if (known)
  411: 		{
  412: 			writtenHash = hook.m_PresetHashes.Get(eventId);
  413: 		}
  414: 
  415: 		if (!force && FileExist(path))
  416: 		{
  417: 			VPPXmlText.ReadAll(path, current);
  418: 			currentHash = VPPXmlText.NormalizedHash(current);
  419: 			if (currentHash == presetHash)
  420: 			{
  421: 				if (!known || writtenHash != presetHash)
  422: 				{
  423: 					hook.m_PresetHashes.Set(eventId, presetHash);
  424: 					m_TemplatesDirty = true;
  425: 				}
  426: 
  427: 				return;
  428: 			}
  429: 
  430: 			if (!known || writtenHash != currentHash)
  431: 			{
  432: 				return;
  433: 			}
  434: 
  435: 			string hookName = hook.GetName();
  436: 			Print("[WebHooksManager] \"" + hookName + "\" " + eventId + TEMPLATE_EXT + " updated to the current preset");
  437: 		}
  438: 
  439: 		VPPXmlText.WriteAll(path, presetText);
  440: 		hook.m_PresetHashes.Set(eventId, presetHash);
  441: 		m_TemplatesDirty = true;
  442: 	}
  443: 
  444: 	protected void SaveIfTemplatesChanged()
  445: 	{
  446: 		if (!m_TemplatesDirty)
  447: 		{
  448: 			return;
  449: 		}
  450: 
  451: 		m_TemplatesDirty = false;
  452: 		Save();
  453: 	}
  454: 
  455: 	// Templates/README.txt: the syntax, the webhooks' folders and every event's variables.
  456: 	protected void WriteReadme()
  457: 	{
  458: 		if (!FileExist(TEMPLATE_DIR))
  459: 		{
  460: 			MakeDirectory(TEMPLATE_DIR);
  461: 		}
  462: 
  463: 		string nl = "\n";
  464: 		string text = "VPP Admin Tools webhook templates" + nl + "=================================" + nl + nl;
  465: 		text = text + "Each webhook has a folder named after its id with one <event>.tpl per event: the request body sent for it." + nl;
  466: 		text = text + "Edit them here or in the WebHooks menu; the server reads them at start (or on Reload in the menu)." + nl;
  467: 		text = text + "Delete a file to get the webhook's preset template back." + nl + nl;
  468: 		text = text + "Syntax:" + nl;
  469: 		text = text + "  {{victim.name}}                        a variable (JSON-escaped for JSON webhooks)" + nl;
  470: 		text = text + "  {{victim.id|steamurl}}                 filters: upper lower trim truncate:N default:TEXT round:N number steamurl raw json" + nl;
  471: 		text = text + "  {{#if killer.id}} ... {{else}} ... {{/if}}   shown when the variable is not empty" + nl;
  472: 		text = text + "  {{#unless killer.id}} ... {{/unless}}       shown when it is empty" + nl;
  473: 		text = text + "  {{#ifeq cause suicide}} ... {{/ifeq}}       shown when it equals the value" + nl;
  474: 		text = text + "  {{! comment }}" + nl;
  475: 		text = text + "  {{hook.<name>}}                        a custom variable of the webhook (username, avatar, chat_id, ...)" + nl + nl;
  476: 		text = text + "Webhooks:" + nl;
  477: 		foreach (WebHook hook : M_DATA)
  478: 		{
  479: 			if (hook)
  480: 			{
  481: 				string hookName = hook.GetName();
  482: 				text = text + "  " + hook.m_Id + "  " + hookName + "  (" + hook.m_Preset + ")" + nl;
  483: 			}
  484: 		}
  485: 
  486: 		text = text + nl + "Events and their variables:" + nl;
  487: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  488: 		foreach (VPPWebhookEventDef def : eventDefs)
  489: 		{
  490: 			text = text + nl + "  " + def.Id + nl;
  491: 			foreach (VPPWebhookVar webhookVar : def.Vars)
  492: 			{
  493: 				text = text + "    {{" + webhookVar.Name + "}}  e.g. " + webhookVar.Sample + nl;
  494: 			}
  495: 		}
  496: 
  497: 		string readmePath = TEMPLATE_DIR + "/README.txt";
  498: 		VPPXmlText.WriteAll(readmePath, text);
  499: 	}
  500: 
  501: 	// ---------------------------------------------------------------- tick
  502: 
  503: 	void Tick()
  504: 	{
  505: 		int now = GetGame().GetTime();
  506: 		foreach (WebHook hook : M_DATA)
  507: 		{
  508: 			if (!hook)
  509: 			{
  510: 				continue;
  511: 			}
  512: 
  513: 			VPPWebhookSender sender = m_Senders.Get(hook.m_Id);
  514: 			if (!sender)
  515: 			{
  516: 				continue;
  517: 			}
  518: 
  519: 			if (hook.IsEventEnabled(VPPWebhookDefs.EV_STATUS) && m_StatusDue.Contains(hook.m_Id) && now >= m_StatusDue.Get(hook.m_Id))
  520: 			{
  521: 				int nextDue = now + hook.GetServerStatsInterval() * 1000;
  522: 				m_StatusDue.Set(hook.m_Id, nextDue);
  523: 				PostStatusTo(hook);
  524: 			}
  525: 
  526: 			sender.Pump();
  527: 		}
  528: 
  529: 		for (int r = m_Retired.Count() - 1; r >= 0; r--)
  530: 		{
  531: 			VPPWebhookSender retired = m_Retired[r];
  532: 			retired.Pump();
  533: 			if (retired.PendingRequests() == 0)
  534: 			{
  535: 				m_Retired.Remove(r);
  536: 			}
  537: 		}
  538: 	}
  539: 
  540: 	protected void PostStatusTo(WebHook hook)
  541: 	{
  542: 		if (!CanSend())
  543: 		{
  544: 			return;
  545: 		}
  546: 
  547: 		ServerStatusMessage status = new ServerStatusMessage();
  548: 		VPPWebhookEvent statusEvent = status.ToEvent();
  549: 		FillCommonVars(statusEvent);
  550: 		SendTo(hook, statusEvent, "", 0);
  551: 	}
  552: 
  553: 	// ---------------------------------------------------------------- menu RPCs (list / create / edit / delete)
  554: 
  555: 	protected bool CanViewUrls(string plainId)
  556: 	{
  557: 		return GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:ViewURL", "", false);
  558: 	}
  559: 
  560: 	protected void SendList(PlayerIdentity sender)
  561: 	{
  562: 		string plainId = sender.GetPlainId();
  563: 		bool showUrl = CanViewUrls(plainId);
  564: 		array<ref WebHook> copies = new array<ref WebHook>();
  565: 		foreach (WebHook hook : M_DATA)
  566: 		{
  567: 			if (hook)
  568: 			{
  569: 				WebHook copy = hook.CopyForClient(showUrl);
  570: 				copies.Insert(copy);
  571: 			}
  572: 		}
  573: 
  574: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "PopulateList", new Param1<ref array<ref WebHook>>(copies), true, sender);
  575: 		int access = AccessMask(plainId);
  576: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnAccess", new Param1<int>(access), true, sender);
  577: 	}
  578: 
  579: 	// What the admin may do in the menu (VPPWebhookAccess bits), so it can disable what the server would refuse.
  580: 	protected int AccessMask(string plainId)
  581: 	{
  582: 		int access = 0;
  583: 		PermissionManager perms = GetPermissionManager();
  584: 		if (perms.VerifyPermission(plainId, "MenuWebHooks:Create", "", false))
  585: 		{
  586: 			access = access | VPPWebhookAccess.CREATE;
  587: 		}
  588: 
  589: 		if (perms.VerifyPermission(plainId, "MenuWebHooks:Edit", "", false))
  590: 		{
  591: 			access = access | VPPWebhookAccess.EDIT;
  592: 		}
  593: 
  594: 		if (perms.VerifyPermission(plainId, "MenuWebHooks:Delete", "", false))
  595: 		{
  596: 			access = access | VPPWebhookAccess.DELETE;
  597: 		}
  598: 
  599: 		if (perms.VerifyPermission(plainId, "MenuWebHooks:EditTemplates", "", false))
  600: 		{
  601: 			access = access | VPPWebhookAccess.EDIT_TEMPLATES;
  602: 		}
  603: 
  604: 		if (perms.VerifyPermission(plainId, "MenuWebHooks:TestSend", "", false))
  605: 		{
  606: 			access = access | VPPWebhookAccess.TEST_SEND;
  607: 		}
  608: 
  609: 		if (perms.VerifyPermission(plainId, "MenuWebHooks:ViewURL", "", false))
  610: 		{
  611: 			access = access | VPPWebhookAccess.VIEW_URL;
  612: 		}
  613: 
  614: 		return access;
  615: 	}
  616: 
  617: 	void GetWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
  618: 	{
  619: 		if(type == CallType.Server && sender)
  620: 		{
  621: 			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks", "", false))
  622: 				return;
  623: 
  624: 			SendList(sender);
  625: 		}
  626: 	}
  627: 
  628: 	void DeleteWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
  629: 	{
  630: 		if(type == CallType.Server && sender)
  631: 		{
  632: 			Param2<int,string> data;
  633: 			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Delete"))
  634: 				return;
  635: 
  636: 			if (!ctx.Read(data))
  637: 				return;
  638: 
  639: 			if (data.param1 >= 0 && data.param1 < M_DATA.Count() && M_DATA.Get(data.param1).GetName() == data.param2)
  640: 			{
  641: 				WebHook removed = M_DATA.Get(data.param1);
  642: 				string removedName = removed.GetName();
  643: 				GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Deleted WebHook: " + removedName));
  644: 				RetireSender(removed.m_Id);
  645: 				M_DATA.RemoveOrdered(data.param1);
  646: 				Save();
  647: 				WriteReadme();
  648: 				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"WebHook: "+data.param2 + " was successfully deleted!", NotifyTypes.NOTIFY);
  649: 				SendList(sender);
  650: 			}
  651: 			else
  652: 			{
  653: 				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"Error deleting webhook: "+data.param2 + "\nobject not found in array!", NotifyTypes.NOTIFY);
  654: 			}
  655: 		}
  656: 	}
  657: 
  658: 	void CreateWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
  659: 	{
  660: 		if(type == CallType.Server && sender)
  661: 		{
  662: 			Param1<ref WebHook> data;
  663: 
  664: 			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Create"))
  665: 				return;
  666: 
  667: 			if (!ctx.Read(data))
  668: 				return;
  669: 
  670: 			WebHook webHook = data.param1;
  671: 			if (!webHook)
  672: 				return;
  673: 
  674: 			string createdUrl = webHook.GetURL();
  675: 			if (createdUrl == "" || WebHook.IsMasked(createdUrl))
  676: 				return;
  677: 
  678: 			// a fresh webhook: the preset follows the menu's "simplified" switch, the events its category switches
  679: 			webHook.m_Id = "";
  680: 			webHook.m_Version = 0;
  681: 			webHook.m_Preset = "";
  682: 			webHook.m_ContentType = "";
  683: 			webHook.Migrate(NextSerial());
  684: 			M_DATA.Insert(webHook);
  685: 			WritePresetTemplates(webHook);
  686: 			StartSender(webHook);
  687: 
  688: 			string createdName = webHook.GetName();
  689: 			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Created new WebHook: " + createdName));
  690: 			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"New WebHook: " + createdName + " successfully created and saved!", NotifyTypes.NOTIFY);
  691: 			Save();
  692: 			WriteReadme();
  693: 			SendList(sender);
  694: 		}
  695: 	}
  696: 
  697: 	// The current menu edits name, URL, the category switches, the status interval and "simplified": they are merged
  698: 	// into the stored webhook, which keeps its id, templates, variables and filters.
  699: 	void EditWebHooks(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
  700: 	{
  701: 		if(type == CallType.Server && sender)
  702: 		{
  703: 			Param3<int,string,ref WebHook> data;
  704: 
  705: 			if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(),"MenuWebHooks:Edit"))
  706: 				return;
  707: 
  708: 			if (!ctx.Read(data))
  709: 				return;
  710: 
  711: 			if (data.param1 < 0 || data.param1 >= M_DATA.Count() || !data.param3)
  712: 				return;
  713: 
  714: 			WebHook stored = M_DATA.Get(data.param1);
  715: 			if (!stored)
  716: 				return;
  717: 
  718: 			WebHook edited = data.param3;
  719: 			string storedName = stored.GetName();
  720: 			string editedName = edited.GetName();
  721: 			if (storedName != data.param2)
  722: 			{
  723: 				GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"Failed to save changes to webhook: " + editedName + "\n\nCould not find old instance, another admin deleted it?", NotifyTypes.NOTIFY);
  724: 				return;
  725: 			}
  726: 
  727: 			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(sender.GetPlainId(), sender.GetName(), "[WebHooksManager] Edited WebHook: " + storedName));
  728: 			stored.SetName(editedName);
  729: 			string newUrl = edited.GetURL();
  730: 			if (newUrl != "" && !WebHook.IsMasked(newUrl))
  731: 				stored.SetURL(newUrl);
  732: 
  733: 			stored.m_deathKillLogs = edited.m_deathKillLogs;
  734: 			stored.m_adminActivityLog = edited.m_adminActivityLog;
  735: 			stored.m_admHitLog = edited.m_admHitLog;
  736: 			stored.m_joinLeaveLog = edited.m_joinLeaveLog;
  737: 			stored.m_serverStatusLog = edited.m_serverStatusLog;
  738: 			VPPWebHookServerStatsTime editedInterval = edited.GetServerStatsInterval();
  739: 			stored.SetServerStatsInterval(editedInterval);
  740: 			stored.SyncEventsFromSwitches();
  741: 			bool presetChanged = false;
  742: 			if (stored.m_simplifiedMessages != edited.m_simplifiedMessages && VPPWebhookPresets.IsDiscord(stored.m_Preset))
  743: 			{
  744: 				stored.m_Preset = VPPWebhookPresets.DISCORD_EMBED;
  745: 				if (edited.m_simplifiedMessages)
  746: 					stored.m_Preset = VPPWebhookPresets.DISCORD_SIMPLE;
  747: 
  748: 				presetChanged = true;
  749: 			}
  750: 
  751: 			stored.m_simplifiedMessages = edited.m_simplifiedMessages;
  752: 			stored.Migrate(NextSerial());
  753: 			if (presetChanged)
  754: 				WritePresetTemplates(stored);
  755: 
  756: 			RetireSender(stored.m_Id);
  757: 			StartSender(stored);
  758: 			Save();
  759: 			WriteReadme();
  760: 			GetPermissionManager().NotifyPlayer(sender.GetPlainId(),"WebHook: " + editedName + " was successfully edited & saved!", NotifyTypes.NOTIFY);
  761: 			SendList(sender);
  762: 		}
  763: 	}
  764: 
  765: 	// ---------------------------------------------------------------- webhook RPCs of the new menu
  766: 
  767: 	protected void ReplySaved(PlayerIdentity sender, int reqId, bool ok, string hookId, string error)
  768: 	{
  769: 		VPPWebhookSaveReply reply = new VPPWebhookSaveReply();
  770: 		reply.ReqId = reqId;
  771: 		reply.Ok = ok;
  772: 		reply.HookId = hookId;
  773: 		reply.Error = error;
  774: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnWebhookSaved", new Param1<ref VPPWebhookSaveReply>(reply), true, sender);
  775: 	}
  776: 
  777: 	protected bool NameInUse(string name, string exceptId)
  778: 	{
  779: 		string lowerName = name;
  780: 		lowerName.ToLower();
  781: 		foreach (WebHook hook : M_DATA)
  782: 		{
  783: 			if (!hook || hook.m_Id == exceptId)
  784: 			{
  785: 				continue;
  786: 			}
  787: 
  788: 			string otherName = hook.GetName();
  789: 			otherName.ToLower();
  790: 			if (otherName == lowerName)
  791: 			{
  792: 				return true;
  793: 			}
  794: 		}
  795: 
  796: 		return false;
  797: 	}
  798: 
  799: 	// Creates (empty or unknown m_Id) or updates a webhook with everything the menu edits. A changed preset rewrites
  800: 	// the webhook's templates from the new preset; the legacy switches are kept in step for older tools.
  801: 	void SaveWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
  802: 	{
  803: 		if (type != CallType.Server || !sender)
  804: 		{
  805: 			return;
  806: 		}
  807: 
  808: 		Param2<int, ref WebHook> data;
  809: 		if (!ctx.Read(data))
  810: 		{
  811: 			return;
  812: 		}
  813: 
  814: 		string plainId = sender.GetPlainId();
  815: 		WebHook incoming = data.param2;
  816: 		int reqId = data.param1;
  817: 		if (!incoming)
  818: 		{
  819: 			return;
  820: 		}
  821: 
  822: 		WebHook stored = FindHook(incoming.m_Id);
  823: 		bool creating = false;
  824: 		if (!stored)
  825: 		{
  826: 			creating = true;
  827: 		}
  828: 
  829: 		string permission = "MenuWebHooks:Edit";
  830: 		if (creating)
  831: 		{
  832: 			permission = "MenuWebHooks:Create";
  833: 		}
  834: 
  835: 		if (!GetPermissionManager().VerifyPermission(plainId, permission))
  836: 		{
  837: 			return;
  838: 		}
  839: 
  840: 		string newName = incoming.GetName();
  841: 		newName = newName.Trim();
  842: 		if (newName.Length() < 3)
  843: 		{
  844: 			ReplySaved(sender, reqId, false, incoming.m_Id, "NAME_SHORT");
  845: 			return;
  846: 		}
  847: 
  848: 		string exceptId = "";
  849: 		if (stored)
  850: 		{
  851: 			exceptId = stored.m_Id;
  852: 		}
  853: 
  854: 		if (NameInUse(newName, exceptId))
  855: 		{
  856: 			ReplySaved(sender, reqId, false, incoming.m_Id, "NAME_IN_USE");
  857: 			return;
  858: 		}
  859: 
  860: 		string newUrl = incoming.GetURL();
  861: 		newUrl = newUrl.Trim();
  862: 		bool urlGiven = newUrl != "" && !WebHook.IsMasked(newUrl);
  863: 		if (creating && !urlGiven)
  864: 		{
  865: 			ReplySaved(sender, reqId, false, "", "URL_MISSING");
  866: 			return;
  867: 		}
  868: 
  869: 		string newPreset = incoming.m_Preset;
  870: 		if (!VPPWebhookPresets.IsPreset(newPreset))
  871: 		{
  872: 			newPreset = VPPWebhookPresets.DISCORD_EMBED;
  873: 		}
  874: 
  875: 		if (creating)
  876: 		{
  877: 			stored = new WebHook(newName, newUrl);
  878: 			stored.m_Preset = newPreset;
  879: 			stored.Migrate(NextSerial());
  880: 			M_DATA.Insert(stored);
  881: 		}
  882: 
  883: 		bool presetChanged = stored.m_Preset != newPreset;
  884: 		stored.SetName(newName);
  885: 		if (urlGiven)
  886: 		{
  887: 			stored.SetURL(newUrl);
  888: 		}
  889: 
  890: 		stored.m_Preset = newPreset;
  891: 		string contentType = incoming.m_ContentType;
  892: 		contentType = contentType.Trim();
  893: 		if (contentType == "")
  894: 		{
  895: 			contentType = VPPWebhookPresets.ContentTypeOf(newPreset);
  896: 		}
  897: 
  898: 		stored.m_ContentType = contentType;
  899: 		int rateLimit = incoming.m_RateLimit;
  900: 		if (rateLimit < 0)
  901: 		{
  902: 			rateLimit = 0;
  903: 		}
  904: 
  905: 		if (rateLimit > 600)
  906: 		{
  907: 			rateLimit = 600;
  908: 		}
  909: 
  910: 		stored.m_RateLimit = rateLimit;
  911: 		stored.m_Disabled = incoming.m_Disabled;
  912: 		stored.m_HideIds = incoming.m_HideIds;
  913: 		stored.m_HideServerAddress = incoming.m_HideServerAddress;
  914: 		VPPWebHookServerStatsTime interval = ValidInterval(incoming.m_serverStatsInterval);
  915: 		stored.SetServerStatsInterval(interval);
  916: 		CopyVars(incoming, stored);
  917: 		CopyEvents(incoming, stored);
  918: 		stored.SyncSwitchesFromEvents();
  919: 		if (creating || presetChanged)
  920: 		{
  921: 			WritePresetTemplates(stored);
  922: 		}
  923: 
  924: 		RetireSender(stored.m_Id);
  925: 		StartSender(stored);
  926: 		Save();
  927: 		SaveIfTemplatesChanged();
  928: 		WriteReadme();
  929: 		string verb = "Edited";
  930: 		if (creating)
  931: 		{
  932: 			verb = "Created";
  933: 		}
  934: 
  935: 		string logText = "[WebHooksManager] " + verb + " WebHook: " + newName;
  936: 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
  937: 		ReplySaved(sender, reqId, true, stored.m_Id, "");
  938: 		SendList(sender);
  939: 	}
  940: 
  941: 	protected VPPWebHookServerStatsTime ValidInterval(VPPWebHookServerStatsTime interval)
  942: 	{
  943: 		if (interval == VPPWebHookServerStatsTime.ONE_MINUTE || interval == VPPWebHookServerStatsTime.FIVE_MINUTES)
  944: 		{
  945: 			return interval;
  946: 		}
  947: 
  948: 		if (interval == VPPWebHookServerStatsTime.TEN_MINUTES || interval == VPPWebHookServerStatsTime.FIFTEEN_MINUTES)
  949: 		{
  950: 			return interval;
  951: 		}
  952: 
  953: 		return VPPWebHookServerStatsTime.FIVE_MINUTES;
  954: 	}
  955: 
  956: 	// hook.* variables: plain names only (letters, digits, _ and .), at most 32, values up to 500 characters.
  957: 	protected void CopyVars(WebHook source, WebHook target)
  958: 	{
  959: 		target.m_Vars.Clear();
  960: 		if (!source.m_Vars)
  961: 		{
  962: 			return;
  963: 		}
  964: 
  965: 		int total = source.m_Vars.Count();
  966: 		for (int i = 0; i < total; i++)
  967: 		{
  968: 			if (target.m_Vars.Count() >= 32)
  969: 			{
  970: 				break;
  971: 			}
  972: 
  973: 			string varName = source.m_Vars.GetKey(i);
  974: 			string varValue = source.m_Vars.GetElement(i);
  975: 			varName = varName.Trim();
  976: 			if (!VPPWebhookVarNames.IsPlain(varName))
  977: 			{
  978: 				continue;
  979: 			}
  980: 
  981: 			if (varValue.Length() > 500)
  982: 			{
  983: 				varValue = varValue.Substring(0, 500);
  984: 			}
  985: 
  986: 			target.m_Vars.Set(varName, varValue);
  987: 		}
  988: 	}
  989: 
  990: 	// Event settings for the known events (unknown ids are ignored); module names are kept lower case and trimmed.
  991: 	protected void CopyEvents(WebHook source, WebHook target)
  992: 	{
  993: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
  994: 		foreach (VPPWebhookEventDef def : eventDefs)
  995: 		{
  996: 			VPPWebhookEventCfg sourceCfg = null;
  997: 			if (source.m_Events)
  998: 			{
  999: 				sourceCfg = source.m_Events.Get(def.Id);
 1000: 			}
 1001: 
 1002: 			VPPWebhookEventCfg cfg = target.m_Events.Get(def.Id);
 1003: 			if (!cfg)
 1004: 			{
 1005: 				cfg = new VPPWebhookEventCfg();
 1006: 				target.m_Events.Set(def.Id, cfg);
 1007: 			}
 1008: 
 1009: 			if (!sourceCfg)
 1010: 			{
 1011: 				continue;
 1012: 			}
 1013: 
 1014: 			cfg.Enabled = sourceCfg.Enabled;
 1015: 			cfg.PvPOnly = sourceCfg.PvPOnly;
 1016: 			cfg.SkipAI = sourceCfg.SkipAI;
 1017: 			cfg.MinDistance = Math.Clamp(sourceCfg.MinDistance, 0, 20000);
 1018: 			CopyModules(sourceCfg.Modules, cfg.Modules);
 1019: 			CopyModules(sourceCfg.ExcludedModules, cfg.ExcludedModules);
 1020: 		}
 1021: 	}
 1022: 
 1023: 	protected void CopyModules(array<string> source, array<string> target)
 1024: 	{
 1025: 		target.Clear();
 1026: 		if (!source)
 1027: 		{
 1028: 			return;
 1029: 		}
 1030: 
 1031: 		foreach (string moduleName : source)
 1032: 		{
 1033: 			string cleanName = moduleName.Trim();
 1034: 			cleanName.ToLower();
 1035: 			if (cleanName == "" || target.Find(cleanName) >= 0 || target.Count() >= 50)
 1036: 			{
 1037: 				continue;
 1038: 			}
 1039: 
 1040: 			target.Insert(cleanName);
 1041: 		}
 1042: 	}
 1043: 
 1044: 	void DeleteWebhookById(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1045: 	{
 1046: 		if (type != CallType.Server || !sender)
 1047: 		{
 1048: 			return;
 1049: 		}
 1050: 
 1051: 		Param1<string> data;
 1052: 		if (!ctx.Read(data))
 1053: 		{
 1054: 			return;
 1055: 		}
 1056: 
 1057: 		string plainId = sender.GetPlainId();
 1058: 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:Delete"))
 1059: 		{
 1060: 			return;
 1061: 		}
 1062: 
 1063: 		int index = -1;
 1064: 		for (int i = 0; i < M_DATA.Count(); i++)
 1065: 		{
 1066: 			if (M_DATA[i] && M_DATA[i].m_Id == data.param1)
 1067: 			{
 1068: 				index = i;
 1069: 				break;
 1070: 			}
 1071: 		}
 1072: 
 1073: 		if (index < 0)
 1074: 		{
 1075: 			SendList(sender);
 1076: 			return;
 1077: 		}
 1078: 
 1079: 		WebHook removed = M_DATA[index];
 1080: 		string removedName = removed.GetName();
 1081: 		RetireSender(removed.m_Id);
 1082: 		M_DATA.RemoveOrdered(index);
 1083: 		Save();
 1084: 		WriteReadme();
 1085: 		string logText = "[WebHooksManager] Deleted WebHook: " + removedName;
 1086: 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
 1087: 		SendList(sender);
 1088: 	}
 1089: 
 1090: 	// A copy with a new id, " (copy)" name and copies of all its template files.
 1091: 	void DuplicateWebhook(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1092: 	{
 1093: 		if (type != CallType.Server || !sender)
 1094: 		{
 1095: 			return;
 1096: 		}
 1097: 
 1098: 		Param2<int, string> data;
 1099: 		if (!ctx.Read(data))
 1100: 		{
 1101: 			return;
 1102: 		}
 1103: 
 1104: 		string plainId = sender.GetPlainId();
 1105: 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:Create"))
 1106: 		{
 1107: 			return;
 1108: 		}
 1109: 
 1110: 		WebHook source = FindHook(data.param2);
 1111: 		if (!source)
 1112: 		{
 1113: 			ReplySaved(sender, data.param1, false, data.param2, "NOT_FOUND");
 1114: 			return;
 1115: 		}
 1116: 
 1117: 		WebHook copy = source.CopyForClient(true);
 1118: 		copy.m_Id = WebHook.NewId(NextSerial());
 1119: 		string baseName = source.GetName() + " (copy)";
 1120: 		string copyName = baseName;
 1121: 		int attempt = 2;
 1122: 		while (NameInUse(copyName, ""))
 1123: 		{
 1124: 			copyName = baseName + " " + attempt.ToString();
 1125: 			attempt++;
 1126: 		}
 1127: 
 1128: 		copy.SetName(copyName);
 1129: 		copy.m_PresetHashes.Copy(source.m_PresetHashes);
 1130: 		EnsureHookDir(copy);
 1131: 		array<ref VPPWebhookEventDef> eventDefs = VPPWebhookDefs.All();
 1132: 		foreach (VPPWebhookEventDef def : eventDefs)
 1133: 		{
 1134: 			string fromPath = TemplatePath(source, def.Id);
 1135: 			string toPath = TemplatePath(copy, def.Id);
 1136: 			string text = "";
 1137: 			bool readOk = false;
 1138: 			if (FileExist(fromPath))
 1139: 			{
 1140: 				readOk = VPPXmlText.ReadAll(fromPath, text);
 1141: 			}
 1142: 
 1143: 			if (readOk)
 1144: 			{
 1145: 				VPPXmlText.WriteAll(toPath, text);
 1146: 			}
 1147: 		}
 1148: 
 1149: 		M_DATA.Insert(copy);
 1150: 		StartSender(copy);
 1151: 		Save();
 1152: 		SaveIfTemplatesChanged();
 1153: 		WriteReadme();
 1154: 		string logText = "[WebHooksManager] Duplicated WebHook: " + copyName;
 1155: 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), logText));
 1156: 		ReplySaved(sender, data.param1, true, copy.m_Id, "");
 1157: 		SendList(sender);
 1158: 	}
 1159: 
 1160: 	// Puts one event template back to the webhook's preset and answers like GetTemplate.
 1161: 	void ResetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1162: 	{
 1163: 		if (type != CallType.Server || !sender)
 1164: 		{
 1165: 			return;
 1166: 		}
 1167: 
 1168: 		Param3<int, string, string> data;
 1169: 		if (!ctx.Read(data))
 1170: 		{
 1171: 			return;
 1172: 		}
 1173: 
 1174: 		string plainId = sender.GetPlainId();
 1175: 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:EditTemplates"))
 1176: 		{
 1177: 			return;
 1178: 		}
 1179: 
 1180: 		WebHook hook = FindHook(data.param2);
 1181: 		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
 1182: 		if (!hook || !def)
 1183: 		{
 1184: 			return;
 1185: 		}
 1186: 
 1187: 		EnsureHookDir(hook);
 1188: 		RefreshPresetTemplate(hook, def.Id, true);
 1189: 		string text = "";
 1190: 		string path = TemplatePath(hook, def.Id);
 1191: 		VPPXmlText.ReadAll(path, text);
 1192: 		VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
 1193: 		if (hookSender)
 1194: 		{
 1195: 			VPPWebhookTemplate tpl = new VPPWebhookTemplate();
 1196: 			tpl.Parse(text, def);
 1197: 			hookSender.SetTemplate(def.Id, tpl);
 1198: 		}
 1199: 
 1200: 		SaveIfTemplatesChanged();
 1201: 		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
 1202: 		reply.ReqId = data.param1;
 1203: 		reply.HookId = hook.m_Id;
 1204: 		reply.EventId = def.Id;
 1205: 		reply.Text = text;
 1206: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
 1207: 	}
 1208: 
 1209: 	void GetWebhookStats(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1210: 	{
 1211: 		if (type != CallType.Server || !sender)
 1212: 		{
 1213: 			return;
 1214: 		}
 1215: 
 1216: 		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks", "", false))
 1217: 		{
 1218: 			return;
 1219: 		}
 1220: 
 1221: 		array<ref VPPWebhookStatsWire> rows = new array<ref VPPWebhookStatsWire>();
 1222: 		foreach (WebHook hook : M_DATA)
 1223: 		{
 1224: 			if (!hook)
 1225: 			{
 1226: 				continue;
 1227: 			}
 1228: 
 1229: 			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
 1230: 			if (!hookSender)
 1231: 			{
 1232: 				continue;
 1233: 			}
 1234: 
 1235: 			VPPWebhookStatsWire row = new VPPWebhookStatsWire();
 1236: 			row.HookId = hook.m_Id;
 1237: 			row.Queued = hookSender.Stats.Queued;
 1238: 			row.Delivered = hookSender.Stats.Delivered;
 1239: 			row.NoReply = hookSender.Stats.NoReply;
 1240: 			row.Failed = hookSender.Stats.Failed;
 1241: 			row.Dropped = hookSender.Stats.Dropped;
 1242: 			row.Waiting = hookSender.QueueCount();
 1243: 			row.ConsecutiveFailures = hookSender.Stats.ConsecutiveFailures;
 1244: 			row.LastError = hookSender.Stats.LastError;
 1245: 			row.LastErrorTime = hookSender.Stats.LastErrorTime;
 1246: 			row.LastSuccessTime = hookSender.Stats.LastSuccessTime;
 1247: 			rows.Insert(row);
 1248: 		}
 1249: 
 1250: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnStats", new Param1<ref array<ref VPPWebhookStatsWire>>(rows), true, sender);
 1251: 	}
 1252: 
 1253: 	// ---------------------------------------------------------------- template RPCs (webhook editor)
 1254: 
 1255: 	protected WebHook FindHook(string hookId)
 1256: 	{
 1257: 		foreach (WebHook hook : M_DATA)
 1258: 		{
 1259: 			if (hook && hook.m_Id == hookId)
 1260: 			{
 1261: 				return hook;
 1262: 			}
 1263: 		}
 1264: 
 1265: 		return null;
 1266: 	}
 1267: 
 1268: 	void GetTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1269: 	{
 1270: 		if (type != CallType.Server || !sender)
 1271: 		{
 1272: 			return;
 1273: 		}
 1274: 
 1275: 		Param3<int, string, string> data;
 1276: 		if (!ctx.Read(data))
 1277: 		{
 1278: 			return;
 1279: 		}
 1280: 
 1281: 		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks:EditTemplates"))
 1282: 		{
 1283: 			return;
 1284: 		}
 1285: 
 1286: 		WebHook hook = FindHook(data.param2);
 1287: 		if (!hook || !VPPWebhookDefs.Get(data.param3))
 1288: 		{
 1289: 			return;
 1290: 		}
 1291: 
 1292: 		VPPWebhookTemplateReply reply = new VPPWebhookTemplateReply();
 1293: 		reply.ReqId = data.param1;
 1294: 		reply.HookId = data.param2;
 1295: 		reply.EventId = data.param3;
 1296: 		string text = "";
 1297: 		string path = TemplatePath(hook, data.param3);
 1298: 		VPPXmlText.ReadAll(path, text);
 1299: 		reply.Text = text;
 1300: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplate", new Param1<ref VPPWebhookTemplateReply>(reply), true, sender);
 1301: 	}
 1302: 
 1303: 	void ValidateTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1304: 	{
 1305: 		HandleTemplate(type, ctx, sender, false);
 1306: 	}
 1307: 
 1308: 	void SaveTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1309: 	{
 1310: 		HandleTemplate(type, ctx, sender, true);
 1311: 	}
 1312: 
 1313: 	// Checks a template like the server will use it: template problems, then rendered with sample values, the JSON
 1314: 	// verdict of the game's parser (+ where) and the service's limits. save: also writes it when it has no errors.
 1315: 	protected void HandleTemplate(CallType type, ParamsReadContext ctx, PlayerIdentity sender, bool save)
 1316: 	{
 1317: 		if (type != CallType.Server || !sender)
 1318: 		{
 1319: 			return;
 1320: 		}
 1321: 
 1322: 		Param4<int, string, string, string> data;
 1323: 		if (!ctx.Read(data))
 1324: 		{
 1325: 			return;
 1326: 		}
 1327: 
 1328: 		string plainId = sender.GetPlainId();
 1329: 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:EditTemplates"))
 1330: 		{
 1331: 			return;
 1332: 		}
 1333: 
 1334: 		WebHook hook = FindHook(data.param2);
 1335: 		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
 1336: 		if (!hook || !def)
 1337: 		{
 1338: 			return;
 1339: 		}
 1340: 
 1341: 		VPPWebhookCheckReply reply = CheckTemplate(hook, def, data.param4);
 1342: 		reply.ReqId = data.param1;
 1343: 		if (save && reply.TemplateOk)
 1344: 		{
 1345: 			EnsureHookDir(hook);
 1346: 			string path = TemplatePath(hook, def.Id);
 1347: 			VPPXmlText.WriteAll(path, data.param4);
 1348: 			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
 1349: 			if (hookSender)
 1350: 			{
 1351: 				VPPWebhookTemplate tpl = new VPPWebhookTemplate();
 1352: 				tpl.Parse(data.param4, def);
 1353: 				hookSender.SetTemplate(def.Id, tpl);
 1354: 			}
 1355: 
 1356: 			reply.Saved = true;
 1357: 			string hookName = hook.GetName();
 1358: 			GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Edited the " + def.Id + " template of WebHook: " + hookName));
 1359: 		}
 1360: 
 1361: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplateCheck", new Param1<ref VPPWebhookCheckReply>(reply), true, sender);
 1362: 	}
 1363: 
 1364: 	VPPWebhookCheckReply CheckTemplate(WebHook hook, VPPWebhookEventDef def, string text)
 1365: 	{
 1366: 		VPPWebhookCheckReply reply = new VPPWebhookCheckReply();
 1367: 		reply.HookId = hook.m_Id;
 1368: 		reply.EventId = def.Id;
 1369: 		VPPWebhookTemplate tpl = new VPPWebhookTemplate();
 1370: 		tpl.Parse(text, def);
 1371: 		foreach (VPPWebhookIssue issue : tpl.Issues)
 1372: 		{
 1373: 			VPPWebhookIssueWire wire = new VPPWebhookIssueWire();
 1374: 			wire.IsError = issue.IsError;
 1375: 			wire.Line = issue.Line;
 1376: 			wire.Col = issue.Col;
 1377: 			wire.Code = issue.Code;
 1378: 			wire.Arg = issue.Arg;
 1379: 			wire.Message = issue.Message;
 1380: 			reply.Issues.Insert(wire);
 1381: 		}
 1382: 
 1383: 		reply.TemplateOk = !tpl.HasErrors();
 1384: 		if (!reply.TemplateOk)
 1385: 		{
 1386: 			return reply;
 1387: 		}
 1388: 
 1389: 		map<string, string> samples = new map<string, string>();
 1390: 		def.FillSamples(samples);
 1391: 		for (int i = 0; i < hook.m_Vars.Count(); i++)
 1392: 		{
 1393: 			string hookKey = hook.m_Vars.GetKey(i);
 1394: 			string hookValue = hook.m_Vars.GetElement(i);
 1395: 			samples.Set("hook." + hookKey, hookValue);
 1396: 		}
 1397: 
 1398: 		bool jsonBody = hook.m_ContentType.Contains("json");
 1399: 		string preview = tpl.Render(samples, jsonBody);
 1400: 		reply.Preview = preview;
 1401: 		if (!jsonBody)
 1402: 		{
 1403: 			return reply;
 1404: 		}
 1405: 
 1406: 		reply.JsonChecked = true;
 1407: 		VPPJsonCheckResult verdict = VPPJsonCheck.Check(preview);
 1408: 		reply.JsonValid = verdict.Valid;
 1409: 		reply.JsonMessage = verdict.Message;
 1410: 		reply.JsonLine = verdict.Line;
 1411: 		reply.JsonCol = verdict.Col;
 1412: 		if (verdict.Valid && VPPWebhookPresets.UsesDiscordLimits(hook.m_Preset))
 1413: 		{
 1414: 			VPPDiscordLint.Check(preview, reply.ServiceProblems);
 1415: 		}
 1416: 
 1417: 		return reply;
 1418: 	}
 1419: 
 1420: 	// Sends the event's sample message now; the answer comes back through OnTestResult.
 1421: 	void TestSend(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1422: 	{
 1423: 		if (type != CallType.Server || !sender)
 1424: 		{
 1425: 			return;
 1426: 		}
 1427: 
 1428: 		Param3<int, string, string> data;
 1429: 		if (!ctx.Read(data))
 1430: 		{
 1431: 			return;
 1432: 		}
 1433: 
 1434: 		string plainId = sender.GetPlainId();
 1435: 		if (!GetPermissionManager().VerifyPermission(plainId, "MenuWebHooks:TestSend"))
 1436: 		{
 1437: 			return;
 1438: 		}
 1439: 
 1440: 		WebHook hook = FindHook(data.param2);
 1441: 		VPPWebhookEventDef def = VPPWebhookDefs.Get(data.param3);
 1442: 		if (!hook || !def)
 1443: 		{
 1444: 			return;
 1445: 		}
 1446: 
 1447: 		VPPWebhookEvent sample = new VPPWebhookEvent(def.Id);
 1448: 		def.FillSamples(sample.Vars);
 1449: 		FillCommonVars(sample);
 1450: 		string hookName = hook.GetName();
 1451: 		if (!SendTo(hook, sample, plainId, data.param1))
 1452: 		{
 1453: 			OnTestResult(plainId, data.param1, hook.m_Id, def.Id, false, "TEMPLATE_ERROR");
 1454: 			return;
 1455: 		}
 1456: 
 1457: 		GetWebHooksManager().PostData(AdminActivityMessage, new AdminActivityMessage(plainId, sender.GetName(), "[WebHooksManager] Test send of " + def.Id + " to WebHook: " + hookName));
 1458: 	}
 1459: 
 1460: 	void OnTestResult(string plainId, int reqId, string hookId, string eventId, bool ok, string reason)
 1461: 	{
 1462: 		PlayerIdentity admin = FindIdentity(plainId);
 1463: 		if (!admin)
 1464: 		{
 1465: 			return;
 1466: 		}
 1467: 
 1468: 		VPPWebhookTestReply reply = new VPPWebhookTestReply();
 1469: 		reply.ReqId = reqId;
 1470: 		reply.HookId = hookId;
 1471: 		reply.EventId = eventId;
 1472: 		reply.Ok = ok;
 1473: 		reply.Reason = reason;
 1474: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTestResult", new Param1<ref VPPWebhookTestReply>(reply), true, admin);
 1475: 		string verdict = "failed: " + reason;
 1476: 		if (ok)
 1477: 		{
 1478: 			verdict = "delivered (" + reason + ")";
 1479: 		}
 1480: 
 1481: 		GetPermissionManager().NotifyPlayer(plainId, "Webhook test " + eventId + " " + verdict, NotifyTypes.NOTIFY);
 1482: 	}
 1483: 
 1484: 	protected PlayerIdentity FindIdentity(string plainId)
 1485: 	{
 1486: 		array<Man> players = new array<Man>();
 1487: 		GetGame().GetPlayers(players);
 1488: 		foreach (Man player : players)
 1489: 		{
 1490: 			if (player && player.GetIdentity() && player.GetIdentity().GetPlainId() == plainId)
 1491: 			{
 1492: 				return player.GetIdentity();
 1493: 			}
 1494: 		}
 1495: 
 1496: 		return null;
 1497: 	}
 1498: 
 1499: 	// Re-reads every template file (edits made on disk) and reports which webhooks have broken templates.
 1500: 	void ReloadTemplates(CallType type, ParamsReadContext ctx, PlayerIdentity sender, Object target)
 1501: 	{
 1502: 		if (type != CallType.Server || !sender)
 1503: 		{
 1504: 			return;
 1505: 		}
 1506: 
 1507: 		Param1<int> data;
 1508: 		if (!ctx.Read(data))
 1509: 		{
 1510: 			return;
 1511: 		}
 1512: 
 1513: 		if (!GetPermissionManager().VerifyPermission(sender.GetPlainId(), "MenuWebHooks:EditTemplates"))
 1514: 		{
 1515: 			return;
 1516: 		}
 1517: 
 1518: 		VPPWebhookReloadReply reply = new VPPWebhookReloadReply();
 1519: 		reply.ReqId = data.param1;
 1520: 		foreach (WebHook hook : M_DATA)
 1521: 		{
 1522: 			VPPWebhookSender hookSender = m_Senders.Get(hook.m_Id);
 1523: 			if (!hookSender)
 1524: 			{
 1525: 				continue;
 1526: 			}
 1527: 
 1528: 			int broken = LoadTemplates(hook, hookSender, true);
 1529: 			reply.HookIds.Insert(hook.m_Id);
 1530: 			reply.TemplateErrors.Insert(broken);
 1531: 		}
 1532: 
 1533: 		SaveIfTemplatesChanged();
 1534: 
 1535: 		GetRPCManager().VSendRPC("RPC_MenuWebHooks", "OnTemplatesReloaded", new Param1<ref VPPWebhookReloadReply>(reply), true, sender);
 1536: 	}
 1537: };
 1538: 
 1539: WebHooksManager GetWebHooksManager()
 1540: {
 1541: 	return WebHooksManager.Cast(GetPluginManager().GetPluginByType(WebHooksManager));
 1542: };

FIM DO RELATORIO
