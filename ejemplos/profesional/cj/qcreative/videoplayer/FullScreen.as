package cj.qcreative.videoplayer {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// this class controls the full screen buttons
    public final class FullScreen extends Sprite {
		
		// begin private vars
		private var kickBack:Function;
		// end private vars
		
		// class constructor
		public function FullScreen(kb:Function) {
			
			this.mouseEnabled = false;
			
			kickBack = kb;
			
			ns.visible = false;
			
			fs.buttonMode = true;
			ns.buttonMode = true;
			
			fs.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			fs.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
			ns.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			ns.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
			fs.addEventListener(MouseEvent.CLICK, goFull, false, 0, true);
			ns.addEventListener(MouseEvent.CLICK, goNormal, false, 0, true);
			
		}
		
		// mouse over event
		private function over(event:MouseEvent):void {
			event.currentTarget.gotoAndStop(2);
		}
		
		// mouse out event
		private function out(event:MouseEvent):void {
			event.currentTarget.gotoAndStop(1);
		}
		
		// full screen event
		private function goFull(event:MouseEvent):void {
			fs.visible = false;
			ns.visible = true;
			kickBack(true);
		}
		
		// normal screen event
		internal function goNormal(event:MouseEvent = null):void {
			ns.visible = false;
			fs.visible = true;
			kickBack();
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			fs.removeEventListener(MouseEvent.ROLL_OVER, over);
			fs.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			ns.removeEventListener(MouseEvent.ROLL_OVER, over);
			ns.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			fs.removeEventListener(MouseEvent.CLICK, goFull);
			ns.removeEventListener(MouseEvent.CLICK, goNormal);
			
			fs.removeChildAt(0);
			ns.removeChildAt(0);
			
			removeChild(fs);
			removeChild(ns);

			kickBack = null;
			
		}
		
    }
}








