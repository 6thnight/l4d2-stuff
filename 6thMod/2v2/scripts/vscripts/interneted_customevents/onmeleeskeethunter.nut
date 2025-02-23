/**
 * parameters = {
 * survivorid = short,
 * hunterid = short,
 * totaldamage = int,
 * totalhits = int,
 * extra = table
 * }
 */
if(!("ICEL_OnMeleeSkeetHunter" in getroottable()))
{
    ::ICEL_OnMeleeSkeetHunter <- {}
}

::ICEL_OnMeleeSkeetHunter_main <-
{
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

    // Add a custom variable to hunter scope.
    function ValidateHunterScriptScope(hunter)
    {
        if(!hunter.ValidateScriptScope()) { return false; }
        local scope = hunter.GetScriptScope();
        if(!("icel_omsh_survtable" in scope))
        { scope.icel_omsh_survtable <- {}; } // Add a custom variable.
        return true;
    }

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

    /**
     * Updates a survivorList to icel_omsh_survtable.
     * survTable =
     * {
     *      entity = ?
     *      totaldamage = ?
     *      totalhits = ?
     * }
     * null damage-> add totalhits [1]
     * int damage -> add totaldamage [0]
     */
    function UpdateSurvivorList(hunterscope, survivor, damage)
    {
        local survTable = hunterscope.icel_omsh_survtable;
        local player = GetSurvivorInList(survTable, survivor);

        if(damage == null) { player.totalhits += 1; }  // Add totalhits when damage is null.
        else { player.totaldamage += damage; } // Otherwise add totaldamage, type always int.
    }

    function OnGameEvent_player_hurt(params)
    {
        if(!("userid" in params && "attacker" in params && "weapon" in params && "dmg_health" in params)) { return; }

        local survivor = GetPlayerFromUserID(params.attacker);
        local hunter = GetPlayerFromUserID(params.userid);
        local weapon = params.weapon;
        local damage = params.dmg_health;

        if(!IsPlayer(hunter, 3) || !IsPlayer(survivor, 9)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; } // Add a custom variable if it doesn't exist.
        local hunterscope = hunter.GetScriptScope();
        // (m_isAttemptingToPounce, m_hGroundEntity) will display (1, not null) and (0, null) respectively.
        if(NetProps.GetPropEntity(hunter, "m_pounceVictim") == null && // Not pouncing a survivor
        NetProps.GetPropEntity(hunter, "m_hGroundEntity") == null && // Hunter jumps also count.
        NetProps.GetPropInt(hunter, "movetype") != 9) // Not climbing a ladder
        {
            if(weapon == "melee" || weapon == "chainsaw")
            {
                if(hunter.GetHealth() <= 0) { damage = damage + hunter.GetHealth(); }
                UpdateSurvivorList(hunterscope, survivor, null); // Add totalhits
                UpdateSurvivorList(hunterscope, survivor, damage) // Add totaldamage.
                if(hunter.GetHealth() <= 0) // Time to fire the custom event, hunter is dead.
                {
                    /**
                     * @main
                     */
                    local resultArray = GetSurvivorInList(hunterscope.icel_omsh_survtable, survivor);
                    local parameters =
                    {
                        survivorid = params.attacker,
                        hunterid = params.userid,
                        totaldamage = resultArray.totaldamage,
                        totalhits = resultArray.totalhits,
                        survivortable = hunterscope.icel_omsh_survtable,
                    }
                    local p = clone params;
                    p.event <- "player_hurt";
                    foreach(func in ::ICEL_OnMeleeSkeetHunter) { func(parameters, p); }

                    hunterscope.icel_omsh_survtable.clear(); // Delete.
                }
            }
        }
    }

    // Clear icel_onskeethunter_survtable when the hunter is dead.
    function OnGameEvent_player_death(params)
    {
        if(!("userid" in params)) { return; }
        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        hunter.GetScriptScope().icel_omsh_survtable.clear(); // Delete.
    }

    // Revamp #2 final part, transfer icel_omsh_survtable to the bot.
    function OnGameEvent_player_bot_replace(params)
    {
        if(!("player" in params && "bot" in params)) { return; }
        local player = GetPlayerFromUserID(params.player);
        local bot = GetPlayerFromUserID(params.bot);
        if(!IsPlayer(player, 3) || !IsPlayer(bot, 3)) { return; }
        if(ValidateHunterScriptScope(player) && bot.ValidateScriptScope())
        {
            bot.GetScriptScope().icel_omsh_survtable <- player.GetScriptScope().icel_omsh_survtable;
        }
    }
}

__CollectEventCallbacks(::ICEL_OnMeleeSkeetHunter_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);