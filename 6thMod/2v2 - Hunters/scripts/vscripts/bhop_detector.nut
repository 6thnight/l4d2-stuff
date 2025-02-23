printl("<mt2> Load bunny-hop detect script 1.4.1")

::BhopVars <-
{
    BunnyHopTimerEnabled = false,
    BunnyCounter =  array(32,0),
    LastBunnyTopSpeed =  array(32,0),
    LastBunnySpeed =  array(32,0),
    BunnyGroundTime =  array(32,0),
    BunnyFailFlag =  array(32,0),
    BunnyDetectCount = 3,
    BunnyDetectSpeed = 350,
    jumpingList = {}
}

::BhopFunc <-
{
    addThinkTimer = function()
    {
        local checkThinkTimer = false;
        local ent = null;
        while (ent = Entities.FindByClassname(ent,"info_target"))
        {
            if (ent.IsValid() && ent.GetName() == "bhopTimer")
            {
                ent.Kill();
                break;
            }
        }

        if(checkThinkTimer == false)
        {
            ::BhopVars._bhop_detect_timer <- SpawnEntityFromTable("info_target",{targetname = "bhopTimer"});
            if(::BhopVars._bhop_detect_timer != null)
            {
                ::BhopVars.BunnyHopTimerEnabled = true;
                ::BhopVars._bhop_detect_timer.ValidateScriptScope();
                local scrScope = ::BhopVars._bhop_detect_timer.GetScriptScope();
                scrScope["ThinkTimer"] <- ::BhopFunc.Think;
                AddThinkToEnt(::BhopVars._bhop_detect_timer,"ThinkTimer");
            }
        }
    }
    loadFile = function()
    {
        local path = "simple_bunnyhop_detect/bhop_detect_condition.txt";
        local file = FileToString(path);

        if(!file)
        {
            StringToFile(path,::BhopVars.BunnyDetectCount+","+::BhopVars.BunnyDetectSpeed);
            return;
        }

        try
        {
            local arr = split(file,",");
            ::BhopVars.BunnyDetectCount = arr[0].tointeger();
            ::BhopVars.BunnyDetectSpeed = arr[1].tointeger();

            printl("Bunnyhop detect condition :  count "+arr[0]+" / speed "+arr[1]);
        }
        catch(error)
        {
            printl("Bunnyhop detect condition error :  Invaild value");
        }
    }

    IsAlive = function(player)
    {
        if (!player.IsValid())
        {
            return false;
        }

        local pClass = player.GetClassname();

        if (pClass == "player"
        || pClass == "witch"
        || pClass == "infected")
        {
            return NetProps.GetPropInt(player,"m_lifeState") == 0;
        }
        else
        {
            return player.GetHealth() > 0;
        }
    }


    checkBhop = function (player)
    {
        if(!player)
        {
            return false;
        }
        else if(!player.IsValid() || !this.IsAlive(player))
        {
            return false;
        }

        local vars = ::BhopVars;
        local pName = player.GetPlayerName();
        local index = player.GetEntityIndex();
        local LBT = vars.LastBunnyTopSpeed;
        local BGT = vars.BunnyGroundTime;
        local speed = player.GetVelocity().Length();
        local playerFlag = NetProps.GetPropInt(player,"m_fFlags");
        local isOnGround = playerFlag == ( playerFlag | 1 );
        local Fail = vars.BunnyFailFlag;

        if(speed > LBT[index])
        {
            LBT[index] = speed;
        }

        if(isOnGround == true || Fail[index] == 1)
        {
            if(BGT[index] >= 3 || Fail[index] == 1)
            {
                local BC = vars.BunnyCounter;
                local count = BC[index];
                local topspeed = floor(LBT[index]+0.5);
                if(count >= vars.BunnyDetectCount && topspeed >= vars.BunnyDetectSpeed)
                {
                    ClientPrint(null,5,"\x04★ " + "\x05"+pName+"\x01 got \x05"+count+"\x01 bunnyhop"+((count > 1)?"s":"")+ " in a row (top speed: \x05"+topspeed+"\x01)");
                }
                BC[index] = 0;
                LBT[index] = 0;
                vars.LastBunnySpeed[index] = 0;
                Fail[index] = 0;

                return false;
            }
            else
            {
                BGT[index]++;
            }
        }
        else if(BGT[index] > 0)
        {
            BGT[index] = 0;
        }
    }

    Think = function()
    {
        foreach(index,player in ::BhopVars.jumpingList)
        {
            if(::BhopFunc.checkBhop(player) == false)
            {
                delete ::BhopVars.jumpingList[index];
            }
        }
    }
}

::BhopEvent <-
{
    OnGameEvent_player_jump = function (params)
    {
        local vars = ::BhopVars;
        if(::BhopVars.BunnyHopTimerEnabled == false)
        {
            return;
        }

        local player = GetPlayerFromUserID(params.userid);

        if(IsPlayerABot(player) == false)
        {
            local index = player.GetEntityIndex();
            local speed = player.GetVelocity().Length();
            local LBS = vars.LastBunnySpeed;
            local pName = player.GetPlayerName();
            local indexName = "bhop"+index;

            if(!(indexName in vars.jumpingList))
            {
                if(speed > 150)
                {
                    LBS[index] = 0;
                    vars.LastBunnyTopSpeed[index] = 0;
                    vars.jumpingList[indexName] <- player;
                }
            }
            else
            {
                local incSpeed = speed - LBS[index];
                local BC = vars.BunnyCounter;
                if(incSpeed > 0.01 || speed > 300)
                {
                    BC[index]++;
                    if(speed > vars.LastBunnyTopSpeed[index])
                    {
                        vars.LastBunnyTopSpeed[index] = speed;
                    }
                }
                else if(BC[index] > 0)
                {
                    vars.BunnyFailFlag[index] = 1;
                    vars.BunnyGroundTime[index] = 10;
                }
            }

            LBS[index] = speed;
        }
    }
}

::BhopFunc.addThinkTimer();
::BhopFunc.loadFile();

__CollectEventCallbacks(::BhopEvent, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);