package cj.qcreative.banner {
	
	import flash.display.Sprite;
	
	// this class extends the CreateMasks class
    public final class CreateMasks2 extends CreateMasks {
		
		// class constructor
		public function CreateMasks2(w:int, h:int, cb:Function, fnct:Function, hold:Sprite, dumper:Function) {
			
			super(w, h, cb, fnct, hold, dumper, "m2");
			
		}
		
		// fade in the bars
		override internal function fadeIn(bars:Boolean):void {
			
			super.fadeIn(bars);
			
		}
		
		// fade out the bars
		override internal function fadeOut(bars:Boolean):void {
			
			super.fadeOut(bars);
			
		}
		
		// GARBAGE COLLECTION
		override internal function finalKill():void {
			
			super.finalKill();
			
		}
		
    }
}








