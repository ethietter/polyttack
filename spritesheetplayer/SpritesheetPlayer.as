package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	
	public class SpritesheetPlayer extends MovieClip{

		private var canvas:Sprite = new Sprite();
		private var canvas_bmp:Bitmap = new Bitmap();
		private var canvas_bmp_data:BitmapData;
		private var source_bmp_data:BitmapData;
		private var frame_width:int;
		private var frame_height:int;
		private var curr_frame:int = 0;
		private var num_frames:int;
		
		
		public function SpritesheetPlayer(frame_width_p:int, frame_height_p:int, transparent:Boolean = false, fill:uint = 0x0) {
			addChild(canvas);
			frame_width = frame_width_p;
			frame_height = frame_height_p;
			canvas_bmp_data = new BitmapData(frame_width, frame_height, transparent, fill);
			canvas_bmp.bitmapData = canvas_bmp_data;
			canvas.addChild(canvas_bmp);
		}
		
		public function loadBmp(bmp_data:BitmapData) {
			source_bmp_data = bmp_data;
			num_frames = source_bmp_data.width / frame_width;
		}
		
		private function drawFrame() {
			canvas_bmp_data.copyPixels(source_bmp_data, new Rectangle(frame_width * curr_frame, 0, frame_width, frame_height), new Point(0, 0));
		}
		
		//returns true when the loop is over
		public function advanceFrame(move_frame_count:int = 1):Boolean {
			curr_frame += move_frame_count;
			if (curr_frame > num_frames) {
				curr_frame = 0;
				return true;
			}
			drawFrame();
			return false;
		}
		
		public function restart() {
			curr_frame = 0;
		}
		

	}
	
}
