/**
 * parameters = {
 * survivorid = short,
 * hunterid = short,
 * height = int,
 * }
 */
if(!("ICEL_OnDeadstopHunter" in getroottable()))
{
    ::ICEL_OnDeadstopHunter <- {}
}

/**
 * * I would love to have VScripters to give me some suggestions on this, because I can't find any better way.
 * ! now before you do, here are a few things to consider:
 * - award_earned for DEAD-STOP does not fire when any survivors haven't left the safe area.
 * - player_shoved sometimes give undesired results on the hunter's netprops.
 * - normally player_shoved should fire first before award_earned, I have an idea to store the last shoved hunter on player_shoved, however
 *   upon map transition, there's a chance that the order of the event swaps for whatever reason, no idea what's causing it
 *   this forces me to use a think function.
 */

// I have no choice but to use this. :(
if(!("Interneted_FastestThinkFunctions" in getroottable()))
{
    ::Interneted_FastestThinkFunctions <- {};
}

 ::ICEL_OnDeadstopHunter_main <-
 {
    // ! OBSOLETE
    // Max value of hunter.GetOrigin().z - survivor.GetOrigin().z on lunge_pounce.
    // Multiple tests: 71.03125 is the mode, 71.0615234 is the highest.
    // Other than that, all the results are between both values.
    // Seems all my results on player_shoved are 71.03125 using HSTM.

    // survivorMaxHeight = 72.0,

    // Check validation of the player entity.
    function IsPlayer(player, zombieType)
    {
        if(player != null)
        {
            if(player.IsValid())
            { return (player.GetZombieType() == zombieType); }
        }
        return false;
    }

    function ClearInfo(scope)
    {
        scope.icel_odsh_zpos = null;
        scope.icel_odsh_apex = false;
    }

    function ClearInfoOnEvent(params)
    {
        if(!("userid" in params)) { return; }
        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();

        ClearInfo(scope);
    }

    // * HUNTER
    // Add custom variables to hunter scope.
    function ValidateHunterScriptScope(hunter)
    {
        if(!hunter.ValidateScriptScope()) { return false; }
        local scope = hunter.GetScriptScope();
        if(!("icel_odsh_zpos" in scope)) { scope.icel_odsh_zpos <- null; } // Hunter's zpos.
        if(!("icel_odsh_apex" in scope)) { scope.icel_odsh_apex <- false; } // Has hunter reached apex.
        return true;
    }

    function OnGameEvent_ability_use(params)
    {
        if(!("userid" in params && "ability" in params)) { return; }

        local hunter = GetPlayerFromUserID(params.userid);
        local lunge = params.ability;

        if(!IsPlayer(hunter, 3) || lunge != "ability_lunge") { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        scope.icel_odsh_zpos = hunter.GetOrigin().z;
        scope.icel_odsh_apex = false;
    }

    function OnGameEvent_player_jump_apex(params)
    {
        if(!("userid" in params)) { return; }
        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        if(NetProps.GetPropInt(hunter, "m_isAttemptingToPounce") != 1) // Jumping.
        {
            ClearInfo(scope);
        }
        else
        {
            scope.icel_odsh_zpos = hunter.GetOrigin().z;
            scope.icel_odsh_apex = true;
        }
    }

    function OnGameEvent_player_jump(params)
    {
        if(!("userid" in params)) { return; }
        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        if(NetProps.GetPropInt(hunter, "m_isAttemptingToPounce") != 1) // Jumping.
        {
            ClearInfo(scope);
        }
    }

    function OnGameEvent_lunge_pounce(params)
    {
        ClearInfoOnEvent(params);
    }

    function OnGameEvent_player_death(params)
    {
        ClearInfoOnEvent(params);
    }

    function OnGameEvent_pounce_end(params)
    {
        ClearInfoOnEvent(params);
    }

    function Thinker()
    {
        function Interneted_FastestThinkFunctions::ICEL_ODSH()
        {
            for (local hunter; hunter = Entities.FindByClassname(hunter, "player");)
            {
                if(!hunter.IsValid()) { continue; }
                if(hunter.GetZombieType() != 3) { continue; }

                if(NetProps.GetPropInt(hunter, "m_isAttemptingToPounce") != 1)
                {
                    if(!::ICEL_OnDeadstopHunter_main.ValidateHunterScriptScope(hunter)) { continue; }
                    local scope = hunter.GetScriptScope();
                    local ground = NetProps.GetPropEntity(hunter, "m_hGroundEntity");
                    if(ground != null)
                    {
                        if(ground.IsPlayer() && scope.icel_odsh_zpos != null)
                        {
                            if(!ground.IsSurvivor())
                            { ::ICEL_OnDeadstopHunter_main.ClearInfo(scope); }
                        }
                        else
                        { ::ICEL_OnDeadstopHunter_main.ClearInfo(scope); }
                    }
                }
            }
        }

        if(Entities.FindByName(null, "interneted_fastestthink")) { return; }

        local interneted_fastestthink = SpawnEntityFromTable("info_target", {targetname = "interneted_fastestthink"});
        if(interneted_fastestthink.ValidateScriptScope())
        {
            interneted_fastestthink.GetScriptScope()["FastestThink"] <- function()
            {
                foreach(func in Interneted_FastestThinkFunctions) { func(); }
                return 0.01;
            }
            AddThinkToEnt(interneted_fastestthink, "FastestThink");
        }
    }

    function FireCustomEvent(Sid, Hid, survivor, hunter, scope, params)
    {
        if(scope.icel_odsh_zpos != null)
        {
            if(!scope.icel_odsh_apex)
            { if(scope.icel_odsh_zpos < hunter.GetOrigin().z) { scope.icel_odsh_zpos = hunter.GetOrigin().z; }}

            local resultHeight = scope.icel_odsh_zpos - survivor.GetOrigin().z;
            if(resultHeight < 0.0) { resultHeight = 0.0; }
            /**
             * @main
             */
            local parameters =
            {
                survivorid = Sid,
                hunterid = Hid,
                height = resultHeight.tointeger(),
            }
            foreach(func in ::ICEL_OnDeadstopHunter) { func(parameters, params); }
        }
    }

    // ? Every time a map is loaded the order of player_shoved -> award_earned may switch?
    // I swear it happened to me at one time, but it never happen again.
    function OnGameEvent_player_shoved(params)
    {
        if(!("userid" in params && "attacker" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.attacker);
        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(survivor, 9) || !IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        // generic case.
        local p = clone params;
        p.event <- "player_shoved";
        if(NetProps.GetPropEntity(hunter, "m_hGroundEntity") == null && NetProps.GetPropInt(hunter, "m_isAttemptingToPounce") == 1)
        {
            FireCustomEvent(params.attacker, params.userid, survivor, hunter, scope, p);
        }
        else if(scope.icel_odsh_zpos != null)
        {
            FireCustomEvent(params.attacker, params.userid, survivor, hunter, scope, p);
        }
        ClearInfo(scope);
    }

    // player_shoved kinda fires first, so this is kind of pointless, but imma just add it anyway.
    // * Okay, nevermind sometimes player_shoved doesn't give the desired properties of the hunter, so this is a plus.
    function OnGameEvent_hunter_punched(params)
    {
        if(!("userid" in params && "hunteruserid" in params && "islunging" in params)) { return; }
        if(params.islunging != 1) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local hunter = GetPlayerFromUserID(params.hunteruserid);
        if(!IsPlayer(survivor, 9) || !IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();

        if(params.islunging == 1)
        {
            local p = clone params;
            p.event <- "hunter_punched";
            FireCustomEvent(params.userid, params.hunteruserid, survivor, hunter, scope, p);
        }
        ClearInfo(scope);
    }

    // * a hunter will stop pouncing on player_bot_replace
}

::ICEL_OnDeadstopHunter_main.Thinker();
__CollectEventCallbacks(::ICEL_OnDeadstopHunter_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);