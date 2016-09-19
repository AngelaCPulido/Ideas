package cj.qcreative.gallery {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.geom.Rectangle;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Linear;
	import cj.qcreative.DrawBlur;
	import cj.qcreative.gallery.graphics.Drawing;
	import cj.qcreative.videoplayer.SingleVideo;
	import cj.qcreative.videoplayer.VideoTracker;
	import cj.qcreative.Tracker;
	
	// this is the document class for the Gallery module
    public final class Gallery extends Sprite {
		
		// begin private vars
		private var xLoader:URLLoader,
		cssLoader:URLLoader,
		cssLoading:Boolean,
		xLoading:Boolean,
		
		xThumb:XMLList,
		xImage:XMLList,
		xText:XMLList,
		xTitle:XMLList,
		xDesc:XMLList,
		xVid:XMLList,
		
		bigLoader:Loader,
		tHolder:Sprite,
		panelMask:Sprite,
		whiteBG:Sprite,
		bigMask:Sprite,
		
		mainButtons:MainButtons,
		bigTitle:TextTitle,
		bigDesc:BigDesc,
		left:MyArrow,
		right:MyArrow,
		vid:SingleVideo,
		myPre:MasterPre,
		
		tWidth:int,
		tHeight:int,
		total:int,
		posX:int,
		posY:int,
		count:int,
		iTotal:int,
		isOn:int,
		tSpace:int,
		t2:int,
		difX:int,
		prevW:int,
		prevH:int,
		vidIndex:int,
		bigIndex:int,
		bigY:int,
		
		vidVolume:Number,
		vidBuffer:Number,
		
		numColor:String,
		numSize:String,
		
		thumbs:Array,
		loaders:Array,
		tMasks:Array,
		
		bigOn:Boolean,
		goingRight:Boolean,
		infoOn:Boolean,
		infoActivated:Boolean,
		videoOn:Boolean,
		wasPlay:Boolean,
		activated:Boolean,
		useNums:Boolean,
		
		styles:StyleSheet;
		
		private const tMargin:int = 24, descBuffer:int = 7, titleBuffer:int = 12, spacing:int = 16;
		// end private vars
		
		// begin internal vars
		internal var bigHolder:Sprite;
		// end internal vars
		
		// class constructor
		public final function Gallery() {
			
			addEventListener(Event.UNLOAD, removed, false, 0, true);
			
			(Tracker.template) ? Tracker.template.setBigOn() : null;
			
			xLoading = false;
			cssLoading = false;
			GalleryTracker.homer = this;
			
			// listen for the stage
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// fires when added to the stage
		private final function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			count = 0;
			isOn = 0;
			bigOn = false;
			infoOn = false;
			activated = false;
			infoActivated = false;
			
			var xString:String;
			
			if(Tracker.template != null) {
				xString = Tracker.textXML;
			}
			else {
				xString = "xml/images.xml";
			}
			
			// load in the xml file
			xLoader = new URLLoader();
			xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			xLoader.addEventListener(Event.COMPLETE, xLoaded, false, 0, true);
			xLoading = true;
			xLoader.load(new URLRequest(xString));
			
			addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// kill the preloader
		private function dumpShape(sh:Shape, pre:MasterPre, i:int):void {
			
			tHolder.removeChild(sh);
			sh.graphics.clear();
			
			pre.stop();
			tHolder.removeChild(pre);
			
			thumbs[i].addMouse();
			
		}
		
		// fires when a thumbnail has loaded in
		private function loaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, loaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var bit:Bitmap = Bitmap(event.target.content), sh:Shape, pre:MasterPre, i:int = event.target.loader.id;
			
			// attach the thumbnail to the thumbs array
			bit.smoothing = true;
			thumbs[i].addChild(bit);
			thumbs[i].bData = bit.bitmapData;
			tMasks[i].alpha = 1;
			thumbs[i].mask = tMasks[i];
			thumbs[i].go();
			
			sh = new Shape();
			sh.graphics.beginFill(0xFFFFFF);
			sh.graphics.drawRect(0, 0, tWidth, tHeight);
			sh.graphics.endFill();
			sh.alpha = 0.5;
			sh.x = thumbs[i].x;
			
			pre = MasterPre(thumbs[i].getChildByName("pre"));
			pre.x += sh.x;
			tHolder.addChildAt(pre, 0);
			tHolder.addChildAt(sh, 0);
			
			tMasks[i].scaleX = 0;
			TweenMax.to(tMasks[i], 0.5, {scaleX: 1, ease: Quint.easeOut, onCompleteParams: [sh, pre, i], onComplete: dumpShape});
			
			if(count == iTotal) {
				loaders = null;
			}
			else {
				count++;
			}
			
		}
		
		// load in the thumbnails
		private function loadLoaders():void {
			
			var loader:ThumbLoader;
			
			// load in each thumbnail
			for(var i:int = 0; i < total; i++) {
				
				loader = new ThumbLoader(i);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				loaders[i] = loader;
				loader.load(new URLRequest(xThumb[i]));
				
			}
			
			// add the control arrows
			left = new MyArrow();
			right = new MyArrow();
			
			left.rotation = 180;
			right.y = tHeight + 41;
			left.y = right.y + left.height - 4;
			left.alpha = right.alpha = 0;
			left.buttonMode = true;
			right.buttonMode = true;			
			left.addEventListener(MouseEvent.ROLL_OVER, aOver, false, 0, true);
			left.addEventListener(MouseEvent.ROLL_OUT, aOut, false, 0, true);
			
			right.addEventListener(MouseEvent.ROLL_OVER, aOver, false, 0, true);
			right.addEventListener(MouseEvent.ROLL_OUT, aOut, false, 0, true);
			
			left.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			right.addEventListener(MouseEvent.CLICK, rightClick, false, 0, true);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
			
			sizer();

			addChild(left);
			addChild(right);
			
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			
			TweenMax.to(left, 1, {alpha: 1, ease: Quint.easeOut});
			TweenMax.to(right, 1, {alpha: 1, ease: Quint.easeOut});
			
			(Tracker.template) ? Tracker.template.galArrows() : null;
			
		}
		
		private function onMouse(event:MouseEvent):void {
			
			if(event.delta > 0) {
				leftClick();
			}
			else {
				rightClick();
			}
			
		}
		
		// set up the module
		private function setUp():void {

			thumbs = [];
			tMasks = [];
			loaders = [];
			
			tHolder = new Sprite();
			
			var holder:ThumbHolder, masker:Shape, pre:MasterPre, bit:Bitmap, xx:int = 0;
			
			// create the main containers and preloaders
			for(var i:int = 0; i < total; i++) {
				
				masker = new Shape();
				Drawing.drawShape(masker, 0xFFFFFF, 0, 0, tWidth, tHeight);
				masker.alpha = 0.5;
				tMasks[i] = masker;
				
				pre = new MasterPre();
				pre.mouseEnabled = false;
				pre.mouseChildren = false;
				pre.name = "pre";
				pre.x = (((tWidth >> 1) + 0.5) | 0) - 35;
				pre.y = (((tHeight >> 1) + 0.5) | 0) - 3;
				
				holder = new ThumbHolder(xText[i], i, tWidth, tHeight, numColor, numSize, posX, posY, thumbClick, useNums, styles);
				holder.x = xx;
				
				holder.addChild(masker);
				holder.addChild(pre);
				
				tHolder.addChild(holder);
				
				thumbs[i] = holder;
				
				xx += tSpace;
				
			}
			
			panelMask = Drawing.drawSprite(0x000000, 0, 0, tSpace * total, tHeight);
			
			tHolder.mask = panelMask;
			
			whiteBG = Drawing.drawSprite(0xFFFFFF, 0, 0, tWidth, tHeight);
			whiteBG.alpha = 0.5;
			
			addChild(tHolder);
			addChild(panelMask);
			
			bigMask = new Sprite();
			bigHolder = new Sprite();
			bigHolder.mask = bigMask;
			GalleryTracker.myGal = bigHolder;
			
			bigTitle = new TextTitle();
			bigTitle.x = tMargin + 8;
			
			bigDesc = new BigDesc();
			bigDesc.x = tMargin + 8;
			
			if(styles != null) {
				
				bigTitle.txt.styleSheet = styles;
				bigDesc.txt.styleSheet = styles;
				
			}
			
			// create the main button controls
			mainButtons = new MainButtons(closeBig, bigInfo, bigLeft, bigRight, total);
			mainButtons.alpha = 0;
			
			// activate the blur class
			BlurDesc.makeMasks(tMargin);
			
			myPre = new MasterPre();
			myPre.mouseEnabled = false;
			myPre.mouseChildren = false;
			myPre.stop();
			
			tHolder.scaleY = 0;
			TweenMax.to(tHolder, 0.5, {scaleY: 1, ease: Quint.easeOut, onComplete: loadLoaders});
			
			Tracker.moduleW = this.width;
			Tracker.moduleH = tHeight + 16;
			
			// position the module
			(Tracker.template) ? Tracker.template.posModule(null, false, true) : null;
			
			styles = null;
			
		}
		
		// fires when the info button is clicked
		private function bigInfo(iOn:Boolean):void {
			
			infoOn = iOn;
			
			// if a video is playing
			if(videoOn) {
				
				if(iOn) {
					
					wasPlay = VideoTracker.myVid.removeControls();
					
					var isTitle:Boolean = validate(xTitle[isOn]), 
					isDesc:Boolean = validate(xDesc[isOn]), 
					dHeight:int, 
					ttHeight:int,
					rec:Rectangle,
					bitData:BitmapData,
					bit:Bitmap;
					
					if(isTitle) {
						ttHeight = bigTitle.txt.textHeight + titleBuffer;
					}
					
					if(isDesc) {
						dHeight = bigDesc.txt.textHeight + descBuffer;
					}
					
					rec = vid.getBounds(bigHolder);
					
					// we're drawing a screenshot of the video for the info blur
					bitData = new BitmapData(rec.width, rec.height, false);
					bitData.draw(vid);
					bit = new Bitmap(bitData);
					
					BlurDesc.setup(bit, isTitle, isDesc, posTitle, posDesc, rec.height, rec.width, dHeight, ttHeight);
					
					infoActivated = true;
					
				}
				
				if(iOn) {
					BlurDesc.wipe();
				}
				else {
					BlurDesc.wipe(true, true, testVid);
				}
				
			}
			
			// if a video is not playing
			else {
				
				(iOn) ? iOn = false : iOn = true;
				BlurDesc.wipe(iOn);
				
			}
			
			
		}
		
		// fires after the info has wiped out
		private function testVid():void {
			
			BlurDesc.killSwf();
			infoActivated = false;
			
			if(wasPlay) {
				VideoTracker.myVid.addControls();
			}
			else {
				VideoTracker.myVid.addControls(false);
			}
			
		}
		
		// loads in from a right click
		private function loadTheRight():void {
			
			if(infoActivated) {
				BlurDesc.killSwf();
				infoActivated = false;
			}
			
			// if we can advance to the right
			if(isOn != iTotal) {
				isOn++;
				
				addChildAt(myPre, 1);
				
				var prev2:int = ((prevH >> 1) + 0.5) | 0;
				var tBreak:int = ((prev2 - t2) + 0.5) | 0;
				
				myPre.x = (((prevW >> 1) + 0.5) | 0) - 35;
				myPre.y = prev2 - tBreak - 3;
				myPre.gotoAndPlay(1);
				
				TweenMax.to(bigMask, 0.75, {scaleX: 0, ease: Quint.easeInOut, onComplete: loadRight});
			}
		}
		
		// loads in from a left click
		private function loadTheLeft():void {
			
			if(infoActivated) {
				BlurDesc.killSwf();
				infoActivated = false;
			}
			
			// if we can advance to the left
			if(isOn != 0) {
				
				isOn--;
				
				var wSpace:int = ((iTotal - isOn) * tSpace), xx:int = tHolder.x + tSpace;
				
				(Tracker.template) ? Tracker.template.adjustBlur(wSpace) : null;
				
				addChildAt(myPre, 1);
				
				var prev2:int = ((prevH >> 1) + 0.5) | 0;
				var tBreak:int = ((prev2 - t2) + 0.5) | 0;
				
				myPre.x = (((prevW >> 1) + 0.5) | 0) - 35;
				myPre.y = prev2 - tBreak - 3;
				myPre.gotoAndPlay(1);
				
				TweenMax.to(bigHolder, 0.75, {x: prevW, ease: Quint.easeInOut});
				TweenMax.to(tHolder, 0.75, {x: xx, ease: Quint.easeInOut, onComplete: loadLeft});
				
			}
			
		}
		
		// waits for the info to wipe out before loadin in the big slide
		private function waitForInfo(event:Event):void {
			
			if(!GalleryTracker.infoWorking) {
				
				removeEventListener(Event.ENTER_FRAME, waitForInfo);
				
				if(goingRight) {
					BlurDesc.wipe(true, true, loadTheRight);
				}
				else {
					BlurDesc.wipe(true, true, loadTheLeft);
				}
				
			}
			
		}
		
		// fired when a thumbnail is clicked
		private function thumbClick(i:int):void {
			
			var j:int = total;
			
			while(j--) {
				thumbs[j].deactivate();
			}
			
			left.removeEventListener(MouseEvent.CLICK, leftClick);
			right.removeEventListener(MouseEvent.CLICK, rightClick);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			
			removeChild(left);
			removeChild(right);
			
			// if the thumbclick does not equal the current open slide
			if(isOn != i) {
				
				isOn = i;
				
				var wSpace:int = (iTotal - isOn) * tSpace;
				
				(Tracker.template) ? Tracker.template.adjustBlur(wSpace) : null;
				
				TweenMax.to(tHolder, 0.75, {x: -(isOn * tSpace), ease: Quint.easeOut, onComplete: wipeThumb});
				
			}
			else {
				wipeThumb();
			}
			
			activated = true;
			
		}
		
		// loads in a left click
		private function bigLeft():void {
			
			var i:int = total;
			
			while(i--) {
				thumbs[i].deactivate();
			}
			
			goingRight = false;
			
			// if info is displayed
			if(infoOn) {
				
				infoOn = false;
				
				if(!GalleryTracker.infoWorking) {
					BlurDesc.wipe(true, true, loadTheLeft);
				}
				else {
					addEventListener(Event.ENTER_FRAME, waitForInfo, false, 0, true);
				}
			}
			else {
				loadTheLeft();
			}
			
		}
		
		// loads in a right click
		private function bigRight():void {
			
			var i:int = total;
			
			while(i--) {
				thumbs[i].deactivate();
			}
			
			goingRight = true;
			
			// if info is displayed
			if(infoOn) {
				
				infoOn = false
				
				if(!GalleryTracker.infoWorking) {
					BlurDesc.wipe(true, true, loadTheRight);
				}
				else {
					addEventListener(Event.ENTER_FRAME, waitForInfo, false, 0, true);
				}
			}
			else {
				loadTheRight();
			}
			
		}
		
		// loads in a video from the right
		private function vidRight(w:int, h:int):void {
			
			myPre.stop();
			(this.contains(myPre)) ? removeChild(myPre) : null;
			
			bigHolder.addChild(vid);
			
			var yy:Number = t2 - (h >> 1);
			yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
			
			difX = w - tWidth;
			
			var xt:int = tHolder.x;
			var xx:int = xt + w - prevW;
			
			Drawing.updateSprite(bigMask, w, h);
			bigMask.scaleX = 1;
			bigMask.y = bigHolder.y = yy;
			
			// check if title and description are to be used
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]);
			
			// if title is to be used
			if(isTitle) {
				bigTitle.txt.width = w - (tMargin * 2) - 20;
				bigTitle.txt.htmlText = xTitle[isOn];
				bigTitle.txt.height = bigTitle.txt.textHeight + 10;
			}
			
			// if description is to be used
			if(isDesc) {
				bigDesc.txt.width = w - (tMargin * 2) - 20;
				bigDesc.txt.htmlText = xDesc[isOn];
				bigDesc.txt.height = bigDesc.txt.textHeight + 10;
			}
			
			bigHolder.x = w;
			
			(isOn != iTotal) ? thumbs[isOn + 1].activate(true) : null;
			
			mainButtons.adjustX(w);
			
			TweenMax.to(mainButtons, 0.5, {y: yy + h + 10, ease: Quint.easeOut});
			
			// if the new slide has a different size than the previous slide
			if(w != prevW || h != prevH) {
				
				var newDif:int = w - prevW;
				
				(Tracker.template) ? Tracker.template.adjustBig(w, h, yy, newDif) : null;
				
				TweenMax.to(panelMask, 0.5, {x: w + spacing, ease: Quint.easeOut});
				TweenMax.to(tHolder, 0.5, {x: xx, ease: Quint.easeOut});
				TweenMax.to(whiteBG, 0.5, {width: w, height: h, y: yy, ease: Quint.easeOut, onComplete: wipeRight});
			}
			else {
				wipeRight();
			}
			
			infoActivated = false;
			
			prevW = w;
			prevH = h;
			
		}
		
		// loads in a video form the left
		private function vidLeft(w:int, h:int):void {
			
			myPre.stop();
			(this.contains(myPre)) ? removeChild(myPre) : null;
			
			bigHolder.addChild(vid);
			
			var yy:Number = t2 - (h >> 1);
			yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
			
			difX = w - tWidth;
			
			var xt:int = tHolder.x, xx:int = xt + w - prevW;
			
			Drawing.updateSprite(bigMask, w, h);
			bigMask.scaleX = 0;
			bigMask.y = bigHolder.y = yy;
			
			// check to see if the info or description is to be used
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]);
			
			// if info is to be used
			if(isTitle) {
				bigTitle.txt.width = w - (tMargin * 2) - 20;
				bigTitle.txt.htmlText = xTitle[isOn];
			}
			
			// if description is to be used
			if(isDesc) {
				bigDesc.txt.width = w - (tMargin * 2) - 20;
				bigDesc.txt.htmlText = xDesc[isOn];
			}
			
			bigHolder.x = 0;
			
			(isOn != iTotal) ? thumbs[isOn + 1].activate(true) : null;
			
			mainButtons.adjustX(w);
			
			TweenMax.to(mainButtons, 0.5, {y: yy + h + 10, ease: Quint.easeOut});
			
			// if the new slide has a different size than the previous slide
			if(w != prevW || h != prevH) {
				
				var newDif:int = w - prevW;
				
				(Tracker.template) ? Tracker.template.adjustBig(w, h, yy, newDif) : null;
				
				TweenMax.to(panelMask, 0.5, {x: w + spacing, ease: Quint.easeOut});
				TweenMax.to(tHolder, 0.5, {x: xx, ease: Quint.easeOut});
				TweenMax.to(whiteBG, 0.5, {width: w, height: h, y: yy, ease: Quint.easeOut, onComplete: wipeLeft});
			}
			else {
				wipeLeft();
			}
			
			infoActivated = false;
			
			prevW = w;
			prevH = h;
			
		}
		
		// fires when the loader has completed
		private function leftLoaded(loader:Loader, w:int, h:int, secLoader:Loader = null):void {
			
			myPre.stop();
			(this.contains(myPre)) ? removeChild(myPre) : null;
			
			bigLoader = loader;
			bigHolder.addChild(bigLoader);
			
			var yy:Number = t2 - (h >> 1);
			yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
			
			difX = w - tWidth;
			
			var xt:int = tHolder.x, xx:int = xt + w - prevW;
			
			Drawing.updateSprite(bigMask, w, h);
			bigMask.scaleX = 0;
			bigMask.y = bigHolder.y = yy;
			
			// check to see if the info or description is to be used
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]), dHeight:int, ttHeight:int;
			
			// if info is to be used
			if(isTitle) {
				bigTitle.txt.width = w - (tMargin * 2) - 20;
				bigTitle.txt.htmlText = xTitle[isOn];
				ttHeight = bigTitle.txt.textHeight;
				bigTitle.txt.height = ttHeight + 10;
				ttHeight += titleBuffer;
			}
			
			// if description is to be used
			if(isDesc) {
				bigDesc.txt.width = w - (tMargin * 2) - 20;
				bigDesc.txt.htmlText = xDesc[isOn];
				dHeight = bigDesc.txt.textHeight;
				bigDesc.txt.height = dHeight + 10;
				dHeight += descBuffer;
			}
			
			if(secLoader != null) {
				BlurDesc.setup(secLoader, isTitle, isDesc, posTitle, posDesc, h, w, dHeight, ttHeight);
			}
			
			bigHolder.x = 0;
			
			mainButtons.adjustX(w);
			
			(isOn != iTotal) ? thumbs[isOn + 1].activate(true) : null;
			
			TweenMax.to(mainButtons, 0.5, {y: yy + h + 10, ease: Quint.easeOut});
			
			// if the new slide has a different size than the previous slide
			if(w != prevW || h != prevH) {
				
				var newDif:int = w - prevW;
				
				(Tracker.template) ? Tracker.template.adjustBig(w, h, yy, newDif) : null;
				
				TweenMax.to(tHolder, 0.5, {x: xx, ease: Quint.easeOut});
				TweenMax.to(panelMask, 0.5, {x: w + spacing, ease: Quint.easeOut});
				TweenMax.to(whiteBG, 0.5, {width: w, height: h, y: yy, ease: Quint.easeOut, onComplete: wipeLeft});
			}
			else {
				wipeLeft();
			}
			
			prevW = w;
			prevH = h;
			
		}
		
		// fires when the loader has completed
		private function rightLoaded(loader:Loader, w:int, h:int, secLoader:Loader = null):void {
			
			myPre.stop();
			(this.contains(myPre)) ? removeChild(myPre) : null;
			
			bigLoader = loader;
			bigHolder.addChild(bigLoader);
			
			var yy:Number = t2 - (h >> 1);
			yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
			
			difX = w - tWidth;
			
			var xt:int = tHolder.x, xx:int = xt + w - prevW;
			
			Drawing.updateSprite(bigMask, w, h);
			bigMask.scaleX = 1;
			bigMask.y = bigHolder.y = yy;
			
			// check to see if the info or description is to be used
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]), dHeight:int, ttHeight:int;
			
			// if info is to be used
			if(isTitle) {
				bigTitle.txt.width = w - (tMargin * 2) - 20;
				bigTitle.txt.htmlText = xTitle[isOn];
				ttHeight = bigTitle.txt.textHeight;
				bigTitle.txt.height = ttHeight + 10;
				ttHeight += titleBuffer;
			}
			
			// if description is to be used
			if(isDesc) {
				bigDesc.txt.width = w - (tMargin * 2) - 20;
				bigDesc.txt.htmlText = xDesc[isOn];
				dHeight = bigDesc.txt.textHeight;
				bigDesc.txt.height = dHeight + 10;
				dHeight += descBuffer;
			}
			
			if(secLoader != null) {
				BlurDesc.setup(secLoader, isTitle, isDesc, posTitle, posDesc, h, w, dHeight, ttHeight);
			}
			
			bigHolder.x = w;
			
			mainButtons.adjustX(w);
			
			(isOn != iTotal) ? thumbs[isOn + 1].activate(true) : null;
			
			TweenMax.to(mainButtons, 0.5, {y: yy + h + 10, ease: Quint.easeOut});
			
			// if the new slide has a different size than the previous slide
			if(w != prevW || h != prevH) {
				
				var newDif:int = w - prevW;
				
				(Tracker.template) ? Tracker.template.adjustBig(w, h, yy, newDif) : null;
				
				TweenMax.to(tHolder, 0.5, {x: xx, ease: Quint.easeOut});
				TweenMax.to(panelMask, 0.5, {x: w + spacing, ease: Quint.easeOut});
				TweenMax.to(whiteBG, 0.5, {width: w, height: h, y: yy, ease: Quint.easeOut, onComplete: wipeRight});
			}
			else {
				wipeRight();
			}
			
			prevW = w;
			prevH = h;
			
		}
		
		// remove the resize function when a video goes full screen
		public function removeSize():void {
			stage.removeEventListener(Event.RESIZE, sizer);
		}
		
		public function addSize(boo:Boolean):void {
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			sizer();
		}
		
		// called from a video full screen event
		public function fs(goFull:Boolean = false):void {
			
			// if we're going full screen video
			if(goFull) {
				bigY = bigHolder.y;
				bigHolder.y = 0;
				vidIndex = bigHolder.getChildIndex(vid);
				bigIndex = getChildIndex(bigHolder);
				bigHolder.mask = null;
				bigHolder.setChildIndex(vid, bigHolder.numChildren - 1);
				setChildIndex(bigHolder, numChildren - 1);
			}
			
			// full screen video deactivated
			else {
				bigHolder.y = bigY;
				bigHolder.mask = bigMask;
				bigHolder.setChildIndex(vid, vidIndex);
				setChildIndex(bigHolder, bigIndex);
				stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			}
			
			(Tracker.template) ? Tracker.template.fixFull(goFull) : null;
		}
		
		// called when the thumb is to return to its normal size
		private function wipeBack():void {
			
			panelMask.x = 0;
			TweenMax.to(tMasks[isOn], 0.75, {x: 0, ease: Quint.easeInOut, onComplete: releaseButtons});
			
		}
		
		// utility string to boolean function
		private function validate(st:String):Boolean {
			
			if(st != "") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// positions the title text field
		private function posTitle(i:int, hold:Sprite, changer:Boolean = false):void {
			
			bigTitle.y = i + 5;
			
			if(!changer) {
				hold.addChild(bigTitle);
				bigTitle.visible = true;
			}
			else {
				bigTitle.visible = false;
			}
			
		}
		
		// positions the description text field
		private function posDesc(i:int, hold:Sprite, changer:Boolean = false):void {
			
			bigDesc.y = i + 5;
			
			if(!changer) {
				hold.addChild(bigDesc);
				bigDesc.visible = true;
			}
			else {
				bigDesc.visible = false;
			}
			
		}
		
		// wipes the mask out to the left
		private function wipeLeft():void {
			
			if(!videoOn) {
				(Tracker.template) ? Tracker.template.checkMusic(true) : null;
			}
			else {
				(Tracker.template) ? Tracker.template.checkMusic(false) : null;
			}
			
			TweenMax.to(bigMask, 0.75, {scaleX: 1, ease: Quint.easeInOut, onComplete: mainButtons.activeClick});
			
			mainButtons.updateText(isOn);
			
		}
		
		// wipes the mask out to the right
		private function wipeRight():void {
			
			if(!videoOn) {
				(Tracker.template) ? Tracker.template.checkMusic(true) : null;
			}
			else {
				(Tracker.template) ? Tracker.template.checkMusic(false) : null;
			}
			
			var wSpace:int = ((iTotal - isOn) * tSpace), tx:Number = Math.floor(tHolder.x);

			(Tracker.template) ? Tracker.template.adjustBlur(wSpace) : null;
			
			TweenMax.to(bigHolder, 0.75, {x: 0, ease: Quint.easeInOut});
			
			TweenMax.to(tHolder, 0.75, {x: tx - tSpace, ease: Quint.easeInOut, onComplete: mainButtons.activeClick});
			
			mainButtons.updateText(isOn);
			
		}

		// closes a big item
		private function closeBig():void {
			
			(isOn != iTotal) ? thumbs[isOn + 1].deactivate() : null;
			TweenMax.to(mainButtons, 0.75, {alpha: 0, ease: Quint.easeInOut});
			TweenMax.to(bigMask, 0.75, {scaleX: 0, ease: Quint.easeInOut, onComplete: goSmall});
			
		}
		
		// resets everything to original thumbnail state
		private function goSmall():void {

			if(infoActivated) {
				BlurDesc.killSwf();
				infoActivated = false;
			}
			
			bigOn = false;
			infoOn = false;
			
			bigMask.graphics.clear();
			
			// if slide is not a video
			if(!videoOn) {
				bigHolder.removeChild(bigLoader);
					
				if(bigLoader.content) {
				
					if(bigLoader.content is Bitmap) {
						BitmapData(Bitmap(bigLoader.content).bitmapData).dispose();
					}
					bigLoader.unload();
				
				}
				
				bigLoader = null;
				
			}
			
			// if slide is a video
			else {
				
				(Tracker.template) ? Tracker.template.checkMusic(true) : null;
				vid.kill();
				bigHolder.removeChild(vid);
				vid = null;
				videoOn = false;
				
			}
			
			removeChild(bigHolder);
			removeChild(bigMask);
			removeChild(mainButtons);
			
			var xx:int = panelMask.x;
			
			var xt:int = -(isOn * tSpace);
			
			var i:int = total;
			
			// adjust mask width
			while(i--) {
				(i != isOn) ? tMasks[i].x = 0 : tMasks[i].x = tWidth;
			}
			
			(Tracker.template) ? Tracker.template.adjustSmall(difX) : null;
			
			TweenMax.to(tHolder, 0.5, {x: xt, ease: Quint.easeOut});
			TweenMax.to(panelMask, 0.5, {x: xx - difX, ease: Quint.easeOut, onComplete: wipeBack});
			TweenMax.to(whiteBG, 0.5, {width: tWidth, height: tHeight, y: 0, ease: Quint.easeOut});
			
		}
		
		// activates the main arrows after an item close
		private function releaseButtons():void {
			
			removeChild(whiteBG);
			
			// add mouse events
			left.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			right.addEventListener(MouseEvent.CLICK, rightClick, false, 0, true);
			
			// add mouse wheel event
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse, false, 0, true);
			
			left.alpha = 0;
			right.alpha = 0;
			
			addChild(left);
			addChild(right);
			
			TweenMax.to(left, 1, {alpha: 1, ease: Quint.easeOut});
			TweenMax.to(right, 1, {alpha: 1, ease: Quint.easeOut});
			
			var j:int = total;
			
			// activate thumb mouse events
			while(j--) {
				thumbs[j].activate();
			}
			
		}
		
		// wipes a big item in
		private function wipeBig(i:int):void {
			
			bigHolder.addChild(bigLoader);
			addChild(bigHolder);
			addChild(bigMask);
			addChild(mainButtons);
			
			var j:int = bigHolder.numChildren, count:int = 0;
			
			// tests to make sure objects exist and sets child index
			while(j--) {
				if(bigHolder.getChildAt(j).name == "iMask" || bigHolder.getChildAt(j).name == "master") {
					
					bigHolder.setChildIndex(bigHolder.getChildAt(j), bigHolder.numChildren - 1);
					count++
					
					if(count == 2) {
						break;
					}
					
				}
			}
			
			panelMask.x = i + spacing;
			
			TweenMax.to(mainButtons, 1, {alpha: 1, ease: Quint.easeInOut});
			TweenMax.to(bigMask, 0.75, {scaleX: 1, ease: Quint.easeInOut});
			
			tMasks[isOn].x = 0;

		}
		
		// loads a left item
		private function loadLeft():void {
			
			// if current slide is not video
			if(!videoOn) {
				bigHolder.removeChild(bigLoader);
					
				if(bigLoader.content) {
				
					if(bigLoader.content is Bitmap) {
						BitmapData(Bitmap(bigLoader.content).bitmapData).dispose();
					}
					bigLoader.unload();
				
				}
				
				bigLoader = null;
				
			}
			
			// if current slide is video
			else {
				
				vid.kill();
				bigHolder.removeChild(vid);
				vid = null;
				videoOn = false;
				
			}
			
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]);
			
			(isTitle || isDesc) ? infoActivated = true : infoActivated = false;
			
			// adjusts buttons if info is being used
			if(infoActivated) {
				mainButtons.adjustInfo();
			}
			else {
				mainButtons.adjustInfo(true);
			}
			
			// grabs the file extention
			var st:String = xImage[isOn];
			st = st.substr(st.length - 3, st.length);
			
			// checks to see if a video is to be played
			if(st == "flv" || st == "mp4" || st == "f4v" || st == "f4p") {
				videoOn = true;
				vid = new SingleVideo(xImage[isOn], xVid[isOn], vidVolume, vidBuffer, vidLeft);
				vid.added();
			}
			else {
				videoOn = false;
				MainLoader.loadIt(xImage[isOn], leftLoaded, infoActivated);
			}
			
		}
		
		// loads a right item
		private function loadRight():void {
			
			// if current slide is not a video
			if(!videoOn) {
				bigHolder.removeChild(bigLoader);
					
				if(bigLoader.content) {
				
					if(bigLoader.content is Bitmap) {
						BitmapData(Bitmap(bigLoader.content).bitmapData).dispose();
					}
					bigLoader.unload();
				
				}
				
				bigLoader = null;
				
			}
			
			// if current slide is a video
			else {
				
				vid.kill();
				bigHolder.removeChild(vid);
				vid = null;
				videoOn = false;
				
			}
			
			// check to see if info is to be used
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]);
			
			(isTitle || isDesc) ? infoActivated = true : infoActivated = false;
			
			if(infoActivated) {
				mainButtons.adjustInfo();
			}
			else {
				mainButtons.adjustInfo(true);
			}
			
			// grab the file extention
			var st:String = xImage[isOn];
			st = st.substr(st.length - 3, st.length);
			
			// if slide is a video
			if(st == "flv" || st == "mp4" || st == "f4v" || st == "f4p") {
				videoOn = true;
				vid = new SingleVideo(xImage[isOn], xVid[isOn], vidVolume, vidBuffer, vidRight);
				vid.added();
			}
			
			// if slide is not a video
			else {
				videoOn = false;
				MainLoader.loadIt(xImage[isOn], rightLoaded, infoActivated);
			}
			
		}
		
		// fired on first big load
		private function bigLoaded(loader:Loader, w:int, h:int, secLoader:Loader = null):void {
			
			myPre.stop();
			(this.contains(myPre)) ? removeChild(myPre) : null;
			
			bigOn = true;
			
			bigLoader = loader;
			
			prevW = w;
			prevH = h;
			
			var yy:Number = t2 - (h >> 1);
			yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
			
			difX = w - tWidth;
			
			var xx:int;
			xx = tHolder.x;
			
			// update the main mask
			Drawing.updateSprite(bigMask, w, h);
			bigMask.scaleX = 0;
			bigMask.y = bigHolder.y = yy;
			
			// check for title and description
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]), dHeight:int, ttHeight:int;
			
			// check for info title
			if(isTitle) {
				bigTitle.txt.width = w - (tMargin * 2) - 20;
				bigTitle.txt.htmlText = xTitle[isOn];
				ttHeight = bigTitle.txt.textHeight;
				bigTitle.txt.height = ttHeight + 10;
				ttHeight += titleBuffer;
			}
			
			// check for description title
			if(isDesc) {
				bigDesc.txt.width = w - (tMargin * 2) - 20;
				bigDesc.txt.htmlText = xDesc[isOn];
				dHeight = bigDesc.txt.textHeight;
				bigDesc.txt.height = dHeight + 10;
				dHeight += descBuffer;
			}
			
			if(secLoader != null) {
				BlurDesc.setup(secLoader, isTitle, isDesc, posTitle, posDesc, h, w, dHeight, ttHeight);
			}
			
			mainButtons.y = yy + h + 10;
			mainButtons.activate(w, isOn);
			
			// activate next thumb mouse events
			(isOn != iTotal) ? thumbs[isOn + 1].activate(true) : null;
			
			(Tracker.template) ? Tracker.template.adjustBig(w, h, yy, difX) : null;
			
			TweenMax.to(tHolder, 0.5, {x: xx + difX, ease: Quint.easeOut});
			TweenMax.to(panelMask, 0.5, {x: difX, ease: Quint.easeOut, onCompleteParams: [w], onComplete: wipeBig});
			TweenMax.to(whiteBG, 0.5, {width: w, height: h, y: yy, ease: Quint.easeOut});
			
		}
		
		// calls the first big loader
		private function loadBig():void {
			
			// check fro info title and desceription
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]);
			
			(isTitle || isDesc) ? infoActivated = true : infoActivated = false;
			
			if(infoActivated) {
				mainButtons.adjustInfo();
			}
			else {
				mainButtons.adjustInfo(true);
			}
			
			// grab file extention
			var st:String = xImage[isOn];
			st = st.substr(st.length - 3, st.length);
			
			// if slide is a video
			if(st == "flv" || st == "mp4" || st == "f4v" || st == "f4p") {
				videoOn = true;
				vid = new SingleVideo(xImage[isOn], xVid[isOn], vidVolume, vidBuffer, setVideo);
				vid.added();
			}
			
			// if slide is not a video
			else {
				videoOn = false;
				MainLoader.loadIt(xImage[isOn], bigLoaded, infoActivated);
			}
			
		}
		
		// fires after the video is ready to be displayed
		private function setVideo(w:int, h:int):void {
			
			myPre.stop();
			(this.contains(myPre)) ? removeChild(myPre) : null;
			
			bigOn = true;
			
			prevW = w;
			prevH = h;
			
			// get the new y position
			var yy:Number = t2 - (h >> 1);
			yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
			
			difX = w - tWidth;
			
			var xx:int;
			xx = tHolder.x;
			
			Drawing.updateSprite(bigMask, w, h);
			bigMask.scaleX = 0;
			bigMask.y = bigHolder.y = yy;
			
			// check for title and description
			var isTitle:Boolean = validate(xTitle[isOn]), isDesc:Boolean = validate(xDesc[isOn]);
			
			// if title is to be used
			if(isTitle) {
				bigTitle.txt.width = w - (tMargin * 2) - 20;
				bigTitle.txt.htmlText = xTitle[isOn];
				bigTitle.txt.height = bigTitle.txt.textHeight + 10;
			}
			
			// if description is to be used
			if(isDesc) {
				bigDesc.txt.width = w - (tMargin * 2) - 20;
				bigDesc.txt.htmlText = xDesc[isOn];
				bigDesc.txt.height = bigDesc.txt.textHeight + 10;
			}
			
			mainButtons.y = yy + h + 10;
			mainButtons.activate(w, isOn);
			
			// activate next thumb mouse events
			(isOn != iTotal) ? thumbs[isOn + 1].activate(true) : null;
			
			(Tracker.template) ? Tracker.template.adjustBig(w, h, yy, difX) : null;
			
			TweenMax.to(tHolder, 0.5, {x: xx + difX, ease: Quint.easeOut});
			TweenMax.to(panelMask, 0.5, {x: difX, ease: Quint.easeOut, onCompleteParams: [w], onComplete: wipeVid});
			TweenMax.to(whiteBG, 0.5, {width: w, height: h, y: yy, ease: Quint.easeOut});
			
		}
		
		// wipes the video in
		private function wipeVid(i:int):void {
			
			(Tracker.template) ? Tracker.template.checkMusic(false) : null;
			
			bigHolder.addChild(vid);
			addChild(bigHolder);
			addChild(bigMask);
			addChild(mainButtons);

			panelMask.x = i + spacing;
			
			TweenMax.to(mainButtons, 1, {alpha: 1, ease: Quint.easeInOut});
			TweenMax.to(bigMask, 0.75, {scaleX: 1, ease: Quint.easeInOut});
			
			tMasks[isOn].x = 0;

		}
		
		// wipes the thumb in
		private function wipeThumb():void {
			
			addChildAt(myPre, 0);
			addChildAt(whiteBG, 0);
			
			myPre.x = (((tWidth >> 1) + 0.5) | 0) - 35;
			myPre.y = (((tHeight >> 1) + 0.5) | 0) - 3;
			myPre.gotoAndPlay(1);
			
			TweenMax.to(tMasks[isOn], 0.75, {x: tWidth, ease: Quint.easeInOut, onComplete: loadBig});
			
		}
		
		// left arrow click
		private function leftClick(event:MouseEvent = null):void {
			
			if(isOn != 0) {
				isOn--;
				
				var wSpace:int = (iTotal - isOn) * tSpace;
				
				(Tracker.template) ? Tracker.template.adjustBlur(wSpace) : null;
				
				TweenMax.to(tHolder, 0.75, {x: -(isOn * tSpace), ease: Quint.easeOut});
				
			}

		}
		
		// right arrow click
		private function rightClick(event:MouseEvent = null):void {
			
			if(isOn != iTotal) {
				isOn++;
				
				var wSpace:int = (iTotal - isOn) * tSpace;

				(Tracker.template) ? Tracker.template.adjustBlur(wSpace) : null;
				
				TweenMax.to(tHolder, 0.75, {x: -(isOn * tSpace), ease: Quint.easeOut});
				
			}

		}
		
		// arrow over mouse event
		private function aOver(event:MouseEvent):void {
			event.currentTarget.gotoAndPlay("over");
		}
		
		// arrow out mouse event
		private function aOut(event:MouseEvent):void {
			event.currentTarget.gotoAndPlay("out");
		}
		
		// stage resize function
		public function sizer(event:Event = null):void {
			
			var sw:int = stage.stageWidth - 282;
			
			left.x = sw - 48;
			right.x = sw - 25;
			
		}
		
		// called from the Q when the module is ready to be activated
		public function getSized():void {

			setUp();
			
		}
		
		// fires when the css file has loaded in
		private function cssLoaded(event:Event):void {
			
			cssLoading = false;
			
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			
			styles = new StyleSheet();
			styles.parseCSS(event.target.data);
			
			// if module is being loaded into the Q
			if(Tracker.template) {
				Tracker.swfIsReady = true;
			}
			else {
				setUp();
			}
			
			cssLoader = null;
			
		}
		
		// converts a string to a boolean
		private function convert(st:String):Boolean {
			if(st.toLowerCase() == "true") {
				return true;
			}
			else {
				return false;
			}
		}
		
		// fires when an xml file has loaded in
		private final function xLoaded(event:Event):void {
			
			xLoading = false;
			
			event.target.removeEventListener(Event.COMPLETE, xLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var xml:XML = new XML(event.target.data);
			
			// grab xml properties
			tWidth = xml.settings.thumbWidth;
			tHeight = xml.settings.thumbHeight;
			tSpace = tWidth + spacing;
			t2 = (tHeight >> 1) | 0;
			
			Tracker.galSpace = spacing;
			Tracker.galThumbW = tSpace;
			
			useNums = convert(xml.settings.useNumbers);
			numSize = xml.settings.numberSize;
			posX = int(xml.settings.numberX);
			posY = int(xml.settings.numberY);
			
			// grab the number color
			numColor = xml.settings.numberColor.toString();
			
			var i:int = numColor.search("#");
			
			(i != -1) ? numColor = numColor.substr(1, 6) : null;
			
			vidVolume = Number(xml.settings.videoVolume) * .01;
			vidBuffer = Number(xml.settings.videoBuffering);
			
			// write the xml lists
			xThumb = xml.item.thumbURL;
			xText = xml.item.thumbDescription;
			xImage = xml.item.largeURL;
			
			xTitle = xml.item.largeTitle;
			xDesc = xml.item.largeDescription;
			xVid = xml.item.videoImage;
			
			total = xml.item.length();
			iTotal = total - 1;
			Tracker.totalGal = tSpace * iTotal;
			
			var useCSS:Boolean = convert(xml.settings.useStyleSheet);
			
			// if css file should be loaded
			if(useCSS) {
				cssLoader = new URLLoader();
				cssLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				cssLoader.addEventListener(Event.COMPLETE, cssLoaded, false, 0, true);
				cssLoading = true;
				cssLoader.load(new URLRequest(xml.settings.cssURL));
			}
			
			// if no css file is being used
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
			
			// remove event listeners
			removeEventListener(Event.UNLOAD, removed);
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.ENTER_FRAME, waitForInfo);
			stage.removeEventListener(Event.RESIZE, sizer);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
			
			// if xml file is still loading
			if(xLoading && xLoader) {
				xLoader.removeEventListener(Event.COMPLETE, xLoaded);
				xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				xLoader.close();
				xLoader = null;
			}
			
			// if css file is still loading
			if(cssLoading && cssLoader) {
				cssLoader.removeEventListener(Event.COMPLETE, cssLoaded);
				cssLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				cssLoader.close();
				cssLoader = null;
			}
			
			MainLoader.kill();
			
			// if big loader is loading
			if(bigLoader != null) {
				
				if(bigLoader.content) {
				
					if(bigLoader.content is Bitmap) {
						BitmapData(Bitmap(bigLoader.content).bitmapData).dispose();
					}
					bigLoader.unload();
					
				}
					
				bigLoader = null;
					
			}
			
			// if a video is playing
			if(vid != null) {
				vid.kill();
				vid = null;
			}
			
			// check to see if thumbnails are still loading
			if(loaders != null) {
				
				var i:int = loaders.length;
				
				while(i--) {
				
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
					
					try {
						loaders[i].close();
					}
					catch(event:*){};
					
					if(loaders[i].content) {
						
						BitmapData(Bitmap(loaders[i].content).bitmapData).dispose();
						
						try {
							loaders[i].unload();
						}
						catch(event:*){};
					}
					
				}
				
				loaders = null;
				
			}
			
			// remove all children
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			// if thumbnail array exists
			if(thumbs != null) {
				
				myPre.stop();
				
				if(left != null) {
				
					TweenMax.killTweensOf(left);
					TweenMax.killTweensOf(right);
					
					left.removeEventListener(MouseEvent.ROLL_OVER, aOver);
					left.removeEventListener(MouseEvent.ROLL_OUT, aOut);
					right.removeEventListener(MouseEvent.ROLL_OVER, aOver);
					right.removeEventListener(MouseEvent.ROLL_OUT, aOut);
					left.removeEventListener(MouseEvent.CLICK, leftClick);
					right.removeEventListener(MouseEvent.CLICK, rightClick);
					
					left.stop();
					right.stop();
					
					left.removeChildAt(0);
					left.removeChildAt(0);
					
					right.removeChildAt(0);
					right.removeChildAt(0);
					
				}
				
				// kill all tweens
				TweenMax.killTweensOf(bigMask);
				TweenMax.killTweensOf(bigHolder);
				TweenMax.killTweensOf(tHolder);
				TweenMax.killTweensOf(panelMask);
				TweenMax.killTweensOf(whiteBG);
				TweenMax.killTweensOf(mainButtons);
				TweenMax.killTweensOf(mainButtons);
				
				var j:int = thumbs.length;
				
				while(j--) {
					
					thumbs[j].kill();
					tHolder.removeChild(thumbs[j]);
					
					TweenMax.killTweensOf(tMasks[j]);
					tMasks[j].graphics.clear();
					
				}
				
				while(panelMask.numChildren) {
					
					Shape(panelMask.getChildAt(0)).graphics.clear();
					panelMask.removeChildAt(0);
					
				}
				
				whiteBG.graphics.clear();
				
				mainButtons.kill();
				
				bigTitle.removeChildAt(0);
				bigDesc.removeChildAt(0);
				
				BlurDesc.finalKill();
				
				bigMask.graphics.clear();
				
			}
			
			while(bigHolder.numChildren) {
				bigHolder.removeChildAt(0);
			}
			
			GalleryTracker.finalKill();
			
			// set all vars to null
			xThumb = null;
			xImage = null;
			xText = null;
			xTitle = null;
			xDesc = null;
			xVid = null;
			tHolder = null;
			panelMask = null;
			whiteBG = null;
			bigMask = null;
			mainButtons = null;
			bigTitle = null;
			bigDesc = null;
			left = null;
			right = null;
			thumbs = null;
			loaders = null;
			tMasks = null;
			styles = null;
			bigHolder = null;
			myPre = null;
			
		}
		
    }
}








