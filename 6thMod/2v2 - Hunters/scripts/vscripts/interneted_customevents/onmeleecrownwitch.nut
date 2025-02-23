/**
 * parameters = {
 * survivorid = short,
 * witchidx = short,
 * totaldamage = int,
 * totalhits = int,
 * player_death = table
 * survivortable = table
 * }
*/

if(!("ICEL_OnMeleeCrownWitch" in getroottable()))
{
    ::ICEL_OnMeleeCrownWitch <- {}
}

::ICEL_OnMeleeCrownWitch_main <-
{
    function GetSurvivorInList(survTable, survivor)
    {
        foreach(i, player in survTable)
        {
            if(player.entity == survivor) { return player; }
        }

        local key = "player" + survTable.len();
        survTable[key] <-
        {
            entity = survivor,
            totaldamage = 0,
            totalhits = 0,
        }
        return survTable[key];
    }
    function UpdateSurvivorTable(survivor, witch, damage)
    {
        local scope = witch.GetScriptScope();
        if(!("icel_omcw_survtable" in scope)) { scope.icel_omcw_survtable <- {}; }
        if(scope.icel_omcw_survtable == null) { return; }

        local player = GetSurvivorInList(scope.icel_omcw_survtable, survivor);
        if(damage == null) { player.totalhits += 1; }  // Add totalhits when damage is null.
        else { player.totaldamage += damage; } // Otherwise add totaldamage, type always int.
    }

    // ! infected_death doesn't return infected_id for the witch.
    function OnGameEvent_infected_hurt(params)
    {
        if(!("entityid" in params && "amount" in params)) { return; }
        local witch = EntIndexToHScript(params.entityid);
        if(witch == null) { return; }
        if(!witch.IsValid()) { return; }
        if(witch.GetClassname() != "witch") { return; }
        local amount = params.amount;
        if(amount <= 0) { return; }
        if(witch.ValidateScriptScope())
        {
            // From here, if the requirements aren't met,
            // the witch didn't took damage from survivor's melee weapon,
            // resulting in a fail crown.
            if("attacker" in params && "type" in params)
            {
                local survivor = GetPlayerFromUserID(params.attacker);
                local type = params.type;
                if(survivor != null)
                {
                    if(survivor.IsValid())
                    {
                        // melee and chainsaw.
                        if(survivor.IsSurvivor() && ((type & (1 << 21)) > 0 || (type & (1 << 26)) > 0))
                        {
                            if(witch.GetHealth() < amount) { amount = witch.GetHealth(); }
                            UpdateSurvivorTable(survivor, witch, amount);
                            UpdateSurvivorTable(survivor, witch, null);
                            return;
                        }
                    }
                }
            }
            witch.GetScriptScope().icel_omcw_survtable <- null;
        }
    }

    // witch is considered a player, i get it.
    function OnGameEvent_player_death(params)
    {
        if(!("entityid" in params)) { return; }
        local witch = EntIndexToHScript(params.entityid);
        if(witch == null) { return; }
        if(!witch.IsValid()) { return; }
        if(witch.GetClassname() != "witch") { return; }
        if(witch.ValidateScriptScope())
        {
            witch.GetScriptScope().icel_omcw_player_death <- clone params;
        }
    }

    // ? infected_death doesn't return infected_id?
    function OnGameEvent_witch_killed(params)
    {
        if(!("userid" in params && "witchid" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local witch = EntIndexToHScript(params.witchid);
        if(survivor == null || witch == null) { return; }
        if(!survivor.IsValid() || !witch.IsValid()) { return; }
        if(!survivor.IsSurvivor() || witch.GetClassname() != "witch") { return; }
        if(witch.ValidateScriptScope())
        {
            local scope = witch.GetScriptScope();
            if("icel_omcw_player_death" in scope)
            {
                if("icel_omcw_survtable" in scope)
                {
                    if(scope.icel_omcw_survtable != null)
                    {
                        /**
                         * @main
                         */
                        local result = GetSurvivorInList(scope.icel_omcw_survtable, survivor);
                        local parameters =
                        {
                            survivorid = params.userid,
                            witchidx = params.witchid,
                            totaldamage = result.totaldamage,
                            totalhits = result.totalhits,
                            player_death = clone scope.icel_omcw_player_death,
                            survivortable = scope.icel_omcw_survtable,
                        }

                        local p = clone params;
                        p.event <- "witch_killed";
                        foreach(func in ::ICEL_OnMeleeCrownWitch) { func(parameters, p); }
                    }
                    delete scope.icel_omcw_survtable;
                }
                delete scope.icel_omcw_player_death;
            }
        }
    }

    // Originally I want to make the crown fails when the witch successfully incaps a survivor.
    // but the original crown mechanic doesn't do this, so imma let it slide. ¯\_(ツ)_/¯
}

__CollectEventCallbacks(::ICEL_OnMeleeCrownWitch_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);