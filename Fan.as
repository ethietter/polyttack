package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Fan extends WeaponObject 
	{
		
		private var polys_array:Array;
		
		public function Fan() {
			uses_clock = true;
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int) {
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
		}
		
		public function step() {
			if(!is_used){
				this.inside_fan.rotation += 20;
				for (var i:int = 0; i < polys_array.length; i++) {
					polys_array[i].fanPoly(this.x, this.y);
				}
			}
		}
		
		
		override public function destroy() {
			is_used = true;
		}
		
		
	}
	
}