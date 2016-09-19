package cj.qcreative.videoplayer {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// this class controls the play/pause buttons
    public final class PlayPause extends Sprite {
		
		// begin private vars
		private var isPlaying:Boolean, togglePlay:Function;
		// end private vars
		
		// class constructor
		public function PlayPause(func:Function) {

			togglePlay = func;
			isPlaying = false;
			this.mouseEnabled = false;
			
			playMC.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			playMC.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			playMC.addEventListener(MouseEvent.CLICK, switchPlay, false, 0, true);
			
			pauseMC.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			pauseMC.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			pauseMC.addEventListener(MouseEvent.CLICK, switchPlay, false, 0, true);
			
			playMC.buttonMode = true;
			pauseMC.buttonMode = true;
			
			pauseMC.visible = false;
			
		}
		
		// switches the play button on
		internal function setPlay():void {
			playMC.visible = false;
			pauseMC.visible = true;
			isPlaying = true;
		}
		
		// mouse over event
		private function over(event:MouseEvent):void {
			event.currentTarget.gotoAndStop(2);
		}
		
		// mouse out event
		private function out(event:MouseEvent):void {
			event.currentTarget.gotoAndStop(1);
		}
		
		// checks to see if pause button is active
		internal function checkPause():Boolean {
			
			var checker:Boolean;
			
			(isPlaying) ? checker = true : checker = false;
			isPlaying = true;
			switchPlay();
			
			return checker;
			
		}
		
		// checks to see if play button is active
		internal function checkPlay():void {
			
			isPlaying = false;
			switchPlay();
			
		}
		
		// toggles play/pause
		internal function switchPlay(event:MouseEvent = null):void {
			
			if(!isPlaying) {
				playMC.visible = false;
				pauseMC.visible = true;
				isPlaying = true;
			}
			else {
				pauseMC.visible = false;
				playMC.visible = true;
				isPlaying = false;
			}
			
			togglePlay(isPlaying);
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			playMC.removeEventListener(MouseEvent.ROLL_OVER, over);
			playMC.removeEventListener(MouseEvent.ROLL_OUT, out);
			playMC.removeEventListener(MouseEvent.CLICK, switchPlay);
			pauseMC.removeEventListener(MouseEvent.ROLL_OVER, over);
			pauseMC.removeEventListener(MouseEvent.ROLL_OUT, out);
			pauseMC.removeEventListener(MouseEvent.CLICK, switchPlay);
			
			playMC.removeChildAt(0);
			pauseMC.removeChildAt(0);
			
			removeChildAt(0);
			removeChildAt(0);
			
			togglePlay = null;
			
		}
		
    }
}








