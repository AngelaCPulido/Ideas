package cj.qcreative.banner {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	// this class controls the loading and is sub-classed
    public class MyLoader extends Sprite {
		
		// begin private vars
		private var sLoader:Loader,
		myLoader:Loader,
		loadTwo:Boolean,
		loadOver:Boolean,
		bars:Boolean,
		cb:Function,
		s:String,
		sLoading:Boolean = false,
		loaderOpen:Boolean = false;
		// end private vars
		
		// class constructor
		public function MyLoader(func:Function) {
			cb = func;
		}
		
		// called when a new slide is to be loaded
		internal function loadIt(st:String, usingTwo:Boolean, overLoad:Boolean, bar:Boolean):void {

			kill();
			
			// store the constructor values so we can reference them later
			loadTwo = usingTwo;
			loadOver = overLoad;
			bars = bar;
			
			s = st;
			
			// create a new loader
			myLoader = new Loader();
			myLoader.mouseEnabled = false;
			myLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, done, false, 0, true);
			loaderOpen = true;
			myLoader.load(new URLRequest(s));
			
		}
		
		// IOErrorEvent because to help with debugging
		private final function catchError(event:IOErrorEvent):void {}
		
		// fires when the second instance has been loaded in
		private final function second(event:Event):void {
			
			sLoading = false;
			sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
			sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			cb(myLoader, loadOver, bars, sLoader);
			myLoader = null;
			sLoader = null;
			
		}
		
		// fires when the first instance has been loaded in 
		private final function done(event:Event):void {
			
			myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
			myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			// if a blur is to be used for info, we load in a duplicate
			if(loadTwo) {
				sLoader = new Loader();
				sLoader.mouseEnabled = false;
				sLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				sLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, second, false, 0, true);
				sLoading = true;
				sLoader.load(new URLRequest(s));
			}
			else {
				cb(myLoader, loadOver, bars);
				myLoader = null;
			}
			loaderOpen = false;
		}
		
		// cleans up any existing loaders
		internal function kill():void {
			
			// if the first loader exists
			if(myLoader != null) {
				
				myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
				myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				// try to close the connection
				if(loaderOpen) {
					
					try {
						myLoader.close();
					}
					catch(event:*){};
					
					loaderOpen = false;
					
				}
				
				if(myLoader.content) {
			
					if(myLoader.content is Bitmap) {
						BitmapData(Bitmap(myLoader.content).bitmapData).dispose();
					}
					myLoader.unload();
				
				}
				
				myLoader = null;
				
			}
			
			// if the second loader exists
			if(sLoader != null) {
				
				sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
				sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				if(BannerTracker.blurHolder != null) {
					(BannerTracker.blurHolder.contains(sLoader)) ? BannerTracker.blurHolder.removeChild(sLoader) : null;
				}
				
				// try to close the connection
				if(sLoading) {
					
					try {
						sLoader.close();
					}
					catch(event:*){};
					
					sLoading = false;
						
				}
				
				if(sLoader.content) {
				
					if(sLoader.content is Bitmap) {
						BitmapData(Bitmap(sLoader.content).bitmapData).dispose();
					}
					sLoader.unload();
				
				}
				
				sLoader = null;
				
			}
			
		}
		
		// GARBAGE COLLECTION
		internal function finalKill():void {
			
			// if the first loader exists
			if(myLoader != null) {
				if(loaderOpen) {
					try {
						myLoader.close();
					}
					catch(event:*){};
				}
				
				myLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, done);
				myLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				myLoader = null;
			}
			
			// if the second loader exists
			if(sLoader != null) {
				if(sLoading) {
					try {
						sLoader.close();
					}
					catch(event:*){};
				}
	
				sLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, second);
				sLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				sLoader = null;
			}
			
			cb = null;
			
		}
		
    }
}








