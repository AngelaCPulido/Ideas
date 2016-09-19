package cj.qcreative {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.ui.ContextMenu;
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	
	// This is the document class for the "master" swf which serves as a preloader
	public final class Master extends Sprite {
		
		private var pre:RootPre, sp:Sprite;
		
		// class constructor
		public function Master() {
			
			// test if stage is available
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// init function
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// create a new preloader
			pre = new RootPre();
			pre.mouseEnabled = pre.mouseChildren = false;
			sizer();
			
			addChild(pre);
			stage.addEventListener(Event.RESIZE, sizer, false, 0, true);
			
			Tracker.rootSwf = this;
			
			var rootX:String = root.loaderInfo.parameters["configURL"];
			(rootX == null) ? rootX = "xml/config.xml" : null;
			Tracker.rootXML = rootX;
			
			// try and grab the FlashVar if available
			var st:String = root.loaderInfo.parameters["swfURL"];
			(st == null) ? st = "qCreative.swf" : null;
			
			// activate the PixelBreaker code 
			MacMouseWheel.setup(stage);
			
			// load in the main template
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loader.load(new URLRequest(st));
			
			// just hiding the built in context menu items here
			var context:ContextMenu = new ContextMenu();
			context.hideBuiltInItems();
			this.contextMenu = context;
			
		}
		
		// kill the preloader, called from the template swf
		public function killPre():void {
			
			pre.stop();
			removeChild(pre);
			stage.removeEventListener(Event.RESIZE, sizer);
			
			// make the template visible
			sp.visible = true;
			
			pre = null;
			
		}
		
		// fixes a problem in Chrome and Opera when closing the browser
		private function catchError(event:IOErrorEvent):void {}
		
		// template loaded function
		private function loaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, loaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			// store the template as a Sprite
			sp = Sprite(event.target.content);
			sp.visible = false;
			addChild(sp);
			
		}
		
		// resize function for intital preloader
		private function sizer(event:Event = null):void {
			
			pre.x = stage.stageWidth >> 1;
			pre.y = stage.stageHeight >> 1;
			
		}
		
	}
	
}