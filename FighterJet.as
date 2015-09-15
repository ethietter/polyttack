package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class FighterJet extends WeaponObject 
	{
		
		private var center_x:int;
		private var center_y:int;
		private var weapons_handler:WeaponsHandler;
		private var t_wait:int = 35;
		private var count:int = 0;
		
		
		public function FighterJet() {
			uses_clock = true;
		}
		
		public function init(init_x:int, init_y:int, weapons_handler_ref:WeaponsHandler) {
			this.x = center_x = init_x;
			this.y = center_y = init_y;
			weapons_handler = weapons_handler_ref;
		}
		
		public function step() {
			count++;
			if (count > t_wait) {
				count = 0;
				var percent:Number = this.currentFrame / this.totalFrames;
				var drop_x:Number = percent;
				var drop_y_mult:Number = 1;
				if (drop_x > .5) drop_x -= 1;
				drop_x *= 200;//width of one circle in the figure eight
				if ((percent > 0 && percent < .25) || (percent > .5 && percent < .75)) drop_y_mult = -1;
				weapons_handler.dropGrenade(center_x + drop_x, center_y + Math.floor(Math.random()*100)*drop_y_mult);
			}
		}
	}
	
}