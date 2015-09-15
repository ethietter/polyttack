package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class ConfirmUpgrade extends MovieClip 
	{
		private var interlevel_screen:InterlevelScreenBase;
		private var curr_item:String = "";
		private var curr_amount:int = 0;
		private var curr_level:int = 0;
		public function ConfirmUpgrade() {
		}
		
		public function init(interlevel_screen_ref:InterlevelScreenBase){
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			no_btn.addEventListener(MouseEvent.CLICK, onNoClick);
			yes_btn.addEventListener(MouseEvent.CLICK, onYesClick);
			interlevel_screen = interlevel_screen_ref;
		}
		
		private function onNoClick(evt:MouseEvent) {
			interlevel_screen.cancelUpgrade();
		}
		
		private function onYesClick(evt:MouseEvent) {
			if (curr_item != "" && curr_amount != 0) {
				interlevel_screen.purchaseUpgrade(curr_item, curr_amount, curr_level);
				curr_amount = 0;
				curr_item = "";
			}
		}
		private function onKeyPress(evt:KeyboardEvent) {
			if (evt.keyCode == 27) {
				interlevel_screen.cancelUpgrade();
			}
		}
		public function hide() {
			this.x = -1000;
		}
		
		public function show(item:String, amount_p:int, level_p:int) {
			curr_item = item;
			curr_amount = amount_p;
			curr_level = level_p;
			var item_str:String = "";
			switch(item) {
				case UpgradeConstants.ID_GRENADE:
					item_str = "Grenade Radius";
					break;
				case UpgradeConstants.ID_HEALTH:
					item_str = "Minion Health";
					break;
				case UpgradeConstants.ID_SPEED:
					item_str = "Minion Speed";
					break;
				case UpgradeConstants.ID_ROCKET_LAUNCHER:
					item_str = "Rocket Launcher Rate";
					break;
				case UpgradeConstants.ID_SPITTER:
					item_str = "Spitter Health";
					break;
			}
			this.x = 0;
			this.upgrade_txt.text = "Upgrade\n" + item_str + "\nfor $" + curr_amount + "?";
		}
	}
	
}