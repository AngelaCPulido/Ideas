package cj.qcreative.gallery.graphics {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	// this class us used for simple graphic drawing
    public class Drawing {
		
		// draws a Shape
		public static function drawShape(sh:Shape, color:uint, x:int, y:int, w:int, h:int):void {
			
			sh.graphics.clear();
			sh.graphics.beginFill(color);
			sh.graphics.drawRect(x, y, w, h);
			sh.graphics.endFill();
			
		}
		
		// draws and returns a Sprite
		public static function drawSprite(color:uint, x:int, y:int, w:int, h:int):Sprite {
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(x, y, w, h);
			sp.graphics.endFill();
			
			return sp;
			
		}
		
		// draws a Sprite
		public static function updateSprite(sp:Sprite, w:int, h:int):void {
			
			sp.graphics.clear();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			
		}
		
		// draws a gradient
		public static function drawGradient(sh:Shape, w:int, w2:int, h:int):void {
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, 1);
			
			sh.graphics.clear();
      		sh.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 1], [0, 255], matr, SpreadMethod.PAD);
     		sh.graphics.drawRect(0, 0, w2, h);
			sh.graphics.endFill();
			
		}
		
    }
}








