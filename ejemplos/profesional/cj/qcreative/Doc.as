package cj.qcreative {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.FullScreenEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import cj.qcreative.utils.FetchXML;
	import cj.qcreative.utils.MyEvent;
	import cj.qcreative.graphics.Container2;
	import com.greensock.TweenMax;
	import com.greensock.OverwriteManager;
	import com.greensock.easing.FastEase;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Quad;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	// This is the document class for the template swf
    public final class Doc extends Sprite {
		
		// start private vars
		private var xBack:XMLList,
		xAlign:XMLList,
		xList:XMLList,
		xTitle:XMLList,
		xURL:XMLList,
		xModule:XMLList,
		mList:XMLList,
		iconX:XMLList,
		copyright:XMLList,
		moduleSt:String,
		modPos:String,
		page:String,
		webName:String,
		useMusic:String,
		pageLength:int,
		item:int,
		theModule:int,
		theSub:int,
		moduleIndex:int,
		xMod:int,
		yMod:int,
		xMask:int,
		xWidth:int,
		xHeight:int,
		logoY:int,
		colorStart:uint,
		colorEnd:uint,
		mBuffer:Number,
		mVolume:Number,
		runOnce:Boolean,
		clicked:Boolean,
		goDraw:Boolean,
		tweenLogo:Boolean,
		isReady:Boolean,
		myFirst:Boolean,
		hasOne:Boolean,
		useColor:Boolean,
		usePattern:Boolean,
		gradDirect:Boolean,
		patReady:Boolean,
		moduleMask:Sprite,
		msk:Sprite,
		mm1:Shape,
		mm2:Shape,
		msk1:Shape,
		msk2:Shape,
		msk22:Shape,
		msk3:Shape,
		menuGloss:Shape,
		bitData:BitmapData,
		logo:Loader;
		// end private vars
		
		// start internal vars
		internal var speaker:Sprite, modulePre:ModulePre, dontLoad:Boolean, moduleOpen:Boolean, module:Loader, moduleReady:Boolean, moduleType:String;
		// end internal vars
		
		// class constructor
		public function Doc() {
				
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// fires when swf has been added to the stage
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.mouseEnabled = false;
			runOnce = true;
			clicked = false;
			isReady = false;
			hasOne = false;
			patReady = false;
			tweenLogo = true;
			myFirst = true;
			Tracker.template = this;
			theSub = 999;
			
			// activate TweenMax classes
			FastEase.activate([Linear, Quint, Quad]);
			OverwriteManager.init(OverwriteManager.ALL_IMMEDIATE); 
			
			// add SWFAddress main event listener
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, SWFHandler, false, 0, true);
			
		}
		
		// stage resize function
		private function sizer(event:Event = null):void {
			
			var sw:Number = stage.stageWidth;
			var sh:Number = stage.stageHeight;
			
			// store the stage properties globally
			Tracker.stageW = sw;
			Tracker.stageH = sh;
			
			var sh2:Number = ceiler(sh >> 1), twoFifty:Number = sw - 250;
			
			// kill any running tweens
			TweenMax.killTweensOf(mm1);
			TweenMax.killTweensOf(mm2);
			TweenMax.killTweensOf(msk2);
			TweenMax.killTweensOf(msk22);
			TweenMax.killTweensOf(msk3);
			TweenMax.killTweensOf(modulePre, true);
			
			mm1.scaleY = mm2.scaleY = msk2.scaleY = msk22.scaleY = 1;
			
			// below we redraw and reposition the the masks
			drawShape(mm1, twoFifty, sh2);
			
			mm1.x = twoFifty;
			mm1.y = sh2;
			
			drawShape(mm2, twoFifty, sh2 + 1);
			mm2.y = sh2;
			
			drawShape(msk1, 250, sh);
			drawShape(msk2, twoFifty, sh2);
			drawShape(msk22, twoFifty, sh2 + 1);
			drawShape(msk3, 177, 119);
			
			msk2.x = sw;
			msk2.y = msk22.y = sh2;
			msk3.y = sh2 - 59.5;
			
			if(!Tracker.isLoading) {
				modulePre.x = sw + 10;
				msk3.x = sw;
			}
			else {
				modulePre.x = sw - 167; 
				msk3.x = sw - 177;
			}
			
			modulePre.y = sh2 - 4;
			
			// position menu and music icon
			CreateMenu.position();
			Music.sizeSpeaker();
			
			// if a module is available for positioning
			if(Tracker.moduleLoaded) {
				(Tracker.newsOn) ? DrawBlur.storeNews() : null;
				Backgrounds.sizeBits();
				posModule(null, Tracker.contactOn, Tracker.galleryOn, Tracker.portOn, Tracker.newsOn, true);
			}
			else if(hasOne) {
				Backgrounds.sizeBits();
			}
			
			if(useColor) {
				drawColor();
			}
			else if(usePattern && patReady) {
				drawPattern();
			}
			
		}
		
		private function drawPattern():void {
			
			menuGloss.graphics.clear();
			menuGloss.graphics.beginBitmapFill(bitData);
			menuGloss.graphics.drawRect(0, 0, 250, stage.stageHeight);
			menuGloss.graphics.endFill();
			
		}
		
		private function patternLoaded(event:Event):void {
			
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			event.target.removeEventListener(Event.COMPLETE, patternLoaded);
			
			var bit:Bitmap = Bitmap(event.target.content);
			bitData = bit.bitmapData;
			drawPattern();
			
			patReady = true;
			
		}
		
		private function drawColor():void {
			
			var d:Number;
			
			if(gradDirect) {
				d = Math.PI * 0.5;
			}
			else {
				d = 0;
			}
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(250, stage.stageHeight, d, 0, 0);
			menuGloss.graphics.clear();
			menuGloss.graphics.beginGradientFill(GradientType.LINEAR, [colorStart, colorEnd], [1, 1], [0, 255], matrix, SpreadMethod.PAD);
			menuGloss.graphics.drawRect(0, 0, 250, stage.stageHeight);
			menuGloss.graphics.endFill();
			
		}
		
		// recieve xml data (config and menu)
		private function cb(xml:XML, xml2:XML):void {
			
			webName = xml.websiteName;
			
			// write xml lists
			xList = xml2.page;
			pageLength = xList.length();
			
			xBack = xList.bgURL;
			xAlign = xList.bgAlign;
			
			xTitle = xList.menuTitle;
			xURL = xList.deepLinkURL;
			
			xModule = xList.module;
			moduleSt = xList.moduleXML;
			
			// store blur properties
			Tracker.xBlur = int(xml.menuBlur.x);
			Tracker.yBlur = int(xml.menuBlur.y);
			Tracker.blurQuality = int(xml.menuBlur.quality);
			
			// if music is used
			useMusic = xml.music.attribute("useMusic");
			mList = xml.music.song;
			mBuffer = Number(xml.music.attribute("buffer")) * .01;
			mVolume = Number(xml.music.attribute("volume")) * .01;
			
			if(xml.menu.attribute("useColor").toLowerCase() == "true") {
				
				menuGloss = new Shape();
				
				useColor = true;
				
				var st:String = xml.menu.colorStart;
				var st2:String = xml.menu.colorEnd;
				
				if(st.charAt(0) == "#") {
					st = st.substr(1, 7);
				}
				
				if(st2.charAt(0) == "#") {
					st2 = st2.substr(1, 7);
				}
				
				st = "0x" + st;
				st2 = "0x" + st2;
				
				colorStart = uint(st);
				colorEnd = uint(st2);
				
				if(xml.menu.direction == "vertical") {
					gradDirect = true;
				}
				else {
					gradDirect = false;
				}
				
				drawColor();
				
				menuGloss.scaleY = 0;
				
				addChild(menuGloss);
				
			}
			else if(xml.menu.attribute("usePattern").toLowerCase() == "true") {
				
				menuGloss = new Shape();
				
				usePattern = true;
				
				var patternLoader:Loader = new Loader();
				patternLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				patternLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, patternLoaded, false, 0, true);
				patternLoader.load(new URLRequest(xml.menu.patternURL));
				
				menuGloss.scaleY = 0;
				
				addChild(menuGloss);
				
			}
			else {
				useColor = false;
				usePattern = false;
			}
			
			iconX = xml.theIcons;
			copyright = xml.copyright;
			
			// load in the logo
			logo = new Loader();
			logo.x = xml.logo.x;
			logoY = xml.logo.y;
			logo.contentLoaderInfo.addEventListener(Event.COMPLETE, logoDone, false, 0, true);
			logo.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			logo.load(new URLRequest(xml.logo.url));
			
		}
		
		// start up the music
		private function startMusic():void {
			
			var iMusic:Boolean;
			
			if(useMusic.toLowerCase() == "true") {
				iMusic = true;
			}
			else {
				iMusic = false;
			}
			
			if(iconX.attribute("useIcons").toLowerCase() == "true") {
				Music.storeXML(iconX, iMusic);
			}
			iconX = null;
			
			if(copyright.attribute("useCopyright").toLowerCase() == "true") {
				Music.addCopy(copyright.text);
			}
			copyright = null;
			
			if(iMusic) {
				Music.setup(mList, mBuffer, mVolume);
				mList = null;
			}
			
		}
		
		// fires when the module preloader has been added
		private function preAdded():void {
			
			TweenMax.killTweensOf(mm1);					   
			TweenMax.killTweensOf(mm2);
			TweenMax.killTweensOf(msk2);
			TweenMax.killTweensOf(msk22);
			
			mm1.scaleY = mm2.scaleY = msk2.scaleY = msk22.scaleY = 1;
			
			Tracker.startListen();
			DrawBlur.killModule(true);
			killModule();
			Backgrounds.load(Tracker.myPage, Tracker.myAlign);
			loadModule();
		}
		
		// utility function to draw a shape
		private function drawShape(sh:Shape, w:int, h:int):void {
			
			sh.graphics.clear();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, w, h);
			sh.graphics.endFill();
			
		}
		
		// just a utility function which is faster than Math.ceil()
		private static function ceiler(i:Number):Number {
   			return i == int(i) ? i : int(i + 1);
		}
		
		// fires when the logo has finished loading
		private function logoDone(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, logoDone);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			runOnce = false;
			
			var sw:int = stage.stageWidth, sh:int = stage.stageHeight;
			
			Tracker.stageW = sw;
			Tracker.stageH = sh;
			
			// add the logo to the stage
			logo.y = -(logo.height + 5);
			addChild(logo);
			
			// add custom event listener
			addEventListener(MyEvent.POS_MODULE, posModule, false, 0, true);
			
			// create the menu
			CreateMenu.make(xTitle, xURL, xList, checkModule, webName);
			
			// create the module mask below
			moduleMask = new Sprite();
			moduleMask.mouseEnabled = false;
			moduleMask.x = 250;
			
			var sh2:Number = ceiler(sh >> 1);
			var twoFifty:Number = sw - 250;
			
			mm1 = new Shape();
			drawShape(mm1, twoFifty, sh2);
			mm1.rotation = 180;
			mm1.x = twoFifty;
			mm1.y = sh2;
			
			mm2 = new Shape();
			drawShape(mm2, twoFifty, sh2 + 1);
			mm2.y = sh2;
			
			moduleMask.addChild(mm1);
			moduleMask.addChild(mm2);
			
			// create the module loader
			module = new Loader();
			module.mouseEnabled = false;
			module.mask = moduleMask;
			moduleReady = false;
			
			// create the module preloader
			modulePre = new ModulePre();
			modulePre.x = sw + 20;
			modulePre.y = sh2 - 4;
			
			msk1 = new Shape();
			drawShape(msk1, 250, sh);
			
			msk2 = new Shape();
			drawShape(msk2, twoFifty, sh2);
			
			msk22 = new Shape();
			drawShape(msk22, twoFifty, sh2 + 1);
			
			msk3 = new Shape();
			drawShape(msk3, 177, 119);
			
			msk2.rotation = 180;
			msk2.x = sw;
			msk22.x = 250;
			msk2.y = msk22.y = sh2;
			msk3.x = sw;
			msk3.y = sh2 - 59.5;
			
			// create the blur mask
			msk = new Sprite();
			msk.addChild(msk1);
			msk.addChild(msk2);
			msk.addChild(msk22);
			msk.addChild(msk3);
			addChild(msk);
			
			DrawBlur.setupMaster(this, msk);
			
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			
			// if the page loaded is the home page
			if(page == "/") {
				
				myFirst = false;
				Tracker.urlPage = xURL[0];
				CreateMenu.checkItem(0, true, true);
				Tracker.startListen(true);
				Backgrounds.load(xBack[0], xAlign[0]);
				loadModule();
				
			}
			// if we need to find what page should be loaded
			else {
				
				var boo:Boolean = checkMain(true);
				
				(!boo) ? checkSub(true, true) : null;
			}
		}
		
		// returns the x and y positions for each module
		private function calculateCenter(wid:Boolean = false):Number {
			
			var mid:int;
			
			if(wid) {
				mid = (Tracker.stageW >> 1) + 125;
				mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
			}
			else {
				mid = (Tracker.stageH >> 1) - (Tracker.moduleH >> 1) + 32;
				mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
			}
			
			return mid;
			
		}
		
		// just removes the module preloader when not needed
		private function dumpPre():void {
			
			(this.contains(modulePre)) ? removeChild(modulePre) : null;
		
		}
		
		// adjusts the module's x position when it's in the way of a submenu opening up
		private function checkModule(pushMod:int, back:Boolean = false):Boolean {
			
			if(Tracker.moduleLoaded && moduleReady) {
				
				// push module forward
				if(!back) {
					
					var minusPush:int = pushMod - 16;
					
					if(goDraw) {
							
						var newPush:int;
						
						if(!Tracker.portOn && !Tracker.newsOn) {
							newPush = pushMod;
						}
						else if(Tracker.portOn) {
							newPush = Tracker.moduleX + pushMod - 298;
							TweenMax.to(moduleMask, 0.5, {x: minusPush, ease: Quint.easeOut});
						}
						else if(Tracker.newsOn) {
							newPush = Tracker.moduleX + pushMod - 282;
							minusPush += 16;
							TweenMax.to(moduleMask, 0.5, {x: minusPush, ease: Quint.easeOut});
						}
							
						TweenMax.to(module, 0.5, {x: newPush, ease: Quint.easeOut});
						DrawBlur.pushDraw(minusPush);
						
					}
					else {
						
						TweenMax.to(module, 0.5, {x: minusPush, ease: Quint.easeOut});
					}
				}
				
				// push module back
				else {
						
					TweenMax.to(module, 0.5, {x: Tracker.moduleX, ease: Quint.easeOut});
					
					if(goDraw) {
						DrawBlur.pushDraw(Tracker.moduleX - 16, true);
					}
					
					if(Tracker.portOn) {
						TweenMax.to(moduleMask, 0.5, {x: 250, ease: Quint.easeOut});
					}
					else if(Tracker.newsOn) {
						TweenMax.to(moduleMask, 0.5, {x: 282, ease: Quint.easeOut});
					}
				}
					
				return true;
					
			}
			else {
				return false;
			}
			
		}
		
		// fixes a problem in Chrome and Opera when closing the browser
		private function catchError(event:IOErrorEvent):void {}
		
		// kill the previous module
		private function killModule():void {
			
			moduleReady = false;
			
			// remove event listeners
			module.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, Tracker.trackProgress);
			module.contentLoaderInfo.removeEventListener(Event.COMPLETE, Tracker.moduleDone);
			module.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, Tracker.catchError);
			
			// remove from stage and unload
			(this.contains(module)) ? removeChild(module) : null;
			(module.content != null) ? module.unload() : null;
			
			// see if the connection needs to be closed
			if(moduleOpen) {
				try {
					module.close();
				}
				catch(event:Error) {}
			}
			
			moduleOpen = false;
			Tracker.moduleLoaded = false;
			Tracker.moduleDif = 0;
			
		}
		
		// checks the menu's top level for the swfAddress page
		private function checkMain(tru:Boolean = false):Boolean {
			
			var can:Boolean = false, i:int = pageLength;

			while(i--) {
					
				var str:String = xURL[i].toLowerCase();
				str = str.split(" ").join("");
				
				// if we found the page
				if(page == "/" + str) {
						
					Tracker.myPage = xBack[i];
					Tracker.urlPage = xURL[i];
					Tracker.myAlign = xAlign[i];
					Tracker.subString = "";
					CreateMenu.checkItem(i, tru);
					theModule = i;
					theSub = 999;
					
					can = true;
					
					break;
						
				}
			}
			
			return can;
		}
		
		// check the sub-menu for the swfAddress page
		private function checkSub(checkAll:Boolean = false, tru:Boolean = false):void {
			
			// if a menu button was clicked
			if(!checkAll) {
				
				var xSub:XMLList = xList[item].subMenu.subPage, i:int = xSub.length();
				
				while(i--) {
					
					var stri:String = xSub[i].deepLinkURL.toLowerCase();
					stri = stri.split(" ").join("");
					
					if(page == "/" + stri) {
						
						Tracker.myPage = xSub[i].bgURL;
						Tracker.urlPage = xSub[i].deepLinkURL;
						Tracker.myAlign = xSub[i].bgAlign;
						
						Tracker.subString = item + stri;
						CreateMenu.checkItem(item, tru);
						theModule = item;
						theSub = i;
						
						break;
						
					}
				}
			}
			
			// if a menu button was not clicked we need to do a deeper search
			else {
				
				var exit:Boolean = false, j:int = pageLength;
				
				while(j--) {
					
					var xSubb:XMLList = xList[j].subMenu.subPage, k:int = xSubb.length();
					
					while(k--) {
						
						var strin:String = xSubb[k].deepLinkURL.toLowerCase();
						strin = strin.split(" ").join("");
						
						if(page == "/" + strin) {
							
							Tracker.myPage = xSubb[k].bgURL;
							Tracker.urlPage = xSubb[k].deepLinkURL;
							Tracker.myAlign = xSubb[k].imageAlign;
							
							Tracker.subString = j + strin;
							
							CreateMenu.checkItem(j, tru);
							theModule = j;
							theSub = k;
							
							exit = true;
							
							break;
							
						}
					}
					
					// break out of the first loop
					if(exit) {
						break;
					}
				}
				
			}
		}
		
		// called when a page is to be changed
		private function switchPage():void {
			
			// if the page is not the homepage
			if(page != "/") {
				if(clicked) {
					if(item == 999) {
						checkMain();
					}
					else {
						checkSub();
					}
				}
				else {
					
					var boo:Boolean = checkMain();
					
					if(!boo) {
						checkSub(true);
					}
				}
				clicked = false;
			}
			
			// if the page is the homepage
			else {
				
				theSub = 999;
				theModule = 0;
				Tracker.subString = "";
				Tracker.myPage = xBack[0];
				Tracker.urlPage = xURL[0];
				Tracker.myAlign = xAlign[0];
				CreateMenu.checkItem(0);

			}
			
		}
		
		// the SWFAddress change event handler
		private function SWFHandler(event:SWFAddressEvent) {
			
			dontLoad = false;
			
			// temporarily disable menu buttons
			(!Tracker.fromClick) ? CreateMenu.cleanListeners() : null;
			
			page = SWFAddress.getValue();
			
			if(!runOnce) {
				switchPage();
			}
			
			// if function called for the first time, load in the xml file
			else {
				
				var xmlURL:String = Tracker.rootXML;
				(xmlURL == null) ? xmlURL = "xml/config.xml" : null;
				
				FetchXML.fetch(xmlURL, cb);
				
			}
			
			Tracker.fromClick = false;
			
		}
		
		// ******************************************************************
		// INTERNAL FUNCTIONS AVAILABLE TO PACKAGE-RELATED CLASSES START HERE
		// ******************************************************************
		
		// activate the module preloader
		internal function addModPre():void {
			
			// if called for the first time
			if(myFirst) {
				
				Tracker.startListen(true);
				Backgrounds.load(Tracker.myPage, Tracker.myAlign);
				loadModule();
				myFirst = false;
				
				return;
				
			}
			
			// animate the module preloader
			TweenMax.killTweensOf(modulePre);
			
			modulePre.x = Tracker.stageW + 20;
			modulePre.txt.text = "0%";
			
			fixIndex(true);
			
			TweenMax.to(mm1, 0.5, {scaleY: 0, ease: Quint.easeOut});
			TweenMax.to(mm2, 0.5, {scaleY: 0, ease: Quint.easeOut});
			TweenMax.to(msk2, 0.5, {scaleY: 0, ease: Quint.easeOut});
			TweenMax.to(msk22, 0.5, {scaleY: 0, ease: Quint.easeOut});
			
			DrawBlur.drawPreloader();
			TweenMax.to(msk3, 0.5, {x: Tracker.stageW - 177, ease: Quint.easeOut});
			TweenMax.to(modulePre, 0.5, {x: Tracker.stageW - 167, ease: Quint.easeOut, onComplete: preAdded});
			addChild(modulePre);
			
		}
		
		// remove event listeners for the background
		internal function sendBack():void {
			
			Backgrounds.loaderOpen = false;
			Backgrounds.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, Tracker.trackBack);
			Backgrounds.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, Tracker.backDone);
			Backgrounds.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, Tracker.catchError);
			
		}
		
		// called when the Background has loaded
		internal function fireBG():void {
			
			// wipe the background in
			Backgrounds.done();
			
			if(tweenLogo) {
				
				var sp:Sprite = Sprite(getChildByName("mMenu"));
				
				sp.alpha = 0;
				sp.visible = true;
				TweenMax.to(sp, 1, {alpha: 1, ease: Quint.easeOut, delay: 0.5});
				TweenMax.to(logo, 0.5, {y: logoY, ease: Quint.easeOut, delay: 0.5});
				tweenLogo = false;
			}
			
		}
		
		// fires when the module has loaded
		internal function catchModule():void {
			
			// hide the preloader
			DrawBlur.killPreloader();
			TweenMax.to(modulePre, 0.5, {x: Tracker.stageW + 10, ease: Quint.easeOut, onComplete: dumpPre});
			
			Tracker.moduleLoaded = true;
			
			// if first load, kill master preloader
			if(!isReady) {
				if(Tracker.rootSwf != null) {
					Tracker.rootSwf.killPre();
				}
				startMusic();
				isReady = true;
			}
			
			// add the module to the stage
			addChildAt(module, numChildren - 1);
			addChild(moduleMask);
			
			// if unknown swf is used
			if(moduleType == "yourswf") {
				module.visible = false;
				posModule();
			}
			
		}
		
		// get the positioning parameters form the module
		internal function goDispatch():void {
			
			if(!Tracker.isLoading && Tracker.moduleLoaded) {
				Object(module.content).getSized();
				setChildIndex(module, numChildren - 1);
			}
			
		}
		
		// load in the module
		internal function loadModule():void {
			
			if(!dontLoad) {
			
				var xPage:String;
				Tracker.swfIsReady = false;
				
				// if the page is a top-level
				if(theSub == 999) {
					xPage = xList[theModule].moduleURL;
					moduleType = xList[theModule].moduleType.toLowerCase();
					modPos = xList[theModule].modulePos.toLowerCase();
					Tracker.textXML = xList[theModule].moduleXML;
				}
				
				// if the page is a sub-menu item
				else {
					xPage = xList[theModule].subMenu.subPage[theSub].moduleURL;
					moduleType = xList[theModule].subMenu.subPage[theSub].moduleType.toLowerCase();
					modPos = xList[theModule].subMenu.subPage[theSub].modulePos.toLowerCase();
					Tracker.textXML = xList[theModule].subMenu.subPage[theSub].moduleXML;
				}
				
				// pause the music equalizer (improves performance)
				Music.vPause(true);
				
				module.visible = false;
				module.mask = moduleMask;
				module.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Tracker.trackProgress, false, 0, true);
				module.contentLoaderInfo.addEventListener(Event.COMPLETE, Tracker.moduleDone, false, 0, true);
				module.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, Tracker.catchError, false, 0, true);
				moduleOpen = true;
				module.load(new URLRequest(xPage));
				
			}
			
		}
		
		// makes sure all the z-indexing is correct
		internal function fixIndex(fixModule:Boolean = false):void {
			
			var numChil:int = numChildren - 1;
			
			if(!fixModule && module != null) {
				(this.contains(module)) ? setChildIndex(module, numChil) : null;
			}
			
			if(menuGloss != null) {
				if(this.contains(menuGloss)) {
					setChildIndex(menuGloss, numChil);
				}
			}
			
			if(logo != null) {
				(this.contains(logo)) ? setChildIndex(logo, numChil) : null;
			}
			
			(this.contains(CreateMenu.menu)) ? setChildIndex(CreateMenu.menu, numChil) : null;
			
			(Tracker.liveMusic) ? setChildIndex(speaker, numChil) : null;
			
			if(!hasOne) {
				Music.fadeIn();
				if(menuGloss != null) {
					TweenMax.to(menuGloss, 1, {scaleY: 1, ease: Quint.easeInOut});
				}
			}
			
			hasOne = true;
			
		}
		
		// make the module visible for unknown swfs
		internal function visibleModule():void {
			if(moduleType == "yourswf") {
				module.visible = true;
			}
			
			speaker.visible = true;
			
		}
		
		// called from a menu click
		internal function processPage(st:String, who:int, i:int):Boolean {
			
			var str:String = st.substr(0, 4);
			
			if(str == "http") {
				
				var par:String;
				
				if(who == 999) {
					par = xList[i].urlTarget.toLowerCase();
				}
				else {
					par = xList[who].subMenu.subPage[i].urlTarget.toLowerCase();
				}
				
				navigateToURL(new URLRequest(st), par);
				
				return false;
				
			}
			
			Tracker.fromClick = true;
			item = who;
			clicked = true;
			st = st.split(" ").join("");
			SWFAddress.setValue(st.toLowerCase());
			
			return true;
			
		}
		
		
		// ************************************************
		// PUBLIC FUNCTIONS AVAILABLE TO MODULES START HERE
		// ************************************************
		
		private var count:int = 0;
		
		// called from each indivual module, positions the module and animates it in.  Also serves as the custom event handler
		public function posModule(event:MyEvent = null, contact:Boolean = false, gallery:Boolean = false, portfolio:Boolean = false, news:Boolean = false, fromResize:Boolean = false):void {
			
			if(Tracker.moduleLoaded) {
				
				moduleReady = true;
				
				var num:int, mid:int, wid:int, high:int, w:int, h:int = 0, longText:Boolean = false, passed:Boolean = false, tw:int = Tracker.stageW, th:int = Tracker.stageH, noTween:Boolean = false;
				
				// if called from a module
				if(event == null) {
					if(moduleType != "yourswf") {
						w = Tracker.moduleW;
						high = Tracker.moduleH;
						goDraw = true;
					}
					else {
						w = module.width;
						high = module.height;
						goDraw = false;
						Tracker.moduleH = 0;
						(!fromResize) ? DrawBlur.cleanUp() : null;
					}
				}
				
				// if called from the custom event
				else {
					w = Tracker.moduleW = event.width;
					high = Tracker.moduleH = event.height + 16;
					noTween = true;
					goDraw = event.blur;
					(goDraw) ? Tracker.moduleH = high : Tracker.moduleH = 0;
					
				}
				
				// check for invalid module positions and throw an error if position is invalid
				if(gallery && modPos != "lc") {
					throw new Error("invalid xml position for gallery module");
				}
				
				if(news && modPos != "lc") {
					throw new Error("invalid xml position for news module");
				}
				
				if(portfolio && modPos != "tc") {
					throw new Error("invalid xml position for portfolio module");
				}
				
				(news) ? moduleMask.x = 282 : moduleMask.x = 250;
				
				
				// **********************************************************************
				// each if statement below calcualtes how the module should be positioned
				// **********************************************************************
				
				// long text right position
				if(modPos == "right") {
						
					Tracker.moduleX = tw - Tracker.moduleW - 16;
						
					if(Tracker.moduleH >= th || Tracker.moduleH + 32 >= th) {
						h = 16;
					}
					else {
						h = calculateCenter();
					}
					
					longText = true;
					
				}
				
				// long text center position
				else if(modPos == "center") {		
						
					num = calculateCenter(true);
					mid = Tracker.moduleW >> 1;
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
					Tracker.moduleX = num - mid;
					
					if(Tracker.moduleH >= th || Tracker.moduleH + 32 >= th) {
						h = 16;
					}
					else {
						h = calculateCenter();
					}
						
					longText = true;
							
				}
				
				// lon text left position
				else if(modPos == "left") {
					
					Tracker.moduleX = 266;
						
					if(Tracker.moduleH >= th || Tracker.moduleH + 32 >= th) {
						h = 16;
					}
					else {
						h = calculateCenter();
					}
					
					longText = true;
						
				}
				
				// top-left position
				else if(modPos == "tl") {
					
					if(goDraw) {
						h = 32;
						Tracker.moduleX = 282;
					}
					else {
						h = 16;
						Tracker.moduleX = 266;
					}
						
				}
				
				// top-center position
				else if(modPos == "tc") {
						
					num = calculateCenter(true);
					mid = w >> 1;
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
					Tracker.moduleX = num - mid;
					(goDraw) ? h = 32 : h = 16;
				
				}
				
				// top-right position
				else if(modPos == "tr") {
					
					if(goDraw) {
						h = 32;
						Tracker.moduleX = tw - w - 32;
					}
					else {
						h = 16;
						Tracker.moduleX = tw - w - 16;
					}
					
				}
				
				// left-center position
				else if(modPos == "lc") {
						
					if(goDraw) {
						Tracker.moduleX = 282;
						
						if(!gallery) {
							h = calculateCenter() - 32;
						}
						else {
							h = calculateCenter() - 24;
						}
					}
					else {
						Tracker.moduleX = 266;
						mid = high >> 1;
						mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
						h = calculateCenter() - 32 - mid;
					}
				}
				
				// middle-center position
				else if(modPos == "mc") {
					
					
					num = calculateCenter(true);
					mid = w >> 1;
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);  
					Tracker.moduleX = num - mid;
					if(goDraw) {
						h = calculateCenter() - 32;
					}
					else {
						
						mid = high >> 1;
						mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5); 
						h = calculateCenter() - 32 - mid;

					}
					
				}
				
				// right-center position
				else if(modPos == "rc") {
						
					if(goDraw) {
						h = calculateCenter() - 32;
						Tracker.moduleX = tw - w - 32;
					}
					else {
						mid = high >> 1;
						h = calculateCenter() - 32 - mid;
						Tracker.moduleX = tw - w - 16;
					}
				}
				
				// bottom-left position
				else if(modPos == "bl") {
						
					if(goDraw) {
						Tracker.moduleX = 282;
						h = th - high - 16;
					}
					else {
						Tracker.moduleX = 266;
						h = th - high - 16;
					}
					
				}
				
				// bottom-center position
				else if(modPos == "bc") {
					
					num = calculateCenter(true);
					mid = w >> 1;
					mid = (mid > 0) ? int(mid + 0.5) : int(mid - 0.5);
					Tracker.moduleX = num - mid;
					
					if(goDraw) {
						h = th - high - 16;
					}
					else {
						h = th - high - 16;
					}
				
				}
				
				// bottom-right position
				else if(modPos == "br") {
						
					if(goDraw) {
						Tracker.moduleX = Tracker.stageW - w - 32;
						h = th - high - 16;
					}
					else {
						Tracker.moduleX = Tracker.stageW - w - 16;
						h = th - high - 16;
					}
					
				}
				
				// if a valid position is not detected, we'll throw an error
				else {
					throw new Error("invalid xml position for module");
				}
				
				wid = Tracker.moduleW + 32;
				
				// if a blur background should be drawn
				if(goDraw) {
					DrawBlur.drawModule(modPos, wid, Tracker.moduleH, Tracker.moduleX, h, longText, contact, gallery, portfolio, news, fromResize, noTween);
					setChildIndex(module, 4);
				}
				else {
					setChildIndex(module, 2);
					Tracker.mTweened = true;
				}
				
				module.x = Tracker.moduleX;
				(!portfolio) ? module.y = h : module.y = 16;
				
				if(moduleType != "yourswf") {
					module.visible = true;
				}
				
				xMask = moduleMask.x;
				xWidth = moduleMask.width;
				xHeight = moduleMask.height;
				xMod = module.x;
				yMod = module.y;
				
			}
			
		}
		
		// ***************************************************************************************
		// The functions below are called from the modules and update the module blurs accordingly
		// ***************************************************************************************
		
		// called from news module
		public function openNews(i:int, yy:int, hh:int, tween:Boolean = false):void {
			DrawBlur.openNews(i, yy, hh, tween);
		}
		
		// called from news module
		public function closeNews(i:int):void {
			DrawBlur.closeNews(i);
		}
		
		// called from news module
		public function shiftNews(xx:int):void {
			DrawBlur.shiftNews(xx);
		}
		
		// called from news module
		public function newsArrow():void {
			DrawBlur.newsArrow();
		}
		
		// called from portfolio module
		public function updateThumbs(i:int, bw:int, tw:int):void {
			DrawBlur.updateThumbs(i, bw, tw);
		}
		
		// called from portfolio module
		public function noThumbs():void {
			DrawBlur.noThumbs();
		}
		
		// called from portfolio module
		public function shiftThumbs(num:Number):void {
			DrawBlur.shiftThumbs(num);
		}
		
		// called from portfolio module
		public function portArrows(showMask:Boolean = false):void {
			DrawBlur.portArrows(showMask);
		}
		
		// called from portfolio module
		public function buildThumbs():void {
			DrawBlur.buildThumbs();
		}
		
		// called from portfolio module
		public function outPort():void {
			DrawBlur.outPort();
		}
		
		// called from portfolio module
		public function returnPort():void {
			DrawBlur.returnPort();
		}
		
		// called from the gallery module
		public function setBigOn():void {
			DrawBlur.setGallery();
		}
		
		// called from gallery module
		public function galArrows():void {
			DrawBlur.galArrows();
		}
		
		// called from news module
		public function updatePort(goTween:Boolean, yy:Number, howHigh:int = 0, easeBoth:Boolean = false, isLast:Boolean = false):void {
			DrawBlur.updatePort(goTween, yy, howHigh, easeBoth, isLast);
		}
		
		// called from news module
		public function portControl(w:int, h:int, yPos:int, difY:int, fromResize:Boolean):void {
			DrawBlur.portControl(w, h, yPos, difY, fromResize);
		}
		
		// called from news module
		public function adjustBlur(difX:int):void {
			DrawBlur.adjustBlur(difX);
		}
		
		// called from news module
		public function adjustBig(w:int, h:int, yy:int, difX:int):void {
			DrawBlur.adjustBig(w, h, yy, difX);
		}
		
		// called from news module
		public function adjustSmall(difX:int):void {
			DrawBlur.adjustSmall(difX);
		}
		
		// called from news module
		public function fixOneNews(usingOne:Boolean = false):void {
			DrawBlur.oneNews = usingOne;
		}
		
		public function checkMusic(playOn:Boolean):void {
			Music.vPause(playOn);
		}
		
		// temporarily removes the stage resize event for video full screen
		public function removeSizer(addIt:Boolean = false):void {
			
			if(Tracker.isFull) {
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, Music.escapeThis);
			}
			
			if(!addIt) {
				stage.removeEventListener(Event.RESIZE, sizer);
			}
			else {
				stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			}
			
		}
		
		public function switchButtons():void {
			
			Music.goNormal();
			
		}
		
		// called when video full-screen is toggled
		public function fixFull(goFull:Boolean = false):void {
			
			// if we're going full screen
			if(goFull) {
				
				if(!Tracker.isFull) {
					xMod = module.x;
					yMod = module.y;
					if(moduleMask) {
						TweenMax.killTweensOf(moduleMask);
						xMask = moduleMask.x;
						xWidth = moduleMask.width;
						xHeight = moduleMask.height;
					}
				}
				else {
					Music.addEscape(false);
				}
				
				if(moduleMask) {
					TweenMax.killTweensOf(moduleMask);
					moduleMask.x = 0;
					moduleMask.width = stage.stageWidth;
					moduleMask.height = stage.stageHeight;
				}
					
				module.x = 0;
				module.y = 0;
					
				moduleIndex = getChildIndex(module);
				setChildIndex(module, numChildren - 1);
				
	
			}
			
			// if full-screen video returns to normal
			else {
				
				if(moduleMask) {
					moduleMask.x = xMask;
					moduleMask.width = xWidth;
					moduleMask.height = xHeight;
				}
				
				module.x = xMod;
				module.y = yMod;
				
				if(stage.displayState == StageDisplayState.NORMAL) {
					Music.goNormal();
					sizer();
				}
				else {
					Music.addEscape();
				}
				
				setChildIndex(module, numChildren - 1);
				
			}
			
		}
		
		// wipes the blur for the contact form's success message
		public function contactMessage(go:Boolean = false):void {
			
			DrawBlur.wipeMessage(go);
			
		}
		
		// wipes the blur for the contact form's success message
		public function noMes():void {
			
			DrawBlur.mesOn = false;
			
		}
		
    }
}








