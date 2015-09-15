package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class LevelBackground extends MovieClip 
	{
		public var curr_background:MovieClip;
		private var level_1_bg:Level1Background;
		private var level_2_bg:Level2Background;
		private var level_3_bg:Level3Background;
		
		public function LevelBackground() {
			
		}
		
		public function init(curr_level:int) {
			switch(curr_level) {
				case 1:
					level_1_bg = new Level1Background();
					curr_background = level_1_bg;
					break;
				case 2:
					level_2_bg = new Level2Background();
					curr_background = level_2_bg;
					break;
				case 3:
					level_3_bg = new Level3Background();
					curr_background = level_3_bg;
					break;
			}
			curr_background = new Level1Background();
			addChild(curr_background);
		}
	}
	
}