package cj.qcreative {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.text.TextFieldAutoSize;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import cj.qcreative.graphics.Container2;
	
	// this class controls the music player
    public final class Music {
		
		// begin private vars
		private static var theBuffer:Number,
		theVol:Number,
		pauser:Number,
		bit:Number,
		flote:Number,
		left:Number,
		right:Number,
		raiser:Number,
		who:int,
		topCount:int,
		bottomCount:int,
		topTotal:int,
		bottomTotal:int,
		topLeft:int,
		bottomLeft:int,
		bottomRight:int,
		bottomH:int,
		myCount:int,
		theList:XMLList,
		topLevel:XMLList,
		bottomLevel:XMLList,
		sound:Sound,
		context:SoundLoaderContext,
		channel:SoundChannel,
		transformer:SoundTransform,
		vol:Boolean,
		wasPlaying:Boolean,
		normal:Sprite,
		full:Sprite,
		social:Sprite,
		container:Sprite,
		bShape:Sprite,
		icons:Array,
		icons2:Array,
		bar1:Shape = new Shape(),
		bar2:Shape = new Shape(),
		bar3:Shape = new Shape(),
		bar4:Shape = new Shape(),
		iconPad:Shape = new Shape(),
		tim:Timer = new Timer(30),
		ii:int = 1,
		totHeight:int = 24,
		initialized = false,
		bo:Boolean = true,
		ran:Boolean = true,
		musicSecond:Boolean = false,
		copyright:Copyright;
		// end private vars
		
		// begin internal vars
		internal static var speaker:Sprite = new Sprite();
		// end internal vars
		
		// utitlity function for drawing a shape
		private static function drawShape(sh:Shape):void {
			
			sh.graphics.beginFill(0xFFFFFF);
			sh.graphics.drawRect(0, 0, 3, 16);
			sh.graphics.endFill();
			
		}
		
		internal static function addCopy(st:String):void {
			
			Tracker.template.speaker = speaker;
			speaker.visible = false;
			
			copyright = new Copyright();
			copyright.txt.text = st;
			copyright.txt.autoSize = TextFieldAutoSize.RIGHT;
			copyright.x = 245;
			
			copyright.y = Tracker.stageH - copyright.height - 5;
			speaker.addChild(copyright);
			
		}
		
		internal static function storeXML(iconX:XMLList, iMusic:Boolean):void {
			
			Tracker.template.speaker = speaker;
			speaker.visible = false;
			
			var ms:String = iconX.topLevel.attribute("useMusicAsSecond");
			topLevel = iconX.topLevel.icon;
			
			if(iMusic) {
				if(ms.toLowerCase() == "false") {
					topLeft = 30;
				}
				else {
					musicSecond = true;
					topLeft = 10;
					
				}
			}
			else {
				topLeft = 10;
			}
				
			icons = [];
			sizeUp();
				
			bottomLevel = iconX.bottomLevel.icon;
			topTotal = topLevel.length() - 1;
			topCount = 0;
			myCount = 0;
				
			loadTop();
			
		}
		
		private static function loadTop():void {
			
			var loader:Loader = new Loader();
			loader.mouseEnabled = false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loader.load(new URLRequest(topLevel[topCount].url));
			
		}
		
		private static function loadBottom():void {
			
			var loader:Loader = new Loader();
			loader.mouseEnabled = false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bottomLoaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loader.load(new URLRequest(bottomLevel[bottomCount].url));
			
		}
		
		private static function bottomLoaded(event:Event):void {
			
			var bit:Bitmap = Bitmap(event.target.content);
			var w:int = bit.width;
			var h:int = bit.height;
			
			bit.smoothing = true;
			
			var sp:Sprite = new Sprite();
			sp.addChild(bit);
			sp.x = bottomRight - w;
			sp.y = Tracker.stageH;
			sp.buttonMode = true;
			sp.addEventListener(MouseEvent.CLICK, goLink2, false, 0, true);
			speaker.addChild(sp);
			
			bottomRight -= w + 2;
			
			icons2[bottomCount] = sp;
			
			(h > totHeight) ? totHeight = h : null;
			
			if(bottomCount != bottomTotal) {
				bottomCount++;
				loadBottom();
			}
			else {
				addRollShape();
			}
			
		}
		
		private static function addRollShape():void {
			
			bShape = new Sprite();
			bShape.graphics.beginFill(0x000000, 0);
			bShape.graphics.drawRect(0, 0, 250, totHeight + 18);
			bShape.graphics.endFill();
			bShape.y = Tracker.stageH - 10;
			bShape.visible = false;
			
			speaker.addChildAt(bShape, 0);
			
			iconPad = new Shape();
			iconPad.graphics.beginFill(0x000000, 0);
			iconPad.graphics.drawRect(0, 0, social.width + 2, social.height + 12);
			iconPad.graphics.endFill();
			iconPad.x = -1;
			iconPad.y = -6;
			social.addChildAt(iconPad, 0);
			
			
			
			social.addEventListener(MouseEvent.CLICK, goSocial, false, 0, true);
			social.addEventListener(MouseEvent.ROLL_OUT, checkSocial, false, 0, true);
			
			var i:int = icons2.length;
			
			while(i--) {
				
				icons2[i].addEventListener(MouseEvent.ROLL_OVER, goSocial, false, 0, true);
				icons2[i].addEventListener(MouseEvent.ROLL_OUT, checkSocial, false, 0, true);
				
			}
			
			bShape.addEventListener(MouseEvent.ROLL_OVER, goSocial, false, 0, true);
			bShape.addEventListener(MouseEvent.ROLL_OUT, checkSocial, false, 0, true);
			
		}
		
		private static function goFull(event:MouseEvent):void {
			
			if(!Tracker.moduleLoaded || !Tracker.template.moduleReady) {
				return;
			}
			
			Tracker.isFull = true;
			
			full.removeEventListener(MouseEvent.CLICK, goFull);
			
			try {
				Object(Tracker.template.module.content).removeSize();
			}
			catch(event:*){};
			
			Tracker.template.stage.displayState = StageDisplayState.FULL_SCREEN;
			
			try {
				Object(Tracker.template.module.content).sizer();
			}
			catch(event:*){};
			
			Tracker.template.stage.addEventListener(FullScreenEvent.FULL_SCREEN, escapeThis, false, 0, true);
			
			full.visible = false;
			normal.visible = true;
			
			normal.addEventListener(MouseEvent.CLICK, goNormal, false, 0, true);
			
		}
		
		// only internal so we can remove the event listener, not actually called from anywhere
		internal static function escapeThis(event:FullScreenEvent):void {
			
			processNormal();
			
			 Tracker.template.stage.displayState = StageDisplayState.NORMAL;
			
			try {
				Object(Tracker.template.module.content).addSize(true);
			}
			catch(event:*){};
			
		}
		
		internal static function addEscape(boo:Boolean = true):void {
			
			if(boo) {
				Tracker.template.stage.addEventListener(FullScreenEvent.FULL_SCREEN, escapeThis, false, 0, true);
			}
			else {
				Tracker.template.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, escapeThis);
			}
			
		}
		
		private static function processNormal(fromClick:Boolean = false):void {
			
			if(!Tracker.moduleLoaded || !Tracker.template.moduleReady) {
				return;
			}
			
			Tracker.isFull = false;
			
			normal.removeEventListener(MouseEvent.CLICK, goNormal);
			Tracker.template.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, escapeThis);
			
			if(fromClick) {
				Tracker.template.stage.displayState = StageDisplayState.NORMAL;
			}
			
			try {
				Object(Tracker.template.module.content).addSize(true);
			}
			catch(event:*){};
			
			normal.visible = false;
			full.visible = true;
			
			full.addEventListener(MouseEvent.CLICK, goFull, false, 0, true);
			
		}
		
		internal static function goNormal(event:MouseEvent = null):void {
			
			var boo:Boolean;
			
			if(event != null) {
				boo = true;
			}
			else {
				boo = false;
			}
			
			processNormal(boo);
			
		}
		
		private static function hideBack():void {
			
			bShape.visible = false;
			
		}
		
		private static function checkSocial(event:MouseEvent):void {
			
			TweenMax.to(speaker, 0.5, {y: 0, ease: Quint.easeOut, onComplete: hideBack});
			
		}
		
		private static function goSocial(event:MouseEvent):void {
			
			bShape.visible = true;
			TweenMax.to(speaker, 0.5, {y: -(totHeight + 8), ease: Quint.easeOut});
			
		}
		
		private static function goLink2(event:MouseEvent):void {
			
			var id:int;
			var i:int = icons2.length;
			var sp:Sprite = Sprite(event.currentTarget);
			
			while(i--) {
				
				if(icons2[i] == sp) {
					
					id = i;
					break;
					
				}
			}
			
			navigateToURL(new URLRequest(bottomLevel[i].link), bottomLevel[i].target);
			
		}
		
		private static function goLink(event:MouseEvent):void {
			
			var id:int;
			var i:int = icons.length;
			var sp:Sprite = Sprite(event.currentTarget);
			
			while(i--) {
				
				if(icons[i] == sp) {
					
					id = i;
					break;
					
				}
			}
			
			navigateToURL(new URLRequest(topLevel[i].link), topLevel[i].target);
			
		}
		
		private static function iconLoaded(event:Event):void {
			
			var bit:Bitmap = Bitmap(event.target.content);
			var w:int = bit.width;
			var h:int = bit.height;
			
			bit.smoothing = true;
			
			var sp:Sprite = new Sprite();
			sp.addChild(bit);
			sp.x = topLeft;
			sp.y = Tracker.stageH - h - 10;
			sp.buttonMode = true;
			speaker.addChild(sp);
			
			icons[topCount] = sp;
			
			switch(topLevel[topCount].type.toLowerCase()) {
				
				case "fullscreen":
					
					sp.addEventListener(MouseEvent.CLICK, goFull, false, 0, true);
					
					if(musicSecond && myCount == 0) {
						topLeft += w + 25;
					}
					else if(musicSecond && myCount == 1) {
						container.x = topLeft;
						container.visible = true;
					}
					else {
						topLeft += w + 5;
					}
					
					full = sp;
					myCount++;
					
				break;
				
				case "normalscreen":
					
					sp.visible = false;
					normal = sp;
					
					if(full != null) {
						sp.x = full.x;
					}
					else {
						throw new Error("full screen icon must be loaded before the normal screen icon.  Please adjust the config.xml");
					}
					
				break;
				
				case "social":
					
					social = sp;
					
					if(musicSecond && myCount == 0) {
						topLeft += w + 25;
					}
					else if(musicSecond && myCount == 1) {
						container.x = topLeft;
						container.visible = true;
					}
					else {
						topLeft += w + 5;
					}
					
					myCount++;
					
				break;
				
				case "link":
				
					sp.addEventListener(MouseEvent.CLICK, goLink, false, 0, true);
					
					if(musicSecond && myCount == 0) {
						topLeft += w + 25;
					}
					else if(musicSecond && myCount == 1) {
						container.x = topLeft;
						container.visible = true;
					}
					else {
						topLeft += w + 5;
					}
					
					myCount++;
				
				break;
				
			}
			
			if(topCount != topTotal) {
				topCount++;
				loadTop();
			}
			else {
				if(bottomLevel != null) {
					bottomTotal = bottomLevel.length() - 1;
					bottomCount = 0;
					bottomRight = 242;
					bottomH = Tracker.stageH + 10;
					icons2 = [];
					loadBottom();
				}
				else {
					fadeIn();
				}
			}
			
		}
		
		internal static function fadeIn():void {
			
			speaker.y = totHeight;
			TweenMax.to(speaker, 0.4, {y: 0, ease: Linear.easeNone, delay: 1});
			
		}
		
		private static function sizeUp():void {
			
			if(ran) {
				ran = false;
				speaker.name = "speaker";
				Tracker.template.addChild(speaker);
			}
			
		}
		
		// sets up the music player
        internal static function setup(myList:XMLList, myBuffer:Number, myVol:Number) { 
			
			Tracker.template.speaker = speaker;
			speaker.visible = false;
			
			theList = myList;
			theBuffer = myBuffer;
			theVol = myVol;
			
			// draw each bar
			drawShape(bar1);
			bar1.x = 5;
			
			drawShape(bar2);
			bar2.x = 9;
			
			drawShape(bar3);
			bar3.x = 13;
			
			drawShape(bar4);
			bar4.x = 17;
			
			bar1.scaleY = bar2.scaleY = bar3.scaleY = bar4.scaleY = 0;
			
			container = new Sprite();
			container.graphics.beginFill(0x000000, 0);
			container.graphics.drawRect(0, 0, 20, 16);
			container.graphics.endFill();
			container.buttonMode = true;
			
			container.addChild(bar1);
			container.addChild(bar2);
			container.addChild(bar3);
			container.addChild(bar4);
			
			if(!musicSecond) {
				container.x = 30;
			}
			else {
				container.visible = false;
			}
			
			container.y = 16;
			container.rotation = 180;
			speaker.addChild(container);
			
			speaker.tabEnabled = false;
			container.y = Tracker.stageH - 10;
			
			who = 0;
			vol = true;
			
			// records the line adjustment for the first song to help control tween size
			raiser = Number(theList[who].attribute("spectrum")) * .01;
			
			context = new SoundLoaderContext(theBuffer);
			
			// create and load in the first song
			sound = new Sound();
			sound.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			sound.load(new URLRequest(theList[who]), context);
			
			transformer = new SoundTransform(theVol);
			
			channel = sound.play();
			channel.soundTransform = transformer;
			
			channel.addEventListener(Event.SOUND_COMPLETE, switchSong, false, 0, true);
			
			addListen();
			
			initialized = true;
			
			sizeUp();
			
			Tracker.liveMusic = true;

			tim.addEventListener(TimerEvent.TIMER, goTime, false, 0, true);
			tim.start();
			
			wasPlaying = true;
		
        }
		
		// fixes a problem in Chrome and Opera when closing the browser
		private static function catchError(event:IOErrorEvent):void {}
		
		// turns off the equalizer tweens
		internal static function turnOff():void {
			
			if(initialized) {
				
				tim.stop();
				tim.removeEventListener(TimerEvent.TIMER, goTime);
				
				TweenMax.killTweensOf(bar1);
				TweenMax.killTweensOf(bar2);
				TweenMax.killTweensOf(bar3);
				TweenMax.killTweensOf(bar4);
				
			}
		}
		
		// checks to see if music should re-play after a video is done
		internal static function vPause(playOn:Boolean):void {
			
			if(!playOn) {
				if(wasPlaying) {
					vol = true;
					clicker();
				}
			}
			else {
				if(wasPlaying) {
					(vol == false) ? clicker() : null;
				}
			}
			
		}
		
		// turns on the equalizer animation
		internal static function turnOn():void {
			
			if(initialized) {

				tim.addEventListener(TimerEvent.TIMER, goTime, false, 0, true);
				tim.start();
				
			}
		}
		
		// positions the music player upon a browser resize event
		internal static function sizeSpeaker():void {
			
			var h:int = Tracker.stageH;
			
			TweenMax.killTweensOf(speaker);
			speaker.y = 0;
			
			(container != null) ? container.y = h - 10 : null;
			
			if(icons != null) {
				
				var i:int = icons.length;
				
				while(i--) {
					
					if(!icons[i].contains(iconPad)) {
						icons[i].y = h - icons[i].height - 10;
					}
					else {
						icons[i].y = h - icons[i].height + 2;
					}
						
				}
				
				if(icons2 != null) {
					
					bottomH = h;
					
					var k:int = icons2.length;
					
					while(k--) {
						
						TweenMax.killTweensOf(icons2[k]);
						icons2[k].y = bottomH;
						
					}
					
					if(bShape != null) {
						
						bShape.y = Tracker.stageH - 10;
						
					}
					
				}
				
			}
			
			if(copyright != null) {
				copyright.y = h - copyright.height - 5;
			}

		}
		
		// animates the equalizer
		private static function goTime(event:TimerEvent):void {
			
			(ii != 3) ? ii++ : ii = 0;
			(bo) ? bo = false : bo = true;
			
			// we alternate between the left peak and the right peak
			if(bo) {
				left = channel.leftPeak * raiser;
				(left > 1) ? left = 1 : null;
				(left < 0.1) ? left = 0.1 : null;
				TweenMax.to(container.getChildAt(ii), 0.2, {scaleY: left, ease: Linear.easeNone});
			}
			
			else {
				right = channel.rightPeak * raiser;
				(right > 1) ? right = 1 : null;
				(right < 0.1) ? right = 0.1 : null;
				TweenMax.to(container.getChildAt(ii), 0.2, {scaleY: right, ease: Linear.easeNone});
			}

		}
		
		// called when a song has finsihed and a new song is to be played
		private static function switchSong(event:Event):void {
			
			(who != theList.length() - 1) ? who++ : who = 0;
			
			channel.removeEventListener(Event.SOUND_COMPLETE, switchSong);
			channel = null;
			
			sound.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			sound = null;
			
			raiser = Number(theList[who].attribute("spectrum")) * .01;
			
			sound = new Sound();
			sound.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			sound.load(new URLRequest(theList[who]), context);
			
			channel = sound.play();
			channel.soundTransform = transformer;
			channel.addEventListener(Event.SOUND_COMPLETE, switchSong, false, 0, true);
			
		}
		
		// fades the song in and out for a smooth listening effect
		private static function callChannel():void {
			channel.soundTransform = transformer;
		}
		
		// called when the song is to be paused
		private static function pauseSound():void {
			pauser = channel.position;
			channel.stop();
			addListen();
		}
		
		// adds the initial event listeners to the song
		private static function addListen():void {
			container.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
			channel.addEventListener(Event.SOUND_COMPLETE, switchSong, false, 0, true);
		}
		
		// called when the music player is clicked
		private static function clicker(event:MouseEvent = null):void {
			
			container.removeEventListener(MouseEvent.CLICK, clicker);
			
			// if the song should stop playing
			if(vol) {
				
				vol = false;
				TweenMax.to(transformer, 0.5, {volume: 0, ease: Linear.easeNone, onUpdate:callChannel, onComplete: pauseSound});
				
				tim.stop();
				tim.removeEventListener(TimerEvent.TIMER, goTime);
					
				TweenMax.to(bar1, 0.2, {scaleY: 0.2, ease: Linear.easeNone});
				TweenMax.to(bar2, 0.2, {scaleY: 0.2, ease: Linear.easeNone});
				TweenMax.to(bar3, 0.2, {scaleY: 0.2, ease: Linear.easeNone});
				TweenMax.to(bar4, 0.2, {scaleY: 0.2, ease: Linear.easeNone});
				
				(event != null) ? wasPlaying = false : null;
					
			}
			
			// if the song should start playing
			else {
				vol = true;
				channel = sound.play(pauser);
				TweenMax.to(transformer, 0.5, {volume: theVol, ease: Linear.easeNone, onUpdate:callChannel, onComplete: addListen});
				tim.addEventListener(TimerEvent.TIMER, goTime, false, 0, true);
				tim.start();
				
				(event != null) ? wasPlaying = true : null;
				
			}
		}

    }
}








