package {
	
	import com.flashandmath.dg.GUI.ScrollingPerlinNoise;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.filters.BlurFilter;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	
	public class FirePlayer extends MovieClip{
		
		/* Fire Object */
		private var posX:Number = 0;
		private var posY:Number = 0;
		private var displayWidth:Number = 300;
		private var displayHeight:Number = 380;
		private var fire_renderer:FireRenderer;
		
		/*Scaled Fire Bitmap*/
		private var scale:Number;
		private var scale_bitmap_data:BitmapData;
		private var scale_bitmap:Bitmap;
		private var scale_matrix:Matrix;
			
		public function FirePlayer(fire_renderer_ref:FireRenderer, fire_width:Number = 60) {
			fire_renderer = fire_renderer_ref;
			scale = fire_width/displayWidth;
			scale_bitmap_data = new BitmapData(displayWidth*scale, displayHeight*scale, true, 0x0);
			scale_bitmap = new Bitmap(scale_bitmap_data);
			scale_matrix = new Matrix(scale, 0, 0, scale);
			addChild(scale_bitmap);
		}
	
		public function step() {			
			scale_bitmap_data.fillRect(scale_bitmap_data.rect, 0x0);
			scale_bitmap_data.draw(fire_renderer.getBitmapData(), scale_matrix, null, null, null, true);
		}
	}
}