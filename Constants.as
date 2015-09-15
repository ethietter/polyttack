package {
	
	public class Constants {
		
		
		/*Define all the constants */
		public static const STAGE_WIDTH:int = 450;
		public static const STAGE_HEIGHT:int = 450;
		public static const POLY_RADIUS:int = 23;
		public static const POLY_ATTACK_RADIUS:int = 26; //the "hit area" for the poly when the user is attacking it
		public static const POLY_KILL_RADIUS:int = 20; //the "hit area" for the poly when it is hitting a minion
		public static const POLY_HIT_VALUE:int = 40; //how much money the player gets when they hit a poly
		public static const MINION_WIDTH:int = 31;
		public static const MINION_HEIGHT:int = 27;
		public static const MINION_ATTACK_RADIUS:int = 15; // the "hit area" for the minion when it is being attacked by a poly
		public static const MINION_TRUE_RADIUS:int = 16; // radius used to determine minion spacing
		public static const SPITTER_LENGTH:int = 22;
		public static const ICE_CANNON_LENGTH:int = 19;
		public static const SURVIVAL_MODE:String = "survival_mode";
		public static const SEND_MINION_COST:int = 100;
		//how many polys to kill before the next rank
		public static const RANK_UP_AMOUNTS:Array = [9, 15, 30, 100, 200, 500, 800, 1000, 1200, 1600, 2200, 3000];
		
	}
	
}