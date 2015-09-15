package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class InterlevelScreenBase extends MovieClip 
	{
		private var upgrade_failed:UpgradeFailed;
		
		public function init(updated_game_object_ref:GameObject, gsm_ref:GameStateManager, main_ref:Main, time_remaining_p:int, polys_killed_curr_level:int) {
		
		}
		public function cancelUpgrade() {
			
		}
		
		public function purchaseUpgrade(item:String, amount:int, level:int) {
			
		}
		
		public function confirmUpgrade(item:String, amount:int, level:int) {
			
		}
		
		public function clearUpgradeFailed() {
			
		}
	}
	
}