package cj.qcreative.portfolio.graphics {
	
	import flash.display.Shape;
    import flash.display.Sprite;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	// this class controls the text field mask gradient
    public final class MyGradient extends Sprite {
		
		// begin private vars
		private var sh1:Shape, sh2:Shape;
		// end private vars
		
		// class constructor
        public function MyGradient() { 
			
			this.mouseEnabled = false;
			sh1 = new Shape();
			sh2 = new Shape();
			
			sh1.rotation = 90;
			
			addChild(sh1);
			addChild(sh2);
			
        }
		
		// removes/adds the gradient
		public function fix(addIt:Boolean = false):void {
			
			if(!addIt) {
				(this.contains(sh1)) ? removeChild(sh1) : null;
			}
			else {
				addChild(sh1);
			}
		
		}
		
		// draws the gradient
		public function update(w:int, h:int):void {
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(h, 1);
			
			sh1.graphics.clear();
			sh1.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 255], matr, SpreadMethod.PAD);
			sh1.graphics.drawRect(0, 0, h, w);
			sh1.graphics.endFill();
			sh1.x = w;
			sh1.y = h;
			
			sh2.graphics.clear();
			sh2.graphics.beginFill(0xFFFFFF);
			sh2.graphics.drawRect(0, 0, w, h);
			sh2.graphics.endFill();
			
		}
		
		// GARBAGE COLLECTION
		public function kill():void {
			
			sh1.graphics.clear();
			sh2.graphics.clear();
			
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			sh1 = null;
			sh2 = null;
			
		}
		
    }
}









