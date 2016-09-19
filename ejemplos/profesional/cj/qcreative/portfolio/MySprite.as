package cj.qcreative.portfolio {
	
	import flash.display.Sprite;
	import cj.qcreative.videoplayer.SingleVideo;
	
	// this class adds variables to a Sprite and also stores information about video
    public class MySprite extends Sprite {
		
		// begin internal vars
		internal var id:int,
		myX:Number,
		containsVid:Boolean,
		autoStart:Boolean,
		containsPrev:Boolean,
		hasHit:Boolean,
		vid:SingleVideo;
		// end internal vars
		
		// class constructor
		public function MySprite(i:int) {
			
			id = i;
			hasHit = false;
			containsVid = false;
			containsPrev = false;
			this.mouseEnabled = false;
			
		}
		
		// plays the video
		internal function showControls():void {
			
			vid.showControls(autoStart);
			
		}
		
		// kills the video
		internal function resetVid():void {
			
			vid.resetVid(true);
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			vid.kill();
			vid = null;
			
		}
		
    }
}








