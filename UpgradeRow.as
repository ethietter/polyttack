package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class UpgradeRow extends MovieClip
	{
		/* DELETE THIS CLASS */
		
		
		/*private static const DEFAULT_STATE:int = 1;
		private static const HOVER_STATE:int = 2;
		private static const PRESS_STATE:int = 3;
		private static const SELECTED_STATE:int = 2;
		
		private var default_num_stars:int = 0;
		private var stars_array:Array = new Array();
		private var id:String = "";
		private var box:String = "";
		private var interlevel_screen:InterlevelScreen;
		
		public function UpgradeRow() {
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseHover);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			for (var i = 0; i < this.numChildren; i++) {
				stars_array.push(this.getChildAt(i));
			}
		}
		
		public function init(id_p:String, num_stars:int, interlevel_screen_ref:InterlevelScreen) {
			var e:Error = new Error();
			id = id_p;
			setDefaultStars(num_stars);
			interlevel_screen = interlevel_screen_ref;
			if (id == UpgradeConstants.ID_HEALTH || id == UpgradeConstants.ID_SPEED) {
				box = UpgradeConstants.MINION_BOX;
			}
			else {
				box = UpgradeConstants.WEAPONS_BOX;
			}
		}
		
		public function setDefaultStars(num_stars:int) {
			default_num_stars = num_stars;
			selectDefaultStars();
		}
		private function selectDefaultStars(){
			for (var i:int = 0; i < Math.min(default_num_stars, stars_array.length); i++) {
				stars_array[i].showState(SELECTED_STATE);
			}
		}
		
		private function onMouseOut(evt:MouseEvent) {
			for (var i = 0; i < stars_array.length; i++) {
				stars_array[i].showState(DEFAULT_STATE);
			}
			//interlevel_screen.clearUpgradeCost();
			selectDefaultStars();
		}
		
		private function onMouseHover(evt:MouseEvent) {
			for (var i = 0; i < stars_array.length; i++) {
				if (stars_array[i].getLevel() <= evt.target.getLevel()) {
					stars_array[i].showState(HOVER_STATE);
				}
			}
			selectDefaultStars();
			if (evt.target.getLevel() > default_num_stars) {
				this.buttonMode = true;
				this.useHandCursor = true;
			}
			else {
				this.buttonMode = false;
				this.useHandCursor = false;
			}
			var upgrade_cost:int = totalUpgradeCost(evt.target.getLevel());
			if (upgrade_cost != 0){
				//interlevel_screen.writeUpgradeCost(box, upgrade_cost);
			}
		}
		
		private function totalUpgradeCost(level:int) {
			var upgrade_cost:int = 0;
			var level_start:int = default_num_stars + 1;
			while(level_start <= level){
				upgrade_cost += interlevel_screen.getUpgradeCost(id, level_start);
				level_start++;
			}
			return upgrade_cost;
		}
		
		private function onMouseClick(evt:MouseEvent) {
			if (evt.target.getLevel() > default_num_stars) {
				interlevel_screen.confirmUpgrade(id, totalUpgradeCost(evt.target.getLevel()), evt.target.getLevel());
			}
		}*/
	}
	
}