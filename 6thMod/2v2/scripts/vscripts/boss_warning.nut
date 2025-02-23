const PREFIX			= "[Boss Warn]";
const GREEN 			= "\x03";
const ORANGE 			= "\x04";
const SPACER 			= " ";
const TANKWARNING		= "A Tank is nearby!";
const WITCHWARNING		= "A Witch is nearby!";

const TANKDEAD			= "A Tank has been killed!";
const WITCHDEAD			= "A Witch has been killed!";

const TANKSNDDELAY		= 2;
const WITCHSNDDELAY		= 2;
const HUD_PRINTTALK		= 3;

local WarnSound 		= "ui/pickup_secret01.wav";
local TankTimeDelay 	= 0;
local WitchTimeDelay 	= 0;

if ( !IsSoundPrecached( WarnSound ) )
{
	PrecacheSound( WarnSound )
}

BossWarning <-
{
	function OnGameEvent_player_spawn( params )
	{
		if ( "userid" in params && params.userid )
		{
			local BossInfected = GetPlayerFromUserID( params.userid );
			if ( BossInfected.GetZombieType() == 8 )
			{
				local currentTime = Time();
				if ( currentTime >= TankTimeDelay )
				{
					EmitAmbientSoundOn( WarnSound, 1.0, 0, RandomInt( 96, 103 ), BossInfected );
					TankTimeDelay = currentTime + TANKSNDDELAY;
				}

				ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + TANKWARNING ) );
			}
		}
	}

	function OnGameEvent_witch_spawn( params )
	{
		local witchEnt = EntIndexToHScript(params.witchid)
		local currentTime = Time();

		if ( currentTime >= WitchTimeDelay )
		{
			EmitAmbientSoundOn( WarnSound, 1.0, 0, RandomInt( 98, 104 ), witchEnt );
			WitchTimeDelay = currentTime + WITCHSNDDELAY;
		}

		ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + WITCHWARNING ) );
	}

	function OnGameEvent_player_death( params )
	{
		if ( !( "userid" in params ) )
			return;

		local victim = GetPlayerFromUserID( params[ "userid" ] );
		local zombieType = victim.GetZombieType();

		if ( zombieType == 8 )
		{
			ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + TANKDEAD ) );
		}
	}

	function OnGameEvent_witch_killed( params )
	{
		if ( !( "witchid" in params ) )
			return;

		ClientPrint( null, HUD_PRINTTALK, format( GREEN + PREFIX + ORANGE + SPACER + WITCHDEAD ) );
	}
}

__CollectEventCallbacks( BossWarning, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );