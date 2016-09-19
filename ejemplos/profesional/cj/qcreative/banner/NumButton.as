package cj.qcreative.banner {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	
	// this class controls the numbered button behaviour
    public final class NumButton extends Sprite {
		
		private var lm:Shape,
		rm:Shape,
		gr:Shape,
		hover:Sprite,
		masker:Sprite,
		gHolder:Sprite,
		myHover:Sprite,
		sp:MySprite,
		numText:NumberText,
		ar:Array,
		total:int,
		current:int,
		w:int,
		h:int,
		onHover:Boolean,
		invert:Boolean,
		func:Function;
		
		// class constructor
		public function NumButton(cb:Function, tlt:int, iVert:Boolean = true) {
			
			// store the constructor data so we can access it later
			func = cb;
			total = tlt;
			invert = iVert;
			
			onHover = false;
			BannerTracker.numbers = this;
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			
		}
		
		// fires when added to the stage
		private function added(event:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			ar = [];
			
			// loop to create each button
			for(var i:int = 0; i < total; i++) {
				
				sp = new MySprite(i);
				ar[i] = sp;
				
				(invert) ? sp.blendMode = BlendMode.INVERT : sp.alpha = 0;
				
				(i != 0) ? sp.addEventListener(MouseEvent.CLICK, clicked, false, 0, true) : null;
				sp.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				sp.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				sp.buttonMode = true;
				sp.x = i * 16;
				addChild(sp);
				
			}
			
			w = this.width;
			h = 19;
			
			// if invert xml property has been chosen
			if(invert) {
				
				hover = new Sprite();
				hover.graphics.beginFill(0xFFFFFF);
				hover.graphics.drawRect(0, 0, 16, 19);
				hover.graphics.endFill();
				
				hover.blendMode = BlendMode.INVERT;
				hover.mouseEnabled = false;
				myHover = hover;
				addChild(hover);

			}
			
			// if no invert is to be applied
			else {
				
				gr = drawShape(0x000000, w, 19);
				gr.alpha = 0.3;
				
				gHolder = new Sprite();
				gHolder.addChild(gr);
				
				lm = drawShape(0xFFFFFF, w, h);
				rm = drawShape(0xFFFFFF, w, h);
				lm.x = -w;
				rm.x = 16;
				
				masker = new Sprite();
				masker.addChild(lm);
				masker.addChild(rm);
				myHover = masker;
				gHolder.mask = masker;
				
				addChildAt(masker, 0);
				addChildAt(gHolder, 0);
				
			}
			
			i = total;
			
			// create the number TextFields
			while(i--) {
				
				numText = new NumberText();
				numText.x = i * 16;
				numText.mouseEnabled = false;
				numText.mouseChildren = false;
				numText.txt.text = String(i + 1);
				addChild(numText);
				
			}
			
			addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
		}
		
		// utility function for drawing a Shape
		private function drawShape(color:uint, ww:int, hh:int):Shape {
			
			var sh:Shape = new Shape();
			sh.graphics.beginFill(color);
			sh.graphics.drawRect(0, 0, ww, hh);
			sh.graphics.endFill();
			
			return sh;
			
		}
		
		// "punches" the next number that represents the clicked slide
		internal function moveHover(cur):void {
			
			current = cur;
			
			(!onHover) ? TweenMax.to(myHover, 0.5, {x: current * 16, ease: Quad.easeOut}) : null;
			
			for(var j:int = 0; j < total; j++) {
				
				if(j != current) {
					ar[j].addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
				}
				else {
					ar[j].removeEventListener(MouseEvent.CLICK, clicked);
				}
				
			}

		}
		
		// mouse over function
		private function over(event:MouseEvent):void {
			
			onHover = true;
			var i:int = event.currentTarget.id;
			TweenMax.to(myHover, 0.5, {x: i * 16, ease: Quint.easeOut});
			
		}
		
		// mouse out function
		private function out(event:MouseEvent):void {
			
			onHover = false;
			
			TweenMax.to(myHover, 0.5, {x: current * 16, ease: Quint.easeOut});
			
		}
		
		// number click function
		private function clicked(event:MouseEvent):void {
			
			current = event.currentTarget.id;
			func(current);
			moveHover(current);
			
		}
		
		// GARBAGE COLLECTION
		internal function finalKill():void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.ROLL_OUT, out);
			
			TweenMax.killTweensOf(myHover);
			
			// remove event listeners
			for(var i:int = 0; i < total; i++) {
				ar[i].removeEventListener(MouseEvent.ROLL_OVER, over);
				ar[i].removeEventListener(MouseEvent.ROLL_OUT, out);
				ar[i].removeEventListener(MouseEvent.CLICK, clicked);
			}
			
			// remove children
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			// clear graphics
			if(invert) {
				hover.graphics.clear();
				hover = null;
			
			}
			
			// clean up for non invert setup
			else {
				
				masker.removeChild(lm);
				masker.removeChild(rm);
				gHolder.removeChild(gr);
				
				lm.graphics.clear();
				rm.graphics.clear();
				gr.graphics.clear();
				
				lm = null;
				rm = null;
				gr = null;
				
				masker = null;
				gHolder = null;
				
			}
			
			// set vars to null
			ar = null;
			sp = null;
			numText = null;
			myHover = null;
			func = null;
			
		}
		
		
    }
}








