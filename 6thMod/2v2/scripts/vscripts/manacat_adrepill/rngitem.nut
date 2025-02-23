Convars.SetValue("sv_consistency", 0);Convars.SetValue("sv_pure_kick_clients", 0);

if (!("MANACAT" in getroottable())){
	::MANACAT <- {}
	for(local i = 0; i < 8; i++)::MANACAT["category"+i] <- [0]
}

local scrver = 20250108, scrcode = "rng_item", scrcat = 0;
if(!(scrcode in ::MANACAT) || ::MANACAT[scrcode].ver <= scrver){
	::MANACAT[scrcode] <- {
		ver = scrver
		check = false
		function Title(ent){
			local msg = Convars.GetClientConvarValue("cl_language", ent.GetEntityIndex());
			switch(msg){
				case "korean":case "koreana":	msg = "아이템 스킨 확장";break;
				case "japanese":				msg = "アイテムスキン拡張";break;
				case "spanish":					msg = "Pack de Skins Extendidos de Items";break;
				case "schinese":				msg = "物品皮肤增加";break;
				case "tchinese":				msg = "物品皮膚增加";break;
				case "russian":					msg = "Скин Пак для Улучшенных Предметов";break;
				case "thai":					msg = "เพิ่มเติมสกินสิ่งของแพ็ค";break;
				case "polish":					msg = "Rozszerzony pakiet skórek przedmiotów";break;
				case "german":					msg = "Erweitertes Item Skin Pack";break;
				case "italian":					msg = "Pacchetto skin oggetti estesi";break;
				case "french":					msg = "pack de skin étendue pour objet";break;
				case "portuguese":				msg = "pack the skins estendido";break;
				case "brazilian":				msg = "Pacote de Visuais Extendido para Items";break;
				case "dutch":					msg = "Uitgebreide skinpakket voor items";break;
				case "vietnamese":				msg = "Gói Skin vật phẩm mở rộng";break;
				default:						msg = "Extended Items Skin Pack";break;
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

IncludeScript("manacat_rng_item/info");
if (!("manacatInfo" in getroottable())){
	IncludeScript("manacat/info");
}

::manacat_rng_item_lang <- {
pistol_kr = "사용 키를 한번 꾹 누르면 오른쪽 권총을, 빠르게 두번 꾹 누르면 왼쪽 권총을 바꿉니다."
pistol_jp = "キーを1回押し、長押しして右手のピストル、キーを2回押し、長押しして左手のピストルを変える"
pistol_es = "Aprieta y manten una vez para cambiar la pistola derecha, dos veces y manten para la izquierda"
pistol_sc = "按住该键一次可更换右手枪，快速按住两次可更换左手枪"
pistol_tc = "按住該鍵一次可更換右手槍，快速按兩次該鍵可更換左手槍"
pistol_ru = "Зажмите чтобы заменить правый пистолет, или же нажмите дважды чтобы сменить левый"
pistol_th = "เมื่อกดปุ่มรอบเดียวแล้วให้กดค้างไว้เพื่อเปลี่ยนปืนด้านขวา, หรือ กดปุ่มสองครั้งแล้วให้กดค้างไว้เพื่อเปลี่ยนปืนซ้าย"
pistol_pl = "Naciśnij i przytrzymaj, aby zamienić prawy pistolet, naciśnij i przytrzymaj dwa razy, aby zamienić lewy pistolet"
pistol_de = "Drücke und halte um die rechte Pistole zu ersetzen, oder drücke doppelt und halte für die linke"
pistol_it = "Tieni premuto una volta per equipaggiare la pistola sulla dx, o premi due volte e tieni premuto per la sx"
pistol_fr = "Appuyez et maintenez pour remplacer le pistolet droite, ou double-cliquez et maintenez pour le pistolet gauche"
pistol_pt = "pressione e segure para trocar a sua pistola direita, ou pressione duas vezes para trocar a pistola esquerda"
pistol_br = "Aperte e segure para trocar a pistola da direita, ou aperte e segure duas vezes para trocar a da esquerda"
pistol_nl = "Houd ingedrukt om rechter pistool te vervangen, of houd dubbel ingedrukt voor het linker"
pistol_vn = "Ấn một lần và giữ nút để đổi súng bên tay phải, hoặc ấn hai lần và giữ để đổi súng bên tay trái"
pistol_en = "Press and hold to replace your right pistol, or double tap and hold for your left pistol"

pistol_same_r_kr = "오른쪽 권총을 바꿀 필요가 없습니다."
pistol_same_l_kr = "왼쪽 권총을 바꿀 필요가 없습니다."
pistol_same_r_jp = "既に右手に同じピストルを持っている"
pistol_same_l_jp = "既に左手に同じピストルを持っている"
pistol_same_r_es = "No necesitas cambiar la pistola derecha"
pistol_same_l_es = "No necesitas cambiar la pistola izquierda"
pistol_same_r_sc = "无需更换右手枪"
pistol_same_l_sc = "无需更换左手枪"
pistol_same_r_tc = "無需更換右手槍"
pistol_same_l_tc = "無需更換左手槍"
pistol_same_r_ru = "Вам не нужно менять правый пистолет"
pistol_same_l_ru = "Вам не нужно менять левый пистолет"
pistol_same_r_th = "คุณไม่การต้องเปลี่ยนปืนด้านขวา"
pistol_same_l_th = "คุณไม่การต้องเปลี่ยนปืนด้านซ้าย"
pistol_same_r_pl = "Nie musisz zmieniać prawego pistoletu"
pistol_same_l_pl = "Nie musisz zmieniać lewego pistoletu"
pistol_same_r_de = "Du brauchst die rechte Pistole nicht zu ändern"
pistol_same_l_de = "Du brauchst die linke Pistole nicht zu ändern"
pistol_same_r_it = "hai già questa pistola sulla destra"
pistol_same_l_it = "hai già questa pistola sulla sinistra"
pistol_same_r_fr = "Tu n'as pas besoin de changer le pistolet de droite"
pistol_same_l_fr = "Tu n'as pas besoin de changer le pistolet de gauche"
pistol_same_r_pt = "Não precisas de trocar a pistola direita"
pistol_same_l_pt = "Não precisas de trocar a pistola esquerda"
pistol_same_r_br = "Você não precisa trocar a pistola da direita"
pistol_same_l_br = "Você não precisa trocar a pistola da esquerda"
pistol_same_r_nl = "Hetzelfde pistool al in rechterhand"
pistol_same_l_nl = "Hetzelfde pistool al in linkerhand"
pistol_same_r_vn = "Bạn không cần đổi súng bên tay phải"
pistol_same_l_vn = "Bạn không cần đổi súng bên tay trái"
pistol_same_r_en = "You don't need to change your right pistol"
pistol_same_l_en = "You don't need to change your left pistol"

wpn_kr = "사용 키를 꾹 누르고 있으면 가지고 있는 무기와 바꿉니다."
itm_kr = "사용 키를 꾹 누르고 있으면 가지고 있는 물품과 바꿉니다."
wpn_jp = "長押しして武器を変える"
itm_jp = "長押ししてアイテムを変える"
wpn_es = "Mantén para reemplazar tu arma"
itm_es = "Mantén para reemplazar tu ítem"
wpn_sc = "按住可交换武器"
itm_sc = "按住可交换物品"
wpn_tc = "按住可交換武器"
itm_tc = "按住可交換物品"
wpn_ru = "Нажмите и удерживайте чтобы заменить ваше оружие"
itm_ru = "Нажмите и удерживайте чтобы заменить ваш предмет"
wpn_th = "กดและให้กดข้างไว้เพื่อเปลี่ยนอาวุธ"
itm_th = "กดและให้กดข้างไว้เพื่อเปลี่ยนไอเทม"
wpn_pl = "Naciśnij i przytrzymaj, aby zastąpić swój broń"
itm_pl = "Naciśnij i przytrzymaj, aby zastąpić swój przedmiot"
wpn_de = "Gedrückt halten um Waffe zu ersetzen"
itm_de = "Gedrückt halten um Gegenstand zu ersetzen"
wpn_it = "Tieni premuto per sostituire la tua arma"
itm_it = "Tieni premuto per sostituire il tuo oggetto"
wpn_fr = "Appuyez et maintenez enfoncée la touche pour remplacer votre arme"
itm_fr = "Appuyez et maintenez enfoncée la touche pour remplacer votre objet"
wpn_pt = "Segure para trocar a sua arma"
itm_pt = "Segure para trocar o seu item"
wpn_br = "Segure para substituir sua arma"
itm_br = "Segure para substituir seu item"
wpn_nl = "Houd ingedrukt om je wapen te vervangen"
itm_nl = "Houd ingedrukt om je item te vervangen"
wpn_vn = "Nhấn và giữ để thay thế vũ khí của bạn"
itm_vn = "Nhấn và giữ để thay thế vật phẩm của bạn"
wpn_en = "Hold to replace your weapon"
itm_en = "Hold to replace your item"

	function lang(l){
		switch(l){
			case "korean":case "koreana":return "kr";
			case "japanese":return "jp";	//https://steamcommunity.com/id/nattsuiy/
			case "spanish":return "es";		//https://steamcommunity.com/id/sirwololo/
			case "schinese":return "sc";	//Google
			case "tchinese":return "tc";	//Google
			case "russian":return "ru";		//https://steamcommunity.com/profiles/76561199136004364/
			case "thai":return "th";		//https://steamcommunity.com/profiles/76561199258990944/
			case "polish":return "pl";		//https://steamcommunity.com/id/Klyxer/
			case "german":return "de";		//https://steamcommunity.com/id/renetm/
			case "italian":return "it";		//https://steamcommunity.com/id/TheRealBlackWolf/
			case "french":return "fr";		//https://steamcommunity.com/id/grandvoledevoiture5/
			case "portuguese":return "pt";	//https://steamcommunity.com/profiles/76561199228689957/
			case "brazilian":return "br";	//https://steamcommunity.com/id/chaduofficial/
			case "dutch":return "nl";		//https://steamcommunity.com/id/MMNL/
			case "vietnamese":return "vn";	//https://steamcommunity.com/profiles/76561199204271477/
			default:return "en";
		}
	}
}

::manacat_rng_item <- {
	world = Entities.First()
	debug = false
	startflag = false
	classnameList = [
		"weapon_spawn",		"weapon_melee_spawn",

		"weapon_first_aid_kit_spawn",
		"weapon_defibrillator_spawn",// 2,
		"weapon_upgradepack_incendiary_spawn",		"upgrade_ammo_incendiary",
		"weapon_upgradepack_explosive_spawn",		"upgrade_ammo_explosive",
		"weapon_pain_pills_spawn",
		"weapon_adrenaline_spawn",
		"weapon_molotov_spawn",
		"weapon_pipe_bomb_spawn",
		"weapon_vomitjar_spawn",// 5,
		
		"weapon_chainsaw_spawn",
		
		"weapon_pistol_spawn",						"weapon_pistol",
		"weapon_pistol_magnum_spawn",				"weapon_pistol_magnum",
		"weapon_smg_spawn",							"weapon_smg",
		"weapon_smg_silenced_spawn",				"weapon_smg_silenced",	
		"weapon_smg_mp5_spawn",						"weapon_smg_mp5",	
		"weapon_pumpshotgun_spawn",					"weapon_pumpshotgun",
		"weapon_shotgun_chrome_spawn",				"weapon_shotgun_chrome",
		"weapon_autoshotgun_spawn",					"weapon_autoshotgun",
		"weapon_shotgun_spas_spawn",				"weapon_shotgun_spas",
		"weapon_rifle_spawn",						"weapon_rifle",
		"weapon_rifle_ak47_spawn",					"weapon_rifle_ak47",
		"weapon_rifle_desert_spawn",				"weapon_rifle_desert",
		"weapon_rifle_sg552_spawn",					"weapon_rifle_sg552",
		"weapon_hunting_rifle_spawn"				"weapon_hunting_rifle"
		"weapon_sniper_military_spawn",				"weapon_sniper_military",
		"weapon_sniper_awp_spawn",					"weapon_sniper_awp",
		"weapon_sniper_scout_spawn",				"weapon_sniper_scout",
		"weapon_rifle_m60_spawn",					"weapon_rifle_m60",
		"weapon_grenade_launcher_spawn",			"weapon_grenade_launcher",

		"prop_minigun_l4d1",						"prop_minigun",
	]
	weaponList = {}

	itemclass = ""
	itembody = ""
	itemskin = ""
	itemx = ""
	itemy = ""
	itemz = ""
	itemlen = 0
	weaponmodel = ""
	weaponbody = ""
	weaponskin = ""
	weaponx = ""
	weapony = ""
	weaponz = ""
	weaponlen = 0
	exceptlist = ""
	sessionData = {}
	sessionData_vs = {}
	sessionInv = {}
	sessionInvReady = {}
	sessionChkp = {}
	round_first_inv_load = false
	intro = 0

	function weaponid(id){
		switch(id){
			case 1:return "pistol";case 2:return "smg";case 3:return "pumpshotgun";case 4:return "autoshotgun";case 5:return "rifle";case 6:return "hunting_rifle";case 7:return "smg_silenced";case 8:return "shotgun_chrome";case 9:return "rifle_desert";case 10:return "sniper_military";case 11:return "shotgun_spas";case 12:return "first_aid_kit";
			case 13:return "molotov";case 14:return "pipe_bomb";case 15:return "pain_pills";case 16:return "gascan";case 17:return "propanetank";case 18:return "oxygentank";case 19:return "melee";case 20:return "chainsaw";case 21:return "grenade_launcher";case 23:return "adrenaline";case 24:return "defibrillator";case 25:return "vomitjar";
			case 26:return "rifle_ak47";case 27:return "gnome";case 28:return "cola_bottles";case 29:return "fireworks_crate";case 30:return "upgradepack_incendiary";case 31:return "upgradepack_explosive";case 32:return "pistol_magnum";case 33:return "smg_mp5";case 34:return "rifle_sg552";case 35:return "sniper_awp";case 36:return "sniper_scout";case 37:return "rifle_m60";
		}
	}

	function skinSelect(skin_fam, skin_set = 0, calculate=false){
		if(!(skin_fam in ::manacat_rng_item.weaponList))return;
		if(typeof ::manacat_rng_item.weaponList[skin_fam][1] == "integer")return RandomInt(0, ::manacat_rng_item.weaponList[skin_fam][1]);
		skin_fam = ::manacat_rng_item.weaponList[skin_fam][1];
		local skin_table = [[0]];

		local skin_total = 0;
		local len = skin_fam.len();
		for(local i = 0; i < len; i++){
			if(skin_fam[i].len()==2 || (skin_fam[i].len()==3 && ::manacat_rng_item.exceptlist.find("|"+skin_fam[i][2]+"|") == null))
				skin_total += skin_fam[i][skin_set];
		}

		local skin_accrue = 0;
		for(local i = 0; i < len; i++){
			if(skin_fam[i].len()==3){
				if(::manacat_rng_item.exceptlist.find("|"+skin_fam[i][2]+"|") == null)
						skin_table.append( [skin_table[i][0] + (skin_fam[i][skin_set].tofloat()/skin_total)*100, skin_fam[i][2]] );
				else	skin_table.append( [skin_table[i][0]] );
			}else		skin_table.append( [skin_table[i][0] + (skin_fam[i][skin_set].tofloat()/skin_total)*100] );
		}

		local r = RandomFloat(0, len) * (100.0/len);

		if(!calculate){
			for(local i = 1; i <= len; i++){
				if(skin_table[i-1][0] == skin_table[i][0])continue;
				if(r < skin_table[i][0]){
					if(skin_table[i].len()==2 && ::manacat_rng_item.exceptlist.find("|"+skin_table[i][1]+"|") == null){
					//	printl("스킨 배제 코드 추가 : "+skin_table[i][1]);
						::manacat_rng_item.exceptlist += "|"+skin_table[i][1]+"|";	//배제 코드 기록
					}
					return i-1;
				}
			}
		}else{//스킨별 스폰확률 계산용 (디버그 시에만 사용되는 부분)
			print(skin_set==0?"Dirty)  ":"Clean)  ");
			for(local i = 1; i <= len; i++){
				print("["+i+"] "+(skin_table[i][0]-skin_table[i-1][0])+"％ ");
				if(skin_table[i].len()==2)print("("+skin_table[i][1]+")");
				print("   ")
			}
			printl(" ");
		}
	}

	function OnGameEvent_spawner_give_item(params){
		local player = GetPlayerFromUserID(params.userid);		if(player == null || !player.IsValid() || NetProps.GetPropIntArray( player, "m_iTeamNum", 0) != 2)return;
		::manacat_rng_item.inv_save(params.userid);
		local itemSpawn = EntIndexToHScript(params.spawner);	if(itemSpawn == null || !itemSpawn.IsValid())return;
		local invTable = {};	GetInvTable(player, invTable);
		if(params.item == "weapon_rifle_m60" || params.item == "weapon_grenade_launcher"){
			NetProps.SetPropInt(invTable.slot0, "m_nSkin", NetProps.GetPropInt(itemSpawn, "m_nSkin"));
			NetProps.SetPropInt(invTable.slot0, "m_nWeaponSkin", NetProps.GetPropInt(itemSpawn, "m_nSkin"));
			resetCurrentWeapon(params.userid);
		}else if(params.item == "weapon_chainsaw"){
			invTable.slot1.Kill();
			player.GiveItemWithSkin("weapon_chainsaw", NetProps.GetPropInt(itemSpawn, "m_nSkin"));
		}else if(params.item == "weapon_molotov" || params.item == "weapon_pipe_bomb" || params.item == "weapon_vomitjar"){
			itemSpawn.ValidateScriptScope();
			local rng = itemSpawn.GetScriptScope();
			if("rngskin" in rng)rng = RandomInt(0, rng.rngskin);
			else rng = NetProps.GetPropInt(itemSpawn, "m_nSkin");
			NetProps.SetPropInt(invTable.slot2, "m_nSkin", rng);
			::manacat_rng_item.chkThrows(player);
		}else if(params.item == "weapon_first_aid_kit" || params.item == "weapon_defibrillator" || params.item == "weapon_upgradepack_explosive" || params.item == "weapon_upgradepack_incendiary"){
			NetProps.SetPropInt(invTable.slot3, "m_nSkin", NetProps.GetPropInt(itemSpawn, "m_nSkin"));
			::manacat_rng_item.chkPacks(player);
			NetProps.SetPropInt(invTable.slot3, "m_nWeaponSkin", NetProps.GetPropInt(itemSpawn, "m_nSkin"));
		}else if(params.item == "weapon_pain_pills" || params.item == "weapon_adrenaline"){
			itemSpawn.ValidateScriptScope();
			local rng = itemSpawn.GetScriptScope();
			if("rngskin" in rng)rng = RandomInt(0, rng.rngskin);
			else rng = NetProps.GetPropInt(itemSpawn, "m_nSkin");
			NetProps.SetPropInt(invTable.slot4, "m_nSkin", rng);
			NetProps.SetPropInt(invTable.slot4, "m_nWeaponSkin", rng);
		}
		chk_golden_magnum(params.userid, itemSpawn);
		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.validSpawner("+params.spawner+")" , 0.0 , null, world);
	}

	function chk_golden_magnum(userid, entity){
		if(entity != null && entity.IsValid() && (entity.GetClassname() == "weapon_pistol_magnum_spawn" || weaponid(NetProps.GetPropInt(entity, "m_weaponID")) == "pistol_magnum") && NetProps.GetPropInt(entity, "m_nSkin") == 5){
			if(NetProps.GetPropInt(GetPlayerFromUserID(userid), "m_iTeamNum") == 2)DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.speakVocal({player = "+userid+", code = \"golden_magnum\"})" , 0.75 , null, world);
			entity.Kill();
		}
	}

	function validSpawner(spawner){
		local spawner = EntIndexToHScript(spawner);
		if(spawner == null || !spawner.IsValid())return;
		if(NetProps.GetPropInt(spawner, "m_itemCount") <= 0)spawner.Kill();
	}

	function pistolChange(userid){
		local player = GetPlayerFromUserID(userid);
		if(player == null || !player.IsValid() || NetProps.GetPropInt( player, "m_iTeamNum") != 2)return;
		local invTable = {};	GetInvTable(player, invTable);
		if("slot1" in invTable && invTable.slot1.GetClassname() == "weapon_pistol"){
			local b = RandomInt(1,::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0]);
			local s = RandomInt(0,::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][1]);
			if(NetProps.GetPropInt(invTable.slot1, "m_hasDualWeapons") == 1){
				b += RandomInt(1,::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0])*::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0];
				s += RandomInt(0,::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][1])*(::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][1]+1);
			}
			NetProps.SetPropInt(invTable.slot1, "m_nWeaponSkin", s);
			NetProps.SetPropInt(invTable.slot1, "m_nSkin", s);
			NetProps.SetPropInt(invTable.slot1, "m_nBody", b);
			if(player.GetActiveWeapon() == invTable.slot1)resetCurrentWeapon(userid);
		}
	}

	function pistolPickup(player, pistol){
		local pistols = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0];//현재 준비된 권총의 종류 수

		local skin = 0, body = 0, dual = false;
		local invTable = {};	GetInvTable(player, invTable);

		local model = pistol.GetModelName();
		if(model == "models/w_models/weapons/w_pistol_A.mdl"){
			if(NetProps.GetPropInt(pistol, "m_nBody") == 0)NetProps.SetPropInt(pistol, "m_nBody", 1);
		}else if(model == "models/w_models/weapons/w_pistol_B.mdl"){
			if(NetProps.GetPropInt(pistol, "m_nBody") == 0)NetProps.SetPropInt(pistol, "m_nBody", 2);
		}

		if("slot1" in invTable && invTable.slot1.GetClassname() == "weapon_pistol"){
			local invpistol = invTable.slot1.GetModelName();
			if(invpistol == "models/v_models/v_pistolA.mdl"){
				skin = NetProps.GetPropInt(pistol, "m_nSkin");
				body = NetProps.GetPropInt(pistol, "m_nBody");		if(body > pistols)body -= pistols;
			}else{
				skin = NetProps.GetPropInt(invTable.slot1, "m_nSkin")*3 + NetProps.GetPropInt(pistol, "m_nSkin");
				local a = NetProps.GetPropInt(invTable.slot1, "m_nBody");		local b = NetProps.GetPropInt(pistol, "m_nBody");		if(b > pistols)b -= pistols;
				body = (a*(pistols+1))	+	b;
				if(!IsPlayerABot(player)){
					dual = true;
				}
			}
		}
		player.GetScriptScope().m_hasDualWeapons <- NetProps.GetPropInt(invTable.slot1, "m_hasDualWeapons");

		NetProps.SetPropInt(invTable.slot1, "m_nSkin", skin);NetProps.SetPropInt(invTable.slot1, "m_nWeaponSkin", skin);NetProps.SetPropInt(invTable.slot1, "m_nBody", body);
		local viewmodel = NetProps.GetPropEntity(player, "m_hViewModel");NetProps.SetPropInt(viewmodel, "m_nBody", body);

		::manacat_rng_item.resetPistol(player, body, skin, dual);
		::manacat_rng_item.inv_save(player.GetPlayerUserId());
	}
	
	function OnGameEvent_player_say(params){
		local player = GetPlayerFromUserID(params.userid);
		if(player == null || !player.IsValid())return;
		local weapon = player.GetActiveWeapon();

		if(!::manacat_rng_item.debug)return;
		if(params.text == "s"){
			if("maps" in ::manacat_rng_item.sessionData){
				local maps = split(::manacat_rng_item.sessionData["maps"], "|");
				local mapslen = maps.len();
				printl("<RNG supplies> Map List");
				printl("---------------");
				for(local i = 0; i < mapslen; i++){
					printl(maps[i])
					if((maps[i]+"|ic") in ::manacat_rng_item.sessionData){printl(maps[i]+"|ic");printl(::manacat_rng_item.sessionData[maps[i]+"|ic"])}
					if((maps[i]+"|ib") in ::manacat_rng_item.sessionData){printl(maps[i]+"|ib");printl(::manacat_rng_item.sessionData[maps[i]+"|ib"])}
					if((maps[i]+"|is") in ::manacat_rng_item.sessionData){printl(maps[i]+"|is");printl(::manacat_rng_item.sessionData[maps[i]+"|is"])}
					if((maps[i]+"|ix") in ::manacat_rng_item.sessionData){printl(maps[i]+"|ix");printl(::manacat_rng_item.sessionData[maps[i]+"|ix"])}
					if((maps[i]+"|iy") in ::manacat_rng_item.sessionData){printl(maps[i]+"|iy");printl(::manacat_rng_item.sessionData[maps[i]+"|iy"])}
					if((maps[i]+"|iz") in ::manacat_rng_item.sessionData){printl(maps[i]+"|iz");printl(::manacat_rng_item.sessionData[maps[i]+"|iz"])}
					if((maps[i]+"|wm") in ::manacat_rng_item.sessionData){printl(maps[i]+"|wm");printl(::manacat_rng_item.sessionData[maps[i]+"|wm"])}
					if((maps[i]+"|wb") in ::manacat_rng_item.sessionData){printl(maps[i]+"|wb");printl(::manacat_rng_item.sessionData[maps[i]+"|wb"])}
					if((maps[i]+"|ws") in ::manacat_rng_item.sessionData){printl(maps[i]+"|ws");printl(::manacat_rng_item.sessionData[maps[i]+"|ws"])}
					if((maps[i]+"|wx") in ::manacat_rng_item.sessionData){printl(maps[i]+"|wx");printl(::manacat_rng_item.sessionData[maps[i]+"|wx"])}
					if((maps[i]+"|wy") in ::manacat_rng_item.sessionData){printl(maps[i]+"|wy");printl(::manacat_rng_item.sessionData[maps[i]+"|wy"])}
					if((maps[i]+"|wz") in ::manacat_rng_item.sessionData){printl(maps[i]+"|wz");printl(::manacat_rng_item.sessionData[maps[i]+"|wz"])}
				}
				printl("---------------");
			}
		}
		if(params.text == "z"){
			local mdls = [
				"w_models/weapons/w_eq_Medkit.mdl"
				"w_models/weapons/w_eq_incendiary_ammopack.mdl"		"w_models/weapons/w_eq_explosive_ammopack.mdl"
				"w_models/weapons/w_eq_painpills.mdl"				"w_models/weapons/w_eq_adrenaline.mdl"
				"w_models/weapons/w_eq_molotov.mdl"		"w_models/weapons/w_eq_pipebomb.mdl"	"weapons/melee/w_fireaxe.mdl"
				"weapons/melee/w_crowbar.mdl"			"weapons/melee/w_bat.mdl"				"weapons/melee/w_cricket_bat.mdl"
				"weapons/melee/w_frying_pan.mdl"		"weapons/melee/w_tonfa.mdl"				"weapons/melee/w_katana.mdl"
				"weapons/melee/w_golfclub.mdl"			"weapons/melee/w_electric_guitar.mdl"	"weapons/melee/w_machete.mdl"
				"w_models/weapons/w_knife_t.mdl"		"weapons/melee/w_pitchfork.mdl"			"weapons/melee/w_shovel.mdl"
				"weapons/melee/w_chainsaw.mdl"

				"w_models/weapons/w_pistol_A.mdl"		"w_models/weapons/w_pistol_B.mdl"		"w_models/weapons/w_desert_eagle.mdl"
				"w_models/weapons/w_smg_uzi.mdl"		"w_models/weapons/w_smg_a.mdl"			"w_models/weapons/w_smg_mp5.mdl"
				"w_models/weapons/w_shotgun.mdl"				"w_models/weapons/w_pumpshotgun_A.mdl"
				"w_models/weapons/w_autoshot_m4super.mdl"		"w_models/weapons/w_shotgun_spas.mdl"
				"w_models/weapons/w_rifle_m16a2.mdl"			"w_models/weapons/w_rifle_ak47.mdl"
				"w_models/weapons/w_desert_rifle.mdl"			"w_models/weapons/w_rifle_sg552.mdl"
				"w_models/weapons/w_sniper_mini14.mdl"		"w_models/weapons/w_sniper_military.mdl"
				"w_models/weapons/w_sniper_awp.mdl"			"w_models/weapons/w_sniper_scout.mdl"
				"w_models/weapons/w_m60.mdl"				"w_models/weapons/w_grenade_launcher.mdl"];
			for(local i = 0, len = mdls.len(); i < len; i++){
				printl(mdls[i]);
				::manacat_rng_item.skinSelect("models/"+mdls[i], 0, true);
				::manacat_rng_item.skinSelect("models/"+mdls[i], 1, true);
				printl(" ");
			}
		}
	}

	function resetPistol(player, body, skin, dual = false){
		local weapon = null;
		local viewmodel = NetProps.GetPropEntity(player, "m_hViewModel");
		if(dual){
			if(player.GetActiveWeapon().GetClassname() == "weapon_pistol")resetCurrentWeapon(player.GetPlayerUserId());
		}else{
			local invTable = {};	GetInvTable(player, invTable);
			weapon = invTable.slot1;
		}

		NetProps.SetPropInt(weapon, "m_nSkin", skin);NetProps.SetPropInt(weapon, "m_nWeaponSkin", skin);NetProps.SetPropInt(weapon, "m_nBody", body);
		NetProps.SetPropInt(viewmodel, "m_nBody", body);
	}

	function resetCurrentWeapon(userid, hideonly = false){
		local player = GetPlayerFromUserID(userid);
		if(NetProps.GetPropInt( player, "m_iTeamNum") != 2)return;
		local viewmodel = NetProps.GetPropEntity(player, "m_hViewModel");

		NetProps.SetPropIntArray( viewmodel, "m_hWeapon", 0, 0 );
		NetProps.SetPropIntArray( viewmodel, "m_nModelIndex", 0, 0 );
	
		if(hideonly)return;

		local game_ui = SpawnEntityFromTable("game_ui",
		{
			FieldOfView = "-1.0"
			spawnflags = "96"
		});
		
		DoEntFire("!self", "Activate", "", 0.0, player, game_ui);
		DoEntFire("!self", "Deactivate", "", 0.0, player, game_ui);
		DoEntFire("!self", "Kill", "", 0.0, null, game_ui);
	}

	function speakVocal(params){
		local speaker = GetPlayerFromUserID(params.player);
		local scene = speaker.GetCurrentScene();
		if(scene == null){
			local vocal = VocalSelect(params);
			speaker.PlayScene(vocal, 0.0);
		}
	}

	function VocalSelect(params){
		local vcd = "scenes/";	local pcode = "";
		switch(GetPlayerFromUserID(params.player).GetModelName()){
			case "models/survivors/survivor_gambler.mdl":		vcd += "gambler/";	pcode = "n_";	break;
			case "models/survivors/survivor_producer.mdl":		vcd += "producer/";	pcode = "r_";	break;
			case "models/survivors/survivor_coach.mdl":			vcd += "coach/";	pcode = "c_";	break;
			case "models/survivors/survivor_mechanic.mdl":		vcd += "mechanic/";	pcode = "e_";	break;
			case "models/survivors/survivor_namvet.mdl":		vcd += "namvet/";	pcode = "b_";	break;
			case "models/survivors/survivor_teenangst.mdl":		vcd += "teengirl/";	pcode = "z_";	break;
			case "models/survivors/survivor_manager.mdl":		vcd += "manager/";	pcode = "l_";	break;
			case "models/survivors/survivor_biker.mdl":			vcd += "biker/";	pcode = "f_";	break;
			default:	return false;
		}

		return vcd+::manacat_rngitem_vcd[pcode+params.code][RandomInt(0,::manacat_rngitem_vcd[pcode+params.code].len()-1)];
	}

	function OnGameEvent_weapon_drop(params){
		if(!("item" in params))return;
		local player = GetPlayerFromUserID(params.userid);		if(player == null || !player.IsValid())return;
		::manacat_rng_item.chkThrows(player);		if(NetProps.GetPropInt(player,"m_iHealth") != 0 && NetProps.GetPropFloat(player,"m_healthBuffer") != 0)::manacat_rng_item.inv_save(params.userid);
		if(params.item == "pistol"){
			local drop = EntIndexToHScript(params.propid);
			if(drop == null || !drop.IsValid())return;
			local skin = NetProps.GetPropInt(drop, "m_nSkin");	local body = NetProps.GetPropInt(drop, "m_nBody");
			local dual = null;

			local drop_pistols = [];
			
			local extra = true;		local drop_pos = player.EyePosition()-Vector(0,0,12);
			for(local pistol = null; (pistol = Entities.FindInSphere(pistol, drop_pos, 1)) != null && pistol.IsValid();){
				if(pistol.GetClassname() != "weapon_pistol" || NetProps.GetPropEntity(pistol, "m_hOwner") != null)continue;
				if((drop_pos - pistol.GetOrigin()).Length() == 0)drop_pistols.append(pistol);
			}

			local pistols = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0];//현재 준비된 권총의 종류 수
			local a_body = (body-1)/(pistols+1);				local b_body = body - (a_body*(pistols+1));
			pistols = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][1]+1;//스킨 종류 수
			local a_skin = (skin/pistols).tointeger();			local b_skin = (skin%pistols).tointeger();

			foreach(pistol in drop_pistols){
				if(!ResponseCriteria.HasCriterion(pistol, "legacy")){
					if(drop == pistol){
						local pang = RotateOrientation(player.EyeAngles(), QAngle(0, 30, 0));pang = Vector(pang.x, pang.y, pang.z);
						drop = SpawnEntityFromTable( "weapon_pistol", {skin = b_skin, origin = drop_pos, angles = pang, spawnflags = 1073741824} );
						if(drop_pistols.len() == 2)b_body += ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0];
						DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistolDropDirection(GetPlayerFromUserID("+params.userid+"), EntIndexToHScript("+drop.GetEntityIndex()+"), "+b_body+", "+b_skin+", -1)" , 0.0, null, world);
					}else{
						local pang = RotateOrientation(player.EyeAngles(), QAngle(0, -30, 0));pang = Vector(pang.x, pang.y, pang.z);
						dual = SpawnEntityFromTable( "weapon_pistol", {skin = a_skin, origin = drop_pos, angles = pang, spawnflags = 1073741824} );
						DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistolDropDirection(GetPlayerFromUserID("+params.userid+"), EntIndexToHScript("+dual.GetEntityIndex()+"), "+a_body+", "+a_skin+", 1)" , 0.0, null, world);
					}
				}
				pistol.Kill();
			}
		}
	}

	function pistolDropDirection(player, pistol, body, skin, n){
		if(player == null || !player.IsValid() || pistol == null || !pistol.IsValid())return;
		local pang = RotateOrientation(player.EyeAngles(), QAngle(0, 30*n, 0));pang = Vector(pang.x, pang.y, pang.z);
		pistol.ApplyLocalAngularVelocityImpulse(pang);
		local invTable = {};	GetInvTable(player, invTable);
		if(n == 0){
			pistol.ApplyAbsVelocityImpulse(player.EyeAngles().Forward().Scale(150));
			pistol.ApplyAbsVelocityImpulse(Vector(0, 0, 100));
		}else if("slot1" in invTable){
			pistol.ApplyAbsVelocityImpulse(player.EyeAngles().Forward().Scale(-150));
		}else{
			pistol.ApplyAbsVelocityImpulse(player.EyeAngles().Forward().Scale(400));
		}
		NetProps.SetPropInt(pistol, "m_nSkin", skin);
		NetProps.SetPropInt(pistol, "m_nWeaponSkin", skin);
		NetProps.SetPropInt(pistol, "m_nBody", body);
		NetProps.SetPropInt(pistol, "m_itemCount", 1);
	}

	function OnGameEvent_player_spawn(params){
		local player = GetPlayerFromUserID(params.userid);
		if(NetProps.GetPropInt( player, "m_iTeamNum") != 2)return;
		::manacat_rng_item.pistolChange(params.userid);
		::manacat_rng_item.chkThrows(player);
	}
	function OnGameEvent_player_team(params){
		::manacat_rng_item.chkThrows(GetPlayerFromUserID(params.userid));
	}
	function OnGameEvent_player_first_spawn(params){
		::manacat_rng_item.chkThrows(GetPlayerFromUserID(params.userid));
	}
	function OnGameEvent_player_entered_start_area(params){
		::manacat_rng_item.startflag = true;
		::manacat_rng_item.chkThrows(GetPlayerFromUserID(params.userid));

		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.CheckPlayingIntro(0)" , 0.033 , null, world);
	}
	function OnGameEvent_player_entered_checkpoint(params){
		::manacat_rng_item.startflag = true;
	}
	function OnGameEvent_player_death(params){
		if("userid" in params)inv_save(params.userid, true);
	}
	function OnGameEvent_player_transitioned(params){
		local player = GetPlayerFromUserID(params.userid);
		::manacat_rng_item.chkThrows(player);
		
		if(!::manacat_rng_item.round_first_inv_load){
			::manacat_rng_item.round_first_inv_load = true;
			RestoreTable("rngiteminv", ::manacat_rng_item.sessionInv);		SaveTable("rngiteminv", ::manacat_rng_item.sessionInv);
		}

		local who = ResponseCriteria.GetValue(player, "who").tolower()+"_act";
		if(!(who in ::manacat_rng_item.sessionInvReady))::manacat_rng_item.sessionInvReady.who <- true;

		::manacat_rng_item.inv_continuity(params.userid, 1);
	}

	function OnGameEvent_player_activate(params){
		local player = GetPlayerFromUserID(params.userid);
		if(IsPlayerABot(player))return;
		::manacat_rng_item.inv_continuity(params.userid);
	}

	function inv_save(userid, death = false, save = true){
		local player = GetPlayerFromUserID(userid);		if(player == null || !player.IsValid() || NetProps.GetPropInt( player, "m_iTeamNum") != 2)return;
		local who = ResponseCriteria.GetValue(player, "who").tolower();
		if(who == "")return;
		who += "_inv";
		local invTable = {};	GetInvTable(player, invTable);	local inv = "";
		for(local i = 0; i < 5; i++){
			if("slot"+i in invTable)inv += NetProps.GetPropInt(invTable["slot"+i], "m_nBody")+":"+NetProps.GetPropInt(invTable["slot"+i], "m_nSkin")+":"+invTable["slot"+i].GetClassname()+":"+NetProps.GetPropInt(invTable["slot"+i], "m_hasDualWeapons")+"|";
			else	inv += "-1:-1:_:-1|";
		}
		if(death){
			::manacat_rng_item.sessionInv[who+"_d_archive"] <- ::manacat_rng_item.sessionInv[who];
			local dying_inv = split(::manacat_rng_item.sessionInv[who], "|");
			local dying_secondary = split(dying_inv[1], ":");
			if(dying_secondary[2] == "weapon_pistol" && dying_secondary[3] == "1"){
				local pistols = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0];//현재 준비된 권총의 종류 수
				local a_body = (dying_secondary[0].tointeger()-1)/(pistols+1);			//	local b_body = dying_secondary[0].tointeger() - (a_body*(pistols+1));
				pistols = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][1]+1;//스킨 종류 수
				local a_skin = (dying_secondary[1].tointeger()/pistols).tointeger();	//	local b_skin = (dying_secondary[1].tointeger()%pistols).tointeger();
				dying_inv[1] = a_body+":"+a_skin+":weapon_pistol:0";
			}

			local dead_inv = "";
			for(local i = 0; i < 5; i++){
				dead_inv += dying_inv[i]+"|";
			}
			::manacat_rng_item.sessionInv[who+"_d"] <- dead_inv;
		}
		if(save)::manacat_rng_item.sessionInv[who] <- inv;
		if("slot1" in invTable){
			local viewmodel = NetProps.GetPropEntity(player, "m_hViewModel");
			NetProps.SetPropInt(viewmodel, "m_nBody", NetProps.GetPropInt(invTable.slot1, "m_nBody"));
		}
	}

	function inv_continuity(userid, order = 0){
		local player = GetPlayerFromUserID(userid);		if(player == null || !player.IsValid() || player.IsDead() || player.IsDying())return;
		if(order == 0){
			::manacat_rng_item.resetCurrentWeapon(userid, true);
			DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.inv_continuity("+userid+", 1)" , 0.033 , null, world);
		}else{
			local who = ResponseCriteria.GetValue(player, "who").tolower()+"_inv";
			if(!(who in ::manacat_rng_item.sessionInv))return;
			local invTable = {};	GetInvTable(player, invTable);	local inv = split(::manacat_rng_item.sessionInv[who], "|");
			for(local i = 0; i < 5; i++){
				if("slot"+i in invTable){
					inv[i] = split(inv[i], ":");
					if(inv[i][0].tointeger() >= 0)NetProps.SetPropInt(invTable["slot"+i], "m_nBody", inv[i][0].tointeger());
					if(inv[i][1].tointeger() >= 0)NetProps.SetPropInt(invTable["slot"+i], "m_nSkin", inv[i][1].tointeger());
				}
			}
			::manacat_rng_item.resetCurrentWeapon(userid);
			::manacat_rng_item.inv_save(userid);
		}
	}

	function OnGameEvent_defibrillator_used(params){
		local player = GetPlayerFromUserID(params.subject);
		local who = ResponseCriteria.GetValue(player, "who").tolower()+"_inv";
		if((who+"_d") in ::manacat_rng_item.sessionInv){
			::manacat_rng_item.sessionInv[who] <- ::manacat_rng_item.sessionInv[who+"_d"];
			inv_continuity(params.subject, 1);
		}
	}

	function OnGameEvent_item_pickup(params){
		local player = GetPlayerFromUserID(params.userid);
		if(NetProps.GetPropInt( player, "m_iTeamNum") != 2)return;
		::manacat_rng_item.chkThrows(player);
		player.GetScriptScope().pickup_timestamp <- Time()+5;
		if(Director.IsSessionStartMap() || (ResponseCriteria.GetValue(player, "who").tolower()+"_act") in ::manacat_rng_item.sessionInvReady){
			DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.inv_save("+params.userid+")" , 0.033 , null, world);
		}
	}
	function OnGameEvent_player_use(params){
		local player = GetPlayerFromUserID(params.userid);	if(player == null || !player.IsValid())return;
		local target = EntIndexToHScript(params.targetid);	if(target == null || !target.IsValid())return;
		local tclass = target.GetClassname(), tmodel = ResponseCriteria.GetValue(target, "weaponname"), tid = "weapon_"+weaponid(NetProps.GetPropInt(target, "m_weaponID"));
		if(tclass == "weapon_melee" || tclass == "weapon_chainsaw" || tclass == "weapon_chainsaw_spawn")return;//이거 이상한데?
		if(tclass == "weapon_pistol_spawn" || tclass == "weapon_pistol" || tid == "weapon_pistol"){
			if(player.GetScriptScope().m_hasDualWeapons <= 0){
				::manacat_rng_item.pistolPickup(player, target);
			}else{
				player.ValidateScriptScope();	local scrScope = player.GetScriptScope();
				if("weapon_switch_1" in scrScope)scrScope.weapon_switch_2 <- scrScope.weapon_switch_1;
				scrScope.weapon_switch_1 <- Time();
				DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistol_pickup_switch("+params.userid+","+params.targetid+",0)" , 0.033 , null, world);
			}
		}else{
			target.ValidateScriptScope(); local target_scrScope = target.GetScriptScope();
			local invTable = {}; GetInvTable(player, invTable);
			for(local i = 0; i < 5; i++){
				if("slot"+i in invTable){
					local mclass = invTable["slot"+i].GetClassname();
					if((mclass == tclass || mclass+"_spawn" == tclass || ((tclass == "weapon_spawn" || tclass == "weapon_melee_spawn") && mclass == tid))
					&& (NetProps.GetPropInt(invTable["slot"+i], "m_nSkin") != NetProps.GetPropInt(target, "m_nSkin") || NetProps.GetPropInt(invTable["slot"+i], "m_nBody") != NetProps.GetPropInt(target, "m_nBody"))
					&& !("rngskin" in target_scrScope)){
						player.ValidateScriptScope();	local scrScope = player.GetScriptScope();
						if("weapon_switch_1" in scrScope)scrScope.weapon_switch_2 <- scrScope.weapon_switch_1;
						scrScope.weapon_switch_1 <- Time();
						DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.item_pickup_switch("+params.userid+","+params.targetid+",0)" , 0.033 , null, world);
					}
				}
			}
		}
	}

	function hint_show(userid, code, timeout = 5, binding="", icon_offscreen="", icon_onscreen=""){
		if(!("hint" in ::manacat_rng_item)){
			local hinttbl ={
				classname = "env_instructor_hint",
				hint_allow_nodraw_target = "1",
				hint_caption = "",
				hint_color = "255 255 255",
				hint_instance_type = 1,
				hint_static = "1",
				targetname = "rng_hint",
			};
			::manacat_rng_item.hint <- g_ModeScript.CreateSingleSimpleEntityFromTable(hinttbl);
		}
		local player = GetPlayerFromUserID(userid);
		if(!("rng_item_use" in ::MANACAT) && player == GetListenServerHost())return;
		NetProps.SetPropString(::manacat_rng_item.hint, "m_iszCaption", ::manacat_rng_item_lang[code+"_"+::manacat_rng_item_lang.lang(Convars.GetClientConvarValue("cl_language", player.GetEntityIndex()))] );
		NetProps.SetPropInt(::manacat_rng_item.hint, "m_iTimeout", timeout );
		NetProps.SetPropString(::manacat_rng_item.hint, "m_iszBinding", binding );
		NetProps.SetPropString(::manacat_rng_item.hint, "m_iszIcon_Offscreen", icon_offscreen );
		NetProps.SetPropString(::manacat_rng_item.hint, "m_iszIcon_Onscreen", icon_onscreen );
		DoEntFire("!self", "ShowHint", "", 0.0, player, ::manacat_rng_item.hint);
		return;
	}

	function pistol_pickup_switch(userid, targetid, n){
		local player = GetPlayerFromUserID(userid);		if(player == null || !player.IsValid())return;
		local target = EntIndexToHScript(targetid);		if(target == null || !target.IsValid() || (NetProps.GetPropInt(target, "m_itemCount") <= 0 && target.GetClassname() == "weapon_pistol_spawn"))return;
		local invTable = {},	scrScope = player.GetScriptScope();		GetInvTable(player, invTable);
		local tgbody = NetProps.GetPropInt(target, "m_nBody"), tgskin = NetProps.GetPropInt(target, "m_nSkin");
		local mybody = NetProps.GetPropInt(invTable.slot1, "m_nBody"), myskin = NetProps.GetPropInt(invTable.slot1, "m_nSkin");
		local pistols = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][0], skins = ::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"][1]+1;//준비된 총 종류 수, 스킨의 가짓수

		if((NetProps.GetPropInt( player, "m_nButtons")&32)!=32){
			scrScope.weapon_switch_2 <- scrScope.weapon_switch_1;

			if(n == 99 && scrScope.weapon_switch_1 != 0){
				if((mybody%(pistols+1) == tgbody && myskin%skins == tgskin) && ((mybody/(pistols+1)).tointeger() == tgbody && (myskin/skins).tointeger() == tgskin))return;
				if(scrScope.pickup_timestamp < Time())::manacat_rng_item.hint_show(userid, "pistol", 4, "use", "use_binding", "use_binding");
			}else{
				DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistol_pickup_switch("+userid+","+targetid+", 99)" , 1.0 , null, world);
			}

			return;
		}else if(n > 10){
			if("weapon_switch_time" in scrScope && scrScope.weapon_switch_time+1 > Time())return;
			if(!("slot1" in invTable) || invTable.slot1.GetClassname() != "weapon_pistol")return;
			if(tgbody == 0){
				local mdl = target.GetModelName();
				if(mdl == "models/w_models/weapons/w_pistol_A.mdl")		tgbody = 1;
				else													tgbody = 2;
			}else if(tgbody > pistols){
				tgbody -= pistols;
			}
			if("weapon_switch_2" in scrScope && (scrScope.weapon_switch_1 - scrScope.weapon_switch_2) < 0.5){
				if(mybody%(pistols+1) == tgbody && myskin%skins == tgskin){		if(scrScope.pickup_timestamp < Time())::manacat_rng_item.hint_show(userid, "pistol_same_l", 2, "", "", "");	return;		}
				tgbody = mybody - (mybody%(pistols+1)) + tgbody;			tgskin = myskin - (myskin%skins) + tgskin;
				mybody = mybody%(pistols+1);								myskin = myskin%skins;
			}else{
				if((mybody/(pistols+1)).tointeger() == tgbody && (myskin/skins).tointeger() == tgskin){		if(scrScope.pickup_timestamp < Time())::manacat_rng_item.hint_show(userid, "pistol_same_r", 2, "", "", "");	return;		}
				tgbody = (tgbody*(pistols+1)) + (mybody%(pistols+1));		tgskin = (tgskin*skins) + (myskin%skins);
				mybody = mybody/(pistols+1).tointeger();					myskin = (myskin/skins).tointeger();
			}

			scrScope.weapon_switch_time <- Time();
			NetProps.SetPropInt(invTable.slot1, "m_nBody", tgbody);		NetProps.SetPropInt(invTable.slot1, "m_nSkin", tgskin);

			if(player.GetActiveWeapon() == invTable.slot1)resetCurrentWeapon(userid);
			else	player.SwitchToItem(invTable.slot1.GetClassname());

			mybody += pistols;//권총 라이트 떼주려고
			local drop_pos = player.EyePosition()-Vector(0,0,12);
			local pang = RotateOrientation(player.EyeAngles(), QAngle(0, 30, 0));pang = Vector(pang.x, pang.y, pang.z);
			local drop = SpawnEntityFromTable( "weapon_pistol", {skin = myskin, origin = drop_pos, angles = pang, spawnflags = 1073741824} );
			DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistolDropDirection(GetPlayerFromUserID("+userid+"), EntIndexToHScript("+drop.GetEntityIndex()+"), "+mybody+", "+myskin+", 0)" , 0.0, null, world);

			NetProps.SetPropInt(target, "m_itemCount", NetProps.GetPropInt(target, "m_itemCount")-1);
			if(NetProps.GetPropInt(target, "m_itemCount") <= 0)target.Kill();
			scrScope.weapon_switch_1 = 0;
			inv_save(userid);
			scrScope.pickup_timestamp <- Time()+5;
			return;
		}
		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistol_pickup_switch("+userid+","+targetid+", "+(++n)+")" , 0.033 , null, world);
	}

	function item_pickup_switch(userid, targetid, n){
		local player = GetPlayerFromUserID(userid);		if(player == null || !player.IsValid())return;
		local scrScope = player.GetScriptScope();
		if((NetProps.GetPropInt( player, "m_nButtons")&32)!=32){
			scrScope.weapon_switch_2 <- scrScope.weapon_switch_1;

			if(n == 99 && scrScope.weapon_switch_1 != 0){
				local target = EntIndexToHScript(targetid);		if(target == null || !target.IsValid())return;
				local tclass = target.GetClassname();			if(NetProps.GetPropInt(target, "m_itemCount") <= 0 && tclass.find("_spawn") != null)return;
				if(tclass.find("_spawn") != null)tclass = "weapon_"+weaponid(NetProps.GetPropInt(target, "m_weaponID"));
				local msg = "wpn";
				switch(tclass.tolower()){
					case "weapon_molotov":case "weapon_pipe_bomb":case "weapon_vomitjar":case "weapon_first_aid_kit":case "weapon_defibrillator":
					case "weapon_upgradepack_explosive":case "weapon_upgradepack_incendiary":case "weapon_pain_pills":case "weapon_adrenaline":msg = "itm";
				}
				if(scrScope.pickup_timestamp < Time())::manacat_rng_item.hint_show(userid, msg, 4, "use", "use_binding", "use_binding");
			}else{
				DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.item_pickup_switch("+userid+","+targetid+", 99)" , 1.0 , null, world);
			}

			return;
		}else if(n > 10){
			if("weapon_switch_time" in scrScope && scrScope.weapon_switch_time+1 > Time())return;
			local target = EntIndexToHScript(targetid);		if(target == null || !target.IsValid())return;
			local tclass = target.GetClassname();
			if(NetProps.GetPropInt(target, "m_itemCount") <= 0 && tclass.find("_spawn") != null)return;
			if(tclass.find("_spawn") != null)tclass = "weapon_"+weaponid(NetProps.GetPropInt(target, "m_weaponID"));
			local invTable = {};	GetInvTable(player, invTable);
			local have = -1, mclass = null;
			for(local i = 0; i < 5; i++)if("slot"+i in invTable && invTable["slot"+i].GetClassname() == tclass){have = i;mclass = invTable["slot"+have].GetClassname();break;}
			if(have == -1)return;

			local tgbody = NetProps.GetPropInt(target, "m_nBody"), tgskin = NetProps.GetPropInt(target, "m_nSkin");
			local mybody = NetProps.GetPropInt(invTable["slot"+have], "m_nBody"), myskin = NetProps.GetPropInt(invTable["slot"+have], "m_nSkin");

			scrScope.weapon_switch_time <- Time();
			NetProps.SetPropInt(invTable["slot"+have], "m_nBody", tgbody);		NetProps.SetPropInt(invTable["slot"+have], "m_nSkin", tgskin);

			if(player.GetActiveWeapon() == invTable["slot"+have])resetCurrentWeapon(userid);
			else	player.SwitchToItem(mclass);

			local drop_pos = player.EyePosition()-Vector(0,0,mclass=="weapon_melee"?16:12);
			local pang = RotateOrientation(player.EyeAngles(), mclass=="weapon_melee"?QAngle(50, 100, 0):QAngle(0, 30, 0));pang = Vector(pang.x, pang.y, pang.z);
			local spawntable = {skin = myskin, origin = drop_pos, angles = pang, spawnflags = 1073741824}
			if(mclass == "weapon_melee"){
				spawntable["melee_script_name"] <- NetProps.GetPropString(invTable["slot"+have], "m_strMapSetScriptName");
			}

			local drop = SpawnEntityFromTable( mclass, spawntable );
			
			local ammo = NetProps.GetPropIntArray( player, "m_iAmmo", NetProps.GetPropInt( invTable["slot"+have], "m_iPrimaryAmmoType" ));
			if(ammo >= 0){
				NetProps.SetPropInt( drop, "m_iExtraPrimaryAmmo", ammo);
				NetProps.SetPropInt( drop, "m_iClip1", NetProps.GetPropInt( invTable["slot"+have], "m_iClip1" ));
			}
			ammo = NetProps.GetPropInt( target, "m_iExtraPrimaryAmmo" );
			if(ammo >= 0){
				NetProps.SetPropIntArray( player, "m_iAmmo", ammo, NetProps.GetPropInt( target, "m_iPrimaryAmmoType" ));
				NetProps.SetPropInt( invTable["slot"+have], "m_iClip1", NetProps.GetPropInt( target, "m_iClip1" ));
			}

			DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.pistolDropDirection(GetPlayerFromUserID("+userid+"), EntIndexToHScript("+drop.GetEntityIndex()+"), "+mybody+", "+myskin+", 0)" , 0.0, null, world);

			NetProps.SetPropInt(target, "m_itemCount", NetProps.GetPropInt(target, "m_itemCount")-1);
			if(NetProps.GetPropInt(target, "m_itemCount") <= 0)target.Kill();
			scrScope.weapon_switch_1 = 0;
			inv_save(userid);

			EmitSoundOnClient("Player.PickupWeapon", player);
			chk_golden_magnum(userid, target);
			scrScope.pickup_timestamp <- Time()+5;
			return;
		}
		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.item_pickup_switch("+userid+","+targetid+", "+(++n)+")" , 0.033 , null, world);
	}

	function OnGameEvent_player_bot_replace(params){character_replace(params, true);}//사람을 봇으로 교체
	function OnGameEvent_bot_player_replace(params){character_replace(params, false);}//봇을 사람이 테이크오버

	function character_replace(params, botsub){
		local player = GetPlayerFromUserID(params.player);			local bot = GetPlayerFromUserID(params.bot);
		::manacat_rng_item.chkThrows(player);						::manacat_rng_item.chkThrows(bot);
		if(::manacat_rng_item.intro == 1){
			ctrl_invisible(player);									ctrl_invisible(bot);
		}

		if(botsub){
			inv_save(params.player);		inv_continuity(params.bot);
		}else{
			inv_save(params.bot);			inv_continuity(params.player);
		}
	}

	function OnGameEvent_player_disconnect(params){
		local player = GetPlayerFromUserID(params.userid);
		if(player == null || !player.IsValid() || !("GetModelName" in player))return;
		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.character_remove(\""+ResponseCriteria.GetValue(player, "who").tolower()+"\", \""+player.GetModelName()+"\")" , 0.033 , null, world);
	}

	function character_remove(who, mdl){
		local find = false;
		for(local player = null; (player = Entities.FindByClassname(player, "player")) != null && player.IsValid();){
			if(NetProps.GetPropInt( player, "m_iTeamNum") == 2 && player.GetModelName() == mdl){	find = true;	break;	}
		}
		if(find || !(who in ::manacat_rng_item.sessionInvReady) || ::manacat_rng_item.sessionInvReady[who][2] == null || !::manacat_rng_item.sessionInvReady[who][2].IsValid())return;
		::manacat_rng_item.sessionInvReady[who][2].Kill();
	}

	function chkThrows(player){
		local invTable = {};	GetInvTable(player, invTable);
		player.ValidateScriptScope();
		if("slot1" in invTable)				player.GetScriptScope().m_hasDualWeapons <- NetProps.GetPropInt(invTable.slot1, "m_hasDualWeapons");
		else if(!("slot1" in invTable))		player.GetScriptScope().m_hasDualWeapons <- -1;
		if("slot2" in invTable){
			local weapon = invTable.slot2;
			local wclass = weapon.GetClassname();
			if(wclass == "weapon_molotov" || wclass == "weapon_pipe_bomb" || wclass == "weapon_vomitjar"){
				NetProps.SetPropInt(weapon, "m_nWeaponSkin", NetProps.GetPropInt( weapon, "m_nSkin"));
				local scrScope = player.GetScriptScope();
				scrScope.throwSkin <- NetProps.GetPropInt( weapon, "m_nSkin");
			}
		}
		if("slot3" in invTable){
			local weapon = invTable.slot3;
			local wclass = weapon.GetClassname();
			if(wclass == "weapon_first_aid_kit" || wclass == "weapon_defibrillator" || wclass == "weapon_upgradepack_explosive" || wclass == "weapon_upgradepack_explosive"){
				NetProps.SetPropInt(weapon, "m_nWeaponSkin", NetProps.GetPropInt( weapon, "m_nSkin"));
			}
		}
	}

	function chkPacks(player){
		local invTable = {};	GetInvTable(player, invTable);
		if(!("slot3" in invTable))return;
		local weapon = invTable.slot3;
		local wclass = weapon.GetClassname();
		if(wclass == "weapon_first_aid_kit" || wclass == "weapon_defibrillator" || wclass == "weapon_upgradepack_explosive" || wclass == "weapon_upgradepack_incendiary"){
			NetProps.SetPropInt(weapon, "m_nWeaponSkin", NetProps.GetPropInt( weapon, "m_nSkin"));
		}
	}

	function chkLay(weapon){
		local startpos = weapon.GetOrigin();
		local endpos = startpos + weapon.GetAngles().Left().Scale(50);
		if(endpos.z < startpos.z)endpos = startpos + weapon.GetAngles().Left().Scale(-50);

		local targetNorm = Vector(endpos.x, endpos.y, endpos.z);
		targetNorm.x -= startpos.x;	targetNorm.y -= startpos.y;	targetNorm.z -= startpos.z;
		targetNorm.x = targetNorm.x/targetNorm.Norm();
		targetNorm.y = targetNorm.y/targetNorm.Norm();
		targetNorm.z = targetNorm.z/targetNorm.Norm();

		if(180/PI*acos(targetNorm.Dot(Vector(0,0,1))) < 4.0){
			//DebugDrawLine(startpos, endpos, 0, 255, 0, true, 60);
			return true;
		}
		//DebugDrawLine(startpos, endpos, 255, 0, 0, true, 60);
		return false;
	}

	function OnGameEvent_weapon_fire(params){
		if(params.weapon == "molotov" || params.weapon == "pipe_bomb" || params.weapon == "vomitjar")
			DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.throwsSkin("+params.userid+", \""+params.weapon+"\", 15)" , 0.15 , null, world); //Worldspawn
	}

	function throwsSkin(userid, throwstype, count){
		local player = GetPlayerFromUserID(userid);
		player.ValidateScriptScope();
		local scrScope = player.GetScriptScope();

		for (local ent = null; (ent = Entities.FindByClassname(ent , throwstype+"_projectile")) != null && ent.IsValid();){
			if(NetProps.GetPropEntity( ent, "m_hThrower" ) == player && ent.GetContext("throwskin") == null){
				ent.SetContext("throwskin", "chk", 15.0);
				NetProps.SetPropInt( ent, "m_nSkin", scrScope.throwSkin );return;
			}
		}
		if(--count > 0)DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.throwsSkin("+userid+", \""+throwstype+"\", "+count+")" , 0.033 , null, world);
	}

	function OnGameEvent_upgrade_pack_begin(params){
		local player = GetPlayerFromUserID(params.userid);
		local ammo = player.GetActiveWeapon();
		if(ammo != null && ammo.IsValid()){
			player.ValidateScriptScope();
			local scrScope = player.GetScriptScope();
			scrScope.ammopack <- NetProps.GetPropInt( ammo, "m_nSkin");
		}
	}

	function OnGameEvent_upgrade_pack_used(params){
		local player = GetPlayerFromUserID(params.userid);
		local ammo = EntIndexToHScript(params.upgradeid);
		if(ammo != null && ammo.IsValid()){
			player.ValidateScriptScope();
			local scrScope = player.GetScriptScope();
			if("ammopack" in scrScope)NetProps.SetPropInt( ammo, "m_nSkin", scrScope.ammopack);
		}
	}

	function OnGameEvent_round_start_post_nav(params){
		local gamemode = ::manacat_rng_item.gamemode();
		local currentTime = Time();
		RestoreTable("rngitemspawn", ::manacat_rng_item.sessionData);		RestoreTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);
		local gamerules = Entities.FindByClassname(null, "terror_gamerules");

		if((::manacat_rng_item.sessionData.len() == 0 && ::manacat_rng_item.sessionData_vs.len() == 0 ) || (gamemode == "coop" && currentTime < 10 && Director.IsSessionStartMap()) || 
		(gamemode == "versus" && currentTime < 10
		&& NetProps.GetPropInt(gamerules, "terror_gamerules_data.m_iCampaignScore.000") == 0
		&& NetProps.GetPropInt(gamerules, "terror_gamerules_data.m_iCampaignScore.001") == 0)){
			::manacat_rng_item.sessionData.clear();		::manacat_rng_item.sessionData_vs.clear();
		}

		for(local door = null; (door = Entities.FindByClassname(door,"prop_door_rotating_checkpoint")) != null && door.IsValid();){
			if(GetFlowPercentForPosition(door.GetOrigin(), false) > 90){
				door.ValidateScriptScope();
				local scrScope = door.GetScriptScope();
				scrScope["InputLock"] <- function(){
					for(local i = 2; i < 54; i++)
						for(local entity = null; (entity = Entities.FindByClassname(entity, ::manacat_rng_item.classnameList[i])) != null && entity.IsValid();)::manacat_rng_item.FixSkin(entity);
					
					return true;
				}
				door.ConnectOutput("OnBlockedClosing","InputLock");
			}
		}
	}

	function OnGameEvent_map_transition(params){
		::manacat_rng_item.sessionData_vs <- {};	SaveTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);

		for(local player = null; (player = Entities.FindByClassname(player, "player")) != null && player.IsValid();){
			if(NetProps.GetPropInt( player, "m_iTeamNum") == 2 && NetProps.GetPropInt(player,"m_lifeState") == 0){//살아있을때만
				::manacat_rng_item.inv_save(player.GetPlayerUserId());
			}
		}
		SaveTable("rngiteminv", ::manacat_rng_item.sessionInv);

		//드랍 아이템
		local landmark = ::manacat_rng_item.GetLandmark();
		if(landmark != false){
			::manacat_rng_item.sessionChkp["landmark"] <- landmark.name;
			landmark = landmark.origin;
		}
		
		local ec = "", eb = "", es = "", ews = "", ex = "", ey = "", ez = "";

		for(local i = 0; i < 54; i++){
			for(local entity = null; (entity = Entities.FindByClassname(entity, ::manacat_rng_item.classnameList[i])) != null && entity.IsValid();){
				if(NetProps.GetPropEntity(entity, "m_hOwner") == null){
					local pos = entity.GetOrigin();
				//	local location = NavMesh.GetNearestNavArea(pos, 150.0, true, true);
				//	local chkpoint = false;
				//	if(location == null)continue;
				//	if(location.HasSpawnAttributes(2048)){
						ec += entity.GetClassname() + "|";
						eb += NetProps.GetPropInt(entity, "m_nBody") + "|";	es += NetProps.GetPropInt(entity, "m_nSkin") + "|"; ews += NetProps.GetPropInt(entity, "m_nWeaponSkin") + "|";
						if(::manacat_rng_item.sessionChkp["landmark"] == "coldstream3_coldstream4"){
							ex += landmark.x+pos.x + "|";	ey += landmark.y+pos.y + "|";	ez += landmark.z+pos.z + "|";
						}else{
							ex += landmark.x-pos.x + "|";	ey += landmark.y-pos.y + "|";	ez += landmark.z-pos.z + "|";
						}
				//	}
				}
			}
		}

		::manacat_rng_item.sessionChkp["ec"] <- ec;		::manacat_rng_item.sessionChkp["eb"] <- eb;		::manacat_rng_item.sessionChkp["es"] <- es;		::manacat_rng_item.sessionChkp["ews"] <- ews;
		::manacat_rng_item.sessionChkp["ex"] <- ex;		::manacat_rng_item.sessionChkp["ey"] <- ey;		::manacat_rng_item.sessionChkp["ez"] <- ez;

		SaveTable("rngitemchkp", ::manacat_rng_item.sessionChkp);

		SaveTable("rngitemspawn", ::manacat_rng_item.sessionData);
	}

	function OnGameEvent_round_freeze_end(params){
		::manacat_rng_item.startflag = true;
		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.ResetSkinSupplies()" , 0.033 , null, world);
	}

	function ctrl_invisible(player){
		local namelist = ["gambler","nick","producer","rochelle","coach","coach","mechanic","ellis","namvet","bill","teengirl","zoey","manager","louis","biker","francis"];
		local invisible = true;
		if(Director.GetSurvivorSet() == 2){
			for(local j = 0; j < 4; j++){
				if(namelist[(j*2)+8] == ResponseCriteria.GetValue(player, "who").tolower()){
					invisible = false;
					break;
				}
			}
		}
		if(invisible)NetProps.SetPropInt(player, "m_fEffects", 32);
	}

	function CheckPlayingIntro(stat){
		switch(stat){
			case 0:
				if(::manacat_rng_item.intro != 0)return;
				::manacat_rng_item.intro = 1;
				for(local player = null; (player = Entities.FindByClassname(player, "player")) != null && player.IsValid();){
					if(NetProps.GetPropIntArray( player, "m_iTeamNum", 0) == 2 && player.IsImmobilized()){
						local invTable = {}, weapon = player.GetActiveWeapon();	GetInvTable(player, invTable);
						if(weapon != null && weapon.GetClassname() == "weapon_pistol" && "slot1" in invTable){
							local who = ResponseCriteria.GetValue(player, "who").tolower();
							local dummy = SpawnEntityFromTable( "commentary_dummy", {model = player.GetModelName(), StartingWeapons = "weapon_pistol"} );
							::manacat_rng_item.sessionInvReady[who] <- [NetProps.GetPropInt(invTable["slot1"], "m_nBody"), NetProps.GetPropInt(invTable["slot1"], "m_nSkin"), dummy];
							invTable["slot1"].Kill();

						//	local namelist = ["gambler","nick","producer","rochelle","coach","coach","mechanic","ellis","namvet","bill","teengirl","zoey","manager","louis","biker","francis"];
							for(local pos = null; (pos = Entities.FindByClassname(pos, "info_survivor_position")) != null && pos.IsValid();){
						//		local survname = "";
						//		for(local i = 0; i < 8; i++)if(namelist[i*2] == who)survname = namelist[(i*2)+1];
								if(/*NetProps.GetPropString(pos, "m_iszSurvivorName").tolower() == survname ||*/ (pos.GetOrigin() - player.GetOrigin()).Length() < 1){
									ctrl_invisible(player);
									dummy.SetOrigin(pos.GetOrigin());	dummy.SetAngles(pos.GetAngles());	break;
								}
							}

							local seq = player.GetSequence();
							local act = player.GetSequenceActivityName(seq)
							if(act == "ACT_IDLE_PISTOL" || act == "ACT_RUN_CALM_PISTOL" || act == "ACT_RUN_PISTOL")seq = player.LookupSequence("ACT_IDLE_CALM_PISTOL");//IDLE
							if(seq <= 0)seq = dummy.LookupSequence("ACT_IDLE_CALM_PISTOL");
							dummy.SetSequence(seq);
							NetProps.SetPropFloat(dummy, "m_flCycle", NetProps.GetPropFloat(player, "m_flCycle"));
							NetProps.SetPropInt(dummy, "m_flAnimTime", NetProps.GetPropInt(player, "m_flAnimTime"));
							weapon = NetProps.GetPropEntity(dummy, "m_hActiveWeapon");
							NetProps.SetPropInt(weapon, "m_nBody", ::manacat_rng_item.sessionInvReady[who][0]);
							NetProps.SetPropInt(weapon, "m_nSkin", ::manacat_rng_item.sessionInvReady[who][1]);
						}
					}
				}
				DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.CheckPlayingIntro(1)" , 0.033 , null, world);
			return;
			case 1:
				for(local player = null; (player = Entities.FindByClassname(player, "player")) != null && player.IsValid();){
					if(NetProps.GetPropIntArray( player, "m_iTeamNum", 0) == 2){
						if(player.IsImmobilized())
							DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.CheckPlayingIntro(1)" , 0.033 , null, world);
						else
							DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.CheckPlayingIntro(2)" , 0.033 , null, world);
						return;
					}
				}
			return;
			case 2:
				::manacat_rng_item.intro = 2;
				for(local player = null; (player = Entities.FindByClassname(player, "player")) != null && player.IsValid();){
					if(NetProps.GetPropIntArray( player, "m_iTeamNum", 0) == 2){
						local invTable = {};	GetInvTable(player, invTable);
						if(!("slot0" in invTable) && !("slot1" in invTable))player.GiveItem("pistol");
						local who = ResponseCriteria.GetValue(player, "who").tolower();
						if(!(who in ::manacat_rng_item.sessionInvReady) || ::manacat_rng_item.sessionInvReady[who][2] == null || !::manacat_rng_item.sessionInvReady[who][2].IsValid())continue;
						NetProps.SetPropInt(player.GetActiveWeapon(), "m_nBody", ::manacat_rng_item.sessionInvReady[who][0]);
						NetProps.SetPropInt(player.GetActiveWeapon(), "m_nSkin", ::manacat_rng_item.sessionInvReady[who][1]);
						::manacat_rng_item.sessionInvReady[who][2].Kill();
						NetProps.SetPropInt(player, "m_fEffects", 0);
						::manacat_rng_item.resetPistol(player, ::manacat_rng_item.sessionInvReady[who][0], ::manacat_rng_item.sessionInvReady[who][1], true);
					}
				}
			return;
		}
	}

	function OnGameEvent_player_left_safe_area(params){
		::manacat_rng_item.startflag = true;
		local gamemode = ::manacat_rng_item.gamemode();
		if(gamemode == "versus"){
			RestoreTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);
			SaveTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);
		}
	}

	function OnGameEvent_weapon_spawn_visible(params){
		local weapon = EntIndexToHScript(params.subject);
		local wclass = weapon.GetClassname();
		if(wclass == "weapon_first_aid_kit_spawn"
		|| wclass == "weapon_defibrillator_spawn"
		|| wclass == "weapon_upgradepack_incendiary_spawn"
		|| wclass == "upgrade_ammo_incendiary"
		|| wclass == "weapon_upgradepack_explosive_spawn"
		|| wclass == "upgrade_ammo_explosive"
		|| wclass == "weapon_pain_pills_spawn"
		|| wclass == "weapon_adrenaline_spawn"
		|| wclass == "weapon_molotov_spawn"
		|| wclass == "weapon_pipe_bomb_spawn"
		|| wclass == "weapon_vomitjar_spawn")
		NetProps.SetPropInt(weapon, "m_nWeaponSkin", -1);
	}

	function OnGameEvent_foot_locker_opened(params){
		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.foot_locker_rng()" , 0.1 , null, world); //Worldspawn
	}

	function foot_locker_rng(){
		for(local i = 8; i < 12; i++)
			for(local entity = null; (entity = Entities.FindByClassname(entity, ::manacat_rng_item.classnameList[i])) != null && entity.IsValid();)SetSkin(entity, true);
		
		local dummy = {};
		dummy["models/w_models/weapons/w_eq_painpills.mdl"] <- 3;
		dummy["models/w_models/weapons/w_eq_adrenaline.mdl"] <- 3;
		dummy["models/w_models/weapons/w_eq_molotov.mdl"] <- 14;
		dummy["models/w_models/weapons/w_eq_pipebomb.mdl"] <- 3;

		for(local i = 0; i < 3; i++)
			for(local entity = null; (entity = Entities.FindByClassname(entity, "prop_dynamic")) != null && entity.IsValid();){
				local model = entity.GetModelName();
				if(model in dummy)SetSkin(entity, true);
			}
	}

	function FixSkin(entity){
		NetProps.SetPropInt(entity, "m_nWeaponSkin", NetProps.GetPropInt( entity, "m_nSkin"));
	}

	function SetSkin(entity, dummy = false){
		if(NetProps.GetPropEntity(entity, "m_hOwner") != null)return;
		entity.ValidateScriptScope();
		local scrScope = entity.GetScriptScope();
		if("rngload" in scrScope || ("rngchk" in scrScope && !::manacat_rng_item.debug))return;
		scrScope.rngchk <- true;
	//	local nearnav = NavMesh.GetNearestNavArea(entity.GetOrigin(), 80.0, true, true);
		local body = 0, skin = ::manacat_rng_item.skinSelect(entity.GetModelName(), ::manacat_rng_item.chkLay(entity)?0:1);
		if(skin == null){if(::manacat_rng_item.debug)printl("실패 : "+entity.GetModelName());return;}
	//	if((nearnav != null && (!nearnav.HasSpawnAttributes(2048)/*checkpoint*/ || (nearnav.HasSpawnAttributes(2048) && GetFlowPercentForPosition(nearnav.GetCenter(), false) > 90))) || Director.IsSessionStartMap()){
			if(::manacat_rng_item.weaponList[entity.GetModelName()][0] != 1){
				body = RandomInt(1,::manacat_rng_item.weaponList[entity.GetModelName()][0]);
				NetProps.SetPropInt(entity, "m_nBody", body);
			}
			NetProps.SetPropInt(entity, "m_nSkin", skin);
			NetProps.SetPropInt(entity, "m_nWeaponSkin", skin);
			//NetProps.SetPropInt(entity, "m_clrRender", 65535);
	//	}

		if(!dummy){
			::manacat_rng_item.itemclass += entity.GetClassname() + "|";
			::manacat_rng_item.itembody += body + "|";			::manacat_rng_item.itemskin += skin + "|";
			local itempos = entity.GetOrigin();
			::manacat_rng_item.itemx += itempos.x + "|";		::manacat_rng_item.itemy += itempos.y + "|";		::manacat_rng_item.itemz += itempos.z + "|";
		}else{
			scrScope.rngskin <- skin;
			NetProps.SetPropInt(entity, "m_nWeaponSkin", -1);
		}
	}

	function SetSkinWeapon(entity){
		if(NetProps.GetPropEntity(entity, "m_hOwner") != null || NetProps.GetPropInt(entity, "m_nSkin") > 0 )return;
		entity.ValidateScriptScope();
		local scrScope = entity.GetScriptScope();
		if("rngload" in scrScope)return;
		scrScope.rngchk <- true;
	//	local nearnav = NavMesh.GetNearestNavArea(entity.GetOrigin(), 80.0, true, true);
		local specialskin = {};
		local body = 0, skin = ::manacat_rng_item.skinSelect(entity.GetModelName(), ::manacat_rng_item.chkLay(entity)?0:1);
		if(skin == null){if(::manacat_rng_item.debug)printl("실패 : "+entity.GetModelName());return;}
	//	if((nearnav != null && (!nearnav.HasSpawnAttributes(2048)/*checkpoint*/ || (nearnav.HasSpawnAttributes(2048) && GetFlowPercentForPosition(nearnav.GetCenter(), false) > 90))) || Director.IsSessionStartMap()){
			if(::manacat_rng_item.weaponList[entity.GetModelName()][0] != 1){
				body = RandomInt(1,::manacat_rng_item.weaponList[entity.GetModelName()][0]);
				NetProps.SetPropInt(entity, "m_nBody", body);
			}
			NetProps.SetPropInt(entity, "m_nSkin", skin);
			NetProps.SetPropInt(entity, "m_nWeaponSkin", skin);
			//NetProps.SetPropInt(entity, "m_`Render", 65535);
	//	}

		::manacat_rng_item.weaponmodel += entity.GetModelName() + "|";
		::manacat_rng_item.weaponbody += body + "|";		::manacat_rng_item.weaponskin += skin + "|";
		local itempos = entity.GetOrigin();
		::manacat_rng_item.weaponx += itempos.x + "|";		::manacat_rng_item.weapony += itempos.y + "|";		::manacat_rng_item.weaponz += itempos.z + "|";
	}

	function RestoreSkin(entity){
		entity.ValidateScriptScope();
		local scrScope = entity.GetScriptScope();
		if("rngload" in scrScope)return;
		scrScope.rngload <- true;
		local entpos = entity.GetOrigin();
		for(local i = 0; i < ::manacat_rng_item.itemlen; i++){
			if(::manacat_rng_item.itemclass[i] == entity.GetClassname()){
				local tgpos = Vector(::manacat_rng_item.itemx[i].tofloat(), ::manacat_rng_item.itemy[i].tofloat(), ::manacat_rng_item.itemz[i].tofloat());
				if((entpos-tgpos).Length() < 3){
					if(::manacat_rng_item.itembody[i] == "X"){entity.Kill();return;}
					if(::manacat_rng_item.debug)DebugDrawBoxAngles(tgpos, Vector(-15, -15, -15), Vector(15, 15, 15), QAngle(0, 0, 0), Vector(255, 0, 255), 64, 30.0);
					NetProps.SetPropInt(entity, "m_nBody", ::manacat_rng_item.itembody[i].tointeger());
					NetProps.SetPropInt(entity, "m_nSkin", ::manacat_rng_item.itemskin[i].tointeger());
					NetProps.SetPropInt(entity, "m_nWeaponSkin", ::manacat_rng_item.itemskin[i].tointeger());
					::manacat_rng_item.itembody[i] = "X";
					return;
				}
			}
		}
		return;
	}

	function RestoreSkinWeapon(entity){
		entity.ValidateScriptScope();
		local scrScope = entity.GetScriptScope();
		if("rngload" in scrScope)return;
		scrScope.rngload <- true;
		local mdl = entity.GetModelName();
		if(!(mdl in ::manacat_rng_item.weaponList))return;
		local entpos = entity.GetOrigin();
		local coord = false;
		for(local i = 0; i < ::manacat_rng_item.weaponlen; i++){
			local tgpos = Vector(::manacat_rng_item.weaponx[i].tofloat(), ::manacat_rng_item.weapony[i].tofloat(), ::manacat_rng_item.weaponz[i].tofloat());
			if((entpos-tgpos).Length() < 3){
				coord = true;
				if(::manacat_rng_item.weaponbody[i] == "X"){entity.Kill();return;}
				if(::manacat_rng_item.weaponmodel[i] == mdl){
					if(::manacat_rng_item.debug)DebugDrawBoxAngles(tgpos, Vector(-15, -15, -15), Vector(15, 15, 15), QAngle(0, 0, 0), Vector(255, 0, 255), 64, 30.0);
					NetProps.SetPropInt(entity, "m_nBody", ::manacat_rng_item.weaponbody[i].tointeger());
					NetProps.SetPropInt(entity, "m_nSkin", ::manacat_rng_item.weaponskin[i].tointeger());
					NetProps.SetPropInt(entity, "m_nWeaponSkin", ::manacat_rng_item.weaponskin[i].tointeger());
					::manacat_rng_item.weaponbody[i] = "X";
					return;
				}
			}
		}
		if(coord)entity.Kill();
		return;
	}

	function GetMapName(){
		local map = Director.GetMapName();
	
		if(map == "c4m3_sugarmill_b")map = "c4m2_sugarmill_a";
		else if(map == "c4m4_milltown_b" || map == "c4m5_milltown_escape")map = "c4m1_milltown_a";

		return [map, Director.GetMapName()];
	}

	function gamemode(){
		local mp_gamemodebase = Director.GetGameModeBase();
		local mp_gamemode = Convars.GetStr("mp_gamemode").tolower();

		if(mp_gamemodebase == "coop" || mp_gamemodebase == "realism")return "coop";
		else if(mp_gamemodebase == "versus" || mp_gamemode == "mutation15")return "versus";
		else return "coop";
	}

	function GetLandmark(){
		local landmark = "";
		for(local ent = null; (ent = Entities.FindByClassname(ent, "info_changelevel")) != null && ent.IsValid();){
			local name = NetProps.GetPropString(ent, "m_landmarkName");
			if(name != ""){	landmark = name;	break;	}
		}
		for(local ent = null; (ent = Entities.FindByClassname(ent, "info_landmark")) != null && ent.IsValid();){
			if(ent.GetName() == landmark)return {origin = ent.GetOrigin(), name = ent.GetName()};
		}

		return false;
	}

	function ResetSkinSupplies(){
		if(!::manacat_rng_item.startflag || ("itemSpawner" in ::MANACAT && !::MANACAT.itemSpawner.check)){
			DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.ResetSkinSupplies()" , 0.1 , null, world); //Worldspawn
			return;
		}

		local map = ::manacat_rng_item.GetMapName(), save = false;

		RestoreTable("rngitemchkp", ::manacat_rng_item.sessionChkp);	SaveTable("rngitemchkp", ::manacat_rng_item.sessionChkp);
		if("ec" in ::manacat_rng_item.sessionChkp){
			local landmark = null;
			for(local ent = null; (ent = Entities.FindByClassname(ent, "info_landmark")) != null && ent.IsValid();){
				if(ent.GetName() == ::manacat_rng_item.sessionChkp["landmark"]){
					landmark = ent.GetOrigin();	break;
				}
			}

			if(landmark != null){
				local ec = split(::manacat_rng_item.sessionChkp["ec"], "|"),		eb = split(::manacat_rng_item.sessionChkp["eb"], "|"),		es = split(::manacat_rng_item.sessionChkp["es"], "|"),		ews = split(::manacat_rng_item.sessionChkp["ews"], "|");
				local ex = split(::manacat_rng_item.sessionChkp["ex"], "|"),		ey = split(::manacat_rng_item.sessionChkp["ey"], "|"),		ez = split(::manacat_rng_item.sessionChkp["ez"], "|");
				local elen = ec.len();

				for(local i = 0; i < 54; i++)for(local entity = null; (entity = Entities.FindByClassname(entity, ::manacat_rng_item.classnameList[i])) != null && entity.IsValid();){
					if(NetProps.GetPropEntity(entity, "m_hOwner") == null){
						local pos = entity.GetOrigin();
						for(local j = 0; j < elen; j++){
							if(::manacat_rng_item.classnameList[i] == ec[j] && (pos - (landmark-Vector(ex[j].tofloat(), ey[j].tofloat(), ez[j].tofloat()))).Length() < 2){
								NetProps.SetPropInt(entity, "m_nBody", eb[j].tointeger());	NetProps.SetPropInt(entity, "m_nSkin", es[j].tointeger());	NetProps.SetPropInt(entity, "m_nWeaponSkin", ews[j].tointeger());
								entity.ValidateScriptScope();
								local scrScope = entity.GetScriptScope();
								scrScope.rngload <- true;
								//NetProps.SetPropInt(entity, "m_clrRender", 255);
							}
						}
					}
				}
			}
		}

		RestoreTable("rngitemspawn", ::manacat_rng_item.sessionData);	SaveTable("rngitemspawn", ::manacat_rng_item.sessionData);
		RestoreTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);	SaveTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);
		local gamemode = ::manacat_rng_item.gamemode();
		//대전이 아니라면 현재 맵 세이브 지워줌
		if(gamemode != "versus"){
			if("maps" in ::manacat_rng_item.sessionData){
				local maparray = "";
				local maps = split(::manacat_rng_item.sessionData["maps"], "|");
				local mapslen = maps.len();
				for(local i = 0; i < mapslen; i++){
					if(maps[i] != map[1])maparray += maps[i]+"|";
				}
				local maparraylen = maparray.len()-1;
				if(maparraylen > 0 && maparray[maparraylen].tochar() == "|")maparray = maparray.slice(0, maparraylen);
				::manacat_rng_item.sessionData["maps"] <- maparray;
				::manacat_rng_item.sessionData.rawdelete(map[0]);
			}
		}

		local table = "sessionData";
		if("maps" in ::manacat_rng_item.sessionData_vs)table = "sessionData_vs";

		//맵리스트에 현재 플레이중인 맵이 있으면 세이브 있는 걸로 인식
		if("maps" in ::manacat_rng_item[table]){			
			local maps = split(::manacat_rng_item[table]["maps"], "|");
			for(local i = 0, mapslen = maps.len(); i < mapslen; i++){
				if(maps[i] == map[0]){	save = true;	break;	}
			}
		}

		::manacat_rng_item.itemclass = "";		::manacat_rng_item.itembody = "";		::manacat_rng_item.itemskin = "";
		::manacat_rng_item.itemx = "";		::manacat_rng_item.itemy = "";		::manacat_rng_item.itemz = "";		::manacat_rng_item.itemlen = 0;
		::manacat_rng_item.weaponmodel = "";		::manacat_rng_item.weaponbody = "";		::manacat_rng_item.weaponskin = "";
		::manacat_rng_item.weaponx = "";		::manacat_rng_item.weapony = "";		::manacat_rng_item.weaponz = "";		::manacat_rng_item.weaponlen = 0;

		map = map[0];
		if(save){
			::manacat_rng_item.exceptlist = ::manacat_rng_item[table].exceptlist;
			::manacat_rng_item.itemclass = split(::manacat_rng_item[table][map+"|ic"], "|");		::manacat_rng_item.itembody = split(::manacat_rng_item[table][map+"|ib"], "|");		::manacat_rng_item.itemskin = split(::manacat_rng_item[table][map+"|is"], "|");
			::manacat_rng_item.itemx = split(::manacat_rng_item[table][map+"|ix"], "|");			::manacat_rng_item.itemy = split(::manacat_rng_item[table][map+"|iy"], "|");		::manacat_rng_item.itemz = split(::manacat_rng_item[table][map+"|iz"], "|");
			::manacat_rng_item.itemlen = ::manacat_rng_item.itemclass.len();
			::manacat_rng_item.weaponmodel = split(::manacat_rng_item[table][map+"|wm"], "|");	::manacat_rng_item.weaponbody = split(::manacat_rng_item[table][map+"|wb"], "|");	::manacat_rng_item.weaponskin = split(::manacat_rng_item[table][map+"|ws"], "|");
			::manacat_rng_item.weaponx = split(::manacat_rng_item[table][map+"|wx"], "|");		::manacat_rng_item.weapony = split(::manacat_rng_item[table][map+"|wy"], "|");		::manacat_rng_item.weaponz = split(::manacat_rng_item[table][map+"|wz"], "|");
			::manacat_rng_item.weaponlen = ::manacat_rng_item.weaponmodel.len();
			
			for(local i = 0; i < 2; i++)
				for(local ent = null; (ent = Entities.FindByClassname(ent, ::manacat_rng_item.classnameList[i])) != null && ent.IsValid();)RestoreSkinWeapon(ent);
			for(local i = 2; i < 54; i++)
				for(local ent = null; (ent = Entities.FindByClassname(ent, ::manacat_rng_item.classnameList[i])) != null && ent.IsValid();)RestoreSkin(ent);
		}else{
			for(local i = 0; i < 2; i++)
				for(local ent = null; (ent = Entities.FindByClassname(ent, ::manacat_rng_item.classnameList[i])) != null && ent.IsValid();)SetSkinWeapon(ent);
			for(local i = 2; i < 54; i++)
				for(local ent = null; (ent = Entities.FindByClassname(ent, ::manacat_rng_item.classnameList[i])) != null && ent.IsValid();)SetSkin(ent);
			
			::manacat_rng_item.sessionData.exceptlist <- ::manacat_rng_item.exceptlist;
			::manacat_rng_item.sessionData[map+"|ic"] <- ::manacat_rng_item.itemclass;			::manacat_rng_item.sessionData[map+"|ib"] <- ::manacat_rng_item.itembody;			::manacat_rng_item.sessionData[map+"|is"] <- ::manacat_rng_item.itemskin;
			::manacat_rng_item.sessionData[map+"|ix"] <- ::manacat_rng_item.itemx;				::manacat_rng_item.sessionData[map+"|iy"] <- ::manacat_rng_item.itemy;				::manacat_rng_item.sessionData[map+"|iz"] <- ::manacat_rng_item.itemz;
			::manacat_rng_item.sessionData[map+"|wm"] <- ::manacat_rng_item.weaponmodel;		::manacat_rng_item.sessionData[map+"|wb"] <- ::manacat_rng_item.weaponbody;			::manacat_rng_item.sessionData[map+"|ws"] <- ::manacat_rng_item.weaponskin;
			::manacat_rng_item.sessionData[map+"|wx"] <- ::manacat_rng_item.weaponx;			::manacat_rng_item.sessionData[map+"|wy"] <- ::manacat_rng_item.weapony;			::manacat_rng_item.sessionData[map+"|wz"] <- ::manacat_rng_item.weaponz;
		
			//맵 이름도 맵 리스트에 저장
			if("maps" in ::manacat_rng_item.sessionData)map = ::manacat_rng_item.sessionData["maps"]+"|"+map;
			::manacat_rng_item.sessionData["maps"] <- map;
			
			if(gamemode == "versus"){
				::manacat_rng_item.sessionData_vs.exceptlist <- ::manacat_rng_item.exceptlist;
				::manacat_rng_item.sessionData_vs[map+"|ic"] <- ::manacat_rng_item.itemclass;			::manacat_rng_item.sessionData_vs[map+"|ib"] <- ::manacat_rng_item.itembody;			::manacat_rng_item.sessionData_vs[map+"|is"] <- ::manacat_rng_item.itemskin;
				::manacat_rng_item.sessionData_vs[map+"|ix"] <- ::manacat_rng_item.itemx;				::manacat_rng_item.sessionData_vs[map+"|iy"] <- ::manacat_rng_item.itemy;				::manacat_rng_item.sessionData_vs[map+"|iz"] <- ::manacat_rng_item.itemz;
				::manacat_rng_item.sessionData_vs[map+"|wm"] <- ::manacat_rng_item.weaponmodel;			::manacat_rng_item.sessionData_vs[map+"|wb"] <- ::manacat_rng_item.weaponbody;			::manacat_rng_item.sessionData_vs[map+"|ws"] <- ::manacat_rng_item.weaponskin;
				::manacat_rng_item.sessionData_vs[map+"|wx"] <- ::manacat_rng_item.weaponx;				::manacat_rng_item.sessionData_vs[map+"|wy"] <- ::manacat_rng_item.weapony;				::manacat_rng_item.sessionData_vs[map+"|wz"] <- ::manacat_rng_item.weaponz;
				
				::manacat_rng_item.sessionData_vs["maps"] <- map;
				SaveTable("rngitemspawn_vs", ::manacat_rng_item.sessionData_vs);
			}
		}

		DoEntFire("!self", "RunScriptCode", "g_ModeScript.manacat_rng_item.ResetSkinProcess()" , 0.1 , null, world); //Worldspawn
	}
	
	function ResetSkinProcess(){
		for(local i = 2; i < 14; i++)
			for(local ent = null; (ent = Entities.FindByClassname(ent, ::manacat_rng_item.classnameList[i])) != null && ent.IsValid();)NetProps.SetPropInt(ent, "m_nWeaponSkin", -1);
	}
}

::manacat_rngitem_vcd <- {
c_golden_magnum = ["TakeMelee05" "TakeMelee06" "TakePills02" "Taunt06" "PainRelieftFirstAid02"]
n_golden_magnum = ["NiceJob10" "TakeMelee05" "Hurrah06" "MeleeWeapons18"]
e_golden_magnum = ["TakePistol02" "WorldC2M303" "WorldC2M305" "WorldC2M319" "WorldC3M145" "MeleeWeapons41" "TransitionClose11" "WorldC1M1B117" "WorldC1M1B118" "Taunt07" "World435" "WorldMisc37" "TransitionClose16" "TransitionClose17" "WorldC1M4B33" "WorldC1M4B34"]
r_golden_magnum = ["TakeFryingPan02" "TakeMelee04" "TakeMelee05" "TakeMelee07" "WorldC2M124" "GrenadeLauncher06" "MeleeResponse02" "WorldC1M2B18" "WorldC1M2B27" "WorldC1M2B28" "WorldC1M2B29" "WorldC1M2B30" "WorldC1M2B38" "WorldC1M2B45" "WorldC1M2B46" "WorldC1M2B49" "WorldC1M2B50" "WorldGenericProducer22" "WorldGenericProducer39" "WorldGenericProducer40"]
f_golden_magnum = ["generic63" "hurrah01" "hurrah02" "hurrah03" "hurrah04" "hurrah11" "hurrah16" "hurrah17" "hurrah18" "hurrah19" "hurrah20" "hurrah24" "incoming07" "laughter04" "lookhere07" "nicejob05" "nicejob13" "reactionpositive03" "safespotaheadreaction07" "takeassaultrifle01" "takeassaultrifle06" "takeautoshotgun04" "taunt05" "taunt06" "taunt07" "taunt08" "taunt09" "violenceawe02" "violenceawe07" "worldairport0322" "worldfarmhousenpc03"]
l_golden_magnum = ["hurrah01" "hurrah02" "hurrah14" "hurrah15" "hurrah16" "niceshot09" "playertransitionclose01" "playertransitionclose02" "playertransitionclose04" "reactionpositive05" "reactionpositive06" "reactionpositive07" "reactionpositive10" "taunt04" "taunt05" "violenceawe01" "violenceawe02" "violenceawe05" "violenceawe08" "violenceawe10"]
b_golden_magnum = ["gnericweaponpickup01" "nicejob08" "reactionpositive02" "reactionpositive04" "reactionpositive10" "safespotaheadreaction04" "violenceawe04" "violenceawe06"]
z_golden_magnum = ["hurrah03" "hurrah12" "hurrah17" "hurrah23" "hurrah56" "hurrah57" "reactionpositive02" "reactionpositive07" "takesubmachinegun01" "takesubmachinegun05" "violenceawe13" "genericresponses32"]
}

::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_Medkit.mdl"] <- [1,4];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_defibrillator.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_incendiary_ammopack.mdl"] <- [1,1];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_explosive_ammopack.mdl"] <- [1,1];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_painpills.mdl"] <- [1,3];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_adrenaline.mdl"] <- [1,3];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_molotov.mdl"] <- [1,14];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_pipebomb.mdl"] <- [1,3];
::manacat_rng_item.weaponList["models/w_models/weapons/w_eq_bile_flask.mdl"] <- [1,5];
::manacat_rng_item.weaponList["models/weapons/melee/w_fireaxe.mdl"] <- [1,3];
::manacat_rng_item.weaponList["models/weapons/melee/w_crowbar.mdl"] <- [1,[[100,100],[0,0,"golden_crowbar"],[100,100],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/weapons/melee/w_bat.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,100],[34,34,"sign_bat"]]];
::manacat_rng_item.weaponList["models/weapons/melee/w_cricket_bat.mdl"] <- [1,3];
::manacat_rng_item.weaponList["models/weapons/melee/w_frying_pan.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/weapons/melee/w_tonfa.mdl"] <- [1,1];
::manacat_rng_item.weaponList["models/weapons/melee/w_katana.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/weapons/melee/w_golfclub.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/weapons/melee/w_electric_guitar.mdl"] <- [1,[[100,100],[100,100],[100,100],[25,25,"signed_guitar"]]];
::manacat_rng_item.weaponList["models/weapons/melee/w_machete.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/w_models/weapons/w_knife_t.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/weapons/melee/w_pitchfork.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/weapons/melee/w_shovel.mdl"] <- [1,2];
::manacat_rng_item.weaponList["models/weapons/melee/w_chainsaw.mdl"] <- [1,3];

::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_A.mdl"] <- [4,2];
::manacat_rng_item.weaponList["models/w_models/weapons/w_pistol_B.mdl"] <- [4,2];
::manacat_rng_item.weaponList["models/w_models/weapons/w_desert_eagle.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,100],[100,100],[27,27,"golden_magnum"]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_smg_uzi.mdl"] <- [1,[[100,100],[100,0],[100,100],[100,0]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_smg_a.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,0]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_smg_mp5.mdl"] <- [1,[[100,100],[100,0],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_shotgun.mdl"] <- [1,[[100,100],[100,100],[100,0],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_pumpshotgun_A.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,100],[100,0]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_autoshot_m4super.mdl"] <- [1,[[100,100],[100,0],[100,0],[100,100],[100,0]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_shotgun_spas.mdl"] <- [1,[[100,100],[100,0],[100,100],[100,0],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_rifle_m16a2.mdl"] <- [1,[[100,100],[100,0,"rusty_m16"],[100,0,"bloody_m16"],[100,100],[100,0]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_rifle_ak47.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_desert_rifle.mdl"] <- [1,[[100,100],[100,0,"bloody_scar"],[100,100],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_rifle_sg552.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,0],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_sniper_mini14.mdl"] <- [1,[[100,100],[100,0],[100,0],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_sniper_military.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_sniper_awp.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,0]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_sniper_scout.mdl"] <- [1,[[100,100],[100,100],[100,100],[100,100]]];
::manacat_rng_item.weaponList["models/w_models/weapons/w_m60.mdl"] <- [1,1];
::manacat_rng_item.weaponList["models/w_models/weapons/w_grenade_launcher.mdl"] <- [1,1];

::manacat_rng_item.weaponList["models/w_models/weapons/w_minigun.mdl"] <- [1,1];
::manacat_rng_item.weaponList["models/w_models/weapons/50cal.mdl"] <- [1,1];

__CollectEventCallbacks(::manacat_rng_item, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);