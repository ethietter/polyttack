package customevents 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class AnimationEvent extends Event 
	{
		
		public static const TAKEOFF_OVER:String = "takeoff_over";
		
		public function AnimationEvent(type:String):void {
			super(type, true);
		}
	}
	
}