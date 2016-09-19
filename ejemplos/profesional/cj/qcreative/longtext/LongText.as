package cj.qcreative.longtext {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import cj.qcreative.Tracker;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this is the document class for the LongText
    public final class LongText extends Sprite {
		
		// begin private vars
		private var xLoader:URLLoader,
		xml:XML,
		loader:*,
		pre:MasterPre,
		shaper:Shape,
		glide:Shape,
		style:StyleSheet,
		styleURL:String,
		tAlign:String,
		cssLoader:URLLoader,
		useStyle:Boolean,
		usingBanner:Boolean,
		xOpen:Boolean,
		cssOpen:Boolean,
		bLoaded:Boolean,
		goDynamic:Boolean,
		loaderLoading:Boolean,
		isLoader:Boolean,
		tWidth:int,
		bHeight:int;
		// end private vars
		
		// begin internal vars
		internal var xString:String;
		// end internal vars
		
		// class constructor
		public function LongText() {
			
			addEventListener(Event.UNLOAD, killLongText, false, 0, true);
			
			// listen for the stage
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// fires when added to the stage
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, killLongText, false, 0, true);
			
			this.visible = false;
			this.mouseEnabled = false;
			var xString:String;
			cssOpen = false;
			bLoaded = false;
			goDynamic = false;
			isLoader = false;
			loaderLoading = false;
			
			if(Tracker.template != null) {
				xString = Tracker.textXML;
			}
			else {
				xString = "xml/about.xml";
			}
			
			xLoader = new URLLoader();
			xLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
			xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			xOpen = true;
			xLoader.load(new URLRequest(xString));
			
		}
		
		private function catchError(event:IOErrorEvent):void {}

		// loads the CSS file
		private function loadStyle():void {
			
			cssLoader = new URLLoader();
			cssLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			cssLoader.addEventListener(Event.COMPLETE, cssLoaded, false, 0, true);
			cssOpen = true;
			cssLoader.load(new URLRequest(styleURL));
			
		}
		
		// fires when the CSS file has loaded
		private function cssLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			style = new StyleSheet();
			style.parseCSS(event.target.data);
			
			if(Tracker.template) {
				Tracker.swfIsReady = true;
			}
			else {
				getSized();
			}
			
			cssOpen = false;
			cssLoader = null;
			
		}
		
		// cleans up the preloader
		private function preDone():void {
			
			pre.stop();
			removeChild(pre);
			pre = null;
			
			removeChild(glide);
			glide.graphics.clear();
			glide = null;
			
		}
		
		// tweens out the preloader
		internal function killPre():void {
			
			TweenMax.to(glide, 2, {alpha: 0, ease:Quint.easeOut, onComplete: preDone});
			TweenMax.to(pre, 1, {alpha: 0, ease:Quint.easeOut});
			
		}
		
		// called from the Q, sets up the module
		public function getSized():void {
			
			var mainText:*, totalHeight:Number, mH:int;
			
			switch(tAlign) {
				
				case "dynamic":
					
					goDynamic = true;
					mainText = new TextDynamic();
					
					(style != null) ? mainText.txtLeft.styleSheet = style : null;
					mainText.txtLeft.width = tWidth;
					mainText.txtLeft.mouseWheelEnabled = false;
					
				break;
				
				case "right":
				
					mainText = new TextRight();
				
				break;
				
				case "left":
				
					mainText = new TextLeft();
					
				break;
				
				case "justify":
				
					mainText = new TextJustify();
					
				break;
				
				case "center":
				
					mainText = new TextCenter();
				
				break;
				
			}
			
			mainText.txt.width = tWidth;
			(style != null) ? mainText.txt.styleSheet = style : null;
			mainText.txt.htmlText = xString;
			mainText.txt.mouseWheelEnabled = false;
			
			mainText.visible = false;
			mainText.mouseEnabled = false;
			
			totalHeight = mainText.txt.textHeight;
			totalHeight = totalHeight == int(totalHeight) ? totalHeight : int(totalHeight + 1);
			
			mainText.txt.height = mainText.txt.textHeight + 10;
			
			if(usingBanner) {
				
				mH = totalHeight + bHeight + 82;
				
				var bannerType:String = xml.settings.bannerType.toLowerCase();
				
				if(bannerType == "kenburns") {
				
					loader = new KenBurns(xml, tWidth, bHeight, killPre);
					bLoaded = true;
					
				}
				else {
				
					loader = new Loader();
					loader.alpha = 0;
					loader.mouseEnabled = false;
					loaderLoading = true;
					isLoader = true;
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, iLoaded, false, 0, true);
					loader.load(new URLRequest(xml.settings.imageSwfURL));
						
				}
				
				addChild(loader);
				
				glide = new Shape();
				glide.graphics.beginFill(0xFFFFFF, 0.5);
				glide.graphics.drawRect(0, 0, tWidth, bHeight);
				glide.graphics.endFill();
				addChild(glide);
				
				pre = new MasterPre();
				pre.mouseEnabled = false;
				pre.mouseChildren = false;
				pre.x = (((tWidth >> 1) + 0.5) | 0) - 35;
				pre.y = (((bHeight >> 1) + 0.5) | 0) - 3;
				addChild(pre);
				
			}
			else {
				mH = totalHeight + 64;
			}
			
			Tracker.moduleW = tWidth;
			Tracker.moduleH = mH;
			
			Scroller.setup(stage, this, usingBanner, mainText, tWidth, bHeight, totalHeight, goDynamic);
			
			shaper = new Shape();
			shaper.graphics.beginFill(0x000000);
			shaper.graphics.drawRect(0, 0, tWidth, mH);
			shaper.graphics.endFill();
			shaper.scaleX = 0;
			
			this.mask = shaper;
			this.visible = true;
			addChild(shaper);
			
			stage.addEventListener(Event.RESIZE, sizes, false, 0, true);
			TweenMax.to(shaper, 0.5, {scaleX: 1, ease:Quint.easeOut, onComplete: dumpShape});
			
			(Tracker.template) ? Tracker.template.posModule() : null;
			
		}
		
		private function iLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, iLoaded);
			loaderLoading = false;
			killPre();
			
			setChildIndex(loader, numChildren - 1);
			TweenMax.to(loader, 1, {alpha: 1, ease:Quint.easeOut});
			
		}
		
		// removes the stage listener
		public function removeSize():void {
			stage.removeEventListener(Event.RESIZE, sizes);
			stage.removeEventListener(Event.RESIZE, Scroller.stageHeight);
		}
		
		public function addSize(boo:Boolean):void {
			
			stage.addEventListener(Event.RESIZE, sizes, false, 0, true);
			
			sizes();
			Scroller.pushSize();
			
		}
		
		public function sizer():void {
			
			sizes();
			Scroller.stageHeight();
			
		}
		
		// stage resize function
		private function sizes(event:Event = null):void {
			TweenMax.killTweensOf(shaper, true);
		}
		
		// gets rid of the intial mask that animates the module in and is no longer necessary
		private function dumpShape():void {
			
			stage.removeEventListener(Event.RESIZE, sizes);
			
			shaper.graphics.clear();
			removeChild(shaper);
			shaper = null;
			
			this.mask = null;
			
		}
		
		// fires when the xml has loaded in
		private function xmlLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, xmlLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			xml = new XML(event.target.data);
			var useBanner:String;
			
			tWidth = int(xml.settings.textAndBannerWidth);
			
			xString = xml.text.text();
			
			useBanner = xml.settings.useBanner;
			
			(useBanner.toLowerCase() == "true") ? usingBanner = true : usingBanner = false;
			
			var useStylesheet:String = xml.settings.useStyleSheet;
			
			if(useStylesheet.toLowerCase() == "true") {
				useStyle = true;
				styleURL = xml.settings.styleSheetUrl;
			}
			else {
				useStyle = false;
			}
			
			tAlign = xml.settings.textAlign.toLowerCase();
			(tAlign == null || tAlign == "") ? tAlign = "dynamic" : null;
			
			(usingBanner) ? bHeight = int(xml.settings.bannerHeight) : null;
				
			if(useStyle && styleURL != null) {
				loadStyle();
			}
			else {
				if(Tracker.template) {
					Tracker.swfIsReady = true;
				}
				else {
					getSized();
				}
			}
			
			xOpen = false;
			xLoader = null;
			
		}
		
		// GARBAGE COLLECTION
		private function killLongText(event:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.UNLOAD, killLongText);
			removeEventListener(Event.REMOVED_FROM_STAGE, killLongText);
			stage.removeEventListener(Event.RESIZE, sizes);
			
			if(bLoaded) {
				loader.killKen();
				removeChild(loader);
				loader = null;
			}
			
			if(isLoader) {
				if(!loaderLoading) {
					
					TweenMax.killTweensOf(loader);
					
					if(loader.content is Bitmap) {
						BitmapData(Bitmap(loader.content).bitmapData).dispose();
					}
				}
				else {
					
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, iLoaded);
					
					try {
						loader.close();
					}
					catch(event:Error){};
				}
				removeChild(loader);
				loader = null;
			}
			
			if(pre != null) {
				
				TweenMax.killTweensOf(pre);
				pre.stop();
				removeChild(pre);
				pre = null;
				
			}
			
			if(xOpen) {
				xLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
				xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				try {
					xLoader.close();
				}
				catch(event:Error){};
				xLoader = null;
			}
			
			if(cssOpen) {
				cssLoader.removeEventListener(Event.COMPLETE, cssLoaded);
				cssLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				try {
					cssLoader.close();
				}
				catch(event:Error){};
				cssLoader = null;
			}
			
			if(glide != null) {
				
				TweenMax.killTweensOf(glide);
				removeChild(glide);
				glide.graphics.clear();
				glide = null;
			}
			
			if(shaper != null) {
				
				if(TweenMax.isTweening(shaper)) {
					TweenMax.killTweensOf(shaper);
				}
				shaper.graphics.clear();
				(this.contains(shaper)) ? removeChild(shaper) : null;
				shaper = null;
				
			}
			
			xml = null;
			style = null;
			Scroller.kill();
			
		}
		
    }
}








