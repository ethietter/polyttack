package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class IceShot extends MovieClip 
	{
		
		private var polys_array:Array;
		private var velx:Number = 0;
		private var vely:Number = 0;
		private var speed:Number = 12;
		private var is_used:Boolean = false;
		private var parent_x:int;
		private var parent_y:int;
		private var true_x:int;
		private var true_y:int;
		private const RADIUS:int = 15;
		
		public function IceShot() {
			
		}
		
		/*
		 * @param start_x The initial x position of the parent spitter
		 * @param start_y The initial y position of the parent spitter
		 * @param angle In radians
		 * @param polys_array_ref Reference to polys array
		 */
		public function init(start_x:int, start_y:int, angle:Number, polys_array_ref:Array) {
			polys_array = polys_array_ref;
			parent_x = start_x;
			parent_y = start_y;
			velx = speed * Math.cos(angle);
			vely = speed * Math.sin(angle);
			this.x += velx * Constants.ICE_CANNON_LENGTH / speed;
			this.y += vely * Constants.ICE_CANNON_LENGTH / speed;
		}
		
		public function step() {
			if (!is_used) {
				this.x += velx;
				this.y += vely;
			}
			true_x = this.x + parent_x;
			true_y = this.y + parent_y;
			if (true_x > Constants.STAGE_WIDTH || true_x < 0 || true_y > Constants.STAGE_HEIGHT || true_y < 0) {
				this.x = -100 - parent_x;
				is_used = true;
			}
			for (var i:int = 0; i < polys_array.length; i++) {
				if ((true_x - polys_array[i].X) * (true_x - polys_array[i].X) + (true_y - polys_array[i].Y) * (true_y - polys_array[i].Y) < (RADIUS + Constants.POLY_ATTACK_RADIUS) * (RADIUS + Constants.POLY_ATTACK_RADIUS)) {
					polys_array[i].frozen();
					is_used = true;
					this.x = -100 - parent_x;
				}
			}
		}
		
		public function isUsed() {
			return is_used;
		}
		
		public function destroy() {
			this.parent.removeChild(this);
		}
	}
	
}