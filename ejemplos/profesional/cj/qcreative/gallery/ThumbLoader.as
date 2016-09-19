package cj.qcreative.gallery {
	
	import flash.display.Loader;
	
	// this class allows us to store a variable in a Loader
	public final class ThumbLoader extends Loader {
		
		internal var id:int;
		
		public function ThumbLoader(i:int) {
			
			id = i;
			this.mouseEnabled = false;
			
		}
		
	}
	
}