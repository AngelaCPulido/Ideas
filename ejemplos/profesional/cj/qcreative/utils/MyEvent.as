package cj.qcreative.utils {

	import flash.events.Event;
	
	// this class allows a user to connect the template's position and blur capabilities to their own swf
	// see "myModule.fla" for sample usage
	
	public final class MyEvent extends Event {
     		
		public static const POS_MODULE:String = "posModule";

		public var width:int, height:int, blur:Boolean;
		
		public function MyEvent(type:String, w:int, h:int, b:Boolean) {
		
			super(type, true);
			
			width = w;
			height = h;
			blur = b;
		
		}
		
		public override function clone():Event {
		
			return new MyEvent(MyEvent.POS_MODULE, width, height, blur);
		
		}
		
	}

}





