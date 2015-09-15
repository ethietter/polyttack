package {

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import LinkedList4.*;
	
	public class Main extends MovieClip {
		
		public const WAYPOINT_TOOL:String = "waypoint_tool";
		public const GRABBING_TOOL:String = "grabbing_tool";
		public const LAUNCHER_TOOL:String = "launcher_tool";
		public const ERASER_TOOL:String = "eraser_tool";
		
		public var waypoints_list:LinkedList = new LinkedList();
		public var current_tool:String = WAYPOINT_TOOL;
		public var user_interface:Interface = new Interface();
		public var canvas:Sprite = new Sprite();
		public var canvas_gfx:Graphics = canvas.graphics;
		public var launchers_array:Array = new Array();
		
		public var waypoint_dragging:Waypoint;
		public var is_dragging:Boolean = false;
		
		public function Main() {
			addChild(user_interface);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseGo, false, 0, true);
			
			user_interface.waypoint_tool.addEventListener(MouseEvent.CLICK, onWaypointToolClick, false, 0, true);
			user_interface.grabbing_tool.addEventListener(MouseEvent.CLICK, onGrabbingToolClick, false, 0, true);
			user_interface.launcher_tool.addEventListener(MouseEvent.CLICK, onLauncherToolClick, false, 0, true);
			user_interface.eraser_tool.addEventListener(MouseEvent.CLICK, onEraserToolClick, false, 0, true);
			user_interface.export_btn.addEventListener(MouseEvent.CLICK, onExportBtnClick, false, 0, true);
			addChild(canvas);
		}
		
		private function onMousePress(evt:MouseEvent) {
			if (current_tool == GRABBING_TOOL) {
				waypoints_list.forEach(
					function callback(thisObject:*, data:*, index:int) {
						var curr_waypoint:Waypoint = thisObject;
						if ((curr_waypoint.x - stage.mouseX) * (curr_waypoint.x - stage.mouseX) + (curr_waypoint.y - stage.mouseY) * (curr_waypoint.y - stage.mouseY) <= 16 * 16) {
							waypoint_dragging = curr_waypoint;
							is_dragging = true;
						}
					},
					waypoints_list
				);
			}
		}
		
		private function onMouseGo(evt:MouseEvent) {
			if (current_tool == GRABBING_TOOL) {
				if(is_dragging){
					waypoint_dragging.x = stage.mouseX;
					waypoint_dragging.y = stage.mouseY;
					if (waypoint_dragging.x > 550) {
						waypoint_dragging.x = 550;
					}
					if (waypoint_dragging.x < 0) {
						waypoint_dragging.x = 0;
					}
					if (waypoint_dragging.y > 550) {
						waypoint_dragging.y = 550;
					}
					if (waypoint_dragging.y < 0) {
						waypoint_dragging.y = 0;
					}
					drawLines();
				}
			}
		}
		
		private function onMouseRelease(evt:MouseEvent) {
			if (current_tool == GRABBING_TOOL) {
				is_dragging = false;
				drawLines();
			}
		}
		private function onMouseClick(evt:MouseEvent) {
			if (current_tool == WAYPOINT_TOOL) {
				if(stage.mouseX < 550 && stage.mouseX >0 && stage.mouseY > 0 && stage.mouseY < 550){
					var waypoint:Waypoint = new Waypoint();
					waypoint.x = stage.mouseX;
					waypoint.y = stage.mouseY;
					waypoints_list.push(waypoint);
					addChild(waypoint);
					drawLines();
				}
			}
			if (current_tool == ERASER_TOOL) {
				var object_removed:Boolean = false;
				waypoints_list.forEach(
					function callback(data:*, index:int, something:*) {
						var curr_waypoint:Waypoint = data;
						if ((curr_waypoint.x - stage.mouseX) * (curr_waypoint.x - stage.mouseX) + (curr_waypoint.y - stage.mouseY) * (curr_waypoint.y - stage.mouseY) <= 16 * 16) {
							if(index != 0 && index != waypoints_list.getLength()-1){
								removeChild(curr_waypoint);
								waypoints_list.splice(index - 1, 1);
								object_removed = true;
							}
						}
					},
					waypoints_list
				);
				for (var i:int = 0; i < launchers_array.length; i++) {
					if (launchers_array[i].hitTestPoint(stage.mouseX, stage.mouseY, true)) {
						removeChild(launchers_array[i]);
						launchers_array.splice(i, 1);
					}
				}
				drawLines();
			}
			if (current_tool == LAUNCHER_TOOL) {
				if(stage.mouseX < 500 && stage.mouseX > 50 && stage.mouseY > 50 && stage.mouseY < 500){
					var launcher:Launcher = new Launcher();
					launcher.x = stage.mouseX;
					launcher.y = stage.mouseY;
					addChild(launcher);
					var num_sides:int = int(user_interface.launcher_num_sides.text);
					if (num_sides < 3) {
						num_sides = 3;
					}
					if (num_sides > 12) {
						num_sides = 12;
					}
					var frame_delay:int = int(user_interface.launcher_frame_delay.text);
					if (frame_delay < 20) {
						frame_delay = 20;
					}
					if (frame_delay > 500) {
						frame_delay = 500;
					}
					launcher.init(num_sides, frame_delay);
					launchers_array.push(launcher);
				}
			}
		}
		
		public function drawLines() {
			canvas_gfx.clear();
			canvas_gfx.lineStyle(2, 0x0);
			var count:int = 0;
			waypoints_list.forEach(
				function callback(data:*, index:int, something:*) {
					var curr_element:Waypoint = data;
					if (count == 0) {
						canvas_gfx.moveTo(curr_element.x, curr_element.y);
					}
					else {
						canvas_gfx.lineTo(curr_element.x, curr_element.y);
					}
					count++;
				},
				waypoints_list
			);
		}
		
		public function export() {
			//make sure to shift all waypoint x and y values to the left and up by 50 pixels
			var i:int = 0;
			var launcher_locations_str:String = "level.launcher_locations = [";
			for (i = 0; i < launchers_array.length; i++) {
				if (i != 0) {
					launcher_locations_str += ",";
				}
				launcher_locations_str += "new Point(" + (launchers_array[i].x - 50) + ", " + (launchers_array[i].y - 50) + ")";
			}
			launcher_locations_str += "];";
			
			var launcher_sides_str:String = "level.launcher_sides = [";
			for (i = 0; i < launchers_array.length; i++) {
				if (i != 0) {
					launcher_sides_str += ",";
				}
				launcher_sides_str += launchers_array[i].num_sides;
			}
			launcher_sides_str += "];";
			
			var launcher_wait_times_str:String = "level.launcher_wait_times = [";
			for (i = 0; i < launchers_array.length; i++) {
				if (i != 0) {
					launcher_wait_times_str += ",";
				}
				launcher_wait_times_str += launchers_array[i].frame_delay;
			}
			launcher_wait_times_str += "];";
			
			var minion_way_points_str:String = "level.minion_way_points = [";
			waypoints_list.forEach(
				function callback(data:*, index:int, something:*) {
					var curr_waypoint:Waypoint = data;
					if (index != 0) {
						minion_way_points_str += ",";
					}
					minion_way_points_str += "new Point(" + (curr_waypoint.x - 50) + ", " + (curr_waypoint.y - 50) + ")";
				},
				waypoints_list
			);
			minion_way_points_str += "];";
			
			trace(launcher_locations_str);
			trace(launcher_sides_str);
			trace(launcher_wait_times_str)
			trace(minion_way_points_str);
			trace("level.wait_frame_max = 100; //how many frames to wait for the next minion to show up");
			trace("level.min_launch_speed = ;");
			trace("level.max_launch_speed = ;");
			trace("level.minions_to_save = ;");
			trace("level.minions_available = 25;");
			trace("level.poly_limit = ;");
			trace("level.time_allowed = ;");
		}
		
		
		private function onWaypointToolClick(evt:MouseEvent) {
			current_tool = WAYPOINT_TOOL;
		}
		
		private function onEraserToolClick(evt:MouseEvent) {
			current_tool = ERASER_TOOL;
		}
		
		private function onGrabbingToolClick(evt:MouseEvent) {
			current_tool = GRABBING_TOOL;
		}
		
		private function onLauncherToolClick(evt:MouseEvent) {
			current_tool = LAUNCHER_TOOL;
		}
		
		private function onExportBtnClick(evt:MouseEvent) {
			export();
		}
	}
	
}

