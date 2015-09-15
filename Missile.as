package 
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Missile extends MovieClip 
	{
		
		private var polys_array:Array;
		private var parent_x:int;
		private var parent_y:int;
		private var velx:Number = 0;
		private var vely:Number = 0;
		private var is_used:Boolean = false;
		private var speed:Number = 12;
		private var true_x:int;
		private var true_y:int;
		private var poly_target:Poly;
		private var accel:Number = 1.5;
		private const RADIUS:int = 10;
		private var velx_log:Array = new Array();
		private var vely_log:Array = new Array();
		private var output_count:int = 0;
		private var weapons_handler:WeaponsHandler;
		
		public function Missile() {
			
		}
		
		public function init(start_x:int, start_y:int, angle:Number, polys_array_ref:Array, poly_target_ref:Poly, weapons_handler_ref:WeaponsHandler) {
			polys_array = polys_array_ref;
			parent_x = start_x;
			parent_y = start_y;
			velx = speed * Math.cos(angle);
			vely = speed * Math.sin(angle);
			poly_target = poly_target_ref;
			setRotation();
			weapons_handler = weapons_handler_ref;
		}
		
		private function setTarget(){
			var most_sides:int = 0;
			var curr_index:int = 0;
			for (var i:int = 0; i < polys_array.length; i++) {
				if (!polys_array[i].isDead()) {
					if (polys_array[i].getNumSides() >= most_sides) {
						curr_index = i;
						most_sides = polys_array[i].getNumSides();
					}
				}			}
			return polys_array[curr_index];
		}
		
		private function setRotation() {
			var radians:Number = Math.atan2(vely, velx);
			inner_missile.rotation = radians * 180 / Math.PI;
		}
		
		private function normalizeVelocity() {
			var curr_speed:Number = Math.sqrt(velx*velx+vely*vely)
			velx = speed*velx/(curr_speed)
			vely = speed*vely/(curr_speed)
		}
		
		public function step() {
			true_x = this.x + parent_x;
			true_y = this.y + parent_y;
			if (!is_used) {
				if(poly_target == null){
					poly_target = setTarget();
				}
				if(poly_target != null){
					if (!poly_target.isDead()) {
						velx += accel * Math.abs(poly_target.X - true_x) / (poly_target.X - true_x);
						vely += accel * Math.abs(poly_target.Y - true_y) / (poly_target.Y - true_y);
						normalizeVelocity();
						setRotation();
					}
					else {
						poly_target = setTarget();
					}
				}
				this.x += velx;
				this.y += vely;
				for (var i:int = 0; i < polys_array.length; i++) {
					if ((true_x - polys_array[i].X) * (true_x - polys_array[i].X) + (true_y - polys_array[i].Y) * (true_y - polys_array[i].Y) < (RADIUS + Constants.POLY_ATTACK_RADIUS) * (RADIUS + Constants.POLY_ATTACK_RADIUS)) {
						polys_array[i].attacked(100, true, false);
						is_used = true;
						weapons_handler.makeMissileExplosion(true_x, true_y);
						destroy();
					}
				}
			}
			if (true_x > Constants.STAGE_WIDTH + 100 || true_x < -100 || true_y > Constants.STAGE_HEIGHT + 100 || true_y < -100) {
				is_used = true;
				destroy();
			}
			
		}
		
		public function isUsed() {
			return is_used;
		}
		
		public function destroy() {
			if(this.stage != null){
				this.parent.removeChild(this);
			}
		}
	}
	
}