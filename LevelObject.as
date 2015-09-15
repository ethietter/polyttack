package 
{
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class LevelObject 
	{
		public var launcher_locations:Array;
		public var launcher_sides:Array;
		public var launcher_wait_times:Array;
		public var minion_way_points:Array;
		public var wait_frame_max:int;
		public var min_launch_speed:int;
		public var max_launch_speed:int;
		public var minions_to_save:int;
		public var minions_available:int;
		public var is_survival_mode:Boolean;
		public var poly_limit:int;
		public var time_allowed:int;//in seconds
		
		public function LevelObject() {
			is_survival_mode = false;
		}
		
		public function makeSurvivalObject() {
			is_survival_mode = true;
		}
		
	}
	
}