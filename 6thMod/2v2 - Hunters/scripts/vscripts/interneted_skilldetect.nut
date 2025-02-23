/**
 * https://github.com/Tabbernaut/L4D2-Plugins/tree/master/skill_detect
 * @author Tabun, Interneted
 */

// Include Interneted's Custom Events Lib.
if(!IncludeScript("interneted_customevents")) { return; } // My lib is not installed.

printl("============================================");
printl("Executing Tabun's Skill Detect by Interneted");
printl("============================================");

::Interneted_SkillDetect_utils <-
{
    function PrintMessageToAll(messagetable)
    {
        for(local player; player = Entities.FindByClassname(player, "player");)
        {
            if(player != null && player.IsValid())
            {
                if(!IsPlayerABot(player))
                {
                    local language = "english"; // Convars.GetClientConvarValue("cl_language", survivor.GetEntityIndex());
                    foreach(key, value in messagetable)
                    {
                        if(key == language)
                        {
                            ClientPrint(player, 3, value);
                        }
                    }
                }
            }
        }
    }

    function Round(val) { return (floor((val * 100.0) + 0.5)) / 100.0; }

    Settings =
    {
        onSkeetHunter = true,
        onMeleeSkeetHunter = true,
        onDeadstopHunter = true,
        onLevelCharger = true,
        onCrownWitch = true,
        onCutSmokerTongue = true,
        onSkeetTankRock = true,
        onEatTankRock = true,
        onSelfClearSmoker = true,
        onHunterHighPounce = true,
        onSpecialTriggerCarAlarm = true,
        onShutdownBoomer = true,
        onChargerDeathCharge = true,
        onInstaClearSpecial = true,
        onChargerDeathChargeByBowl = true,
        onMeleeCrownWitch = true,
    }

	function ParseConfigFile()
	{
		local tData;

		local function SerializeSettings()
		{
			local sData = "{"
			foreach (key, val in Settings) { sData = sData + "\n\t" + key + " = " + val; }
			sData = sData + "\n}"
			StringToFile("interneted_skilldetect/settings.cfg", sData)
		}

		if (tData = FileToString("interneted_skilldetect/settings.cfg"))
		{
			try {
				tData = compilestring("return " + tData)();
				local hasMissingKey = false;
                local hasInvalidType = false;
				foreach (key, val in Settings)
				{
					if (key in tData)
					{
						local input = tData[key];
                        if(typeof(input) == "bool") { Settings[key] = input; }
                        else if(!hasInvalidType) { hasInvalidType = true; }
					}
					else if (!hasMissingKey)
					{ hasMissingKey = true; }
				}
				if (hasMissingKey || hasInvalidType)
				{ SerializeSettings(); }
			}
			catch (error) {
				SerializeSettings();
			}
		}
		else
		{
			SerializeSettings();
		}
	}

    Settings2 =
    {
        onInstaClearSpecial_maxTime = 0.75,
        onDeadstopHunter_minHeight = 0.0,
        onHunterHighPounce_minHeight = 0.0,
        onSkeetHunter_minDamage = 100.0,
        onShutdownBoomer_maxTime = 3.0,
        onHunterHighPounce_minDamage = 8.0,
        onLevelCharger_minDamage = 0.0,
    }

	function ParseConfigFile2()
	{
		local tData;

		local function SerializeSettings()
		{
			local sData = "{"
			foreach (key, val in Settings2) { sData = sData + "\n\t" + key + " = " + val; }
			sData = sData + "\n}"
			StringToFile("interneted_skilldetect/settings2.cfg", sData)
		}

		if (tData = FileToString("interneted_skilldetect/settings2.cfg"))
		{
			try {
				tData = compilestring("return " + tData)();
				local hasMissingKey = false;
                local hasInvalidType = false;
				foreach (key, val in Settings2)
				{
					if (key in tData)
					{
						local input = tData[key];
                        local types = ["integer", "float"];
                        if(types.find(typeof(input)) != null)
                        {
                            Settings2[key] = input.tofloat();
                        }
                        else if(!hasInvalidType) { hasInvalidType = true; }
					}
					else if (!hasMissingKey)
					{ hasMissingKey = true; }
				}
				if (hasMissingKey || hasInvalidType)
				{ SerializeSettings(); }
			}
			catch (error) {
				SerializeSettings();
			}
		}
		else
		{
			SerializeSettings();
		}
	}
}

Interneted_SkillDetect_utils.ParseConfigFile();
Interneted_SkillDetect_utils.ParseConfigFile2();

// Skeeting a hunter.
if(Interneted_SkillDetect_utils.Settings.onSkeetHunter)
{
    IncludeScript("interneted_customevents/onskeethunter");
    function ICEL_OnSkeetHunter::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local hunter = GetPlayerFromUserID(params.hunterid);

        local shots = params.totalshots;
        if(shots <= 0) { return; }
        if(params.totaldamage >= ::Interneted_SkillDetect_utils.Settings2.onSkeetHunter_minDamage)
        {
            local message =
            {
                english = "\x04★ " + "\x05" + survivor.GetPlayerName() + " \x01skeeted "
                + (IsPlayerABot(hunter) ? ("a hunter ") : ("\x05" + hunter.GetPlayerName() + "\x01's hunter "))
                + "\x01in \x03" + shots + " \x01shot" + ((shots > 1) ? "s" : ""),
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }
}

// Melee-skeeting a hunter.
if(Interneted_SkillDetect_utils.Settings.onMeleeSkeetHunter)
{
    IncludeScript("interneted_customevents/onmeleeskeethunter");
    function ICEL_OnMeleeSkeetHunter::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local hunter = GetPlayerFromUserID(params.hunterid);

        local message =
        {
            english = "\x04★ \x01" + (IsPlayerABot(hunter) ? ("A hunter") : ("\x05" + hunter.GetPlayerName() + "\x01"))
            + " was \x03melee-\x01skeeted by \x05" + survivor.GetPlayerName(),
        }
        Interneted_SkillDetect_utils.PrintMessageToAll(message);
    }
}

if(Interneted_SkillDetect_utils.Settings.onDeadstopHunter)
{
    IncludeScript("interneted_customevents/ondeadstophunter");
    function ICEL_OnDeadstopHunter::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local hunter = GetPlayerFromUserID(params.hunterid);
        local height = params.height;

        if(height >= ::Interneted_SkillDetect_utils.Settings2.onDeadstopHunter_minHeight)
        {
            local message =
            {
                english = "\x04★ " + "\x05" + survivor.GetPlayerName() + "\x01 deadstopped "
                + (IsPlayerABot(hunter) ? ("a hunter ") : ("\x05" + hunter.GetPlayerName() + "\x01's hunter "))
                + "(height: \x03" + height + "\x01)",
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }
}

// Leveling a charger.
if(Interneted_SkillDetect_utils.Settings.onLevelCharger)
{
    Interneted_SkillDetect_OnLevelCharger <-
    {
        // Friendship with charger_killed is over, now player_hurt is my new best friend :D, thanks m_customAbility.
        function OnGameEvent_player_hurt(params)
        {
            if(!("userid" in params && "attacker" in params && "dmg_health" in params && "weapon" in params)) { return; }
            local charger = GetPlayerFromUserID(params.userid);
            local survivor = GetPlayerFromUserID(params.attacker);
            local ability = NetProps.GetPropEntity(charger, "m_customAbility");

            if(charger == null || survivor == null) { return; }
            if(charger.IsSurvivor() || charger.GetZombieType() != 6 || !survivor.IsSurvivor() || survivor.GetZombieType() != 9) { return; }
            if(params.weapon != "melee" && params.weapon != "chainsaw") { return; }
            if(charger.GetHealth() > 0 || NetProps.GetPropInt(ability, "m_isCharging") != 1) { return; }
            local dmg = params.dmg_health + charger.GetHealth(); // Make sure the damage is equal to the charger's current health before dying.
            if(dmg >= ::Interneted_SkillDetect_utils.Settings2.onLevelCharger_minDamage)
            {
                if(dmg >= charger.GetMaxHealth()) // FULL LEVEL, impossible to do for ai chargers, lel.
                {
                    // I don't even think that I need to check if it's a player controlled-charger, but whatever.
                    local message =
                    {
                        english = "\x04★ \x05" + survivor.GetPlayerName() + "\x03 fully-leveled \x01"
                        + (IsPlayerABot(charger) ? ("a charger"): ("\x05" + charger.GetPlayerName() + "\x01's charger")),
                    }
                    Interneted_SkillDetect_utils.PrintMessageToAll(message);
                }
                else // CHIP LEVEL
                {
                    local message =
                    {
                        english = "\x04★ \x05" + survivor.GetPlayerName() + "\x03 chip-leveled \x01"
                        + (IsPlayerABot(charger) ? ("a charger "): ("\x05" + charger.GetPlayerName() + "\x01's charger "))
                        + "(\x03" + dmg + "\x01 dmg)",
                    }
                    Interneted_SkillDetect_utils.PrintMessageToAll(message);
                }
            }
       }
    }

    __CollectEventCallbacks(Interneted_SkillDetect_OnLevelCharger, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}

// Crowning a witch.
if(Interneted_SkillDetect_utils.Settings.onCrownWitch)
{
    Interneted_SkillDetect_OnCrownWitch <-
    {
        function OnGameEvent_witch_killed(params)
        {
            if(!("userid" in params && "witchid" in params && "oneshot" in params)) { return; }

            local survivor = GetPlayerFromUserID(params.userid);
            local witch = EntIndexToHScript(params.witchid);

           if(survivor == null || witch == null) { return; }
           if(!survivor.IsValid() || !witch.IsValid()) { return; }
           if(!survivor.IsSurvivor() || survivor.GetZombieType() != 9) { return; }
           if(!params.oneshot) { return; }
           local message =
           {
               english = "\x04★ \x05" + survivor.GetPlayerName() + "\x03 crowned\x01 a witch",
           }
           Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }

    __CollectEventCallbacks(Interneted_SkillDetect_OnCrownWitch, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}

// Cutting a smoker's tongue.
if(Interneted_SkillDetect_utils.Settings.onCutSmokerTongue)
{
    Interneted_SkillDetect_OnCutSmokerTongue <-
    {
        function OnGameEvent_tongue_pull_stopped(params)
        {
            if(!("userid" in params && "victim" in params && "smoker" in params && "release_type" in params && "damage_type" in params)) { return; }

            local survivor1 = GetPlayerFromUserID(params.userid);
            local survivor2 = GetPlayerFromUserID(params.victim);
            local smoker = GetPlayerFromUserID(params.smoker);

            if(survivor1 == null || survivor2 == null || smoker == null) { return; }
            if(!survivor1.IsValid() || !survivor2.IsValid() || !smoker.IsValid()){ return; }
            if(survivor1.GetZombieType() != 9 || survivor2.GetZombieType() != 9 || smoker.GetZombieType() != 1) { return; }
            if(survivor1.GetEntityIndex() == survivor2.GetEntityIndex() && (params.damage_type == 4 || params.damage_type == 67108864))
            {
                local message =
                {
                    english = "\x04★ \x05" + survivor1.GetPlayerName() + "\x03 cut"
                    + (IsPlayerABot(smoker) ? ("\x01 a smoker") : ("\x05 " + smoker.GetPlayerName() + "\x01")) + "'s tongue",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
        }
    }

    __CollectEventCallbacks(Interneted_SkillDetect_OnCutSmokerTongue, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}

// Skeeting a tank rock.
if(Interneted_SkillDetect_utils.Settings.onSkeetTankRock)
{
    IncludeScript("interneted_customevents/onskeettankrock");
    function ICEL_OnSkeetTankRock::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local message =
        {
            english = "\x04★ \x05" + survivor.GetPlayerName() + "\x03 skeeted\x01 a tank's rock",
        }
        Interneted_SkillDetect_utils.PrintMessageToAll(message);
    }
}

// Eating a tank rock.
if(Interneted_SkillDetect_utils.Settings.onEatTankRock)
{
    Interneted_SkillDetect_OnEatTankRock <-
    {
        function OnGameEvent_player_hurt(params)
        {
            if(!("userid" in params && "attacker" in params && "weapon" in params)) { return; }

            local survivor = GetPlayerFromUserID(params.userid);
            local tank = GetPlayerFromUserID(params.attacker);
            local weapon = params.weapon;

            if(survivor == null || tank == null) { return; }
            if(!survivor.IsSurvivor() || survivor.GetZombieType() != 9 || tank.IsSurvivor() || tank.GetZombieType() != 8) { return; }
            if(weapon != "tank_rock") { return; }
            local message =
            {
                english = "\x04★ \x05" + survivor.GetPlayerName() + "\x01 ate "
                + (IsPlayerABot(tank) ? ("a tank rock") : ("\x05" + tank.GetPlayerName() + "\x01's rock")),
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }

    __CollectEventCallbacks(Interneted_SkillDetect_OnEatTankRock, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}

// Self-clearing from a smoker's tongue.
if(Interneted_SkillDetect_utils.Settings.onSelfClearSmoker)
{
    IncludeScript("interneted_customevents/onclearspecial");
    function ICEL_OnClearSpecial::Interneted_SkillDetect_2(params, params2)
    {
        if(params.clearerid != params.pinnedid) { return; }
        local survivor = GetPlayerFromUserID(params.clearerid);
        local smoker = GetPlayerFromUserID(params.specialid);

        if(!survivor.IsSurvivor() || smoker.GetZombieType() != 1) { return; }
        if("damage_type" in params2)
        {
            if(params2.damage_type == 4 || params2.damage_type == 67108864) { return; }
        }

        local message =
        {
            english = "\x04★ \x05" + survivor.GetPlayerName() + "\x03 self-cleared\x01 from "
            + (IsPlayerABot(smoker) ? ("a smoker's tongue") : ("\x05" + smoker.GetPlayerName() + "\x01's tongue")),
        }
        Interneted_SkillDetect_utils.PrintMessageToAll(message);
    }
}

// High-pouncing a survivor.
if(Interneted_SkillDetect_utils.Settings.onHunterHighPounce)
{
    IncludeScript("interneted_customevents/onhunterhighpounce");
    function ICEL_OnHunterHighPounce::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local hunter = GetPlayerFromUserID(params.hunterid);
        local height = params.height;
        local damage = params.damage;

        if(damage >= ::Interneted_SkillDetect_utils.Settings2.onHunterHighPounce_minDamage
        && height >= ::Interneted_SkillDetect_utils.Settings2.onHunterHighPounce_minHeight)
        {
            local message =
            {
                english = "\x04★" + (IsPlayerABot(hunter) ? ("\x01 A hunter") : ("\x05 " + hunter.GetPlayerName() + "\x01"))
                + " high-pounced \x05" + survivor.GetPlayerName() + "\x01 (\x03" + damage + "\x01 dmg, height: \x03" + height + "\x01)",
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }
}

// A special triggering a car alarm.
if(Interneted_SkillDetect_utils.Settings.onSpecialTriggerCarAlarm)
{
    IncludeScript("interneted_customevents/onspecialtriggercaralarm");
    function ICEL_OnSpecialTriggerCarAlarm::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local special = GetPlayerFromUserID(params.specialid);

        if(IsPlayerABot(special))
        {
            local type = special.GetZombieType();
            if(type == 1) // Smoker
            {
                local message =
                {
                    english = "\x04★\x01 A smoker made \x05" + survivor.GetPlayerName() + "\x01 trigger an alarmed car",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
            else if(type == 2) // Boomer
            {
                local message =
                {
                    english = "\x04★\x01 A boomer made \x05" + survivor.GetPlayerName() + "\x01 trigger an alarmed car",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
            else if(type == 5) // Jockey
            {
                local message =
                {
                    english = "\x04★\x01 A jockey made \x05" + survivor.GetPlayerName() + "\x01 trigger an alarmed car",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
            else if(type == 6) // Charger
            {
                local message =
                {
                    english = "\x04★\x01 A charger made \x05" + survivor.GetPlayerName() + "\x01 trigger an alarmed car",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
        }
        else
        {
            local message =
            {
                english = "\x04★ \x05" + special.GetPlayerName() + "\x01 made \x05" + survivor.GetPlayerName() + "\x01 trigger an alarmed car",
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }
}

// Shutting-down a boomer.
if(Interneted_SkillDetect_utils.Settings.onShutdownBoomer)
{
    IncludeScript("interneted_customevents/onkillboomer");
    function ICEL_OnKillBoomer::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local boomer = GetPlayerFromUserID(params.boomerid);
        local totalvomitbiled = params.totalvomitbiled;
        local splashedbile = params.splashedbile;
        local timealive = params.timealive;

        if(totalvomitbiled >= 1 || splashedbile) { return; }
        if(timealive <= ::Interneted_SkillDetect_utils.Settings2.onShutdownBoomer_maxTime)
        {
            local message =
            {
                english = "\x04★ \x05" + survivor.GetPlayerName() + "\x01 has shutdown "
                + (IsPlayerABot(boomer) ? ("a boomer") : ("\x05" + boomer.GetPlayerName() + "\x01's boomer"))
                + " in \x03" + ::Interneted_SkillDetect_utils.Round(timealive),
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }
}

// Death-charging a survivor.
if(Interneted_SkillDetect_utils.Settings.onChargerDeathCharge)
{
    IncludeScript("interneted_customevents/onchargerdeathcharge");
    function ICEL_OnChargerDeathCharge::Interneted_SkillDetect(params, params2)
    {
        local charger = GetPlayerFromUserID(params.chargerid);
        local survivor = GetPlayerFromUserID(params.survivorid);
        local height = params.height;

        local message =
        {
            english = "\x04★ \x01" + (IsPlayerABot(charger) ? ("A charger") : ("\x05" + charger.GetPlayerName()))
            + "\x01 death-charged \x05" + survivor.GetPlayerName() + "\x01 (height: \x03" + height + "\x01)",
        }
        Interneted_SkillDetect_utils.PrintMessageToAll(message);
    }
}

// Insta-clearing a survivor from a special.
if(Interneted_SkillDetect_utils.Settings.onInstaClearSpecial)
{
    IncludeScript("interneted_customevents/onclearspecial");
    function ICEL_OnClearSpecial::Interneted_SkillDetect(params, params2)
    {
        local clearer = GetPlayerFromUserID(params.clearerid);
        local pinned = GetPlayerFromUserID(params.pinnedid);
        local special = GetPlayerFromUserID(params.specialid);
        local time = params.time;

        if(params.clearerid == params.pinnedid) { return; }
        if(time <= Interneted_SkillDetect_utils.Settings2.onInstaClearSpecial_maxTime)
        {
            local type = special.GetZombieType();
            if(type == 1) // SMOKER
            {
                local message =
                {
                    english = "\x04★ \x05" + clearer.GetPlayerName() + "\x03 insta-cleared \x05" + pinned.GetPlayerName() + "\x01 from "
                    + (IsPlayerABot(special) ? ("a smoker") : ("\x05" + special.GetPlayerName() + "\x01's smoker"))
                    + " (\x03" + ::Interneted_SkillDetect_utils.Round(time) + "\x01 seconds)",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
            else if(type == 3) // HUNTER
            {
                local message =
                {
                    english = "\x04★ \x05" + clearer.GetPlayerName() + "\x03 insta-cleared \x05" + pinned.GetPlayerName() + "\x01 from "
                    + (IsPlayerABot(special) ? ("a hunter") : ("\x05" + special.GetPlayerName() + "\x01's hunter"))
                    + " (\x03" + ::Interneted_SkillDetect_utils.Round(time) + "\x01 seconds)",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
            else if(type == 5) // JOCKEY
            {
                local message =
                {
                    english = "\x04★ \x05" + clearer.GetPlayerName() + "\x03 insta-cleared \x05" + pinned.GetPlayerName() + "\x01 from "
                    + (IsPlayerABot(special) ? ("a jockey") : ("\x05" + special.GetPlayerName() + "\x01's jockey"))
                    + " (\x03" + ::Interneted_SkillDetect_utils.Round(time) + "\x01 seconds)",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
            else if(type == 6) // CHARGER
            {
                local message =
                {
                    english = "\x04★ \x05" + clearer.GetPlayerName() + "\x03 insta-cleared \x05" + pinned.GetPlayerName() + "\x01 from "
                    + (IsPlayerABot(special) ? ("a charger") : ("\x05" + special.GetPlayerName() + "\x01's charger"))
                    + " (\x03" + ::Interneted_SkillDetect_utils.Round(time) + "\x01 seconds)",
                }
                Interneted_SkillDetect_utils.PrintMessageToAll(message);
            }
        }
    }
}

// Death-charging a survivor by bowling.
if(Interneted_SkillDetect_utils.Settings.onChargerDeathChargeByBowl)
{
    IncludeScript("interneted_customevents/onchargerdeathchargebybowl");
    function ICEL_OnChargerDeathChargeByBowl::Interneted_SkillDetect(params, params2)
    {
        local charger = GetPlayerFromUserID(params.chargerid);
        local survivor = GetPlayerFromUserID(params.survivorid);
        local height = params.height;

        local message =
        {
            english = "\x04★ \x01" + (IsPlayerABot(charger) ? ("A charger") : ("\x05" + charger.GetPlayerName()))
            + "\x01 death-charged \x05" + survivor.GetPlayerName() + "\x01 by bowling (height: \x03" + height + "\x01)",
        }
        Interneted_SkillDetect_utils.PrintMessageToAll(message);
    }
}

if(Interneted_SkillDetect_utils.Settings.onMeleeCrownWitch)
{
    IncludeScript("interneted_customevents/onmeleecrownwitch");
    function ICEL_OnMeleeCrownWitch::Interneted_SkillDetect(params, params2)
    {
        local survivor = GetPlayerFromUserID(params.survivorid);
        local witch = EntIndexToHScript(params.witchidx);
        if(params.survivortable.len() < 2)
        {
            local message =
            {
                english = "\x04★ \x05" + survivor.GetPlayerName() + "\x03 melee-\x01" + "crowned a witch",
            }
            Interneted_SkillDetect_utils.PrintMessageToAll(message);
        }
    }
}