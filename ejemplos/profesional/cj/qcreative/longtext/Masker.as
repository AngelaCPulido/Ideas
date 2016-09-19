package cj.qcreative.longtext {
	
    import flash.display.Sprite;
	
	// this class allows us to store a variable in a Sprite
    public class Masker extends Sprite {
		
		internal var square:Sprite;
		
        public function Masker(w:int, h:int) { 
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			// draw the Sprite
			square = new Sprite();
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(0, 0, w, h);
			square.graphics.endFill();
			addChild(square);
			
        }
    }
}