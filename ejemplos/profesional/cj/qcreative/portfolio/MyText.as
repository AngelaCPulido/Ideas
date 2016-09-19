package cj.qcreative.portfolio {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cj.qcreative.Tracker;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class is for a section's text field and is subclassed
    public class MyText extends Sprite {
		
		// begin private vars
		private var tHolder:Sprite,
		aHolder:Sprite,
		cHolder:Sprite,
		tMask:Sprite,
		tMask2:Sprite,
		pops:Sprite,
		tShape:Shape,
		theText:TheText,
		scroller:Scroller,
		prevTitle:PreviewTitle,
		upper:SmallArrow,
		downer:SmallArrow,
		closer:Closer,
		w:int,
		h:int,
		total:int,
		distH:int,
		spaceW:int,
		spaceH:int,
		goTo:String,
		arrowsOn:Boolean,
		kickBack:Function;
		// end private vars
		
		// class constructor
		public function MyText(sp:Sprite, bw:int, bh:int, func:Function) {
			
			pops = sp;
			w = bw;
			h = bh;
			kickBack = func;
			arrowsOn = false;
			this.mouseEnabled = false;
			
		}
		
		// calculalates the text fields height
		internal function fixMenu(st:String):int {
			
			prevTitle.txt.htmlText = st;
			
			var space:int, sh:int, myW:int, myY:int;
			
			space = (stage.stageWidth - 250 - w - 32) >> 1;
			
			prevTitle.txt.width = space - 16;
			
			sh = prevTitle.txt.textHeight;
			prevTitle.txt.height = sh + 10;
			
			space = prevTitle.txt.textWidth + 8;
			
			(space < 73) ? space = 73 : null;
			
			prevTitle.txt.width = space;
			
			myW = w + 12;
			myY = sh + 32;
			
			aHolder.x = tMask.x = myW;
			cHolder.y = myY;
			
			spaceW = space + 8;
			spaceH = myY;
			
			tShape.graphics.clear();
			tShape.graphics.beginFill(0x000000);
			tShape.graphics.drawRect(0, 0, spaceW, spaceH + 20);
			tShape.graphics.endFill();
			
			return space;
			
		}
		
		// arrow click event
		internal function goClick():void {
			
			if(arrowsOn) {
				upper.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
				downer.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
			}
			
		}
		
		// adds mouse events to the control buttons
		internal function wipeControl(noWipe:Boolean):void {
			
			arrowsOn = true;
			
			if(PortTracker.arrowsReady) {
				
				upper.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
				downer.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
				
			}
			
			upper.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			downer.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				
			upper.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			downer.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
			closer.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			closer.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			closer.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
			
			if(!noWipe) {
				callPort();
				TweenMax.to(tMask, 0.75, {scaleX: 1, ease: Quint.easeOut});
				TweenMax.to(tMask2, 0.75, {scaleX: 1, ease: Quint.easeOut});
			}
		
		}
		
		// tells the Q to add the blur background to the controls
		internal function callPort(fromResize:Boolean = false):void {
			
			(Tracker.template) ? Tracker.template.portControl(spaceW, spaceH, h, distH, fromResize) : null;
			
		}
		
		// activates and deactivates the scrollbar
		internal function setScroll(kill:Boolean = false, sectionOn:Boolean = false):void {
			
			if(!kill) {
				scroller.activate(total, distH);
			}
			else {
				(sectionOn) ? wipeBack(true) : null;
				scroller.deactivate();				
			}
			
		}
		
		// returns the height of the text field
		internal function getHigh():int {
			
			ripText();
			setScroll(true);
			setScroll();
			
			return distH - 32;
			
		}
		
		// sets the heihgt of the text field
		private final function ripText():void {
			
			total = theText.txt.textHeight + 10;
			
			distH = stage.stageHeight - (h + 48);
			
			var buf:int;
			
			if(total > distH) {
				theText.txt.width = w - 16;
				buf = 8;
			}
			else {
				theText.txt.width = w;
				buf = 0;
			}
			
			total = theText.txt.textHeight + 10;
			(buf == 0) ? distH = total : null;
			theText.txt.height = total + buf;
			
		}
		
		// setd the text field text
		internal function setText(st:String):int {
			
			theText.txt.htmlText = st;
			
			ripText();
			
			return distH - 32;
			
		}
		
		// kills the controls
		internal function wipeBack(noKick:Boolean = false):void {
			
			removeListen();
			(Tracker.template) ? Tracker.template.outPort() : null;
			TweenMax.to(tMask, 0.5, {scaleX: 0, ease: Quint.easeOut});
			TweenMax.to(tMask2, 0.5, {scaleX: 0, ease: Quint.easeOut});
			(!noKick) ? kickBack(goTo) : null;
			
		}
		
		// removes all mouse events
		internal function removeListen():void {
			
			arrowsOn = false;
			
			closer.removeEventListener(MouseEvent.ROLL_OVER, over);
			upper.removeEventListener(MouseEvent.ROLL_OVER, over);
			downer.removeEventListener(MouseEvent.ROLL_OVER, over);
			
			closer.removeEventListener(MouseEvent.ROLL_OUT, out);
			upper.removeEventListener(MouseEvent.ROLL_OUT, out);
			downer.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			closer.removeEventListener(MouseEvent.CLICK, clicker);
			upper.removeEventListener(MouseEvent.CLICK, clicker);
			downer.removeEventListener(MouseEvent.CLICK, clicker);
			
			closer.gotoAndStop(1);
			upper.gotoAndStop(1);
			downer.gotoAndStop(1);
			
		}
		
		// mouse over event
		private final function over(event:MouseEvent):void {
			
			event.currentTarget.gotoAndPlay("over");
			
		}
		
		// mouse out event
		private final function out(event:MouseEvent):void {
			
			event.currentTarget.gotoAndPlay("out");
			
		}
		
		// mouse click event
		private final function clicker(event:MouseEvent):void {
			
			switch(event.currentTarget.name) {
				
				case "downer":
				
					goTo = "down";
					
					if(PortTracker.home.isOn != PortTracker.home.iTotal) {
						wipeBack();
					}
					
				break;
				
				case "upper":
					goTo = "up";
					
					if(PortTracker.home.isOn != 0) {
						wipeBack();
					}
					
				break;
				
				case "closer":
				
					goTo = "close";
					wipeBack();
					
				break;
				
			}

		}
		
		// activates the controls
		internal function setUp(style:StyleSheet = null):void {
			
			theText = new TheText();
			theText.mouseEnabled = false;
			
			tHolder = new Sprite();
			tHolder.mouseEnabled = false;
			
			scroller = new Scroller(theText, w, h);
			scroller.mouseEnabled = false;
			
			prevTitle = new PreviewTitle();
			prevTitle.mouseEnabled = false;
			prevTitle.txt.selectable = true;
			prevTitle.txt.multiline = true;
			prevTitle.txt.wordWrap = true;
			prevTitle.txt.mouseWheelEnabled = false;
			
			if(style) {
				theText.txt.styleSheet = style;
				prevTitle.txt.styleSheet = style;
			}
			
			closer = new Closer();
			upper = new SmallArrow();
			downer = new SmallArrow();
			
			closer.name = "closer";
			upper.name = "upper";
			downer.name = "downer";
			
			closer.x = 4;
			upper.x = 31;
			downer.x = 69;
			
			closer.buttonMode = true;
			upper.buttonMode = true;
			downer.buttonMode = true;
			
			upper.y = 2;
			downer.rotation = 180;
			downer.y = 9.3;
			
			tShape = new Shape();
			
			tMask = new Sprite();
			tMask.mouseEnabled = false;
			tMask.addChild(tShape);
			tMask.scaleX = 0;
			
			tMask2 = new Sprite();
			tMask2.mouseEnabled = false;
			tMask2.graphics.beginFill(0x000000);
			tMask2.graphics.drawRect(0, 0, 81, 28);
			tMask2.graphics.endFill();
			tMask2.scaleX = 0;
			tMask2.y = -9;
			
			cHolder = new Sprite();
			cHolder.mouseEnabled = false;
			cHolder.addChild(closer);
			cHolder.addChild(upper);
			cHolder.addChild(downer);
			cHolder.addChild(tMask2);
			
			cHolder.mask = tMask2;
			prevTitle.mask = tMask;
			
			aHolder = new Sprite();
			aHolder.mouseEnabled = false;
			aHolder.addChild(prevTitle);
			aHolder.addChild(cHolder);
			
			tHolder.addChild(scroller);
			tHolder.addChild(aHolder);
			tHolder.addChild(tMask);
			
			pops.addChild(tHolder);
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			closer.removeEventListener(MouseEvent.ROLL_OVER, over);
			upper.removeEventListener(MouseEvent.ROLL_OVER, over);
			downer.removeEventListener(MouseEvent.ROLL_OVER, over);
			
			closer.removeEventListener(MouseEvent.ROLL_OUT, out);
			upper.removeEventListener(MouseEvent.ROLL_OUT, out);
			downer.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			closer.removeEventListener(MouseEvent.CLICK, clicker);
			upper.removeEventListener(MouseEvent.CLICK, clicker);
			downer.removeEventListener(MouseEvent.CLICK, clicker);
			
			TweenMax.killTweensOf(tMask);
			
			closer.stop();
			upper.stop();
			downer.stop();
			
			cHolder.removeChild(closer);
			cHolder.removeChild(upper);
			cHolder.removeChild(downer);
			
			aHolder.removeChild(prevTitle);
			aHolder.removeChild(cHolder);
			
			tMask.removeChild(tShape);
			
			tHolder.removeChild(scroller);
			tHolder.removeChild(aHolder);
			tHolder.removeChild(tMask);
			
			pops.removeChild(tHolder);
			
			tShape.graphics.clear();
			
			scroller.kill();
			
			theText.removeChildAt(0);
			prevTitle.removeChildAt(0);
			closer.removeChildAt(0);
			upper.removeChildAt(0);
			downer.removeChildAt(0);
			
			tHolder = null;
			aHolder = null;
			cHolder = null;
			tMask = null;
			pops = null;
			tShape = null;
			theText = null;
			scroller = null;
			prevTitle = null;
			upper = null;
			downer = null;
			closer = null;
			kickBack = null;
			
		}
		
		
    }
}








