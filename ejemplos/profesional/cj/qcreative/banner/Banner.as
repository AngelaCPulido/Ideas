package cj.qcreative.banner {
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	import cj.qcreative.Tracker;
	import cj.qcreative.banner.utils.CheckContain;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// document class for the banner module
    public final class Banner extends Sprite {
		
		// begin private vars
		private const descBuffer:int = 7, titleBuffer:int = 12, tMargin:int = 24;
		
		private var xLoader:URLLoader,
		css:URLLoader,
		holder1:MyHolder,
		holder2:MyHolder,
		myShape:Shape,
		xTitle:Array,
		xDesc:Array,
		xWait:Array,
		xInfo:Array,
		xDelay:Array,
		xList:Array,
		xFade:Array,
		xLink:Array,
		xTarget:Array,
		xUseInfo:Array,
		xLoading:Boolean,
		cssLoading:Boolean,
		usingTitle:Boolean,
		usingDesc:Boolean,
		one:Boolean,
		forceInfo:Boolean,
		infoOn:Boolean,
		runOnce:Boolean,
		goRandom:Boolean,
		checkOnce:Boolean,
		waitingToLoad:Boolean,
		auto:Boolean,
		useNum:Boolean,
		invert:Boolean,
		useInfo:Boolean,
		globalInfo:Boolean,
		total:int,
		iTotal:int,
		who:int,
		w:int,
		h:int,
		dHeight:int,
		tHeight:int,
		sTitle:String,
		sDesc:String,
		tim:Timer,
		myLoader1:MyLoader1,
		myLoader2:MyLoader2,
		createMasks1:CreateMasks1,
		createMasks2:CreateMasks2,
		textTitle:TextTitle,
		textDesc:TextDescription,
		info:InfoButton,
		pp:PlayPause,
		numButton:NumButton,
		masterPre:MasterPre;
		// end private vars
		
		public function Banner() {
			
			addEventListener(Event.UNLOAD, killLongText, false, 0, true);
			
			// listen for the stage
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
		
		}
		
		// fires when the banner has been added to the stage
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, killLongText, false, 0, true);
			
			this.mouseEnabled = false;
			xLoading = false;
			cssLoading = false;
			runOnce = true;
			checkOnce = true;
			waitingToLoad = false;
			BannerTracker.banner = this;
			var xString:String;
			
			(Tracker.textXML) ? xString = Tracker.textXML : xString = "xml/banner.xml";
			
			// load in the xml file
			xLoader = new URLLoader();
			xLoader.addEventListener(Event.COMPLETE, xLoaded, false, 0, true);
			xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			xLoading = true;
			xLoader.load(new URLRequest(xString));

		}
		
		// fixes a Chrome and Opera bug
		private function catchError(event:IOErrorEvent):void {}
		
		// a string to boolean utility function
		private function convert(st:String):Boolean {
			
			if(st.toLowerCase() == "true") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// called when the pause button is toggled
		private function ppClick(goPause:Boolean):void {
			
			if(goPause) {
				stopTim();
				BannerTracker.playOn = false;
			}
			
			// checks to make sure a slide is ready to be displayed
			else if(!BannerTracker.infoWorking && !BannerTracker.slide1Working && !BannerTracker.slide2Working && !waitingToLoad) {
				BannerTracker.playOn = true;
				startTim();
			}
			else {
				BannerTracker.playOn = true;
			}
			
		}
		
		// fires when a slide transition is to occur
		private function goTime(event:TimerEvent):void {
			
			stopTim();
			
			var checkPlay:Boolean = pp.getPlay();
			
			if(!waitingToLoad && checkPlay) {
				
				// if random slides are off
				if(!goRandom) {
					(who != iTotal) ? who++ : who = 0;
				}
				
				// if random slides are on
				else {
					var cur:int = who;
					while(cur == who) {
						who = (Math.random() * total) | 0;
					}
				}
				
				recieveNumber(who);
			}
		}
		
		// stops the Timer
		private function stopTim():void {
			tim.removeEventListener(TimerEvent.TIMER, goTime);
			tim.stop();
		}
		
		// starts the Timer
		internal function startTim():void {
			if(!waitingToLoad && auto) {
				tim.addEventListener(TimerEvent.TIMER, goTime, false, 0, true);
				tim.delay = xDelay[who];
				tim.start();
			}
		}
		
		// called when the info button is clicked
		private function infoClick(event:MouseEvent):void {
			
			if(!waitingToLoad) {
				
				// if the info is not displayed
				if(!infoOn) {
					if(!BannerTracker.infoWorking) {
						BlurSwf.wipe();
						infoOn = true;
					}
				}
				
				// if the info is displayed
				else {
					if(!BannerTracker.infoWorking) {
						BlurSwf.wipe(true);
						infoOn = false;
					}
				}
			}
		}
		
		// called when a number is clicked
		private function recieveNumber(i:int):void {
			
			// stopes timer if autoplay is on
			(auto) ? stopTim() : null;
			
			who = i;
			
			if(!waitingToLoad) {
				
				// if info is tweening
				if(BannerTracker.infoWorking) {
					BlurSwf.wipe(true, true, true);
					infoOn = false;
				}
				else if(infoOn) {
					BlurSwf.wipe(true, true);
					infoOn = false;
				}
				else {
					loadNext();
				}
			}
		}
		
		// checks to see if info is used
		private function returnInfo(st:String):Boolean {
			
			st = st.toLowerCase();
			
			if(st != "null") {
				return true;
			}
			else {
				return false;
			}
			
		}

		// checks to see if the next slide has info and sets it up if so
		private function testInfo():Boolean {
			
			sTitle = xTitle[who];
			sDesc = xDesc[who];
			usingTitle = returnInfo(sTitle);
			usingDesc = returnInfo(sDesc);
			useInfo = convert(xUseInfo[who]);
			
			var infoVisible:Boolean = false;
			
			// global info refers to when info is always shown directly after a slide wipes in
			if(globalInfo) {
				
				info.offListen();
				
				if(useInfo) {
					
					// if both info and description are used
					if(usingTitle || usingDesc) {
						info.visible = true;
						infoVisible = true;
					}
					else {
						info.visible = false;
					}
				}
				else {
					info.visible = false;
				}
				
			}
			
			// if the play/pause buttons are being used
			if(auto) { 
				(infoVisible) ? pp.x = w - 33 : pp.x = w - 15;
			}
			
			if(usingDesc || usingTitle) {
				return true;
			}
			
			// return false if no info is being used
			else {
				return false;
			}

		}
		
		// fires when a slide transition is complete and we're ready to show the next slide
		private function fireDraw():void {
			
			if(!waitingToLoad && !BannerTracker.slide1Working && !BannerTracker.slide2Working) {
				
				// if using an info title or description
				if(usingTitle || usingDesc) {
					if(forceInfo) {
						infoOn = true;
						BlurSwf.wipe(false, false);
					}
					else if(xInfo && xInfo[who] == "true") {
						infoOn = true;
						BlurSwf.wipe(false, false);
					}
					else {
						infoOn = false;
						BannerTracker.infoWorking = false;
						(auto) ? startTim() : null;
					}
					info.onListen();
				}
				// start the timer if autoplay is on
				else {
					(auto) ? startTim() : null;
				}
			}
			// start the timer if autoplay is on
			else {
				(auto) ? startTim() : null;
			}
			
		}
		
		// "punches" the next number that is to be in an active state
		private function moveNumber():void {
			(!runOnce && useNum) ? numButton.moveHover(who) : runOnce = false;
		}
		
		// waits for the info to tween out before the next slide fires
		private function waitToEnd(event:Event):void {
			if(!BannerTracker.slide1Working && !BannerTracker.slide2Working && !BannerTracker.infoWorking) {
				removeEventListener(Event.ENTER_FRAME, waitToEnd);
				waitingToLoad = false;
				loadNext();
			}
		}
		
		// checks to see if the special "bar" animation should be used
		private function checkFade(st:String):Boolean {
			
			if(st.toLowerCase() == "bars") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// fires if a slide click is to navigate to a url
		private function goClick(event:MouseEvent):void {
			
			var st:String = event.currentTarget.url;
			
			if(st != "null") {
				navigateToURL(new URLRequest(st), event.currentTarget.target);
			}
			
		}
		
		// prepares and loads the next slide
		private function loadNext():void {
			
			if(BannerTracker.slide1Working || BannerTracker.slide2Working || BannerTracker.infoWorking) {
				waitingToLoad = true;
				addEventListener(Event.ENTER_FRAME, waitToEnd, false, 0, true);
			}
			
			// if the slide is ready to be loaded
			else {
				
				setChildIndex(masterPre, numChildren - 1);
				masterPre.gotoAndPlay(1);
				
				// local vars
				var boo:Boolean = testInfo(), 
				loadOver:Boolean = convert(xWait[who]), 
				j:int = getChildIndex(holder1),
				k:int = getChildIndex(holder2),
				getFade:Boolean = checkFade(xFade[who]),
				linker:Boolean = returnInfo(xLink[who]);
				
				(j > k) ? one = true : one = false;
				
				// tests to see which slide holder is to be used
				if(one) {
					holder2.visible = false;
					holder2.url = xLink[who];
					holder2.target = xTarget[who];
					(linker) ? holder2.buttonMode = true : holder2.buttonMode = false;
					myLoader2.loadIt(xList[who], boo, loadOver, getFade);
				}
				else {
					holder1.visible = false;
					holder1.url = xLink[who];
					holder1.target = xTarget[who];
					(linker) ? holder1.buttonMode = true : holder1.buttonMode = false;
					myLoader1.loadIt(xList[who], boo, loadOver, getFade);
				}
			}
		}
		
		// disposes the previous loader when it is no longer needed
		private function dumpSec(loader:Loader):void {
			
			// attemps to dispose of bitmapdata
			if(loader.content is Bitmap) {
				BitmapData(Bitmap(loader.content).bitmapData).dispose();
			}
			loader.unload();
			
		}
		
		// fires when loader #1 has finished loading
		private function loaded1(loader:Loader, loadOver:Boolean, bars:Boolean, secLoader:Loader = null):void {
			
			setChildIndex(holder1, numChildren - 1);
					
			textTitle.visible = false;
			textDesc.visible = false;
			
			// if a title is being used
			if(usingTitle) {
				textTitle.txt.htmlText = sTitle;
				tHeight = textTitle.txt.textHeight;
				textTitle.txt.height = tHeight + 10;
				tHeight += titleBuffer;
			}
			
			// if a description is being used
			if(usingDesc) {
				textDesc.txt.htmlText = sDesc;
				dHeight = textDesc.txt.textHeight;
				textDesc.txt.height = dHeight + 10;
				dHeight += descBuffer;
			}
			
			// if info blur background is to be setup
			if(secLoader != null) {
				BlurSwf.setup(secLoader, usingTitle, usingDesc, dHeight, tHeight);
			}
					
			holder1.addChild(loader);
			
			if(!checkOnce) {
				if(!loadOver && bars) {
					createMasks2.fadeOut(bars);
					masterPre.stop();
					setChildIndex(masterPre, 0);
				}
				else {
					createMasks1.fadeIn(bars);
				}
			}
			
			// if first time the function has fired
			else {
				checkOnce = false;
				createMasks1.fadeIn(bars);
			}
			
		}
		
		// fires when loader #2 has finsihed loading
		private function loaded2(loader:Loader, loadOver:Boolean, bars:Boolean, secLoader:Loader = null):void {
			
			setChildIndex(holder2, numChildren - 1);
					
			textTitle.visible = false;
			textDesc.visible = false;
			
			// if info title is being used
			if(usingTitle) {
				textTitle.txt.htmlText = sTitle;
				tHeight = textTitle.txt.textHeight;
				textTitle.txt.height = tHeight + 10;
				tHeight += titleBuffer;
			}
			
			// if info description is being used
			if(usingDesc) {
				textDesc.txt.htmlText = sDesc;
				dHeight = textDesc.txt.textHeight;
				textDesc.txt.height = dHeight + 10;
				dHeight += descBuffer;
			}
					
			holder2.addChild(loader);
			
			// if info blur background is to be setup
			if(secLoader != null) {
				BlurSwf.setup(secLoader, usingTitle, usingDesc, dHeight, tHeight);
			}
			
			// if bar transition is to be used
			if(!loadOver && bars) {
				createMasks1.fadeOut(bars);
				masterPre.stop();
				setChildIndex(masterPre, 0);
			}
			else {
				createMasks2.fadeIn(bars);
			}
			
		}
		
		// removes the preloader and removes loader #1 form the stage
		private function dumpOne():void {

			masterPre.stop();
			setChildIndex(masterPre, 0);
			CheckContain.holdCheck(holder1, true);
			
		}
		
		// removes the preloader and removes loader #2 form the stage
		private function dumpTwo():void {
			
			masterPre.stop();
			setChildIndex(masterPre, 0);
			CheckContain.holdCheck(holder2, false);
			
		}
		
		// fires when the css file has loaded in
		private function cssLoaded(event:Event):void {
			
			cssLoading = false;
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var style:StyleSheet = new StyleSheet();
			style.parseCSS(event.target.data);
			
			// apply style sheets to info text fields
			textTitle.txt.styleSheet = style;
			textDesc.txt.styleSheet = style;
			
			// if loaded into the Q
			if(Tracker.template) {
				Tracker.swfIsReady = true;
			}
			else {
				setup();
			}
			
			css = null;
			
		}
		
		// fires when the module is ready to animate in for the first time
		private function setup():void {
			
			who = 0;
			
			// checks for global xml properties
			
			// if info is to always be shown
			if(globalInfo) {
				info = new InfoButton(infoClick);
				info.x = w - 15;
				info.y = h + 7;
				info.visible = false;
				addChild(info);
			}
			
			// if autoplay is to be used
			if(auto) {
				tim = new Timer(5000, 1);
				pp = new PlayPause(ppClick);
				pp.y = h + 12;
				addChild(pp);
			}
			
			// if numbered buttons are to be used
			if(useNum) {
				numButton = new NumButton(recieveNumber, total, invert);
				numButton.y = h + 7;
				addChild(numButton);
			}
			
			// creates the two main containers
			holder1 = new MyHolder();
			holder2 = new MyHolder();
			
			holder1.addEventListener(MouseEvent.CLICK, goClick, false, 0, true);
			holder2.addEventListener(MouseEvent.CLICK, goClick, false, 0, true);
			
			holder1.cacheAsBitmap = true;
			holder2.cacheAsBitmap = true;
			
			// create the slide loaders
			myLoader1 = new MyLoader1(loaded1);
			myLoader2 = new MyLoader2(loaded2);
			
			BannerTracker.h1 = holder1;
			BannerTracker.h2 = holder2;
			
			addChild(holder1);
			addChild(holder2);
			addChild(textTitle);
			addChild(textDesc);
			
			// creates the two masks that are used for slide animations
			createMasks1 = new CreateMasks1(w, h, fireDraw, moveNumber, holder1, dumpTwo);
			createMasks2 = new CreateMasks2(w, h, fireDraw, moveNumber, holder2, dumpOne);
			
			BannerTracker.masker1 = createMasks1;
			BannerTracker.masker2 = createMasks2;
			
			// activates the info blur
			BlurSwf.makeMasks(w, h, tMargin, loadNext, posTitle, posDesc);
			
			// local vars
			var boo:Boolean = testInfo(),
			loadOver:Boolean = convert(xWait[who]),
			getFade:Boolean = checkFade(xFade[who]),
			linker:Boolean = returnInfo(xLink[who]);
			(boo) ? BannerTracker.infoWorking = true : BannerTracker.infoWorking = false;
			
			holder1.url = xLink[who];
			holder1.target = xTarget[who];
			(linker) ? holder1.buttonMode = true : null;
			
			// draw the initial mask
			myShape = new Shape();
			myShape.graphics.beginFill(0xFFFFFF);
			myShape.graphics.drawRect(0, 0, w, h);
			myShape.graphics.endFill();
			
			myShape.alpha = 0.5;
			myShape.scaleX = 0;
			addChild(myShape);
			
			// creates the main preloader
			masterPre = new MasterPre();
			masterPre.x = (((w >> 1) + 0.5) | 0) - 35;
			masterPre.y = (((h >> 1) + 0.5) | 0) - 3;
			masterPre.mouseEnabled = false;
			masterPre.mouseChildren = false;
			addChild(masterPre);
			
			TweenMax.to(myShape, 0.5, {scaleX: 1, ease: Quint.easeOut});
			
			myLoader1.loadIt(xList[who], boo, loadOver, getFade);
		}
		
		// sets the title child index
		internal function setT():void {
			textTitle.visible = true;
			setChildIndex(textTitle, numChildren - 1);
		}
		
		// sets the description child index
		internal function setD():void {
			textDesc.visible = true;
			setChildIndex(textDesc, numChildren - 1);
		}
		
		// positions the title TextField
		private function posTitle(i:int, hold:Sprite = null, changer:Boolean = false):void {
			
			textTitle.y = i + 5;
			
			if(hold != null) {
				
				if(!changer) {
					hold.addChild(textTitle);
					textTitle.txt.visible = true;
					textTitle.visible = true;
				}
				else {
					textTitle.visible = false;
					addChild(textTitle);
				}
			}
		}
		
		// positions the description TextField
		private function posDesc(i:int, hold:Sprite = null, changer:Boolean = false):void {
			
			textDesc.y = i + 10;
			
			if(hold != null) {
				if(!changer) {
					hold.addChild(textDesc);
					textDesc.txt.visible = true;
					textDesc.visible = true;
				}
				else {
					textDesc.visible = false;
					addChild(textDesc);
				}
			}
		}
		
		// called from the Q when the module is ready to be activated
		public function getSized():void {
			Tracker.template.posModule();
			setup();
		}
		
		// fires when the xml file has loaded in
		private function xLoaded(event:Event):void {
			
			xLoading = false;
			event.target.removeEventListener(Event.COMPLETE, xLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var xml:XML = new XML(event.target.data);
			
			w = int(xml.settings.width);
			h = int(xml.settings.height);
			
			// creates temporary xml lists
			var xLister:XMLList = xml.content.item.image,
			xUseInfos:XMLList = xml.content.item.useInfoButton,
			xLinks:XMLList = xml.content.item.link,
			xTargets:XMLList = xml.content.item.linkTarget,
			xTitles:XMLList = xml.content.item.title,
			xDescs:XMLList = xml.content.item.description,
			xFades:XMLList = xml.content.item.fadeType,
			xWaits:XMLList = xml.content.item.fadeOver,
			xDelays:XMLList = xml.content.item.delay,
			infoShow:String = String(xml.settings.infoBehaviour).toLowerCase(),
			isRandom:String = xml.settings.randomizeOrder,
			cssString:String = xml.settings.useStylesheet.toString(),
			xInfos:XMLList;
			
			if(Tracker.template) {
				Tracker.moduleW = w;
				Tracker.moduleH = h + 32;
			}
			
			total = xLister.length();
			iTotal = total - 1;
			
			// set global xml properties
			
			if(infoShow == "forceoff" || infoShow == "perslide") {
				forceInfo = false;
			}
			else if(infoShow == "forceon") {
				forceInfo = true;
			}
			
			if(infoShow == "perslide") {
				xInfos = xml.content.item.showInfo;
			}
			
			// create arrays for storing xml lists
			xList = [];
			xDelay = [];
			xTitle = [];
			xDesc = [];
			xWait = [];
			xInfo = [];
			xFade = [];
			xUseInfo = [];
			xLink = [];
			xTarget = [];
			
			// populate the arrays
			for(var i:int = 0; i < total; i++) {
				
				xList[i] = xLister[i].toString();
				xDelay[i] = Number(xDelays[i].toString()) * 1000;
				
				xUseInfo[i] = xUseInfos[i].toString();
				
				xLink[i] = xLinks[i].toString();
				(xLink[i] == "") ? xLink[i] = "null" : null;
				
				xTarget[i] = xTargets[i].toString();
				(xTarget[i] == "") ? xTarget[i] = "null" : null;
				
				xTitle[i] = xTitles[i].toString();
				(xTitle[i] == "") ? xTitle[i] = "null" : null;
				
				xDesc[i] = xDescs[i].toString();
				(xDesc[i] == "") ? xDesc[i] = "null" : null;
				
				xWait[i] = xWaits[i].toString();
				xFade[i] = xFades[i].toString();
				(xInfos) ? xInfo[i] = xInfos[i].toString() : null;
				
			}
			
			// check a few more global xml properties
			auto = convert(xml.settings.autoPlay.toString());
			goRandom = convert(xml.settings.randomSlide.toString());
			invert = convert(xml.settings.invertButtons.toString());
			useNum = convert(xml.settings.useNumButtons.toString());
			globalInfo = convert(xml.settings.useInfoButton.toString());
			
			// if slides are to be randomized
			if(isRandom.toLowerCase() == "true") {
				
				// create temporary arrays
				var shuf1:Array = [],
				shuf2:Array = [],
				shuf3:Array = [],
				shuf4:Array = [],
				shuf5:Array = [],
				shuf6:Array = [],
				shuf7:Array = [],
				shuf8:Array = [],
				shuf9:Array = [],
				shuf10:Array = [],
				j:Number;
				
				// populate arrays in a random order
				while(xList.length > 0){
					
					j = (Math.random() * xList.length) | 0;
					shuf1.push(xList.splice(j, 1));
					shuf2.push(xDelay.splice(j, 1));
					shuf3.push(xTitle.splice(j, 1));
					shuf4.push(xDesc.splice(j, 1));
					shuf5.push(xWait.splice(j, 1));
					shuf6.push(xFade.splice(j, 1));
					shuf7.push(xUseInfo.splice(j, 1));
					shuf8.push(xLink.splice(j, 1));
					shuf9.push(xTarget.splice(j, 1));
					(xInfos) ? shuf10.push(xInfo.splice(j, 1)) : null;
				}
				
				// store the new order of the arrays
				xList = shuf1;
				xDelay = shuf2;
				xTitle = shuf3;
				xDesc = shuf4;
				xWait = shuf5;
				xFade = shuf6;
				xUseInfo = shuf7;
				xLink = shuf8;
				xTarget = shuf9;
				
				(xInfos) ? xInfo = shuf10 : null;
				
			}

			textTitle = new TextTitle();
			textTitle.txt.width = w - (tMargin * 2) - 20;
			
			textTitle.x = tMargin + 8;
			
			textDesc = new TextDescription();
			textDesc.txt.width = textTitle.txt.width;
			textDesc.x = tMargin + 10;
			textDesc.txt.mouseWheelEnabled = false;
			
			// load in the css file if used
			if(cssString.toLowerCase() == "true") {
				css = new URLLoader();
				css.addEventListener(Event.COMPLETE, cssLoaded, false, 0, true);
				css.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				cssLoading = true;
				css.load(new URLRequest(xml.settings.stylesheetURL));
			}
			else {
				if(Tracker.template) {
					Tracker.swfIsReady = true;
				}
				else {
					setup();
				}
			}
			
			xLoader = null;
			
		}
		
		// GARBAGE COLLECTION
		private function killLongText(event:Event):void {
			
			// remove event listeners
			removeEventListener(Event.UNLOAD, killLongText);
			removeEventListener(Event.REMOVED_FROM_STAGE, killLongText);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.ENTER_FRAME, waitToEnd);
			
			// check if xml file or css file are still loading
			if(xLoading) {
				if(xLoader != null) {
					xLoader.removeEventListener(Event.COMPLETE, xLoaded);
					xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
					try {
						xLoader.close();
					}
					catch(event:Error) {
						
						if(cssLoading) {
							if(css != null) {
								css.removeEventListener(Event.COMPLETE, cssLoaded);
								css.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
								try {
									css.close();
								}
								catch(event:Error){};
								css = null;
							}
						}
						
					}
					xLoader = null;
				}
			}
			
			masterPre.stop();
			
			// remove all children
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			BannerTracker.finalKill();
			BlurSwf.finalKill();
			
			// if the module has been activated
			if(holder1 != null) {
				
				holder1.removeEventListener(MouseEvent.CLICK, goClick);
				holder2.removeEventListener(MouseEvent.CLICK, goClick);
				
				// kill any Loaders that are currently loading data
				myLoader1.kill();
				myLoader2.kill();
				
				createMasks1.finalKill();
				createMasks2.finalKill();
				
				CheckContain.holdCheck(holder1, true);
				CheckContain.holdCheck(holder2, false);
				
				// clean up assets
				info.finalKill();
				(useNum) ? numButton.finalKill() : null;
				
				// kill the timer
				if(auto) {
					tim.removeEventListener(TimerEvent.TIMER, goTime);
					tim.stop();
					tim = null;
					(globalInfo) ? pp.finalKill() : null;
				}
				
				// remove more children
				textTitle.removeChildAt(0);
				textDesc.removeChildAt(0);
				
				while(holder1.numChildren) {
					holder1.removeChildAt(0);
				}
				while(holder2.numChildren) {
					holder2.removeChildAt(0);
				}
				
				myShape.graphics.clear();
				
			}
			
			// set all vars to null
			textTitle = null;
			textDesc = null;
			info = null;
			pp = null;
			numButton = null;
			holder1 = null;
			holder2 = null;
			xTitle = null;
			xDesc = null;
			xWait = null;
			xInfo = null;
			xDelay = null;
			xList = null;
			xFade = null;
			xUseInfo = null;
			xLink = null;
			xTarget = null;
			myLoader1 = null;
			myLoader2 = null;
			createMasks1 = null;
			createMasks2 = null;
			myShape = null;
			masterPre = null;

		}
    }
}








