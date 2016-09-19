package cj.qcreative.graphics {
	
    import flash.display.Sprite;
	
	// this class allows us to store some additional variables to a Sprite
    public final class Container extends Sprite {
		
		public var id:int;
		public var xx:int;
		public var textString:String;
		public var hasSub:Boolean;
		public var sp:Sprite;
		
        public function Container(w:int = 50, h:int = 50, color:uint = 0x000000, who:int = undefined, str:String = undefined, sub:Boolean = false, useContainer:Boolean = false) { 
			
			id = who;
			textString = str;
			hasSub = sub;
			
			// if only a Shape is needed
			if(!useContainer) {
				graphics.beginFill(color);
				graphics.drawRect(0, 0, w, h);
				graphics.endFill();
			}
			
			// if a Sprite is needed
			else {
				sp = new Sprite();
				sp.graphics.beginFill(color);
				sp.graphics.drawRect(0, 0, w, h);
				sp.graphics.endFill();
				addChild(sp);
			}
        }
		
		// cleans up the Sprite
		public function removeSprite():void {
			
			removeChild(sp);
			sp.graphics.clear();
			sp = null;
			
		}
		
    }
}