/**
 * parameters = {
 * clearerid = short,
 * pinnedid = short,
 * specialid = short,
 * time = float,
 * }
 */
if(!("ICEL_OnClearSpecial" in getroottable()))
{
    ::ICEL_OnClearSpecial <- {}
}

// Does not apply to boomers and spitters.
// It's possible for clearerid = pinnedid, which means that you cleared yourself.
/**
 * ! This will not fire when:
 * - Cleared someone by utilizing a boomer explosion, including using explosive ammo both stagger the pinner and killing the boomer at the same time.
 * - Another special or other infected cleared it instead of the survivor.
 * - Self clearing from a smoker using the prop dropping trick or other tongue_broke_bent related events.
 */

::ICEL_OnClearSpecial_main <-
{
    /**
     * * GENERIC WAYS TO CLEAR
     * 1. Killing em by any means.
     * 2. Stunning em with propane tank, oxygen tank, grenade launcher, and explosive ammo.
     * ! (a) Taken over by another special
     * ! (b) Killed by another special, killed by commons (biled)
     * ! (c) Stunned by boomer explosion and charger impact.
     * ! (d) The special kills the survivor.
     * * ^^^ Make sure to delete info.
     */

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

    // Add custom variables to special scope.
    function ValidateSpecialScriptScope(special)
    {
        if(!special.ValidateScriptScope()) { return false; }
        local scope = special.GetScriptScope();
        if(!("icel_ocs_time" in scope)) { scope.icel_ocs_time <- null; } // Time after getting pinned.
        return true;
    }

    // Fire the custom event.
    function FireCustomEvent(par1, par2, par3, par4, par5)
    {
        local parameters =
        {
            clearerid = par1,
            pinnedid = par2,
            specialid = par3,
            // !!! FIX TIME() PLEASE, I DON'T KNOW WHY IT CAN RETURN LESS VALUE
            // !!! WHEN TWO UNRELATED EVENTS HAPPEN WITHIN A SPLIT SECOND INTERVAL.
            time = par4 < 0.0 ? 0.0 : par4,
        }
        foreach(func in ::ICEL_OnClearSpecial) { func(parameters, par5); }
    }

    // Update the special scope
    function UpdateSpecialScope(survivorid, specialid, zomType)
    {
        local special = GetPlayerFromUserID(specialid);
        local survivor = GetPlayerFromUserID(survivorid);
        if(!IsPlayer(special, zomType) || !IsPlayer(survivor, 9)) { return; }
        if(!ValidateSpecialScriptScope(special)) { return; }
        special.GetScriptScope().icel_ocs_time = Time();
    }

    function DeleteSpecialScope(special)
    {
        if(!ValidateSpecialScriptScope(special)) { return; }
        special.GetScriptScope().icel_ocs_time = null;
    }

    /**
     * * SMOKER
     * - tongue_grab - tongue_pull_stopped - tongue_release - player_hurt - tongue_release.
     * - choke_start -  choke_stopped - tongue_release - choke_end - player_hurt - tongue_release.
     * - tongue_release - player_hurt - tongue_release.
     * 3. Cutting the smoker's tongue, self-clear.
     * 4. Shooting the smoker's tongue.
     * 5. Shoving the survivor.
     * 6. Shove the smoker.
     * ! (e) Smoker ledge-hanged a survivor
     */
    function OnGameEvent_tongue_grab(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        UpdateSpecialScope(params.victim, params.userid, 1);
    }

    function OnGameEvent_choke_start(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        UpdateSpecialScope(params.victim, params.userid, 1);
    }

    // * SMOKER (1,3,4,5,6)
    // ! smoker killed by a gascan, firework, molotov, and incendiary ammo will not fire this event.
    function OnGameEvent_tongue_pull_stopped(params)
    {
        if(!("userid" in params && "victim" in params && "smoker" in params)) { return; }
        local smoker = GetPlayerFromUserID(params.smoker);
        local survivor = GetPlayerFromUserID(params.userid);
        local victim = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(smoker, 1) || !IsPlayer(survivor, 9) || !IsPlayer(victim, 9)) { return; }
        if(!ValidateSpecialScriptScope(smoker)) { return; }
        local scope = smoker.GetScriptScope();
        if(scope.icel_ocs_time != null)
        {
            /**
             * @main
             */
            local p = clone params;
            p.event <- "tongue_pull_stopped";
            FireCustomEvent(params.userid, params.victim, params.smoker, Time() - scope.icel_ocs_time, p);
            scope.icel_ocs_time = null;
        }
    }

    // * SMOKER (1,5,6)
    // ! smoker killed by a gascan, firework, molotov, and incendiary ammo will not fire this event.
    function OnGameEvent_choke_stopped(params)
    {
        if(!("userid" in params && "victim" in params && "smoker" in params)) { return; }
        local smoker = GetPlayerFromUserID(params.smoker);
        local survivor = GetPlayerFromUserID(params.userid);
        local victim = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(smoker, 1) || !IsPlayer(survivor, 9) || !IsPlayer(victim, 9)) { return; }
        if(!ValidateSpecialScriptScope(smoker)) { return; }
        local scope = smoker.GetScriptScope();
        if(scope.icel_ocs_time != null)
        {
            /**
             * @main
             */
            local p = clone params;
            p.event <- "choke_stopped";
            FireCustomEvent(params.userid, params.victim, params.smoker, Time() - scope.icel_ocs_time, p);
            scope.icel_ocs_time = null;
        }
    }

    # smoked while holding a prop_physics trick, clear.
    function OnGameEvent_tongue_broke_bent(params)
    {
        if(!("userid" in params)) { return; }
        local smoker = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(smoker, 1)) { return; }
        if(!ValidateSpecialScriptScope(smoker)) { return; }
        local scope = smoker.GetScriptScope();
        scope.icel_ocs_time = null;
        if("icel_ocs_victim" in scope) { delete scope.icel_ocs_victim; }
    }

    # clear.
    function OnGameEvent_tongue_release(params)
    {
        if(!("userid" in params && "distance" in params && "victim" in params)) { return; }
        local smoker = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(smoker, 1)) { return; }
        if(!ValidateSpecialScriptScope(smoker)) { return; }
        local scope = smoker.GetScriptScope();
        // ! (a,b,c,d,e)
        if(params.distance < 0 && params.victim < 0) // second firation.
        {
            // !!! I STILL HATE THAT THERE IS A DELAY ON THIS.
            // At least killing the smoker still fires this event first before player_death.
            scope.icel_ocs_time = null;
            if("icel_ocs_victim" in scope) { delete scope.icel_ocs_victim; }
        }
        else if(scope.icel_ocs_time != null ) // first firation
        {
            // Taking advantage of the event firing twice :V
            // For clearing with stagger except for shoving.
            local victim = GetPlayerFromUserID(params.victim);
            if(!IsPlayer(victim, 9)) { return; }
            scope.icel_ocs_victim <- victim;
            // * Some clears may not fire the second firation.
            DoEntFire("!self", "RunScriptCode", "::ICEL_OnClearSpecial_main.DelayedClear(self);", 0.0, null, smoker);
        }
    }

    // ? When does this fire?
    function OnGameEvent_tongue_broke_victim_died(params)
    {
        if(!("userid" in params)) { return; }
        local smoker = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(smoker, 1)) { return; }
        if(!ValidateSpecialScriptScope(smoker)) { return; }
        local scope = smoker.GetScriptScope();
        scope.icel_ocs_time = null;
        if("icel_ocs_victim" in scope) { delete scope.icel_ocs_victim; }
    }

    /**
     * * JOCKEY
     * - jockey_ride - player_hurt && player_shoved - jockey_ride_end.
     * 3. Shoving em.
     * ! (e) The jockey incaps or ledge hanged a survivor.
     */
    function OnGameEvent_jockey_ride(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        UpdateSpecialScope(params.victim, params.userid, 5);
    }

    // * JOCKEY (3), cleared by shoving.
    # You can either shove the jockey or the survivor to clear.
    // ! Extremely rarely, it will not free the survivor when shoving too quickly.
    // * we need delay to check.
    function OnGameEvent_player_shoved(params)
    {
        if(!("userid" in params && "attacker" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.attacker);
        local shoved = GetPlayerFromUserID(params.userid);
        if(!(IsPlayer(survivor, 9))) { return; }
        if(shoved == null) { return; }
        if(!shoved.IsValid()) { return; }
        if(shoved.IsSurvivor()) // shoving the survivor.
        {
            local jockey = NetProps.GetPropEntity(shoved, "m_jockeyAttacker");
            if(!IsPlayer(jockey, 5)) { return; }
            if(ValidateSpecialScriptScope(jockey))
            {
                local scope = jockey.GetScriptScope();
                if(scope.icel_ocs_time != null)
                {
                    scope.icel_ocs_surv <- survivor;
                    scope.icel_ocs_victim <- shoved;
                    DoEntFire("!self", "RunScriptCode", "::ICEL_OnClearSpecial_main.DelayedFire2(self, " + (Time() - scope.icel_ocs_time) + ", false);", 0.0, null, jockey);
                }
            }
        }
        else if(shoved.GetZombieType() == 5) // shoving the jockey.
        {
            local victim = NetProps.GetPropEntity(shoved, "m_jockeyVictim");
            if(!IsPlayer(victim, 9)) { return; }
            if(ValidateSpecialScriptScope(shoved))
            {
                local scope = shoved.GetScriptScope();
                if(scope.icel_ocs_time != null)
                {
                    scope.icel_ocs_surv <- survivor;
                    scope.icel_ocs_victim <- victim;
                    DoEntFire("!self", "RunScriptCode", "::ICEL_OnClearSpecial_main.DelayedFire2(self, " + (Time() - scope.icel_ocs_time) + ", true);", 0.0, null, shoved);
                }
            }
        }
    }

    // * JOCKEY (1,2)
    function OnGameEvent_jockey_ride_end(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local victim = GetPlayerFromUserID(params.victim);
        local jockey = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(victim, 9) || !IsPlayer(jockey, 5)) { return; }
        if(!ValidateSpecialScriptScope(jockey)) { return; }

        local scope = jockey.GetScriptScope();
        if("rescuer" in params && scope.icel_ocs_time != null)
        {
            local survivor = GetPlayerFromUserID(params.rescuer);
            if(IsPlayer(survivor, 9))
            {
                /**
                 * @main
                 */
                local p = clone params;
                p.event <- "jockey_ride_end";
                FireCustomEvent(params.rescuer, params.victim, params.userid, Time() - scope.icel_ocs_time, p);
            }
        }
        // ! (a,b,c,d,e) Clear info no matter what, since it should be fire in all release cases.
        DoEntFire("!self", "RunScriptCode", "::ICEL_OnClearSpecial_main.DelayedClear2(self);", 0.0, null, jockey);
    }

    function DelayedClear2(jockey)
    {
        if(jockey != null)
        {
            local scope = jockey.GetScriptScope();
            scope.icel_ocs_time = null;
            if("icel_ocs_surv" in scope) { delete scope.icel_ocs_surv; }
            if("icel_ocs_victim" in scope) { delete scope.icel_ocs_victim; }
        }
    }

    function DelayedFire2(jockey, time, jockey_shoved)
    {
        if(jockey != null)
        {
            local scope = jockey.GetScriptScope();
            if("icel_ocs_surv" in scope && "icel_ocs_victim" in scope)
            {
                if(scope.icel_ocs_victim != null && scope.icel_ocs_surv != null && NetProps.GetPropEntity(jockey, "m_jockeyVictim") == null && scope.icel_ocs_time != null)
                {
                    /**
                     * @main
                     */
                    local p = { event = "delayed_player_shoved", attacker = scope.icel_ocs_surv.GetPlayerUserId(), }
                    if(jockey_shoved)
                    { p.userid <- jockey.GetPlayerUserId(); }
                    else { p.userid <- scope.icel_ocs_victim.GetPlayerUserId(); }
                    FireCustomEvent(scope.icel_ocs_surv.GetPlayerUserId(), scope.icel_ocs_victim.GetPlayerUserId(), jockey.GetPlayerUserId(), time, p);

                    scope.icel_ocs_time = null; // * Make sure to not always clear THIS!
                }
                delete scope.icel_ocs_victim;
                delete scope.icel_ocs_surv;
            }
        }
    }

    /**
     * * HUNTER
     * - lunge_pounce - player_hurt* - pounce_stopped - player_hurt* - pounce_end - player_hurt*
     * - *player_hurt order varies on how it was cleared.
     * 3. Shove em.
     */
    function OnGameEvent_lunge_pounce(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        UpdateSpecialScope(params.victim, params.userid, 3);
    }

    // * HUNTER (3)
    # Killing the hunter will fire player_hurt first.
    # Killing it by shoving will fire pounce_stopped first.
    // ! Will not fire if staggered by pipe bomb, propane/oxygen tank, explosive ammo, grenade_launcher.
    // !!! FREAKING BUGGY EVENT WHEN CLEARING THE HUNTER BY SHOVING.
    // ! Shoving a hunter right after it pounces a survivor will not release the survivor, but the event will still fire, pounce_end will not fire.
    function OnGameEvent_pounce_stopped(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local victim = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(survivor, 9) || !IsPlayer(victim, 9)) { return; }

        local hunter = NetProps.GetPropEntity(victim, "m_pounceAttacker");
        if(!IsPlayer(hunter, 3)) { return; }
        if(!ValidateSpecialScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();

        if(scope.icel_ocs_time != null)
        {
            scope.icel_ocs_victim <- victim;
            scope.icel_ocs_surv <- survivor;
            DoEntFire("!self", "RunScriptCode", "::ICEL_OnClearSpecial_main.DelayedFire(self, " + (Time() - scope.icel_ocs_time) + ");", 0.0, null, hunter);
        }
    }

    function OnGameEvent_pounce_end(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local hunter = GetPlayerFromUserID(params.userid);
        local victim = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(hunter, 3) || !IsPlayer(victim, 9)) { return; }
        if(!ValidateSpecialScriptScope(hunter)) { return; }
        local scope = hunter.GetScriptScope();
        if(scope.icel_ocs_time != null)
        {
            // !!! I HAVE NO CHOICE BUT TO USE DOENTFIRE DELAY TO CLEAR INFO
            // !!! I CAN'T FIND ANY OTHER WAY.
            // For clearing with stagger except shoving.
            scope.icel_ocs_victim <- victim;
            DoEntFire("!self", "RunScriptCode", "::ICEL_OnClearSpecial_main.DelayedClear(self);", 0.0, null, hunter);
        }

    }

    function DelayedClear(hunter)
    {
        if(hunter != null)
        {
            local scope = hunter.GetScriptScope();
            if("icel_ocs_victim" in scope) { delete scope.icel_ocs_victim; }
            scope.icel_ocs_time = null;
        }
    }

    function DelayedFire(hunter, time)
    {
        if(hunter != null)
        {
            local scope = hunter.GetScriptScope();
            if("icel_ocs_victim" in scope && "icel_ocs_surv" in scope)
            {
                if(scope.icel_ocs_victim != null && scope.icel_ocs_surv != null && NetProps.GetPropEntity(hunter, "m_pounceVictim") == null && scope.icel_ocs_time != null)
                {
                    /**
                     * @main
                     */
                    local p = { event = "delayed_pounce_stopped", userid = scope.icel_ocs_surv.GetPlayerUserId(), victim = scope.icel_ocs_victim.GetPlayerUserId(), }
                    FireCustomEvent(scope.icel_ocs_surv.GetPlayerUserId(), scope.icel_ocs_victim.GetPlayerUserId(), hunter.GetPlayerUserId(), time, p);
                    scope.icel_ocs_time = null; // * Make to not always clear THIS!
                }
                delete scope.icel_ocs_victim;
                delete scope.icel_ocs_surv;
            }
        }
    }

    /**
     * * CHARGER
     * - charger_carry_start - charger_pummel_start
     * - player_hurt - charger_carry_end
     * - player_hurt - charger_pummel_end
     * - if z_charger_allow_shove is set to 1, the charger can be shoved to death when pummeling a survivor.
     */
    function OnGameEvent_charger_carry_start(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        UpdateSpecialScope(params.victim, params.userid, 6);
    }

    function OnGameEvent_charger_pummel_start(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        UpdateSpecialScope(params.victim, params.userid, 6);
    }

    // transitioning to pummel, or killed by carrying
    // will still return the same value of m_carryVictim (handle) and m_pummelVictim (null)
    // on charger_carry_end.

    // * This will only fire on versus.
    function OnGameEvent_charger_carry_kill(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local charger = GetPlayerFromUserID(params.userid);
        local survivor = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(charger, 6) || !IsPlayer(survivor, 9)) { return; }
        if(!ValidateSpecialScriptScope(charger)) { return; }
        charger.GetScriptScope().icel_ocs_time = null;
    }

    function OnGameEvent_charger_pummel_end(params)
    {
        if(!("userid" in params && "victim" in params)) { return; }
        local charger = GetPlayerFromUserID(params.userid);
        local victim = GetPlayerFromUserID(params.victim);
        if(!IsPlayer(charger, 6) || !IsPlayer(victim, 9)) { return; }
        if(!ValidateSpecialScriptScope(charger)) { return; }
        local scope = charger.GetScriptScope();

        if("rescuer" in params)
        {
            local survivor = GetPlayerFromUserID(params.rescuer);
            if(IsPlayer(survivor, 9) && scope.icel_ocs_time != null)
            {
                /**
                 * @main
                 */
                local p = clone params;
                p.event <- "charger_pummel_end";
                FireCustomEvent(params.rescuer, params.victim, params.userid, Time() - scope.icel_ocs_time, p);
            }
        }
        // ! (a,b,c,d) Clear info no matter what, since it should be fire in all release cases.
        scope.icel_ocs_time = null;
    }

    # EVERY GENERIC WAY TO CLEAR FOR EVERY SPECIAL
    // * CHARGER (1), HUNTER (1), JOCKEY (1), SMOKER(1, kind of?)
    // ? For some reason, right after the charger starts pummeling, IsStaggering() returns true?
    // ? valve pls fix :((((

    function OnGameEvent_player_hurt(params)
    {
        if(!("userid" in params && "attacker" in params)) { return; }
        local hurt = GetPlayerFromUserID(params.userid);
        local attack = GetPlayerFromUserID(params.attacker);
        if(hurt == null || attack == null) { return; }
        if(!hurt.IsValid() || !attack.IsValid()) { return; }

        local survivor = null; local time = null;

        if(attack.IsSurvivor())
        {
            if(hurt.GetHealth() <= 0)
            {
                local type = hurt.GetZombieType();
                if(type == 3) // hunter.
                {
                    survivor = NetProps.GetPropEntity(hurt, "m_pounceVictim");
                }
                else if(type == 5) // jockey.
                {
                    survivor = NetProps.GetPropEntity(hurt, "m_jockeyVictim");
                }
                else if(type == 6) // charger.
                {
                    local pummel = NetProps.GetPropEntity(hurt, "m_pummelVictim");
                    local carry = NetProps.GetPropEntity(hurt, "m_carryVictim");
                    survivor = pummel == null ? (carry == null ? null : carry) : pummel;
                }
                else if(type == 1) // smoker.
                {
                    // The only time m_tongueVictim will return the smoked victim is when
                    // ! the smoker is killed by entityflame, inferno, and fire_cracker_blast, probably more.
                    // ? is it the reason why it doesn't fire tongue_pull_stopped and tongue_choke_stopped?
                    // ok.
                    survivor = NetProps.GetPropEntity(hurt, "m_tongueVictim");
                }
                if(survivor != null)
                {
                    if(ValidateSpecialScriptScope(hurt))
                    {
                        local scope = hurt.GetScriptScope();
                        if(scope.icel_ocs_time != null)
                        {
                            time = Time() - scope.icel_ocs_time;
                            scope.icel_ocs_time = null;
                        }
                    }
                }
            }
            else(hurt.IsStaggering())
            {
                // * SMOKER (2), HUNTER (2)
                local type = hurt.GetZombieType();
                if(type == 1 || type == 3) // smoker and hunter.
                {
                    if(ValidateSpecialScriptScope(hurt))
                    {
                        local scope = hurt.GetScriptScope();
                        if("icel_ocs_victim" in scope && scope.icel_ocs_time != null)
                        {
                            survivor = scope.icel_ocs_victim; time = Time() - scope.icel_ocs_time;
                            scope.icel_ocs_time = null; delete scope.icel_ocs_victim;
                        }
                    }
                }
            }
        }
        // ! (c) charger impact stumbling nearby specials.
        else if(attack.GetZombieType() == 6)
        {
            local types = [1, 3, 5, 6];
            if(types.find(hurt.GetZombieType()) != null)
            {
                if(hurt.IsStaggering())
                {
                    // you know, I would have not done this, if IsStaggering() isn't so buggy.
                    local victims = ["m_tongueVictim", "m_pounceVictim", "m_jockeyVictim", "m_pummelVictim", "m_carryVictim"];
                    foreach(i, victim in victims)
                    { if(NetProps.GetPropEntity(hurt, victim) != null) { return; } }
                    DeleteSpecialScope(hurt);
                }
            }
        }

        if(survivor != null && time != null)
        {
            /**
             * @main
             */
            local p = clone params;
            p.event <- "player_hurt";
            FireCustomEvent(params.attacker, survivor.GetPlayerUserId(), params.userid, time, p);
        }
    }

    function OnGameEvent_player_death(params)
    {
        if(!("userid" in params)) { return; }
        local dead = GetPlayerFromUserID(params.userid);
        if(dead == null) { return; }
        if(!dead.IsValid()) { return; }
        local types = [1, 3, 5, 6];
        if(types.find(dead.GetZombieType()) != null) // special is dead, delete info.
        { // ! (b)
            if(!ValidateSpecialScriptScope(dead)) { return; }
            dead.GetScriptScope().icel_ocs_time = null;
        }
        else if(type == 9) // special successfully kills a survivor, delete info.
        { // ! (d)
            if(!("attacker" in params)) { return; }
            local special = GetPlayerFromUserID(params.attacker);
            if(special == null) { return; }
            if(!special.IsValid()) { return; }
            if(types.find(special.GetZombieType()) != null)
            {
                if(!ValidateSpecialScriptScope(special)) { return; }
                special.GetScriptScope().icel_ocs_time = null;
            }
        }
    }

    // ! (c) boomer explosion stumbling nearby specials.
    function OnGameEvent_boomer_exploded(params)
    {
        for(local special; special = Entities.FindByClassname(special, "player");)
        {
            if(special.IsValid())
            {
                local type = special.GetZombieType();
                if(type < 7 && type != 2 && type != 4)
                {
                    if(special.IsStaggering())
                    {
                        // you know, I would have not done this, if IsStaggering() isn't so buggy.
                        local victims = ["m_tongueVictim", "m_pounceVictim", "m_jockeyVictim", "m_pummelVictim", "m_carryVictim"];
                        foreach(i, victim in victims)
                        { if(NetProps.GetPropEntity(special, victim) != null) { return; } }
                        DeleteSpecialScope(special);
                    }
                }
            }
        }
    }

    // ! (e) FOR JOCKEY AND SMOKER.
    function OnGameEvent_player_incapacitated_start(params)
    {
        if(!("userid" in params && "attacker" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local jockey = GetPlayerFromUserID(params.attacker);
        if(!IsPlayer(survivor, 9) || !IsPlayer(jockey, 5)) { return; }

        if(survivor.IsDominatedBySpecialInfected())
        {
            if(survivor.GetSpecialInfectedDominatingMe() == jockey) // jockey.
            { DeleteSpecialScope(jockey); }
        }
    }

    function OnGameEvent_player_ledge_grab(params)
    {
        if(!("userid" in params && "causer" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        local smoker = GetPlayerFromUserID(params.causer);
        if(!IsPlayer(survivor, 9) || !IsPlayer(smoker, 1)) { return; } // smoker.

        DeleteSpecialScope(smoker);
    }

    // Revamp #2 final part, bot_player_replace.
    function OnGameEvent_player_bot_replace(params)
    {
        if(!("player" in params && "bot" in params)) { return; }
        local player = GetPlayerFromUserID(params.player);
        local bot = GetPlayerFromUserID(params.bot);
        local types = [1, 3, 5, 6];
        if(player == null || bot == null) { return; }
        if(types.find(player.GetZombieType()) == null && player.GetZombieType() == bot.GetZombieType()) { return; }
        if(player.ValidateScriptScope() && bot.ValidateScriptScope())
        {
            local player_scope = player.GetScriptScope();
            local bot_scope = bot.GetScriptScope();
            // transfer info.
            if("icel_ocs_time" in player_scope) { bot_scope.icel_ocs_time <- player_scope.icel_ocs_time; }
            if("icel_ocs_victim" in player_scope) { bot_scope.icel_ocs_victim <- player_scope.icel_ocs_victim; }
            if("icel_ocs_surv" in player_scope) { bot_scope.icel_ocs_surv <- player_scope.icel_ocs_surv; }
        }
    }
}

__CollectEventCallbacks(::ICEL_OnClearSpecial_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);