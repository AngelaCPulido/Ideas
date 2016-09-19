package cj.qcreative.banner {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// this class controls the play/pause button
    public final class PlayPause extends MovieClip {
		
		// begin private vars
		private var func:Function, onPlay:Boolean;
		// end private vars
		
		// class constructor
		public function PlayPause(cb:Function) {
			
			stop();
			pp.stop();
			onPlay = false;
			func = cb;
			
			// listen for the stage
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			
		}
		
		// fires when added to the stage
		private function added(event:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			// add mouse events
			addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			this.buttonMode = true;
			
		}
		
		// mouse over function
		private function over(event:MouseEvent):void {
			gotoAndPlay("over");
		}
		
		// mouse out function
		private function out(event:MouseEvent):void {
			gotoAndPlay("out");
		}
		
		// checks to see if either play or pause is active
		internal function getPlay():Boolean {
			if(pp.currentFrame == 1) {
				return true;
			}
			else {
				return false;
			}
		}
		
		// play-pause click event
		private function clicked(event:MouseEvent):void {
			
			if(onPlay) {
				onPlay = false;
				pp.gotoAndStop(1);
			}
			else {
				onPlay = true;
				pp.gotoAndStop(2);
			}
			func(onPlay);
			
		}
		
		// GARBAGE COLLECTION
		internal function finalKill():void {
			
			stop();
			
			// remove event listeners
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.CLICK, clicked);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			removeEventListener(MouseEvent.ROLL_OUT, out);
			
			// remove children
			while(pp.numChildren) {
				pp.removeChildAt(0);
			}
			
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			func = null;
			
		}
		
		
    }
}








