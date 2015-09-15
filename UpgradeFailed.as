package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class UpgradeFailed extends MovieClip 
	{
		
		private var interlevel_screen:InterlevelScreenBase;
		public function UpgradeFailed() {
			
		}
		
		
		public function init(interlevel_screen_ref:InterlevelScreenBase){
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			ok_btn.addEventListener(MouseEvent.CLICK, onOkClick);
			interlevel_screen = interlevel_screen_ref;
		}
		
		public function hide() {
			this.x = -1000;
		}
		
		public function show(amount_p:int) {
			var item_str:String = "";
			this.x = 0;
			this.upgrade_failed_txt.text = "You need $" + amount_p + "\nto purchase this upgrade!";
		}
		
		private function onOkClick(evt:MouseEvent) {
			interlevel_screen.clearUpgradeFailed();
		}
		
		private function onKeyPress(evt:KeyboardEvent) {
			if (evt.keyCode == 27 || evt.keyCode == 32 || evt.keyCode == 13) {
				interlevel_screen.clearUpgradeFailed();
			}
		}
	}
	
}