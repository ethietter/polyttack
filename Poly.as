package 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Poly extends MovieClip
	{
		
		private var radius:Number = Constants.POLY_RADIUS;
		private var canvas:Sprite = new Sprite();
		private var gfx:Graphics = canvas.graphics;
		private var velx:Number = 0;
		private var vely:Number = 0;
		private var is_dead:Boolean = false;
		private var num_sides:int;
		private var explode_animation:ExplodeAnimation = new ExplodeAnimation();
		private var game_play:GamePlay;
		private var is_frozen:Boolean = false;
		private var poly_ice:PolyIce = new PolyIce();
		private var speed:Number = 0;
		private var on_fire:Boolean = false;
		private var fire_max_count:int;//how many steps should it be on fire for it to drop a side?
		private var fire_count:int = 0;
		
		
		public function Poly(game_play_ref:GamePlay) {
			game_play = game_play_ref;
		}
		
		public function init(num_sides_p:int, start_point:Point, angle:Number, speed_p:Number) {
			num_sides = num_sides_p;
			addChild(canvas);
			speed = speed_p;
			velx = speed * Math.cos(angle);
			vely = speed * Math.sin(angle);
			canvas.x = start_point.x + velx * Constants.POLY_RADIUS / speed;
			canvas.y = start_point.y + vely * Constants.POLY_RADIUS / speed;
			draw(num_sides);
		}
		
		private function draw(num_sides:int) {
			var fill_color:uint = 0x0;
			switch(num_sides) {
				case 3:
					fill_color = 0xB3D3D5;
					break;
				case 4:
					fill_color = 0xC5E298;
					break;
				case 5:
					fill_color = 0xFF6F3E;
					break;
			}
			gfx.clear();
			gfx.beginFill(fill_color);
			gfx.lineStyle(1, 0x000, 0);
			gfx.moveTo(radius, 0);
			for (var i:int = 1; i < num_sides; i++) {
				var delta_theta:Number = ((Math.PI * 2) / num_sides)*i;
				gfx.lineTo(Math.cos(delta_theta) * radius, Math.sin(delta_theta) * radius);
			}
			gfx.lineTo(radius, 0);
			gfx.endFill();
		}
		
		public function step() {
			if (!is_dead) {
				if (!is_frozen) {
					canvas.rotation+=2;
					canvas.x += velx;
					canvas.y += vely;
					
					if (canvas.x + radius / 2 > Constants.STAGE_WIDTH) {
						canvas.x = Constants.STAGE_WIDTH - radius / 2;
						velx = -velx;
					}
					if (canvas.x - radius / 2 < 0) {
						canvas.x = radius / 2;
						velx = -velx;
					}
					if (canvas.y + radius / 2 > Constants.STAGE_HEIGHT) {
						canvas.y = Constants.STAGE_HEIGHT - radius / 2;
						vely = -vely;
					}
					if (canvas.y - radius / 2 < 0) {
						canvas.y = radius / 2;
						vely = -vely;
					}
				}
				handleCollisions();
			}
		}
		
		private function handleCollisions() {
			if (on_fire) {
				fire_count++;
				if (fire_count > fire_max_count) {
					fire_count = 0;
					attacked(1, true);
				}
			}
			var minions_array:Array = game_play.getMinionsArray();
			for (var i:int = 0; i < minions_array.length; i++) {
				var dx:Number = canvas.x - minions_array[i].x;
				var dy:Number = canvas.y - minions_array[i].y;
				var max_distance:Number = Constants.MINION_ATTACK_RADIUS + Constants.POLY_KILL_RADIUS;
				if (dx * dx + dy * dy <= max_distance * max_distance) {
					canvas.x -= velx;
					canvas.y -= vely;
					velx = -velx;
					vely = -vely;
					minions_array[i].attacked(num_sides);
					//attacked(1, false, true);
					game_play.hitMinion();
				}
			}
		}
		
		public function fanPoly(fan_x:int, fan_y:int) {
			var dy:int =  this.Y - fan_y;
			var dx:int = this.X - fan_x;
			if (dx < 20 && dx >= 0) dx = 20;
			if (dy < 20 && dy >= 0) dy = 20;
			if (dx > -20 && dx <= 0) dx = -20;
			if (dy > -20 && dy <= 0) dy = -20;
			// distance formula squared, make sure the poly is within 150 pixels of the fan
			// to even consider calculating change in velocity
			if (dx * dx + dy * dy < 150 * 150) {
				velx += 15 / dx;
				vely += 15 / dy;
			}
			
		}
		
		public function blackHoleForce(hole_x:int, hole_y:int) {
			var dy:int = hole_y - this.Y;
			var dx:int = hole_x - this.X;
			// distance formula squared, make sure the poly is within 120 pixels of the black hole
			// to even consider calculating change in velocity			
			var distance_squared:Number = dx * dx + dy * dy;
			if (distance_squared < 120 * 120) {
				velx += dx / 250;
				vely += dy / 250;
				velx *= .98;
				vely *= .98;
				if (distance_squared < 20 * 20) {
					velx *= .9;
					vely *= .9;
					canvas.scaleX *= .98;
					canvas.scaleY = canvas.scaleX;
					if (canvas.scaleX < .2) {
						attacked(100, true);
					}
				}
			}
		}
		
		//remove a dead poly from the screen. Then wait for it to be spliced out of the array
		public function remove(showed_explosion:Boolean = true) {
			if (is_frozen && poly_ice.stage != null) {
				removeChild(poly_ice);
			}
			velx = 0;
			vely = 0;
			canvas.x = -500;
		}
		
		public function levelOver() {
			remove();
			if(explode_animation.stage != null){
				removeChild(explode_animation);
				removeEventListener("ExplodeOver", explodeAnimationOver);
			}
			is_dead = true;
		}
		
		public function explodeAnimationOver(evt:Event) {
			removeChild(explode_animation);
			if(this.stage != null){
				this.parent.removeChild(this);
			}
		}
		
		public function electrocuted(new_dir:Point) {
			//attacked();
			velx = new_dir.x;
			vely = new_dir.y;
		}
		
		public function attacked(num_times:int = 1, automated_hit:Boolean = false, from_minion:Boolean = false) {
			if (num_times == 100) {
				//kind of a hack to let this know that it was sucked into a black hole or hit by a missile
				num_sides = 3;
			}
			if (!from_minion) {
				game_play.hitPoly(automated_hit);
			}
			if (num_sides == 6) {
				var theta1:Number = Math.floor(Math.random() * Math.PI / 2);
				game_play.fire(4, new Point(this.X+15, this.Y+15), theta1, speed);
				game_play.fire(3, new Point(this.X-15, this.Y-15), theta1+Math.PI, speed);
				num_sides = 3;
			}
			num_sides -= num_times;
			if (num_sides < 3) {
				is_dead = true;
				game_play.polyKilled();
				//if (num_times != 100) {
					//sucked into a black hole. Don't show the animation
					explode_animation.gotoAndPlay(2);
					addChild(explode_animation);
					explode_animation.x = canvas.x;
					explode_animation.y = canvas.y;
					addEventListener("ExplodeOver", explodeAnimationOver);
				//}
				remove();
			}
			else{
				draw(num_sides);
			}
		}
		
		public function frozen() {
			if (!is_frozen) {
				game_play.main.playSoundEffect("freeze_sound", false);
				poly_ice.x = this.X;
				poly_ice.y = this.Y;
				addChild(poly_ice);
				is_frozen = true;
			}
		}
		
		public function getMotionVector() {
			return new Point(velx, vely);
		}
		
		public function setFire() {
			on_fire = true;
			fire_count = 0;
			fire_max_count = 30 + Math.floor(Math.random() * 30);
		}
		
		public function removeFire() {
			on_fire = false;
		}
		
		public function isOnFire() {
			return on_fire;
		}
		
		public function getNumSides() {
			return num_sides;
		}
		
		public function isDead() {
			return is_dead;
		}
		
		public function get Y() {
			return canvas.y;
		}
		
		public function get X() {
			return canvas.x;
		}
	}
	
}