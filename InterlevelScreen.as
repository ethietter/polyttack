package 
{
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class InterlevelScreen extends InterlevelScreenBase 
	{		
		private var game_state_manager:GameStateManager;
		private var main:Main;
		private var updated_game_object:GameObject;
		private var time_remaining:int;
		
		private var confirm_upgrade:ConfirmUpgrade;
		private var upgrade_failed:UpgradeFailed;
		private var confirm_quit:ConfirmQuit;
		
		public function InterlevelScreen() {
			
		}
		
		//Now this is just disgusting, but I don't care. The game's almost complete.
		public override function init(updated_game_object_ref:GameObject, gsm_ref:GameStateManager, main_ref:Main, time_remaining_p:int, polys_killed_curr_level:int) {
			main = main_ref;
			updated_game_object = updated_game_object_ref;
			game_state_manager = gsm_ref;
			time_remaining = time_remaining_p;
			next_level_btn.addEventListener(MouseEvent.CLICK, onNextLevelClick, false, 0, true);			
			//Set all the text boxes
			
			//Write the upgrade box levels
			minion_speed_level_txt.text = String(updated_game_object.minion_speed_level);
			minion_health_level_txt.text = String(updated_game_object.minion_health_level);
			grenade_radius_level_txt.text = String(updated_game_object.grenade_radius_level);
			rocket_launcher_rate_level_txt.text = String(updated_game_object.rocket_launcher_level);
			
			//Write the upgrade box prices
			minion_speed_cost_txt.text = "$" + String(UpgradeConstants.SPEED_COSTS[updated_game_object.minion_speed_level]);
			minion_health_cost_txt.text = "$" + String(UpgradeConstants.MINION_HEALTH_COSTS[updated_game_object.minion_health_level]);
			grenade_radius_cost_txt.text = "$" + String(UpgradeConstants.GRENADE_COSTS[updated_game_object.grenade_radius_level]);
			rocket_launcher_rate_cost_txt.text = "$" + String(UpgradeConstants.ROCKET_LAUNCHER_COSTS[updated_game_object.rocket_launcher_level]);
			
			//Add event listeners to + buttons
			minion_speed_btn.addEventListener(MouseEvent.CLICK, onMinionSpeedClick, false, 0, true);
			minion_health_btn.addEventListener(MouseEvent.CLICK, onMinionHealthClick, false, 0, true);
			grenade_radius_btn.addEventListener(MouseEvent.CLICK, onGrenadeRadiusClick, false, 0, true);
			rocket_launcher_rate_btn.addEventListener(MouseEvent.CLICK, onRocketLauncherRateClick, false, 0, true);
			
			quit_btn.addEventListener(MouseEvent.CLICK, onQuitClick, false, 0, true);
			
			handleMaxedUpgrade();
			
			
			money_txt.text = "$" + String(updated_game_object.money_total);
			next_level_txt.text = "Next Level: " + String(updated_game_object.curr_level);
			time_remaining /= 10;
			time_left_txt.text = String(time_remaining);
			
			polys_killed_txt.text = String(polys_killed_curr_level);
			var minions_saved:int = gsm_ref.level_objects_holder.levels_array[updated_game_object.curr_level - 1].minions_to_save
			minions_saved_txt.text = String(minions_saved);
			var level_points:int = polys_killed_curr_level * 10 + minions_saved * 100 + time_remaining * 2;
			level_total_txt.text = String(level_points);
			updated_game_object.point_total += level_points;
			
			game_total_txt.text = String(updated_game_object.point_total);
			
			//these have to be last so they appear on top
			upgrade_failed = new UpgradeFailed();
			addChild(upgrade_failed);
			upgrade_failed.init(this);
			upgrade_failed.hide();
			
			confirm_upgrade = new ConfirmUpgrade();
			addChild(confirm_upgrade);
			confirm_upgrade.init(this);
			confirm_upgrade.hide();
			
			confirm_quit = new ConfirmQuit();
			addChild(confirm_quit);
			confirm_quit.init(this.quitGame, this.confirm_quit.hide);
			confirm_quit.hide();
		}
		
		//Event Listeners for + buttons
		private function onMinionSpeedClick(evt:MouseEvent) {
			confirmUpgrade(UpgradeConstants.ID_SPEED, UpgradeConstants.SPEED_COSTS[updated_game_object.minion_speed_level], updated_game_object.minion_speed_level + 1);
		}
		
		private function onMinionHealthClick(evt:MouseEvent) {
			confirmUpgrade(UpgradeConstants.ID_HEALTH, UpgradeConstants.MINION_HEALTH_COSTS[updated_game_object.minion_health_level], updated_game_object.minion_health_level + 1);
		}
		
		private function onGrenadeRadiusClick(evt:MouseEvent) {
			confirmUpgrade(UpgradeConstants.ID_GRENADE, UpgradeConstants.GRENADE_COSTS[updated_game_object.grenade_radius_level], updated_game_object.grenade_radius_level + 1);
		}
		
		private function onRocketLauncherRateClick(evt:MouseEvent) {
			confirmUpgrade(UpgradeConstants.ID_ROCKET_LAUNCHER, UpgradeConstants.ROCKET_LAUNCHER_COSTS[updated_game_object.rocket_launcher_level], updated_game_object.rocket_launcher_level + 1);
		}
		
		private function onQuitClick(evt:MouseEvent) {
			confirm_quit.show();
		}
		
		private function quitGame() {
			main.saved_game_manager.saveGame(updated_game_object);
			next_level_btn.removeEventListener(MouseEvent.CLICK, onNextLevelClick, false);
			quit_btn.removeEventListener(MouseEvent.CLICK, onQuitClick, false);
			game_state_manager.removeChild(this);
			game_state_manager.quitGameBetweenLevels();
		}
		
		//Handle the case when a given upgrade is maxed out
		private function handleMaxedUpgrade() {
			if (updated_game_object.minion_speed_level >= UpgradeConstants.MAX_LEVEL) {
				minion_speed_cost_txt.text = "";
				minion_speed_level_txt.text = "Max!";
				minion_speed_btn.visible = false;
			}
			
			if (updated_game_object.minion_health_level >= UpgradeConstants.MAX_LEVEL) {
				minion_health_cost_txt.text = "";
				minion_health_level_txt.text = "Max!";
				minion_health_btn.visible = false;
			}
			
			if (updated_game_object.grenade_radius_level >= UpgradeConstants.MAX_LEVEL) {
				grenade_radius_cost_txt.text = "";
				grenade_radius_level_txt.text = "Max!";
				grenade_radius_btn.visible = false;
			}
			
			if (updated_game_object.rocket_launcher_level >= UpgradeConstants.MAX_LEVEL) {
				rocket_launcher_rate_cost_txt.text = "";
				rocket_launcher_rate_level_txt.text = "Max!";
				rocket_launcher_rate_btn.visible = false;
			}
		}
		
		public function getUpgradeCost(item:String, level:int) {
			switch(item) {
				case UpgradeConstants.ID_GRENADE:
					return UpgradeConstants.GRENADE_COSTS[level-1];
					break;
				case UpgradeConstants.ID_HEALTH:
					return UpgradeConstants.MINION_HEALTH_COSTS[level-1];
					break;
				case UpgradeConstants.ID_ROCKET_LAUNCHER:
					return UpgradeConstants.ROCKET_LAUNCHER_COSTS[level-1];
					break;
				case UpgradeConstants.ID_SPEED:
					return UpgradeConstants.SPEED_COSTS[level-1];
					break;
			}
			return 0;
		}
		
		public override function purchaseUpgrade(item:String, amount:int, level:int) {
			confirm_upgrade.hide();
			if (updated_game_object.money_total - amount >= 0) {
				updated_game_object.money_total -= amount;
				money_txt.text = "$" + updated_game_object.money_total;
				switch(item) {
					case UpgradeConstants.ID_GRENADE:
						updated_game_object.grenade_radius_level = level;
						grenade_radius_level_txt.text = String(level);
						grenade_radius_cost_txt.text = "$" + String(UpgradeConstants.GRENADE_COSTS[level]);
						break;
					case UpgradeConstants.ID_HEALTH:
						updated_game_object.minion_health_level = level;
						minion_health_level_txt.text = String(level);
						minion_health_cost_txt.text = "$" + String(UpgradeConstants.MINION_HEALTH_COSTS[level]);
						break;
					case UpgradeConstants.ID_ROCKET_LAUNCHER:
						updated_game_object.rocket_launcher_level = level;
						rocket_launcher_rate_level_txt.text = String(level);
						rocket_launcher_rate_cost_txt.text = "$" + String(UpgradeConstants.ROCKET_LAUNCHER_COSTS[level]);
						break;
					case UpgradeConstants.ID_SPEED:
						updated_game_object.minion_speed_level = level;
						minion_speed_level_txt.text = String(level);
						minion_speed_cost_txt.text = "$" + String(UpgradeConstants.SPEED_COSTS[level]);
						break;
				}
				handleMaxedUpgrade();
			}
			
		}
		
		public override function confirmUpgrade(item:String, amount:int, level:int) {
			if (updated_game_object.money_total - amount >= 0) {
				confirm_upgrade.show(item, amount, level);	
			}
			else {
				upgrade_failed.show(amount);
			}
		}
		
		public override function cancelUpgrade() {
			confirm_upgrade.hide();
		}
		
		public override function clearUpgradeFailed() {
			upgrade_failed.hide();
		}	
		
		private function onNextLevelClick(evt:MouseEvent) {
			main.saved_game_manager.saveGame(updated_game_object);
			next_level_btn.removeEventListener(MouseEvent.CLICK, onNextLevelClick, false);
			game_state_manager.startLevel(updated_game_object);
			game_state_manager.removeChild(this);
		}
		
	}
	
}