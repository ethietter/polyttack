package {
	
	public class Weapons {
		
		
		public static const PISTOL:String = "pistol";
		public static const GRENADE:String = "grenade";
		public static const MACHINE_GUN:String = "machine_gun";
		public static const SPITTER:String = "spitter";
		public static const ICE_CANNON:String = "ice_cannon";
		public static const FAN:String = "fan";
		public static const BLACK_HOLE:String = "black_hole";
		public static const ROCKET_LAUNCHER:String = "rocket_launcher";
		public static const FIRE:String = "fire";
		public static const ELECTRIC_FENCE:String = "electric_fence";
		public static const FIGHTER_JET:String = "fighter_jet";
		
		public static const GRENADE_COST:int = 20;
		public static const MACHINE_GUN_COST:int = 2;
		public static const SPITTER_COST:int = 1500;
		public static const ICE_CANNON_COST:int = 500;
		public static const FAN_COST:int = 1500;
		public static const BLACK_HOLE_COST:int = 7000;
		public static const ROCKET_LAUNCHER_COST:int = 5000;
		public static const FIRE_COST:int = 0; //1000;
		public static const ELECTRIC_FENCE_COST:int = 10;//cost per pixel
		public static const FIGHTER_JET_COST:int = 4000;
		
		public static const PISTOL_INFO:String = "Pistol\nCost: Free\nClick to fire";
		public static const GRENADE_INFO:String = "Grenade\nCost: $" + GRENADE_COST + "\nClick to launch a grenade";
		public static const MACHINE_GUN_INFO:String = "Machine Gun\nCost: $" + MACHINE_GUN_COST + "/shot\nClick and hold to fire";
		public static const SPITTER_INFO:String = "Spitter\nCost: $" + SPITTER_COST + "\nContinuously fires bullets once placed";
		public static const ICE_CANNON_INFO:String = "Ice Cannon\nCost: $" + ICE_CANNON_COST + "\nFires blocks of ice to freeze polys";
		public static const FAN_INFO:String = "Fan\nCost: $" + FAN_COST + "\nAn incredibly powerful fan! Blows polys away from it";
		public static const BLACK_HOLE_INFO:String = "Black Hole\nCost: $" + BLACK_HOLE_COST + "\nUse it to suck polys into oblivion";
		public static const ROCKET_LAUNCHER_INFO:String = "Rocket Launcher\nCost: $" + ROCKET_LAUNCHER_COST + "\nLaunches rockets at the polys";
		public static const FIRE_INFO:String = "Wildfire\nCost: $" + FIRE_COST + "\nStart a wildfire";
		public static const ELECTRIC_FENCE_INFO:String = "Electric Fence\nCost: $" + ELECTRIC_FENCE_COST + "/pixel\nShock the polys";
		public static const FIGHTER_JET_INFO:String = "Fighter Jet\nCost: $" + FIGHTER_JET_COST + "\nFlies around and bombards polys with grenades";
		
		public static const PISTOL_RANK:int = 1;
		public static const GRENADE_RANK:int = 2;
		public static const ICE_CANNON_RANK:int = 3;
		public static const MACHINE_GUN_RANK:int = 4;
		public static const SPITTER_RANK:int = 5;
		public static const FAN_RANK:int = 6;
		public static const BLACK_HOLE_RANK:int = 7;
		public static const ROCKET_LAUNCHER_RANK:int = 8;
		public static const FIRE_RANK:int = 9;
		public static const ELECTRIC_FENCE_RANK:int = 10;
		public static const FIGHTER_JET_RANK:int = 11;
	}
	
}