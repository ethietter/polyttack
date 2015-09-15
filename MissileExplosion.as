package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class MissileExplosion extends WeaponObject 
	{
		
		private var game_play:GamePlay;
		private var polys_array:Array;
		private var explosion_player:SpritesheetPlayer = new SpritesheetPlayer(88, 93, true, 0x0);
		private var explosion_over:Boolean = false;
		private var explosion_started:Boolean = false;
		private const EXPLOSION_RADIUS_SQUARED:int = 70 * 70;
		
		public function MissileExplosion(game_play_ref:GamePlay) {
			uses_clock = true;
			game_play = game_play_ref;
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int) {
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
			addChild(explosion_player);
			explosion_player.loadBmp(new ExplosionBitmap(0, 0));
			explosion_player.x = explosion_player.y = -44;
			explode();
		}
		
		public function step() {
			if(!explosion_over){
				explosion_over = explosion_player.advanceFrame(2);
			}
			else {
				is_used = true;
			}
		}
		private function explode(){
			if (!is_used) {
				showExplosion();
				for (var i:int = 0; i < polys_array.length; i++) {
					var dist_squared:Number = (this.x - polys_array[i].X) * (this.x - polys_array[i].X) + (this.y - polys_array[i].Y) * (this.y - polys_array[i].Y);
					if (dist_squared < EXPLOSION_RADIUS_SQUARED) {
						polys_array[i].attacked(100);
					}
				}
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