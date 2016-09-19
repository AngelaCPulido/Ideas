package cj.qcreative.banner {

	import flash.display.Sprite;
	
	// this class allows us to track vars globally within the module
    public final class BannerTracker {
		
		// begin internal vars
		internal static var banner:Object,
		numbers:Object,
		masker1:Object,
		masker2:Object,
		h1:Sprite,
		h2:Sprite,
		blurHolder:Sprite,
		infoWorking:Boolean,
		slide1Working:Boolean = false,
		slide2Working:Boolean = false,
		playOn:Boolean = true;
		// end internal vars
		
		// called when module is unloaded
		internal static function finalKill():void {
			
			// set all vars to null
			banner = null;
			numbers = null;
			masker1 = null;
			masker2 = null;
			h1 = null;
			h2 = null;
			blurHolder = null;
			
		}
		
    }
	
}