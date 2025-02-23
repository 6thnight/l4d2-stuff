/**
 * parameters = {
 * survivorid = short,
 * boomerid = short,
 * totalvomitbiled, int,
 * splashedbile = bool,
 * timealive = float,
 * }
 */
if(!("ICEL_OnKillBoomer" in getroottable()))
{
    ::ICEL_OnKillBoomer <- {}
}

// Game event order -> boomer_exploded, player_now_it
::ICEL_OnKillBoomer_main <-
{
    // Check validation of the player entity.
    function IsPlayer(player, zombieType)
    {
        if(player != null)
        {
            if(player.IsValid())
            {
                return (player.GetZombieType() == zombieType);
            }
        }
        return false;
    }

    function OnGameEvent_player_spawn(params)
    {
        if("userid" in params)
        {
            local boomer = GetPlayerFromUserID(params.userid);
            if(!IsPlayer(boomer, 2)) { return; }
            if(boomer.ValidateScriptScope())
            {
                local scope = boomer.GetScriptScope();
                scope.icel_okb_time <- Time();
            }
        }
    }

    function OnGameEvent_player_now_it(params)
    {
        if(!("userid" in params && "attacker" in params && "exploded" in params && "by_boomer" in params)) { return; }

        local survivor = GetPlayerFromUserID(params.userid);
        local boomer = GetPlayerFromUserID(params.attacker);
        local by_boomer = params.by_boomer;
        local exploded = params.exploded;

        if(!IsPlayer(boomer, 2) || !IsPlayer(survivor, 9)) { return; }
        if(by_boomer != 1) { return; }
        if(exploded != 0) { return;}

        if(boomer.ValidateScriptScope())
        {
            local scope = boomer.GetScriptScope();
            if(!("icel_okb" in scope)) { scope.icel_okb <- 0; }
            scope.icel_okb += 1;
        }
    }

    function OnGameEvent_boomer_exploded(params)
    {
        if("userid" in params && "attacker" in params && "splashedbile" in params) { } else { return; }

        local survivor = GetPlayerFromUserID(params.attacker);
        local boomer = GetPlayerFromUserID(params.userid);

        if(!IsPlayer(boomer, 2) || !IsPlayer(survivor, 9)) { return; }

        if(boomer.ValidateScriptScope())
        {
            local scope = boomer.GetScriptScope();
            local time = Time() - scope.icel_okb_time;
            /**
             * @main
             */
            local parameters =
            {
                survivorid = params.attacker,
                boomerid = params.userid,
                totalvomitbiled = ("icel_okb" in scope) ? scope.icel_okb : 0,
                splashedbile = params.splashedbile == 1 ? true : false,
                timealive = time < 0.0 ? 0.0 : time,
            }
            local p = clone params;
            p.event <- "boomer_exploded";
            foreach(func in ::ICEL_OnKillBoomer) { func(parameters, p); }
            scope.icel_okb <- 0; // Delete.
        }
    }

    // Revamp #2
    function OnGameEvent_player_bot_replace(params)
    {
        if(!("player" in params && "bot" in params)) { return; }
        local player = GetPlayerFromUserID(params.player);
        local bot = GetPlayerFromUserID(params.bot);
        if(!IsPlayer(player, 2) || !IsPlayer(bot, 2)) { return; }
        if(bot.ValidateScriptScope() && player.ValidateScriptScope())
        {
            local bot_scope = bot.GetScriptScope();
            local player_scope = player.GetScriptScope();
            if("icel_okb_time" in player_scope) { bot_scope.icel_okb_time <- player_scope.icel_okb_time; }
            // Don't do anything with icel_okb.
        }
    }
}

__CollectEventCallbacks(::ICEL_OnKillBoomer_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);