package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class FireGhost extends MovieClip 
	{
		
		private var fire_player:FirePlayer;
		public function FireGhost()
		{
		}
		public function init(fire_renderer:FireRenderer) {
			fire_player = new FirePlayer(fire_renderer, 60);
			addChild(fire_player);
			fire_player.x = -fire_player.width / 2;
			fire_player.y = -fire_player.height / 2;
		}
		
		public function step() {
			fire_player.step();
		}
	}
	
}