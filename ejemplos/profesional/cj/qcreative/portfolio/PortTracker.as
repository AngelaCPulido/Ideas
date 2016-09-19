package cj.qcreative.portfolio {
	
	// this class tracks variables throughout the module
	public final class PortTracker {
		
		// begin public vars
		public static var home:Object;
		// end public vars
		
		// begin internal vars
		internal static var stager:Object;
		internal static var arrowsReady:Boolean = false;
		// end internal vars
		
		// GARBAGE COLLECTION
		internal static function kill():void {
			
			home = null;
			stager = null;
			
		}
		
	}
	
}