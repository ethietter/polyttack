package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class MenuScreen extends MovieClip {
		
		private var main:MovieClip;
		private var hover_filter:GlowFilter = new GlowFilter(0xFFCC99, 1, 5, 5, 2);
		
		public function MenuScreen(main_ref:MovieClip) {
			main = main_ref;
		}
		public function init() {
			
			new_game_btn.addEventListener(MouseEvent.MOUSE_UP, onNewGameClick, false, 0, true);
			new_game_btn.addEventListener(MouseEvent.MOUSE_OVER, onNewGameOver, false, 0, true);
			
			//load_btn.addEventListener(MouseEvent.MOUSE_UP, onLoadClick, false, 0, true);
			//load_btn.addEventListener(MouseEvent.MOUSE_OVER, onLoadOver, false, 0, true);
			
			//survival_btn.addEventListener(MouseEvent.MOUSE_UP, onSurvivalClick, false, 0, true);
			//survival_btn.addEventListener(MouseEvent.MOUSE_OVER, onSurvivalOver, false, 0, true);
			
			//upgrades_btn.addEventListener(MouseEvent.MOUSE_UP, onUpgradesClick, false, 0, true);
			//upgrades_btn.addEventListener(MouseEvent.MOUSE_OVER, onUpgradesOver, false, 0, true);
			
			music_btn.addEventListener(MouseEvent.MOUSE_OVER, onMusicOver, false, 0, true);
			music_btn.addEventListener(MouseEvent.CLICK, onMusicClick, false, 0, true);
			music_btn.addEventListener(MouseEvent.MOUSE_OUT, onMusicOut, false, 0, true);
			
			sfx_btn.addEventListener(MouseEvent.MOUSE_OVER, onSfxOver, false, 0, true);
			sfx_btn.addEventListener(MouseEvent.CLICK, onSfxClick, false, 0, true);
			sfx_btn.addEventListener(MouseEvent.MOUSE_OUT, onSfxOut, false, 0, true);
			
			if (main.musicMuted()) {
				music_btn.gotoAndStop(2);
			}
			if (main.sfxMuted()) {
				sfx_btn.gotoAndStop(2);
			}
		}
		
		private function onSfxClick(evt:MouseEvent){
			toggleSoundEffects();
		}
		private function onSfxOver(evt:MouseEvent){
			sfx_btn.filters = [hover_filter];
			sfx_btn.buttonMode = true;
			useHandCursor = true;
		}
		private function onSfxOut(evt:MouseEvent) {
			sfx_btn.filters = [];
		}
		
		private function onMusicClick(evt:MouseEvent){
			toggleMusic();
		}		
		private function onMusicOver(evt:MouseEvent){
			music_btn.filters = [hover_filter];
			music_btn.buttonMode = true;
			useHandCursor = true;
		}
		private function onMusicOut(evt:MouseEvent) {
			music_btn.filters = [];
		}
		
		
		private function onNewGameClick(evt:MouseEvent) {
			main.game_state_manager.beginGame();
			hide();
		}
		
		private function onNewGameOver(evt:MouseEvent) {
			main.playSoundEffect("switch_item_sound", false);
		}
		
		private function onSurvivalClick(evt:MouseEvent) {
			main.game_state_manager.beginSurvivalGame();
			hide();
		}
		
		private function onSurvivalOver(evt:MouseEvent) {
			main.playSoundEffect("switch_item_sound", false);
		}
		
		public function hide() {
			main.removeChild(main.menu_screen);
		}
		
		
		private function toggleSoundEffects() {
			if (main.toggleSoundEffects()) {
				sfx_btn.gotoAndStop(2);
			}
			else {
				sfx_btn.gotoAndStop(1);
			}
		}
		
		private function toggleMusic() {
			if (main.toggleMusic("menu_song")) {
				music_btn.gotoAndStop(2);
			}
			else {
				music_btn.gotoAndStop(1);
			}			
		}
	}
	
}