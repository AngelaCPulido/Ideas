package cj.qcreative.videoplayer {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;
	import flash.events.MouseEvent;
	import flash.events.FullScreenEvent;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import cj.qcreative.gallery.GalleryTracker;
	import cj.qcreative.portfolio.PortTracker;
	import cj.qcreative.Tracker;
	
	// this is the video players main class
    public final class SingleVideo extends Sprite {
		
		// begin private vars
		private var controls:Controls,
		bg:Sprite,
		cover:Sprite,
		vCover:Sprite,
		vHolder:Sprite,
		tShape:Shape,
		iLoader:Loader,
		bit:Bitmap,
		txt:TextField,
		
		vid:Video,
		meta:Object,
		st:SoundTransform,
		nc:NetConnection,
		ns:NetStream,
		xLoader:URLLoader,
		
		theVolume:Number,
		buffer:Number,
		duration:Number,
		place:Number,
		totalLoaded:Number,
		overage:Number,
		sec:Number,
		min:Number,
		
		cw:int,
		ch:int,
		vw:int,
		vh:int,
		id:int,
		floor:int,
		
		st1:String,
		st2:String,
		vURL:String,
		total:String,
		iURL:String,

		readOnce:Boolean,
		hasEnded:Boolean,
		mouseOn:Boolean,
		iLoading:Boolean,
		begin:Boolean,
		usingXML:Boolean,
		xLoading:Boolean,
		played:Boolean,
		playAuto:Boolean,
		firstPlay:Boolean,
		
		timer:Timer,
		
		setVideo:Function;
		// end private vars
		
		// class constructor
		public function SingleVideo(videoURL:String = "video/sample.flv", imageURL:String = "images/video/snapshot.jpg", vol:Number = 1, buf:Number = 3, func:Function = null, i:int = undefined) {
			
			VideoTracker.myVid = this;
			
			addEventListener(Event.UNLOAD, kill, false, 0, true);
			
			if(GalleryTracker.homer || PortTracker.home) {
				vURL = videoURL;
				iURL = imageURL;
				theVolume = vol;
				buffer = buf;
				setVideo = func;
				usingXML = false;
			}
			else {
				usingXML = true;
			}
			
			id = i;
			readOnce = true;
			begin = true;
			hasEnded = false;
			iLoading = false;
			xLoading = false;
			played = false;
			mouseOn = true;
			playAuto = false;
			firstPlay = false;
			
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// toggles play/pause
		private function changePlay(goPlay:Boolean):void {
			
			if(goPlay) {
				playVid();
			}
			else {
				pauseVid();
			}
			
		}
		
		// disables the player
		public function pauseAndHide():void {
			
			pauseVid();
			removeListen();
			controls.removeListen();
			controls.visible = false;
			vid.visible = false;
			addChild(bit);
			TweenMax.to(bit, 1, {alpha: 1, ease: Quint.easeOut});
			
		}
		
		// pauses the playback
		private function pauseVid():void {
			
			removeEventListener(Event.ENTER_FRAME, updateStatus);
			played = false;
			ns.pause();
			
		}
		
		// hides the control bar
		private function fireTimer(event:TimerEvent):void {
			if(!mouseOn || firstPlay) {
				hideControls();
				firstPlay = false;
			}
		}
		
		// listens for when the mouse is moved
		private function mover(event:MouseEvent):void {
			
			timer.stop();
			timer.start();
			
			cover.visible = false;
			
			if(controls.alpha != 1) {
				TweenMax.to(controls, 1, {alpha: 1, ease: Quint.easeOut});
			}
			
			Mouse.show();
			
			this.addEventListener(MouseEvent.ROLL_OUT, hideControls, false, 0, true);
			addEventListener(Event.MOUSE_LEAVE, hideControls, false, 0, true);
			
		}
		
		// hides the control bar and mouse
		private function hideControls(event:Event = null):void {
			
			this.removeEventListener(MouseEvent.ROLL_OUT, hideControls);
			removeEventListener(Event.MOUSE_LEAVE, hideControls);
			cover.visible = true;
			
			if(controls.alpha != 0) {
				TweenMax.to(controls, 1, {alpha: 0, ease: Quint.easeOut});
			}
			
			if(this.mouseX > 0 && this.mouseX < cw && this.mouseY > 0 && this.mouseY < ch) {
				Mouse.hide();
			}
			
		}
		
		// removes the video image
		private function removeBit():void {
			
			(this.contains(bit)) ? removeChild(bit) : null;
			
		}
		
		// starts playback
		private function playVid():void {
			
			played = true;
			
			if(begin) {
				TweenMax.to(bit, 1, {alpha: 0, ease: Quint.easeOut, onComplete: removeBit});
				vid.visible = true;
				begin = false;
				
				timer.start();
				
				this.addEventListener(MouseEvent.MOUSE_MOVE, mover, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OUT, hideControls, false, 0, true);
				addEventListener(Event.MOUSE_LEAVE, hideControls, false, 0, true);
				
			}
			
			if(usingXML && Tracker.template) {
				Tracker.template.checkMusic(false);
			}
			
			addEventListener(Event.ENTER_FRAME, updateStatus, false, 0, true);
			ns.pause();
			ns.resume();
			
		}
		
		// calculates playback status
		private function trackLoaded(event:Event):void {
			
			totalLoaded = ns.bytesLoaded / ns.bytesTotal;
			
			if(totalLoaded < 1) {
				controls.lineHit.scaleX = totalLoaded;
			}
			else {
				controls.lineHit.scaleX = 1;
				removeEventListener(Event.ENTER_FRAME, trackLoaded);
			}
			
		}
		
		// updates the time text filed
		private function updateStatus(event:Event):void {
			
			place = ns.time / duration;
			controls.white.scaleX = ns.time / duration;
			
			floor = ns.time | 0;
			min = floor / 60;
			overage = min - (min | 0);
			min = min | 0;
			sec = overage * 60;
			overage = sec - (sec | 0);
			sec = sec | 0;

			st1 = min < 10 ? "0" + min : "" + min;
			st2 = sec < 10 ? "0" + sec : "" + sec;
			
			txt.text = st1 + ":" + st2 + total;
			
		}
		
		// shows the conrol bar
		public function showControls(goPlay:Boolean):void {
			
			controls.visible = true;
			controls.alpha = 0;
			TweenMax.to(controls, 1, {alpha: 1, ease: Quint.easeOut});
			
			if(goPlay) {
				firstPlay = true;
				playVid();
				controls.switchBack();
			}
			
			
		}
		
		// restores the video to it's initial state
		public function resetVid(hideCon:Boolean = false):void {
			
			removeEventListener(Event.ENTER_FRAME, updateStatus);
			
			if(vid != null) { 
				vid.visible = false;
			}
			
			if(bit != null) {
				(!this.contains(bit)) ? addChild(bit) : null;
				TweenMax.to(bit, 1, {alpha: 1, ease: Quint.easeOut});
			}
			if(controls != null) {
				setChildIndex(controls, numChildren - 1);
				(hideCon) ? controls.visible = false : null;
			}
			if(cover != null) {
				setChildIndex(cover, numChildren - 1);
			}
						
			hasEnded = true;
			begin = true;
						
			if(played) {
				if(controls != null) {
					controls.switchBack();
				}
				played = false;
			}
			
			if(ns != null) {
				ns.seek(0);
				ns.pause();
			}
			
			if(txt != null) {
				txt.text = "00:00" + total;
			}
			
		}
		
		// listens for status events
		private function statusEvent(event:NetStatusEvent):void {
			
			switch(event.info.code) {

				case "NetStream.Play.Start":
				
					ns.pause();
					
				break;
				
				case "NetStream.Play.Stop":
					
					if(!controls.downMouse) {
						resetVid();
					}
					
				break;
				
			}
		}
		
		// adds the control bar
		public function addControls(activate:Boolean = true):void {
			
			if(activate) {
				controls.playPause.checkPlay();
			}
			
			controls.visible = true;
			
		}
		
		// removes the control bar
		public function removeControls():Boolean {
			
			controls.visible = false;
			
			var wasPlaying:Boolean = controls.playPause.checkPause();
			
			return wasPlaying;
			
		}
		
		// toggles play/pause
		private function togNS(goPlay:Boolean = false):void {
			if(!goPlay) {
				ns.pause();
				
				if(begin) {
					TweenMax.to(bit, 1, {alpha: 0, ease: Quint.easeOut, onComplete: removeBit});
					vid.visible = true;
					begin = false;
					addEventListener(Event.ENTER_FRAME, updateStatus, false, 0, true);
					
					timer.start();
			
					this.addEventListener(MouseEvent.MOUSE_MOVE, mover, false, 0, true);
					this.addEventListener(MouseEvent.ROLL_OUT, hideControls, false, 0, true);
					addEventListener(Event.MOUSE_LEAVE, hideControls, false, 0, true);
					
				}
				
			}
			else {
				removeEventListener(Event.ENTER_FRAME, updateStatus);
				controls.playPause.setPlay();
				playVid();
			}
		}
		
		// moves the status line
		private function moveLine(i:Number, wid:int):void {
			ns.seek(((i / wid) * duration) | 0);
		}
		
		// line click event
		private function checkLine(i:Number, wid:int):void {
			
			removeEventListener(Event.ENTER_FRAME, updateStatus);
			controls.playPause.setPlay();
			ns.seek(((i / wid) * duration) | 0);
			playVid();
			
		}
		
		// stores variables for local usage
		private function kickRef(texter:TextField, tot:String):void {
			txt = texter;
			total = tot;
		}
		
		// updates the volume
		private function updateV(vol:Number):void {
			
			st.volume = vol * .01;
			ns.soundTransform = st;
			
		}
		
		// toggles the volume on off
		private function kickVol(volOn:Boolean):void {
			
			(!volOn) ? st.volume = 0 : st.volume = theVolume;
			
			ns.soundTransform = st;
			
		}
		
		// controls mouse over event
		private function cOver(event:MouseEvent):void {
			mouseOn = true;
		}
		
		// controls mouse out event
		private function cOut(event:MouseEvent):void {
			mouseOn = false;
		}
		
		// sizes the video and controls
		private function getSizer(full:Boolean = false):void {
			
			var theW:int = vw, theH:int = vh;
			
			if(full) {
				
				if(!usingXML) {
					(Tracker.template) ? Tracker.template.removeSizer() : null;
					(PortTracker.home) ? PortTracker.home.removeSize() : null;
					(GalleryTracker.homer) ? GalleryTracker.homer.removeSize() : null;
					
					if(stage.displayState != StageDisplayState.FULL_SCREEN) {
						stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					
					if(GalleryTracker.homer) {
						GalleryTracker.homer.fs(true);
					}
					else if(PortTracker.home) {
						PortTracker.home.fs(true);
					}
				}
				else if(Tracker.template) {
					Tracker.template.removeSizer();
					
					if(stage.displayState != StageDisplayState.FULL_SCREEN) {
						stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					
					Tracker.template.fixFull(true);
				}
				
				cw = stage.stageWidth;
				ch = stage.stageHeight;
				
				var scalerH:Number = cw / vw, scalerW:Number = ch / vh, scaleMe:Number;
				
				if(scalerH <= scalerW) {
					scaleMe = scalerH;
				}
				else {
					scaleMe = scalerW;
				}
				
				theW *= scaleMe;
				theH *= scaleMe;
				
				vHolder.width = theW;
				vHolder.height = theH;
				
				vHolder.x = (cw >> 1) - (theW >> 1);
				vHolder.y = (ch >> 1) - (theH >> 1);
				
				if(bg == null) {
					bg = new Sprite();
					bg.graphics.beginFill(0x000000);
					bg.graphics.drawRect(0, 0, cw, ch);
					bg.graphics.endFill();
					bg.addEventListener(MouseEvent.ROLL_OVER, hideControls, false, 0, true);
					addChildAt(bg, 0);
				}
				
				controls.x = vHolder.x + 20;
				controls.y = ch - 61;
				controls.goingFull(true, theW);
				
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, escapeThis, false, 0, true);
				
			}
			
			else {
				
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, escapeThis);
				
				if(!Tracker.isFull) {
					stage.displayState = StageDisplayState.NORMAL;
				}
				
				if(!usingXML) {
					(Tracker.template) ? Tracker.template.removeSizer(true) : null;
					if(GalleryTracker.homer) {
						GalleryTracker.homer.fs();
					}
					else if(PortTracker.home) {
						PortTracker.home.fs();
					}
				}
				else if(Tracker.template) {
					Tracker.template.fixFull();
					Tracker.template.removeSizer(true)
				}
				
				controls.goingFull();
				controls.x = 20;
				controls.y = vh - 61;

				cw = vw;
				ch = vh;
				
				vHolder.width = cw;
				vHolder.height = ch;
				
				vHolder.x = 0;
				vHolder.y = 0;
				
				if(bg) {
					bg.removeEventListener(MouseEvent.ROLL_OVER, hideControls);
					removeChild(bg);
					bg.graphics.clear();
					bg = null;
				}
			
			}
			
			bit.width = vHolder.width;
			bit.height = vHolder.height;
			bit.x = vHolder.x;
			bit.y = vHolder.y;
			
			vCover.graphics.clear();
			vCover.graphics.beginFill(0x000000);
			vCover.graphics.drawRect(0, 0, cw, ch);
			vCover.graphics.endFill();
			
			cover.graphics.clear();
			cover.graphics.beginFill(0x000000);
			cover.graphics.drawRect(0, 0, cw - 40, 41);
			cover.graphics.endFill();
			cover.x = controls.x;
			cover.y = controls.y;
			
		}
		
		// fullsreen listener
		private function escapeThis(event:FullScreenEvent):void {
			
			if(Tracker.isFull) {
				Tracker.isFull = false;
				if(Tracker.template) {
					Tracker.template.switchButtons();
				}
			}
			
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, escapeThis);
			controls.fullScreen.goNormal();
			
		}
		
		// removes the initial mask that is no longer needed
		private function dumpT():void {
			
			removeChild(tShape);
			this.mask = null;
			
			tShape.graphics.clear();
			tShape = null;
			
			if(playAuto) {
				showControls(true);
			}
			
		}
		
		// called from the Q and activates the module
		public function getSized(isLocal:Boolean = false):void {
			
			tShape = new Shape();
			tShape.graphics.beginFill(0x000000);
			tShape.graphics.drawRect(0, 0, vw, vh);
			tShape.graphics.endFill();
			
			this.mask = tShape;
			tShape.scaleX = 0;
			addChild(tShape);
			
			TweenMax.to(tShape, 0.5, {scaleX: 1, ease: Quint.easeOut, onComplete: dumpT});
			
			if(!isLocal) {
				Tracker.moduleW = vw;
				Tracker.moduleH = vh + 16;
				Tracker.template.posModule();
			}
			
		}
		
		// fires when meta data is available
		private function runMeta(info:Object) {
			
			if(readOnce) {
				
				ns.seek(0);
				readOnce = false;
				
				vw = info.width;
				vh = info.height;
				cw = vw;
				ch = vh;
				
				vid.width = vw;
				vid.height = vh;

				duration = info.duration;
				
				controls = new Controls(vw - 40, changePlay, checkLine, kickRef, kickVol, moveLine, togNS, getSizer, updateV, duration);
				controls.x = 20;
				controls.y = vh - 61;
				controls.addEventListener(MouseEvent.ROLL_OVER, cOver, false, 0, true);
				controls.addEventListener(MouseEvent.ROLL_OUT, cOut, false, 0, true);
				
				cover = new Sprite();
				cover.graphics.beginFill(0x000000);
				cover.graphics.drawRect(0, 0, vw - 40, 41);
				cover.graphics.endFill();
				cover.x = 20;
				cover.y = controls.y;
				cover.alpha = 0;
				cover.visible = false;
				
				vCover = new Sprite();
				vCover.graphics.beginFill(0x000000);
				vCover.graphics.drawRect(0, 0, vw, vh);
				vCover.graphics.endFill();
				vCover.alpha = 0;
				
				timer = new Timer(3500, 1);
				timer.addEventListener(TimerEvent.TIMER, fireTimer, false, 0, true);
				
				addChild(vCover);
				addChild(controls);
				addChild(cover);
				
				if(setVideo != null) {
					
					if(PortTracker.home) {
						controls.visible = false;
						setVideo(vw, vh, this, bit.bitmapData, id)
					}
					
					else {
						setVideo(vw, vh);
					}
					
				}
				else {
					
					if(Tracker.template) {
						Tracker.swfIsReady = true;
					}
					else {
						getSized(true);
					}
					
				}
				
				addEventListener(Event.ENTER_FRAME, trackLoaded, false, 0, true);
				
			}
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// fires when the video preview image has loaded
		private function iLoaded(event:Event):void {

			iLoading = false;
			
			event.target.removeEventListener(Event.COMPLETE, iLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			bit = Bitmap(event.target.content);
			bit.smoothing = true;
			
			st = new SoundTransform(theVolume);
			
			nc = new NetConnection();
			nc.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			nc.connect(null);
			
			ns = new NetStream(nc);
			ns.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			ns.addEventListener(NetStatusEvent.NET_STATUS, statusEvent, false, 0, true);
			ns.bufferTime = buffer;
			ns.soundTransform = st;
			
			vid = new Video();
			vid.attachNetStream(ns);
			vid.visible = false;
			
			vHolder = new Sprite();
			vHolder.mouseEnabled = false;
			vHolder.addChild(vid);
			
			meta = new Object();
			meta.onMetaData = runMeta;
			
			ns.client = meta;
			ns.play(vURL);
			
			addChild(vHolder);
			addChild(bit);
			
			iLoader = null;
			
		}
				
		// removes all event listeners
		private function removeListen():void {

			removeEventListener(Event.ENTER_FRAME, updateStatus);
			removeEventListener(Event.ENTER_FRAME, trackLoaded);
			
			if(timer != null) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, fireTimer);
			}
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mover);
			this.removeEventListener(MouseEvent.ROLL_OUT, hideControls);
			removeEventListener(Event.MOUSE_LEAVE, hideControls);
			
			if(ns != null) {
				ns.removeEventListener(NetStatusEvent.NET_STATUS, statusEvent);
			}
			
			if(controls != null) {
				removeEventListener(MouseEvent.MOUSE_MOVE, controls.enterTrack);
				removeEventListener(MouseEvent.MOUSE_MOVE, controls.enterVol);
				controls.removeEventListener(MouseEvent.ROLL_OVER, cOver);
				controls.removeEventListener(MouseEvent.ROLL_OUT, cOut);
			}
			
			if(stage != null) {
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, escapeThis);
			}
			
			Mouse.show();
			
		}
		
		// string to boolean conversion
		private function convert(st:String):Boolean {
			
			if(st.toLowerCase() == "true") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// fires when the xml file has loaded
		private final function xLoaded(event:Event):void {

			event.target.removeEventListener(Event.COMPLETE, xLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var xml:XML = new XML(event.target.data);
			
			playAuto = convert(xml.autoPlay);
			
			theVolume = Number(xml.videoVolume) * .01;
			buffer = Number(xml.videoBuffering);
			vURL = xml.videoURL;
			iURL = xml.videoImage;
			
			loadImage();
			
			xLoader = null;
			xLoading = false;
			
		}
		
		// loads in the preview image
		private function loadImage():void {
			
			iLoader = new Loader();
			iLoading = true;
			iLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, iLoaded, false, 0, true);
			iLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			iLoader.load(new URLRequest(iURL));
				
		}
		
		// fires when added to the stage
		public function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, kill, false, 0, true);
			
			if(!usingXML) {
				loadImage();
			}
			else {
				
				var xString:String;
				
				if(Tracker.template) {
					xString = Tracker.textXML;
				}
				else {
					xString = "xml/video.xml";
				}
				
				xLoader = new URLLoader();
				xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				xLoader.addEventListener(Event.COMPLETE, xLoaded, false, 0, true);
				xLoading = true;
				xLoader.load(new URLRequest(xString));
			}
			
		}
		
		// GARBAGE COLLECTION
		public function kill(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, kill);
			removeEventListener(Event.UNLOAD, kill);
				
			removeListen();
			
			if(vHolder != null) {
				if(vid != null) {
					(vHolder.contains(vid)) ? vHolder.removeChild(vid) : null;
				}
			}
			
			if(nc != null) {
				nc.close();
				nc.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			}
			
			if(ns != null) {
				ns.close();
				ns.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			}
			
			if(vid != null) {
				vid.clear();
			}

			if(controls != null) {
				TweenMax.killTweensOf(controls);
				controls.kill();
			}
			
			if(bit != null) {
				TweenMax.killTweensOf(bit);
				bit.bitmapData.dispose();
			}
			
			if(cover != null) {
				cover.graphics.clear();
			}
			
			if(vCover != null) {
				vCover.graphics.clear();
			}
			
			if(tShape != null) {
				TweenMax.killTweensOf(tShape);
				tShape.graphics.clear();
			}
			
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			tShape = null;
			vHolder = null;
			st = null;
			nc = null;
			ns = null;
			vid = null;
			timer = null;
			meta = null;
			bit = null;
			controls = null;
			cover = null;
			vCover = null;
			txt = null;
			
			if(iLoader != null) {
			
				iLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, iLoaded);
				iLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
				if(iLoading) {
				
					try {
						iLoader.close();
					}
					catch(event:*){};
					
				}
				
				iLoader = null;
			}
			
			if(xLoader != null) {
				
				xLoader.removeEventListener(Event.COMPLETE, xLoaded);
				xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				if(xLoading) {
				
					try {
						xLoader.close();
					}
					catch(event:*){};
					
				}
				
				xLoader = null;
				
			}
			
			setVideo = null;
			VideoTracker.kill();
			
		}
		
    }
}







