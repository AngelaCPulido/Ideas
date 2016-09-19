package cj.qcreative.banner {
	
	import flash.display.Sprite;
	
	// this class extends the CreateMasks class
    public final class CreateMasks1 extends CreateMasks {
		
		// class constructor
		public function CreateMasks1(w:int, h:int, cb:Function, fnct:Function, hold:Sprite, dumper:Function) {
			
			super(w, h, cb, fnct, hold, dumper, "m1");
			
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








