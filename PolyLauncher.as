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
	public class PolyLauncher extends MovieClip 
	{
		
		private var num_sides:int = 0;
		private var canvas:Sprite = new Sprite();
		private var gfx:Graphics = canvas.graphics;
		private var radius:int = Constants.POLY_RADIUS;
		private var wait_frame_count:int = 0;
		private var wait_frame_max:int = 60;
		private var min_launch_speed:int;
		private var max_launch_speed:int;
		private var game_play:GamePlay;
		private var level_over:Boolean = false;
		
		public function PolyLauncher(game_play_ref:GamePlay) {
			game_play = game_play_ref;			
		}
		
		public function init(wait_frame_max_p:int, num_sides_p:int, min_launch_speed_p:int, max_launch_speed_p:int) {
			addChild(canvas);
			wait_frame_max = wait_frame_max_p;
			num_sides = num_sides_p;
			min_launch_speed = min_launch_speed_p;
			max_launch_speed = max_launch_speed_p;
			wait_frame_count = wait_frame_max;//to make it fire immediately
			draw();
		}
		
		
		private function draw() {
			gfx.clear();
			gfx.beginFill(0x000);
			gfx.lineStyle(3, 0x000);
			gfx.moveTo(radius, 0);
			for (var i:int = 1; i < num_sides; i++) {
				var delta_theta:Number = ((Math.PI * 2) / num_sides)*i;
				gfx.lineTo(Math.cos(delta_theta) * radius, Math.sin(delta_theta) * radius);
			}
			gfx.lineTo(radius, 0);
			gfx.endFill();
		}
		
		public function step() {
			if(!level_over){
				this.rotation += .5;
				wait_frame_count++;
				if (wait_frame_count >= wait_frame_max) {
					wait_frame_count = 0;
					var start_point:Point = new Point(this.x, this.y);
					for (var i:int = 0; i < num_sides; i++) {
						var theta:Number = rotation * Math.PI / 180 + (i * (Math.PI * 2 / num_sides)) + Math.PI * 2 / (2 * num_sides);
						var speed:Number = Math.ceil((max_launch_speed - min_launch_speed) * Math.random()) + min_launch_speed;
						var sides:Number = Math.ceil((num_sides - 2) * Math.random()) + 2;
						theta += 
						game_play.fire(sides, start_point, theta, speed);
					}
				}
			}
		}
		
		public function levelOver() {
			level_over = true;
		}
	}
	
}