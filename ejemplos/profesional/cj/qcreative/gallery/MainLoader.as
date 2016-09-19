package cj.qcreative.gallery {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	// this class loads in the big items for the gallery
    public class MainLoader {
		
		// begin private vars
		private static var loadTwo:Boolean,
		cb:Function,
		s:String,
		sLoading:Boolean = false,
		loaderOpen:Boolean = false,
		
		sLoader:Loader,
		myLoader:Loader;
		// end private vars
		
		// loads in the item
		internal static function loadIt(st:String, func:Function, twoLoad:Boolean):void {

			s = st;
			cb = func;
			loadTwo = twoLoad;
			
			myLoader = new Loader();
			myLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, done, false, 0, true);
			loaderOpen = true;
			myLoader.load(new URLRequest(s));
			
		}
		
		// for debugging
		private static function catchError(event:IOErrorEvent):void {}
		
		// fires when the second loader is done loading
		private static function second(event:Event):void {
			
			sLoading = false;
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
			sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			cb(myLoader, event.target.content.width, event.target.content.height, sLoader);
			myLoader = null;
			sLoader = null;
			
		}
		
		// fires when the first loader is done loading
		private static function done(event:Event):void {
			
			loaderOpen = false;
			myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
			myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			if(loadTwo) {
				sLoader = new Loader();
				sLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, second, false, 0, true);
				sLoading = true;
				sLoader.load(new URLRequest(s));
			}
			else {
				cb(myLoader, event.target.content.width, event.target.content.height);
				myLoader = null;
			}
			
		}
		
		// kills the loader instances if necessary
		internal static function kill():void {
			
			if(myLoader != null) {
				if(loaderOpen) {
					try {
						myLoader.close();
					}
					catch(event:*){};
				}
				
				if(myLoader.content) {
			
					if(myLoader.content is Bitmap) {
						BitmapData(Bitmap(myLoader.content).bitmapData).dispose();
					}
					myLoader.unload();
				
				}
				
				myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
				myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				myLoader = null;
			}
			
			if(sLoader != null) {
				if(sLoading) {
					try {
						sLoader.close();
					}
					catch(event:*){};
				}
				
				if(GalleryTracker.blurHolder.contains(sLoader)) {
					GalleryTracker.blurHolder.removeChild(sLoader);
				}
				
				if(sLoader.content) {
				
					if(sLoader.content is Bitmap) {
						BitmapData(Bitmap(sLoader.content).bitmapData).dispose();
					}
					sLoader.unload();
				
				}
				
				sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
				sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				sLoader = null;
			}
			
			cb = null;
			
		}
		
    }
}








