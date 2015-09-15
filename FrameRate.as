package 
{
	import flash.display.MovieClip;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class FrameRate extends MovieClip 
	{
		private var t_samples:Array = new Array();
		private var last_t:int = 0;
		private var num_samples:int = 0;
		private var curr_t:int = 0;
		private var first_delta_t:int = 0;
		private var max_samples:int = 100;
		
		public function step() {
			if (num_samples == 0) {
				last_t = getTimer();
			}
			else {
				last_t = curr_t;
				curr_t = getTimer();
				if (num_samples > max_samples) {
					t_samples.splice(0, 1);
				}
				t_samples.push(curr_t - last_t);
				if (num_samples > max_samples) {
					output();
				}
			}
			num_samples++;
		}
		
		private function output() {
			var sum:int = 0;
			for (var i:int = 0; i < max_samples; i++) {
				sum += t_samples[i];
			}
			output_txt.text = String(Math.floor(1000/(sum / max_samples))) + " FPS";
		}
	}
	
}