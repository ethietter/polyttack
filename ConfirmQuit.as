package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class ConfirmQuit extends MovieClip 
	{
		
		private var yes_callback:Function;
		private var no_callback:Function;
		private var is_visible:Boolean = true;
		
		public function ConfirmQuit() {
			
		}
		
		public function init(yes_callback_p:Function, no_callback_p:Function) {
			yes_callback = yes_callback_p;
			no_callback = no_callback_p;
			yes_btn.addEventListener(MouseEvent.CLICK, onYesClick, false, 0, true);
			no_btn.addEventListener(MouseEvent.CLICK, onNoClick, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true);
		}
		
		private function onYesClick(evt:MouseEvent) {
			yes_callback();
		}
		
		private function onNoClick(evt:MouseEvent) {
			no_callback();
		}
		
		private function onKeyPress(evt:KeyboardEvent) {
			if (evt.keyCode == 27) {
				if (is_visible) hide();
			}
		}
		
		public function hide() {
			this.x = -1000;
			is_visible = false;
		}
		
		public function show() {
			this.x = 0;
			is_visible = true;
		}
	}
	
}