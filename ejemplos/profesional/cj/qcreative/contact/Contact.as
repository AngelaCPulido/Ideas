package cj.qcreative.contact {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.events.FullScreenEvent;
	
	import cj.qcreative.Tracker;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// document class for Contact module
    public final class Contact extends Sprite {
		
		// begin private vars
		private const fieldH:int = 24, descH:int = 179, numLines:int = 12;
		
		private var mySubmit:MySubmit,
		successMes:MessageSuccess,
		myClear:MyClear,
		info:InfoText,
		tempText:FieldText,
		mesHolder:Sprite,
		mesMask:Shape,
		tShape:Shape,
		style:StyleSheet,
		xLoader:URLLoader,
		cssLoader:URLLoader,
		sendData:URLLoader, 
		xFields:XMLList,
		xReq:XMLList,
		backs:Array,
		texts:Array,
		tHeight:Number,
		newLines:int,
		xOpen:Boolean,
		cssOpen:Boolean,
		rPhone:Boolean,
		sendOpen:Boolean,
		mActive:Boolean,
		fromEmail:Boolean,
		sentMessage:String,
		sbText:String,
		cbText:String,
		myInfo:String,
		phpURL:String,
		mScroll:MyScroll,
		disable:Sprite;
		// end private vars
		
		// class constructor
		public function Contact() {
			
			this.visible = false;
			
			addEventListener(Event.UNLOAD, remover, false, 0, true);
			
			// listen for the stage
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			}
			else {
				added();
			}
			
		}
		
		// input field focus in event
		private function inFocus(event:FocusEvent):void {
			
			var mc:FieldText = FieldText(event.target.parent), i:int = mc.id, st:String = mc.txt.text;
				
			if(st == mc.namer || st == mc.eMessage) {
				mc.txt.text = "";
			}
			
			TweenMax.to(backs[i], 0.75, {alpha: 0.5, ease:Quint.easeOut});
			
			// only add listeners once or after the form has submitted
			if(mActive) {
				TweenMax.to(mesHolder, 0.75, {width: 0, ease: Quint.easeInOut});
				(Tracker.template != null) ? Tracker.template.contactMessage(true) : null;
				mActive = false;
				
				mySubmit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				mySubmit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				mySubmit.addEventListener(MouseEvent.CLICK, submitMe, false, 0, true);
				mySubmit.buttonMode = true;
					
				myClear.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
				myClear.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
				myClear.addEventListener(MouseEvent.CLICK, clearMe, false, 0, true);
				myClear.buttonMode = true;
				
			}
			
			stage.addEventListener(MouseEvent.CLICK, switchFocus, false, 0, true);
			
		}
		
		// focus out event if the stage is clicked and an input field has focus
		private function switchFocus(event:MouseEvent):void {
			
			// if the mouse is not hovering the contact module
			if(mouseX < 0 || mouseX > this.width || mouseY < 0 || mouseY > this.height) {
			
				var i:int = texts.length;
				
				while(i--) {
					TweenMax.to(backs[i], 0.75, {alpha: 0.2, ease:Quint.easeOut});
				}
				
				stage.removeEventListener(MouseEvent.CLICK, switchFocus);
				
			}
			
		}
		
		// input field focus out event
		private function outFocus(event:FocusEvent):void {
			
			if(event.target.parent != null) {
				var mc:FieldText = FieldText(event.target.parent), i:int = mc.id;
				
				if(mc.txt.text == "") {
					mc.txt.text = mc.namer;
				}
				
				TweenMax.to(backs[i], 0.75, {alpha: 0.2, ease:Quint.easeOut});
			}
			
			(stage != null) ? stage.removeEventListener(MouseEvent.CLICK, switchFocus) : null;
			
		}
		
		// called from the Q, tells the module it is ready to be activated
		public function getSized():void {
			setUp();
		}
		
		// sets up the contact form
		private function setUp():void {
			
			// temporary vars
			var leg:int = xFields.length(),
			back:MySprite,
			yCount:int = 0,
			counter:int,
			fText:FieldText,
			st:String,
			fType:String,
			req:String,
			val:String,
			i:int,
			finder:int,
			ww:int,
			hh:int,
			myH:int,
			scroller:MyScroll;
			
			backs = [];
			texts = [];
			
			// loop through all the fields
			for(i = 0; i < leg; i++) {
				
				fText = new FieldText();
				fText.mouseEnabled = false;
				texts[i] = fText;
				
				fType = xFields[i].fieldType.toString().toLowerCase();
				
				// if the inpput field is to be small
				if(fType == "small") {
					back = new MySprite(i);
					counter = fieldH;
				}
				
				// if the input field is to be large (like for comments/messages)
				else {
					back = new MySprite(i, true);
					counter = descH;
					fText.txt.height = counter;
					fText.txt.multiline = true;
					fText.txt.wordWrap = true;
					fText.txt.addEventListener(Event.CHANGE, checkLines, false, 0, true);
					scroller = new MyScroll(fText.txt);
					scroller.x = 290;
					scroller.y = -2
					scroller.visible = false;
					fText.addChild(scroller);
				}
				
				backs[i] = back;
				back.y = yCount;
				back.alpha = 0.2;
				addChild(back);
				
				val = xFields[i].validationType.toString().toLowerCase();
				st = xFields[i].fieldName.toString();
				
				// checks to see if a field is required
				if(xReq[i].toString().toLowerCase() == "true") {
						
					finder = st.search("*");
					
					// adding the asterisk if not added in the xml
					if(finder == -1) {
						st += "*";
						fText.txt.text = st;
					}
					else {
						fText.txt.text = st;
					}
					
					// if restricting phone field to numbers
					if(val == "phone" && rPhone) {
						fText.txt.restrict = "0-9\-\.";
					}
					
				}
				else {
					fText.txt.text = st;
				}
				
				fText.id = i;
				fText.namer = st;
				fText.eMessage = xFields[i].errorMessage.toString();
				fText.x = 5;
				fText.y = yCount + 2;
				fText.txt.addEventListener(FocusEvent.FOCUS_IN, inFocus, false, 0, true);
				fText.txt.addEventListener(FocusEvent.FOCUS_OUT, outFocus, false, 0, true);
				addChild(fText);
				
				yCount += counter;
				
			}
			
			// create the contact information
			info = new InfoText();
			info.mouseEnabled = false;
			(style != null) ? info.txt.styleSheet = style : null;
			info.txt.htmlText = myInfo;
			info.x = 336;

			ww = info.txt.textWidth + 5;
			hh = info.txt.textHeight + 5;
			
			ww = ww == int(ww) ? ww : int(ww + 1);
			hh = hh == int(hh) ? hh : int(hh + 1);
			
			info.txt.width = ww;
			info.txt.height = hh;
			addChild(info);
			
			// create the submit button
			mySubmit = new MySubmit();
			mySubmit.mc.txt.text = sbText;
			mySubmit.buttonMode = true;
			mySubmit.tabEnabled = false;
			mySubmit.mouseChildren = false;
			mySubmit.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			mySubmit.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			mySubmit.addEventListener(MouseEvent.CLICK, submitMe, false, 0, true);
			mySubmit.x = 219;
			mySubmit.y = yCount + 8;
			addChild(mySubmit);
			
			// create the clear button
			myClear = new MyClear();
			myClear.mc.txt.text = cbText;
			myClear.buttonMode = true;
			myClear.tabEnabled = false;
			myClear.mouseChildren = false;
			myClear.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			myClear.addEventListener(MouseEvent.ROLL_OUT, out, false, 0, true);
			myClear.addEventListener(MouseEvent.CLICK, clearMe, false, 0, true);
			myClear.x = mySubmit.x - 88;
			myClear.y = yCount + 8;
			addChild(myClear);
			
			// create the success message
			myH = this.height;
			successMes = new MessageSuccess();
			successMes.mouseEnabled = false;
			successMes.txt.htmlText = sentMessage;
			successMes.y = myH + 17;
			mesMask = new Shape();
			mesMask.graphics.beginFill(0x000000);
			mesMask.graphics.drawRect(0, 0, 300, 24);
			mesMask.graphics.endFill();
			mesHolder = new Sprite();
			mesHolder.mouseEnabled = false;
			mesHolder.x = -16;
			mesHolder.y = successMes.y;
			mesHolder.addChild(mesMask);
			mesHolder.alpha = 0.5;
			mesHolder.width = 0;
			successMes.mask = mesHolder;
			addChild(successMes);
			addChild(mesHolder);
			
			var ceiler:Number = yCount + 8 + mySubmit.height;
			ceiler = ceiler == int(ceiler) ? ceiler : int(ceiler + 1);
			
			// store some properties for the Q to access
			Tracker.contactObj = {leftHeight: ceiler, rightWidth: ww, rightHeight: hh, mWidth: successMes.txt.textWidth + 32};
			
			tShape = new Shape();
			tShape.graphics.beginFill(0x000000);
			tShape.graphics.drawRect(0, 0, this.width, myH);
			tShape.graphics.endFill();
			
			this.mask = tShape;
			addChild(tShape);
			
			// position the module
			Tracker.moduleW = this.width;
			Tracker.moduleH = myH;
			(Tracker.template) ? Tracker.template.posModule(null, true) : null;
			
			tShape.scaleY = 0;
			this.visible = true;
			TweenMax.to(tShape, 0.5, {scaleY: 1, ease:Quint.easeOut, onComplete: dumpT});
			
			style = null;
			
			disable = new Sprite();
			disable.alpha = 0;
			disable.buttonMode = true;
			
			if(stage.displayState != StageDisplayState.FULL_SCREEN) {
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, block, false, 0, true);
			}
			else {
				block();
			}
			
		}
		
		private function noFull(event:MouseEvent):void {
			
			stage.displayState = StageDisplayState.NORMAL;
			noBlock();
			
		}
		
		private function block(event:FullScreenEvent = null):void {
			
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, block);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, noBlock, false, 0, true);
			
			disable.graphics.beginFill(0x000000);
			disable.graphics.drawRect(0, 0, this.width, this.height);
			disable.graphics.endFill();
			disable.addEventListener(MouseEvent.CLICK, noFull, false, 0, true);
			
			addChild(disable);
			
			var i:int = texts.length;
			
			while(i--) {
				
				if(i != 0) {
					texts[i].txt.text = "";
				}
				else {
					texts[0].txt.text = "Menu blocked in Full Screen Mode.  Click Here to Exit";
					texts[0].mouseEnabled = false;
					texts[0].mouseChildren = false;
				}
				
			}
			
		}
		
		private function noBlock(event:FullScreenEvent = null):void {
			
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, noBlock);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, block, false, 0, true);
			
			disable.graphics.clear();
			disable.removeEventListener(MouseEvent.CLICK, noFull);
			
			(this.contains(disable)) ? removeChild(disable) : null;
			
			var i:int = texts.length;
			
			while(i--) {
				texts[i].txt.text = texts[i].namer;
			}
			
			texts[0].mouseEnabled = true;
			texts[0].mouseChildren = true;
			
		}
		
		// get rid of the initial mask as it's only need for animating the module in
		private function dumpT():void {
			
			removeChild(tShape);
			this.mask = null;
			tShape.graphics.clear();
			tShape = null;
			
		}
		
		// fires on input to check if a scrollbar is needed
		private function checkLines(event:Event):void {
			
			tempText = FieldText(event.target.parent);
			mScroll = MyScroll(tempText.getChildAt(1));
			
			// activates and updates the scrollbar if necessary
			if(event.target.numLines > numLines) {
				mScroll.visible = true;
				mScroll.updateH(event.target.textHeight + 5);
			}
			else {
				mScroll.visible = false;
			}
			
		}
		
		// clear all fields
		private function clearMe(event:MouseEvent):void {
		
			var i:int = texts.length;
			
			while(i--) {
				
				texts[i].txt.text = texts[i].namer;
				TweenMax.to(backs[i], 0.75, {alpha: 0.2, ease:Quint.easeOut});
				
			}
			
			stage.focus = null;
		
		}
		
		// submit click mouse event
		private function submitMe(event:MouseEvent):void {
			
			// temporary vars
			var tryAgain:Boolean = false,
			pass1:Boolean = true,
			pass2:Boolean,
			atFound:Boolean,
			dotFound:Boolean,
			leg:int = texts.length,
			stringer:String,
			vType:String,
			eField = "999",
			ar:Array,
			ar2:Array,
			strings:Array = [];
			
			// store the input text 
			for(var ii:int = 0; ii < leg; ii++) {
				stringer = texts[ii].txt.text;
				strings[ii] = stringer;
			}
			
			// loop through each field
			for(var i:int = 0; i < leg; i++) {
				
				// if field is required
				if(xReq[i].toString().toLowerCase() == "true") {
					
					// first check for blank fields
					if(strings[i] != "") {
						
						// get what validation type to check
						vType = xFields[i].validationType.toString().toLowerCase();
						
						// if validation type is email
						if(vType == "email") {
							
							pass2 = true;
							atFound = false;
							dotFound = false;
							
							// if there are more than 5 characters
							if(strings[i].length > 5) {
								
								for(var j:int = 0; j < strings[i].length; j++) {
									
									if(strings[i].charAt(j) == "@") {
										atFound = true;
									}

									else if(strings[i].charAt(j) == ".") {
										dotFound = true;
									}
									
									if(atFound && dotFound) {
										break;
									}
									
								}
								
								// validation failed
								if(!atFound || !dotFound) {
									tryAgain = true;
									pass2 = false;
								}

								else {
									
									ar = strings[i].split("@");
									
									for(var k:int = 0; k < ar.length; k++) {
										
										// validation fails
										if(ar[k] == "") {
											tryAgain = true;
											pass2 = false;
											break;
										}
									}

									ar2= strings[i].split(".");
									
									for(var l:int = 0; l < ar2.length; l++) {
										
										// validation fails
										if(ar2[l] == "") {
											tryAgain = true;
											pass2 = false;
											break;
										}
									}
								}
							}
							
							// validation failed
							else {
								tryAgain = true;
								pass2 = false;
							}
							
							// if validation has failed
							if(!pass2) {
								texts[i].txt.text = texts[i].eMessage;
								TweenMax.to(backs[i], 0.75, {alpha: 0.5, ease: Quint.easeOut});
							}
							else {
								TweenMax.to(backs[i], 0.75, {alpha: 0.2, ease: Quint.easeOut});
							}

							
						}
						
						// if input text equals field title text, validation fails
						else if(strings[i] == texts[i].namer) {
							
							pass1 = false;
							tryAgain = true;
							texts[i].txt.text = texts[i].eMessage;
							TweenMax.to(backs[i], 0.5, {alpha: 0.5, ease: Quint.easeOut});
							
						}
						
						// if input text is empty, validation fails
						else {

							if(strings[i].length < 1) {
								tryAgain = true;
								pass1 = false;
							}
							
							// if validation failed
							if(!pass1) {
								texts[i].txt.text = texts[i].eMessage;
								TweenMax.to(backs[i], 0.5, {alpha: 0.5, ease: Quint.easeOut});
							}
							else {
								TweenMax.to(backs[i], 0.5, {alpha: 0.2, ease: Quint.easeOut});
							}
								
						}
						
					}
					
					// validation failed
					else {
						tryAgain = true;
						texts[i].txt.text = texts[i].eMessage;
						TweenMax.to(backs[i], 0.75, {alpha: 0.5, ease: Quint.easeOut});
					}
				}
				
				// field was not required
				else {
					TweenMax.to(backs[i], 0.5, {alpha: 0.2, ease: Quint.easeOut});
				}
			}
			
			// if validation succeeded
			if(!tryAgain) {
				
				var vars:URLVariables = new URLVariables(), req:URLRequest, far:String, titles:String;
				
				// remove all event listeners
				mySubmit.removeEventListener(MouseEvent.ROLL_OVER, over);
				mySubmit.removeEventListener(MouseEvent.ROLL_OUT, out);
				mySubmit.removeEventListener(MouseEvent.CLICK, submitMe);
				mySubmit.buttonMode = false;
				mySubmit.gotoAndPlay("out");
					
				myClear.removeEventListener(MouseEvent.ROLL_OVER, over);
				myClear.removeEventListener(MouseEvent.ROLL_OUT, out);
				myClear.removeEventListener(MouseEvent.CLICK, clearMe);
				myClear.buttonMode = false;
				
				if(fromEmail) {
					
					var isEmail:Array = [], checkMail:Boolean;
					
					for(var mm:int = 0; mm < leg; mm++) {
						
						isEmail[mm] = xFields[mm].attribute("isEmail");
						checkMail = convert(isEmail[mm]);
						
						if(checkMail) {
							var mmm:int = mm + 1;
							eField = String(mmm);
							break;
						}
						
					}
				}
				
				// loop through the fields
				for(var kk:int = 0; kk < leg; kk++) {
					
					texts[kk].txt.text = "";
					texts[kk].txt.selectable = false;
					
					TweenMax.to(backs[kk], 0.75, {alpha: 0.2, ease: Quint.easeOut});
					
					// below we're adding a unique string so the php can split the exact string
					// this provides correct email formatting since the contact form is liquid
					
					titles += "r7yi2s" + texts[kk].namer;
					
					far += "z85c64" + strings[kk];

				}
				
				vars.tt = titles;
				vars.ff = far;
				vars.ee = eField;
				
				req = new URLRequest(phpURL);
				req.method = URLRequestMethod.POST;
				req.data = vars;
				
				// send the info to the php file to process
				sendData = new URLLoader();
				sendData.addEventListener(Event.COMPLETE, varsSent, false, 0, true);
				sendData.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
				sendOpen = true;
				sendData.load(req);
				
			}
			
			stage.focus = null;
			
		}
		
		// fires when the php file has finished loading
		private function varsSent(event:Event):void {
			
			sendOpen = false;
			
			event.target.removeEventListener(Event.COMPLETE, varsSent);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			if(Tracker.template != null) {
				Tracker.template.contactMessage();
			}
			
			mActive = true;
			TweenMax.to(mesHolder, 0.75, {width: successMes.txt.textWidth + 32, ease: Quint.easeInOut, onComplete: addAgain});
			
			sendData = null;
			
		}
		
		// restores the contact form to it's original state after a form submit
		private function addAgain():void {
			
			var i:int = texts.length;
			
			while(i--) {
				
				texts[i].txt.text = texts[i].namer;
				texts[i].txt.selectable = true;
				texts[i].txt.addEventListener(FocusEvent.FOCUS_IN, inFocus, false, 0, true);
				texts[i].txt.addEventListener(FocusEvent.FOCUS_OUT, outFocus, false, 0, true);

			}
			
			stage.focus = null;
			
		}
		
		// moue over function for buttons
		private function over(event:MouseEvent):void {
			event.currentTarget.gotoAndPlay("over");
		}
		
		// mouse out function for buttons
		private function out(event:MouseEvent):void {
			event.currentTarget.gotoAndPlay("out");
		}
		
		// utility function to convert a string to a boolean
		private function convert(st:String):Boolean {
			
			if(st.toLowerCase() == "true") {
				return true;
			}
			else {
				return false;
			}
			
		}
		
		// fires when the xml has loaded in
		private function xLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, xLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			var xml:XML = new XML(event.target.data);
			
			// temporary vars
			var useStylesheet:String = xml.settings.useStyleSheet,
			styleURL:String,
			useStyle:Boolean;
			
			phpURL = xml.settings.phpUrl;
			sbText = xml.settings.submitButtonText;
			cbText = xml.settings.clearButtonText;
			rPhone = convert(xml.settings.restrictPhoneToNumbers);
			fromEmail = convert(xml.settings.submitFromEmailField);
			sentMessage = xml.settings.successMessage;
			
			// if we're going to use a stylesheet
			if(useStylesheet.toLowerCase() == "true") {
				useStyle = true;
				styleURL = xml.settings.styleSheetUrl;
			}
			else {
				useStyle = false;
			}
			
			xFields = xml.fields.input;
			xReq = xFields.required;
			myInfo = xml.info;
			
			(Tracker.template) ? Tracker.template.noMes() : null;
			
			if(useStyle && styleURL != null) {
				loadStyle(styleURL);
			}
			else {
				if(Tracker.template) {
					Tracker.swfIsReady = true;
				}
				else {
					setUp();
				}
			}
			
			xOpen = false;
			xLoader = null;
			
		}
		
		// GARBAGE COLLECTION
		private function remover(event:Event):void {
			
			// remove event listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, remover);
			removeEventListener(Event.UNLOAD, remover);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			if(stage != null) {
				stage.removeEventListener(MouseEvent.CLICK, switchFocus);
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, block);
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, noBlock);
			}
			
			// if the module has been activated
			if(myClear != null) {
				
				var i:int = texts.length;
				
				while(i--) {
					
					texts[i].removeEventListener(FocusEvent.FOCUS_IN, inFocus);
					texts[i].removeEventListener(FocusEvent.FOCUS_OUT, outFocus);
					texts[i].removeEventListener(Event.CHANGE, checkLines);
					
					TweenMax.killTweensOf(backs[i]);
					
					while(texts[i].numChildren) {
						
						if(texts[i].getChildAt(0) is MyScroll) {
							texts[i].getChildAt(0).kill();
						}
						
						texts[i].removeChildAt(0);
					}
					
					backs[i].graphics.clear();
					
				}
				
				// remove mouse events
				mySubmit.removeEventListener(MouseEvent.ROLL_OVER, over);
				mySubmit.removeEventListener(MouseEvent.ROLL_OUT, out);
				mySubmit.removeEventListener(MouseEvent.CLICK, submitMe);
				mySubmit.stop();
				
				myClear.removeEventListener(MouseEvent.ROLL_OVER, over);
				myClear.removeEventListener(MouseEvent.ROLL_OUT, out);
				myClear.removeEventListener(MouseEvent.CLICK, clearMe);
				myClear.stop();
				
				disable.graphics.clear();
				disable.removeEventListener(MouseEvent.CLICK, noFull);
				
				TweenMax.killTweensOf(mesHolder);
	
				mesMask.graphics.clear();
				mesHolder.removeChild(mesMask);
				successMes.removeChildAt(0);
				
				// remove children
				while(this.numChildren) {
					removeChildAt(0);
				}
				
				info.removeChildAt(0);
				
				if(tShape != null) {
					TweenMax.killTweensOf(tShape);
					tShape.graphics.clear();
					tShape = null;
				}
				
			}
			
			// set all vars to null
			mySubmit = null;
			myClear = null;
			xFields = null;
			xReq = null;
			backs = null;
			texts = null;
			info = null;
			mesMask = null;
			mesHolder = null;
			successMes = null;
			tempText = null;
			mScroll = null;
			style = null;
			
			xLoader = null;
			cssLoader = null;
			sendData = null;
			
			Tracker.contactObj = null;
			
			// check if xml file is still loading
			if(xOpen) {
				
				xLoader.removeEventListener(Event.COMPLETE, xLoaded);
				xLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					xLoader.close();
				}
				catch(event:*) {};
				xLoader = null;
			}
			
			// check if css file is still loading
			if(cssOpen) {
						
				cssLoader.removeEventListener(Event.COMPLETE, cssLoaded);
				cssLoader.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
						
				try {
					cssLoader.close();
				}
				catch(event:*){};
				cssLoader = null;
			}
			
			// check if php file is still loading
			if(sendOpen) {
				
				sendData.removeEventListener(Event.COMPLETE, varsSent);
				sendData.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
				
				try {
					sendData.close();
				}
				catch(event:*){};
				sendData = null;
			}
			
			
			
		}
		
		// fires when module has been added to the stage
		private function added(event:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, remover, false, 0, true);
			
			this.mouseEnabled = false;
			var xString:String;
			
			if(Tracker.template != null) {
				xString = Tracker.textXML;
			}
			else {
				xString = "xml/contact.xml";
			}
			
			cssOpen = false;
			sendOpen = false;
			mActive = false;
			
			// load in the xml file
			xLoader = new URLLoader();
			
			xLoader.addEventListener(Event.COMPLETE, xLoaded, false, 0, true);
			xLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			xOpen = true;
			xLoader.load(new URLRequest(xString));
			
			
		}
		
		private function catchError(event:IOErrorEvent):void {}
		
		// load in the css file
		private function loadStyle(st:String):void {
			
			cssLoader = new URLLoader()
			cssLoader.addEventListener(Event.COMPLETE, cssLoaded, false, 0, true);
			cssLoader.addEventListener(IOErrorEvent.IO_ERROR, catchError, false, 0, true);
			cssOpen = true;
			cssLoader.load(new URLRequest(st));
			
		}
		
		// fires when the css file has loaded
		private function cssLoaded(event:Event):void {
			
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, catchError);
			
			style = new StyleSheet();
			style.parseCSS(event.target.data);
			
			if(Tracker.template) {
				Tracker.swfIsReady = true;
			}
			else {
				setUp();
			}
			
			cssOpen = false;
			cssLoader = null;
			
		}
		
    }
}








