package 
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class GameObject 
	{
		public var curr_level:int = 1;
		public var point_total:int = 0;
		public var curr_rank:int = 1;
		public var money_total:int = 0;
		public var minion_speed_level:int = 0;
		public var minion_health_level:int = 0;
		public var grenade_radius_level:int = 0;
		public var rocket_launcher_level:int = 0;
		public var spitter_health_level:int = 0;
		public var polys_killed:int = 0;//Number of polys destroyed at the current rank (used to determine how many are needed to rank up
		private const DEBUG_START:Boolean = false;
		
		public function GameObject(init_object:Object = null) {
			if (init_object != null) {
				curr_level = init_object.curr_level;
				point_total = init_object.point_total;
				curr_rank = init_object.curr_rank;
				minion_speed_level = init_object.minion_speed_level;
				minion_health_level = init_object.minion_health_level;
				money_total = init_object.money_total;
				polys_killed = init_object.polys_killed;
				grenade_radius_level = init_object.grenade_radius_level;
				rocket_launcher_level = init_object.rocket_launcher_level;
				spitter_health_level = init_object.spitter_health_level;
			}
			else {
				curr_level =  1;
				point_total = 0;
				curr_rank = 1;
				money_total = 1000;
				polys_killed = 0;
				minion_speed_level = 0;// 6;
				minion_health_level = 0;//2;
				grenade_radius_level = 0;//2;
				rocket_launcher_level = 0;//3;
				spitter_health_level = 0;//1;
				if (DEBUG_START) {
					curr_level = 1;
					curr_rank = 9;
					money_total = 1000000;
					minion_speed_level = 5;
					minion_health_level = 5;
				}
			}
		}
		public function reset() {
			curr_level = 1;
			point_total = 0;
			curr_rank = 1;
			money_total = 0;
			polys_killed = 0;//Number of polys destroyed at the current rank (used to determine how many are needed to rank up			
		}
		public function copy():GameObject {
			return new GameObject( {
					"curr_level":curr_level,
					"point_total":point_total,
					"curr_rank":curr_rank,
					"money_total":money_total,
					"minion_speed_level":minion_speed_level,
					"minion_health_level":minion_health_level,
					"polys_killed":polys_killed,
					"grenade_radius_level":grenade_radius_level,
					"rocket_launcher_level":rocket_launcher_level,
					"spitter_health_level":spitter_health_level
			});
		}
	}
	
}