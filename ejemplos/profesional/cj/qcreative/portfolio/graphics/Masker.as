package cj.qcreative.portfolio.graphics {
	
    import flash.display.Sprite;
	
	// this class allows us to store a variable in a Sprite
    public final class Masker extends Sprite {
		
		internal var square:Sprite;
		
		// class constructor
        public function Masker(w:int, h:int) { 
			
			this.mouseEnabled = false;
			square = new Sprite();
			square.mouseEnabled = false;
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(0, 0, w, h);
			square.graphics.endFill();
			addChild(square);
			
        }
		
		public function kill():void {
			
			removeChild(square);
			square.graphics.clear();
			square = null;
			
		}
		
    }
}