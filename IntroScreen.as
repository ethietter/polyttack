package {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class IntroScreen extends Sprite {
		
		private var main:MovieClip;
		public function IntroScreen(main_ref:MovieClip) {
			main = main_ref;
		}
		
		public function init() {
			main.showAd();
		}
		public function destroy() {
			main.removeChild(main.intro_screen);
		}
	}
}