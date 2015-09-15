package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class BlackHole extends WeaponObject 
	{
		
		private var polys_array:Array;
		
		public function BlackHole() {
			uses_clock = true;
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int) {
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
		}
		
		public function step() {
			if(!is_used){
				this.black_hole_outer.rotation += .2;
				this.black_hole_inner.rotation += .1;
				for (var i:int = 0; i < polys_array.length; i++) {
					polys_array[i].blackHoleForce(this.x, this.y);
				}
			}
		}
		
		
		override public function destroy() {
			is_used = true;
		}
		
		
	}
	
}