package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class SavedGameScreen extends MovieClip 
	{
		private var game_state_manager:GameStateManager;
		
		public function SavedGameScreen(gsm:GameStateManager) {
			game_state_manager = gsm;
		}
		
		public function init() {
			load_game_btn.addEventListener(MouseEvent.CLICK, onLoadClick, false, 0, true);
			new_game_btn.addEventListener(MouseEvent.CLICK, onNewGameClick, false, 0, true);
		}
		
		private function onLoadClick(evt:MouseEvent) {
			this.parent.removeChild(this);
			load_game_btn.removeEventListener(MouseEvent.CLICK, onLoadClick, false);
			new_game_btn.removeEventListener(MouseEvent.CLICK, onNewGameClick, false);
			game_state_manager.startSavedGame();
		}
		
		private function onNewGameClick(evt:MouseEvent) {
			this.parent.removeChild(this);
			load_game_btn.removeEventListener(MouseEvent.CLICK, onLoadClick, false);
			new_game_btn.removeEventListener(MouseEvent.CLICK, onNewGameClick, false);
			game_state_manager.startNewGame();
		}
	}
	
}