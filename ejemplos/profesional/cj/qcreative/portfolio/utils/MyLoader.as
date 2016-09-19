package cj.qcreative.portfolio.utils {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	// this class loads in the initial section content
    public final class MyLoader extends Sprite {
		
		// begin private vars
		private var sLoader:Loader,
		myLoader:Loader,
		loadTwo:Boolean,
		smooth:Boolean,
		cb:Function,
		s:String,
		sLoading:Boolean = false,
		loaderOpen:Boolean = false;
		// end private vars
		
		// begin public vars
		public var id:int;
		// end public vars
		
		// class constructor
		public function MyLoader(func:Function, i:int) {
			cb = func;
			id = i;
		}
		
		// called when loading is to begin
		public function loadIt(st:String, usingTwo:Boolean):void {
			
			s = st;
			
			var leg:int = s.length;
			var str = s.substr(leg - 3, leg);
			
			(str != "swf") ? smooth = true : smooth = false;
			
			loadTwo = usingTwo;
			
			myLoader = new Loader();
			myLoader.mouseEnabled = false;
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, done, false, 0, true);
			myLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loaderOpen = true;
			myLoader.load(new URLRequest(s));
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// fires when second loader has loaded
		private function second(event:Event):void {
			
			sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
			sLoading = false;
			
			(smooth) ? event.target.content.smoothing = true : null;
			
			cb(id, myLoader, sLoader);
			myLoader = null;
			sLoader = null;
			
		}
		
		// fires when first loader has loaded
		private function done(event:Event):void {
			
			myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
			loaderOpen = false;
			
			(smooth) ? event.target.content.smoothing = true : null;
			
			if(loadTwo) {
				sLoader = new Loader();
				sLoader.mouseEnabled = false;
				sLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, second, false, 0, true);
				sLoading = true;
				sLoader.load(new URLRequest(s));
			}
			else {
				cb(id, myLoader);
				myLoader = null;
			}

		}
		
		// GARBAGE COLLECTION
		public function kill():void {
			
			if(myLoader != null) {
				if(loaderOpen) {
					try {
						myLoader.close();
					}
					catch(event:*){};
				}
				
				myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
				
				if(myLoader.content) {
					(smooth) ? BitmapData(Bitmap(myLoader.content).bitmapData).dispose() : null;
					myLoader.unload();
				}
				
				myLoader = null;
			}
			
			if(sLoader != null) {
				if(sLoading) {
					try {
						sLoader.close();
					}
					catch(event:*){};
				}
				
				sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
				
				if(sLoader.content) {
					(smooth) ? BitmapData(Bitmap(sLoader.content).bitmapData).dispose() : null;
					sLoader.unload();
				}
				
				sLoader = null;
			}
			
			cb = null;
			
		}
		
    }
}








