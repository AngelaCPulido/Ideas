package cj.qcreative.gallery {
	
	import flash.display.Sprite
	import flash.events.Event
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class creates the main control buttons that show when an item is clicked
    public final class MainButtons extends Sprite {
		
		private var closer:Closer,
		myInfo:MyInfo,
		closeBig:Function,
		showInfo:Function,
		goLeft:Function,
		goRight:Function,
		leftArrow:MyArrow2,
		rightArrow:MyArrow2,
		numbers:Numbers,
		total:String,
		isOn:int,
		max:int,
		infoOn:Boolean;
		
		// class constructor
		public final function MainButtons(closeB:Function, infoB:Function, leftB:Function, rightB:Function, tot:int) {
			
			GalleryTracker.arrows = this;
			
			closeBig = closeB;
			showInfo = infoB;
			goLeft = leftB;
			goRight = rightB;
			infoOn = false;
			
			max = tot - 1;
			total = String(tot);
			(total.length == 1) ? total = "0" + total : null;
			
			closer = new Closer();
			closer.buttonMode = true;
			
			myInfo = new MyInfo();
			myInfo.buttonMode = true;
			
			myInfo.x = 29;
			myInfo.y = -3;
			
			leftArrow = new MyArrow2();
			leftArrow.buttonMode = true;
			
			rightArrow = new MyArrow2();
			rightArrow.buttonMode = true;
			
			leftArrow.rotation = 180;
			leftArrow.y = leftArrow.height - 5;
			rightArrow.y = 1;
			
			numbers = new Numbers();
			numbers.y = -4;
			
			addChild(closer);
			addChild(myInfo);
			addChild(leftArrow);
			addChild(rightArrow);
			addChild(numbers);
			
		}
		
		// temporarily deactivates event listeners
		internal function deactivate(myClick:Boolean = false):void {
			
			if(!myClick) {
				closer.removeEventListener(MouseEvent.ROLL_OVER, over);
				closer.removeEventListener(MouseEvent.ROLL_OUT, out);
				
				myInfo.removeEventListener(MouseEvent.ROLL_OVER, over);
				myInfo.removeEventListener(MouseEvent.ROLL_OUT, out);
	
				leftArrow.removeEventListener(MouseEvent.ROLL_OVER, over);
				leftArrow.removeEventListener(MouseEvent.ROLL_OUT, out);
	
				rightArrow.removeEventListener(MouseEvent.ROLL_OVER, over);
				rightArrow.removeEventListener(MouseEvent.ROLL_OUT, out);
			}
			
			myInfo.removeEventListener(MouseEvent.CLICK, info);
			closer.removeEventListener(MouseEvent.CLICK, theClose);
			leftArrow.removeEventListener(MouseEvent.CLICK, lefty);
			rightArrow.removeEventListener(MouseEvent.CLICK, righty);
			
			infoOn = false;
			
		}
		
		// adjusts the number text field upon a n item click
		internal function adjustX(i:int):void {
			
			TweenMax.to(numbers, 0.5, {x: i, ease: Quint.easeOut});
			
		}
		
		// adjusts the arrows depending on whether info is used
		internal function adjustInfo(noInfo:Boolean = false):void {
			
			if(!noInfo) {
				myInfo.visible = true;
				leftArrow.x = 61;
				rightArrow.x = 79;
			}
			else {
				myInfo.visible = false;
				leftArrow.x = 36;
				rightArrow.x = 54;
			}
			
		}
		
		// updates the current number text field
		internal function updateText(who:int):void {
			
			isOn = who;
			
			var st1:String = String(isOn + 1);
			
			(st1.length == 1) ? st1 = "0" + st1 : null;
			
			numbers.txt.text = st1 + "/" + total;
			
		}
		
		// adds the event listeners
		internal function activeClick():void {
			
			myInfo.addEventListener(MouseEvent.CLICK, info, false, 0, true);
			closer.addEventListener(MouseEvent.CLICK, theClose, false, 0, true);
			leftArrow.addEventListener(MouseEvent.CLICK, lefty, false, 0, true);
			rightArrow.addEventListener(MouseEvent.CLICK, righty, false, 0, true);
			
		}
		
		// activates the controls
		internal function activate(xx:int, who:int):void {
			
			numbers.x = xx;
			
			isOn = who;
			
			var st1:String = String(isOn + 1);
			
			(st1.length == 1) ? st1 = "0" + st1 : null;
			
			numbers.txt.text = st1 + "/" + total;
			
			closer.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			closer.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
			myInfo.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			myInfo.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);

			leftArrow.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			leftArrow.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);

			rightArrow.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			rightArrow.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			
			activeClick();
			
		}
		
		// mouse over function
		private function over(event:MouseEvent):void {
			
			event.currentTarget.gotoAndPlay("over");
			
		}
		
		// mouse out function
		private function out(event:MouseEvent):void {
			
			event.currentTarget.gotoAndPlay("out");
			
		}
		
		// left arrow click
		private function lefty(event:MouseEvent):void {
			
			if(isOn != 0) {
				deactivate(true);
				goLeft();
			}
			
		}
		
		// right arrow click
		internal function righty(event:MouseEvent = null):void {
			
			if(isOn != max) {
				deactivate(true);
				goRight();
			}
			
		}
		
		// info button click
		private function info(event:MouseEvent):void {
			
			(infoOn) ? infoOn = false : infoOn = true;
			showInfo(infoOn);
			
		}
		
		// close button click
		private function theClose(event:MouseEvent):void {
			
			deactivate();
			closeBig();
			closer.gotoAndPlay("out");
			
		}
		
		// GARBAGE COLLECTION
		internal function kill():void {
			
			TweenMax.killTweensOf(numbers);
			
			closer.removeEventListener(MouseEvent.ROLL_OVER, over);
			closer.removeEventListener(MouseEvent.ROLL_OUT, out);
			myInfo.removeEventListener(MouseEvent.ROLL_OVER, over);
			myInfo.removeEventListener(MouseEvent.ROLL_OUT, out);
			leftArrow.removeEventListener(MouseEvent.ROLL_OVER, over);
			leftArrow.removeEventListener(MouseEvent.ROLL_OUT, out);
			rightArrow.removeEventListener(MouseEvent.ROLL_OVER, over);
			rightArrow.removeEventListener(MouseEvent.ROLL_OUT, out);
			
			myInfo.removeEventListener(MouseEvent.CLICK, info);
			closer.removeEventListener(MouseEvent.CLICK, theClose);
			leftArrow.removeEventListener(MouseEvent.CLICK, lefty);
			rightArrow.removeEventListener(MouseEvent.CLICK, righty);
			
			closer.stop();
			myInfo.stop();
			leftArrow.stop();
			rightArrow.stop();
			
			closer.removeChildAt(0);
			closer.removeChildAt(0);
			
			myInfo.removeChildAt(0);
			myInfo.removeChildAt(0);
			
			leftArrow.removeChildAt(0);
			leftArrow.removeChildAt(0);
			
			rightArrow.removeChildAt(0);
			rightArrow.removeChildAt(0);
			
			numbers.removeChildAt(0);
			
			while(this.numChildren) {
				removeChildAt(0);
			}
			
			closer = null;
			myInfo = null;
			closeBig = null;
			showInfo = null;
			goLeft = null;
			goRight:Function;
			leftArrow = null;
			rightArrow = null;
			numbers = null;
			
			
		}
		
    }
}








