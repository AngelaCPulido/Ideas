package cj.qcreative.gallery {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.StyleSheet;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Linear;
	
	// this class holds each thumbnail
    public final class ThumbHolder extends Sprite {
		
		// begin private vars
		private var id:int,
		w:int,
		h:int,
		posX:int,
		posY:int,
		gradStart:int,
		tColor:String,
		tSize:String,
		myTitle:String,
		bit:Bitmap,
		cover:Sprite,
		bMask:Sprite,
		bHolder:Sprite,
		container:Sprite,
		myNumber:MyNumber,
		textTitle:TextTitle,
		styles:StyleSheet,
		kickBack:Function,
		active:Boolean,
		useNum:Boolean;
		
		private const tMargin:int = 4, tHeight:int = 30, gradEnd:int = 16;
		// end private vars
		
		// begin internal vars
		internal var bData:BitmapData;
		// end intenral vars
		
		// class constructor
		public function ThumbHolder(st:String, i:int, ww:int, hh:int, colorT:String, sizeT:String, pX:int, pY:int, cb:Function, useNums:Boolean, style:StyleSheet) {
			
			active = true;
			myTitle = st;
			id = i;
			w = ww;
			h = hh;
			tColor = colorT;
			tSize = sizeT;
			posX = pX;
			posY = pY;
			kickBack = cb;
			useNum = useNums;
			styles = style;
			
		}
		
		// utility function to draw a Shape
		private function drawShape(ww:int, hh:int):Shape {
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, ww, hh);
			sh.graphics.endFill();
			
			return sh;
			
		}
		
		// activates a thumb for mouse events
		internal function activate(bigOn:Boolean = false):void {
			
			active = true;
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
			if(!bigOn) {
				this.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
			}
			else {
				this.addEventListener(MouseEvent.CLICK, bigClick, false, 0, true);
			}
		}
		
		internal function addMouse():void {
			
			if(active) {
				this.buttonMode = true;
				this.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				this.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
			}
			
		}
		
		// mouse click event
		private function bigClick(event:MouseEvent):void {
			
			GalleryTracker.arrows.righty();
			
		}
		
		// temporarily deactivate mouse events
		internal function deactivate():void {
			
			active = false;
			
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.ROLL_OVER, over);
			this.removeEventListener(MouseEvent.ROLL_OUT, out);
			this.removeEventListener(MouseEvent.CLICK, clicker);
			this.removeEventListener(MouseEvent.CLICK, bigClick);
			
			if(cover != null) {
				(cover.alpha != 0.5) ? TweenMax.to(cover, 1, {alpha: 0.5, ease: Quint.easeOut}) : null;
			}
			
			if(bMask != null) {
				(bMask.x != gradStart) ? TweenMax.to(bMask, 0.75, {x: gradStart, ease: Linear.easeNone}) : null;
			}
			
		}
		
		// sets up the roll over title and number for the thumbnail
		internal function go():void {
			
			if(myTitle != "") {
			
				var bitData:BitmapData = bData.clone(),
				bf:BlurFilter = new BlurFilter(27, 27, 3),
				ww:int = w - 32,
				hh:int,
				matr:Matrix = new Matrix(),
				sh1:Shape = new Shape(),
				txtH:int,
				sh2:Shape,
				plus8:int,
				conMask:Shape;
				
				bit = new Bitmap(bitData);
				bit.filters = [bf];
				
				gradStart = -((ww * 2) + 16);
				
				textTitle = new TextTitle();
				textTitle.x = 20;
				textTitle.txt.width = ww - tMargin;
				(styles != null) ? textTitle.txt.styleSheet = styles : null;
				textTitle.txt.htmlText = myTitle;
				
				txtH = textTitle.txt.textHeight;
				plus8 = txtH + 16;
				
				sh2 = drawShape(ww, plus8);
				conMask = drawShape(ww, plus8);
				
				textTitle.txt.height = txtH;
				
				hh = h - plus8 - 16,
				
				textTitle.y = hh + tMargin + 3;
				
				matr.createGradientBox(ww, 1);

				sh1.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 255], matr, SpreadMethod.PAD);
				sh1.graphics.drawRect(0, 0, ww, plus8);
				sh1.graphics.endFill();
				sh1.x = ww;
				
				bMask = new Sprite();
				bMask.addChild(sh1);
				bMask.addChild(sh2);
				
				bMask.x = gradStart;
				bMask.y = hh;
				bMask.cacheAsBitmap = true;
				
				bHolder = new Sprite();
				bHolder.cacheAsBitmap = true;
				bHolder.mask = bMask;
				
				bHolder.addChild(bit);
				bHolder.addChild(textTitle);
				
				container = new Sprite();
				container.addChild(bMask);
				container.addChild(bHolder);
				
				conMask.x = 16;
				conMask.y = hh;
				
				container.mask = conMask;
				
				addChild(container);
				addChild(conMask);
				
			}
			
			cover = new Sprite();
			cover.graphics.beginFill(0x000000);
			cover.graphics.drawRect(0, 0, w, h);
			cover.graphics.endFill();
			cover.alpha = 0.5;
			addChild(cover);
			
			if(useNum) {
				
				var i:int = id + 1;
				
				var num:String = i.toString();
				if(num.length == 1) {
					num = "0" + num;
				}
				
				myNumber = new MyNumber();
				myNumber.txt.htmlText = "<font size='" + tSize + "' color='" + tColor + "'>" + num + "</font>";
				myNumber.x = posX;
				myNumber.y = posY;
				myNumber.mouseEnabled = false;
				myNumber.mouseChildren = false;
				myNumber.alpha = 0;
				addChild(myNumber);
			}
			
			bData = null;
			
		}
		
		// mouse over function
		private function over(event:MouseEvent):void {
			
			TweenMax.to(cover, 1, {alpha: 0, ease: Quint.easeOut});
			
			if(useNum) {
				TweenMax.killTweensOf(myNumber);
				myNumber.alpha = 0.45;
				TweenMax.to(myNumber, 1, {alpha: 0, ease: Linear.easeNone});
			}
			
			(bMask != null) ? TweenMax.to(bMask, 0.75, {x: gradEnd, ease: Linear.easeNone}) : null;
			
		}
		
		// mouse out function
		private function out(event:MouseEvent):void {
			
			TweenMax.to(cover, 1, {alpha: 0.5, ease: Quint.easeOut});
			
			(bMask != null) ? TweenMax.to(bMask, 0.75, {x: gradStart, ease: Linear.easeNone}) : null;
			
		}
		
		// mouse click function
		private function clicker(event:MouseEvent):void {
			
			kickBack(id);
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			this.removeEventListener(MouseEvent.ROLL_OVER, over);
			this.removeEventListener(MouseEvent.ROLL_OUT, out);
			this.removeEventListener(MouseEvent.CLICK, clicker);
			this.removeEventListener(MouseEvent.CLICK, bigClick);
			
			TweenMax.killTweensOf(cover);
			TweenMax.killTweensOf(bMask);
			
			if(useNum && myNumber != null) {
				TweenMax.killTweensOf(myNumber);
				myNumber.removeChildAt(0);
				myNumber = null;
			}
			
			if(bit != null) {
				
				BitmapData(Bitmap(getChildAt(1)).bitmapData).dispose();

				textTitle.removeChildAt(0);
				
				Shape(bMask.getChildAt(0)).graphics.clear();
				Shape(bMask.getChildAt(1)).graphics.clear();
				
				bMask.removeChildAt(0);
				bMask.removeChildAt(0);
				
				bHolder.removeChild(bit);
				bHolder.removeChild(textTitle);
				
				container.removeChild(bMask);
				container.removeChild(bHolder);
				
				bit.bitmapData.dispose();
			}
			
			if(cover != null) {
				cover.graphics.clear();
			}
			
			while(this.numChildren) {
				
				if(getChildAt(0) is MovieClip) {
					MovieClip(getChildAt(0)).stop();
				}
				
				removeChildAt(0);
			}
			
			bData = null;
			bit = null;
			cover = null;
			bMask = null;
			bHolder = null;
			container = null;
			textTitle = null;
			kickBack = null;
			styles = null;
			
		}
		
		
    }
}








