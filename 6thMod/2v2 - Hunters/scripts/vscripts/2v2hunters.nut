DirectorOptions <- {
	ActiveChallenge = 1

	cm_NoSurvivorBots = 1
	cm_AllowPillConversion = 0

	SmokerLimit = 0
	BoomerLimit = 0
	HunterLimit = 2
	SpitterLimit = 0
	JockeyLimit = 0
	ChargerLimit = 0

	EscapeSpawnTanks = false

	weaponsToConvert = {
		weapon_shotgun_spas = "weapon_shotgun_chrome_spawn"
		weapon_sniper_awp = "weapon_smg_spawn"
		weapon_sniper_scout = "weapon_smg_silenced_spawn"
		weapon_hunting_rifle = "weapon_pumpshotgun_spawn"
		weapon_sniper_military = "weapon_shotgun_chrome_spawn"
		weapon_pistol = "weapon_pistol_magnum_spawn"
		weapon_rifle_ak47 = "weapon_smg_silenced_spawn"
		weapon_rifle_desert = "weapon_smg_silenced_spawn"
		weapon_rifle_sg552 = "weapon_smg_silenced_spawn"
		weapon_smg_mp5 = "weapon_smg_silenced_spawn"
		weapon_autoshotgun = "weapon_shotgun_chrome_spawn"
		weapon_rifle = "weapon_smg_silenced_spawn"
	}

	function ConvertWeaponSpawn(classname) {
		if (classname in weaponsToConvert) {
			return weaponsToConvert[classname];
		}
		return 0;
	}

	weaponsToRemove = {
		weapon_first_aid_kit = 0
		weapon_vomitjar = 0
		weapon_molotov = 0
		weapon_pipe_bomb = 0
		weapon_chainsaw = 0
		weapon_grenade_launcher = 0
		weapon_upgradepack_explosive = 0
		weapon_upgradepack_incendiary = 0
		weapon_defibrillator = 0
		weapon_adrenaline = 0
		weapon_pain_pills = 0
		upgrade_item = 0
		weapon_rifle_m60 = 0
	}

	function AllowWeaponSpawn(classname) {
		if (classname in weaponsToRemove) {
			return false;
		}
		return true;
	}

	DefaultItems = [
		"weapon_pistol_magnum",
		"weapon_pain_pills",
	]

	function GetDefaultItem(idx) {
		if (idx < DefaultItems.len()) {
			return DefaultItems[idx];
		}
		return 0;
	}
}


function Update() {
	FireworkCrate <- null;
	while ((FireworkCrate = Entities.FindByModel(FireworkCrate, "models/props_junk/explosive_box001.md")) != null) {
		DoEntFire("!self", "kill", "", 0, null, FireworkCrate);
	}
	GasCan <- null;
	while ((GasCan = Entities.FindByModel(GasCan, "models/props_junk/gascan001a.mdl")) != null) {
		DoEntFire("!self", "kill", "", 0, null, GasCan);
	}
	OxygenTank <- null;
	while ((OxygenTank = Entities.FindByModel(OxygenTank, "models/props_equipment/oxygentank01.mdl")) != null) {
		DoEntFire("!self", "kill", "", 0, null, OxygenTank);
	}
	PropaneTank <- null;
	while ((PropaneTank = Entities.FindByModel(PropaneTank, "models/props_junk/propanecanister001a.mdl")) != null) {
		DoEntFire("!self", "kill", "", 0, null, PropaneTank);
	}
}