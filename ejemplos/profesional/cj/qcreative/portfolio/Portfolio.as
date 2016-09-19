package cj.qcreative.portfolio {
	
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Linear;
	
	import cj.qcreative.Tracker;
	import cj.qcreative.utils.Cleaner;
	import cj.qcreative.videoplayer.SingleVideo;
	import cj.qcreative.portfolio.utils.MyLoader;
	import cj.qcreative.portfolio.utils.ThumbLoader;
	import cj.qcreative.portfolio.graphics.ThumbMask;
	import cj.qcreative.portfolio.graphics.MyGradient;
	
	// this is the document class for the Portfolio module
    public final class Portfolio extends Sprite {
		
		// begin private vars
		private var xLoader:URLLoader,
		cssLoader:URLLoader,
		
		xOpen:Boolean,
		cssOpen:Boolean,
		hasFirst:Boolean,
		sectionOn:Boolean,
		oneClicked:Boolean,
		masterTween:Boolean,
		transitioning:Boolean,
		
		cats:XMLList,
		thumbList:XMLList,
		
		total:int,
		bw:int,
		bh:int,
		tw:int,
		th:int,
		countUp:int,
		sw:int,
		sh:int,     
		totalB:int,
		totalH:int,
		prev:int,
		bitCount:int,
		halfH:int,
		thumbOn:int,
		prevOn:int,
		counter:int,
		theDif:int,
		howHigh:int,
		myTotal:int,
		bigIndex:int,
		vidIndex:int,
		totalHeight:int,
		yMaster:int,
		
		loader:MyLoader,
		myText1:MyText1,
		myText2:MyText2,
		upper:MyArrow,
		downer:MyArrow,
		tMask1:MyGradient,
		tMask2:MyGradient,
		thumbMask:ThumbMask,
		subVideo:SingleVideo,
		objToGo:SingleVideo,
		aHolder:Sprite,
		master:Sprite,
		tHolder1:Sprite,
		tHolder2:Sprite,
		bitHolder:Sprite,
		bLoader:Loader,
		bMask:Sprite,
		maskToGo:Sprite,
		newLoader:Loader,
		oldLoader:*,
		prevLoader:*,
		
		holders:Array,
		storeY:Array,
		loaders:Array,
		bites:Array,
		originals:Array,
		
		css:StyleSheet;
		// end private vars
		
		// begin internal vars
		internal var isOn:int, iTotal:int;
		// end internal vars
		
		// class constructor
		public function Portfolio() {
			
			addEventListener(Event.UNLOAD, removed, false, 0, true);
			
			xOpen = false;
			cssOpen = false;
			hasFirst = false;
			sectionOn = false;
			oneClicked = false;
			transitioning = false;
			
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
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
		
		// removes text mask #1
		private function removeMask1():void {
			
			tMask1.fix(true);
			
			var i:int = total;
			
			while(i--) {
				
				if(holders[i].contains(tMask1)) {
					holders[i].removeChild(tMask1);

					break;
				}
				
			}
			
		}
		
		// removes text mask #2
		private function removeMask2():void {
			
			tMask2.fix(true);
			
			var i:int = total;
			
			while(i--) {
				
				if(holders[i].contains(tMask2)) {
					holders[i].removeChild(tMask2);

					break;
				}
				
			}
			
		}
		
		// processes a category click
		private function recieveClick(i:int):void {
			
			var high:int, mySpace:int, k:int = total, hit:Sprite, myScaler:Sprite, scaleParent:Sprite, scaleThis:Sprite, hasVid:Boolean;
			
			bitCount = 0;
			thumbOn = 0;
			bitHolder.x = 0;
			
			if(!hasFirst) {
				
				holders[i].addChild(tHolder1);
				
				high = myText1.setText(cats[i].description);
				mySpace = myText1.fixMenu(cats[i].title);
				howHigh = high + 48;
				
				myText1.setScroll();
				
				tMask1.scaleY = 1;
				tMask1.update(bw + mySpace + 9, howHigh);
				TweenMax.killTweensOf(tMask1);
				tMask1.y = totalH - (howHigh << 1);
				holders[i].addChild(tMask1);
				
				tMask2.fix();
				TweenMax.to(tMask2, 0.75, {scaleY: 0, ease: Quint.easeInOut, onComplete: removeMask2});
				
				hasFirst = true;
				
			}
			else {
				
				holders[i].addChild(tHolder2);
				
				high = myText2.setText(cats[i].description);
				mySpace = myText2.fixMenu(cats[i].title);
				howHigh = high + 48;
				
				myText2.setScroll();
				
				tMask2.scaleY = 1;
				tMask2.update(bw + mySpace + 9, howHigh);
				TweenMax.killTweensOf(tMask2);
				tMask2.y = totalH - (howHigh << 1);
				holders[i].addChild(tMask2);
				
				tMask1.fix();
				TweenMax.to(tMask1, 0.75, {scaleY: 0, ease: Quint.easeInOut, onComplete: removeMask1});
				
				hasFirst = false;
			}
			
			while(k--) {
				
				if(k > i) {
					TweenMax.to(holders[k], 0.75, {y: storeY[k] + howHigh, ease: Quint.easeInOut});
				}
				else {
					TweenMax.to(holders[k], 0.75, {y: storeY[k], ease: Quint.easeInOut});
				}
				
				if(holders[k].hasHit) {
					
					hit = Sprite(holders[k].getChildByName("hit"));
					holders[k].setChildIndex(hit, holders[k].numChildren - 1);
				
					if(k != i) {
						
						TweenMax.to(hit, 1, {alpha: 0.7, ease: Quint.easeOut});
						
						myScaler = Sprite(holders[k].getChildByName("masker"));
						scaleParent = Sprite(holders[k].getChildByName("master"));
						scaleThis = Sprite(scaleParent.getChildByName("black"));
							
						if(myScaler.x != holders[k].myX) {
							TweenMax.to(myScaler, 0.5, {x: holders[k].myX, ease: Quint.easeOut});
						}
							
						if(scaleThis.scaleX != 0) {
							TweenMax.to(scaleThis, 0.5, {scaleX: 0, ease: Quint.easeOut});
						}
						
						hasVid = holders[k].containsVid ? true : false;
						
						(hasVid) ? holders[k].resetVid() : null;
							
					}
				}
				
			}
			
			prev = i;
			isOn = i;
				
			yMaster = getHeight();
			
			TweenMax.to(master, 0.75, {y: yMaster, ease: Quint.easeInOut, onComplete: wipeText});
			
		}
		
		// calculates the height of the category
		private function getHeight(goTween:Boolean = false):Number {
			
			myTotal = howHigh + bh + 16;
			
			var myDif:Number, theY:Number, isLast:Boolean;
			
			myDif = (((sh >> 1) - (myTotal >> 1)) + 0.5) | 0;
			theY = -(isOn * totalH) + myDif - 8;
			
			isLast = isOn == iTotal ? true : false;

			if(goTween) {
				(Tracker.template) ? Tracker.template.updatePort(false, theY, howHigh, true, isLast) : null;
				TweenMax.killTweensOf(master, true);
				master.y = theY;
			}
			else {
				(Tracker.template) ? Tracker.template.updatePort(true, theY, howHigh, true, isLast) : null;
			}
			
			return theY;
			
		}
		
		// removes the stage resize function for full-browser video
		public function addSize(boo:Boolean = false):void {
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			(boo) ? sizer() : null;
		}
		
		// removes the stage resize function for full-browser video
		public function removeSize():void {
			stage.removeEventListener(Event.RESIZE, sizer);
		}

		// toggles full-screen behaviour for the video player
		public function fs(goFull:Boolean = false):void {
			
			if(goFull) {
				
				var j:int = holders[isOn].numChildren - 1, k:int = master.numChildren - 1;
				
				if(oneClicked) {
								
					bigIndex = master.getChildIndex(holders[isOn]);
					vidIndex = holders[isOn].getChildIndex(oldLoader);
								
					maskToGo = Sprite(holders[isOn].getChildByName("theB"));
					oldLoader.mask = null;
								
					holders[isOn].setChildIndex(oldLoader, j);
					master.setChildIndex(holders[isOn], k);
								
					master.y = -(isOn * totalH);
					
				}
				
				else {
								
					bigIndex = master.getChildIndex(holders[isOn]);
					vidIndex = holders[isOn].getChildIndex(holders[isOn].vid);
							
					maskToGo = Sprite(holders[isOn].getChildByName("mainMask"));
					holders[isOn].vid.mask = null;
								
					holders[isOn].setChildIndex(holders[isOn].vid, j);
					master.setChildIndex(holders[isOn], k);
								
					master.y = -(isOn * totalH);
					
				}
				
			}
			else {
				
				if(oneClicked) {
					holders[isOn].setChildIndex(oldLoader, vidIndex);
					oldLoader.mask = maskToGo;
				}
				else {
					holders[isOn].setChildIndex(holders[isOn].vid, vidIndex);
					holders[isOn].vid.mask = maskToGo;
				}
				
				master.setChildIndex(holders[isOn], bigIndex);
				master.y = yMaster;
				maskToGo = null;
				
				if(!Tracker.isFull) {
					stage.displayState = StageDisplayState.NORMAL;
				}
				
				addSize();
				sizer(null);
				
			}
			
			(Tracker.template) ? Tracker.template.fixFull(goFull) : null;
			
			if(!goFull && stage.displayState == StageDisplayState.NORMAL) {
				
				addSize();
				sizer(null);
				
			}
			
		}
		
		// wipes the text mask in when a category is selected
		private function wipeText():void {
			
			removeThumbs();
			
			if(hasFirst) {
				TweenMax.to(tMask1, 1, {y: totalH - 9, ease: Linear.easeNone, onComplete: wipeControl});
			}
			else {
				TweenMax.to(tMask2, 1, {y: totalH - 9, ease: Linear.easeNone, onComplete: wipeControl});
			}
			
			var hasVid:Boolean, bitY:Number;
			
			hasVid = holders[isOn].containsVid ? true : false;
			
			if(hasVid) {
				holders[isOn].showControls();
				(Tracker.template) ? Tracker.template.checkMusic(false) : null;
			}
			else {
				(Tracker.template) ? Tracker.template.checkMusic(true) : null;
			}
			
			tw = int(cats[isOn].attribute("thumbWidth")) + 16;
			th = int(cats[isOn].attribute("thumbHeight"));
			thumbList = cats[isOn].item;
			
			bitY = ((halfH - (th >> 1)) + 0.5) | 0;
			bitHolder.y = bitY;
			
			Tracker.portObj = {tw: ((thumbList.length() - 1) * tw) + bw + 32, th: th + 32, myTotal: myTotal + 16, dif: bitY, bw: bw + 32};
			(Tracker.template) ? Tracker.template.buildThumbs() : null;
			
			ThumbLoader.loadThumbs(thumbList);
			
			holders[isOn].addChildAt(bitHolder, 1);
			holders[isOn].setChildIndex(holders[isOn].getChildByName("whiteBG"), 0);
			
			thumbMask.y = bitHolder.y;
			holders[isOn].addChild(thumbMask);
			thumbMask.activate(bw, th);
			
			bitHolder.mask = thumbMask;
			
		}
		
		// stage event resize function
		public function sizer(event:Event = null):void {
			
			sh = stage.stageHeight;
			sw = stage.stageWidth;
			
			aHolder.y = sh - 73;
			
			if(sectionOn) {
				
				if(hasFirst) {
					howHigh = myText1.getHigh() + 48;
				}
				else {
					howHigh = myText2.getHigh() + 48;
				}
				
				getHeight(true);
				
				var k:int = total, mySpace:int;
				
				while(k--) {

					TweenMax.killTweensOf(holders[k]);
					
					if(k > isOn) {
						holders[k].y = storeY[k] + howHigh;
					}
					else {
						holders[k].y = storeY[k];
					}
					
				}
				
				thumbMask.activate(bw, th);
				
				Tracker.portObj.myTotal = myTotal + 16;
				Tracker.portObj.dif = ((halfH - (th >> 1)) + 0.5) | 0;
				
				if(hasFirst) {
					mySpace = myText1.fixMenu(cats[isOn].title);
					myText1.callPort(true);
					tMask1.update(bw + mySpace + 9, howHigh);
				}
				else {
					mySpace = myText2.fixMenu(cats[isOn].title);
					myText2.callPort(true);
					tMask2.update(bw + mySpace + 9, howHigh);
				}
				
			}
			else {
				
				var theDif:Number = -(isOn * totalH);
				
				if(!masterTween) {
					TweenMax.killTweensOf(master);
				}
				else {
					TweenMax.killTweensOf(master, true);
				}
				
				master.y = theDif;
				
				if(Tracker.template) {
					Tracker.template.updatePort(false, theDif);
				}
			}
			
		}
		
		// small thumb click
		private function tClick(i:int):void {
			
			(hasFirst) ? myText1.removeListen() : myText2.removeListen();
			
			var j:int = bites.length, hasVid:Boolean, pre:MasterPre;
			
			while(j--) {
				bites[j].pauseVideo(i);
			}
			
			hasVid = holders[isOn].containsVid ? true : false;
			(hasVid) ? holders[isOn].resetVid() : null;
			
			pre = MasterPre(holders[isOn].getChildByName("pre"));
			holders[isOn].setChildIndex(pre, holders[isOn].numChildren - 1);
			pre.gotoAndPlay(1);
			
			if(!bites[i].containsVid) {
				bLoader = new Loader();
				bLoader.mouseEnabled = false;
				bLoader.name = "z" + i;
				bLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				bLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bLoaded, false, 0, true);
				bLoader.load(new URLRequest(thumbList[i].large));
			}
			else {
				
				subVideo = new SingleVideo(thumbList[i].video, thumbList[i].large, 1, 3, vLoaded, i);
				holders[isOn].addChildAt(subVideo, 1);
				holders[isOn].setChildIndex(holders[isOn].getChildByName("whiteBG"), 0);
				
			}
			
		}
		
		// fires when a small thumbs video has loaded
		private function vLoaded(w:int, h:int, vid:Sprite, bite:BitmapData, i:int):void {
			
			var prevLoader:*, dispose:Boolean, space:int, x1:int, dif:int, goingLeft:Boolean, j:int, pre:MasterPre;
			
			bites[i].vid = vid;
			
			if(!oneClicked) {
				prevLoader = originals[isOn];
				dispose = false;
			}
			else {
				prevLoader = oldLoader;
				dispose = true;
			}
			
			oneClicked = true;
			
			space = -(i * tw);
			
			bMask = getMask();
			bMask.name = "theB";
			subVideo.mask = bMask;
			
			pre = MasterPre(holders[isOn].getChildByName("pre"));
			pre.stop();
			
			holders[isOn].addChildAt(bMask, 2);
			holders[isOn].setChildIndex(holders[isOn].getChildByName("whiteBG"), 0);
			holders[isOn].setChildIndex(pre, 0);
			
			dif = bw + 16;
			goingLeft = i > thumbOn ? true : false;
			
			if(goingLeft) {
				bites[thumbOn].x = bites[i].x - dif;
				subVideo.x = bw;
				x1 = -bw;
			}
			else {
				bites[thumbOn].x = bites[i].x + dif
				subVideo.x = -bw;
				x1 = bw;
			}
			
			j = bites.length;
			
			while(j--) {
				
				if(j == i - 1 || j == i + 1) {
					bites[j].clickOn();
				}
				else if(i != j) {
					bites[j].removeClick();
				}
				
			}
			
			subVideo.visible = true;

			oldLoader = subVideo;
			
			(Tracker.template) ? Tracker.template.shiftThumbs(space) : null;
			
			TweenMax.to(bitHolder, 0.75, {x: space, ease: Quint.easeInOut});
			TweenMax.to(prevLoader, 0.75, {x: x1, ease: Quint.easeInOut, onCompleteParams: [prevLoader, dispose, i, true], onComplete: resetThumbs});
			TweenMax.to(subVideo, 0.75, {x: 0, ease: Quint.easeInOut});
			
			thumbOn = i;
			oldLoader.name = "oldLoader";
			subVideo = null;
			
		}
		
		// fires when a small click loads in an image
		private function bLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, bLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			if(event.target.content is Bitmap) {
				event.target.content.smoothing = true;
			}
			
			newLoader = event.target.loader;
			newLoader.mouseEnabled = false;
			
			var space:int, i:int, numb:int, dispose:Boolean, x1:int, dif:int, goingLeft:Boolean, j:int, pre:MasterPre;
			
			numb = newLoader.name.length;
			
			if(numb == 2) {
				i = int(newLoader.name.charAt(1));
			}
			else {
				i = int(newLoader.name.charAt(1) + newLoader.name.charAt(2));
			}
			
			if(!oneClicked) {
				prevLoader = originals[isOn];
				dispose = false;
			}
			else {
				prevLoader = oldLoader;
				dispose = true;
			}
			
			oneClicked = true;
			
			space = -(i * tw);
			
			bMask = getMask();
			bMask.name = "theB";
			newLoader.mask = bMask;
			
			pre = MasterPre(holders[isOn].getChildByName("pre"));
			pre.stop();
			
			holders[isOn].addChildAt(bMask, 2);
			holders[isOn].addChildAt(newLoader, 2);
			holders[isOn].setChildIndex(holders[isOn].getChildByName("whiteBG"), 0);
			holders[isOn].setChildIndex(pre, 0);
			
			dif = bw + 16;
			goingLeft = i > thumbOn ? true : false;
			
			if(goingLeft) {
				bites[thumbOn].x = bites[i].x - dif;
				newLoader.x = bw;
				x1 = -bw;
			}
			else {
				bites[thumbOn].x = bites[i].x + dif
				newLoader.x = -bw;
				x1 = bw;
			}
			
						
			j = bites.length;
			
			while(j--) {
				
				if(j == i - 1 || j == i + 1) {
					bites[j].clickOn();
				}
				else if(i != j) {
					bites[j].removeClick();
				}
				
			}
			
			(Tracker.template) ? Tracker.template.shiftThumbs(space) : null;
			
			TweenMax.to(bitHolder, 0.75, {x: space, ease: Quint.easeInOut});
			TweenMax.to(prevLoader, 0.75, {x: x1, ease: Quint.easeInOut, onCompleteParams: [prevLoader, dispose, i], onComplete: resetThumbs});
			TweenMax.to(newLoader, 0.75, {x: 0, ease: Quint.easeInOut});
			
			thumbOn = i;
			oldLoader = newLoader;
			oldLoader.name = "oldLoader";
			bLoader = null;
			
		}
		
		// kills the small thumbs when a new section is clicked 
		private function resetThumbs(preLoader:*, dispose:Boolean, i:int, isVideo:Boolean = false):void {
			
			if(dispose) {
				
				if(preLoader is Loader) {
					
					if(preLoader.content is Bitmap) {
						
						BitmapData(Bitmap(preLoader.content).bitmapData).dispose();
						
					}
					
					preLoader.unload();
					
				}
				else {
					
					preLoader.kill();
					
				}
				
			}
			
			var j:int = bites.length;
			
			while(j--) {
				
				if(j == i - 1 || j == i + 1) {
					bites[j].addClick(true);
				}
				
				if(j != i) {
					bites[j].vid = null;
				}
				
			}
			
			(hasFirst) ? myText1.wipeControl(true) : myText2.wipeControl(true);
			
			if(isVideo) {
				bites[i].showControls();
				(Tracker.template) ? Tracker.template.checkMusic(false) : null;
			}
			else {
				(Tracker.template) ? Tracker.template.checkMusic(true) : null;
			}
			
		}
		
		// fires after a small thumb has loaded in
		private function recThumbs(bit:Bitmap):void {
			
			var hasVideo:Boolean, autoStart:Boolean, sp:MyThumb;
			
			hasVideo = thumbList[bitCount].video == undefined ? false : true;
			autoStart = hasVideo ? convert(thumbList[bitCount].autoStartVideo) : false;
			
			sp = new MyThumb(bit, bitCount, tClick, tw - 16, th, hasVideo, autoStart);
			
			bites[bitCount] = sp;
			
			if(bitCount != 0) {
				sp.x = totalB + (tw * (bitCount - 1));
			}
			
			(Tracker.template) ? Tracker.template.updateThumbs(bitCount, bw, tw) : null;
			bitHolder.addChild(sp);
			
			bitCount++;
			
		}
		
		// wipes in the section's control bar
		private function wipeControl():void {
			
			(hasFirst) ? myText1.wipeControl(false) : myText2.wipeControl(false);
			
			transitioning = false;
			var i:int = total, hit:Sprite;
			
			while(i--) {
				if(i != isOn) {
					if(holders[i].hasHit) {
						hit = Sprite(holders[i].getChildByName("hit"));
						hit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
						hit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
						hit.addEventListener(MouseEvent.CLICK, thumbClick, false, 0, true);
						hit.buttonMode = true;
						hit.mouseChildren = false;
						hit.mouseEnabled = true;
					}
				}
			}

		}
		
		// removes the event listeners from a section when it's clicked
		private function removeListen(i:int):void {
			
			var j:int = total, hit:Sprite;
			
			while(j--) {
				
				if(holders[j].hasHit) {
					hit = Sprite(holders[j].getChildByName("hit"));
					hit.removeEventListener(MouseEvent.ROLL_OVER, over);
					hit.removeEventListener(MouseEvent.ROLL_OUT, out);
					hit.removeEventListener(MouseEvent.CLICK, thumbClick);
					hit.buttonMode = false;
					hit.mouseChildren = true;
					hit.mouseEnabled = false;
					
					(j == i) ? TweenMax.to(hit, 1, {alpha: 0, ease: Quint.easeOut}) : null;
				}
			}
			
		}
		
		// closes the sections back to normal
		private function finalBack():void {
			
			if(hasFirst) {
				tMask1.fix();
				TweenMax.to(tMask1, 0.75, {scaleY: 0, ease: Quint.easeInOut, onComplete: removeMask1});
			}
			else {
				tMask2.fix();
				TweenMax.to(tMask2, 0.75, {scaleY: 0, ease: Quint.easeInOut, onComplete: removeMask2});
			}
	
			var k:int = total, hasVid:Boolean, hit:Sprite, myScaler:Sprite, scaleParent:Sprite, scaleThis:Sprite;
			
			while(k--) {
				
				TweenMax.to(holders[k], 0.75, {y: storeY[k], ease: Quint.easeInOut});
				
				if(holders[k].hasHit) {
					hit = Sprite(holders[k].getChildByName("hit"));
					TweenMax.to(hit, 1, {alpha: 0, ease: Quint.easeOut});
				}
				
				hasVid = holders[k].containsVid ? true : false;
				
				if(hasVid) {
					holders[k].resetVid();
				}
					
			}
			
			if(Tracker.template) {
				Tracker.template.returnPort();
			}
				
			hit = Sprite(holders[isOn].getChildByName("hit"));
			hit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			hit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			hit.addEventListener(MouseEvent.CLICK, thumbClick, false, 0, true);
			hit.buttonMode = true;
			hit.mouseChildren = false;
			hit.mouseEnabled = true;
			
			myScaler = Sprite(holders[isOn].getChildByName("masker"));
			scaleParent = Sprite(holders[isOn].getChildByName("master"));
			scaleThis = Sprite(scaleParent.getChildByName("black"));
						
			if(myScaler.x != holders[isOn].myX) {
				TweenMax.to(myScaler, 0.5, {x: holders[isOn].myX, ease: Quint.easeOut});
			}
						
			if(scaleThis.scaleX != 0) {
				TweenMax.to(scaleThis, 0.5, {scaleX: 0, ease: Quint.easeOut});
			}
				
			upper.activate();
			downer.activate();
				
			TweenMax.to(aHolder, 0.75, {alpha: 1, ease: Quint.easeOut, onComplete: addMouse});
		}
		
		private function addMouse():void {
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
			
		}
		
		// returns the section back to its normal state
		private function fireMask(sending:Boolean, tweenMask:Boolean = false):void {
			
			if(oldLoader != null) {
				if(oldLoader is Loader) {
						
					if(oldLoader.content is Bitmap) {
						BitmapData(Bitmap(oldLoader.content).bitmapData).dispose();
					}
						
					oldLoader.unload();
						
				}
				else {
					
					oldLoader.kill();
						
				}
				oldLoader = null;
			}
			
			var i:int = holders[isOn].numChildren, countMe:int = 0;
			
			while(i--) {
				
				if(holders[isOn].getChildAt(i).name == "theB") {
					Sprite(holders[isOn].getChildAt(i)).graphics.clear();
					holders[isOn].removeChildAt(i);
					countMe++;
				}
				else if(holders[isOn].getChildAt(i).name == "oldLoader") {
					holders[isOn].removeChildAt(i);
					countMe++;
				}
				
				if(countMe == 2) {
					break;
				}
				
			}
			
			originals[prevOn].x = 0;
			
			if(!sending) {
				if(!tweenMask) {
					var mm:Sprite = Sprite(holders[prevOn].getChildByName("mainMask"));
					mm.x = bw;
					TweenMax.to(mm, 0.5, {x: 0, ease: Quint.easeOut, onComplete: finalBack});
				}
				else {
					finalBack();
				}
			}
			else {
				if(!tweenMask) {
					var mm2:Sprite = Sprite(holders[prevOn].getChildByName("mainMask"));
					mm2.x = bw;
					TweenMax.to(mm2, 0.5, {x: 0, ease: Quint.easeOut, onCompleteParams: [isOn], onComplete: recieveClick});
				}
				else {
					recieveClick(isOn);
				}
			}
			
		}
		
		// wipes the current section slide away
		private function wipeAway(sending:Boolean, tweenMask:Boolean = false):void {
			
			if(bMask != null) {
				TweenMax.to(bMask, 0.5, {scaleX: 0, ease: Quint.easeOut, onCompleteParams: [sending, tweenMask], onComplete: fireMask});
			}
			else {
				fireMask(sending, tweenMask);
			}
			
		}
		
		// removes the small thumbs from the main thumb holder
		private function removeThumbs():void {
			
			var i:int = bites.length, j:int = holders.length;
			
			while(i--) {
				bitHolder.removeChild(bites[i]);
				bites[i].finalKill();
			}
			
			bites = [];
			
			while(j--) {
				
				if(holders[j].contains(bitHolder)) {
					holders[j].removeChild(bitHolder);
					holders[j].removeChild(thumbMask);

					break;
				}
			}
			
		}
		
		// closes out an active section
		private function goBack(sending:Boolean = false):void {
			
			oneClicked = false;
			(hasFirst) ? myText1.setScroll(true) : myText2.setScroll(true);
			
			if(bLoader != null) {
				
				bLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bLoaded);
				bLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					bLoader.close();
				}
				catch(event:*){};
				
				bLoader = null;
				
			}
			
			ThumbLoader.kill();
			
			var i:int = bites.length, j:int = bites.length;
			
			while(i--) {
				bites[i].kill();
				bites[i].pauseVideo();
			}
			
			if(thumbOn != 0 || sending) {
				
				if(thumbOn != 0) {
					wipeAway(sending);
				}
				else {
					fireMask(sending, true);
				}
				
			}
			else {
				
				fireMask(false, true);
				
			}
			
			(Tracker.template) ? Tracker.template.noThumbs() : null;
		
			
			Tracker.portObj = null;
			
			while(j--) {
				
				bites[j].hide();
				
			}
			
		}
		
		// fires the next section
		private function afterBack():void {
			
			recieveClick(isOn);
			
		}
		
		// handles a main section click
		private function thumbClick(event:MouseEvent):void {
			
			var par:* = event.currentTarget.parent;
			var i:int = par.id;
			
			if(sectionOn) {
				
				if(i > isOn) {
					
					if(hasFirst) {
						myText1.wipeBack(true);
					}
					else {
						myText2.wipeBack(true);
					}
					
					bigClick("down");
				}
				else if(i < isOn) {
					
					if(hasFirst) {
						myText1.wipeBack(true);
					}
					else {
						myText2.wipeBack(true);
					}
					
					bigClick("up");
					
				}
				
				return;
				
			}
			
			var j:int, myScaler:Sprite;
			
			(hasFirst) ? myText1.setScroll(true, sectionOn) : myText2.setScroll(true, sectionOn);
			
			sectionOn = true;
			transitioning = true;
			oneClicked = false;
			
			upper.deactivate();
			downer.deactivate();
			
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			
			TweenMax.to(aHolder, 0.75, {alpha: 0, ease: Quint.easeOut});
			
			TweenMax.killTweensOf(holders[i].getChildByName("masker"), true);
			
			removeListen(i);
			
			if(Tracker.template) {
				Tracker.template.noThumbs();
				Tracker.template.portArrows();
			}
			
			var k:int = holders.length, pre:MasterPre;
			
			while(k--) {
				
				if(holders[k].hasHit) {
					pre = MasterPre(holders[k].getChildByName("pre"));
					pre.stop();
					holders[k].setChildIndex(pre, 0);
				}
				
			}
			
			j = bites.length;
			
			while(j--) {
				
				bites[j].hide();
				
			}
			
			myScaler = Sprite(holders[i].getChildByName("masker"));
			TweenMax.to(myScaler, 0.5, {x: holders[i].myX + myScaler.width, ease: Quint.easeOut, onCompleteParams: [i], onComplete: recieveClick});
			
		}
		
		// handles main arror clicks
		private function arrowClick(isUp:Boolean, tween:Boolean = true):Boolean {
			
			var returner:Boolean;
			
			if(!isUp) {
				if(isOn != iTotal) {
					isOn++;
					returner = true;
				}
				else {
					returner = false;
				}
			}
			else {
				if(isOn != 0) {
					isOn--;
					returner = true;
				}
				else {
					returner = false;
				}
			}
			
			if(tween) {
				
				var theDif:Number = -(isOn * totalH);
				TweenMax.to(master, 0.75, {y: theDif, ease: Quint.easeOut});
				
				if(Tracker.template) {
					Tracker.template.updatePort(true, theDif);
				}
				
			}
			else {
				removeListen(isOn);
			}
			
			return returner;
			
		}
		
		// tests to see if another section should be loaded
		private function testCount():void {
			
			if(countUp != iTotal) {
				countUp++;
				setUp(countUp);
			}
			else {
				PortTracker.arrowsReady = true;
				loaders = null;
				
				if(sectionOn) {
					
					if(hasFirst) {
						myText1.goClick();
					}
					else {
						myText2.goClick();
					}
					
				}
				
			}
			
		}
		
		// utility function that draws a Sprite
		private function getMask():Sprite {
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(0, 0, bw, bh);
			sp.graphics.endFill();
			
			return sp;
			
		}
		
		// utility function that draws a Shape
		private function getShape():Shape {
			
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xFFFFFF);
			sh.graphics.drawRect(0, 0, bw, bh);
			sh.graphics.endFill();
			
			return sh;
			
		}
		
		// handles section control clicks
		private function bigClick(st:String):void {
			
			prevOn = isOn;
			
			switch(st) {
				
				case "down":
					
					var go:Boolean, myScaler:Sprite;
					
					go = arrowClick(false, false);
					
					if(go) {
						removeListen(isOn);
						goBack(true);
						myScaler = Sprite(holders[isOn].getChildByName("masker"));
						TweenMax.to(myScaler, 0.5, {x: holders[isOn].myX + myScaler.width, ease: Quint.easeOut});
					}
					
				break;
				
				case "up":
					
					var go2:Boolean, myScaler2:Sprite;
					
					go2 = arrowClick(true, false);
					
					if(go2) {
						removeListen(isOn);
						goBack(true);
						myScaler2 = Sprite(holders[isOn].getChildByName("masker"));
						TweenMax.to(myScaler2, 0.5, {x: holders[isOn].myX + myScaler2.width, ease: Quint.easeOut});
					}
					
				break;
				
				case "close":
				
					if(Tracker.template) {
						Tracker.template.portArrows(true);
						Tracker.template.checkMusic(true);
					}
					sectionOn = false;
					
					var pre:MasterPre = MasterPre(holders[isOn].getChildByName("pre"));
					pre.stop();
					holders[isOn].setChildIndex(pre, 0);
					
					goBack();
					
				break;
				
			}
			
		}
		
		// removes the initial mask after a section has loaded in
		private function removeMasker(i:int, loader:*, bit:*, msk:Sprite):void {
			
			if(loader is Loader) {
				if(loader.content is Bitmap) {
					Bitmap(loader.content).smoothing = true;
				}
			}
			
			if(bit is Loader) {
				if(bit.content is Bitmap) {
					Bitmap(bit.content).smoothing = true;
				}
			}
			
			holders[i].removeChild(msk);
			msk.graphics.clear();
			
			var previewTitle:PreviewTitle, masker:Sprite, pre:MasterPre;
			
			pre = MasterPre(holders[i].getChildByName("pre"));
			pre.stop();
			
			previewTitle = new PreviewTitle();
			(css) ? previewTitle.txt.styleSheet = css : null;
			previewTitle.txt.htmlText = cats[i].title;
			previewTitle.txt.height = previewTitle.txt.textHeight + 10;
			
			holders[i].myX = MyTitle.setUp(i, bit, holders[i], previewTitle, addHit);
			holders[i].containsPrev = true;
			
			masker = getMask();
			masker.mouseChildren = false;
			masker.name = "mainMask";
			loader.mask = masker;
			holders[i].addChild(masker);
			
		}
		
		// adds mouse click event to a section after it's loaded in
		private function addHit(i:int):void {
			
			var hit:Sprite = new Sprite();
			hit.graphics.beginFill(0x000000);
			hit.graphics.drawRect(0, 0, bw, bh);
			hit.graphics.endFill();
			hit.alpha = 0;
			hit.name = "hit";
			
			if(!transitioning) {
				hit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				hit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				hit.addEventListener(MouseEvent.CLICK, thumbClick, false, 0, true);
				hit.buttonMode = true;
				(sectionOn) ? TweenMax.to(hit, 1, {alpha: 0.7, ease: Quint.easeOut}) : null;
			}
			else {
				TweenMax.to(hit, 1, {alpha: 0.7, ease: Quint.easeOut});
			}
			
			hit.mouseChildren = false;
				
			holders[i].addChild(hit);
			holders[i].hasHit = true;
			
		}
		
		// firs when a video has loaded in as a section's main slide
		private function recVid(w:int, h:int, vid:Sprite, bite:BitmapData, i:int):void {
			
			var bitData:BitmapData = bite.clone();
			var bit:Bitmap = new Bitmap(bitData), iMask:Sprite;
			
			originals[i] = vid;
			
			iMask = getMask();
			iMask.scaleY = 0;
			vid.mask = iMask;
			holders[i].addChild(iMask);
			
			vid.visible = true;
			TweenMax.to(iMask, 0.75, {scaleY: 1, ease: Quint.easeOut, onCompleteParams: [i, vid, bit, iMask], onComplete: removeMasker});
			
			testCount();
			
		}
		
		// fires when an image has loaded in as a sections main slide
		private function loaded(i:int, loader1:Loader, loader2:Loader = null):void {
			
			loaders.splice(i, 1);
			
			originals[i] = loader1;
			
			holders[i].addChildAt(loader1, 2);
			holders[i].setChildIndex(holders[i].getChildByName("whiteBG"), 0);
			
			var iMask:Sprite = getMask();
			iMask.name = "iMask";
			iMask.scaleY = 0;
			loader1.mask = iMask;
			holders[i].addChild(iMask);
			
			TweenMax.to(iMask, 0.75, {scaleY: 1, ease: Quint.easeOut, onCompleteParams: [i, loader1, loader2, iMask], onComplete: removeMasker});
			
			testCount();
			
		}
		
		// mouse over event for section item
		private function over(event:MouseEvent):void {
			
			var par:Sprite = Sprite(event.currentTarget.parent);
			
			var i:int = par.numChildren;
			
			while(i--) {
				
				if(par.getChildAt(i).name == "master") {
					
					var myScaler:Sprite, scaleThis:Sprite;
					
					myScaler = Sprite(par.getChildByName("master"));
					scaleThis = Sprite(myScaler.getChildByName("black"));
					
					TweenMax.to(scaleThis, 0.5, {scaleX: 1, ease: Quint.easeOut});
					
					break;
					
				}
			}
			
			(sectionOn) ? TweenMax.to(event.currentTarget, 1, {alpha: 0, ease: Quint.easeOut}) : null;
			
		}
		
		// mouse out event for section slide
		private function out(event:MouseEvent):void {
			
			var par:Sprite = Sprite(event.currentTarget.parent);
			
			var i:int = par.numChildren;
			
			while(i--) {
				
				if(par.getChildAt(i).name == "master") {
					
					var myScaler:Sprite, scaleThis:Sprite;
					
					myScaler = Sprite(par.getChildByName("master"));
					scaleThis = Sprite(myScaler.getChildByName("black"));
					
					TweenMax.to(scaleThis, 0.5, {scaleX: 0, ease: Quint.easeOut});
					
					break;
					
				}
				
			}
			
			(sectionOn) ? TweenMax.to(event.currentTarget, 1, {alpha: 0.7, ease: Quint.easeOut}) : null;
			
		}
		
		// called from the Q when the module is ready to be displayed
		public function getSized():void {
			
			Tracker.moduleW = bw;
			Tracker.moduleH = total * (bh + 16);
			(Tracker.template) ? Tracker.template.posModule(null, false, false, true) : null;
			
			ripHolders();
			
		}
		
		// sets up the main holders for the sections
		private function ripHolders():void {
			
			var holder:MySprite, bg:Shape, pre:MasterPre;
			
			for(var j:int = 0; j < total; j++) {
				
				holder = new MySprite(j);
				holder.y = counter;
				holders[j] = holder;
				
				bg = getShape();
				bg.name = "whiteBG";
				bg.alpha = 0.5;
				
				pre = new MasterPre();
				pre.name = "pre";
				pre.x = (((bw >> 1) + 0.5) | 0) - 35;
				pre.y = (((bh >> 1) + 0.5) | 0) - 3;
				pre.mouseEnabled = false;
				pre.mouseChildren = false;
				
				holder.addChild(bg);
				holder.addChild(pre);
				master.addChild(holder);
					
				storeY[j] = counter;
				counter += theDif;
					
			}
			
			upper = new MyArrow(arrowClick, true);
			downer = new MyArrow(arrowClick);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
			
			upper.x = 14;
			upper.y = 16;
			downer.y = 32;			
			upper.rotation = 180;
			
			aHolder = new Sprite();
			aHolder.mouseEnabled = false;
			aHolder.x = bw + 48;
			
			aHolder.addChild(upper);
			aHolder.addChild(downer);
			aHolder.alpha = 0;
			sh = stage.stageHeight;
			sw = stage.stageWidth;
			aHolder.y = sh - 73;
			
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			
			addChild(aHolder);
			TweenMax.to(aHolder, 1, {alpha: 1, ease: Quint.easeOut});
			
			master.scaleX = 0;
			masterTween = true;
			TweenMax.to(master, 0.5, {scaleX: 1, ease: Quint.easeOut, onComplete: setUp});
			
		}
		
		private function onMouse(event:MouseEvent):void {
			
			if(event.delta > 0) {
				
				arrowClick(true, true);
				
			}
			
			else {
				
				arrowClick(false, true);
				
			}
			
		}
		
		// loads in a section's content
		private function setUp(i:int = 0):void {
			
			masterTween = false;
			
			if(cats[i].item[0].video == undefined) {
					
				var loader:MyLoader = new MyLoader(loaded, i);
				loader.loadIt(cats[i].item[0].large, true);
				loaders[i] = loader;
					
			}
				
			else {
					
				var video:SingleVideo = new SingleVideo(cats[i].item[0].video, cats[i].item[0].large, 1, 3, recVid, i);
				holders[i].containsVid = true;
				holders[i].vid = video;
				holders[i].autoStart = convert(cats[i].item[0].autoStartVideo);
				video.visible = false;

				holders[i].addChildAt(video, 2);
				holders[i].setChildIndex(holders[i].getChildByName("whiteBG"), 0);
					
			}
				
		}

		// fires when the CSS file has loaded
		private function cssLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			css = new StyleSheet();
			css.parseCSS(event.target.data);
			
			myText1.setUp(css);
			myText2.setUp(css);

			if(Tracker.template) {			
				Tracker.swfIsReady = true;
			}
			else {
				ripHolders();
			}
			
			cssOpen = false;
			cssLoader = null;
			
		}
		
		// fires when the xml file has loaded
		private function xmlLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, xmlLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var xml:XML = new XML(event.target.data), useStyle:Boolean;
			
			bw = xml.settings.largeWidth;
			bh = xml.settings.largeHeight;
			totalB = bw + 16;
			totalH = bh + 16;
			
			halfH = bh >> 1;

			cats = xml.category;			
			
			total = cats.length();
			iTotal = total - 1;
			totalHeight = totalH * total;
			
			useStyle = convert(xml.settings.useStyleSheet);
			
			tHolder1 = new Sprite();
			tHolder1.mouseEnabled = false;
			tHolder1.y = bh + 16;
			
			tHolder2 = new Sprite();
			tHolder2.mouseEnabled = false;
			tHolder2.y = bh + 16;
			
			myText1 = new MyText1(tHolder1, bw, bh, bigClick);
			myText2 = new MyText2(tHolder2, bw, bh, bigClick);
			
			tHolder1.addChild(myText1);
			tHolder2.addChild(myText2);
			
			tMask1 = new MyGradient();
			tMask1.cacheAsBitmap = tHolder1.cacheAsBitmap = true;
			tHolder1.mask = tMask1;
			
			tMask2 = new MyGradient();
			tMask2.cacheAsBitmap = tHolder2.cacheAsBitmap = true;
			tHolder2.mask = tMask2;
			
			master = new Sprite();
			master.mouseEnabled = false;
			addChild(master);
			
			bitHolder = new Sprite();
			bitHolder.mouseEnabled = false;
			thumbMask = new ThumbMask();
			
			MyTitle.calculate(bw, bh);
			theDif = bh + 16;
			
			if(useStyle) {
				
				cssLoader = new URLLoader();
				cssLoader.addEventListener(Event.COMPLETE, cssLoaded, false, 0, true);
				cssLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				cssOpen = true;
				cssLoader.load(new URLRequest(xml.settings.styleSheetUrl));
				
			}
			else {
				
				myText1.setUp();
				myText2.setUp();
				
				if(Tracker.template) {
					Tracker.swfIsReady = true;
				}
				else {
					ripHolders();
				}
				
			}
			
			xOpen = false;
			xLoader = null;
			
		} 
		
		// fires when added to the stage
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
			
			this.mouseEnabled = false;
			
			PortTracker.home = this;
			PortTracker.stager = stage;
			ThumbLoader.kickBack = recThumbs;
			
			countUp = 0;
			isOn = 0;
			bitCount = 0;
			thumbOn = 0;
			counter = 0;
			
			holders = [];
			loaders = [];
			storeY = [];
			bites = [];
			originals = [];
			
			var xString:String;
			
			if(Tracker.template) {
				xString = Tracker.textXML;
			}
			else {
				xString = "xml/portfolio.xml";
			}
			
			xLoader = new URLLoader();
			xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			xLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
			xOpen = true;
			xLoader.load(new URLRequest(xString));
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// GARBAGE COLLECTION
		private function removed(event:Event):void {
			
			removeEventListener(Event.UNLOAD, removed);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			stage.removeEventListener(Event.RESIZE, sizer);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			
			if(xOpen) {
				
				xLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
				xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					xLoader.close();
				}
				catch(event:*){};
				
				xLoader = null;
				
			}
			
			if(cssOpen) {
				
				cssLoader.removeEventListener(Event.COMPLETE, cssLoaded);
				cssLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					cssLoader.close();
				}
				catch(event:*){};
				
				cssLoader = null;
				
			}
			
			PortTracker.kill();
			ThumbLoader.kill();
			
			if(aHolder != null) {
				
				TweenMax.killTweensOf(aHolder);
					
				upper.stop();
				downer.stop();
					
				aHolder.removeChild(upper);
				aHolder.removeChild(downer);
					
				removeChild(aHolder);
					
			}
			
			if(myText1 != null) {
				
				TweenMax.killTweensOf(master);
				TweenMax.killTweensOf(bitHolder);
				
				if(subVideo) {
					TweenMax.killTweensOf(subVideo);
				}
				
				removeChild(master);
				
				if(bLoader != null) {
					
					bLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bLoaded);
					bLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
					
					try {
						bLoader.close();
					}
					catch(event:*){};
					
				}
				
				var j:int = bites.length;
			
				while(j--) {
					
					bites[j].kill();
					bitHolder.removeChild(bites[j]);
					
				}
				
				if(oldLoader != null) {
					
					TweenMax.killTweensOf(oldLoader);
					
					if(oldLoader is Loader) {
						
						oldLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bLoaded);
						oldLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
						
						if(oldLoader.content) {
							if(oldLoader.content is Bitmap) {
								
								BitmapData(Bitmap(oldLoader.content).bitmapData).dispose();
								
							}
							
							oldLoader.unload();
						}
						
					}
					else {
						
						oldLoader.kill();
						
					}
					
				}
				
				if(prevLoader != null) {
					
					TweenMax.killTweensOf(prevLoader);
					
					if(prevLoader is Loader) {
						
						prevLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bLoaded);
						prevLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
						
						if(prevLoader.content) {
							if(prevLoader.content is Bitmap) {
								
								BitmapData(Bitmap(prevLoader.content).bitmapData).dispose();
								
							}
							
							prevLoader.unload();
						}
						
					}
					else {
						
						prevLoader.kill();
						
					}
				}
				
				if(newLoader != null) {
					
					TweenMax.killTweensOf(newLoader);
					
				}
				
				if(loaders != null) {
					
					var loadLeg:int = loaders.length;
					
					for(var jj:int = 0; jj < loadLeg; jj++) {
						
						if(loaders[jj] != null) {
							loaders[jj].kill();
						}
						
					}
					
				}
				
				while(master.numChildren) {
					
					master.removeChildAt(0);
					
				}
				
				myText1.kill();
				myText2.kill();
				
				TweenMax.killTweensOf(tMask1);
				TweenMax.killTweensOf(tMask2);
				
				tMask1.kill();
				tMask2.kill();
				
				tHolder1.removeChild(myText1);
				tHolder2.removeChild(myText2);
				
				var k:int = holders.length;
				
				while(k--) {
					
					TweenMax.killTweensOf(holders[k]);
					
					while(holders[k].numChildren) {

						TweenMax.killTweensOf(holders[k].getChildAt(0));
						
						if(holders[k].getChildAt(0) is Sprite) {
							
							Sprite(holders[k].getChildAt(0)).graphics.clear();
							
							if(holders[k].getChildAt(0).name == "hit") {
								
								TweenMax.killTweensOf(Sprite(holders[k].getChildAt(0)));

								Sprite(holders[k].getChildAt(0)).removeEventListener(MouseEvent.ROLL_OVER, over);
								Sprite(holders[k].getChildAt(0)).removeEventListener(MouseEvent.ROLL_OUT, out);
								Sprite(holders[k].getChildAt(0)).removeEventListener(MouseEvent.CLICK, thumbClick);
							
							}
							
						}
						else if(holders[k].getChildAt(0) is MovieClip) {
							
							MovieClip(holders[k].getChildAt(0)).stop();
							
						}
						
						else if(holders[k].getChildAt(0) is Shape) {
							
							Shape(holders[k].getChildAt(0)).graphics.clear();
							
						}
						
						else if(holders[k].getChildAt(0) is Loader) {
							
							Loader(holders[k].getChildAt(0)).unload();
							
						}
						
						else if(holders[k].getChildAt(0) is Bitmap) {
																	   
							BitmapData(Bitmap(holders[k].getChildAt(0)).bitmapData).dispose();
							
						}
						
						else if(holders[k].getChildAt(0) is SingleVideo) {
							
							SingleVideo(holders[k].getChildAt(0)).kill();
							
						}
						
						Cleaner.clean(holders[k].getChildAt(0));
						
						holders[k].removeChildAt(0);
						
					}
					
					myText1 = null;
					myText2 = null;
					
				}
				
			}
			
			cats = null;
			thumbList = null;
			loader = null;
			upper = null;
			downer = null;
			tMask1 = null;
			tMask2 = null;
			thumbMask = null;
			subVideo = null;
			aHolder = null;
			master = null;
			tHolder1 = null;
			tHolder2 = null;
			bitHolder = null;
			bLoader = null;
			bMask = null;
			newLoader = null;
			oldLoader = null;
			prevLoader = null;
			holders = null;
			storeY = null;
			loaders = null;
			bites = null;
			originals = null;
			css = null;
			
			
		}
		
		
    }
}








