package cj.qcreative {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import cj.qcreative.graphics.Container;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
    public class CreateSub extends Sprite {
		
		// start private vars
		private var names:XMLList,
		url:XMLList,
		pops:Object,
		ar:Array,
		who:int,
		numChild:int,
		arLength:int,
		checkMod:Function;
		// end private vars
		
		// start internal vars
		internal var id:int,
		subMask:Shape,
		difW:int,
		difH:int,
		dW:int,
		dH:int,
		modW:int;
		// end internal vars
		
		// this class creates each sub-menu and is instanciated from the CreateMenu class
		public function CreateSub(list:XMLList, i:int, dad:int, func:Function) {
			
			id = i;
			who = dad;
			checkMod = func;
			names = list.menuTitle;
			url = list.deepLinkURL;
			
			// we need access to the stage so we can create a reference to the sub-menu's parent
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// fires when submenu has been added to the stage
		private final function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			pops = this.parent;
			
			ar = [];
			
			var item:SubButton, container:Container, yy:Number = 0, leg:int = names.length(), legger:int = leg - 1, j:int, differ:int, xst:String, checkOnce:Boolean = true;
			
			// loops through each sub-menu item
			for(var i:int = 0; i < leg; i++) {
				
				item = new SubButton();
				item.mouseEnabled = false;
				xst = url[i]
				
				item.id = i;
				ar[i] = item;
				
				xst = xst.split(" ").join("");
				
				item.textString = who + xst;
				item.txt.namer.text = names[i];
				item.txt.namer.width = item.txt.namer.textWidth + 10;
				item.txt.mouseEnabled = false;
				item.x = 5;
				item.y = yy + 2;
				
				// here we're adding a hit buffer to the top and bottom of the sub-menu
				if(i != 0 && i != legger) {
					container = new Container(item.txt.namer.textWidth + 15, item.txt.height + 4, 0xFFFFFF, i, who + xst);
					container.y = yy;
				}
				else if(i == 0) {
					container = new Container(item.txt.namer.textWidth + 15, item.txt.height + 14, 0xFFFFFF, i, who + xst);
					container.y = yy - 10;
				}
				else {
					container = new Container(item.txt.namer.textWidth + 15, item.txt.height + 10, 0xFFFFFF, i, who + xst);
					container.y = yy;
				}
				
				container.alpha = 0;
				container.tabEnabled = false;
				
				addChild(item);
				addChild(container);
				
				differ = (item.txt.namer.height + 4) | 0;
				yy += differ;
				
			}
			
			arLength = ar.length;
			
			j = numChildren;
			
			// this sets each button to the same width of the largest text field
			while(j--) {
				if(getChildAt(j) is Container) {
					if(!checkOnce) {
						getChildAt(j).width = this.width;
					}
					else {
						checkOnce = false;
						getChildAt(j).width = this.width + 5;
					}
				}
			}
			
			dW = this.width;
			dH = this.height;
			
			dW = dW == int(dW) ? dW : int(dW + 1);
			dH = dH == int(dH) ? dH : int(dH + 1);
			
			modW = dW + 282;
			
			// create the mask that will animate in sync with the background blur
			subMask = new Shape();
			subMask.graphics.beginFill(0x000000);
			subMask.graphics.drawRect(0, 0, dW, dH);
			subMask.graphics.endFill();
			
			subMask.name = "masker";
			addChildAt(subMask, 0);
			
			this.mask = subMask;
			
			difW = -dW;
			difH = -dH;
			
			subMask.x = difW;
			subMask.y = difH;
			
			numChild = this.numChildren;
			
		}
		
		// temporarily cleans the mouse events when a page is transitioning
		internal function cleanListeners(ask:Boolean = false):void {
			
			var sb:SubButton, ct:Container, i:int = numChild;
			
			while(i--) {
				
				// find the container buttons
				if(getChildAt(i) is Container && getChildAt(i).name != "masker") {
					ct = Container(getChildAt(i));
					ct.removeEventListener(MouseEvent.ROLL_OVER, overGlow);
					ct.removeEventListener(MouseEvent.ROLL_OUT, outGlow);
					ct.removeEventListener(MouseEvent.CLICK, clicker);
					ct.removeEventListener(MouseEvent.ROLL_OVER, over);
					ct.removeEventListener(MouseEvent.ROLL_OUT, out);
					
				}
				
				// remove the glow event for the text if necessary
				else if(getChildAt(i) is SubButton) {
					sb = SubButton(getChildAt(i));
					sb.go = false;
					sb.removeEventListener(Event.ENTER_FRAME, goEnter);
				}
			}
			(!ask) ? goOut(true) : null;
		}
		
		// "punches" the sub-menu changing it to its active state
		internal function checkItem():void {
			
			var i:int = arLength;
			while(i--) {
				if(ar[i].textString == Tracker.subString) {
					ar[i].gotoAndStop("pause");
				}
				else {
					ar[i].gotoAndStop(1);
				}
			}
		}
		
		// adds the mouse events to each sub-menu item
		internal function addListeners():void {
			
			var contain:Container, theItem:SubButton, i:int = numChild;
			
			while(i--) {
				
				if(getChildAt(i) is Container && getChildAt(i).name != "masker") {
					
					// first clean all the listeners
					contain = Container(getChildAt(i));
					contain.removeEventListener(MouseEvent.ROLL_OVER, overGlow);
					contain.removeEventListener(MouseEvent.ROLL_OUT, outGlow);
					contain.removeEventListener(MouseEvent.CLICK, clicker);
					contain.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
					contain.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
					contain.buttonMode = false;
					
					// then apply the mouse events to every item that is not active
					if(contain.textString != Tracker.subString) {
						contain.addEventListener(MouseEvent.ROLL_OVER, overGlow, false, 0, true);
						contain.addEventListener(MouseEvent.ROLL_OUT, outGlow, false, 0, true);
						contain.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
						contain.buttonMode = true;
					}
				}
				
				// apply glow animations to only non-active items
				else if(getChildAt(i) is SubButton) {
					
					theItem = SubButton(getChildAt(i));
					theItem.removeEventListener(Event.ENTER_FRAME, goEnter);
					theItem.go = false;
					
					if(theItem.textString != Tracker.subString) {
						theItem.addEventListener(Event.ENTER_FRAME, goEnter, false, 0, true);
					}
				}
			}
		}
		
		// fires when a sub-menu item is clicked
		private function clicker(event:MouseEvent):void {
			
			var i:int = event.currentTarget.id;
			
			CreateMenu.animate(url[i], who, i);
			
			cleanListeners(true);
			goOut(true);
			
		}
		
		// controls the glow animation for the sub-menu item
		private function goEnter(event:Event):void {
			(event.target.go) ? event.target.nextFrame() : event.target.prevFrame();
		}
		
		// animtes the item's glow
		private function overGlow(event:MouseEvent):void {
			var i:int = event.target.id;
			ar[i].go = true;
		}
		
		// removes the item's glow
		private function outGlow(event:MouseEvent):void {
			var i:int = event.target.id;
			ar[i].go = false;
		}
		
		// fires when the sub-menu is to be activated
		internal function overIt():void {
			pops.go = true;
			DrawBlur.showSub(id);
			TweenMax.to(subMask, 0.6, {x: 0, y: -7, ease: Quint.easeInOut});
		}
		
		// animates the sub-menu in
		private function over(event:MouseEvent):void {
			
			// checks to see if the current module should be repositioned
			if(Tracker.moduleLoaded) {
				if(Tracker.moduleX + Tracker.moduleDif < modW) {
					checkMod(modW);
				}
			}
			
			pops.go = true;
			DrawBlur.showSub(id);
			TweenMax.to(subMask, 0.6, {x: 0, y: -7, ease: Quint.easeInOut});
			
		}
		
		// animates the sub-menu out
		internal function goOut(fast:Boolean = false) {
			
			// checks to see if the module should be restored to it's original position
			if(Tracker.moduleLoaded) {
				if(Tracker.moduleX + Tracker.moduleDif < modW) {
					checkMod(undefined, true);
				}
			}
			
			var tim:Number;
			
			// fast = on click or on rollOver
			if(!fast) {
				tim = 0.4;
				DrawBlur.hideSub(id);
			}
			else {
				tim = 0.25;
				DrawBlur.hideSub(id, true);
				
			}
			
			pops.go = false;
			TweenMax.to(subMask, tim, {x: difW, y: difH, ease: Quint.easeOut});
			
		}
		
		// roll out mouse event for each sub-menu item
		private function out(event:MouseEvent):void {
			
			goOut();
			
		}
    }
}





























