package cj.qcreative.contact {
	
	import flash.display.Sprite;
	
	// this class allows us to attach some variables to a Sprite
    public final class MySprite extends Sprite {

		internal var id:int;
		
		public final function MySprite(who:int, boo:Boolean = false) {
			
			id = who;
			
			var h:int;
			(!boo) ? h = 20 : h = 175;
			
			// draw the Sprite
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, 300, h);
			this.graphics.endFill();
			
			this.mouseEnabled = false;
			
		}
		
    }
	
}








