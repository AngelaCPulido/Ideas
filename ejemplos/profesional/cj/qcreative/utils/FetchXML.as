package cj.qcreative.utils {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
    
	// this class loads in the config and menu xml files and
	public final class FetchXML {
		
		private static var func:Function,
		xml:XML,
		xml2:XML,
		
		count:int = 0,
		loader:URLLoader = new URLLoader();
		
		// load in the config xml file
		public static function fetch(st:String, sendBack:Function) {
			
			func = sendBack;
			loader.addEventListener(Event.COMPLETE, received, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			loader.load(new URLRequest(st));
			
		}
		
		// clean up class variables
		private static function killThis():void {
			
			loader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			loader.removeEventListener(Event.COMPLETE, received);
			xml = null;
			xml2 = null;
			func = null;
			loader = null;
			
		}
		
		// fixes a problem in Chrome and Opera when closing the browser
		private static function catchError(event:IOErrorEvent):void {}
		
		// fired when each xml file has loaded
		private static function received(event:Event):void {

			if(count == 1) {
				xml2 = new XML(event.target.data);
				func(xml, xml2);
				killThis();
			}
			else {
				xml = new XML(event.target.data);
				count++;
				fetch(xml.xmlUrls.menu.text(), func);
			}
			
		}
		
    }
}








