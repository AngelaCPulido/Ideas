package cj.qcreative.videoplayer {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class sets up the control bar for the video player
    public final class Controls extends Sprite {
		
		// begin private vars
		private var shaper:Shaper,
		liner:Liner,
		volumeMC:VolumeMC,
		volPercent:VolPercent,
		volStrip:VolStrip,
		lineClick:MovieClip,
		sLine:MovieClip,
		mouseTrack:MovieClip,
		volMask:Sprite,
		volShape:Shape,
		
		cb:Function,
		kickVol:Function,
		moveLine:Function,
		togNS:Function,
		updateVol:Function,
		
		wid:int,
		storeW:int,
		trackVol:Number,
		stVol:String,
		volOn:Boolean,
		rec:Rectangle;
		// end private vars
		
		// begin internal vars
		internal var playPause:PlayPause,
		fullScreen:FullScreen,
		theTime:TheTime,
		white:MovieClip,
		lineHit:MovieClip,
		downMouse:Boolean;
		// end internal vars
		
		// class constructor
		public function Controls(w:int, func:Function, callback:Function, kickText:Function, kickVolume:Function, mover:Function, toggleNS:Function, kSize:Function, uVol:Function, duration:Number) {
			
			shaper = new Shaper(w);
			
			playPause = new PlayPause(func);
			playPause.x = 18;
			playPause.y = 13;
			
			liner = new Liner();
			liner.x = 44;
			liner.y = 15;
			
			storeW = w;
			cb = callback;
			kickVol = kickVolume;
			moveLine = mover;
			togNS = toggleNS;
			updateVol = uVol;
			volOn = true;
			downMouse = false;
			trackVol = 1;
			
			white = liner.wLine;
			lineHit = liner.lineB;
			
			lineHit.buttonMode = true;
			lineHit.addEventListener(MouseEvent.CLICK, clickLine, false, 0, true);
			lineHit.addEventListener(MouseEvent.MOUSE_DOWN, lineDown, false, 0, true);
			
			var floor:int = duration | 0;
			var min:Number = floor / 60;
			var overage:Number = min - (min | 0);
			min = min | 0;
			var sec:Number = overage * 60;
			overage = sec - (sec | 0);
			sec = sec | 0;

			var st1:String = min < 10 ? "0" + min : "" + min,
			st2:String = sec < 10 ? "0" + sec : "" + sec;

			var right:String = "/" + st1 + ":" + st2;

			theTime = new TheTime();
			theTime.y = 11;
			theTime.txt.text = "00:00" + right;
			
			kickText(theTime.txt, right);
			
			volumeMC = new VolumeMC();
			volumeMC.y = 11;
			volumeMC.buttonMode = true;
			volumeMC.addEventListener(MouseEvent.ROLL_OVER, showVol, false, 0, true);
			
			fullScreen = new FullScreen(kSize);
			fullScreen.y = 11;
			
			volPercent = new VolPercent();
			volPercent.txt.text = "100";
			volPercent.y = 20;
			volPercent.mouseEnabled = false;
			volPercent.mouseChildren = false;
			volPercent.alpha = 0;
			
			volStrip = new VolStrip();
			volStrip.mouseEnabled = false;
			volStrip.mouseChildren = false;
			volStrip.buttonMode = true;
			volStrip.alpha = 0;
			volStrip.addEventListener(MouseEvent.ROLL_OUT, hideVol, false, 0, true);
			volStrip.clickVol.addEventListener(MouseEvent.CLICK, vClick, false, 0, true);
			volStrip.topClick.addEventListener(MouseEvent.CLICK, tClick, false, 0, true);
			
			sLine = volStrip.sLine;
			mouseTrack = volStrip.mouseTrack;
			lineClick = volStrip.lineClick;
			lineClick.addEventListener(MouseEvent.CLICK, lineClicker, false, 0, true);
			lineClick.addEventListener(MouseEvent.MOUSE_DOWN, volDown, false, 0, true);
			
			volShape = new Shape();
			volShape.graphics.beginFill(0x000000);
			volShape.graphics.drawRect(0, 0, 20, 80);
			volShape.graphics.endFill();
			
			volMask = new Sprite();
			volMask.mouseEnabled = false;
			volMask.addChild(volShape);
			volMask.y = -50;
			
			volMask.cacheAsBitmap = volStrip.cacheAsBitmap = true;
			
			volStrip.mask = volMask;
			volShape.visible = false;
			
			sizeControls(w);
			
			white.scaleX = lineHit.scaleX = 0;
			white.mouseEnabled = false;
			white.mouseChildren = false;
			
			this.mouseEnabled = false;
			
			addChild(shaper);
			addChild(playPause);
			addChild(liner);
			addChild(theTime);
			addChild(volumeMC);
			addChild(volPercent);
			addChild(volStrip);
			addChild(volMask);
			addChild(fullScreen);
			
		}
		
		// 
		// fires when the track is released
		private function released(event:Event):void {
			
			this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, enterTrack);
			stage.removeEventListener(MouseEvent.MOUSE_UP, released);
			stage.removeEventListener(Event.MOUSE_LEAVE, released);
			
			downMouse = false;
			togNS(true);
			
			lineHit.addEventListener(MouseEvent.MOUSE_DOWN, lineDown, false, 0, true);
			
		}
		
		// updaets the video track line
		internal function enterTrack(event:MouseEvent = null):void {
			
			rec = lineHit.getBounds(this);
			
			if(mouseX > rec.x && mouseX < rec.x + rec.width) {
				white.scaleX = liner.mouseX / wid;
			}
			
			moveLine(liner.mouseX, wid);
			
		}
		
		// fires when the track is selected
		private function lineDown(event:MouseEvent):void {
			
			downMouse = true;
			togNS();
			lineHit.removeEventListener(MouseEvent.MOUSE_DOWN, lineDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, released, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, released, false, 0, true);
			this.parent.addEventListener(MouseEvent.MOUSE_MOVE, enterTrack, false, 0, true);
			enterTrack();
			
		}
		
		// fires when the volume is released
		private function upVol(event:Event):void {
			
			this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, enterVol);
			stage.removeEventListener(MouseEvent.MOUSE_UP, upVol);
			stage.removeEventListener(Event.MOUSE_LEAVE, upVol);
			
			volStrip.addEventListener(MouseEvent.ROLL_OUT, hideVol, false, 0, true);
			lineClick.addEventListener(MouseEvent.MOUSE_DOWN, volDown, false, 0, true);
			
			rec = lineClick.getBounds(volStrip);
			
			if(volStrip.mouseX < rec.x || volStrip.mouseX > rec.x + rec.height || volStrip.mouseY < rec.y || volStrip.mouseY > rec.y + rec.height) {
				hideVol();
			}
			
		}
		
		// disables the volume button
		private function hideShape():void {
			volShape.visible = false;
		}
		
		// hides the volume bar
		private function hideVol(event:MouseEvent = null):void {

			TweenMax.to(volPercent, 0.75, {alpha: 0, ease: Quint.easeOut});
			TweenMax.to(volStrip, 0.75, {alpha: 0, ease: Quint.easeOut, onComplete: hideShape});
			
			if(trackVol == 0) {
				volumeMC.gotoAndStop(3);
				volOn = false;
			}
			
			(volumeMC.currentFrame != 3) ? volumeMC.gotoAndStop(1) : null;
			
			volStrip.mouseEnabled = false;
			volStrip.mouseChildren = false;
			
		}
		
		// toggles the volume 
		internal function enterVol(event:Event):void {
			
			rec = lineClick.getBounds(volStrip);
			
			if(volStrip.mouseY > rec.y - 1 && volStrip.mouseY - 1 < rec.y + rec.height) {
				trackVol = -(mouseTrack.mouseY / 42);
				sLine.scaleY = trackVol;
				stVol = String((trackVol * 100) | 0);
				volPercent.txt.text = stVol;
				updateVol(Number(stVol));
				
				if(trackVol != 0) {
					(volumeMC.currentFrame != 2) ? volumeMC.gotoAndStop(2) : null;
				}
				else {
					(volumeMC.currentFrame != 3) ? volumeMC.gotoAndStop(3) : null;
				}
				
			}
			
		}
		
		// fires when the volume is pressed
		private function volDown(event:MouseEvent):void {
			
			volStrip.removeEventListener(MouseEvent.ROLL_OUT, hideVol);
			lineClick.removeEventListener(MouseEvent.MOUSE_DOWN, volDown);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, upVol, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, upVol, false, 0, true);
			this.parent.addEventListener(MouseEvent.MOUSE_MOVE, enterVol, false, 0, true);
			
		}
		
		// full screen button click
		internal function goingFull(yes:Boolean = false, sW:int = 0):void {
			
			if(yes) {
				sizeControls(sW - 40);
			}
			else {
				sizeControls(storeW);
			}
			
		}
		
		// fires when the volume line is clicked
		private function lineClicker(event:MouseEvent):void {
			
			trackVol = -(mouseTrack.mouseY / 42);
			
			sLine.scaleY = trackVol;
			
			var st:String = String((trackVol * 100) | 0);
			volPercent.txt.text = st;
			
			updateVol(Number(st));
			
			volumeMC.gotoAndStop(2);
			volOn = true;
			
		}
		
		// fires when the volume icon is clicked
		private function tClick(event:MouseEvent):void {
			
			trackVol = 1;
			volPercent.txt.text = "100";
			volumeMC.gotoAndStop(2);
			sLine.scaleY = 1;
			volOn = true;
			
		}
		
		// fires when the volume bar is clicked
		private function vClick(event:MouseEvent):void {
			
			var v:int;
			
			(trackVol == 0) ? trackVol = 1 : null;
			
			if(volOn) {
				volOn = false;
				volumeMC.gotoAndStop(3);
				sLine.scaleY = 0;
				v = 0;
			}
			else {
				volOn = true;
				volumeMC.gotoAndStop(2);
				sLine.scaleY = trackVol;
				v = trackVol * 100;
			}
			
			volPercent.txt.text = String(v);
			kickVol(volOn);
		}
		
		// activates the volume
		private function showVol(event:MouseEvent):void {
			
			TweenMax.to(volPercent, 0.75, {alpha: 1, ease: Quint.easeOut});
			TweenMax.to(volStrip, 0.75, {alpha: 1, ease: Quint.easeOut});
			
			(volumeMC.currentFrame != 3) ? volumeMC.gotoAndStop(2) : null;

			volShape.visible = true;
			volStrip.mouseEnabled = true;
			volStrip.mouseChildren = true;
			
		}
		
		// gets the line position of the loaded track
		private function clickLine(event:MouseEvent):void {
			
			cb(liner.mouseX, wid);
			
		}
		
		// toggles the video's play/pause
		internal function switchBack():void {
			white.scaleX = 0;
			playPause.switchPlay();
		}
		
		// resizes the controls on a fullscreen event
		internal function sizeControls(w:int):void {
			
			shaper.drawCenter(w);
			wid = w - 196;
			liner.gLine.width = white.insideWhite.width = lineHit.insideLB.width = wid;
			theTime.x = wid + 58;
			volumeMC.x = theTime.x + 77;
			fullScreen.x = volumeMC.x + 25;
			
			volStrip.x = volMask.x = volumeMC.x - 3;
			volPercent.x = volumeMC.x - 10;
			
		}
		
		// removes all event listeners
		internal function removeListen():void {
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, released);
			stage.removeEventListener(Event.MOUSE_LEAVE, released);
			stage.removeEventListener(MouseEvent.MOUSE_UP, upVol);
			stage.removeEventListener(Event.MOUSE_LEAVE, upVol);
			
			lineHit.removeEventListener(MouseEvent.CLICK, clickLine);
			lineHit.removeEventListener(MouseEvent.MOUSE_DOWN, lineDown);
			volumeMC.removeEventListener(MouseEvent.ROLL_OVER, showVol);
			volStrip.removeEventListener(MouseEvent.ROLL_OUT, hideVol);
			volStrip.clickVol.removeEventListener(MouseEvent.CLICK, vClick);
			volStrip.topClick.removeEventListener(MouseEvent.CLICK, tClick);
			lineClick.removeEventListener(MouseEvent.CLICK, lineClicker);
			lineClick.removeEventListener(MouseEvent.MOUSE_DOWN, volDown);
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			removeListen();
			
			TweenMax.killTweensOf(volPercent);
			TweenMax.killTweensOf(volStrip);
			
			shaper.kill();
			playPause.kill();
			fullScreen.kill();
			
			playPause = null;
			shaper = null;
			fullScreen = null;
			
			liner.lineB.removeChildAt(0);
			liner.wLine.removeChildAt(0);
			liner.removeChildAt(0);
			liner.removeChildAt(0);
			liner.removeChildAt(0);
			liner = null;
			
			volumeMC.removeChildAt(0);
			volumeMC = null;
			
			volPercent.removeChildAt(0);
			volPercent = null;
			
			volStrip.removeChildAt(0);
			volStrip.removeChildAt(0);
			volStrip.removeChildAt(0);
			volStrip.removeChildAt(0);
			volStrip = null;
			
			volMask.removeChild(volShape);
			volMask = null;
			
			volShape.graphics.clear();
			volShape = null;
			
			theTime.removeChildAt(0);
			theTime = null;
			
			cb = null;
			kickVol = null;
			moveLine = null;
			togNS = null;
			updateVol = null;
			rec = null;
			white = null;
			lineHit = null;
			lineClick = null;
			sLine = null;
			mouseTrack = null;
			
		}
		
    }
}








