package cj.qcreative {
	
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import cj.qcreative.graphics.Container;
	
	// this class creates the menu's top-level
    public final class CreateMenu {
		
		// begin private vars
		private static var xSub:XMLList,
		pages:XMLList,
		isOn:int,
		leg:int,
		subLength:int,
		buttonLength:int,
		numChild:int,
		pass:int,
		webName:String,
		menuH:Number,
		boo:Boolean,
		checkMod:Function,
		tim:Timer,
		buttons:Array,
		subArray:Array;
		// end private vars
		
		// begin internal vars
		internal static var menu:Sprite = new Sprite();
		// end internal vars
		
		// init function called from the document class
		internal static function make(titles:XMLList, deepLink:XMLList, subs:XMLList, func:Function, wName:String) {
			
			var yy:Number = 0, countSub:int = 0, item:MenuButton, container:Container, createSub:CreateSub, ww:int = 0, hh:int = 0;
			
			tim = new Timer(750, 1),
			buttons = [],
			subArray = [];
			menu.x = 2;
			xSub = subs;
			pages = deepLink;
			checkMod = func;
			webName = wName;
			leg = titles.length();
			
			// this loop creates the menu items
			for(var i:int = 0; i < leg; i++) {
				
				item = new MenuButton();
				item.mouseEnabled = false;
				item.txt.mouseEnabled = false;
				item.txt.namer.text = titles[i];
				item.y = yy + 2;
				item.id = i;

				buttons[i] = item;
				
				ww = item.txt.namer.textWidth + 20;
				hh = item.txt.height + 4;
				
				// if the menu button has a sub-menu
				if(xSub[i].subMenu != undefined) {
					item.subMenu = xSub[i].subMenu.subPage;
					createSub = new CreateSub(item.subMenu, countSub, i, checkMod);
					createSub.x = 248;
					createSub.y = -2;
					item.addChild(createSub);
					subArray[countSub] = createSub;
					countSub++;
					container = new Container(ww, hh, 0xFFFFFF, i, undefined, true);
				}
				else {
					container = new Container(ww, hh, 0xFFFFFF, i);
				}
				
				// set up the actual button
				container.x = (item.txt.width - item.txt.namer.textWidth - 5) | 0;
				container.y = yy;
				container.buttonMode = true;
				container.tabEnabled = false;
				container.alpha = 0;
				
				menu.addChild(item);
				menu.addChild(container);
				
				yy += (item.txt.namer.height + 4) | 0;
				
			}
			
			subLength = subArray.length;
			buttonLength = buttons.length;
			
			menuH = menu.height >> 1;
			position();
			
			numChild = menu.numChildren;
			
			menu.name = "mMenu";
			menu.visible = false;
			Tracker.template.addChild(menu);
			
			// add intial roll over
			menu.addEventListener(MouseEvent.ROLL_OVER, menuOver, false, 0, true);
			
		}
		
		// on menu roll over, we activate the individual event listeners
		private static function menuOver(event:MouseEvent = null):void {
			
			menu.removeEventListener(MouseEvent.MOUSE_OVER, menuOver);
			menu.removeEventListener(MouseEvent.ROLL_OVER, menuOver);

			addListeners();
			
			menu.addEventListener(MouseEvent.ROLL_OUT, menuOut, false, 0, true);
	
		}
		
		// on menu roll out, we disable the individual event listeners (perfomance enhancement)
		private static function menuOut(event:MouseEvent):void {
			
			menu.removeEventListener(MouseEvent.ROLL_OUT, menuOut);
			
			cleanListeners();
			
			var sb:CreateSub;
			
			var i:int = buttonLength;
			
			// checking to see if the menu item has a sub menu
			while(i--) {
				
				if(buttons[i].numChildren == 2) {
					sb = CreateSub(buttons[i].getChildAt(1));
					sb.cleanListeners();
				}
			}
			
			// check item activates the "hit" state of the button
			checkItem(isOn, true, true, true);
			
			menu.addEventListener(MouseEvent.ROLL_OVER, menuOver, false, 0, true);
		}
		
		// animates the over and out states for the buttons
		private static function enterGo(event:Event):void {
			(event.target.go) ? event.target.nextFrame() : event.target.prevFrame();
		}
		
		// adds the mouse event listeners to each button
		private static function addListeners():void {
			
			var contain:Container, theItem:MenuButton, subIt:CreateSub, i:int = numChild;
			
			// loops through the buttons
			while(i--) {
				
				if(menu.getChildAt(i) is Container) {
					
					contain = Container(menu.getChildAt(i));
					
					// clean all the event listeners
					contain.removeEventListener(MouseEvent.MOUSE_OVER, overGlow);
					contain.removeEventListener(MouseEvent.ROLL_OUT, outGlow);
					contain.removeEventListener(MouseEvent.CLICK, clicker);
					contain.removeEventListener(MouseEvent.MOUSE_OVER, subOver);
					contain.removeEventListener(MouseEvent.ROLL_OUT, subOut);
					
					// apply only the over and out listeners to any non-active buttons
					if(contain.id != isOn && !contain.hasSub) {
						contain.addEventListener(MouseEvent.MOUSE_OVER, overGlow, false, 1, true);
						contain.addEventListener(MouseEvent.ROLL_OUT, outGlow, false, 1, true);
						contain.addEventListener(MouseEvent.CLICK, clicker, false, 0, true);
					}
					
					// apply the over and out listeners to if an item has a submenu
					if(contain.hasSub) {
						contain.addEventListener(MouseEvent.MOUSE_OVER, subOver, false, 0, true);
						contain.addEventListener(MouseEvent.ROLL_OUT, subOut, false, 0, true);
					}
					
				}
				else {
					
					// clean up the roll over and roll out listeners
					theItem = MenuButton(menu.getChildAt(i));
					theItem.removeEventListener(Event.ENTER_FRAME, enterGo);
					
					// clean up the submenu listeners
					if(theItem.numChildren == 2) {
						subIt = CreateSub(theItem.getChildAt(1));
						subIt.addListeners();
					}
					
					// add the roll over listeners to all non-active items
					if(theItem.id != isOn) {
						theItem.addEventListener(Event.ENTER_FRAME, enterGo, false, 0, true);
					}
				}
			}
			menu.addEventListener(MouseEvent.ROLL_OVER, menuOver, false, 0, true);
		}
		
		// called when a new background is loaded in, calculates the sub-menu's blur background
		internal static function newSubs():void {
				
			for(var i:int = 0; i < subLength; i++) {
				
				var sb:CreateSub = CreateSub(subArray[i]), it:MenuButton = MenuButton(sb.parent);
				
				DrawBlur.fixSub(menu.y + it.y, subArray[i].dW, subArray[i].dH);

			}
		}
		
		// cleans all mouse event listeners
		internal static function cleanListeners():void {
			
			menu.removeEventListener(MouseEvent.ROLL_OUT, menuOut);
			menu.removeEventListener(MouseEvent.ROLL_OVER, menuOver);
			
			var mb:MenuButton, ct:Container, subIt:CreateSub, i:int = numChild;
			
			// loops through all the menu items
			while(i--) {
				
				if(menu.getChildAt(i) is Container) {
					ct = Container(menu.getChildAt(i));
					ct.removeEventListener(MouseEvent.MOUSE_OVER, overGlow);
					ct.removeEventListener(MouseEvent.ROLL_OUT, outGlow);
					ct.removeEventListener(MouseEvent.CLICK, clicker);
					ct.removeEventListener(MouseEvent.MOUSE_OVER, subOver);
					ct.removeEventListener(MouseEvent.ROLL_OUT, subOut);
				}
				else {
					mb = MenuButton(menu.getChildAt(i));
					mb.go = false;
					mb.removeEventListener(Event.ENTER_FRAME, enterGo);
					
					if(mb.numChildren == 2) {
						subIt = CreateSub(mb.getChildAt(1));
						subIt.cleanListeners(true);
					}
				}
			}
		}
		
		// "punches" a menu item so it is in an active state
		internal static function checkItem(who:int, tru:Boolean = false, chg:Boolean = false, setPage:Boolean = false):void {
			
			isOn = who;
			var iPage:String, test:Boolean = Tracker.returnClick, i:int = buttonLength;
			
			// loops through all the menu items
			while(i--) {
				
				if(buttons[i].id == isOn) {
					if(!tru) {
						TweenMax.to(buttons[i], 0.25, {frame: 7, onCompleteParams: [test], onComplete: changeBG});
					}
					else {
						buttons[i].gotoAndStop(7);
						(!chg) ? changeBG(test) : null;
						
						var j:int = subArray.length;
						
						while(j--) {
							
							subArray[j].checkItem();
							
						}
						
					}
				}
				else if(buttons[i].currentFrame != 1) {
					TweenMax.to(buttons[i], 0.25, {frame: 1});
				}
			}
			
			// sets the browser title via swfAddress
			if(!setPage) {
				iPage = webName + " - " + Tracker.urlPage;
				SWFAddress.setTitle(iPage);
			}
			
		}
		
		// kills the Timer
		private static function killTim():void {
			tim.removeEventListener(TimerEvent.TIMER, goTime);
			tim.stop();
		}
		
		// calls the module preloader
		private static function goTime(event:TimerEvent):void {
			killTim();
			Tracker.template.addModPre();
		}
		
		// starts the Timer which helps avoid swfAddress glitches
		private static function startTim():void {
			killTim();
			
			tim.addEventListener(TimerEvent.TIMER, goTime, false, 0, true);
			tim.start();
			
		}
		
		// calls the module preloader or starts the Timer depending on how the page was changed
		private static function changeBG(tru:Boolean):void {
			
			// menu was clicked
			if(tru) {
				Tracker.template.addModPre();
			}
			
			// browser back/forward button was clicked
			else {
				startTim();
			}
			
		}
		
		// checks to see if the mouse is hovering a menu item after a page transition
		internal static function menuListen():void {
			
			menu.addEventListener(MouseEvent.ROLL_OVER, menuOver, false, 0, true);
			
			var xx:int = Tracker.template.mouseX, yy:int = Tracker.template.mouseY, bX:int, bY:int, bW:int, bH:int, tCon:Container, i:int = numChild;
			
			// loop through the menu items
			while(i--) {
					
				if(menu.getChildAt(i) is Container) {
					
					tCon = Container(menu.getChildAt(i));
					
					// grab the menu item position coordinates
					bX = menu.x + tCon.x;
					bY = menu.y + tCon.y;
					bW = tCon.width;
					bH = tCon.height;
					
					// check to see if the mouse is within the menu item coordinates
					if(xx >= bX && xx <= bX + bW && yy >= bY && yy <= bY + bH) {
						
						(buttons[tCon.id].numChildren == 2) ? goSub(tCon.id) : null;
						buttons[tCon.id].go = true;
						
						addListeners();

						break;
						
					}
				}
			}
			
			var rec:Rectangle = menu.getBounds(Tracker.template.stage);
			var xMouse:int = Tracker.template.mouseX;
			var yMouse:int = Tracker.template.mouseY;
			
			// check to see if we should manually activate a mouse over state
			if(xMouse > rec.x && xMouse < rec.x + rec.width && yMouse > rec.y && yMouse < rec.y + rec.height) {
				menuOver();
			}
			
		}
		
		// called from a sub-menu item click
		internal static function animate(url:String, id:int, i:int):void {
			
			var clean:Boolean = Tracker.template.processPage(url, id, i);
			
			(clean) ? cleanListeners() : null;
			
		}
		
		// called form a top-level click
		private static function clicker(event:MouseEvent):void {
			
			var i:int = event.currentTarget.id;
			
			var clean:Boolean = Tracker.template.processPage(pages[i], 999, i);
			
			(clean) ? cleanListeners() : null;
			
		}
		
		// mouse over glow for button
		private static function overGlow(event:MouseEvent):void {
			
			var i:int = event.currentTarget.id;
			buttons[i].go = true;
			
		}
		
		// mouse out glow for button
		private static function outGlow(event:MouseEvent):void {
			
			var i:int = event.currentTarget.id;
			buttons[i].go = false;
			
		}
		
		// checks to see if a module is in the way of a submenu
		private static function enterMod(event:Event):void {
			
			trace("fire");
			
			if(Tracker.moduleLoaded) {
				if(Tracker.moduleX + Tracker.moduleDif < pass) {
					boo = checkMod(pass);
				}
				else {
					boo = true;
				}
			}
			(boo) ? menu.removeEventListener(Event.ENTER_FRAME, enterMod) : null;
			
		}
		
		// activates the submenu
		private static function goSub(i:int) {
			
			var temp:MenuButton = MenuButton(buttons[i]), subTemp = CreateSub(temp.getChildAt(1)), j:int = subLength;
			
			pass = subTemp.modW;
			
			if(Tracker.moduleLoaded) {
				if(Tracker.moduleX + Tracker.moduleDif < pass) {
					checkMod(pass);
				}
			}
			else {
				menu.addEventListener(Event.ENTER_FRAME, enterMod, false, 0, true);
			}
			
			subTemp.overIt();
			
			// finds the submenu and activates the blur background
			while(j--) {
				
				if(subTemp == subArray[j]) {
					
					DrawBlur.showSub(j);
					
					break;
					
				}
			}
		}
		
		// deactivates the submenu
		private static function subOut(event:MouseEvent):void {
			
			var i:int = event.currentTarget.id, temp:MenuButton = MenuButton(buttons[i]), subTemp = CreateSub(temp.getChildAt(1)), j:int = subLength;
			
			if(Tracker.moduleLoaded) {
				if(Tracker.moduleX + Tracker.moduleDif < subTemp.modW) {
					checkMod(undefined, true);
				}
			}
			
			subTemp.goOut();
			
			// finds the submenu and deactivates the blur background
			while(j--)  {
				
				if(subTemp == subArray[j]) {
					
					DrawBlur.hideSub(j);
					
					break;
					
				}
			}
		}
		
		// animates the submenu
		private static function subOver(event:MouseEvent):void {
			
			var i:int = event.currentTarget.id;
			goSub(i);
			
		}
		
		// repositions the menu on stage resize
		internal static function position():void {
			
			var mid:int = Tracker.stageH >> 1;
			menu.y = ((mid - menuH) + 0.5) | 0;
			
		}
    }
}








