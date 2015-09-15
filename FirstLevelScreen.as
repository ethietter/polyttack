package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class FirstLevelScreen extends MovieClip 
	{
		private var game_state_manager:GameStateManager;
		public function FirstLevelScreen(gsm_ref:GameStateManager) {
			game_state_manager = gsm_ref;
		}
		
		public function init() {
			start_level_1_btn.addEventListener(MouseEvent.MOUSE_UP, onStartBtnRelease, false, 0, true);
		}
		
		private function onStartBtnRelease(evt:MouseEvent) {
			destroy();
			game_state_manager.continueGame();
		}
		
		public function destroy() {
			start_level_1_btn.removeEventListener(MouseEvent.MOUSE_UP, onStartBtnRelease, false);
			this.parent.removeChild(game_state_manager.first_level_screen);
		}
	}
	
}