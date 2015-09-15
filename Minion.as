package 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Minion extends MovieClip 
	{
		
		public static const DEBUG_SPEED:int = 12;
		public static const MINION_SPEEDS:Array = new Array(1, 1.5, 1.7, 2.1, 2.3, 2.6, DEBUG_SPEED);
		public static const MINION_HEALTH:Array = new Array(3, 4, 6, 9, 12, 15, 20);
		private static const MINION_SEPARATION:int = 50;
		
		private var game_play:GamePlay;
		private var waypoints_array:Array;
		private var pixels_moved:int = 0;
		private var sent_next:Boolean = false;
		private var health:int = 0;
		private var init_health:int = 0;
		private var speed:Number = 0;
		private var next_waypoint_index:int = 0;
		private var is_removed:Boolean = false;
		private var angle:Number = 0;
		private var speedx:Number = 0;
		private var speedy:Number = 0;
		
		public function Minion() {
			
		}
		
		public function init(game_play_ref:GamePlay, waypoints_array_ref:Array, init_speed:Number, init_health_p:int) {
			game_play = game_play_ref;
			waypoints_array = waypoints_array_ref;
			speed = init_speed;
			health = init_health = init_health_p;
			this.x = waypoints_array[0].x;
			this.y = waypoints_array[0].y;
		}
		
		public function step() {
			if (!isRemoved()) {
				var next_waypoint:Point = waypoints_array[next_waypoint_index];
				var dist:Number = Math.sqrt((next_waypoint.x - this.x) * (next_waypoint.x - this.x) + (next_waypoint.y - this.y) * (next_waypoint.y - this.y));
				if (dist <= speed) {
					this.x = next_waypoint.x;
					this.y = next_waypoint.y;
					next_waypoint_index++;
					if (next_waypoint_index == waypoints_array.length) {
						remove();
						game_play.minionSaved();
					}
					else{
						next_waypoint = waypoints_array[next_waypoint_index];
						angle = Math.atan2(next_waypoint.y - this.y, next_waypoint.x - this.x);
						this.rotation = angle * 180 / Math.PI;
					}
				}
				else {
					speedx = speed * (next_waypoint.x - this.x) / dist;
					speedy = speed * (next_waypoint.y - this.y) / dist;
					this.x += speedx;
					this.y += speedy;
					pixels_moved += Math.abs(speedx) + Math.abs(speedy);
				}
				if (pixels_moved >= Constants.MINION_TRUE_RADIUS + MINION_SEPARATION) {
					if(!sent_next){
						//game_play.sendMinion();
						sent_next = true;
					}
				}
			}
		}
		
		public function attacked(num_sides:int) {
			this.health -= num_sides - 2;
			this.health_bar.scaleX = this.health / this.init_health;
			if (health <= 0) {
				remove();
			}
		}
		
		public function levelOver() {
			//something weird's going on here...
			is_removed = true;
			sent_next = true;
			speedx = 0;
			speedy = 0;
			this.x = -100;
			//remove();
		}
		
		public function remove() {
			if (!sent_next) {
				//game_play.sendMinion();
				sent_next = true;
			}
			game_play.minimizeMinionsArray();
			is_removed = true;
			speedx = 0;
			speedy = 0;
			this.x = -100;
		}
		
		public function isRemoved() {
			return is_removed;
		}
	}
	
}