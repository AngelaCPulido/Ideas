package cj.qcreative.news.graphics {
	
    import flash.display.Shape;
	
	// this class draws out a Shape
    public class Masker extends Shape {
		
        public function Masker(w:int, h:int) { 
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
        }
		
		// garbage collection
		public function kill():void {
			
			graphics.clear();
			
		}
		
    }
}