package cj.qcreative.videoplayer {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	
	// this class draws the video control background image
    public final class Shaper extends Sprite {
		
		// begin private vars
		private var left:Shape,
		right:Shape,
		center:Shape,
		lMask:Shape,
		rMask:Shape,
		lHolder:Sprite,
		rHolder:Sprite;
		// end private vars
		
		// class constructor
		public function Shaper(w:int) {
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			left = drawRound();
			right = drawRound();
			center = new Shape();
			
			lMask = drawMask();
			rMask = drawMask();
			
			left.mask = lMask;
			right.mask = rMask;
			
			lHolder = new Sprite();
			rHolder = new Sprite();
			
			lHolder.addChild(left);
			lHolder.addChild(lMask);
			
			rHolder.addChild(right);
			rHolder.addChild(rMask);
			
			center.x = 25;
			right.x = -25;
			
			drawCenter(w);
			
			addChild(lHolder);
			addChild(rHolder);
			addChild(center);
			
		}
		
		// draws a Shape
		private function drawMask():Shape {
			
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, 25, 41);
			sh.graphics.endFill();
			
			return sh;
			
		}
		
		// calculates the center of the player
		internal function drawCenter(w:int):void {
			
			w -= 50;
			
			center.graphics.clear();
			center.graphics.beginFill(0x000000);
			center.graphics.drawRect(0, 0, w, 41);
			center.graphics.endFill();
			
			rHolder.x = w + 25;
			
		}
		
		// draws a round rectangle
		private function drawRound():Shape {
			
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRoundRect(0, 0, 50, 41, 10);
			sh.graphics.endFill();
			
			return sh;
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
				
			lHolder.removeChild(left);
			lHolder.removeChild(lMask);
			
			rHolder.removeChild(right);
			rHolder.removeChild(rMask);
			
			removeChild(lHolder);
			removeChild(rHolder);
			removeChild(center);
			
			left.graphics.clear();
			right.graphics.clear();
			center.graphics.clear();
			lMask.graphics.clear();
			rMask.graphics.clear();
			
			left = null;
			right = null;
			center = null;
			lMask = null;
			rMask = null;
			lHolder = null;
			rHolder = null;
			
		}
		
    }
}








