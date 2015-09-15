package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class UpgradeStar extends MovieClip 
	{
		
		private var level:int = 0;
		
		public function UpgradeStar() {
			level = parseInt(this.name.charAt(4));//this is idiotic
		}
		
		public function showState(state:int) {
			this.gotoAndStop(state);
		}
		
		public function getLevel() {
			return level;
		}
			
		
	}
	
}