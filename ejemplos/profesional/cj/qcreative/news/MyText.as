package cj.qcreative.news {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cj.qcreative.Tracker;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class manages the main text field for an item
    public class MyText extends Sprite {
		
		// begin private vars
		private var theText:TheText,
		scroller:Scroller,
		w:int,
		h:int,
		total:int,
		spaceW:int,
		spaceH:int,
		goTo:String,
		st:String,
		styler:StyleSheet;
		// end private vars
		
		// begin internal bars
		internal var distH:int;
		// end internal vars
		
		// class constructor
		public function MyText(bw:int, bh:int, style:StyleSheet, str:String) {
			
			this.name = "myText";
			this.mouseEnabled = false;
			
			w = bw;
			h = bh;
			styler = style;
			st = str;
			
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			
		}
		
		// fires when added to the stage
		private function added(event:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			theText = new TheText();
			theText.mouseEnabled = false;
			
			(styler) ? theText.txt.styleSheet = styler : null;
			
			scroller = new Scroller(theText, w, h);
			
			theText.txt.htmlText = st;
			
			ripText(true);
			
			addChild(scroller);
			
			styler = null;
			
		}
		
		// activates and deactivates the scrollbar
		internal function setScroll(kill:Boolean = false):void {
			
			if(!kill) {
				scroller.activate(total, distH);
			}
			else {
				scroller.deactivate();				
			}
			
		}
		
		// calculates the height of the text field for scrolling
		internal function ripText(activate:Boolean = false):Boolean {
			
			theText.txt.width = w;
			total = theText.txt.textHeight + 10;
			
			distH = stage.stageHeight - (h + 48);
			
			var theW:int, buf:int, isSmall:Boolean;
			
			if(total > distH) {
				theW = w - 16;
				distH += 16;
				buf = 8;
				isSmall = true;
			}
			else {
				theW = w;
				distH = total;
				buf = 0;
				isSmall = false;
			}
			
			theText.txt.width = theW;
			
			total = theText.txt.textHeight + 10;
			
			theText.txt.height = total + buf;
			
			(!activate) ? scroller.activate(total, distH) : null;
			
			if(!isSmall) {
				distH -= 8;
			}
			
			return isSmall;
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			if(this.contains(scroller)) {
				
				removeChild(scroller);
				
				scroller.kill();
				theText.removeChildAt(0);
				
			}
			else {
				
				removeEventListener(Event.ADDED_TO_STAGE, added);
				
			}

			theText = null;
			scroller = null;
			styler = null;
			
		}
		
		
    }
}








