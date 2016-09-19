package cj.qcreative.news {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cj.qcreative.Tracker;
	import cj.qcreative.news.graphics.Masker;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class handles the scrolling an item's text field
    public final class Scroller extends Sprite {
		
		private var mainText:Sprite,
		stager:Object,
		masker:Masker,
		scroller:DragScroll,
		distH:int,
		storeH:int,
		bw:int,
		bh:int,
		where:Number,
		go:Number,
		difY:Number,
		max:Number;
		
		// class constructor
		public function Scroller(hld:Sprite, ww:int, hh:int):void {
			
			mainText = hld;
			bw = ww;
			bh = hh + 48;
			
			stager = NewsTracker.stager;
			
			scroller = new DragScroll();
			scroller.buttonMode = true;
			scroller.x = bw - 14;
			
			masker = new Masker(bw, 200);
			
			this.mouseEnabled = false;
			
			addChild(mainText);
			addChild(scroller);
			addChild(masker);
			
		}
		
		// activates the scrollbar
		internal function activate(total:int, newDist:int):void {
			
			storeH = total;
			distH = newDist;
			
			sizer();
			
		}
		
		// deactivates the scrollbar
		internal function deactivate():void {
			
			scroller.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
			scroller.removeEventListener(MouseEvent.ROLL_OVER, over);
			scroller.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			stager.removeEventListener(MouseEvent.MOUSE_UP, thumbUp); 
			stager.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			stager.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
			
			TweenMax.killTweensOf(mainText);

			mainText.y = 0;
			mainText.mask = null;
			masker.visible = false;
			scroller.visible = false;
			scroller.gotoAndStop(1);
			
		}
		
		// tests if the scrollbar is needed
		private function sizer():void {
			
			if(storeH > distH) {
				
				mainText.y = 0;
				mainText.mask = masker;
				masker.visible = true;
				
				scroller.visible = true;
				scroller.y = 0;
				
				scroller.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown, false, 0, true);
				scroller.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				scroller.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				stager.addEventListener(MouseEvent.MOUSE_UP, thumbUp, false, 0, true); 
				stager.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
				
				max = distH - scroller.height - 8;

			}
			else {
				
				deactivate();
				
			}

			masker.height = distH - 8;
			mainText.visible = true;
			
		}
		
		// performs actual scrolling
		private function scrollMe():void {
			
			if(scroller.y <= 0) {
				scroller.y = 0;
			}
			else if(scroller.y >= max) {
				scroller.y = max;
			}
					
			where = scroller.y / max;

			go = -where * (storeH - distH + 16);
					
			TweenMax.to(mainText, 0.5, {y: go, ease:Quint.easeOut});
		
		}
		
		// scroller mouse over
		private function over(event:MouseEvent):void {
			if(scroller.currentLabel != "paused") {
				scroller.gotoAndPlay("over");
			}
		}
		
		// scroller mouse out 
		private function out(event:MouseEvent):void {
			scroller.gotoAndPlay("out");
		}
		
		// scroll thumb down
		private function thumbDown(event:MouseEvent):void {
			
			if(scroller.currentLabel != "paused") {
				scroller.stop();
				TweenMax.to(scroller, 0.25, {frame: 7});
			}
			scroller.removeEventListener(MouseEvent.ROLL_OUT, out);
			stager.addEventListener(MouseEvent.MOUSE_MOVE, thumbMove, false, 0, true);
			difY = mouseY - scroller.y;
			
		}
		
		// scroll thumb up
		private function thumbUp(event:MouseEvent):void {
			
			var obj:Object = scroller.getBounds(this);
			
			if(mouseX >= obj.x && mouseX <= obj.x + 14 && mouseY >= obj.y && mouseY <= obj.y + 22) {
				if(scroller.currentLabel != "paused") {
					TweenMax.to(scroller, 0.25, {frame: 7});
				}
			}
			else {
				if(scroller.currentFrame != 1) {
					scroller.gotoAndPlay("out");
				}
			}
			
			scroller.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			stager.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
			
		}
		
		// mouse wheel scroll
		private function onMouse(event:MouseEvent):void {
			
			scroller.y -= event.delta * 10;
			scrollMe();
			
		}
		
		// tracks mouse movement
		private function thumbMove(event:MouseEvent):void {
			
			scroller.y = mouseY - difY;
			scrollMe();
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			scroller.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
			scroller.removeEventListener(MouseEvent.ROLL_OVER, over);
			scroller.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			stager.removeEventListener(MouseEvent.MOUSE_UP, thumbUp); 
			stager.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			stager.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
			
			TweenMax.killTweensOf(scroller);
			TweenMax.killTweensOf(mainText);
			
			scroller.stop();
			
			masker.kill();
			
			scroller.removeChildAt(0);
			
			removeChild(mainText);
			removeChild(scroller);
			removeChild(masker);
			
			stager = null;
			masker = null;
			scroller = null;
			mainText = null;
			
		}
		
    }
}








