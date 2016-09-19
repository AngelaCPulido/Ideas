package cj.qcreative.portfolio {
	
	import flash.display.MovieClip
	import flash.events.MouseEvent;
	
	// this class controls mouse events for the arrows
    public class MyArrow extends MovieClip {
		
		// begin private vars
		private var up:Boolean, kicker:Function;
		// end private vars
		
		// class constructor
		public function MyArrow(cb:Function, boo:Boolean = false) {
			
			up = boo;
			kicker = cb;
			
			activate();
			
		}
		
		// adds mouse events
		internal function activate():void {
			
			addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			this.buttonMode = true;
			
		}
		
		// removes mouse events
		internal function deactivate():void {
			
			removeEventListener(MouseEvent.ROLL_OVER, over);
			removeEventListener(MouseEvent.ROLL_OUT, out);
			removeEventListener(MouseEvent.CLICK, clicked);
			this.buttonMode = false;
			
			gotoAndStop(1);
			
		}
		
		// mouse over event
		private function over(event:MouseEvent):void {
			
			gotoAndPlay("over");
			
		}
		
		// mouse out event
		private function out(event:MouseEvent):void {
			
			gotoAndPlay("out");
			
		}
		
		// mouse click event
		private function clicked(event:MouseEvent):void {
			
			kicker(up);
			
		}
		
		
    }
}








