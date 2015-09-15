package 
{
	import flash.display.MovieClip;
	import customevents.TutorialEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Tutorial extends MovieClip 
	{
		public static const STAGE_INIT:String = "init";
		public static const STAGE_SHOW_POLY:String = "show_poly";
		public static const STAGE_SHOW_WEAPON:String = "show_weapon";
		public static const STAGE_SHOW_RANK:String = "show_rank";
		public static const STAGE_SHOW_MONEY:String = "show_money";
		public static const STAGE_SEND_MINION:String = "send_minion";
		public static const STAGE_COMPLETE_LEVEL:String = "complete_level";
		public static const STAGE_SHOW_GRENADE:String = "show_grenade";
		public static const STAGE_SAVE_MINION:String = "save_minion";
		public static const STAGE_SHOW_BAR:String = "show_bar";
		public static const STAGE_TUTORIAL_END:String = "tutorial_end";
		
		private var current_stage:String = STAGE_INIT;
		private var game_play:GamePlay;
		
		public function Tutorial(game_play_ref:GamePlay) {
			game_play = game_play_ref;
		}
		
		public function init() {
			stage.addEventListener(TutorialEvent.INIT, onInitEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SHOW_POLY, onShowPolyEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SHOW_WEAPON, onShowWeaponEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SHOW_RANK, onShowRankEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SHOW_MONEY, onShowMoneyEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SEND_MINION, onSendMinionEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SHOW_GRENADE, onShowGrenadeEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SAVE_MINION, onSaveMinionEvent, false, 0, true);
			stage.addEventListener(TutorialEvent.SHOW_BAR, onShowBarEvent, false, 0, true);
		}
		
		private function onInitEvent(evt:TutorialEvent) {
			if(current_stage == STAGE_INIT){
				this.gotoAndPlay(2);
				current_stage = STAGE_SHOW_POLY;
			}
		}
		
		private function onShowPolyEvent(evt:TutorialEvent) {
			if(current_stage == STAGE_SHOW_POLY){
				this.gotoAndPlay(3);
				current_stage = STAGE_SHOW_WEAPON;
				game_play.stopTutorialCounting();
			}
		}
		
		private function onShowWeaponEvent(evt:TutorialEvent) {
			if(current_stage == STAGE_SHOW_WEAPON){
				this.gotoAndPlay(4);
				current_stage = STAGE_SHOW_RANK;
			}
		}
		
		private function onShowRankEvent(evt:TutorialEvent) {
			if (current_stage == STAGE_SHOW_RANK) {
				this.gotoAndPlay(5);
				current_stage = STAGE_SHOW_GRENADE;
			}
		}
		
		private function onShowGrenadeEvent(evt:TutorialEvent) {
			if (current_stage == STAGE_SHOW_GRENADE) {
				this.gotoAndPlay(6);
				current_stage = STAGE_SHOW_MONEY;
				game_play.startTutorialCounting();
			}
		}
		
		private function onShowMoneyEvent(evt:TutorialEvent) {
			if (current_stage == STAGE_SHOW_MONEY) {
				this.gotoAndPlay(7);
				current_stage = STAGE_SHOW_BAR;
			}
		}
		
		private function onShowBarEvent(evt:TutorialEvent) {
			if (current_stage == STAGE_SHOW_BAR) {
				this.gotoAndPlay(8);
				current_stage = STAGE_SEND_MINION;
			}
		}
		
		private function onSendMinionEvent(evt:TutorialEvent) {
			if (current_stage == STAGE_SEND_MINION) {
				this.gotoAndPlay(9);
				current_stage = STAGE_SAVE_MINION;
				game_play.stopTutorialCounting();
			}
		}
		
		private function onSaveMinionEvent(evt:TutorialEvent) {
			if (current_stage == STAGE_SAVE_MINION) {
				//this.gotoAndPlay(9);
				current_stage = STAGE_TUTORIAL_END;
			}
		}
		
		
	}
	
}