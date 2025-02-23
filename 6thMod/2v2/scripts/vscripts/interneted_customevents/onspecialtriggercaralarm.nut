/**
 * parameters = {
 * survivorid = short,
 * specialid = short,
 * }
 */
// The only specials included are jockey, charger, smoker, and boomer.
if(!("ICEL_OnSpecialTriggerCarAlarm" in getroottable()))
{
    ::ICEL_OnSpecialTriggerCarAlarm <- {}
}

/**
 * Revamp #2 Plan simplified:
 * 1. Think function to connect outputs OnTakeDamage and OnCarAlarmStart.
 * 2. Store, delete, make use of the variables, as well as firing the custom event in the subsequent event order.
 * 3. Event order as follows: player_death -> triggered_car_alarm -> boomer_exploded -> OnCarAlarmStart -> Delay_triggered_car_alarm -> OnTakeDamage -> Delay_OnCarAlarmStart
 * ! It's still not perfect, because of hook limitations.
 */

if(!("Interneted_FastestThinkFunctions" in getroottable()))
{
    ::Interneted_FastestThinkFunctions <- {};
}

// * prop_car_alarm behaves differently in versus.
::ICEL_OnSpecialTriggerCarAlarm_main <-
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

    // Is the car alarm triggered already? CREDITS: @smilzo - Left 4 Bots.
    function IsCarAlarmTriggered(caralarm)
    {
        if (!caralarm || !caralarm.IsValid())
            return false;

        if (NetProps.GetPropInt(caralarm, "m_bDisabled"))
            return true;

        local ambient_generic = null;
        while (ambient_generic = Entities.FindByClassname(ambient_generic, "ambient_generic"))
        {
            if (NetProps.GetPropString(ambient_generic, "m_sSourceEntName") == caralarm.GetName() && NetProps.GetPropString(ambient_generic, "m_iszSound") == "Car.Alarm" && NetProps.GetPropInt(ambient_generic, "m_fActive"))
                return true;
        }
        return false;
    }

    function FireCustomEvent(par1, par2, par3, params)
    {
        local parameters =
        {
            survivorid = par1,
            specialid = par2,
            carentidx = par3,
        }
        foreach(func in ::ICEL_OnSpecialTriggerCarAlarm) { func(parameters, params); }
    }

    // ? Is there an event hook right after an entity is spawned? I hate using think.
    function Thinker()
    {
        function Interneted_FastestThinkFunctions::ICEL_OSTCA()
        {
            for(local car; car = Entities.FindByClassname(car, "prop_car_alarm");)
            {
                if(!car.IsValid()) { continue; }
                // * Car alarm is not triggered, hook functions to events.
                if(::ICEL_OnSpecialTriggerCarAlarm_main.IsCarAlarmTriggered(car)) { continue; }
                if(car.ValidateScriptScope())
                {
                    local scope = car.GetScriptScope();
                    if("interneted_ostca_oncaralarmstart" in scope) { continue; }
                    scope.interneted_ostca_oncaralarmstart <- function(ent = null)
                    {
                        ::ICEL_OnSpecialTriggerCarAlarm_main.OnCarAlarmStart(self);
                    }
                    scope.interneted_ostca_ontakedamage <- function(ent = null)
                    {
                        local surv = ent ? ent : activator;
                        if(surv == null) { return; }
                        if(surv.GetClassname() != "player") { return; }
                        if(!surv.IsSurvivor()) { return; }
                        if(!::ICEL_OnSpecialTriggerCarAlarm_main.IsPlayer(surv, 9)) { return; }
                        ::ICEL_OnSpecialTriggerCarAlarm_main.OnTakeDamage(surv, self);
                    }
                    car.ConnectOutput("OnCarAlarmStart", "interneted_ostca_oncaralarmstart");
                    car.ConnectOutput("OnTakeDamage", "interneted_ostca_ontakedamage");
                }
            }
            for(local glass; glass = Entities.FindByClassname(glass, "prop_car_glass");)
            {
                if(!glass.IsValid()) { continue; }
                if(glass.ValidateScriptScope())
                {
                    local scope = glass.GetScriptScope();
                    if("interneted_ostca_ontakedamage" in scope) { continue; }
                    scope.interneted_ostca_ontakedamage <- function(ent = null)
                    {
                        local surv = ent ? ent : activator;
                        if(surv == null) { return; }; if(surv.GetClassname() != "player") { return; }
                        if(!surv.IsSurvivor()) { return; }
                        if(!::ICEL_OnSpecialTriggerCarAlarm_main.IsPlayer(surv, 9)) { return; }
                        local car = self.GetMoveParent();
                        if(car == null) { return; }; if(!car.IsValid()) { return; }
                        if(car.GetClassname() != "prop_car_alarm") { return; }
                        ::ICEL_OnSpecialTriggerCarAlarm_main.OnTakeDamage(surv, car);
                    }
                    glass.ConnectOutput("OnTakeDamage", "interneted_ostca_ontakedamage");
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

    /**
     * player_death -> triggered_car_alarm -> boomer_exploded
     * triggered_car_alarm -> OnTakeDamage -> triggered_car_alarm.DoEntFire()
     * * player_death -> triggered_car_alarm -> boomer_exploded -> OnCarAlarmStart -> Delay_triggered_car_alarm -> OnTakeDamage -> Delay_OnCarAlarmStart
     * * Right after boomer_exploded, IsCarAlarmTriggered will return true for the subsequent events.
     */

    /**
     * @FOR survivor
     * - icel_ostca_dotrigger <- null;
     * - icel_ostca_boomer <- null;
     * -
     * @FOR car
     */

    // * ONE
    function OnGameEvent_player_death(params)
    {
        if(!("userid" in params && "attacker" in params)) { return; }
        local boomer = GetPlayerFromUserID(params.userid);
        local survivor = GetPlayerFromUserID(params.attacker);
        if(!IsPlayer(boomer, 2) || !IsPlayer(survivor, 9)) { return; }
        if(survivor.ValidateScriptScope())
        {
            survivor.GetScriptScope().icel_ostca_boomer <- boomer;
        }
    }

    // * TWO
    // ! When multiple car alarms triggered at once, OnCarAlarmStart_car1 -> Delay_t_c_a_car1 -> OnCarAlarmStart_car2 -> Delay_t_c_a_car2 -> ...
    // mark every single unblocked car with icel_ostca_marked = survivor.
    function OnGameEvent_triggered_car_alarm(params)
    {
        if(!("userid" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(survivor, 9)) { return; }

        // * Ensures that the survivor triggered the car alarm, use for subsequent events.
        if(survivor.ValidateScriptScope())
        {
            local scope = survivor.GetScriptScope();
            scope.icel_ostca_dotrigger <- true;
            // * A special except boomer forces the survivor to trigger the car alarm.
            if(survivor.IsDominatedBySpecialInfected())
            {
                local type = [1, 5, 6];
                local special = survivor.GetSpecialInfectedDominatingMe();
                if(type.find(special.GetZombieType()) != null)
                {
                    scope.icel_ostca_special <- special;
                }
            }

            if("icel_ostca_boomer" in scope)
            {
                if(scope.icel_ostca_boomer != null)
                {
                    for(local car; car = Entities.FindByClassnameWithin(car, "prop_car_alarm", scope.icel_ostca_boomer.GetOrigin(), Convars.GetFloat("z_exploding_outer_radius"));)
                    {
                        if(!car.IsValid()) { continue; }
                        if(IsCarAlarmTriggered(car)) { continue; }
                        if(car.ValidateScriptScope())
                        {
                            local scope = car.GetScriptScope();
                            if(!("icel_ostca_blocked" in scope))
                            {
                                car.GetScriptScope().icel_ostca_marked <- survivor;
                            }
                        }
                    }
                }
            }
        }

        DoEntFire("!self", "RunScriptCode", "::ICEL_OnSpecialTriggerCarAlarm_main.Delay_triggered_car_alarm(self);", 0.0, null, survivor);
    }

    // * THREE
    // This is when the survivor triggers the car alarm with the boomer.
    // make sure the survivor has icel_ostca_boomer and icel_ostca_dotrigger.
    // make sure the car is not triggered, has icel_ostca_marked and not blocked, fires on Delay_triggered_car_alarm.
    // make sure icel_ostca_boomer == boomer, and icel_ostca_marked == survivor
    function OnGameEvent_boomer_exploded(params)
    {
        if(!("userid" in params && "attacker" in params)) { return; }
        local survivor = GetPlayerFromUserID(params.attacker);
        local boomer = GetPlayerFromUserID(params.userid);
        if(!IsPlayer(survivor, 9) || !IsPlayer(boomer, 2)) { return; }

        if(survivor.ValidateScriptScope())
        {
            local scope = survivor.GetScriptScope();
            local clear_dotrigger = false;
            if("icel_ostca_boomer" in scope)
            {
                if("icel_ostca_dotrigger" in scope)
                {
                    for(local car; car = Entities.FindByClassname(car, "prop_car_alarm");)
                    {
                        if(!car.IsValid()) { continue; }
                        if(car.ValidateScriptScope())
                        {
                            local car_scope = car.GetScriptScope();
                            // !IsCarAlarmTriggered will return false, even if this event fires after triggered_car_alarm :(
                            // * m_hLastAttacker will display the survivor even if the boomer explosion touches it, I guess that explains triggered_car_alarm event.
                            if(!IsCarAlarmTriggered(car) && "icel_ostca_marked" in car_scope && !("icel_ostca_blocked" in car_scope) && NetProps.GetPropEntity(car, "m_hLastAttacker") == survivor)
                            {
                                if(car_scope.icel_ostca_marked == survivor && scope.icel_ostca_boomer == boomer)
                                {
                                    car_scope.icel_ostca_fire <- [survivor, boomer];
                                    clear_dotrigger = true;
                                }
                                delete car_scope.icel_ostca_marked;
                            }
                        }
                    }
                }
                // * Always delete on boomer_exploded no matter what.
                delete scope.icel_ostca_boomer;
            }
            // * If triggered the car alarm by killing the boomer then clear dotrigger info.
            if(clear_dotrigger) { delete scope.icel_ostca_dotrigger; }
        }
    }

    // * FOUR
    // IsCarAlarmTriggered will always return true;
    // *Do note that icel_ostca_marked on car and icel_ostca_dotrigger on survivor may still be alive.
    function OnCarAlarmStart(car)
    {
        if(car.ValidateScriptScope())
        {
            local scope = car.GetScriptScope();
            // * triggers the car alarm by killing the boomer.
            if("icel_ostca_fire" in scope)
            {
                local survivor = scope.icel_ostca_fire[0];
                local boomer = scope.icel_ostca_fire[1];
                if(survivor != null && boomer != null && !("icel_ostca_blocked" in scope))
                {
                    /**
                     * @main
                     */
                    FireCustomEvent(survivor.GetPlayerUserId(), boomer.GetPlayerUserId(), car.GetEntityIndex(), { event = "OnCarAlarmStart", });
                }
                delete scope.icel_ostca_fire;
            }
            // * triggeres the car alarm by other specials.
            else if("icel_ostca_marked" in scope)
            {
                local survivor = scope.icel_ostca_marked;
                if(survivor != null)
                {
                    if(survivor.ValidateScriptScope())
                    {
                        local surv_scope = survivor.GetScriptScope();
                        if("icel_ostca_dotrigger" in surv_scope && "icel_ostca_special" in surv_scope)
                        {
                            scope.icel_ostca_fire2 <- [survivor, surv_scope.icel_ostca_special];
                            DoEntFire("!self", "RunScriptCode", "::ICEL_OnSpecialTriggerCarAlarm_main.Delay_OnCarAlarmStart(self);", 0.0, null, car);
                            delete surv_scope.icel_ostca_dotrigger;
                            delete surv_scope.icel_ostca_special;
                        }
                    }
                }

                delete scope.icel_ostca_marked;
            }
            // block triggered car no matter what.
            scope.icel_ostca_blocked <- true;
        }
    }

    // * FIVE
    // for survivor, delete icel_ostca_boomer, icel_ostca_dotrigger and icel_ostca_special.
    // for car, delete icel_ostca_marked no matter what, as a bonus if it's triggered, block it.
    // delete icel_ostca_fire no matter what.
    function Delay_triggered_car_alarm(survivor)
    {
        if(survivor != null)
        {
            if(survivor.ValidateScriptScope())
            {
                local scope = survivor.GetScriptScope();
                if("icel_ostca_boomer" in scope) { delete scope.icel_ostca_boomer; }
                if("icel_ostca_dotrigger" in scope) { delete scope.icel_ostca_dotrigger; }
                if("icel_ostca_special" in scope) { delete scope.icel_ostca_special; }
            }
        }
        for(local car; car = Entities.FindByClassname(car, "prop_car_alarm");)
        {
            if(!car.IsValid()) { continue; }
            if(car.ValidateScriptScope())
            {
                local scope = car.GetScriptScope();
                if("icel_ostca_marked" in scope)
                {
                    delete scope.icel_ostca_marked;
                }
            }
        }
    }

    // * SIX
    // Clear icel_ostca_fire2 when hitting the car while dominated by specials
    // ! A charger carrying a survivor that charges to the car will fire this, wtf.
    function OnTakeDamage(survivor, car) // Hitting the car or the glass will fire this event.
    {
        // ! This will not be consistent if the survivor doesn't trigger the car by this method.
        // However, I am pretty sure it is impossible.
        if(NetProps.GetPropEntity(survivor, "m_carryAttacker") != null)
        {
            if(Entities.FindByClassnameNearest("prop_car_alarm", survivor.GetOrigin(), 0.0) == car)
            { return; }
        }

        if(car.ValidateScriptScope())
        {
            local scope = car.GetScriptScope();
            if(IsCarAlarmTriggered(car) && "icel_ostca_fire2" in scope)
            {
                delete scope.icel_ostca_fire2;
            }
        }
    }

    // * SEVEN
    // Triggering the car alarm while dominated by specials.
    function Delay_OnCarAlarmStart(car)
    {
        if(car == null) { return; }
        if(car.ValidateScriptScope())
        {
            local scope = car.GetScriptScope();
            if("icel_ostca_fire2" in scope)
            {
                local survivor = scope.icel_ostca_fire2[0];
                local special = scope.icel_ostca_fire2[1];
                if(survivor != null && special != null)
                {
                    /**
                     * @main
                     */
                    FireCustomEvent(survivor.GetPlayerUserId(), special.GetPlayerUserId(), car.GetEntityIndex(), { event = "delayed_OnCarAlarmStart", });
                }
                delete scope.icel_ostca_fire2;
            }
        }
    }
}

::ICEL_OnSpecialTriggerCarAlarm_main.Thinker();
__CollectEventCallbacks(::ICEL_OnSpecialTriggerCarAlarm_main, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);