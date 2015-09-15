package {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import mochi.as3.*;
	
	public class Main extends MovieClip {
		
		public var intro_screen:IntroScreen;
		public var menu_screen:MenuScreen;
		public var game_state_manager:GameStateManager;
		public var saved_game_manager:SavedGameManager;
		
		private var ad_sprite:MovieClip = new MovieClip;
		private var sound_handler:SoundHandler = new SoundHandler();
		
		public function Main() {
			menu_screen = new MenuScreen(this);
			intro_screen = new IntroScreen(this);
			game_state_manager = new GameStateManager(this);
			saved_game_manager = new SavedGameManager(this);
			addChild(intro_screen);
			intro_screen.init();
			
			addChild(game_state_manager);
			//playSoundEffect("theme_song", true);
			//sound_handler.resumeMusic();
		}
		public function showAd() {
			intro_screen.destroy();
			addChild(ad_sprite);
			//MochiAd.showPreGameAd( { clip:ad_sprite, id:"82a0fea68503deed", res:"700x600", ad_finished:function() { showMenuAfterAd(); } } );
			showMenuAfterAd();
		}
		public function showMenuAfterAd() {
			playSoundEffect("menu_song", true);
			removeChild(ad_sprite);
			addChild(menu_screen);
			menu_screen.init();
		}
		public function showMenuAfterQuit() {
			playSoundEffect("menu_song", true);
			addChild(menu_screen);
			menu_screen.init();
		}
		
		public function toggleSoundEffects() {
			return sound_handler.toggleSoundEffects();
		}
		
		public function toggleMusic(key:String = "theme_song") {
			return sound_handler.toggleMusic(key);
		}
		
		public function playMusic(key:String = "theme_song") {
			if(!sound_handler.theme_song_playing){
				sound_handler.resumeMusic(key);
			}
		}
		
		public function playSoundEffect(sound_key:String, loop:Boolean) {
			sound_handler.playSound(sound_key, loop);
		}
		
		public function stopSoundEffect(sound_key:String) {
			sound_handler.stopSound(sound_key);
		}
		
		public function musicMuted() {
			return sound_handler.musicMuted();
		}
		
		public function sfxMuted() {
			return sound_handler.sfxMuted();
		}
	}
	
}