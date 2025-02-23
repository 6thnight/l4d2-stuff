/**
 * parameters = {
 * hunterid = short,
 * survivorid = short,
 * distance = long,
 * height = int,
 * damage = short,
 * }
 */
if(!("ICEL_OnHunterHighPounce" in getroottable()))
{
    ::ICEL_OnHunterHighPounce <- {}
}

 ::ICEL_OnHunterHighPounce_main <-
 {
    // ! AS OF 19/11/2024, This variable is now obsolete as I thought of a better way to implement it.
    // Max value of hunter.GetOrigin().z - survivor.GetOrigin().z on lunge_pounce.
    // Multiple tests: 71.03125 is the mode, 71.0615234 is the highest.
    // Other than that, all the results are between both values.
    // * This is used for situations where the hunter pounces a survivor before even reaching the apex.
    // ? I don't think it will damage the survivor with the pounce, but it's good to add extra checks I guess.

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

    // Add custom variables to hunter scope.
    function ValidateHunterScriptScope(hunter)
    {
        if(!hunter.ValidateScriptScope()) { return false; }
        local scope = hunter.GetScriptScope();
        if(!("icel_ohhp_zpos" in scope)) { scope.icel_ohhp_zpos <- null; } // Hunter's zpos.
        if(!("icel_ohhp_apex" in scope)) { scope.icel_ohhp_apex <- false; } // Has hunter reached apex.
        return true;
    }

    function OnGameEvent_ability_use(params)
    {
        if(!("userid" in params && "ability" in params)) { return; }

        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(hunter, 3) || params.ability != "ability_lunge") { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        scope.icel_ohhp_zpos = hunter.GetOrigin().z;
        scope.icel_ohhp_apex = false;
    }

    function OnGameEvent_lunge_pounce(params)
    {
        if(!("userid" in params && "victim" in params && "distance" in params && "damage" in params)) { return; }

        local hunter = GetPlayerFromUserID(params.userid);
        local survivor = GetPlayerFromUserID(params.victim);

        if(!IsPlayer(hunter, 3) || !IsPlayer(survivor, 9) || params.damage < 1) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        if(scope.icel_ohhp_zpos == null) { return; }
        if(!scope.icel_ohhp_apex) // If the hunter is not pouncing in a parabolic way and player_jump_apex does not fire.
        // There's 2 ways to pounce a survivor without reaching apex, from the bottom and from the top.
        // We will only update zpos when the hunter is pouncing from the bottom.
        { if(scope.icel_ohhp_zpos < hunter.GetOrigin().z) { scope.icel_ohhp_zpos = hunter.GetOrigin().z; } }

        local resultHeight = scope.icel_ohhp_zpos - survivor.GetOrigin().z;
        if(resultHeight < 0.0) { resultHeight = 0.0; }

        /**
         * @main
         */
        local parameters =
        {
            survivorid = params.victim,
            hunterid = params.userid,
            distance = params.distance,
            height = resultHeight.tointeger(),
            damage = params.damage,
        }
        local p = clone params;
        p.event <- "lunge_pounce";
        foreach(func in ::ICEL_OnHunterHighPounce) { func(parameters, p); }
        // Delete.
        scope.icel_ohhp_zpos = null;
        scope.icel_ohhp_apex = false;
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
            // Delete.
            scope.icel_ohhp_zpos = null;
            scope.icel_ohhp_apex = false;
        }
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
            // Delete.
            scope.icel_ohhp_zpos = null;
            scope.icel_ohhp_apex = false;
        }
        else
        {
            scope.icel_ohhp_zpos = hunter.GetOrigin().z;
            scope.icel_ohhp_apex = true;
        }
    }

    function OnGameEvent_player_death(params)
    {
       if(!("userid" in params)) { return; }
       local hunter = GetPlayerFromUserID(params.userid);
       if(!IsPlayer(hunter, 3)) { return; }
       if(!ValidateHunterScriptScope(hunter)) { return; }
       local scope = hunter.GetScriptScope();
       // Delete.
       scope.icel_ohhp_zpos = null;
       scope.icel_ohhp_apex = false;
    }

    // * a hunter will stop pouncing on player_bot_replace
 }

 __CollectEventCallbacks(::ICEL_OnHunterHighPounce_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);