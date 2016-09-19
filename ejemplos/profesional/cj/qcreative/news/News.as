package cj.qcreative.news {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.StyleSheet;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import cj.qcreative.Tracker;
	import cj.qcreative.utils.Cleaner;
	import cj.qcreative.news.graphics.MyGradient;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Linear;
	
	// this is the document class for the News module
	public final class News extends Sprite {
		
		// begin private vars
		private var xLoader:URLLoader,
		css:URLLoader,
		
		xLoading:Boolean,
		useStyle:Boolean,
		cssLoading:Boolean,
		sectionOn:Boolean,
		direct:String,
		
		style:StyleSheet,
		xImage:XMLList,
		xTitle:XMLList,
		xDate:XMLList,
		xText:XMLList,
		
		iWidth:int,
		iHeight:int,
		total:int,
		iTotal:int,
		counter:int,
		bWidth:int,
		isOn:int,
		sh:int,
		itemOn:int,
		halfStage:int,
		
		holders:Array,
		loaders:Array,
		
		aHolder:Sprite,
		master:Sprite,
		mainMask:Sprite,
		shLeft:Shape,
		shTop:Shape,
		shBottom:Shape,
		lefty:MyArrow,
		righty:MyArrow;
		// end private vars
		
		// clas constructor
		public function News() {
			
			addEventListener(Event.UNLOAD, removed, false, 0, true);
			
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
			addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
			
			this.mouseEnabled = false;
			NewsTracker.stager = stage;
			
			var xString:String;
			
			(Tracker.textXML) ? xString = Tracker.textXML : xString = "xml/news.xml";
			
			xLoader = new URLLoader()
			xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			xLoader.addEventListener(Event.COMPLETE, xLoaded, false, 0, true);
			xLoading = true;
			xLoader.load(new URLRequest(xString));
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// loads in the CSS file
		private function loadStyle(st:String):void {
			
			css = new URLLoader();
			css.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			css.addEventListener(Event.COMPLETE, cssLoaded, false, 0, true);
			cssLoading = true;
			css.load(new URLRequest(st));
			
		}
		
		// string to boolean function
		private function xCheck(st:String):Boolean {
			
			if(st == null) {
				return false;
			}
			
			if(st != "") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// called form the Q when the module is ready to be displayed
		public function getSized():void {
			
			Tracker.template.posModule(null, false, false, false, true);
			setUp();
			
		}
		
		// loads in each item's image and creates the preloaders
		private function ripLoaders(ripPre:Boolean = false):void {
			
			if(ripPre) {
				
				var i:int = total, pre:MasterPre, shp:Sprite;
				
				while(i--) {
					
					pre = new MasterPre();
					pre.name = "pre";
					pre.x = (((iWidth >> 1) + 0.5) | 0) - 35;
					pre.y = (((iHeight >> 1) + 0.5) | 0) - 3;
					pre.mouseEnabled = false;
					pre.mouseChildren = false;
					shp = Sprite(master.getChildByName("shp" + i));
					shp.addChild(pre);
					
				}
				
			}
			
			var loader:MyLoader;
			loader = new MyLoader(counter);
			loaders[counter] = loader;
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, iLoaded, false, 0, true);
			loader.load(new URLRequest(xImage[counter]));
			
		}
		
		// set's up the module's assets
		private function setUp():void {
			
			var holder:MyHolder, dif:int = 0, shaper:Sprite;
			
			holders = [];
			loaders = [];
			
			master = new Sprite();
			master.mouseEnabled = false;
			
			for(var i:int = 0; i < total; i++) {
				
				holder = new MyHolder(i);
				holders[i] = holder;
				holder.x = dif;
				
				shaper = new Sprite();
				shaper.name = "shp" + i;
				shaper.graphics.beginFill(0xFFFFFF, 0.5);
				shaper.graphics.drawRect(0, 0, iWidth, iHeight);
				shaper.graphics.endFill();
				shaper.x = dif;
				
				master.addChild(shaper);
				master.addChild(holder);
				
				dif += bWidth;
				
			}
			
			lefty = new MyArrow();
			righty = new MyArrow();
			
			lefty.name = "left";
			righty.name = "right";
			
			righty.x = 22;
			lefty.y = 14;			
			lefty.rotation = 180;
			
			if(total != 1) {
			
				lefty.addEventListener(MouseEvent.ROLL_OVER, aOver, false, 0, true);
				lefty.addEventListener(MouseEvent.ROLL_OUT, aOut, false, 0, true);
				lefty.addEventListener(MouseEvent.CLICK, aClick, false, 0, true);
				
				righty.addEventListener(MouseEvent.ROLL_OVER, aOver, false, 0, true);
				righty.addEventListener(MouseEvent.ROLL_OUT, aOut, false, 0, true);
				righty.addEventListener(MouseEvent.CLICK, aClick, false, 0, true);
				
				lefty.buttonMode = righty.buttonMode = true;
				
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
				
			}
			else {
				
				lefty.visible = righty.visible = false;
				
			}
			
			aHolder = new Sprite();
			aHolder.alpha = 0;
			aHolder.mouseEnabled = false;
			aHolder.addChild(lefty);
			aHolder.addChild(righty);
			
			shLeft = new Shape();
			shTop = new Shape();
			shBottom = new Shape();
			
			mainMask = new Sprite();
			mainMask.mouseEnabled = false;
			mainMask.addChild(shLeft);
			mainMask.addChild(shTop);
			mainMask.addChild(shBottom);
			
			sizer();
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			
			addChild(mainMask);
			addChild(aHolder);
			
			master.mask = mainMask;
			
			(Tracker.template) ? Tracker.template.newsArrow() : null;
			TweenMax.to(aHolder, 1, {alpha: 1, ease: Quint.easeOut});
			
			master.scaleY = 0;
			addChild(master);
			
			TweenMax.to(master, 0.5, {scaleY: 1, ease: Quint.easeOut, onCompleteParams: [true], onComplete: ripLoaders});
			
		}
		
		private function onMouse(event:MouseEvent):void {
			
			if(event.delta > 0) {
				direct = "left";
				aClick();
			}
			else {
				direct = "right";
				aClick();
			}
			
		}
		
		// fires when an image has loaded in
		private function iLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, iLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var temp:MyLoader = MyLoader(event.target.loader);
			temp.isLoading = false;
			
			var i:int = temp.id, yy:int, checkThis:Boolean, dater:Boolean, bit:Bitmap, sMask:Shape, previewTitle:PreviewTitle;
			
			loaders.splice(i, 1);
			
			bit = Bitmap(event.target.content);
			
			sMask = new Shape();
			sMask.graphics.beginFill(0x000000);
			sMask.graphics.drawRect(0, 0, iWidth, iHeight);
			sMask.graphics.endFill();
			sMask.scaleX = 0;
			holders[i].mask = sMask;
			holders[i].addChild(sMask);
			
			holders[i].addChild(bit);
			
			previewTitle = new PreviewTitle();
			previewTitle.mouseEnabled = false;
			(useStyle) ? previewTitle.txt.styleSheet = style : null;
			
			previewTitle.txt.width = iWidth - 60;
			previewTitle.txt.htmlText = xTitle[i];
			
			checkThis = xCheck(xTitle[i]);
			dater = xCheck(xDate[i]);
			
			if(dater) {
				MyTitle.calculate(iWidth, iHeight, 22);
			}
			else {
				MyTitle.calculate(iWidth, iHeight, 16);
			}
			
			if(checkThis) {
				
				var bitData:BitmapData, bit2:Bitmap;
				
				bitData = bit.bitmapData.clone();
				bit2 = new Bitmap(bitData);
				yy = MyTitle.setUp(bit2, holders[i], previewTitle);
			}
			else {
				yy = iHeight - 22;
			}
			
			if(dater) {
				
				var theDate:TheDate, dShape:Shape;
				
				theDate = new TheDate();
				theDate.txt.width = iWidth - 60;
				theDate.txt.text = xDate[i];
				theDate.x = 30;
				theDate.y = yy - 5;
				theDate.mouseEnabled = false;
				
				dShape = new Shape();
				dShape.graphics.beginFill(0x000000);
				dShape.graphics.drawRect(0, 0, iWidth - 40, theDate.txt.height - 4);
				dShape.graphics.endFill();
				dShape.x = 20;
				dShape.y = yy;
				
				holders[i].addChild(dShape);
				holders[i].addChild(theDate);
				
			}
			
			var myText:MyText, tMask:MyGradient, tHolder:Sprite;
			
			myText = new MyText(iWidth, iHeight, style, xText[i]);
			
			tMask = new MyGradient();
			tMask.cacheAsBitmap = myText.cacheAsBitmap = true;
			myText.mask = tMask;
			
			tHolder = new Sprite();
			tHolder.name = "tHolder";
			tHolder.y = iHeight + 12;
			
			tHolder.addChild(myText);
			tHolder.addChild(tMask);
			
			holders[i].addChild(tHolder);
			
			tMask.update(iWidth, myText.distH);
			tMask.y = -(myText.distH * 2) - 40;
			
			TweenMax.to(sMask, 0.5, {scaleX: 1, ease: Quint.easeOut, onCompleteParams: [sMask, i], onComplete: dumpMask});
			
			if(counter != iTotal) {
				counter++;
				ripLoaders();
			}
			else {
				counter++;
				ready();
			}
			
		}
		
		// fires when an item tweens in for the first time
		private function dumpMask(sp:Shape, i:int):void {
			
			holders[i].mask = null;
			holders[i].removeChild(sp);
			sp.graphics.clear();
			
			var shp:Sprite, pre:MasterPre, hit:Sprite;
			
			shp = Sprite(master.getChildByName("shp" + i));
			
			pre = MasterPre(shp.getChildByName("pre"));
			pre.stop();
			
			shp.removeChild(pre);
			shp.graphics.clear();
			master.removeChild(shp);
			
			hit = new Sprite();
			hit.name = "hit";
			
			hit.graphics.beginFill(0x000000);
			hit.graphics.drawRect(0, 0, iWidth, iHeight);
			hit.graphics.endFill();
			
			hit.buttonMode = true;
			hit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			hit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			hit.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
			hit.alpha = 0;
			
			holders[i].addChild(hit);
			holders[i].hasHit = true;
			
		}
		
		// mouse over function for arrow
		private function aOver(event:MouseEvent):void {
			
			event.currentTarget.gotoAndPlay("over");
			
		}
		
		// mouse out function for arrow
		private function aOut(event:MouseEvent):void {
			
			event.currentTarget.gotoAndPlay("out");
			
		}
		
		// checks to see if the news can be moved to the left or right
		private function checkOn(st:String):Boolean {
			
			if(st == "right") {
				
				if(isOn != iTotal) {
					isOn++;
					return true;
				}
				else {
					return false;
				}
				
			}
			else {
				
				if(isOn != 0) {
					isOn--;
					return true;
				}
				else {
					return false;
				}
				
			}
			
		}
		
		// nulls out some vars when they're no longer needed
		private function ready():void {
			
			loaders = null;
			style = null;
			xImage = null;
			xTitle = null;
			xDate = null;
			xText = null;
			
		}
		
		// arrow click function
		private function aClick(event:MouseEvent = null):void {
			
			var st:String;
			
			if(event != null) {
				st = event.currentTarget.name;
			}
			else {
				st = direct;
			}
			var tween:Boolean = checkOn(st);
			
			if(tween) {
				
				(sectionOn) ? clicker() : null;
				sectionOn = false;
				(Tracker.template) ? Tracker.openNews = false : null;
				
				var xx:int = isOn * bWidth;
				TweenMax.to(master, 0.75, {x: -xx, ease: Quint.easeOut});
				
				(Tracker.template) ? Tracker.template.shiftNews(-xx) : null;
				
			}
			
		}
		
		// news item click function
		private function clicker(event:MouseEvent = null):void {
			
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			
			var k:int;
			
			if(event != null) {
				
				sectionOn = true;
				event.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, out);
				var par:MyHolder = MyHolder(event.currentTarget.parent);
				k = par.id;
				itemOn = k;
				Tracker.newsNumber = k;
				Tracker.openNews = true;
				
			}
			else {
				k = -1;
			}
			
			var j:int = counter, theHolder:Sprite, theMask:MyGradient, hit:Sprite, theText:MyText, myScaler:Sprite, scaleThis:Shape, dist:int, yy:int = 0, goHit:Boolean;
			
			while(j--) {
					
				theHolder = Sprite(holders[j].getChildByName("tHolder"));
				theMask = MyGradient(theHolder.getChildByName("tMask"));
				theText = MyText(theHolder.getChildByName("myText"));
				
				goHit = holders[j].hasHit;
				
				if(goHit) {
					hit = Sprite(holders[j].getChildByName("hit"));
					hit.removeEventListener(MouseEvent.CLICK, clicker);
				}
				
				myScaler = Sprite(holders[j].getChildByName("master"));
				scaleThis = Shape(myScaler.getChildByName("black"));
				
				if(j != k || event == null) {
					
					if(goHit) {
						hit.removeEventListener(MouseEvent.ROLL_OUT, addReverse);
						hit.removeEventListener(MouseEvent.ROLL_OVER, rOver);
						hit.removeEventListener(MouseEvent.ROLL_OUT, rOut);
					
						hit.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
						hit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
						hit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
					}
					
					dist = theText.distH;
					
					if(holders[j].y != 0) {
						
						TweenMax.to(holders[j], 0.75, {y: 0, ease: Quint.easeOut});
						(Tracker.template) ? Tracker.template.closeNews(j) : null;
					}
					
					if(theMask.y != -dist - 20) {
						theMask.fix();
						TweenMax.to(theMask, 0.75, {y: -dist - 20, ease: Quint.easeOut});
					}

					if(scaleThis.scaleX != 0) {
						TweenMax.to(scaleThis, 0.5, {scaleX: 0, ease: Quint.easeOut});
					}
					
					theText.setScroll(true);
					
				}
					
				else {
					
					var isSmall:Boolean = theText.ripText(), fortyEight:int, tFour:int = 0, difY:int, newDif:int;
					dist = theText.distH;
					
					if(goHit) {
						hit.removeEventListener(MouseEvent.ROLL_OVER, over);
						hit.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);
						hit.addEventListener(MouseEvent.ROLL_OUT, addReverse, false, 0, true);
					}
					
					TweenMax.to(scaleThis, 0.5, {scaleX: 1, ease: Quint.easeOut});
					
					yy = -(dist * 0.5);
					yy += 8;
					
					if(!isSmall) {
						fortyEight = 48;
					}
					else {
						fortyEight = 0;
					}
					
					difY = halfStage - (iHeight >> 1);
					newDif = difY + yy;
					
					if(newDif > 16 && newDif < 32) {
						fortyEight += 32;
					}
					
					TweenMax.killTweensOf(theMask);
					
					theMask.fix(true);
					theMask.y = -(dist * 2);
					TweenMax.to(theMask, 0.75, {y: -10, ease: Linear.easeNone});
					TweenMax.to(holders[j], 0.75, {y: yy, ease: Quint.easeOut});
					
					(Tracker.template) ? Tracker.template.openNews(j, yy, dist + iHeight + fortyEight) : null;
					
				}
				
			}
			
			if(!stage.willTrigger(MouseEvent.MOUSE_WHEEL)) {
					
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
				
			}
			
		}
		
		// adds reverse mouse roll events for an opened item
		private function addReverse(event:Event):void {
			
			event.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, addReverse);
			event.currentTarget.addEventListener(MouseEvent.ROLL_OVER, rOver, false, 0, true);
			event.currentTarget.addEventListener(MouseEvent.ROLL_OUT, rOut, false, 0, true);
			
		}
		
		public function addSize(boo:Boolean):void {
			
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			sizer();
			
		}
		
		public function removeSize():void {
			
			stage.removeEventListener(Event.RESIZE, sizer);
		}
		
		// browser resize event
		public function sizer(event:Event = null):void {
			
			var sw:int = stage.stageWidth, i:int = counter, theHolder:Sprite, theMask:MyGradient, theText:MyText, isSmall:Boolean, dist:int;
				
			sh = stage.stageHeight;
			halfStage = ((sh >> 1) + 0.5) | 0;
				
			aHolder.y = iHeight + 48;
			aHolder.x = sw - 324;
				
			while(i--) {
				
				theHolder = Sprite(holders[i].getChildByName("tHolder"));
				theMask = MyGradient(theHolder.getChildByName("tMask"));
				theText = MyText(theHolder.getChildByName("myText"));
					
				isSmall = theText.ripText();
				dist = theText.distH;
				theMask.update(iWidth, dist);
					
				if(i == itemOn  && sectionOn) {
					
					TweenMax.killTweensOf(theHolder);
					TweenMax.killTweensOf(theMask);
						
					var yy:int, fortyEight:int, tFour:int = 0, difY:int, newDif:int;
					
					yy = -(dist * 0.5);
					yy += 8;
					
					if(!isSmall) {
						fortyEight = 48;
					}
					else {
						fortyEight = 0;
					}
					
					difY = halfStage - (iHeight >> 1);
					newDif = difY + yy;
					
					if(newDif > 16 && newDif < 32) {
						fortyEight += 32;
					}
							
					holders[i].y = yy;
					
					theMask.y = -10;
					
					(Tracker.template) ? Tracker.template.openNews(i, yy, dist + iHeight + fortyEight, true) : null;
					
				}
				else {
					theMask.y = -(dist * 2);
				}
				
			}
				
			shLeft.graphics.clear();
			shLeft.graphics.beginFill(0x000000);
			shLeft.graphics.drawRect(0, 0, sw - 348, sh);
			shLeft.graphics.endFill();
				
			shTop.graphics.clear();
			shTop.graphics.beginFill(0x000000);
			shTop.graphics.drawRect(0, 0, 66, halfStage + (iHeight >> 1) + 24);
			shTop.graphics.endFill();
			shTop.x = sw - 348;
				
			shBottom.graphics.clear();
			shBottom.graphics.beginFill(0x000000);
			shBottom.graphics.drawRect(0, 0, 66, sh - shTop.height - 48);
			shBottom.graphics.endFill();
			shBottom.x = shTop.x;
			shBottom.y = shTop.y + shTop.height + 48;
				
			mainMask.y = this.y - halfStage + (iHeight >> 1) + 8;
			
		}
		
		// closes a news item
		private function goBack(event:MouseEvent):void {
			
			sectionOn = false;
			(Tracker.template) ? Tracker.openNews = false : null;
			clicker();
			
		}
		
		// handles title mouse roll events
		private function processRoll(par:MyHolder, reverse:Boolean = false):void {
			
			var i:int = par.numChildren;
			
			while(i--) {
				
				if(par.getChildAt(i).name == "master") {
					
					var myScaler:Sprite, scaleThis:Shape, inOut:int;
					
					myScaler = Sprite(par.getChildByName("master"));
					scaleThis = Shape(myScaler.getChildByName("black"));
					
					inOut = !reverse ? 1 : 0;
					
					TweenMax.to(scaleThis, 0.5, {scaleX: inOut, ease: Quint.easeOut});
					
					break;
					
				}
			}
			
		}
		
		// open news roll over
		private function rOver(event:MouseEvent):void {
			
			processRoll(MyHolder(event.currentTarget.parent), true);
			
		}
		
		// open news roll out
		private function rOut(event:MouseEvent):void {
			
			processRoll(MyHolder(event.currentTarget.parent));
			
		}
		
		// closed news roll over
		private function over(event:MouseEvent):void {
			
			processRoll(MyHolder(event.currentTarget.parent));
			
		}
		
		// closed news roll out
		private function out(event:MouseEvent):void {
			
			processRoll(MyHolder(event.currentTarget.parent), true);
			
		}
		
		// css file loaded
		private function cssLoaded(event:Event):void {
			
			cssLoading = false;
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			style = new StyleSheet();
			style.parseCSS(event.target.data);
			
			if(Tracker.template) {
				Tracker.swfIsReady = true;
			}
			else {
				setUp();
			}
			
			css = null;
			
		}
		
		// string to boolean utility function
		private function convert(st:String):Boolean {
			
			if(st.toLowerCase() == "true") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// xml file loaded
		private function xLoaded(event:Event):void {
			
			xLoading = false;
			event.target.removeEventListener(Event.COMPLETE, xLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var xml:XML = new XML(event.target.data), xList:XMLList;
			
			iWidth = int(xml.settings.itemWidth);
			iHeight = int(xml.settings.itemHeight);
			
			bWidth = iWidth + 16;
			
			xList = xml.item;
			
			total = xList.length();
			iTotal = total - 1;
			counter = 0;
			isOn = 0;
			itemOn = 0;
			sectionOn = false;
			
			xDate = xList.date;
			xImage = xList.image;
			xTitle = xList.title;
			xText = xList.text;

			useStyle = convert(xml.settings.useStyleSheet);
			
			Tracker.newsObj = {newsTotal: total, newsWidth: bWidth + 16, newsHeight: iHeight + 32};
			Tracker.moduleW = (bWidth * total) + 16;
			Tracker.moduleH = iHeight + 16;
			Tracker.newsNumber = -1;
			Tracker.openNews = false;
			
			if(total != 1) {
				(Tracker.template) ? Tracker.template.fixOneNews() : null;
			}
			else {
				(Tracker.template) ? Tracker.template.fixOneNews(true) : null;
			}
			
			if(useStyle) {
				loadStyle(xml.settings.styleSheetUrl);
			}
			else {
				if(Tracker.template) {
					Tracker.swfIsReady = true;
				}
				else {
					setUp();
				}
			}
			
			xLoader = null;
			
		}
		
		// GARBAGE COLLECTION
		private function removed(event:Event):void {
			
			stage.removeEventListener(Event.RESIZE, sizer);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			removeEventListener(Event.UNLOAD, removed);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			if(loaders != null) {
				
				var i:int = loaders.length;
				
				while(i--) {
					
					if(loaders[i] != null) {
						loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, iLoaded);
						loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
						
						if(loaders[i].isLoading) {
							try {
								loaders[i].close();
							}
							catch(event:*){};
						}
						else if(loaders[i].content) {
							BitmapData(Bitmap(loaders[i].content).bitmapData).dispose();
							loaders[i].unload();
						}
					}
					
				}
				
				loaders = null;
				
			}
			
			if(holders != null) {
				
				TweenMax.killTweensOf(master);
				
				removeChild(mainMask);
				shLeft.graphics.clear();
				shTop.graphics.clear();
				shBottom.graphics.clear();
				mainMask.removeChild(shLeft);
				mainMask.removeChild(shTop);
				mainMask.removeChild(shBottom);
				
				removeChild(aHolder);
				aHolder.removeChild(lefty);
				aHolder.removeChild(righty);
				
				lefty.removeEventListener(MouseEvent.ROLL_OVER, aOver);
				lefty.removeEventListener(MouseEvent.ROLL_OUT, aOut);
				lefty.removeEventListener(MouseEvent.CLICK, aClick);
			
				righty.removeEventListener(MouseEvent.ROLL_OVER, aOver);
				righty.removeEventListener(MouseEvent.ROLL_OUT, aOut);
				righty.removeEventListener(MouseEvent.CLICK, aClick);
				
				lefty.stop();
				righty.stop();
				
				while(lefty.numChildren) {
					lefty.removeChildAt(0);
				}
				
				while(righty.numChildren) {
					righty.removeChildAt(0);
				}
				
				var j:int = holders.length;
				
				while(j--) {
					
					while(holders[j].numChildren) {
						
						TweenMax.killTweensOf(holders[j].getChildAt(0));
						
						if(holders[j].getChildAt(0).name == "tHolder") {
							
							var th:Sprite, mt:MyText;
							
							th = Sprite(holders[j].getChildAt(0));
							mt = MyText(th.getChildByName("myText"));
							
							mt.kill();
						}
						
						else if(holders[j].getChildAt(0).name == "hit") {
							
							var hit:Sprite = Sprite(holders[j].getChildAt(0));
							hit.removeEventListener(MouseEvent.ROLL_OVER, over);
							hit.removeEventListener(MouseEvent.ROLL_OUT, out);
							hit.removeEventListener(MouseEvent.CLICK, clicker);
							hit.removeEventListener(MouseEvent.ROLL_OUT, addReverse);
							hit.removeEventListener(MouseEvent.ROLL_OVER, rOver);
							hit.removeEventListener(MouseEvent.ROLL_OUT, rOut);
							
						}
						
						Cleaner.clean(holders[j].getChildAt(0));
						holders[j].removeChildAt(0);
					
					}
					
				}
				
				while(this.numChildren) {
					removeChildAt(0);
				}
				
				mainMask = null;
				shLeft = null;
				shTop = null;
				shBottom = null;
				aHolder = null;
				lefty = null;
				righty = null;
				holders = null;
				
			}
			
			if(xLoading) {
				
				xLoader.removeEventListener(Event.COMPLETE, xLoaded);
				xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					xLoader.close();
				}
				catch(event:*){};
				
				xLoader = null;
				
			}
			else if(cssLoading) {
				
				css.removeEventListener(Event.COMPLETE, cssLoaded);
				css.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					css.close();
				}
				catch(event:*){};
				
				css = null;
				
			}
			
			style = null;
			xImage = null;
			xTitle = null;
			xDate = null;
			xText = null;
			master = null;
			
			Tracker.newsObj = null;
			NewsTracker.kill();
			
			
		}
		
		
	}
	
	
}








