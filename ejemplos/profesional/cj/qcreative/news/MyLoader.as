package cj.qcreative.news {
	
	import flash.display.Loader;
	
	// this class allows us to store some variables in a Loader
    public class MyLoader extends Loader {
		
		internal var id:int, isLoading:Boolean;
		
		public function MyLoader(i:int) {
			id = i;
			isLoading = true;
			this.mouseEnabled = false;
		}
		
    }
}








