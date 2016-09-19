package cj.qcreative {
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	
	// This class is for tracking global vars and values.  
	// It also handles background image and module preloading.
	
    public final class Tracker {
		
		// public vars that can be accessed by the modules
		public static var rootSwf:Object,
		template:Object,
		contactObj:Object,
		portObj:Object,
		newsObj:Object,
		stageH:Number,
		textXML:String,
		rootXML:String,
		moduleW:int,
		moduleH:int,
		galThumbW:int,
		totalGal:int,
		galSpace:int,
		xBlur:int = 37,
		yBlur:int = 37,
		blurQuality:int = 3,
		newsNumber:int = -1,
		isFull:Boolean = false,
		openNews:Boolean = false,
		mTweened:Boolean = false,
		swfIsReady:Boolean = false;
		
		// internal vars that can only be accessed by the Q
		internal static var stageW:Number,
		moduleX:int,
		catcher:Boolean,
		fromClick:Boolean,
		subString:String,
		myPage:String,
		urlPage:String,
		moduleDif:int = 0,
		contactOn:Boolean = false,
		galleryOn:Boolean = false,
		portOn:Boolean = false,
		newsOn:Boolean = false,
		liveMusic:Boolean = false,
		moduleLoaded:Boolean = false,
		isLoading:Boolean = false,
		myAlign:String = "tl";
		
		// private vars for preloading
		private static var moduleBytes:Number = 1000,
		backBytes:Number = 1000,
		modLoaded:Number,
		backLoaded:Number,
		byteTotal:Number,
		byteLoaded:Number,
		totalLoaded:Number,
		dif:Number,
		backIsDone:Boolean = false,
		moduleIsDone:Boolean = false;
		
		// just returns the value fromClick
		internal static function get returnClick():Boolean {
		
			return fromClick;
			
		}
		
		// **************************************
		// ALL FUNCTIONS BELOW ARE FOR PRELOADING
		// **************************************
		
		// called when the preloading should start
		internal static function startListen(firstLoad:Boolean = false):void {
			
			swfIsReady = false;
			mTweened = false;
			
			if(!firstLoad) {
				isLoading = true;
				Tracker.template.modulePre.txt.text = "0%";
				template.addEventListener(Event.ENTER_FRAME, listen, false, 0, true);
			}
			else {
				template.addEventListener(Event.ENTER_FRAME, listenFirst, false, 0, true);
			}
			
		}
		
		// preloader combines bg image plus module when preloading
		private static function listen(event:Event):void {
			
			byteTotal = backBytes + moduleBytes;
			byteLoaded = modLoaded + backLoaded;
			
			totalLoaded = byteLoaded / byteTotal;
			
			dif = ((totalLoaded * 100) + 0.5) | 0;
			(dif > 100) ? dif = 0 : null;
			
			template.modulePre.txt.text = String(dif) + "%";
			
			if(totalLoaded == 1) {
				template.removeEventListener(Event.ENTER_FRAME, listenFirst);
				template.addEventListener(Event.ENTER_FRAME, testListen, false, 0, true);
				moduleBytes = 1000;
				backBytes = 1000;
			}
			
		}
		
		// the very first preloader
		private static function listenFirst(event:Event):void {
			
			byteTotal = backBytes + moduleBytes;
			byteLoaded = modLoaded + backLoaded;
			
			totalLoaded = byteLoaded / byteTotal;
			
			if(totalLoaded == 1) {
				template.removeEventListener(Event.ENTER_FRAME, listenFirst);
				template.addEventListener(Event.ENTER_FRAME, testListen, false, 0, true);
				moduleBytes = 1000;
				backBytes = 1000;
			}
			
		}
		
		// waiting to make sure both Event.Complete handlers have fired
		private static function testListen(event:Event):void {
			
			if(backIsDone && moduleIsDone) {
				template.removeEventListener(Event.ENTER_FRAME, testListen);
				isLoading = false;
				template.catchModule();
				template.fireBG();
				moduleIsDone = false;
				backIsDone = false;
			}
			
		}
		
		// waits for the module's xml file file to load if it hasn't already
		private static function waitForDispatch(event:Event):void {
			
			if(swfIsReady) {
				
				template.removeEventListener(Event.ENTER_FRAME, waitForDispatch);

				template.goDispatch();
				
			}
		}
		
		// checks to see if the module's xml file has been loaded
		internal static function testReady():void {
			
			if(template.moduleType != "yourswf") {
				if(swfIsReady) {
					template.goDispatch();
				}
				else {
					template.addEventListener(Event.ENTER_FRAME, waitForDispatch, false, 0, true);
				}
			}
			
		}
		
		// fixes a problem in Chrome and Opera when closing the browser
		internal static function catchError(event:IOErrorEvent):void {}
		
		// fires when the module has finished loading
		internal static function moduleDone(event:Event):void {
			template.moduleOpen = false;
			template.module.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, trackProgress);
			template.module.contentLoaderInfo.removeEventListener(Event.COMPLETE, moduleDone);
			template.module.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			moduleIsDone = true;
		}
		
		// fires when the background image has finished loading
		internal static function backDone(event:Event):void {
			template.sendBack();
			backIsDone = true;
		}
		
		// tracks the progress of the background image
		internal static function trackBack(event:ProgressEvent):void {
			
			backBytes = event.bytesTotal;
			backLoaded = event.bytesLoaded;
			
		}
		
		// tracks the progress of the module
		internal static function trackProgress(event:ProgressEvent):void {
			
			moduleBytes = event.bytesTotal;
			modLoaded = event.bytesLoaded;
			
		}
		
    }
	
}














