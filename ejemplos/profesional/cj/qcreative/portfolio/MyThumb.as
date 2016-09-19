package cj.qcreative.portfolio {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import cj.qcreative.videoplayer.SingleVideo;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class controls each loaded section item
    public class MyThumb extends Sprite {
		
		// begin private vars
		private var tClick:Function,
		shaper:Sprite,
		masker:Sprite,
		white:Sprite,
		w:int,
		h:int;
		// end private vars
		
		// begin internal vars
		internal var containsVid:Boolean,
		autoStart:Boolean,
		vid:SingleVideo,
		bit:Bitmap,
		id:int;
		// end internal vars
		
		// class contructor
		public function MyThumb(bite:Bitmap, i:int, myClick:Function, tw:int, th:int, hasVid:Boolean, startAuto:Boolean) {
			
			bit = bite;
			id = i;
			tClick = myClick;
			w = tw;
			h = th;
			containsVid = hasVid;
			autoStart = startAuto;
			
			shaper = buildShape(tw, th, 0x000000);
			shaper.alpha = 0.5;
			
			masker = buildShape(tw, th, 0x000000);
			this.mask = masker;
			
			masker.scaleX = 0;
			
			white = buildShape(w, h, 0xFFFFFF);
			white.alpha = 0;
			
			addChild(bit);
			addChild(shaper);
			addChild(masker);
			addChild(white);
			
			if(id != 1) {
				shaper.alpha = 0.7;
				TweenMax.to(masker, 0.5, {scaleX: 1, ease: Quint.easeOut});
			}
			else {
				shaper.alpha = 0;
				TweenMax.to(masker, 0.5, {scaleX: 1, ease: Quint.easeOut, onComplete: addListen});
			}
			
		}
		
		// firs when a new section is called
		internal function hide():void {
			
			kill();
			TweenMax.to(masker, 0.5, {scaleY: 0, ease: Quint.easeOut});
			
		}
		
		// tells the video player it is ready to show the control bar
		internal function showControls():void {
			
			vid.showControls(autoStart);
			
		}
		
		// adds mouse events
		private function addListen():void {
			addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			buttonMode = true;
		}
		
		// draws and returns a Sprite
		private function buildShape(tw:int, th:int, color:uint):Sprite {
			
			var sp:Sprite = new Sprite();
			sp.mouseEnabled = false;
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(0, 0, tw, th);
			sp.graphics.endFill();
			
			return sp;
			
		}
		
		// removes mouse events
		internal function removeClick(shapeOut:Boolean = false):void {
			
			removeEventListener(MouseEvent.CLICK, clicked);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			(!shapeOut) ? TweenMax.to(shaper, 0.5, {alpha: 0.7, ease: Quint.easeOut}) : null;
			this.buttonMode = false;
		
		}
		
		// mouse click event
		internal function clickOn():void {
			
			TweenMax.to(shaper, 0.5, {alpha: 0, ease: Quint.easeOut, onComplete: addRoll});
			this.buttonMode = true;
		
		}
		
		// adds mouse click
		internal function addClick(addListen:Boolean = false):void {
			
			addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			
		}
		
		// mouse over event
		private function over(event:MouseEvent):void {
			
			TweenMax.killTweensOf(white);
			white.alpha = 1;
			TweenMax.to(white, 0.75, {alpha: 0, ease: Quint.easeOut});
			
		}
		
		// adds mouse rollover event
		private function addRoll():void {
			
			addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			
		}
		
		// pauses the video
		internal function pauseVideo(i:int = undefined):void {
			
			if(vid != null) {
				vid.pauseAndHide();
			}
			
			if(id != i) {
				removeClick(true);
			}
			
		}
		
		// removes mouse evnts
		internal function kill():void {
			
			removeEventListener(MouseEvent.CLICK, clicked);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			tClick = null;
			
		}
		
		// mouse click event
		private function clicked(event:MouseEvent):void {
			
			removeEventListener(MouseEvent.CLICK, clicked);
			this.buttonMode = false;
			tClick(id);
			
		}
		
		// GARBAGE COLLECTION
		internal function finalKill():void {
			
			removeChild(bit);
			bit.bitmapData.dispose();
			bit = null;
			
			TweenMax.killTweensOf(shaper);
			removeChild(shaper);
			shaper.graphics.clear();
			shaper = null;
			
			TweenMax.killTweensOf(masker);
			removeChild(masker);
			masker.graphics.clear();
			masker = null;
			
			TweenMax.killTweensOf(white);
			white.graphics.clear();
			removeChild(white);
			white = null;
			
			vid = null;
			
		}
		
    }
}








