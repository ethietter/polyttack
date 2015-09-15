package  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Main extends MovieClip{

		private var player:SpritesheetPlayer = new SpritesheetPlayer(88, 93, true, 0x0);
		private var loop_over:Boolean = false;
		
		public function Main() {
			addChild(player);
			player.loadBmp(new ExplosionBitmap(0, 0));
			addEventListener(Event.ENTER_FRAME, onLoop);
		}
		
		private function onLoop(evt:Event) {
			if(!loop_over){
				loop_over = player.advanceFrame(3);
			}
		}

	}
	
}
