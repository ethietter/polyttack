package 
{
	
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class FireObject extends WeaponObject
	{
		
		private var fire_player:FirePlayer;
		private var polys_array:Array;
		private var is_static:Boolean;
		private var fire_width:int;
		private var poly_to_follow:Poly;
		private var weapons_handler:WeaponsHandler;
		private var burn_out_time:int;
		private var burn_out_count:int;
		
		public function FireObject(fire_renderer_ref:FireRenderer, weapons_handler_ref:WeaponsHandler, polys_array_ref:Array, init_x:Number, init_y:Number, is_static_p:Boolean = true, fire_width_p:Number = 40, poly_to_follow_p:Poly = null) {
			this.x = init_x;
			this.y = init_y;
			polys_array = polys_array_ref;
			is_static = is_static_p;
			poly_to_follow = poly_to_follow_p;
			fire_width = fire_width_p;
			weapons_handler = weapons_handler_ref;
			
			burn_out_time = 150 + Math.floor(Math.random() * 150);
			burn_out_count = 0;
			
			fire_player = new FirePlayer(fire_renderer_ref, fire_width);
			uses_clock = true;
		}
		
		public function init() {
			addChild(fire_player);
			fire_player.x = -fire_player.width / 2;
			fire_player.y = -fire_player.height / 2 - Math.floor(Math.random()*20);
		}
		
		public function step() {
			if(!is_used){
				burn_out_count++;
				if (burn_out_count > burn_out_time) {
					burnOut();
				}
				fire_player.step();
				if (poly_to_follow != null) {
					this.x = poly_to_follow.X;
					this.y = poly_to_follow.Y;
				}
				for (var i:int = 0; i < polys_array.length; i++) {
					if ((this.x - polys_array[i].X) * (this.x - polys_array[i].X) + (this.y - polys_array[i].Y) * (this.y - polys_array[i].Y) < (fire_width + Constants.POLY_ATTACK_RADIUS) * (fire_width + Constants.POLY_ATTACK_RADIUS)) {
						if(!polys_array[i].isOnFire()){
							if(Math.random() > .94){
								weapons_handler.makeFire(this.x, this.y, polys_array[i]);
								polys_array[i].setFire();
							}
						}
					}
				}
			}
		}
		
		private function burnOut() {
			if (poly_to_follow != null && poly_to_follow.isOnFire())
			{
				poly_to_follow.removeFire();
			}
			if(fire_player.stage != null) removeChild(fire_player);
			destroy();
		}
		
		override public function destroy() {
			is_used = true;
		}
	}
	
}