package cj.qcreative.graphics {
	
    import flash.display.Sprite;
	
	// this class draws a simple Sprite
    public final class Container2 extends Sprite {
		
        public function Container2(w:int = 50, h:int = 50) { 
			
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
        }
    }
}