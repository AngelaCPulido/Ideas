package cj.qcreative {
	
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class loads in the background images
    public final class Backgrounds {
		
		// begin private vars
		private static var bit1:Bitmap,
		bit2:Bitmap,
		bitW:Number,
		bitH:Number,
		scaler:Number,
		align:String,
		
		bMask1:Shape = new Shape(),
		bMask2:Shape = new Shape(),
		who:int = 1,
		firstLoad:Boolean = true;
		
		private static const blurBuffer:int = 50;
		// end private vars
		
		// begin internal vars
		internal static var loaderOpen:Boolean = false, loader:Loader;
		// end internal vars
		
		// just a performance enhancement
		internal static function noMouse():void {
			loader.mouseEnabled = false;
		}
		
		// called when a new background image is to be loaded in
		internal static function load(st:String, position:String):void {
			
			// we temporarily pause the music equalizer to improve performance
			Music.turnOff();
			
			killLoader();
			align = position;
			
			loader = new Loader();
			loader.mouseEnabled = false;
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Tracker.trackBack, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, Tracker.catchError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, Tracker.backDone, false, 0, true);
			loaderOpen = true;
			loader.load(new URLRequest(st));
			
		}
		
		// fixes a problem in Chrome and Opera when closing the browser
		private static function catchError(event:IOErrorEvent):void {}
		
		// fires when the background and module have both loaded in
		internal static function done():void {
			
			// finds which main container should be used
			switch(who) {
				
				case 1:
					
					bit1 = Bitmap(loader.content);
					bit1.smoothing = true;
					bitW = bit1.width;
					bitH = bit1.height;
					
					// if a previous background exists and should be wiped out
					if(!firstLoad) {
						TweenMax.to(bMask2, 1, {y: Tracker.stageH, ease: Quint.easeInOut, onCompleteParams: [2], onComplete: killBit});
					}
					else {
						firstLoad = false;
					}
					
					Tracker.template.addChildAt(bit1, 0);
					
					pos(bit1);
					
					bMask1.y = 0;
					
					// wipe in the new background image
					TweenMax.to(bMask1, 1, {scaleY: 1, ease: Quint.easeInOut, onComplete: turnMusic});
					
				break;
				
				case 2:
					
					bit2 = Bitmap(loader.content);
					bit2.smoothing = true;
					bitW = bit2.width;
					bitH = bit2.height;
					
					// wipe out the previous background image
					TweenMax.to(bMask1, 1, {y: Tracker.stageH, ease: Quint.easeInOut, onCompleteParams: [1], onComplete: killBit});
			
					Tracker.template.addChildAt(bit2, 0);
					
					pos(bit2);
					
					bMask2.y = 0;
					
					// wipe in the new background image
					TweenMax.to(bMask2, 1, {scaleY: 1, ease: Quint.easeInOut, onComplete: turnMusic});
					
				break;
				
			}
			
			loader = null;
			
			(who == 1) ? who = 2 : who = 1;
			
		}
		
		// checks which main container is active and performs scaling actions
		internal static function sizeBits():void {
			
			if(bit1 != null) {
				if(who == 2) {
					pos(bit1, true);
				}
				else {
					TweenMax.killTweensOf(bMask1);
					killBit(1);
				}
			}
			if(bit2 != null) {
				if(who == 1) {
					pos(bit2, true);
				}
				else {
					TweenMax.killTweensOf(bMask2);
					killBit(2);
				}
			}
		}
		
		// positions and scales the background image
		private static function pos(bit:Bitmap, reSize:Boolean = false):void {
			
			var bitID:int, mid:int, tw:int = Tracker.stageW, th:int = Tracker.stageH;
			
			// if main container #1 is active
			if(bit == bit1) {
				
				bMask1.graphics.clear();
				bMask1.graphics.beginFill(0x000000);
				bMask1.graphics.drawRect(0, 0, tw, th);
				bMask1.graphics.endFill();
				
				if(!reSize) {
					bMask1.scaleY = 0;
					bit.mask = bMask1;
					Tracker.template.addChildAt(bMask1, 0);
				}
				else {
					TweenMax.killTweensOf(bMask1);
					bMask1.scaleY = 1;
				}
				bitID = 0;
			}
			
			// if main container #2 is active
			else {
				
				bMask2.graphics.clear();
				bMask2.graphics.beginFill(0x000000);
				bMask2.graphics.drawRect(0, 0, tw, th);
				bMask2.graphics.endFill();
				
				if(!reSize) {
					bMask2.scaleY = 0;
					bit.mask = bMask2;
					Tracker.template.addChildAt(bMask2, 0);
				}
				else {
					TweenMax.killTweensOf(bMask2);
					bMask2.scaleY = 1;
				}
				bitID = 1;
			}
			
			var scaledX:Boolean = false, scaledY:Boolean = false;
			
			scaler = 1;
			bit.width = bitW;
			bit.height = bitH;
			
			// checks to see if image scaling is necessary
			if(tw >= th) {
				if(tw > bitW) {
					 scaler = tw / bitW;
					 scaledX = true;
				}
			}
			else {
				if(th > bitH) {
					scaler = th / bitH;
					scaledY = true;
				}
			}
			
			bit.width *= scaler;
			bit.height *= scaler;
			
			var ceilerX:Number;
			var ceilerY:Number;
			
			// positions the background image
			switch(align) {
				
				// top-left
				case "tl":
					bit.x = -blurBuffer;
					bit.y = -blurBuffer;
				break;
				
				// top-center
				case "tc":
					mid = (tw >> 1) - (bit.width >> 1)
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
					bit.x = mid;
					bit.y = -blurBuffer;
				break;
				
				// top-right
				case "tr":
					ceilerX = tw - bit.width;
					bit.x = ceilerX == int(ceilerX) ? ceilerX : int(ceilerX + 1);
					bit.y = -blurBuffer;
				break;
				
				// top-center
				case "lc":
					bit.x = -blurBuffer;
					mid = (th >> 1) - (bit.height >> 1);
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
					bit.y = mid;
				break;
				
				// middle-center
				case "mc":
					mid = (tw >> 1) - (bit.width >> 1);
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5); 
					bit.x = mid;
					mid = (th >> 1) - (bit.height >> 1);
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5); 
					bit.y = mid;
					
				break;
				
				// right center
				case "rc":
					ceilerX = tw - bit.width;
					bit.x = ceilerX == int(ceilerX) ? ceilerX : int(ceilerX + 1);
					mid = (th >> 1) - (bit.height >> 1);
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5); 
					bit.y = mid;
				break;
				
				// bottom-left
				case "bl":
					bit.x = -blurBuffer;
					ceilerY = Tracker.stageH - bit.height;
					bit.y = ceilerY == int(ceilerY) ? ceilerY : int(ceilerY + 1);
				break;
				
				// bottom-center
				case "bc":
					mid = (tw >> 1) - (bit.width >> 1);
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5); 
					bit.x = mid;
					ceilerY = th - bit.height;
					bit.y = ceilerY == int(ceilerY) ? ceilerY : int(ceilerY + 1);
				break;
				
				// bottom-right
				case "br":
				
					ceilerX = tw - bit.width;
					bit.x = ceilerX == int(ceilerX) ? ceilerX : int(ceilerX + 1);
					ceilerY = th - bit.height;
					bit.y = ceilerY == int(ceilerY) ? ceilerY : int(ceilerY + 1);
				break;
				
			}
			
			// adjust the image position if necessary for proper blur effect
			if(bit.x > -blurBuffer || bit.y > -blurBuffer) {
				
				bit.x = -blurBuffer;
				bit.y = -blurBuffer;
				
			}
			
			if(bit.width < tw + 100 || bit.height < th + 100) {

				bit.width += blurBuffer << 1;
				bit.height += blurBuffer << 1;
				
			}
			
			// pass the bitmap to the DrawBlur class
			DrawBlur.draw(bit, bitID, reSize);
			
			// create the new sub menu blurs
			CreateMenu.newSubs();
			
		}
		
		// kills the loader if a new one needs to be created and a current loader already exists
		private static function killLoader():void {
			
			if(loader != null) {
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, Tracker.trackBack);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, Tracker.backDone);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, Tracker.catchError);
				
				if(loaderOpen) {
					
					try {
						loader.close();
					}
					catch(event:Error){};
	
				}
				loader = null;
			}
			
			TweenMax.killTweensOf(bMask1, true);
			TweenMax.killTweensOf(bMask2, true);
		}
		
		// turns on the music equalizer after the wipe tween has completed
		private static function turnMusic():void {
			Music.turnOn();
		}
		
		// kills the previous background image when it is no longer needed
		private static function killBit(b:int):void {
			
			var bite:Bitmap, bMask:Shape;
			
			switch(b) {
				
				case 1:
					bite = bit1;
					bMask = bMask1;
				break;
				
				case 2:
					bite = bit2;
					bMask = bMask2;
				break;
				
			}
			
			bite.bitmapData.dispose();
			bMask.graphics.clear();
			
			(Tracker.template.contains(bMask)) ? Tracker.template.removeChild(bMask) : null;
			(Tracker.template.contains(bite)) ? Tracker.template.removeChild(bite) : null;
			
			bite = null;
			bMask = null;
		
		}
		
    }
}








