package cj.qcreative.banner {
	
	import flash.display.Sprite;
	
	// this class allows us to store a variable in a Sprite and also draws it
    public final class MySprite extends Sprite {

		internal var id:int;
		
		public function MySprite(who:int) {
			
			id = who;
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, 16, 19);
			this.graphics.endFill();
			
		}
		
    }
	
}








