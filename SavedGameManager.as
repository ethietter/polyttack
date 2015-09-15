package 
{
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class SavedGameManager {
		
		private var main:MovieClip;
		private var game_object:GameObject;
		private var saved_game:SharedObject;
		
		public function SavedGameManager(main_ref:MovieClip) {
			main = main_ref;
			saved_game = SharedObject.getLocal("saved_game");
		}
		
		/**
		 * Create the new game object and then save it to a shared object.
		 * Duplicate the game object and save it in memory
		 */
		public function createGame() {
			//check to see if shared object exists, if it does, overwrite with the new game object
			//if it doesn't exist, create it and save the new game object to it
			game_object = new GameObject();
			saveGame(game_object);
			saved_game.flush();
			return game_object;
		}
		
		/**
		 * Detect if there is a saved game and ask if the player would
		 * like to start from the saved place or create a new game.
		 */
		public function savedGameExists() {
			return saved_game.data.exists
		}
		
		public function getSavedGame() {
			var curr_saved_game:Object = {
				"curr_level":saved_game.data.curr_level,
				"point_total":saved_game.data.point_total,
				"curr_rank":saved_game.data.curr_rank,
				"money_total":saved_game.data.money_total,
				"minion_speed_level":saved_game.data.minion_speed_level,
				"minion_health_level":saved_game.data.minion_health_level,
				"polys_killed":saved_game.data.polys_killed
			};
			game_object = new GameObject(curr_saved_game);
			return game_object;
		}
		
		public function saveGame(game_object_p:GameObject) {
			saved_game.data.curr_level = game_object_p.curr_level;
			saved_game.data.point_total = game_object_p.point_total;
			saved_game.data.curr_rank = game_object_p.curr_rank;
			saved_game.data.money_total = game_object_p.money_total;
			saved_game.data.minion_speed_level = game_object_p.minion_speed_level;
			saved_game.data.minion_health_level = game_object_p.minion_health_level;
			saved_game.data.polys_killed = game_object_p.polys_killed;
			if(saved_game.data.curr_level != 1){
				saved_game.data.exists = Boolean(true);
			}
			else {
				saved_game.data.exists = Boolean(false);
			}
			saved_game.flush();
		}
	}
	
}