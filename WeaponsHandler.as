package 
{
	import customevents.TutorialEvent;
	import customevents.AnimationEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class WeaponsHandler extends MovieClip 
	{
		
		private var game_play:GamePlay;
		private var launcher_locations:Array;
		private var current_weapon:String = Weapons.PISTOL;
		private var step_count:int = 0;
		private var machine_gun_firing:Boolean = false;
		private var drawing_fence:Boolean = false;
		private var polys_array:Array;
		private var fighter_jets_queue:Queue = new Queue();
		
		private var bullet_flashes_array:Array = new Array();
		
		private const INVALID_DIST:int = Constants.POLY_RADIUS + 15;
		
		
		private var curr_ghost:MovieClip;
		private var grenade_ghost:MovieClip = new GrenadeGhost();
		private var spitter_ghost:MovieClip = new SpitterGhost();
		private var ice_cannon_ghost:MovieClip = new IceCannonGhost();
		private var fan_ghost:MovieClip = new FanGhost();
		private var black_hole_ghost:MovieClip = new BlackHoleGhost();
		private var rocket_launcher_ghost:MovieClip = new RocketLauncherGhost();
		private var fighter_jet_ghost:MovieClip = new FighterJetGhost();
		private var fire_ghost:MovieClip = new FireGhost();
		private var temp_electric_fence:MovieClip = new ElectricFenceTemp();
		
		private var no_ghost:MovieClip = new MovieClip();
		private var invalid_x:MovieClip = new InvalidX();
		
		
		private var invalid_location:Boolean = false;
		private var level_over:Boolean = false;
				
		// this will hold a reference to all of the weapons that are added to the stage
		// This way when the level is over they can all be safely removed from the stage
		// and won't throw any errors.
		private var weapon_objects_array:Array = new Array();
		
		public function WeaponsHandler() {
			
		}
		
		public function init(game_play_ref:GamePlay, launcher_locations_ref:Array) {
			game_play = game_play_ref;
			launcher_locations = launcher_locations_ref;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse, false, 0, true);
			stage.addEventListener(AnimationEvent.TAKEOFF_OVER, onTakeoffOver, false, 0, true);
			
			polys_array = game_play.getPolysArray();
			
			curr_ghost = ice_cannon_ghost;
			
			addChild(ice_cannon_ghost);
			addChild(grenade_ghost);
			addChild(spitter_ghost);
			addChild(fan_ghost);
			addChild(black_hole_ghost);
			addChild(rocket_launcher_ghost);
			addChild(fire_ghost);
			addChild(fighter_jet_ghost);
			addChild(temp_electric_fence);
			temp_electric_fence.init();
			fire_ghost.init(game_play.getFireRenderer());
			addChild(invalid_x);
			addChild(no_ghost);
			
			ice_cannon_ghost.visible = false;
			grenade_ghost.visible = false;
			spitter_ghost.visible = false;
			fan_ghost.visible = false;
			black_hole_ghost.visible = false;
			rocket_launcher_ghost.visible = false;
			fighter_jet_ghost.visible = false;
			fire_ghost.visible = false;
			invalid_x.visible = false;
			
			ice_cannon_ghost.alpha = .4;
			grenade_ghost.alpha = .4;
			spitter_ghost.alpha = .4;
			fan_ghost.alpha = .4;
			black_hole_ghost.alpha = .4;
			rocket_launcher_ghost.alpha = .4;
			fire_ghost.alpha = .4;
			fighter_jet_ghost.alpha = .4;
			curr_ghost.visible = true;
			switchWeapon(Weapons.PISTOL);
		}
		
		private function onMousePress(evt:MouseEvent) {
			if(!game_play.isPaused()){
				var i:int;
				if (current_weapon == Weapons.PISTOL) {
					if (game_play.getCurrentLevel() == 1) {
						dispatchEvent(new TutorialEvent(TutorialEvent.SHOW_WEAPON));
					}
					if(stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT){
						makeBullet();
						for (i = 0; i < polys_array.length; i++) {
							if (checkPointHit(stage.mouseX, stage.mouseY, polys_array[i].X, polys_array[i].Y)) {
								polys_array[i].attacked();
							}
						}
					}
				}
				if (current_weapon == Weapons.MACHINE_GUN) {
					if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
						machine_gun_firing = true;
					}
				}
				if (current_weapon == Weapons.GRENADE) {
					if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
						if (game_play.subtractMoney(Weapons.GRENADE_COST)) {
							dropGrenade(stage.mouseX, stage.mouseY);
							dispatchEvent(new TutorialEvent(TutorialEvent.SHOW_GRENADE));
						}
						else {
							showFlashingRed();
						}
					}
				}
				if(!invalid_location){
					if (current_weapon == Weapons.SPITTER) {
						if(stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT){
							if(game_play.subtractMoney(Weapons.SPITTER_COST)){
								var spitter:Spitter = new Spitter(game_play);
								addChild(spitter);
								spitter.init(game_play.getPolysArray(), stage.mouseX, stage.mouseY);
								weapon_objects_array.push(spitter);
							}
							else {
								showFlashingRed();
							}
						}
					}
					if (current_weapon == Weapons.ICE_CANNON) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							if(game_play.subtractMoney(Weapons.ICE_CANNON_COST)){
								var ice_cannon:IceCannon = new IceCannon();
								addChild(ice_cannon);
								ice_cannon.init(game_play.getPolysArray(), stage.mouseX, stage.mouseY);
								weapon_objects_array.push(ice_cannon);
							}
							else {
								showFlashingRed();
							}
						}
					}
					if (current_weapon == Weapons.FAN) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							if (game_play.subtractMoney(Weapons.FAN_COST)) {
								var fan:Fan = new Fan();
								addChild(fan);
								fan.init(game_play.getPolysArray(), stage.mouseX, stage.mouseY);
								weapon_objects_array.push(fan);
							}
							else {
								showFlashingRed();
							}
						}
					}
					
					if (current_weapon == Weapons.BLACK_HOLE) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							if (game_play.subtractMoney(Weapons.BLACK_HOLE_COST)) {
								var black_hole:BlackHole = new BlackHole();
								addChild(black_hole);
								black_hole.init(game_play.getPolysArray(), stage.mouseX, stage.mouseY);
								weapon_objects_array.push(black_hole);
							}
							else {
								showFlashingRed();
							}
						}
					}
					
					if (current_weapon == Weapons.ROCKET_LAUNCHER) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							if (game_play.subtractMoney(Weapons.ROCKET_LAUNCHER_COST)) {
								var rocket_launcher:RocketLauncher = new RocketLauncher();
								addChild(rocket_launcher);
								rocket_launcher.init(game_play.getPolysArray(), stage.mouseX, stage.mouseY, this, game_play.getRocketLauncherLevel());
								weapon_objects_array.push(rocket_launcher);
							}
							else {
								showFlashingRed();
							}
						}
					}
					
					if (current_weapon == Weapons.FIRE) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							if (game_play.subtractMoney(Weapons.FIRE_COST)) {
								//add a fire as a child - all fires should exist statically. If a static fire touches a poly,
								//a new fire should be added here, and it will be instructed to follow the poly that it touched.
								//Fire should not spread on every contact; Fire should burn out after a short period of time
								
								var fire_object:FireObject = new FireObject(game_play.getFireRenderer(), this, game_play.getPolysArray(), stage.mouseX, stage.mouseY);
								addChild(fire_object);
								fire_object.init();
								weapon_objects_array.push(fire_object);
							}
							else {
								showFlashingRed();
							}
						}
					}
					
					if (current_weapon == Weapons.ELECTRIC_FENCE) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							temp_electric_fence.setStart(new Point(stage.mouseX, stage.mouseY));
							drawing_fence = true;
						}
					}
					
					if (current_weapon == Weapons.FIGHTER_JET) {
						if (stage.mouseX > 0 && stage.mouseX < Constants.STAGE_WIDTH && stage.mouseY > 0 && stage.mouseY < Constants.STAGE_HEIGHT) {
							if(game_play.subtractMoney(Weapons.FIGHTER_JET_COST)){
								var fighter_jet_animation:FighterJetAnimation = new FighterJetAnimation(stage.mouseX, stage.mouseY);
								addChild(fighter_jet_animation);
								fighter_jets_queue.addItem(fighter_jet_animation);
							}
							else {
								showFlashingRed();
							}
						}
					}
				}
			}
		}
		
		private function onMoveMouse(evt:MouseEvent) {
			if(curr_ghost !== no_ghost){
				curr_ghost.x = invalid_x.x = stage.mouseX;
				curr_ghost.y = invalid_x.y = stage.mouseY;
				invalid_location = false;
				if(current_weapon == Weapons.ICE_CANNON || current_weapon == Weapons.SPITTER || current_weapon == Weapons.FAN || current_weapon == Weapons.BLACK_HOLE || current_weapon == Weapons.FIRE) {
					for (var i:int = 0; i < launcher_locations.length; i++) {
						if ((launcher_locations[i].x - stage.mouseX) * (launcher_locations[i].x - stage.mouseX) + (launcher_locations[i].y - stage.mouseY) * (launcher_locations[i].y - stage.mouseY) < INVALID_DIST*INVALID_DIST) {
							invalid_location = true;
							break;
						}
					}
				}
				if (invalid_location) {
					invalid_x.visible = true;
				}
				else {
					invalid_x.visible = false;
				}
				if(curr_ghost.visible){
					if (curr_ghost.x > Constants.STAGE_WIDTH || curr_ghost.x < 0 || curr_ghost.y > Constants.STAGE_HEIGHT || curr_ghost.y < 0) {
						curr_ghost.visible = false;
						Mouse.show();
					}
				}
				if (!curr_ghost.visible) {
					if (curr_ghost.x < Constants.STAGE_WIDTH && curr_ghost.x > 0 && curr_ghost.y < Constants.STAGE_HEIGHT && curr_ghost.y > 0) {
						if(!game_play.isPaused()){
							curr_ghost.visible = true;
							Mouse.hide();
						}
					}
				}
				if (invalid_location) {
					curr_ghost.visible = false;
				}
				evt.updateAfterEvent();
			}
			if (current_weapon == Weapons.ELECTRIC_FENCE && drawing_fence) {
				temp_electric_fence.drawFence(new Point(stage.mouseX, stage.mouseY));
			}
		}
		
		private function onMouseRelease(evt:MouseEvent) {
			machine_gun_firing = false;
			if (current_weapon == Weapons.ELECTRIC_FENCE && drawing_fence) {
				drawing_fence = false;
				temp_electric_fence.clearGfx();
				makeRealFence(temp_electric_fence.getStartPoint(), new Point(stage.mouseX, stage.mouseY));
			}
		}
		
		private function onTakeoffOver(evt:AnimationEvent) {
			var temp_animation:FighterJetAnimation = fighter_jets_queue.removeItem();
			var fighter_jet:FighterJet = new FighterJet();
			addChild(fighter_jet);
			fighter_jet.init(temp_animation.init_x, temp_animation.init_y, this);
			weapon_objects_array.push(fighter_jet);
			removeChild(temp_animation);
		}
		
		private function minimizeWeaponsArray() {
			for (var i:int = 0; i < weapon_objects_array.length; i++) {
				if (weapon_objects_array[i].isUsed()) {
					removeChild(weapon_objects_array[i]);
					weapon_objects_array.splice(i, 1);
				}
			}
		}
		
		public function dropGrenade(x_init:int, y_init:int) {
			var grenade:Grenade = new Grenade(game_play);
			addChild(grenade);
			grenade.init(game_play.getPolysArray(), x_init, y_init, game_play.getGrenadeLevel());
			weapon_objects_array.push(grenade);
		}
		
		public function step() {
			if(!level_over){
				step_count++;
				var i:int;
				for (i = 0; i < weapon_objects_array.length; i++) {
					if (weapon_objects_array[i].uses_clock) {
						weapon_objects_array[i].step();
					}
				}
				if (step_count == 100) {
					minimizeWeaponsArray();
					step_count = 0;
				}
				if (machine_gun_firing) {
					if(game_play.subtractMoney(Weapons.MACHINE_GUN_COST)){
						if(Math.random() > .2){
							makeBullet();
						}
						for (i = 0; i < polys_array.length; i++) {
							if (checkPointHit(stage.mouseX, stage.mouseY, polys_array[i].X, polys_array[i].Y)) {
								polys_array[i].attacked();
							}
						}
					}
					else {
						showFlashingRed();
					}
				}
				if (current_weapon == Weapons.FIRE)
				{
					fire_ghost.step();
				}
			}
		}
		
		private function makeRealFence(p1_p:Point, p2_p:Point) {
			var electric_fence:ElectricFence = new ElectricFence();
			electric_fence.init(game_play.getPolysArray(), p1_p, p2_p);
			addChild(electric_fence);
			weapon_objects_array.push(electric_fence);
		}
		
		public function makeFire(pos_x:int, pos_y:int, poly_to_follow:Poly) {
			var fire_object:FireObject = new FireObject(game_play.getFireRenderer(), this, game_play.getPolysArray(), pos_x, pos_y, false, 30+Math.floor(Math.random()*40), poly_to_follow);
			addChild(fire_object);
			fire_object.init();
			weapon_objects_array.push(fire_object);
		}
		public function makeMissileExplosion(curr_x:int, curr_y:int) {
			var missile_explosion:MissileExplosion = new MissileExplosion(game_play);
			addChild(missile_explosion);
			missile_explosion.init(polys_array, curr_x, curr_y);
			weapon_objects_array.push(missile_explosion);
		}
		
		private function makeBullet() {
			var bullet_flash:BulletFlash = new BulletFlash();
			addChild(bullet_flash);
			bullet_flash.x = stage.mouseX;
			bullet_flash.y = stage.mouseY;
			bullet_flashes_array.push(bullet_flash);
			game_play.main.playSoundEffect("bullet_sound", false);
		}
		
		private function checkPointHit(bullet_x:int, bullet_y:int, poly_x:int, poly_y:int) {
			if ((bullet_x - poly_x) * (bullet_x - poly_x) + (bullet_y - poly_y) * (bullet_y - poly_y) <= Constants.POLY_ATTACK_RADIUS * Constants.POLY_ATTACK_RADIUS) {
				return true;
			}
		}
		
		private function showFlashingRed() {
			game_play.showFlashingRed();
		}
		
		public function levelOver() {
			level_over = true;
			for (var i:int = 0; i < weapon_objects_array.length; i++) {
				weapon_objects_array[i].destroy();
			}
			minimizeWeaponsArray();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse, false);
			stage.removeEventListener(AnimationEvent.TAKEOFF_OVER, onTakeoffOver, false);
		}
		
		public function switchWeapon(new_weapon:String) {
			current_weapon = new_weapon;
			spitter_ghost.visible = false;
			ice_cannon_ghost.visible = false;
			grenade_ghost.visible = false;
			fan_ghost.visible = false;
			black_hole_ghost.visible = false;
			rocket_launcher_ghost.visible = false;
			fighter_jet_ghost.visible = false;
			fire_ghost.visible = false;
			switch(current_weapon) {
				case Weapons.SPITTER:
					curr_ghost = spitter_ghost;
					break;
				case Weapons.ICE_CANNON:
					curr_ghost = ice_cannon_ghost;
					break;
				case Weapons.GRENADE:
					curr_ghost = grenade_ghost;
					break;
				case Weapons.FAN:
					curr_ghost = fan_ghost;
					break;
				case Weapons.BLACK_HOLE:
					curr_ghost = black_hole_ghost;
					break;
				case Weapons.ROCKET_LAUNCHER:
					curr_ghost = rocket_launcher_ghost;
					break;
				case Weapons.FIRE:
					curr_ghost = fire_ghost;
					break;
				case Weapons.FIGHTER_JET:
					curr_ghost = fighter_jet_ghost;
					break;
				default:
					curr_ghost = no_ghost;
			}
			curr_ghost.visible = true;
		}
		
		public function getCurrentWeapon() {
			return current_weapon;
		}
	}
	
}