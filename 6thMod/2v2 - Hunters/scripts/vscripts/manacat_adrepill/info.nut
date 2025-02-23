local scrver = 20250104;
if (!("manacatInfo" in getroottable()) || !("ver" in ::manacatInfo) || ::manacatInfo.ver < scrver){
	::manacatInfo<-{
		ver = scrver
		function OnGameEvent_player_connect(params){
			if(!("name" in params) || !("networkid" in params))return;
			if(params.networkid != "BOT"){
				local p = null;
				while (p = Entities.FindByClassname(p, "player")){
					if(p != null && p.IsValid()){
						local msg = Convars.GetClientConvarValue("cl_language", p.GetEntityIndex());
						switch(msg){
							case "korean":case "koreana":	msg = params["name"]+" 님이 게임에 참가하고 있습니다.";break;
							case "japanese":				msg = "プレイヤー "+params["name"]+" がゲームに参加しています";break;
							case "spanish":					msg = "El jugador "+params["name"]+" se está uniendo a la partida";break;
							case "schinese":				msg = "玩家 "+params["name"]+" 正在加入游戏";break;//간체
							case "tchinese":				msg = "玩家 "+params["name"]+" 正在加入遊戲";break;//번체
							case "russian":					msg = "Игрок "+params["name"]+" вступает в игру";break;
							case "thai":					msg = "ผู้เล่น "+params["name"]+" กำลังเข้าเกม";break;
							case "polish":					msg = "Gracz "+params["name"]+" łączący się do gry";break;
							case "german":					msg = "Spieler "+params["name"]+" tritt dem Spiel bei";break;
							case "italian":					msg = "Il giocatore "+params["name"]+" si sta unendo alla partita";break;
							case "french":					msg = "Le joueur "+params["name"]+" rejoint la partie";break;
							case "portuguese":				msg = params["name"]+" está entrando na partida";break;
							case "brazilian":				msg = params["name"]+" está entrando no partida";break;
							case "dutch":					msg = "Speler "+params["name"]+" doet mee aan het spel";break;
							case "vietnamese":				msg = params["name"]+" đang vào trận";break;
							default:						msg = "Player "+params["name"]+" is joining the game";break;
						}
						ClientPrint(p, 5, "\x01"+msg);
					}
				}
			}
		}

		function OnGameEvent_player_say(params){
			local player = GetPlayerFromUserID(params.userid);
			local chat = params.text.tolower();
			chat = split(chat," ");
			local chatlen = chat.len();
			if(chatlen > 0){
				switch(chat[0]){
					case "!addon" : case "!add-on" : case "!mod" : case "!info" :
						local msg = Convars.GetClientConvarValue("cl_language", player.GetEntityIndex());
						switch(msg){
							case "korean":case "koreana":	msg = "이 세션에 적용된 애드온 목록입니다.";break;
							case "japanese":				msg = "このセッションに適用されたアドオンのリストです。";break;
							case "spanish":					msg = "Lista de add-ons aplicados a esta sesión.";break;
							case "schinese":				msg = "适用于此会话的附加组件列表。";break;
							case "tchinese":				msg = "適用於此會話的附加組件列表。";break;
							case "russian":					msg = "Список дополнений активных в этом сеансе.";break;
							case "thai":					msg = "รายการม็อดต่อไปนี้จะถูกใช้งานในด่านนี้.";break;
							case "polish":					msg = "Lista Addonow Dodana w Tej Sesji";break;
							case "german":					msg = "Liste von add-ons die angewendet werden in der sitzung";break;
							case "italian":					msg = "Lista di add-on attivi in questa sessione.";break;
							case "french":					msg = "Liste des add-ons appliqués à cette session.";break;
							case "portuguese":				msg = "Lista de add-ons adicionados/aplicados nesta sessão.";break;
							case "brazilian":				msg = "Lista de conteúdos personalizados aplicados para essa sessão.";break;
							case "dutch":					msg = "Lijst van uitbreidingen toegepast op deze sessie.";break;
							case "vietnamese":				msg = "Danh sách add-ons áp dụng trong trận này.";break;
							default:						msg = "List of add-ons applied to this session.";break;
						}
						ClientPrint(player, 5, "\x03"+msg);
						local slotn = 0;
						for(local i = 0; i < 8; i++){
							for(local j = 1; j <= ::MANACAT["category"+i][0]; j++){
								::MANACAT[::MANACAT["category"+i][j]].Title(player);	slotn++;
							}
						}
					break;
				}
			}
		}
	}

	__CollectEventCallbacks(::manacatInfo, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}