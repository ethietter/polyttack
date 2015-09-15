package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Grenade extends WeaponObject 
	{
		public static const GRENADE_RADII:Array = new Array(80, 85, 90, 95, 105, 115);
		
		
		private const GRENADE_WAIT_TIME:int = 20;
		
		private var game_play:GamePlay;
		private var polys_array:Array;
		private var grenade_radius:int
		private var grenade_radius_squared:int;
		private var landed = false;
		private var count:int = 0;
		private var explosion_player:SpritesheetPlayer = new SpritesheetPlayer(88, 93, true, 0x0);
		private var explosion_over:Boolean = false;
		private var explosion_started:Boolean = false;
		private var original_grenade_x:int;
		private var original_grenade_y:int;
		
		public function Grenade(game_play_ref:GamePlay) {
			uses_clock = true;
			game_play = game_play_ref;
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int, grenade_level:int) {
			grenade_radius = GRENADE_RADII[grenade_level] + Constants.POLY_ATTACK_RADIUS;
			grenade_radius_squared = grenade_radius * grenade_radius;
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
			addEventListener("grenade_landed", onGrenadeLand, false, 0, true);
			addChild(explosion_player);
			explosion_player.loadBmp(new ExplosionBitmap(0, 0));
			explosion_player.x = explosion_player.y = -44;
			explosion_player.scaleX = explosion_player.scaleY = grenade_radius * 1.3 / (GRENADE_RADII[0] + Constants.POLY_ATTACK_RADIUS);
		}
		
		private function onGrenadeLand(evt:Event) {
			count = 0;
			landed = true;
		}
		
		public function step() {
			if(!is_used && landed && !explosion_started){
				count++;
				if (count >= GRENADE_WAIT_TIME) {
					explode();
				}
			}
			if (!is_used) {
				if(explosion_started){
					if(!explosion_over){
						explosion_over = explosion_player.advanceFrame(2);
					}
					else {
						is_used = true;
					}
				}
			}
		}
		private function explode(){
			if (!is_used) {
				showExplosion();
				for (var i:int = 0; i < polys_array.length; i++) {
					var dist_squared:Number = (this.x - polys_array[i].X) * (this.x - polys_array[i].X) + (this.y - polys_array[i].Y) * (this.y - polys_array[i].Y);
					if (dist_squared < grenade_radius_squared) {
						polys_array[i].attacked(3);
					}
				}
				this.grenade_body.visible = false;
			}
		}
		
		private function showExplosion() {
			//add explosion animation here
			explosion_started = true;
			game_play.main.playSoundEffect("grenade_sound", false);
		}
				
		override public function destroy() {
			is_used = true;
		}
		
		
	}
	
}