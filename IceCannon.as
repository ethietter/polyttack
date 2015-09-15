package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class IceCannon extends WeaponObject
	{
		
		private var polys_array:Array;
		private const TURN_DELAY:int = 30;
		private const FIRE_DELAY:int = TURN_DELAY + 30;
		private var delay_count:int = 0;
		private var ice_shots_array:Array = new Array();
		private var original_health:int = 10;
		private var health:int = original_health;
		private const HIT_RADIUS:int = Constants.POLY_ATTACK_RADIUS + 15;
		
		public function IceCannon() {
				
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int) {
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
			uses_clock = true;
			this.health_bar.visible = false;
		}
		
		public function step() {
			if (!is_used) {
				var i:int;
				delay_count++;
				if (delay_count == TURN_DELAY) {
					this.inside_cannon.rotation += 45;
				}
				if (delay_count == FIRE_DELAY) {
					delay_count = 0;
					for (var j:int = 0; j < 4; j++){
						fire((this.inside_cannon.rotation + j * 90) * Math.PI / 180);
					}
				}
				for (i = 0; i < ice_shots_array.length; i++) {
					if (!ice_shots_array[i].isUsed()) {
						ice_shots_array[i].step();
					}
					else {
						ice_shots_array[i].destroy();
						ice_shots_array.splice(i, 1);
					}
				}
				/*for (i = 0; i < polys_array.length; i++) {
					if ((this.x - polys_array[i].X) * (this.x - polys_array[i].X) + (this.y - polys_array[i].Y) * (this.y - polys_array[i].Y) <= HIT_RADIUS*HIT_RADIUS) {
						attacked();
						polys_array[i].attacked();
					}
				}*/
			}
		}
		
		override public function destroy() {
			this.x = -100;
			for (var i:int = 0; i < ice_shots_array.length; i++) {
				ice_shots_array[i].destroy();
				ice_shots_array.splice(i, 1);
			}
			is_used = true;
		}
		
		public function attacked() {
			health--;
			this.health_bar.scaleX = health / original_health;
			if (health <= 0) {
				destroy();
			}
		}
		
		private function fire(angle:Number){
			var ice_shot:IceShot = new IceShot();
			addChild(ice_shot);
			ice_shot.init(this.x, this.y, angle, polys_array);
			ice_shots_array.push(ice_shot);
		}
	}
	
}