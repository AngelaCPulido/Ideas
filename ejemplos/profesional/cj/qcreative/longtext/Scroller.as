package cj.qcreative.longtext {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class manages the scrollbar for the text field
    public final class Scroller {
		
		// begin private vars
		private static var stager:Object,
		pops:Object,
		holder:Sprite,
		mainText:*,
		masker:Masker,
		scroller:DragScroll,
		w:int,
		h:int,
		sh:int,
		stageH:int,
		distH:int,
		storeH:int,
		where:Number,
		go:Number,
		difY:Number,
		max:Number,
		usingBanner:Boolean,
		goDynamic:Boolean,
		runOnce:Boolean;
		// end private vars
		
		// sets up the scrollbar
		internal static function setup(obj:Object, sp:Object, ldr:Boolean, hld:Sprite, wid:int, high:int, total:int, dynam:Boolean):void {
			
			stager = obj;
			
			(ldr) ? usingBanner = true : usingBanner = false;
			
			pops = sp;
			mainText = hld;
			w = wid;
			h = high;
			storeH = total;
			goDynamic = dynam;
			runOnce = false;

			stageHeight();
			
			holder = new Sprite();
			holder.mouseEnabled = false;
			
			scroller = new DragScroll();
			scroller.buttonMode = true;
			scroller.x = w - 14;
			masker = new Masker(w, distH);
			
			holder.addChild(mainText);
			holder.addChild(scroller);
			holder.addChild(masker);
			
			(usingBanner) ? holder.y = h + 16 : holder.y = 0;
			
			pops.addChild(holder);
			
			sizer();
			
			stager.addEventListener(Event.RESIZE, stageHeight, false, 0, true);
			
		}
		
		// called on a stage resize
		internal static function stageHeight(event:Event = null):void {

			sh = stager.stageHeight;
			(usingBanner) ? distH = sh - h - 48 : distH = sh - 32;
			(runOnce) ? sizer() : runOnce = true;
			
		}
		
		internal static function pushSize():void {
			
			stager.addEventListener(Event.RESIZE, stageHeight, false, 0, true);
			stageHeight();
			
		}
		
		// checks to see if the scrollbar is needed
		private static function sizer():void {
			
			if(storeH > distH) {
				
				mainText.y = 0;
				mainText.mask = masker;
				masker.visible = true;
				
				scroller.visible = true;
				scroller.y = 0;
				
				mainText.txt.width = w - 28;
				
				if(goDynamic) {
					mainText.txtLeft.visible = false;
					mainText.txt.visible = true;
					mainText.txtLeft.mouseEnabled = false;
					mainText.txt.mouseEnabled = true;
					mainText.txtLeft.htmlText = "";
					mainText.txt.htmlText = pops.xString;
				}
				
				mainText.txt.height = mainText.txt.textHeight + 10;
				
				storeH = mainText.txt.height;
				storeH = storeH == int(storeH) ? storeH : int(storeH + 1);
				
				scroller.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown, false, 0, true);
				scroller.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				scroller.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				stager.addEventListener(MouseEvent.MOUSE_UP, thumbUp, false, 0, true); 
				stager.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
				
				max = (distH - scroller.height);

			}
			else {
				
				removeListeners();
				mainText.mask = null;
				masker.visible = false;
				scroller.visible = false;
				
				mainText.txt.width = w;
				
				if(goDynamic) {
					
					mainText.txtLeft.width = w;
					mainText.txt.visible = false;
					mainText.txtLeft.visible = true;
					mainText.txt.mouseEnabled = false;
					mainText.txtLeft.mouseEnabled = true;
					mainText.txt.htmlText = "";
					mainText.txtLeft.htmlText = pops.xString;
					
					mainText.txtLeft.height = mainText.txtLeft.textHeight + 10;
					
					storeH = mainText.txtLeft.height;
					storeH = storeH == int(storeH) ? storeH : int(storeH + 1);
					
				}
				else {
					
					mainText.txt.height = mainText.txt.textHeight + 10;
					
					storeH = mainText.txt.height;
					storeH = storeH == int(storeH) ? storeH : int(storeH + 1);
					
				}
				
			}

			masker.height = distH;
			mainText.visible = true;
			
		}
		
		// performs actual text field scrolling
		private static function scrollMe():void {
			
			if(scroller.y <= 0) {
				scroller.y = 0;
			}
			else if(scroller.y >= max) {
				scroller.y = max;
			}
					
			where = (scroller.y) / max;

			go = -where * (storeH - distH);
					
			TweenMax.to(mainText, 0.5, {y: go, ease:Quint.easeOut});
		
		}
		
		// mouse over event
		private static function over(event:MouseEvent):void {
			if(scroller.currentLabel != "paused") {
				scroller.gotoAndPlay("over");
			}
		}
		
		// mouse out event
		private static function out(event:MouseEvent):void {
			scroller.gotoAndPlay("out");
		}
		
		// thumb down, activates scrolling
		private static function thumbDown(event:MouseEvent):void {
			
			if(scroller.currentLabel != "paused") {
				scroller.stop();
				TweenMax.to(scroller, 0.25, {frame: 7});
			}
			scroller.removeEventListener(MouseEvent.ROLL_OUT, out);
			stager.addEventListener(MouseEvent.MOUSE_MOVE, thumbMove, false, 0, true);
			difY = holder.mouseY - scroller.y;
			
		}
		
		// thumb up, deactivates scrolling
		private static function thumbUp(event:MouseEvent):void {
			
			var obj:Object = scroller.getBounds(holder);
			
			if(holder.mouseX >= obj.x && holder.mouseX <= obj.x + 14 && holder.mouseY >= obj.y && holder.mouseY <= obj.y + 22) {
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
		
		// scroll event for the mouse wheel
		private static function onMouse(event:MouseEvent):void {
			
			scroller.y -= event.delta * 10;
			scrollMe();
			
		}
		
		// scrolls the scrollbar on mouse move
		private static function thumbMove(event:MouseEvent):void {
			
			scroller.y = holder.mouseY - difY;
			scrollMe();
			
		}
		
		// remove all event listeners
		private static function removeListeners():void {
			
			if(scroller != null) {
				scroller.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
				scroller.removeEventListener(MouseEvent.ROLL_OUT, out);
				scroller.removeEventListener(MouseEvent.ROLL_OVER, over);
			}
			if(stager != null) {
				stager.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);  
				stager.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
				stager.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			}
			if(mainText != null) {
				TweenMax.killTweensOf(mainText);
				mainText.y = 0;
			}
			
		}
		
		// GARBAGE COLLECTION
		internal static function kill():void {
			
			removeListeners();
			(stager != null) ? stager.removeEventListener(Event.RESIZE, stageHeight) : null;
			
			if(holder != null) {
				while(holder.numChildren) {
					holder.removeChildAt(0);
				}
				(pops != null) ? pops.removeChild(holder) : null;
			}
			
			if(mainText != null) {
				mainText.removeChildAt(0);
				(goDynamic) ? mainText.removeChildAt(0) : null;
			}
			if(scroller != null) {
				TweenMax.killTweensOf(scroller);
				scroller.stop();
				scroller.removeChildAt(0);
			}
			if(masker != null) {
				masker.removeChildAt(0);
				masker.square.graphics.clear();
			}
			
			mainText = null;
			scroller = null;
			masker = null;
			pops = null;
			stager = null;
			holder = null;
			
		}
		
    }
}








