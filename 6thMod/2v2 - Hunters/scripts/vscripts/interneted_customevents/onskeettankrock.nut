/**
 * parameters = {
 * survivorid = short,
 * extra = params
 * }
 */
if(!("ICEL_OnSkeetTankRock" in getroottable()))
{
    ::ICEL_OnSkeetTankRock <- {}
}

/**
 * I wasn't going to do this, but apparently OnGameEvent_tank_rock_killed
 * can be triggered multiple times when hitting the rock sometimes.
 * Most notably with shotguns and melees.
 */

::ICEL_OnSkeetTankRock_main <-
{
    function OnGameEvent_weapon_fire(params)
    {
        if(!("userid" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        if(survivor == null) { return; }
        if(!survivor.IsValid()) { return; }
        if(survivor.GetZombieType() != 9 || !survivor.IsSurvivor()) { return; }

        if(!survivor.ValidateScriptScope()) { return; }
        local scope = survivor.GetScriptScope();
        if(!("icel_ostr" in scope)) { scope.icel_ostr <- true; }
        scope.icel_ostr = true;
    }

    function OnGameEvent_tank_rock_killed(params)
    {
        if(!("userid" in params)) { return; }

        local survivor = GetPlayerFromUserID(params.userid);
        if(survivor == null) { return; }
        if(!survivor.IsValid()) { return; }
        if(!survivor.IsSurvivor() || survivor.GetZombieType() != 9) { return; }

        if(!survivor.ValidateScriptScope()) { return; }
        local scope = survivor.GetScriptScope();
        if(!("icel_ostr" in scope)) { scope.icel_ostr <- true; }
        if(scope.icel_ostr)
        {
            local parameters =
            {
                survivorid = params.userid,
            }
            local p = clone params;
            p.event <- "tank_rock_killed";
            foreach(func in ::ICEL_OnSkeetTankRock) { func(parameters, p); }
            scope.icel_ostr = false; // Delete.
        }
    }
}

__CollectEventCallbacks(::ICEL_OnSkeetTankRock_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);