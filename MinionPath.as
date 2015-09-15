package 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class MinionPath extends MovieClip 
	{
		
		private var canvas:Sprite = new Sprite();
		private var gfx:Graphics = canvas.graphics;
		public function MinionPath() {
			
		}
		
		public function init(waypoints:Array) {
			addChild(canvas);
			gfx.lineStyle(40, 0xFFFFFF, .5);
			gfx.moveTo(waypoints[0].x, waypoints[0].y);
			for (var i:int = 1; i < waypoints.length; i++) {
				gfx.lineTo(waypoints[i].x, waypoints[i].y);
			}
		}
	}
	
}