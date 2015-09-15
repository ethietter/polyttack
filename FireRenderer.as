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
	
	public class FireRenderer {
		
		/* Fire Object */
		private var posX:Number = 0;
		private var posY:Number = 0;
		private var displayWidth:Number = 300;
		//I have no idea what this is for, but this needs to be 380 (or more) to look good
		private var displayHeight:Number = 380;
		private var displayRect:Rectangle = new Rectangle(0,0,displayWidth, displayHeight);
		private var clouds:ScrollingPerlinNoise;
		private var clouds2:ScrollingPerlinNoise;
		private var dmfClouds:ScrollingPerlinNoise;
		
		private var displayBitmapData:BitmapData = new BitmapData(displayWidth, displayHeight, true, 0x0);
		private var dmfSource:BitmapData;
		private var shapeGrad:Shape;
		private var dmf:DisplacementMapFilter;
		private var cmf:ColorMatrixFilter;
		private var origin:Point = new Point(0,0);
		private var preBlur:BlurFilter;
		private var postBlur:BlurFilter;
		
		/*Scaled Fire Bitmap*/
		private var scale:Number;
		private var scale_bitmap_data:BitmapData;
		private var scale_bitmap:Bitmap;
		private var scale_matrix:Matrix;
			
		public function FireRenderer() {
			/*scale = fire_width/displayWidth;
			scale_bitmap_data = new BitmapData(displayWidth*scale, displayHeight*scale, true, 0x0);
			scale_bitmap = new Bitmap(scale_bitmap_data);
			scale_matrix = new Matrix(scale, 0, 0, scale);
			*/
			clouds = new ScrollingPerlinNoise(displayWidth,displayHeight, 1, -5, true, 0x000000, 5, 30,150,true);
			clouds2 = new ScrollingPerlinNoise(displayWidth,displayHeight, -1, -6, true, 0x000000, 5, 40,100,true);
			//we want these "clouds" to have more contrast:
			var contrast:ColorMatrixFilter = new ColorMatrixFilter([4,0,0,0,-400,
																	4,0,0,0,-400,
																	4,0,0,0,-400,
																	0,0,0,1,0]);
			
			clouds.cloudsBitmapData.applyFilter(clouds.cloudsBitmapData,clouds.cloudsBitmapData.rect,origin,contrast);
			clouds2.cloudsBitmapData.applyFilter(clouds2.cloudsBitmapData,clouds2.cloudsBitmapData.rect,origin,contrast);
			
			//The dmfClouds will be used as the source for the displacement map filter.
			dmfClouds = new ScrollingPerlinNoise(displayWidth,displayHeight, 3, -14, true,0x800000, 5, 120,200,false);
			
			dmfSource = new BitmapData(displayWidth,displayHeight,false,0x000000);
			
			//shapeGrad will be used to round out the top of the perlin noise cloud display before distorting it.
			shapeGrad = new Shape();
			var mat:Matrix = new Matrix();
			var gw:Number = displayWidth;
			var gh:Number = 2*displayHeight;
			mat.createGradientBox(gw,gh,0,0.5*(displayWidth - gw),0);
			shapeGrad.graphics.beginGradientFill("radial",[0xFFFFFF,0],[0,1],[0,255],mat);
			shapeGrad.graphics.drawRect(0,0,displayWidth,displayHeight);
			shapeGrad.graphics.endFill();					
			dmfSource.draw(shapeGrad);
			
			
			preBlur = new BlurFilter(3,10);
			postBlur = new BlurFilter(2, 2);
			dmf = new DisplacementMapFilter(dmfSource, new Point(), BitmapDataChannel.RED, BitmapDataChannel.BLUE, 120, 500, DisplacementMapFilterMode.COLOR,0x000000,0);
			
			var a:Number = 16;
			var d:Number = -1024;
			cmf = new ColorMatrixFilter([a*1,0,0,0,d,
										 a*0.6,0,0,0,d,
										 a*0.4,0,0,0,d,
										 2.4,0,0,0,0]);
			clouds.startScroll();
			clouds2.startScroll();
			dmfClouds.startScroll();
		}
	
	
	
	
		public function step() {
			dmfClouds.step();
			clouds.step();
			clouds2.step();
			dmfSource.draw(dmfClouds);	
			
			displayBitmapData.lock();
			
			displayBitmapData.draw(clouds);
			displayBitmapData.draw(clouds2,null,null,BlendMode.ADD);
			displayBitmapData.draw(shapeGrad);
			
			displayBitmapData.applyFilter(displayBitmapData, displayRect, origin, cmf);
			displayBitmapData.applyFilter(displayBitmapData, displayRect, origin, preBlur);
			displayBitmapData.applyFilter(displayBitmapData, displayRect, origin, dmf);
			displayBitmapData.applyFilter(displayBitmapData, displayRect, origin, postBlur);
			
			displayBitmapData.unlock();
			
			/*scale_bitmap_data.fillRect(scale_bitmap_data.rect, 0x0);
			scale_bitmap_data.draw(displayBitmapData, scale_matrix, null, null, null, true);
			*/
		}
		
		public function getBitmapData() {
			return displayBitmapData;
		}
	}
}