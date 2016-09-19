package cj.qcreative.banner {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	// this class controls the masking animations and is also sub-classed
    public class CreateMasks extends Sprite {
		
		// begin private vars
		private const theDelay:Number = 0.15, time:int = 1;
		
		private var func:Function,
		fireNext:Function,
		moveNumber:Function,
		dump:Function,
		holder:Sprite,
		inHold:Sprite,
		ar:Array,
		runOnce:Boolean,
		tim:Timer,
		easer:Function;
		// end private vars
		
		// begin internal vars
		internal var fadingIn:Boolean;
		// end internal vars
		
		// class constructor
		public function CreateMasks(w:int, h:int, cb:Function, fnct:Function, hold:Sprite, dumper:Function, namer:String) {
			
			// store constructor values so we can access them later
			var wid:Number = ceiler(w / 6), s:Shape;
			func = cb;
			moveNumber = fnct;
			holder = hold;
			dump = dumper;
			this.name = namer;
			
			this.mouseEnabled = false;
			
			// create new instances
			inHold = new Sprite();
			ar = [];
			runOnce = true;
			tim = new Timer(500, 1);
			easer = Quad.easeInOut;
			fadingIn = false;
			
			inHold.mouseEnabled = false;
			
			// create the bars that will animate
			for(var i:int = 0; i < 6; i++) {
				
				s = new Shape();
				s.graphics.beginFill(0xFFFFFF);
				s.graphics.drawRect(0, 0, wid, h);
				s.graphics.endFill();
				
				s.x = i * wid;
				s.alpha = 0;
				ar[i] = s;
				inHold.addChild(s);
			}
			
			inHold.visible = false;
			inHold.cacheAsBitmap = true;
			
			holder.mask = inHold;
			
			BannerTracker.banner.addChildAt(inHold, 0);
			
		}
		
		// utility function for avoiding expensive Math.ceil() call
		private final function ceiler(i:Number):Number {
   			return i == int(i) ? i : int(i + 1);
		}
		
		// animate the bars in
		internal function fadeIn(bars:Boolean):void {
			
			tim.removeEventListener(TimerEvent.TIMER, resetTime);
			tim.stop();
			BannerTracker.slide1Working = true;
			
			fadingIn = true;
			moveNumber();
			holder.visible = true;
			
			// if individual bars are to be used
			if(bars) {
				
				var myDelay:Number = 0;
				
				for(var i:int = 0; i < 6; i++) {
					
					TweenMax.killTweensOf(ar[i]);
					ar[i].alpha = 0;
					if(i != 5) {
						TweenMax.to(ar[i], time, {alpha: 1, ease: easer, delay: myDelay});
					}
					else {
						TweenMax.to(ar[i], time, {alpha: 1, ease: easer, delay: myDelay, onComplete: inDone});
					}
					myDelay += theDelay;
				}
			}
			
			// if a smooth wipe effect is to be used
			else {
				
				for(var j:int = 0; j < 6; j++) {
					
					TweenMax.killTweensOf(ar[j]);
					ar[j].alpha = 0;
					if(j != 5) {
						TweenMax.to(ar[j], time, {alpha: 1, ease: easer});
					}
					else {
						TweenMax.to(ar[j], time, {alpha: 1, ease: easer, onComplete: inDone});
					}
					
				}
			}
			

		}
		
		// fade out the bars
		internal function fadeOut(bars:Boolean):void {
			
			tim.removeEventListener(TimerEvent.TIMER, resetTime);
			tim.stop();
			BannerTracker.slide1Working = true;
			
			holder.visible = true;
			
			var myDelay:Number = 0, i:int = 6;
			
			// tween each bar out
			while(i--) {
				
				TweenMax.killTweensOf(ar[i]);
				
				if(i != 0) {
					TweenMax.to(ar[i], time, {alpha: 0, ease: easer, delay: myDelay});
				}
				else {
					TweenMax.to(ar[i], time, {alpha: 0, ease: easer, delay: myDelay, onCompleteParams: [bars], onComplete: outDone});
				}
				myDelay += theDelay;
	
			}
		}
		
		// kill the Timer and let the banner know it is available for a new transition
		private final function resetTime(event:TimerEvent):void {
			tim.removeEventListener(TimerEvent.TIMER, resetTime);
			tim.stop();
			BannerTracker.slide1Working = false;
			func();
		}
		
		// fires when the current slide has faded out and the new slide is ready to animate in
		private final function outDone(bars:Boolean):void {
			
			holder.visible = false;
			
			if(this.name == "m1") {
				BannerTracker.masker2.fadeIn(bars);
			}
			else {
				BannerTracker.masker1.fadeIn(bars);
			}

		}
		
		// starts the Timer when the animation has finished
		private final function inDone():void {
			
			fadingIn = false;
			(!runOnce) ? dump() : runOnce = false;
			tim.addEventListener(TimerEvent.TIMER, resetTime, false, 0, true);
			tim.start();
			
		}
		
		// GARBAGE COLLECTION
		internal function finalKill():void {
			
			// kill the Timer
			tim.removeEventListener(TimerEvent.TIMER, resetTime);
			tim.stop();
			tim = null;
			
			var i:int = 6;
			
			// clean up the bars
			if(holder != null) {
				while(i--) {
					
					TweenMax.killTweensOf(ar[i]);
					inHold.removeChild(ar[i]);
					ar[i].graphics.clear();
					
				}
			}
			
			// set all vars to null
			inHold = null;
			holder = null;
			ar = null;
			func = null;
			fireNext = null;
			moveNumber = null;
			dump = null;
			easer = null;
				
		}
		
    }
}








