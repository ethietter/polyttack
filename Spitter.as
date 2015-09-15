package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Spitter extends WeaponObject 
	{
		
		private var game_play:GamePlay;
		private var polys_array:Array;
		private const SPITTER_RATE:int = 7;//how many frames to wait before shotting
		private var spitter_wait_count:int = 0;
		private var spitter_shots_array:Array = new Array();
		private var original_health:int = 10;
		private var health:int = original_health;
		private const HIT_RADIUS:int = Constants.POLY_ATTACK_RADIUS + 10;
		
		public function Spitter(game_play_ref:GamePlay) {
			game_play = game_play_ref;
			uses_clock = true;
		}
		
		public function init(polys_array_ref:Array, startx:int, starty:int) {
			polys_array = polys_array_ref;
			this.x = startx;
			this.y = starty;
			this.health_bar.visible = false;
		}
		
		public function step() {
			spitter_wait_count++;
			this.inside_spitter.rotation += 3;
			var i:int;
			if (spitter_wait_count >= SPITTER_RATE) {
				spitter_wait_count = 0;
				var spitter_shot:SpitterShot = new SpitterShot();
				addChild(spitter_shot);
				spitter_shot.init(this.x, this.y, this.inside_spitter.rotation * Math.PI / 180, polys_array);
				spitter_shots_array.push(spitter_shot);
				game_play.main.playSoundEffect("spitter_sound", false);
			}
			for (i = 0; i < spitter_shots_array.length; i++) {
				if (!spitter_shots_array[i].isUsed()) {
					spitter_shots_array[i].step();
				}
				else {
					spitter_shots_array[i].destroy();
					spitter_shots_array.splice(i, 1);
				}
			}
			/*for (i = 0; i < polys_array.length; i++) {
				if ((this.x - polys_array[i].X) * (this.x - polys_array[i].X) + (this.y - polys_array[i].Y) * (this.y - polys_array[i].Y) <= HIT_RADIUS*HIT_RADIUS) {
					attacked();
					polys_array[i].attacked();
				}
			}*/
		}
		
		public function attacked() {
			health--;
			this.health_bar.scaleX = health / original_health;
			if (health <= 0) {
				destroy();
			}
		}
		
		override public function destroy() {
			for (var i:int = 0; i < spitter_shots_array.length; i++) {
				spitter_shots_array[i].destroy();
				spitter_shots_array.splice(i, 1);
			}
			is_used = true;
		}
		
		
	}
	
}