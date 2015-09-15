package 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Launcher extends MovieClip 
	{
		public var num_sides:int = 3;
		public var frame_delay:int = 120;
		public var canvas:Sprite = new Sprite();
		public var canvas_gfx:Graphics = canvas.graphics;
		public var radius:int = 23;
		
		public function Launcher() {
			
		}
		
		public function init(num_sides_p:int, frame_delay_p:int) {
			addChild(canvas);
			num_sides = num_sides_p;
			frame_delay = frame_delay_p;
			draw();
		}
		public function draw() {
			canvas_gfx.clear();
			canvas_gfx.beginFill(0xFFFFFF);
			canvas_gfx.lineStyle(3, 0x000000);
			canvas_gfx.moveTo(radius, 0);
			for (var i:int = 1; i < num_sides; i++) {
				var delta_theta:Number = ((Math.PI * 2) / num_sides)*i;
				canvas_gfx.lineTo(Math.cos(delta_theta) * radius, Math.sin(delta_theta) * radius);
			}
			canvas_gfx.lineTo(radius, 0);
			canvas_gfx.endFill();
		}
	}
	
}