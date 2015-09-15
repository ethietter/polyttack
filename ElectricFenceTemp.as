package 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class ElectricFenceTemp extends MovieClip 
	{
		
		private var p1:Point;
		private var p2:Point;
		private var canvas:Sprite = new Sprite();
		private var gfx:Graphics = canvas.graphics;
		
		public function ElectricFenceTemp() {
			
		}
		
		public function init() {
			addChild(canvas);
		}
		
		public function setStart(p1_p:Point) {
			p1 = p1_p;
		}
		
		public function drawFence(p2_p:Point) {
			p2 = p2_p;
			gfx.clear();
			gfx.lineStyle(2, 0xFAFF78, 1);
			gfx.moveTo(p1.x, p1.y);
			gfx.lineTo(p2.x, p2.y);
		}
		
		public function getStartPoint() {
			return p1;
		}
		
		public function clearGfx() {
			gfx.clear();
		}
	}
	
}