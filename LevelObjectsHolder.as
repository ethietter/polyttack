package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class LevelObjectsHolder
	{
		public var levels_array:Array = new Array();
		public var level1:LevelObject = new LevelObject();
		public var level2:LevelObject = new LevelObject();
		public var level3:LevelObject = new LevelObject();
		public var level4:LevelObject = new LevelObject();
		public var level5:LevelObject = new LevelObject();
		public var survival_level:LevelObject = new LevelObject();
		
		public function LevelObjectsHolder() {
			/* how to define multiple launchers:
			levelX.launcher_locations = [new Point(350, 300), new Point(100,100), new Point(600,500)];
			levelX.launcher_sides = [3, 4, 5];
			levelX.launcher_wait_times = [80, 100, 160];
			*/
			
			//define survival level
			survival_level.launcher_locations = [new Point(Constants.STAGE_WIDTH / 2, Constants.STAGE_HEIGHT / 2)];
			survival_level.launcher_sides = [3];
			survival_level.launcher_wait_times = [120];
			survival_level.minion_way_points = [new Point(0, 0), new Point(0, Constants.STAGE_HEIGHT)];
			survival_level.wait_frame_max = 100;
			survival_level.min_launch_speed = 3;
			survival_level.max_launch_speed = 8;
			survival_level.minions_to_save = 20;
			survival_level.minions_available = 100;
			survival_level.makeSurvivalObject();
			
			// define level 1
			level1.launcher_locations = [new Point(90, 199)];
			level1.launcher_sides = [3];
			level1.launcher_wait_times = [120];
			level1.minion_way_points = [new Point(384, 485),new Point(384, -24)];
			level1.wait_frame_max = 100; //how many frames to wait for the next minion to show up
			level1.min_launch_speed = 3;
			level1.max_launch_speed = 5;
			level1.minions_to_save = 2;
			level1.minions_available = 25;
			level1.poly_limit = 20;
			level1.time_allowed = 180;
			
			// define level 2
			level2.launcher_locations = [new Point(224, 208)];
			level2.launcher_sides = [4];
			level2.launcher_wait_times = [120];
			level2.minion_way_points = [new Point(-16, 34),new Point(395, 34),new Point(395, 476)];
			level2.wait_frame_max = 100; //how many frames to wait for the next minion to show up
			level2.min_launch_speed = 4;
			level2.max_launch_speed = 6;
			level2.minions_to_save = 3;
			level2.minions_available = 25;
			level2.poly_limit = 20;
			level2.time_allowed = 180;
			
			//define level 3
			level3.launcher_locations = [new Point(287, 102),new Point(136, 328)];
			level3.launcher_sides = [3,4];
			level3.launcher_wait_times = [200,300];
			level3.minion_way_points = [new Point(482, 40),new Point(213, 40),new Point(213, 402),new Point(-37, 402)];
			level3.wait_frame_max = 100; //how many frames to wait for the next minion to show up
			level3.min_launch_speed = 4;
			level3.max_launch_speed = 6;
			level3.minions_to_save = 4;
			level3.minions_available = 25;
			level3.poly_limit = 20;
			level3.time_allowed = 180;
			
			//define level 4
			level4.launcher_locations = [new Point(83, 69),new Point(385, 391)];
			level4.launcher_sides = [3,5];
			level4.launcher_wait_times = [100,200];
			level4.minion_way_points = [new Point(82, 486),new Point(82, 209),new Point(391, 209),new Point(391, -28)];
			level4.wait_frame_max = 100; //how many frames to wait for the next minion to show up
			level4.min_launch_speed = 3;
			level4.max_launch_speed = 5;
			level4.minions_to_save = 6;
			level4.minions_available = 25;
			level4.poly_limit = 20;
			level4.time_allowed = 180;
			
			//define level 5
			level5.launcher_locations = [new Point(65, 72),new Point(400, 411),new Point(389, 66),new Point(54, 405)];
			level5.launcher_sides = [8,3,3,3];
			level5.launcher_wait_times = [300,60,70,70];
			level5.minion_way_points = [new Point(221, 471),new Point(221, 303),new Point(45, 303),new Point(45, 141),new Point(470, 141)];
			level5.wait_frame_max = 100; //how many frames to wait for the next minion to show up
			level5.min_launch_speed = 7;
			level5.max_launch_speed = 10;
			level5.minions_to_save = 10;
			level5.minions_available = 25;
			level5.poly_limit = 40;
			level5.time_allowed = 180;

			
			levels_array.push(null, level1, level2, level3, level4, level5);
		}
		
		public function getLevelObject(level_num:int) {
			return levels_array[level_num];
		}
		
		public function getSurvivalLevel() {
			return survival_level;
		}
	}
	
}