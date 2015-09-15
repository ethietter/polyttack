package 
{
	import customevents.TutorialEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * Everything concerning game play goes in this file
	 * @author Edward Hietter
	 */
	public class GamePlay extends MovieClip 
	{
		
		public var main:MovieClip;
		
		private var is_paused:Boolean = false;
		
		private var game_state_manager:GameStateManager;
		private var init_game_object:GameObject;
		private var current_level_object:LevelObject;
		private var polys_holder:Sprite = new Sprite();
		private var minions_holder:Sprite = new Sprite();
		private var auto_send:Boolean = false;
		
		private var send_frame_max:int = 150;
		private var send_frame_count:int = 0;
		
		private var wait_send_min:int = 45;
		private var wait_send_count:int = 0;
		
		private var level_background:LevelBackground = new LevelBackground();
		private var level_frames_elapsed:int;
		private var level_frames_allowed:int;
		
		private var game_timer:Timer = new Timer(25);
		private var polys_array:Array = new Array();
		private var minions_array:Array = new Array();
		private var poly_launchers_array:Array = new Array();
		private var weapons_handler:WeaponsHandler = new WeaponsHandler();
		private var user_interface:UserInterface = new UserInterface();
		private var poly_count:int = 0;
		private var minion_path:MinionPath;
		private var fire_renderer:FireRenderer;
		
		// statistics for the individual level
		private var polys_killed_curr_level:int;
		private var level_polys_killed:int = 0;
		private var level_minions_saved:int = 0;
		private var level_current_money:int = 0;
		private var level_current_rank:int = 0;
		
		//Thresholds for timed tutorial elements
		private var tutorial:Tutorial;
		private var tutorial_time_count:int = 0;
		private var init_threshold:int = 100;
		private var show_poly_threshold:int = 200;
		private var is_counting:Boolean = false;
		private var show_money_threshold:int = 400;
		private var show_bar_threshold:int = 600;
		
		private var frame_rate:FrameRate;
		
		
		public function GamePlay(gsm_ref:GameStateManager, main_ref:MovieClip) {
			game_state_manager = gsm_ref;
			main = main_ref;
		}
		
		public function init(current_game_object:GameObject, current_level_object_p:LevelObject) {
			main.stopSoundEffect("menu_song");
			tutorial_time_count = 0;
			poly_count = 0;
			polys_killed_curr_level = 0;
			addChild(level_background);
			
			init_game_object = current_game_object.copy();
			current_level_object = current_level_object_p;
			
			// initialize the current level statistics to their 
			// correct values taken from init_game_object
			level_current_money = init_game_object.money_total;
			level_current_rank = init_game_object.curr_rank;
			level_polys_killed = init_game_object.polys_killed;
			
			level_frames_elapsed = 0;
			level_frames_allowed = current_level_object.time_allowed * 40;
			
			level_background.init(init_game_object.curr_level);
			
			game_timer.addEventListener(TimerEvent.TIMER, onLoop, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease, false, 0, true);
			game_timer.start();
			
			minion_path = new MinionPath();
			minion_path.init(current_level_object.minion_way_points);
			addChild(minion_path);
			
			addChild(polys_holder);
			addChild(minions_holder);
			
			fire_renderer = new FireRenderer();
			
			var launcher_locations:Array = current_level_object.launcher_locations;
			for (var i:int = 0; i < launcher_locations.length; i++) {
				var poly_launcher:PolyLauncher = new PolyLauncher(this);
				addChild(poly_launcher);
				poly_launcher.init(current_level_object.launcher_wait_times[i], current_level_object.launcher_sides[i], current_level_object.min_launch_speed, current_level_object.max_launch_speed);
				poly_launcher.x = launcher_locations[i].x;
				poly_launcher.y = launcher_locations[i].y;
				poly_launchers_array.push(poly_launcher);
			}
			
			
			if (init_game_object.curr_level == 1) {
				tutorial = new Tutorial(this);
				addChild(tutorial);
				tutorial.init();
				is_counting = true;
			}
			
			
			// add the weapons handler second to last so that it is on top and all of the events can register
			// also this will mean that all weapon animations appear on top
			addChild(weapons_handler);
			weapons_handler.init(this, launcher_locations);
			
			addChild(user_interface);
			user_interface.init(this, weapons_handler);
			user_interface.updateMoneyField(level_current_money);
			user_interface.updateLevelField(current_game_object.curr_level);
			user_interface.updateRankField(current_game_object.curr_rank);
			user_interface.updateMinionsLeft(0, current_level_object.minions_to_save);
			user_interface.updatePolysLeft(0, Constants.RANK_UP_AMOUNTS[level_current_rank - 1]);
			if (!main.musicMuted()) {
				main.playMusic("theme_song");
			}
			
			frame_rate = new FrameRate();
			//addChild(frame_rate);
			
		}
		
		private function onLoop(evt:TimerEvent) {
			if(auto_send){
				send_frame_count++;
				if (send_frame_count >= send_frame_max) {
					send_frame_count = 0;
					sendMinion();
				}
			}
			if (wait_send_count > 0) {
				wait_send_count--;
			}
			var i:int;
			for (i = 0; i < poly_launchers_array.length; i++) {
				poly_launchers_array[i].step();
			}
			for (i = 0; i < polys_array.length; i++) {
				polys_array[i].step();
			}
			for (i = 0; i < minions_array.length; i++) {
				minions_array[i].step();
			}
			level_frames_elapsed++;
			//user_interface.updatePolyMeter(poly_count, current_level_object.poly_limit);
			user_interface.updatePolyMeter(level_frames_elapsed + 750 * (Math.exp(.04 * poly_count) - 1), level_frames_allowed);
			fire_renderer.step();
			weapons_handler.step();
			if (init_game_object.curr_level == 1) {
				if(is_counting){
					tutorial_time_count++;
					if (tutorial_time_count == init_threshold) {
						dispatchEvent(new TutorialEvent(TutorialEvent.INIT));
					}
					if (tutorial_time_count == show_poly_threshold) {
						dispatchEvent(new TutorialEvent(TutorialEvent.SHOW_POLY));
					}
					if (tutorial_time_count == show_money_threshold) {
						dispatchEvent(new TutorialEvent(TutorialEvent.SHOW_MONEY));
					}
					if (tutorial_time_count == show_bar_threshold) {
						dispatchEvent(new TutorialEvent(TutorialEvent.SHOW_BAR));
					}
				}
			}
			evt.updateAfterEvent();
			frame_rate.step();
		}
		
		public function startTutorialCounting() {
			is_counting = true;
		}
		
		public function stopTutorialCounting() {
			is_counting = false;
		}
		
		public function pause() {
			game_timer.stop();
			user_interface.pause();
			is_paused = true;
		}
		
		public function resume() {
			game_timer.start();
			user_interface.resume();
			is_paused = false;
		}
		
		public function isPaused() {
			return is_paused;
		}
		
		public function polyAdded() {
			poly_count++;
		}
		
		public function polyKilled() {
			polys_killed_curr_level++;
			poly_count--;
		}
		
		//remove the polys that have been killed from polys_array 
		public function minimizePolysArray() {
			for (var i:int = 0; i < polys_array.length; i++) {
				if (polys_array[i].isDead()) {
					polys_array.splice(i, 1);
				}
			}
		}
		
		public function showFlashingRed() {
			user_interface.showFlashingRed();
		}
		
		//remove the minions that have either been saved or killed
		public function minimizeMinionsArray() {
			for (var i:int = 0; i < minions_array.length; i++) {
				if (minions_array[i].isRemoved()) {
					minions_holder.removeChild(minions_array[i]);
					minions_array.splice(i, 1);
				}
			}
		}
		
		/* All of the game play elements go below */
		
		public function levelComplete() {
			clearStage();
			var updated_game_object:GameObject = new GameObject();
			updated_game_object = init_game_object.copy();
			updated_game_object.curr_rank = level_current_rank;
			updated_game_object.money_total = level_current_money;
			updated_game_object.polys_killed = level_polys_killed;
			updated_game_object.curr_level++;
			user_interface.levelOver();
			game_state_manager.levelOver(updated_game_object, level_frames_allowed-level_frames_elapsed, polys_killed_curr_level);
		}
		
		public function quitGame() {
			clearStage();
			game_state_manager.quitGame();
		}
		
		private function onKeyRelease(evt:KeyboardEvent) {
			if (evt.keyCode == 32) {
				if(wait_send_count == 0){
					wait_send_count = wait_send_min;
					sendMinion();
				}
			}
		}
		
		private function clearStage() {
			var i:int;
			for (i = 0; i < minions_array.length; i++) {
				if(minions_array[i].stage != null){
					minions_array[i].levelOver();
					minions_holder.removeChild(minions_array[i]);
				}
			}
			for (i = 0; i < polys_array.length; i++) {
				if(polys_array[i].stage != null){
					polys_array[i].levelOver();
					polys_holder.removeChild(polys_array[i]);
				}
			}
			for (i = 0; i < poly_launchers_array.length; i++) {
				poly_launchers_array[i].levelOver();
				removeChild(poly_launchers_array[i]);
			}
			minions_array = [];
			polys_array = [];
			poly_launchers_array = [];
			weapons_handler.levelOver();
			game_timer.removeEventListener(TimerEvent.TIMER, onLoop, false);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease, false);
		}
		
		//returns false when the player doesn't have enough money
		public function subtractMoney(amount:int) {
			if (level_current_money - amount < 0) {
				return false;
			}
			else {
				level_current_money -= amount;
				user_interface.updateMoneyField(level_current_money);
				return true;
			}
		}
		
		public function sendMinion() {
			if (subtractMoney(Constants.SEND_MINION_COST)) {
				var minion:Minion = new Minion();
				minions_holder.addChild(minion);
				minion.init(this, current_level_object.minion_way_points, Minion.MINION_SPEEDS[init_game_object.minion_speed_level], Minion.MINION_HEALTH[init_game_object.minion_health_level]);
				minions_array.push(minion);
				if(init_game_object.curr_level == 1) dispatchEvent(new TutorialEvent(TutorialEvent.SEND_MINION));
			}
			else {
				showFlashingRed();
			}
		}
		
		public function minionSaved() {
			level_minions_saved++;
			user_interface.updateMinionsLeft(level_minions_saved, current_level_object.minions_to_save);
			if (level_minions_saved >= current_level_object.minions_to_save) {
				levelComplete();
			}
			if(init_game_object.curr_level == 1) dispatchEvent(new TutorialEvent(TutorialEvent.SAVE_MINION));
		}
		
		public function getMinionsArray() {
			return minions_array;
		}
		
		public function hitMinion() {
			
		}
		
		/*
		 * Get the array of all the polys on screen, to be used for collision detection
		 */
		public function getPolysArray() {
			return polys_array;
		}
		
		/*
		 * Used to notify game_play that a poly was hit. It can then take actions
		 * such as adding points/kills/etc.
		 */
		public function hitPoly(automated_hit:Boolean = false) {
			level_polys_killed++;
			level_current_money += Constants.POLY_HIT_VALUE;// * (automated_hit ? .8 : 1);
			user_interface.updateMoneyField(level_current_money);
			
			if (level_polys_killed >= Constants.RANK_UP_AMOUNTS[level_current_rank - 1]) {
				level_polys_killed = 0;
				rankUp();
			}
			user_interface.updatePolysLeft(level_polys_killed, Constants.RANK_UP_AMOUNTS[level_current_rank - 1]);
			minimizePolysArray();
		}
		
		public function rankUp() {
			level_current_rank++;
			user_interface.updateRankField(level_current_rank);
			user_interface.onRankUp();
			if(init_game_object.curr_level == 1) dispatchEvent(new TutorialEvent(TutorialEvent.SHOW_RANK));
		}
		
		public function getCurrentRank() {
			return level_current_rank;
		}
		
		public function getCurrentLevel() {
			return init_game_object.curr_level;
		}
		
		public function getFireRenderer() {
			return fire_renderer;
		}
		
		public function getGrenadeLevel() {
			return init_game_object.grenade_radius_level;
		}
		
		public function getRocketLauncherLevel() {
			return init_game_object.rocket_launcher_level;
		}
		
		public function getAutoSend() {
			return auto_send;
		}
		
		public function setAutoSend(new_value:Boolean) {
			auto_send = new_value;
		}
		
		/*
		 * Launch a poly from the specified point in the specified direction
		 */
		public function fire(sides:int, start_point:Point, angle:Number, speed:Number) {
			var poly:Poly = new Poly(this);
			poly.init(sides, start_point, angle, speed);
			polys_array.push(poly);
			polys_holder.addChild(poly);
			polyAdded();
		}
	}
	
}