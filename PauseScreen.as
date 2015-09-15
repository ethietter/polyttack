package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class PauseScreen extends MovieClip 
	{
		
		private var game_play:GamePlay;
		private var confirm_quit:ConfirmQuit;
		
		public function PauseScreen() {
		}
		
		public function init(game_play_ref:GamePlay) {
			game_play = game_play_ref;
			
			//Fix this. What the hell was I thinking
			this.gotoAndStop(4);
			hide();
			
			
			resume_btn.addEventListener(MouseEvent.CLICK, onResumeClick, false, 0, true);
			quit_btn.addEventListener(MouseEvent.CLICK, onQuitClick, false, 0, true);
			
			confirm_quit = new ConfirmQuit();
			addChild(confirm_quit);
			confirm_quit.init(game_play.quitGame, this.confirm_quit.hide);
			confirm_quit.hide();
		}
		
		public function show() {
			//this.gotoAndStop(4);
			//resume_btn.addEventListener(MouseEvent.CLICK, onResumeClick, false, 0, true);
			//quit_btn.addEventListener(MouseEvent.CLICK, onQuitClick, false, 0, true);
			this.x = 0;
		}
		
		public function hide() {
			//resume_btn.removeEventListener(MouseEvent.CLICK, onResumeClick, false);
			//quit_btn.removeEventListener(MouseEvent.CLICK, onQuitClick, false);
			//this.gotoAndStop(0);
			this.x = -1000;
		}
		
		private function onResumeClick(evt:MouseEvent) {
			game_play.resume();
		}
		
		private function onQuitClick(evt:MouseEvent) {
			confirm_quit.show();
		}
	}
	
}