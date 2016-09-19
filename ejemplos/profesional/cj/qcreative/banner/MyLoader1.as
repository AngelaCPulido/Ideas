package cj.qcreative.banner {
	
	// this class extends the MyLoader class
    public final class MyLoader1 extends MyLoader {
		
		// class constructor
		public function MyLoader1(func:Function) {
			
			super(func);
			
		}
		
		// load in a new slide
		override internal function loadIt(st:String, usingTwo:Boolean, overLoad:Boolean, bar:Boolean):void {
			
			super.loadIt(st, usingTwo, overLoad, bar);
			
		}
		
		// kill the previous slide
		override internal function kill():void {
			
			super.kill();
			
		}
		
		// GARBAGE COLLECTION
		override internal function finalKill():void {
			
			super.finalKill();
			
		}
		
    }
}








