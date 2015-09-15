package customevents
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class TutorialEvent extends Event
	{
		
		public static const INIT:String = "init";
		public static const SHOW_POLY:String = "show_poly";
		public static const SHOW_WEAPON:String = "show_weapon";
		public static const SHOW_RANK:String = "show_rank";
		public static const SHOW_MONEY:String = "show_money";
		public static const SEND_MINION:String = "send_minion";
		public static const SAVE_MINION:String = "save_minion";
		public static const COMPLETE_LEVEL:String = "complete_level";
		public static const SHOW_GRENADE:String = "show_grenade";
		public static const SHOW_BAR:String = "show_bar";
		
		public function TutorialEvent(type:String):void {
			super(type, true);
		}
	}
	
}