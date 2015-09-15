package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class WeaponObject extends MovieClip 
	{
		
		protected var is_used:Boolean = false;
		public var uses_clock:Boolean = false;
		
		public function WeaponObject() {
			
		}
		
		public function isUsed() {
			return is_used;
		}
		
		public function destroy() {
			trace('destroy');
		}
	}
	
}