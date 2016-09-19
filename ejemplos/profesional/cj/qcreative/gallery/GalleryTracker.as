package cj.qcreative.gallery {

	import flash.display.Sprite;
	
	// this class allows us to track global vars 
    public final class GalleryTracker {
		
		public static var homer:Object;
		
		internal static var myGal:Sprite,
		blurHolder:Sprite,
		arrows:Object,
		infoWorking:Boolean = false;
		
		// GARBAGE COLLECTION
		internal static function finalKill():void {
			
			homer = null;
			myGal = null;
			blurHolder = null;
			arrows = null;
			
		}
		
    }
	
}