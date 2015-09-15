package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.*;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class UserInterface extends MovieClip 
	{
		
		private var game_play:GamePlay;
		private var pause_screen:PauseScreen = new PauseScreen();
		private var hover_filter:GlowFilter = new GlowFilter(0xFFCC99, 1, 5, 5, 2);
		
		private var weapons_handler:WeaponsHandler;
		private var current_rank:int = 1;
		
		public var pistol_unlocked:Boolean = true;
		public var grenade_unlocked:Boolean = false;
		public var machine_gun_unlocked:Boolean = false;
		public var spitter_unlocked:Boolean = false;
		public var ice_cannon_unlocked:Boolean = false;
		public var fan_unlocked:Boolean = false;
		public var black_hole_unlocked:Boolean = false;
		public var rocket_launcher_unlocked:Boolean = false;
		public var fire_unlocked:Boolean = false;
		public var electric_fence_unlocked:Boolean = false;
		public var fighter_jet_unlocked:Boolean = false;
		
		public function UserInterface() {
		}
		
		public function init(game_play_ref:GamePlay, weapons_handler_ref:WeaponsHandler) {
			game_play = game_play_ref;
			weapons_handler = weapons_handler_ref;
			stage.addEventListener(MouseEvent.CLICK, onItemClick, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_OVER, onItemOver, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_OUT, onItemOut, false, 0, true);
			autosend_check.addEventListener(MouseEvent.MOUSE_UP, onAutoSendClick, false, 0, true);
			autosend_check.buttonMode = true;
			autosend_check.useHandCursor = true;

			selectWeapon(Weapons.PISTOL);
			current_rank = game_play.getCurrentRank();
			evaluateRank();
			addChild(pause_screen);
			pause_screen.init(game_play);
			if (game_play.main.musicMuted()) {
				music_btn.gotoAndStop(2);				
			}
			if (game_play.main.sfxMuted()) {
				sfx_btn.gotoAndStop(2);				
			}
			autosend_check.checkmark.visible = game_play.getAutoSend();
		}
		
		public function updateMinionsLeft(minions_saved:int, minions_required:int) {
			//var minions_plural:String = (minions_left == 1) ? "minion" : "minions";
			minions_left_txt.text = minions_saved + "/" + minions_required;
		}
		
		public function updatePolysLeft(polys_killed:int, polys_required:int) {
			//var polys_plural:String = (polys_left == 1) ? "poly" : "polys";
			polys_left_txt.text = "" + (polys_required - polys_killed);
		}
		
		public function updatePolyMeter(polys_on_screen:int, polys_limit:int) {
			poly_meter.inner_scale_bar.scaleX = polys_on_screen / polys_limit;
		}
		
		public function updateWeaponInfo(str:String) {
			if (str == Weapons.GRENADE && grenade_unlocked) {
				weapon_info_txt.text = Weapons.GRENADE_INFO;
			}
			if (str == Weapons.ICE_CANNON && ice_cannon_unlocked) {
				weapon_info_txt.text = Weapons.ICE_CANNON_INFO;
			}
			if (str == Weapons.MACHINE_GUN && machine_gun_unlocked) {
				weapon_info_txt.text = Weapons.MACHINE_GUN_INFO;
			}
			if (str == Weapons.PISTOL && pistol_unlocked) {
				weapon_info_txt.text = Weapons.PISTOL_INFO;
			}
			if (str == Weapons.SPITTER && spitter_unlocked) {
				weapon_info_txt.text = Weapons.SPITTER_INFO;
			}
			if (str == Weapons.FAN && fan_unlocked) {
				weapon_info_txt.text = Weapons.FAN_INFO;
			}
			if (str == Weapons.BLACK_HOLE && black_hole_unlocked) {
				weapon_info_txt.text = Weapons.BLACK_HOLE_INFO;
			}
			if (str == Weapons.ROCKET_LAUNCHER && rocket_launcher_unlocked) {
				weapon_info_txt.text = Weapons.ROCKET_LAUNCHER_INFO;
			}
			if (str == Weapons.FIRE && fire_unlocked) {
				weapon_info_txt.text = Weapons.FIRE_INFO;
			}
			if (str == Weapons.ELECTRIC_FENCE && electric_fence_unlocked) {
				weapon_info_txt.text = Weapons.ELECTRIC_FENCE_INFO;
			}
			if (str == Weapons.FIGHTER_JET && fighter_jet_unlocked) {
				weapon_info_txt.text = Weapons.FIGHTER_JET_INFO;
			}
		}
		
		public function updateRankField(rank:int) {
			rank_txt.text = String(rank);
		}
		
		public function updateLevelField(level:int) {
			level_txt.text = String(level);
		}
		
		public function updateMoneyField(amount:int) {
			money_total.text = "$" + String(amount);
		}
		
		private function isUnlocked(weapon_name:String) {
			switch (weapon_name) {
				case Weapons.PISTOL:
					return pistol_unlocked;
				case Weapons.ICE_CANNON:
					return ice_cannon_unlocked;
				case Weapons.MACHINE_GUN:
					return machine_gun_unlocked;
				case Weapons.SPITTER:
					return spitter_unlocked;
				case Weapons.GRENADE:
					return grenade_unlocked;
				case Weapons.FAN:
					return fan_unlocked;
				case Weapons.BLACK_HOLE:
					return black_hole_unlocked;
				case Weapons.ROCKET_LAUNCHER:
					return rocket_launcher_unlocked;
				case Weapons.FIRE:
					return fire_unlocked;
				case Weapons.ELECTRIC_FENCE:
					return electric_fence_unlocked;
				case Weapons.FIGHTER_JET:
					return fighter_jet_unlocked;
				default:
					return false;
			}
		}
		
		public function pause() {
			
			pause_screen.show();
		}
		
		public function resume() {
			pause_screen.hide();
		}
		
		private function onAutoSendClick(evt:MouseEvent) {
			if (game_play.getAutoSend()) {
				game_play.setAutoSend(false);
			}
			else {
				game_play.setAutoSend(true);
			}
			autosend_check.checkmark.visible = game_play.getAutoSend();
		}
		
		private function onItemClick(evt:MouseEvent) {
			if (evt.target is WeaponBoxUI) {
				if(!game_play.isPaused()){
					deselectWeapons();
					if (isUnlocked(evt.target.name)) {
						weapons_handler.switchWeapon(evt.target.name);
					}
					selectWeapon(weapons_handler.getCurrentWeapon());
				}
			}
			if (evt.target.name == "sfx_btn") {
				toggleSoundEffects();
			}
			if (evt.target.name == "music_btn") {
				toggleMusic();
			}
			if (evt.target.name == "pause_btn") {
				if (game_play.isPaused()) {
					game_play.resume();
					//pause_btn.gotoAndStop(1);
				}
				else {
					game_play.pause();
					//pause_btn.gotoAndStop(2);
				}
			}
		}
		
		public function toggleSoundEffects() {
			if (game_play.main.toggleSoundEffects()) {
				sfx_btn.gotoAndStop(2);
			}
			else {
				sfx_btn.gotoAndStop(1);
			}
		}
		
		public function toggleMusic() {
			if (game_play.main.toggleMusic("theme_song")) {
				music_btn.gotoAndStop(2);
			}
			else {
				music_btn.gotoAndStop(1);
			}			
		}
		
		private function deselectWeapons() {
			this.pistol.gotoAndStop(1);
			this.grenade.gotoAndStop(1);
			this.machine_gun.gotoAndStop(1);
			this.spitter.gotoAndStop(1);
			this.ice_cannon.gotoAndStop(1);
			this.fan.gotoAndStop(1);
			this.black_hole.gotoAndStop(1);
			this.rocket_launcher.gotoAndStop(1);
			this.fire.gotoAndStop(1);
			this.electric_fence.gotoAndStop(1);
			this.fighter_jet.gotoAndStop(1);
		}
		private function selectWeapon(instance_name:String) {
			this[instance_name].gotoAndStop(3);
		}
		
		
		private function onItemOver(evt:MouseEvent) {
			if (evt.target is WeaponBoxUI) {
				if (isUnlocked(evt.target.name)) {
					evt.target.buttonMode = true;
					evt.target.gotoAndStop(2);
					if (weapons_handler.getCurrentWeapon() == evt.target.name) {
						evt.target.gotoAndStop(4);
					}
					useHandCursor = true;
					updateWeaponInfo(evt.target.name);
				}
			}
			if (evt.target.name == "sfx_btn" || evt.target.name == "music_btn" || evt.target.name == "pause_btn") {
				this[evt.target.name].filters = [hover_filter];
				evt.target.buttonMode = true;
				useHandCursor = true;
			}
		}
		
		private function onItemOut(evt:MouseEvent) {
			if(evt.target is WeaponBoxUI){
				evt.target.gotoAndStop(1);
				if (weapons_handler.getCurrentWeapon() == evt.target.name) {
					evt.target.gotoAndStop(3);
				}
				updateWeaponInfo(weapons_handler.getCurrentWeapon());
			}
			if (evt.target.name == "music_btn" || evt.target.name == "sfx_btn" || evt.target.name == "pause_btn") {
				this[evt.target.name].filters = [];
			}
		}
		
		public function showFlashingRed() {
			flashing_red.gotoAndPlay(2);
		}
		
		public function onRankUp() {
			current_rank = game_play.getCurrentRank();
			weapon_unlocked.gotoAndPlay(2);
			evaluateRank();
		}
		
		public function levelOver() {
			stage.removeEventListener(MouseEvent.CLICK, onItemClick, false);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, onItemOver, false);
			stage.removeEventListener(MouseEvent.MOUSE_OUT, onItemOut, false);
			autosend_check.removeEventListener(MouseEvent.MOUSE_UP, onAutoSendClick, false);
		}
		
		private function evaluateRank() {
			if (current_rank >= Weapons.PISTOL_RANK) {
				pistol_unlocked = true;
				pistol.lock.visible = false;
			}
			if (current_rank >= Weapons.GRENADE_RANK) {
				grenade_unlocked = true;
				grenade.lock.visible = false;
			}
			if (current_rank >= Weapons.MACHINE_GUN_RANK) {
				machine_gun_unlocked = true;
				machine_gun.lock.visible = false;
			}
			if (current_rank >= Weapons.SPITTER_RANK) {
				spitter_unlocked = true;
				spitter.lock.visible = false;
			}
			if (current_rank >= Weapons.ICE_CANNON_RANK) {
				ice_cannon_unlocked = true;
				ice_cannon.lock.visible = false;
			}
			if (current_rank >= Weapons.FAN_RANK) {
				fan_unlocked = true;
				fan.lock.visible = false;
			}
			if (current_rank >= Weapons.BLACK_HOLE_RANK) {
				black_hole_unlocked = true;
				black_hole.lock.visible = false;
			}
			if (current_rank >= Weapons.ROCKET_LAUNCHER_RANK) {
				rocket_launcher_unlocked = true;
				rocket_launcher.lock.visible = false;
			}
			if (current_rank >= Weapons.FIRE_RANK) {
				fire_unlocked = true;
				fire.lock.visible = false;
			}
			if (current_rank >= Weapons.ELECTRIC_FENCE_RANK) {
				electric_fence_unlocked = true;
				electric_fence.lock.visible = false;
			}
			if (current_rank >= Weapons.FIGHTER_JET_RANK) {
				fighter_jet_unlocked = true;
				fighter_jet.lock.visible = false;
			}
		}
	}
	
}