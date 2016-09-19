package cj.qcreative.news {
	
	// this class allows us to track the stage globally
	public class NewsTracker {
		
		internal static var stager:Object;
		
		internal static function kill():void {
			
			stager = null;
			
		}
		
	}
	
}