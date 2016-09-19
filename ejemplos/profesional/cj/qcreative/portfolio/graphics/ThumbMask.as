package cj.qcreative.portfolio.graphics {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	
	// this class controls the thumbnail mask
    public class ThumbMask extends Sprite {
		
		// begin private vars
		private var left:Shape, right:Shape, tw:int, th:int, sw:int;
		// end private vars
		
		// class constructor
		public function ThumbMask() {
			
			this.mouseEnabled = false;
			
		}
		
		// stores the stage width
		private function getStage():void {
			
			sw = stage.stageWidth;
			
		}
		
		// draws and returns a Shape
		private function buildShape(tw:int, th:int):Shape {
			
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xFF0000);
			sh.graphics.drawRect(0, 0, tw, th);
			sh.graphics.endFill();
			sh.alpha = 0.5;
			
			return sh;
			
		}
		
		// utility function for Math.ceil
		private function ceiler(num:Number):Number {
    		return num == int(num) ? num : int(num + 1);
		}
		
		// activates the thumb mask
		public function activate(w:int, h:int):void {
			
			getStage();
			
			tw = w;
			th = h;
			
			var space:Number = ceiler((sw - tw) >> 1) - 16;
			
			if(left != null) {
				removeChild(left);
				left.graphics.clear();
			}
			
			left = buildShape(space - 16, th);
			addChild(left);
			
			if(right != null) {
				removeChild(right);
				right.graphics.clear();
			}
			
			right = buildShape(space, th);
			addChild(right);

			left.x = -space;
			right.x = tw + 16;
			
		}
		
    }
}








