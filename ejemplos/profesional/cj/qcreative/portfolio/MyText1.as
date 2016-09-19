package cj.qcreative.portfolio {
	
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	
	// this class extends the MyText class
    public final class MyText1 extends MyText {
		
		// class constructor
		public function MyText1(sp:Sprite, bw:int, bh:int, func:Function) {
			
			super(sp, bw, bh, func);
			
		}
		
		// returns the height of the text field
		override internal function fixMenu(st:String):int {
			
			return super.fixMenu(st);
			
		}
		
		// tweens in the controls
		override internal function wipeControl(noWipe:Boolean):void {
			
			super.wipeControl(noWipe);
			
		}
		
		// sets the text field text
		override internal function setText(st:String):int {
			
			return super.setText(st);
			
		}
		
		// activates and deactivates the scrollbar
		override internal function setScroll(kill:Boolean = false, sectionOn:Boolean = false):void {
			
			super.setScroll(kill, sectionOn);
			
		}
		
		// removes mouse events
		override internal function removeListen():void {
			
			super.removeListen();
			
		}
		
		// activates the controls
		override internal function setUp(style:StyleSheet = null):void {
			
			super.setUp(style);
			
		}
		
		// deactivates the controls
		override internal function wipeBack(noKick:Boolean = false):void {
			
			super.wipeBack(noKick);
			
		}
		
		// GARBAGE COLLECTION
		override internal function kill():void {
			
			super.kill();
			
		}
		
    }
}








