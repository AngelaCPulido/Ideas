package cj.qcreative.longtext {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Linear;
	
	// this class creates the KenBurns slideshow
    public final class KenBurns extends Sprite {
		
		// begin private vars
		private var imageList:XMLList,
		loader1:Loader,
		loader2:Loader,
		shaper:Shape,
		mask1:Shape,
		mask2:Shape,
		border:Shape,
		maskBack:Shape,
		shader:Sprite,
		tick:Timer,
		w:int,
		h:int,
		borderSize:int,
		fadeTime:int,
		isOn:int,
		imageLength:int,
		speed:Number,
		tweenSpeed:Number,
		halfBorder:Number,
		goRandom:Boolean,
		loader1Open:Boolean,
		loader2Open:Boolean,
		loader1Loaded:Boolean,
		loader2Loaded:Boolean,
		masksAdded:Boolean,
		odd:Boolean,
		randomAlign:Array,
		easing:Function,
		kicker:Function,
		xml:XML;
		// end private vars
		
		// class constructor
		public function KenBurns(xmlBanner:XML, ww:int, hh:int, killPre) {
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			xml = xmlBanner;
			w = ww;
			h = hh;
			kicker = killPre;
			masksAdded = false;
			loader1Open = false;
			loader2Open = false;
			loader1Loaded = false;
			loader2Loaded = false;
			odd = true;
			
			imageList = xml.image;
			imageLength = imageList.length() - 1;
			tweenSpeed = Number(xml.bannerSettings.speed);
			speed = tweenSpeed * 1000;
			
			var ran:String = xml.bannerSettings.randomTransitions, useFilter:String = xml.bannerSettings.useOverlay;
			
			(ran.toLowerCase() == "true") ? goRandom = true : goRandom = false;
			
			randomAlign = ["tl", "tc", "tr", "lc", "mc", "rc", "bl", "bc", "br"];
			
			borderSize = int(xml.bannerSettings.borderSize);
			halfBorder = borderSize >> 1;
			
			if(borderSize != 0) {
				
				var bc:String = xml.bannerSettings.borderColor, hex:String, borderColor:uint;
				
				if(bc.charAt(0) == "#") {
					hex = bc.split("#").join("0x");
				}
				else if(bc.charAt(1) == "x") {
					hex = bc;
				}
				else {
					hex = "0x" + bc;
				}
				
				borderColor = uint(hex);
				
				addBorder(borderColor);
				
			}
			
			else {
				
				addBG();
				
			}
			
			addMasks();

			if(useFilter.toLowerCase() == "true") {
				addShader();
				fadeTime = 1;
				easing = Quint.easeOut;
			}
			else {
				fadeTime = 2;
				easing = Linear.easeNone;
			}
			
			isOn = 0;
			loadNew(0);
			
			xml = null;
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// adds the background if used
		private function addBG():void {
			
			shaper = new Shape();
			shaper.graphics.beginFill(0xFFFFFF, 0.5);
			shaper.graphics.drawRect(0, 0, w, h);
			shaper.graphics.endFill();
			addChild(shaper);
			
		}
		
		// adds the border if used
		private function addBorder(color:uint):void {
			
			border = new Shape();
			border.graphics.beginFill(color);
			border.graphics.drawRect(0, 0, w, h);
			border.graphics.endFill();
			border.alpha = 0;
			addChild(border);
			
		}
		
		// kills the previous loader when it is no longer needed
		private function killLoader(i:int = 0):void {
			
			var bit:Bitmap;
			
			if(i == 1) {
				loader2Loaded = false;
				mask2.visible = false
				bit = Bitmap(loader2.content);
				bit.bitmapData.dispose();
				loader2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
				loader2.unload();
				loader2 = null;

			}
			else {
				loader1Loaded = false;
				mask1.visible = false;
				bit = Bitmap(loader1.content);
				bit.bitmapData.dispose();
				loader1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				loader1.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
				loader1.unload();
				loader1 = null;
				
			}
			
			if(shaper != null) {
				shaper.graphics.clear();
				(this.contains(shaper)) ? removeChild(shaper) : null;
				shaper = null;
			}
			
		}
		
		// scales the image down
		private function scaleDown(loader:Loader, wid:int):void {
			
			var scaler:Number = w / wid;
			
			loader.width *= scaler;
			loader.height *= scaler;
			
		}
		
		// kills the preloader
		private function killTick():void {
			
			tick.removeEventListener(TimerEvent.TIMER, ticked);
			tick.stop();
			tick = null;
			
		}
		
		// loads in a new image
		private function loadNew(i:int):void {
			
			if(i == 0) {
				loader1 = new Loader();
				loader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				loader1.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
				loader1Open = true;
				loader1.load(new URLRequest(imageList[isOn].url));
			}
			else {
				loader2 = new Loader();
				loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
				loader2Open = true;
				loader2.load(new URLRequest(imageList[isOn].url));
			}
			
		}
		
		// fires the Timer event
		private function ticked(event:TimerEvent):void {
			
			killTick();
			
			(isOn != imageLength) ? isOn++ : isOn = 0;
			
			var num:int;
			
			if(odd) {
				odd = false;
				num = 1;
			}
			else {
				odd = true;
				num = 0;
			}
			
			loadNew(num);
			
		}
		
		// starts the Timer
		private function startTick():void {
			tick = new Timer(speed - 2000, 1);
			tick.addEventListener(TimerEvent.TIMER, ticked, false, 0, true);
			tick.start();
		}
		
		// checks to see how the image should be animated
		private function checkAlign(iWidth:int, iHeight:int, str:String):Array {
			
			var x:int = borderSize, y:int = borderSize, ar:Array;
			
			switch(str) {
				
				
				case "tc":
				
					x = (w >> 1) - (iWidth >> 1) + halfBorder;
				
				break;
				
				
				case "tr":
				
					x = -(iWidth - w) + halfBorder;
				
				break;
				
				
				case "lc":
				
					y = (h >> 1) - (iHeight >> 1) + halfBorder;
				
				break;
				
				
				case "mc":
					
					x = ((w >> 1) - (iWidth >> 1)) + halfBorder;
					y = ((h >> 1) - (iHeight >> 1)) + halfBorder;
					
					
				break;
				
				
				case "rc":
					
					x = -(iWidth - w) + halfBorder;
					y = (h >> 1) - (iHeight >> 1) + halfBorder;
					
				break;
				
				
				case "bl":
				
					y = -(iHeight - h) + halfBorder;
				
				break;
				
				
				case "bc":
					
					x = (w >> 1) - (iWidth >> 1) + halfBorder;
					y = -(iHeight - h) + halfBorder;
				
				break;
				
				
				case "br":
				
					x = -(iWidth - w) + halfBorder;
					y = -(iHeight - h) + halfBorder;
				
				break;
				
			}
			
			ar = [x, y];
			
			return ar;
			
		}
		
		// returns a random alignment
		private function randomize():String {
			
			var st:String;
			
			var mid:int = Math.random() * 9;
			mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5); 
			st = randomAlign[mid];

			return st;
			
		}
		
		// returns a random direction
		private function randomDirect():String {
			
			var rnd:int = Math.random() * 2, st:String;
			rnd = (rnd > 0) ? int(rnd + 0.5) : int(rnd - 0.5); 
			
			(rnd == 1) ? st = "in" : st = "out";
			
			return st;
			
		}
		
		// adds the image masks
		private function addMasks():void {
			
			mask1 = new Shape();
			mask1.visible = false;
			
			mask2 = new Shape();
			mask2.visible = false;
			
			maskBack = new Shape();
			maskBack.alpha = 0;
			
			var tempMask:Shape, i:int = 3;
			
			while(i--) {
				
				switch(i) {
					
					case 2:
						tempMask = maskBack;
					break;
					
					case 1:
						tempMask = mask1;
					break;
					
					case 0:
						tempMask = mask2;
					break;
					
				}
				
				tempMask.graphics.beginFill(0xFFFFFF);
				tempMask.graphics.drawRect(0, 0, w - (borderSize * 2), h - (borderSize * 2));
				tempMask.graphics.endFill();
				tempMask.x = borderSize;
				tempMask.y = borderSize;
				addChild(tempMask);

			}
			
			masksAdded = true;
			
		}
		
		// adds the overlay object
		private function addShader():void {
			
			shader = new Sprite();
			shader.x = borderSize;
			shader.y = borderSize;
			shader.graphics.beginFill(0xFFFFFF);
			shader.graphics.drawRect(0, 0, w - borderSize, h - borderSize);
			shader.graphics.endFill();
			shader.alpha = 0;
			shader.blendMode = BlendMode.OVERLAY;
			addChild(shader);
			
		}
		
		// tweens the alpha up 
		private function alphaUp(event:Event):void {
			
			if(event.target.alpha < 1) {
				event.target.alpha += 0.03;
			}
			else {
				event.target.removeEventListener(Event.ENTER_FRAME, alphaUp);
				event.target.alpha = 1;
			}
			
		}
		
		// fires when an image has loaded
		private function imageLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, imageLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var loader:Loader = event.target.loader, count:int;
			loader.alpha = 0;
			
			var myLoader1:Boolean;
			
			if(loader == loader1) {
				myLoader1 = true;
				loader1Open = false;
				loader1Loaded = true;
			}
			else {
				myLoader1 = false;
				loader2Open = false;
				loader2Loaded = true;
			}
			
			event.target.content.smoothing = true;
			
			if(imageList[isOn].static.toLowerCase() == "false") {
				
				var iWidth:int = loader.width, iHeight:int = loader.height, st:String = "", en:String = "", direc:String;
				
				if(!goRandom) {
					st = imageList[isOn].start.toLowerCase();
					en = imageList[isOn].end.toLowerCase();
					direc = imageList[isOn].direction.toLowerCase();

					if(direc != "in" && direc != "out") {
						throw new Error("invalid direction for KenBurns item");
					}
					
					var i:int = 9;
					var passed1:Boolean = false;
					var passed2:Boolean = false;
					
					while(i--) {
						if(st == randomAlign[i]) {
							passed1 = true;
							break;
						}
					}
					
					if(!passed1) {
						throw new Error("Invalid start position for KenBurns item");
					}
					
					i = 9;
					
					while(i--) {
						if(en == randomAlign[i]) {
							passed2 = true;
							break;
						}
					}
					
					if(!passed2) {
						throw new Error("Invalid end position for KenBurns item");
					}
					
				}
				else {
					while(st == en || st == null || en == null) {
						st = randomize();
						en = randomize();
					}
					direc = randomDirect();
				}
				
				if(direc == "in") {
						
					var ar:Array = checkAlign(iWidth, iHeight, st), scale:Number;
					loader.x = ar[0];
					loader.y = ar[1];

					scale = (w / iWidth);
						
					TweenMax.to(loader, tweenSpeed, {width: iWidth * scale, height: iHeight * scale, x: 0, y: 0, ease: Linear.easeNone});
						
				}
				else {
					var finish:Array = checkAlign(iWidth, iHeight, en);
					loader.x = borderSize;
					loader.y = borderSize;
					scaleDown(loader, iWidth);
					TweenMax.to(loader, tweenSpeed, {width: iWidth, height: iHeight, x: finish[0], y: finish[1], ease: Linear.easeNone});
				}
					
				loader.addEventListener(Event.ENTER_FRAME, alphaUp, false, 0, true);
				startTick();
				
			}
			else {
				TweenMax.to(loader, fadeTime, {alpha: 1, ease: easing, onComplete: startTick});
			}
			
			count = 1;
			
			(border != null) ? count++ : null;
			
			(shader != null) ? count++ : null;
			
			addChildAt(loader, count);
			
			if(myLoader1) {
				
				loader.mask = mask1;
				mask1.visible = true;
				
				if(loader2Loaded) {
					TweenMax.to(loader2, fadeTime, {alpha: 0, ease: easing, onCompleteParams: [1], onComplete: killLoader});
				}
				
			}
			else {
				
				loader2Open = false;
				loader2Loaded = true;
				
				loader.mask = mask2;
				mask2.visible = true;
				
				TweenMax.to(loader1, fadeTime, {alpha: 0, ease: easing, onComplete: killLoader});
				
			}
			
			if(shader != null) {
				
				setChildIndex(shader, numChildren - 1);
				shader.alpha = 1;
				TweenMax.to(shader, 2, {alpha: 0, ease: Linear.easeNone});
			}
			
			if(kicker != null) {
				
				kicker();
				kicker = null;

				if(maskBack != null && maskBack.alpha != 1) {
					TweenMax.to(maskBack, 2, {alpha: 1, ease: Linear.easeNone});
				}
				
				if(border != null) {
					TweenMax.to(border, 2, {alpha: 1, ease: Linear.easeNone});
				}
			
			}
			
		}
		
		// GARBAGE COLLECTION
		internal function killKen():void {
			
			(tick != null) ? killTick() : null;
			
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			if(loader1 != null) {
				
				TweenMax.killTweensOf(loader1);
				loader1.removeEventListener(Event.ENTER_FRAME, alphaUp);
				loader1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				loader1.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
				
				if(loader1Loaded && loader1.content) {
					BitmapData(Bitmap(loader1.content).bitmapData).dispose();
					loader1.unload();
				}
				else if(loader1Open) {
					try {
						loader1.close();
					}
					catch(event:Error){};
				}
				
				loader1 = null;
			}
			
			if(loader2 != null) {
				TweenMax.killTweensOf(loader2);
				loader2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
				loader2.removeEventListener(Event.ENTER_FRAME, alphaUp);
				
				if(loader2Loaded && loader2.content) {
					BitmapData(Bitmap(loader2.content).bitmapData).dispose();
					loader2.unload();
				}
				else if(loader2Open) {
					try {
						loader2.close();
					}
					catch(event:Error){};
				}
				
				loader2 = null;
			}
			
			if(masksAdded) {
				mask1.graphics.clear();
				mask2.graphics.clear();
				mask1 = null;
				mask2 = null;
			}
			
			if(shader != null) {
				TweenMax.killTweensOf(shader);
				shader.graphics.clear();
				shader = null;
			}			
			
			if(border != null) {
				TweenMax.killTweensOf(border);
				border.graphics.clear();
				border = null;
			}
			
			if(maskBack != null) {
				TweenMax.killTweensOf(maskBack);
				maskBack.graphics.clear();
				maskBack = null;
			}
			
			if(shaper != null) {
				shaper.graphics.clear();
				(this.contains(shaper)) ? removeChild(shaper) : null;
				shaper = null;
			}
			
			easing = null;
			xml = null;
			imageList = null;
			kicker = null;
			randomAlign = null;
			
		}
		
    }
}








