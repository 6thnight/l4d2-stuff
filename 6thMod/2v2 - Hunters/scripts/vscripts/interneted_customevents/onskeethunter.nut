/**
 * parameters = {
 * survivorid = short,
 * hunterid = short,
 * totaldamage = int,
 * totalshots = int,
 * }
*/
if(!("ICEL_OnSkeetHunter" in getroottable()))
{
    ::ICEL_OnSkeetHunter <- {}
}
/**
 * Killing a hunter that is currently in the air, no matter how many health they have.
 * Hunter is lunging or just jumping, doesn't matter, except for climbing ladders.
 * icel_osh_survtable contains about total damage and total shots being to the hunter while being in the air.
 * so the total damage of every single survivor combined does not always add up to the hunter's max health.
 */
::ICEL_OnSkeetHunter_main <-
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
        if(!("icel_osh_survtable" in scope)) { scope.icel_osh_survtable <- {}; } // Add a custom variable.
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
            totalshots = 0,
        }
        return survTable[key];
    }

    /**
     * Updates a survivorList to icel_omsh_survtable.
     * survTable =
     * {
     *      entity = ?
     *      totaldamage = ?
     *      totalshots = ?
     * }
     * null damage-> add totalshots [1]
     * int damage -> add totaldamage [0]
     */
    function UpdateSurvivorList(hunterscope, survivor, damage)
    {
        local survTable = hunterscope.icel_osh_survtable;
        local player = GetSurvivorInList(survTable, survivor);

        if(damage == null) { player.totalshots += 1; }  // Add totalshots when damage is null.
        else { player.totaldamage += damage; } // Otherwise add totaldamage, type always int.
    }

    // ! Splash damage and direct hit from explosive ammos share the same damage type using player_hurt.
    // ! hitgroup will always return 0 no matter what, m_LastHitGroup gives undesired result as well.
    // ? I have yet to find a way to detect direct hits from explosive ammo. :(

    // Fires more than one bullet.
    shotguns = ["shotgun_spas", "autoshotgun", "shotgun_chrome", "pumpshotgun"],

    // Uses explosive ammo.
    nonShotguns = ["rifle_m60", "grenade_launcher_projectile", // Tier 3 weapons, 16777280 for GL
                "sniper_military", "hunting_rifle", "sniper_scout", "sniper_awp" // Snipers.
                "rifle_desert", "rifle", "rifle_ak47", "rifle_sg552" // Rifles.
                "smg_mp5", "smg", "smg_silenced"] // SMGs.

    // These don't use any explosive ammo.
    others = ["pistol", "pistol_magnum" // Pistols.
            "prop_minigun", "prop_minigun_l4d1"] // Miniguns.

    function OnGameEvent_player_hurt(params)
    {
        if(!("userid" in params && "attacker" in params && "weapon" in params && "dmg_health" in params)) { return; }

        local survivor = GetPlayerFromUserID(params.attacker);
        local hunter = GetPlayerFromUserID(params.userid);
        local weapon = params.weapon;
        local damage = params.dmg_health;

        local usingGun = false;

        if(!IsPlayer(hunter, 3) || !IsPlayer(survivor, 9)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; } // Add a custom variable if it doesn't exist.
        local hunterscope = hunter.GetScriptScope();
        // (m_isAttemptingToPounce, m_hGroundEntity) will display (1, not null) and (0, null) respectively.
        if(NetProps.GetPropEntity(hunter, "m_hGroundEntity") == null && // Hunter jumps also count.
        NetProps.GetPropInt(hunter, "m_pounceVictim") == -1 && // Not pouncing anyone.
        NetProps.GetPropInt(hunter, "movetype") != 9) // Not climbing a ladder
        {
            if(hunter.GetHealth() <= 0) { damage = damage + hunter.GetHealth(); } // When the hunter is dead, make sure the damage is equal to remaining health.
            if(shotguns.find(weapon) != null) // shotguns
            {
                if(survivor.ValidateScriptScope())
                {
                    local scope = survivor.GetScriptScope();
                    if(!("icel_osh" in scope)) { scope.icel_osh <- false;}
                    if(scope.icel_osh)
                    {
                        UpdateSurvivorList(hunterscope, survivor, null); // Add totalshots
                        scope.icel_osh = false;
                    }
                }
                UpdateSurvivorList(hunterscope, survivor, damage); // Add totaldamage.
                usingGun = true;
            }
            else if(nonShotguns.find(weapon) != null || others.find(weapon) != null) // non-shotguns
            {
                if(weapon == "grenade_launcher_projectile" && "type" in params)
                {
                    if(params.type == 16777280) { usingGun = true; }
                } else { usingGun = true; }
                if(usingGun)
                {
                    UpdateSurvivorList(hunterscope, survivor, null); // Add totalshots
                    UpdateSurvivorList(hunterscope, survivor, damage) // Add totaldamage.
                }
            }
            if(hunter.GetHealth() <= 0) // Time to fire the custom event, hunter is dead.
            {
                if(usingGun)
                {
                    /**
                     * @main
                     */
                    local resultArray = GetSurvivorInList(hunterscope.icel_osh_survtable, survivor);
                    local parameters =
                    {
                        survivorid = params.attacker,
                        hunterid = params.userid,
                        totaldamage = resultArray.totaldamage,
                        totalshots = resultArray.totalshots,
                        survivortable = hunterscope.icel_osh_survtable,
                    }
                    local p = clone params;
                    p.event <- "player_hurt";
                    foreach(func in ::ICEL_OnSkeetHunter) { func(parameters, p); }
                    hunterscope.icel_osh_survtable.clear(); // Delete.
                }
            }
        }
    }

    // Set survivor's icel_osh to true if firing with a shotgun.
    function OnGameEvent_weapon_fire(params)
    {
        if(!("userid" in params && "weapon" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local weapon = params.weapon;
        if(!IsPlayer(survivor, 9)) { return; }
        if(survivor.ValidateScriptScope())
        {
            local scope = survivor.GetScriptScope();
            if(!("icel_osh" in scope)) { scope.icel_osh <- false; }
            if(shotguns.find(weapon) != null) { scope.icel_osh = true; }
            else { scope.icel_osh = false; }
        }
    }

    // Clear icel_osh_survtable when the hunter is dead.
    function OnGameEvent_player_death(params)
    {
        if(!("userid" in params)) { return; }
        local hunter = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(hunter, 3)) { return; }
        if(!ValidateHunterScriptScope(hunter)) { return; }
        hunter.GetScriptScope().icel_osh_survtable.clear(); // Delete.
    }

    // Revamp #2 final part, transfer icel_osh_survtable to the bot.
    function OnGameEvent_player_bot_replace(params)
    {
        if(!("player" in params && "bot" in params)) { return; }
        local player = GetPlayerFromUserID(params.player);
        local bot = GetPlayerFromUserID(params.bot);
        if(!IsPlayer(player, 3) || !IsPlayer(bot, 3)) { return; }
        if(ValidateHunterScriptScope(player) && bot.ValidateScriptScope())
        {
            bot.GetScriptScope().icel_osh_survtable <- player.GetScriptScope().icel_osh_survtable;
        }
    }
}

__CollectEventCallbacks(::ICEL_OnSkeetHunter_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);