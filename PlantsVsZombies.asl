// For Steam version users, you have to open PVZ before LiveSplit.
// If you run LiveSplit first this script won't work due to the stupid Steam logic.

// Timer should start at -8.80 seconds in NG+, at -5.00 in Endless categories, at -6.00 in other categories.

state("popcapgame1"){                       // main process of Steam version
	int gamestate : 0x331c50, 0x91c;
	int levelID : 0x331c50, 0x918;
	int level: 0x331c50, 0x94c, 0x50;
	int timesadventurecompleted: 0x331c50, 0x94c, 0x58;
	int sun: 0x331c50, 0x868, 0x5578;
	int endlessstreak: 0x331c50, 0x868, 0x178, 0x6c;
	int gametime: 0x331c50, 0x868, 0x5584;
}

state("PlantsVsZombies", "1051"){                    // main process of original version
	int gamestate : 0x2a9ec0, 0x7fc;
	int levelID: 0x2a9ec0, 0x7f8;              // 0 = Adventure, 16 = Zombotany, 51 = Vasebreaker, 1 = Survival: Day
	int level: 0x2a9ec0, 0x82c, 0x24;          // current level in Adventure mode, 1 = 1-1, 2 = 1-2, etc
	int timesadventurecompleted: 0x2a9ec0, 0x82c, 0x2c;
	int sun: 0x2a9ec0, 0x768, 0x5560;
	int endlessstreak: 0x2a9ec0, 0x768, 0x160, 0x6c;
	int gametime: 0x2a9ec0, 0x768, 0x556c;
}


state("PlantsVsZombies", "1073en"){                    // main process of original version
	int gamestate : 0x329670, 0x91c;
	int levelID: 0x329670, 0x918;              // 0 = Adventure, 16 = Zombotany, 51 = Vasebreaker, 1 = Survival: Day
	int level: 0x329670, 0x94c, 0x4c;          // current level in Adventure mode, 1 = 1-1, 2 = 1-2, etc
	int timesadventurecompleted: 0x329670, 0x94c, 0x54;
	int sun: 0x329670, 0x868, 0x5578;
	int endlessstreak: 0x329670, 0x868, 0x178, 0x6c;
	int gametime: 0x329670, 0x868, 0x5584;
}

init{
	vars.isendless = false;
	vars.startinglevels = new List<int>(){1,2,3,4,5,6,7,8,9,10,16,18,31,51,55,59,61,69};
	vars.endlesslevels = new List<int>(){60,70,13};
	if (modules.First().ModuleMemorySize <= 4000000)
		version = "1051";
	else
		version = "1073en";
}

startup{
	settings.Add("splitinsurvival", true, "Split after every round in non-Endless Survival Mode");
	settings.Add("splitinlaststand", false, "Split after every round in Last Stand");
}

start{
	if (current.timesadventurecompleted == 0){
		if (current.levelID == 0 && current.level == 1 && current.gamestate == 3 && current.sun == 50){
		// Any% or 100%
			return true;
		}
	}
	else if (current.gametime >=1 && current.gametime <= 20){
		if ( vars.startinglevels.Contains(current.levelID) ){
			return true;
		}
		else if ( vars.endlesslevels.Contains(current.levelID) ){
			vars.isendless = true;
			return true;	
		}
		else if (current.levelID == 0 && current.level == 1){
		// NG+
			return true;
		}
	}
}
split{
	if (current.levelID == 0)
		return current.level != old.level;
	else
		return (current.gamestate == 5 || current.gamestate == 7) && old.gamestate == 3 || (vars.isendless || current.levelID <= 10 && settings["splitinsurvival"] || current.levelID == 31 && settings["splitinlaststand"]) && current.endlessstreak != old.endlessstreak;
}
