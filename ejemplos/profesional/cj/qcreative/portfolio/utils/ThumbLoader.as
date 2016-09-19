package cj.qcreative.portfolio.utils {
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	// this class is used for loading all the thumbnails in
	public class ThumbLoader {
		
		// begin public vars
		public static var kickBack:Function;
		// end public vars
		
		// begin private vars
		private static var i:int, total:int, xList:XMLList, loader:Loader, isLoading:Boolean = false;
		// end private vars
		
		// fires when loading is to begin
		public static function loadThumbs(listX:XMLList):void {
			
			kill();
			
			i = 0;
			xList = listX;
			total = xList.length();
			
			loadNext();
			
		}
		
		// loads in the next thumb
		private static function loadNext():void {
			
			isLoading = true;
			loader = new Loader();
			loader.mouseEnabled = false;
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded, false, 0, true);
			loader.load(new URLRequest(xList[i].thumbnail));
			
		}
		
		private static function catchError(event:IOErrorEvent):void {}
		
		// fires when thumb has loaded in
		private static function loaded(event:Event):void {
			
			isLoading = false;
			
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			event.target.removeEventListener(Event.COMPLETE, loaded);
			event.target.content.smoothing = true;
			
			kickBack(event.target.content);
			
			i++;
			
			loader = null;
			
			(i != total) ? loadNext() : null;
			
		}
		
		// GARBAGE COLLECTION
		public static function kill():void {
			
			if(loader != null) {
				
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
				
				if(isLoading) {
					try {
						loader.close();
					}
					catch(event:*){};
					
				}
				loader = null;
			}
			
			isLoading = false;
			xList = null;
		}
		
	}
	
}
















