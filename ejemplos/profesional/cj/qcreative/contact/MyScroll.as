package cj.qcreative.contact {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	// this class creates a scrollbar for any large input text fields
    public final class MyScroll extends Sprite {
		
		// begin private vars
		private var bg:Shape,
		th:Shape,
		thumb:Sprite,
		rec:Rectangle,
		dif:Number,
		num:Number,
		perc:Number,
		txt:TextField;
		
		private const h:int = 175, tHeight:int = 88;
		// end private vars
		
		// class constructor
		public function MyScroll(texter:TextField) {
			
			txt = texter;
			
			// listen for the stage
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// fires when added to the stage
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			this.mouseEnabled = false;
			
			// create the scrollbar graphics
			bg = new Shape();
			bg.graphics.beginFill(0x000000, 0.3);
			bg.graphics.drawRect(0, 0, 5, h);
			bg.graphics.endFill();
			
			addChild(bg);
			
			th = new Shape();
			th.graphics.beginFill(0xFFFFFF);
			th.graphics.drawRect(0, 0, 5, 88);
			th.graphics.endFill();
			
			thumb = new Sprite();
			thumb.addChild(th);
			
			addChild(thumb);
			
			rec = new Rectangle(0, 0, 0, 89);
			
			thumb.buttonMode = true;
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown, false, 0, true);
			
		}
		
		// this function dynamically updates the scrollbar's height
		internal function updateH(hh:Number):void {
			
			perc = h / hh;
			thumb.height = perc * 100;
			
			(thumb.height < 20) ? thumb.height = 20 : null;
			(thumb.height > h - 20) ? thumb.height = h - 20 : null;
			
			dif = h - thumb.height;
			rec.height = dif + 1;
			thumb.y = dif;
			
		}
		
		// mouse up function when the scrollbar is released
		private function thumbUp(event:Event):void {
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);
			stage.removeEventListener(Event.MOUSE_LEAVE, thumbUp);
			
			thumb.removeEventListener(Event.ENTER_FRAME, mover);
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown, false, 0, true);
			
			thumb.stopDrag();
			
		}
		
		// scrollbar drag function
		private function mover(event:Event):void {
			
			if(mouseY > 0 && mouseY < h) {
				
				num = thumb.y / dif;
				txt.scrollV = (((txt.maxScrollV - 1) * num) + 1) + 0.5 | 0;
				
			}
			
		}
		
		// scrollbar pressed function
		private function thumbDown(event:MouseEvent):void {
			
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, thumbUp, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, thumbUp, false, 0, true);
			
			thumb.addEventListener(Event.ENTER_FRAME, mover, false, 0, true);
			
			// start dragging the scrollbar
			thumb.startDrag(false, rec);
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			if(bg != null) {
				
				thumb.stopDrag();
				
				// remove event listeners
				thumb.removeEventListener(Event.ENTER_FRAME, mover);
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);
				stage.removeEventListener(Event.MOUSE_LEAVE, thumbUp);
				
				// remove children
				thumb.removeChild(th);
				removeChild(thumb);
				removeChild(bg);
				
				// clear graphics
				bg.graphics.clear();
				th.graphics.clear();
				
				// set vars to null
				bg = null;
				th = null;
				thumb = null;
				rec = null;
				
			}
			
			txt = null;
			
		}

    }
}











































