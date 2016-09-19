package cj.qcreative.videoplayer {
	
	// this class allows us to track the video player globally
    public final class VideoTracker {
		
		public static var myVid:Object;
		
		internal static function kill():void {
			
			myVid = null;
			
		}
		

    }
	
}