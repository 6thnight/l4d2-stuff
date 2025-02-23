Convars.SetValue("sv_consistency", 0);Convars.SetValue("sv_pure_kick_clients", 0);

if (!("MANACAT" in getroottable())){
	::MANACAT <- {}
	for(local i = 0; i < 8; i++)::MANACAT["category"+i] <- [0]
}

local scrver = 20241005, scrcode = "delayHeal", scrcat = 5;
if(!(scrcode in ::MANACAT) || ::MANACAT[scrcode].ver <= scrver){
	::MANACAT[scrcode] <- {
		ver = scrver
		check = false
		function Title(ent){
			local msg = Convars.GetClientConvarValue("cl_language", ent.GetEntityIndex());
			switch(msg){
				case "korean":case "koreana":	msg = "지연치유";break;
				case "japanese":				msg = "治癒遅延";break;
				case "spanish":					msg = "Retrasar la curación";break;
				case "schinese":				msg = "延迟愈合";break;
				case "tchinese":				msg = "延遲癒合";break;
			//	case "russian":					msg = "";break;
			//	case "thai":					msg = "";break;
			//	case "polish":					msg = "";break;
			//	case "german":					msg = "";break;
			//	case "italian":					msg = "";break;
			//	case "french":					msg = "";break;
			//	case "portuguese":				msg = "";break;
			//	case "brazilian":				msg = "";break;
			//	case "dutch":					msg = "";break;
			//	case "vietnamese":				msg = "";break;
				default:						msg = "Delay Healing";break;
			}
			ClientPrint( ent, 5, "\x02 - "+msg+" \x01 v"+::MANACAT[scrcode].ver);
		}
	}

	local scr = true;
	for(local i = 1; i <= ::MANACAT["category"+scrcat][0]; i++){
		if(::MANACAT["category"+scrcat][i] == scrcode){scr = false;break;}
	}
	if(scr){::MANACAT["category"+scrcat].append(scrcode);	::MANACAT["category"+scrcat][0]++;}
}else if(::MANACAT[scrcode].ver > scrver){
	return;
}

for(local directory = "manacat_adrepill/",
	includes = [
		"info", "manacatInfo",
		"rngitem", "manacat_rng_item"
	],
	len = includes.len(), i = 0; i < len; i+=2){
	IncludeScript(directory+includes[i]);
	if(!(includes[i+1] in getroottable()))IncludeScript("manacat/"+includes[i]);
}

::DurationHealVar<-{
	temphealList = [] //유휴 상태로 전환되었을 때 진통제/아드 효과가 끊어지는 것 방지

	pill = 25
	adre = 25
	work = false
}

::DurationHeal<-{
	function OnGameEvent_pills_used(params){
		local player = GetPlayerFromUserID(params.userid);
		::DurationHeal.UseItem(player, ::DurationHealVar.pill, ::DurationHealVar.pill);
	}

	function OnGameEvent_adrenaline_used(params){
		local player = GetPlayerFromUserID(params.userid);
		::DurationHeal.UseItem(player, ::DurationHealVar.adre);
	}

	function UseItem(player, amount1 = 0, amount2 = 0){
		local len = ::DurationHealVar.temphealList.len();		local chk = false;
		for(local i = 0; i < len; i++){
			if(::DurationHealVar.temphealList[i][0] == player){
				::DurationHealVar.temphealList[i][1] += amount1;
				::DurationHealVar.temphealList[i][2] += amount2;
				chk = true;
			}
		}
		if(!chk)::DurationHealVar.temphealList.append([player, amount1, amount2]);
		
		if(!::DurationHealVar.work){
			::DurationHealVar.work = true;
			EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.DurationHealThink()", 0.0 );
		}
	}

	function OnGameEvent_weapon_fire(params){
		local player = GetPlayerFromUserID(params.userid);
		local item = player.GetActiveWeapon().GetClassname();
		if(item == "weapon_pain_pills" && Convars.GetFloat("pain_pills_health_value") > 0){
			::DurationHealVar.pill = Convars.GetFloat("pain_pills_health_value")/2;
			Convars.SetValue("pain_pills_health_value",0);
		}else if(item == "weapon_adrenaline" && Convars.GetFloat("adrenaline_health_buffer") > 0){
			::DurationHealVar.adre = Convars.GetFloat("adrenaline_health_buffer");
			Convars.SetValue("adrenaline_health_buffer",0);
		}
	}

	function OnGameEvent_bot_player_replace(params){
		local player = GetPlayerFromUserID(params.player);
		local bot = GetPlayerFromUserID(params.bot);
		::DurationHeal.targetFix(bot, player);
	}
	function OnGameEvent_player_bot_replace(params){
		local player = GetPlayerFromUserID(params.player);
		local bot = GetPlayerFromUserID(params.bot);
		::DurationHeal.targetFix(player, bot);
	}

	function targetFix(player, bot){
		local len = ::DurationHealVar.temphealList.len();
		for(local i = 0; i < len; i++){
			if(::DurationHealVar.temphealList[i][0] == player){
				::DurationHealVar.temphealList[i][0] = bot;
			}
		}
	}
}

function DurationHealThink(){
	local chk = false;
	local len = ::DurationHealVar.temphealList.len()-1;
	for(local i = len; i >= 0; i--){
		if(::DurationHealVar.temphealList[i][0] == null || !::DurationHealVar.temphealList[i][0].IsValid() ||
			::DurationHealVar.temphealList[i][0].IsDead() || ::DurationHealVar.temphealList[i][0].IsIncapacitated()){
			::DurationHealVar.temphealList.remove(i);	continue;
		}
		local model = ::DurationHealVar.temphealList[i][0].GetModelName();
		if(model == "models/infected/hunter.mdl" || model == "models/infected/hunter_l4d1.mdl"){
			::DurationHealVar.temphealList.remove(i);	continue;
		}
		local hp = ::DurationHealVar.temphealList[i][0].GetHealth();
		local hpb = ::DurationHealVar.temphealList[i][0].GetHealthBuffer();
		local maxhp = NetProps.GetPropInt( ::DurationHealVar.temphealList[i][0], "m_iMaxHealth" );
		if(hp + hpb >= maxhp){
			::DurationHealVar.temphealList.remove(i);	continue;
		}
		local heal = 0;
		if(::DurationHealVar.temphealList[i][1] > 0){
			::DurationHealVar.temphealList[i][1]--;
			heal++;	chk = true;
		}
		if(::DurationHealVar.temphealList[i][2] > 0){
			::DurationHealVar.temphealList[i][2]--;
			heal++;	chk = true;
		}
		::DurationHealVar.temphealList[i][0].SetHealthBuffer(hpb+heal);
		hpb = ::DurationHealVar.temphealList[i][0].GetHealthBuffer();
		if(hp + hpb > maxhp)
			::DurationHealVar.temphealList[i][0].SetHealthBuffer(hpb-1);
		if(hp + hpb == maxhp){
			::DurationHealVar.temphealList.remove(i);	continue;
		}
	}
	if(chk){
		EntFire( "worldspawn", "RunScriptCode", "g_ModeScript.DurationHealThink()", 0.1 );
	}else{
		::DurationHealVar.work = false;
	}
}

__CollectEventCallbacks(::DurationHeal, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);