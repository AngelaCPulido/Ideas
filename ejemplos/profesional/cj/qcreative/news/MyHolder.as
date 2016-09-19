package cj.qcreative.news {
	
	import flash.display.Sprite;
	
	// this class allows us to store some variables in a Sprite
    public class MyHolder extends Sprite {
		
		internal var id:int;
		internal var hasHit:Boolean;
		
		public function MyHolder(i:int) {
			
			id = i;
			hasHit = false;
			this.mouseEnabled = false;
			
		}
		
    }
}








