package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class ElectricFence extends WeaponObject 
	{
		
		private var polys_array:Array;
		private var p1:Point;
		private var p2:Point;
		private var fence_vector:Point;
		private var fence_normal_vector:Point;
		private var canvas:Sprite = new Sprite();
		private var gfx:Graphics = canvas.graphics;
		private var time:int = 0;
		private static const MAX_TIME:int = 300;
		private static const MAX_LENGTH:int = 250;
		
		public function ElectricFence() {
			uses_clock = true;
		}
		
		public function init(polys_array_ref:Array, p1_p:Point, p2_p:Point) {
			polys_array = polys_array_ref;
			p1 = p1_p;
			p2 = p2_p;
			//distance formula squared
			//var length:Number = Math.sqrt((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y));
			fence_vector = new Point(p2.x - p1.x, p2.y - p1.y);
			var mag:Number = Math.sqrt(fence_vector.x * fence_vector.x + fence_vector.y * fence_vector.y);
			fence_normal_vector = new Point(-fence_vector.y / mag, fence_vector.x / mag);
			//if (length > MAX_LENGTH) {
				//var slope:Number = fence_vector.y / fence_vector.x;
				//p2.x = p1.x + fence_vector.
			//}
			addChild(canvas);
			drawFence();
		}
		
		private function drawFence() {
			gfx.clear();
			gfx.lineStyle(2, 0xFAFF78);
			gfx.moveTo(p1.x, p1.y);
			gfx.lineTo(p2.x, p2.y);
		}
		
		public function step() {
			/*Do electricity/check for collisions with polys*/
			if (!is_used) {
				var poly_vector:Point;
				for (var i:int = 0; i < polys_array.length; i++) {
					//this misses some collisions when either the fence or poly vectors are horizontal or vertical
					poly_vector = polys_array[i].getMotionVector();
					var intersect_t:Number = (fence_vector.y*polys_array[i].X - fence_vector.y*p1.x + fence_vector.x*p1.y - fence_vector.x*polys_array[i].Y)/(fence_vector.x*poly_vector.y - fence_vector.y*poly_vector.x);
					var intersect_x:Number = poly_vector.x*intersect_t + polys_array[i].X;
					var intersect_y:Number = poly_vector.y*intersect_t + polys_array[i].Y;
					if (isBetween(intersect_x, p1.x, p2.x) && isBetween(intersect_y, p1.y, p2.y)) {
						if (isBetween(intersect_x, polys_array[i].X, polys_array[i].X + poly_vector.x) && isBetween(intersect_y, polys_array[i].Y, polys_array[i].Y + poly_vector.y)) {
							var reflected_vector:Point = new Point(
								poly_vector.x - 2 * (poly_vector.x * fence_normal_vector.x + poly_vector.y * fence_normal_vector.y) * fence_normal_vector.x,
								poly_vector.y - 2 * (poly_vector.x * fence_normal_vector.x + poly_vector.y * fence_normal_vector.y) * fence_normal_vector.x
							);
							
							//polys_array[i].electrocuted(reflected_vector);
							polys_array[i].attacked();
						}
					}
				}
				time++;
				if (time >= MAX_TIME) {
					destroy();
				}
			}
		}
		
		private function isBetween(check_value:Number, bound1:Number, bound2:Number) {
			if (check_value == bound1 || check_value == bound2) return true;
			return ((Math.max(check_value, bound1, bound2) != check_value) && (Math.min(check_value, bound1, bound2) != check_value));//
		}
		
		
		override public function destroy() {
			is_used = true;
			if(canvas.stage != null) removeChild(canvas);
		}
		
	}
	
}