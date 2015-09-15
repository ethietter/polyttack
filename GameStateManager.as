package {
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	
	/**
	 * Used to control the game states which includes the following responsibilities:
		 * Starting new games, loading games, clearing saved games
		 * Is the game paused?
		 * Volume control for sound effects and music
		 * Starting new levels
	 * @author Edward Hietter
	 */
	public class GameStateManager extends MovieClip {
		
		private var main:Main;
		private var current_game_object:GameObject;
		public var first_level_screen:FirstLevelScreen;
		//public var survival_mode_screen:SurvivalModeScreen;
		private var game_play:GamePlay;
		private var current_level_object:LevelObject;
		public var level_objects_holder:LevelObjectsHolder = new LevelObjectsHolder();
		private var interlevel_screen:InterlevelScreenBase;
		private var saved_game_screen:SavedGameScreen;
		
		/**
		 * @param main_ref Reference to Main class
		 */
		public function GameStateManager(main_ref:Main) {
			main = main_ref;
		}
		
		/**
		 * If there is a saved game, load the saved game, show the state,
		 * and ask if the user would like to continue from that spot or start a new game.
		 * Otherwise, start a new game from scratch and create a new save object.
		 */
		public function beginGame() {
			if (main.saved_game_manager.savedGameExists()) {
				saved_game_screen = new SavedGameScreen(this);
				addChild(saved_game_screen);
				saved_game_screen.init();
			}
			else {
				startNewGame();
			}
		}
		
		public function beginSurvivalGame() {
			//survival_mode_screen = new SurvivalModeScreen();
			startSurvivalGame();
		}
		
		public function startSurvivalGame() {
			game_play = new GamePlay(this, main);
			addChild(game_play);
			current_level_object = level_objects_holder.getSurvivalLevel();
			game_play.init(new GameObject(), current_level_object);
		}
		
		public function startNewGame() {
			current_game_object = main.saved_game_manager.createGame();
			first_level_screen = new FirstLevelScreen(this);
			addChild(first_level_screen);
			first_level_screen.init();
		}
		
		public function startSavedGame() {
			current_game_object = main.saved_game_manager.getSavedGame();
			interlevel_screen = new ContinueGameScreen();
			addChild(interlevel_screen);
			//what the hell do I do about this?
			interlevel_screen.init(current_game_object, this, main, 0, 0);
		}
		
		public function continueGame() {
			startLevel(current_game_object);
		}
		
		public function levelOver(updated_game_object:GameObject, time_remaining:int, polys_killed_curr_level:int) {
			removeChild(game_play);
			interlevel_screen = new InterlevelScreen();
			addChild(interlevel_screen);
			interlevel_screen.init(updated_game_object, this, main, time_remaining, polys_killed_curr_level);
			main.saved_game_manager.saveGame(updated_game_object);
			Mouse.show();
		}
		
		public function quitGame() {
			removeChild(game_play);
			main.showMenuAfterQuit();
			main.stopSoundEffect("theme_song");
			Mouse.show();
		}
		
		public function quitGameBetweenLevels() {
			main.showMenuAfterQuit();
			main.stopSoundEffect("theme_song");
			Mouse.show();
		}
		
		public function startLevel(updated_game_object:GameObject) {
			game_play = new GamePlay(this, main);
			addChild(game_play);
			current_level_object = level_objects_holder.getLevelObject(updated_game_object.curr_level);
			game_play.init(updated_game_object, current_level_object);
		}
	}
	
}