package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class RocketLauncher extends WeaponObject 
	{
		private static const ROCKET_LAUNCHER_RATES:Array = [70, 50, 40, 35, 25, 15];
		
		private var polys_array:Array;
		private var missiles_array:Array = new Array();
		private var wait_count:int = 0;
		private var time_to_wait:int = 50;
		private var show_missile_time:int = 30;
		private var poly_target:Poly;
		private var target_rotation:Number = 0;
		private var weapons_handler:WeaponsHandler;
		
		public function RocketLauncher() {
			uses_clock = true;
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int, weapons_handler_ref:WeaponsHandler, rocket_launcher_level:int) {
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
			weapons_handler = weapons_handler_ref;
			poly_target = setTarget();
			time_to_wait = ROCKET_LAUNCHER_RATES[rocket_launcher_level];
			show_missile_time = time_to_wait / 2;
		}
		
		public function step() {
			if (!is_used) {
				wait_count++;
				if (wait_count >= show_missile_time) {
					this.launcher_circle.inner_missile.visible = true;
				}
				if(poly_target == null){
					poly_target = setTarget();
				}
				else{
					if (poly_target.isDead()) {
						poly_target = setTarget();
					}
					if(poly_target != null){
						target_rotation = Math.atan2(poly_target.Y - this.y, poly_target.X - this.x) * 180 / Math.PI;
						if (this.launcher_circle.rotation < target_rotation) {
							this.launcher_circle.rotation+=3;
						}
						if (this.launcher_circle.rotation > target_rotation) {
							this.launcher_circle.rotation-=3;
						}
						if(wait_count >= time_to_wait){
							var angle:Number = this.launcher_circle.rotation * Math.PI / 180;
							fire(angle, poly_target);
							wait_count = 0;
						}
					}
				}
				for (var i:int = 0; i < missiles_array.length; i++) {
					missiles_array[i].step();
				}
			}
		}
		
		private function setTarget(){
			var most_sides:int = 0;
			var curr_index:int = 0;
			if(polys_array.length < 1){
				return null;
			}
			for (var i:int = 0; i < polys_array.length; i++) {
				if (!polys_array[i].isDead()) {
					if (polys_array[i].getNumSides() >= most_sides) {
						curr_index = i;
						most_sides = polys_array[i].getNumSides();
					}
				}
			}
			return polys_array[curr_index];
		}
		
		//angle in radians
		private function fire(angle:Number, poly_target:Poly) {
			this.launcher_circle.inner_missile.visible = false;
			var missile:Missile = new Missile();
			addChild(missile);
			missile.init(this.x, this.y, angle, polys_array, poly_target, weapons_handler);
			missiles_array.push(missile);
			//game_play.main.playSoundEffect("missile_launched_sound", false);
		}
		
		override public function destroy() {
			is_used = true;
		}
		
		
	}
	
}