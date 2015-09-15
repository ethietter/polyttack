package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Waypoint extends MovieClip 
	{
		public var unique_value:uint;
		public function Waypoint() {
			unique_value = Math.floor(Math.random() * int.MAX_VALUE * 1.9);
		}
	}
	
}