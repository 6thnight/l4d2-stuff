/**
 * parameters = {
 * survivorid = short,
 * chargerid = short,
 * height = int,
 * }
 */
if(!("ICEL_OnChargerDeathChargeByBowl" in getroottable()))
{
    ::ICEL_OnChargerDeathChargeByBowl <- {}
}

/**
 * * Revamp #2 Plan.
 * 1. Store information of the survivor upon charger impact.
 * 2. Keep track of the survivor's information while impacted.
 * 3. Delete the survivor's information when reached the ground and not touching any trigger_hurt that deals above 200 damage.
 * 4. When the damage type is DMG_FALL (1 << 5), check for "survivor_incap_max_fall_damage" convar.
 * 5. params.height is going to be the survivor's highest height while impacted.
 * 6. Transfer information on player_bot_replace and bot_player_replace.
 * 7. Charger carries an impacted survivor, delete info.
 * ! I don't think there will be a perfect algorithm for this.
 */

if(!("Interneted_FastestThinkFunctions" in getroottable()))
{
    ::Interneted_FastestThinkFunctions <- {};
}

::ICEL_OnChargerDeathChargeByBowl_main <-
{
    /**
     * Fires when the player is incapacitated from the trigger_hurt entity while carried by a charger.
     * trigger_hurt -> c1m1 (20000), c3m1 (500), c4m5 (2000), c5m1 (10000), c5m5 (1000), c6m1 (1000),
     *                 c7m1 (10000), c7m2 (10000), c9m1(1000), c10m4 (10000), c10m5 (1000), c11m1 (200),
     *                 c11m2 (200), c12m1 (1000), c12m4 (1000), c12m5 (10000), c13m2 (10000), c13m3 (1000)
     *                 c14m2 (1000)
     * trigger_hurt_ghost -> c4m1 (10000), c6m1 (10000), c8m4 (10000), c8m5 (10000), c14m1 (5000)
     * * Most of the time, player_incapacitated_start fires when they are not one-shot by trigger_hurt entities.
     */
    // minimum damage from trigger_hurt for a death-charge.
    MINIMUM_DAMAGE = 200.0,

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

    // Validate the survivor script scope.
    function ValidateSurvivorScriptScope(survivor)
    {
        if(!survivor.ValidateScriptScope()) { return false; }
        local scope = survivor.GetScriptScope();
        if(!("icel_ocdcbb_zpos" in scope)) { scope.icel_ocdcbb_zpos <- null; }
        if(!("icel_ocdcbb_charger" in scope)) { scope.icel_ocdcbb_charger <- null; }
        return true;
    }

    // Fire the custom event.
    function FireCustomEvent(par1, par2, par3, par4)
    {
        local parameters =
        {
            survivorid = par1,
            chargerid = par2,
            height = par3,
        }
        foreach(func in ::ICEL_OnChargerDeathChargeByBowl) { func(parameters, par4); }
    }

    function OnGameEvent_charger_impact(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.victim);
        local charger = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(charger, 6) || !IsPlayer(survivor, 9)) { return; }
        if(!ValidateSurvivorScriptScope(survivor)) { return; }
        local scope = survivor.GetScriptScope();

        if(NetProps.GetPropEntity(survivor, "m_hGroundEntity") == null) // Survivor is in the air when impacted.
        {   // Fun fact: IsImmobilized() doesn't return true immediately. :V
            scope.icel_ocdcbb_zpos = survivor.GetOrigin().z;
            scope.icel_ocdcbb_charger = charger;
        }
    }

    function OnGameEvent_player_jump_apex(params)
    {
        if(!("userid" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(survivor, 9)) { return; }
        if(!ValidateSurvivorScriptScope(survivor)) { return; }
        local scope = survivor.GetScriptScope();

        if(scope.icel_ocdcbb_zpos != null)
        {
            scope.icel_ocdcbb_zpos = survivor.GetOrigin().z;
        }
    }

    function Thinker()
    {
        function Interneted_FastestThinkFunctions::ICEL_OCDCBB()
        {
            // Nested loops resulted in a stoopid O(mn) time complexity.
            for(local survivor; survivor = Entities.FindByClassname(survivor, "player");)
            {
                if(!survivor.IsValid()) { continue; }
                if(!survivor.IsSurvivor()) { continue; }
                if(::ICEL_OnChargerDeathChargeByBowl_main.ValidateSurvivorScriptScope(survivor))
                {
                    local scope = survivor.GetScriptScope();
                    if(scope.icel_ocdcbb_zpos != null)
                    {
                        local movetype = NetProps.GetPropInt(survivor, "movetype");
                        if(movetype == 8 || movetype == 9) { scope.icel_ocdcbb_zpos = null; continue; } // noclip and ladder.
                        if(survivor.IsDead() || survivor.IsDying()) { scope.icel_ocdcbb_zpos = null; continue; } // dead.
                        // There's a chance that survivor landed on another impacted survivor
                        // resulting in m_hGroundEntity and IsGettingUp() returning player handle and true respectively.
                        local ground = NetProps.GetPropEntity(survivor, "m_hGroundEntity");
                        if(ground == null) { continue; }
                        local exclude = ["player", "infected", "witch"];
                        if(exclude.find(ground) == null) // standing on ground, but not in exclude.
                        {
                            local instakill = false;
                            // ? m_hTouchingEntities doesn't seem to do anything?
                            local function loop_trigger(ent_class)
                            {
                                for(local t_h; t_h = Entities.FindByClassname(t_h, ent_class);)
                                {
                                    if(!t_h.IsTouching(survivor)) { continue; }
                                    if(NetProps.GetPropInt(t_h, "m_bDisabled") == 1) { continue; } // trigger is disabled.
                                    // Does not damage survivors.
                                    local spawn_flags = NetProps.GetPropInt(t_h, "m_spawnflags");
                                    if((spawn_flags & (1 << 0)) == 0 && (spawn_flags & (1 << 6)) == 0) { continue; }

                                    local damage = NetProps.GetPropFloat(t_h, "m_flDamage");
                                    if(damage >= ::ICEL_OnChargerDeathChargeByBowl_main.MINIMUM_DAMAGE) // more than minimum dmg.
                                    { instakill = true; break; }
                                    if((NetProps.GetPropInt(t_h, "m_bitsDamageInflict") & (1 << 5)) > 0) // DMG_FALL
                                    {
                                        if(damage > Convars.GetFloat("survivor_incap_max_fall_damage")) //fatal fall.
                                        { instakill = true; break; }
                                    }
                                }
                            }
                            loop_trigger("trigger_hurt");
                            if(instakill) { continue; }
                            loop_trigger("trigger_hurt_ghost");
                            if(instakill) { continue; }
                            loop_trigger("script_trigger_hurt");
                            if(!instakill) { scope.icel_ocdcbb_zpos = null; }
                        }
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

    // causer will return charger's userid.
    // It will not be available in params if the charger entity is killed before this fires.
    // * If a bot takes control of a player charger, it will return the player's userid as the causer.
    function OnGameEvent_player_falldamage(params)
    {
        if(!("userid" in params && "damage" in params && "causer" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local charger = GetPlayerFromUserID(params.causer);
        if(!IsPlayer(survivor, 9) || !IsPlayer(charger, 6)) { return; }
        // Make sure the damage is enough to kill survivors.
        if(params.damage <= Convars.GetFloat("survivor_incap_max_fall_damage")) { return; }
        if(!ValidateSurvivorScriptScope(survivor)) { return; }
        local scope = survivor.GetScriptScope();
        if(scope.icel_ocdcbb_zpos == null) { return; }

        local totalHeight = scope.icel_ocdcbb_zpos - survivor.GetOrigin().z;
        if(totalHeight < 0.0) { totalHeight = 0.0; }
        /**
         * @main
         */
        local p = clone params;
        p.event <- "player_falldamage";
        FireCustomEvent(params.userid, params.causer, totalHeight.tointeger(), p);

        scope.icel_ocdcbb_zpos = null; // Delete.
        scope.icel_ocdcbb_charger = null;
    }

    function CheckTrigger(t_h)
    {
        if(t_h == null) { return false; }
        if(!t_h.IsValid()) { return false; }
        local ent_class = ["trigger_hurt", "trigger_hurt_ghost", "script_trigger_hurt"];
        if(ent_class.find(t_h.GetClassname()) == null) { return false; }
        local damage = NetProps.GetPropFloat(t_h, "m_flDamage")
        if(damage >= MINIMUM_DAMAGE) { return true; }
        if((NetProps.GetPropInt(t_h, "m_bitsDamageInflict") & (1 << 5)) > 0) // DMG_FALL
        {
            if(damage > Convars.GetFloat("survivor_incap_max_fall_damage")) // fatal fall.
            { return true; }
        }
        return false;
    }

    // for trigger_hurt
    function OnGameEvent_player_incapacitated_start(params)
    {
        if(!("userid" in params && "attackerentid" in params)) { return; }

        local survivor = GetPlayerFromUserID(params.userid);
        local t_h = EntIndexToHScript(params.attackerentid);

        if(!IsPlayer(survivor, 9) || !CheckTrigger(t_h)) { return; }

        if(!ValidateSurvivorScriptScope(survivor)) { return; }
        local scope = survivor.GetScriptScope();
        if(scope.icel_ocdcbb_charger == null || scope.icel_ocdcbb_zpos == null) { return; }

        local charger = scope.icel_ocdcbb_charger;
        local totalHeight = scope.icel_ocdcbb_zpos - survivor.GetOrigin().z;
        if(totalHeight < 0.0) { totalHeight = 0.0; }

        /**
         * @main
         */
        local p = clone params;
        p.event <- "player_incapacitated_start";
        FireCustomEvent(params.userid, charger.GetPlayerUserId(), totalHeight.tointeger(), p);

        scope.icel_ocdcbb_charger = null; // Delete.
        scope.icel_ocdcbb_zpos = null;
    }

    // some trigger may kill the player instantly without incapacitating them.
    function OnGameEvent_player_death(params)
    {
        if(!("userid" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        if(IsPlayer(survivor, 9))
        {
            if(ValidateSurvivorScriptScope(survivor))
            {
                local scope = survivor.GetScriptScope();
                if("attackerentid" in params)
                {
                    local t_h = EntIndexToHScript(params.attackerentid);
                    if(CheckTrigger(t_h) && scope.icel_ocdcbb_charger != null && scope.icel_ocdcbb_zpos != null)
                    {
                        local charger = scope.icel_ocdcbb_charger;
                        local totalHeight = scope.icel_ocdcbb_zpos - survivor.GetOrigin().z;
                        if(totalHeight < 0.0) { totalHeight = 0.0; }

                        /**
                         * @main
                         */
                        local p = clone params;
                        p.event <- "player_death";
                        FireCustomEvent(params.userid, charger.GetPlayerUserId(), totalHeight.tointeger(), p);
                    }
                }
                scope.icel_ocdcbb_zpos = null;
                scope.icel_ocdcbb_charger = null;
            }
        }
    }

    // Charger impacted a survivor to a ledge hang state.
    function OnGameEvent_ledge_grab(params)
    {
        if(!("userid" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(survivor, 9)) { return; }
        if(!ValidateSurvivorScriptScope(survivor)) { return; }
        local scope = survivor.GetScriptScope();
        scope.icel_ocdcbb_charger = null; // Delete.
        scope.icel_ocdcbb_zpos = null;
    }

    function OnGameEvent_player_bot_replace(params)
    {
        if(!("player" in params && "bot" in params)) { return; }
        local player = GetPlayerFromUserID(params.player);
        local bot = GetPlayerFromUserID(params.bot);
        if(!IsPlayer(player, 9) || !IsPlayer(bot, 9)) { return; }
        if(bot.ValidateScriptScope() && player.ValidateScriptScope())
        {
            local bot_scope = bot.GetScriptScope();
            local player_scope = player.GetScriptScope();
            if("icel_ocdcbb_charger" in player_scope) { bot_scope.icel_ocdcbb_charger <- player_scope.icel_ocdcbb_charger; }
            if("icel_ocdcbb_zpos" in player_scope) { bot_scope.icel_ocdcbb_zpos <- player_scope.icel_ocdcbb_zpos; }
        }
    }

    function OnGameEvent_bot_player_replace(params)
    {
        if(!("player" in params && "bot" in params)) { return; }
        local player = GetPlayerFromUserID(params.player);
        local bot = GetPlayerFromUserID(params.bot);
        if(!IsPlayer(player, 9) || !IsPlayer(bot, 9)) { return; }
        if(bot.ValidateScriptScope() && player.ValidateScriptScope())
        {
            local bot_scope = bot.GetScriptScope();
            local player_scope = player.GetScriptScope();
            if("icel_ocdcbb_charger" in bot_scope) { player_scope.icel_ocdcbb_charger <- bot_scope.icel_ocdcbb_charger; }
            if("icel_ocdcbb_zpos" in bot_scope) { player_scope.icel_ocdcbb_zpos <- bot_scope.icel_ocdcbb_zpos; }
        }
    }

    // Extremely rare case where a charger carries an impacted survivor, delete info.
    function OnGameEvent_charger_carry_start(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local charger = GetPlayerFromUserID(params.userid);
        local survivor = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(charger, 6) || !IsPlayer(survivor, 9)) { return; }
        if(!ValidateSurvivorScriptScope(survivor)) { return; }
        local scope = survivor.GetScriptScope();
        scope.icel_ocdcbb_charger = null; // Delete.
        scope.icel_ocdcbb_zpos = null;
    }
}

::ICEL_OnChargerDeathChargeByBowl_main.Thinker();
__CollectEventCallbacks(::ICEL_OnChargerDeathChargeByBowl_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);