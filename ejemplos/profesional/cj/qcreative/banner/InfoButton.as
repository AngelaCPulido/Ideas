package cj.qcreative.banner {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// this class controls the info button behaviour
    public final class InfoButton extends MovieClip {
		
		private var func:Function;
		
		// class constructor
		public function InfoButton(cb:Function) {
			
			stop();
			func = cb;
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			
		}
		
		// fires when added to the stage
		private function added(event:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			this.buttonMode = true;
			turnMouse();
			
		}
		
		// add the mouse event roll listeners
		private function turnMouse():void {
			addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
		}
		
		// add the click event listener
		internal function onListen():void {
			addEventListener(MouseEvent.CLICK, func, false, 0, true);
			turnMouse();
		}
		
		// remove the click event listener
		internal function offListen():void {
			removeEventListener(MouseEvent.CLICK, func);
		}
		
		// glow the info button 
		private function over(event:MouseEvent):void {
			gotoAndPlay("over");
		}
		
		// remove the info button glow
		private function out(event:MouseEvent):void {
			gotoAndPlay("out");
		}
		
		// GARBAGE COLLECTION
		internal function finalKill():void {
			
			stop();
			
			// remove event listeners
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			removeEventListener(MouseEvent.ROLL_OUT, out);
			removeEventListener(MouseEvent.CLICK, func);
			
			// remove children
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			func = null;
			
		}
		
		
    }
}








