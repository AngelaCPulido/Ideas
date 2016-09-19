package cj.qcreative {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.OverwriteManager;
	import cj.qcreative.graphics.Container;
	
	// this class controls all the blur backgrounds
    public final class DrawBlur {
		
		// begin private vars
		private static var sub:Shape,
		sub2:Shape,
		
		blur:Bitmap,
		blur2:Bitmap,
		canvas:BitmapData,
		canvas2:BitmapData,

		modulePos:int,
		storeY:int,
		storeH:int,
		storeDif:int,
		m1w:int,
		m1h:int,
		m2w:int,
		mm2x:int,
		mm3x:int,
		mm4x:int,
		mm5x:int,
		nHeight:int,
		nY:int,
		storeNewsH:int,
		newsW:int,
		m2x:Number,
		
		newsItems:Array,
		newsStore:Array,
		newsStorage:Array,
		
		masker:Sprite,
		masker2:Sprite,
		sp:Sprite,
		sp2:Sprite,
		
		moduleMask2:Shape,
		moduleMask3:Shape,
		moduleMask4:Shape,
		moduleMask5:Shape,
		preloader:Shape,
		
		isOn:int = 0,
		thumbWidth:Number = 0,
		portActivated:Boolean = false,
		galActivated:Boolean = false,
		bf:BlurFilter = new BlurFilter(Tracker.xBlur, Tracker.yBlur, Tracker.blurQuality);
		// end private vars
		
		// begin internal vars
		internal static var bg:Array = [],
		bg2:Array = [],
		mesOn:Boolean = false,
		bigOn:Boolean = false,
		oneNews:Boolean = false,
		masterSprite:Sprite = new Sprite(),
		moduleMask:Shape;
		// end internal vars
		
		// connects the main container (masterSprite) to a mask in the document class
		internal static function setupMaster(sp:Sprite, msk:Sprite):void {
			
			sp.addChild(masterSprite);
			masterSprite.mask = msk;
			masterSprite.mouseChildren = false;
			masterSprite.addEventListener(MouseEvent.ROLL_OVER, over, false, 0, true);
			
		}
		
		private static function over(event:MouseEvent):void {
			Mouse.show();
		}
		
		// creates the blur background for each sub-menu
		internal static function fixSub(yy:int, w:int, h:int):void {
			
			// we use to sets of containers so isOn checks to see which container is active
			
			if(isOn == 0) {
				sub = new Shape();
				drawShape(sub, w, h - 4);
				bg[bg.length] = sub;
				sub.x = 250;
				sub.y = yy - 9;
				sub.scaleX = sub.scaleY = 0;
				sub.alpha = 0;
				masker.addChild(sub);
			}
			else {
				sub2 = new Shape();
				drawShape(sub2, w, h - 4);
				bg2[bg2.length] = sub2;
				sub2.x = 250;
				sub2.y = yy - 9;
				sub2.scaleX = sub2.scaleY = 0;
				sub2.alpha = 0;
				masker2.addChild(sub2);
			}
			
		}
		
		// called on a browser resize, stores the current properties of the gallery module
		private static function storeGallery():void {
			
			if(galActivated) {
				
				TweenMax.killTweensOf(moduleMask, true);
				TweenMax.killTweensOf(moduleMask2, true);
				
				m1w = moduleMask.width;
				m1h = moduleMask.height;
				
				m2w = moduleMask2.width;
				m2x = ceiler(moduleMask2.x);
				
			}
			
		}
		
		// killModule fires every time a new module is loaded in
		internal static function killModule(fullClean:Boolean = false):void {
			
			// first we check if the main containers exist
			if(moduleMask != null) {
				
				if(masker != null) {
					
					// then we clean up each each mask graphic below
					
					(masker.contains(moduleMask)) ? masker.removeChild(moduleMask) : null;
					
					// if moduleMask2 needs to be cleaned up
					if(moduleMask2 != null) {
						
						TweenMax.killTweensOf(moduleMask2);
						
						(masker.contains(moduleMask2)) ? masker.removeChild(moduleMask2) : null;
						moduleMask2.graphics.clear();
						moduleMask2 = null;
						
					}
					
					// if moduleMask3 needs to be cleaned up
					if(moduleMask3 != null) {
						
						TweenMax.killTweensOf(moduleMask3);
						
						(masker.contains(moduleMask3)) ? masker.removeChild(moduleMask3) : null;
						moduleMask3.graphics.clear();
						moduleMask3 = null;
						
					}
					
					// if moduleMask4 needs to be cleaned up
					if(moduleMask4 != null) {
						
						TweenMax.killTweensOf(moduleMask4);
						
						(masker.contains(moduleMask4)) ? masker.removeChild(moduleMask4) : null;
						moduleMask4.graphics.clear();
						moduleMask4 = null;
						
					}
					
					// if moduleMask5 needs to be cleaned up
					if(moduleMask5 != null) {
						
						TweenMax.killTweensOf(moduleMask5);
						
						(masker.contains(moduleMask5)) ? masker.removeChild(moduleMask5) : null;
						moduleMask5.graphics.clear();
						moduleMask5 = null;
						
					}
					
					// check to see if news graphics exist and need to be cleaned up
					if(newsItems != null) {
						
						var j:int = newsItems.length;
						
						while(j--) {
							
							TweenMax.killTweensOf(newsItems[j]);
							
							if(masker.contains(newsItems[j])) {
								masker.removeChild(newsItems[j]);							
							}
							
							newsItems[j].graphics.clear();
							
						}
						
						newsItems = null;
						
					}
					
				}
				
				// first we check if the main container exists
				if(masker2 != null) {
					
					if(masker2.contains(moduleMask)) {
						masker2.removeChild(moduleMask);   
					}
					
					// if moduleMask2 needs to be cleaned up
					if(moduleMask2 != null) {
						
						TweenMax.killTweensOf(moduleMask2);
						
						(masker2.contains(moduleMask2)) ? masker2.removeChild(moduleMask2) : null;
						moduleMask2.graphics.clear();
						moduleMask2 = null;
					}
					
					// if moduleMask3 needs to be cleaned up
					if(moduleMask3 != null) {
						
						TweenMax.killTweensOf(moduleMask3);
						
						(masker2.contains(moduleMask3)) ? masker2.removeChild(moduleMask3) : null;
						moduleMask3.graphics.clear();
						moduleMask3 = null;
					}
					
					// if moduleMask4 needs to be cleaned up
					if(moduleMask4 != null) {
						
						TweenMax.killTweensOf(moduleMask4);
						
						(masker2.contains(moduleMask4)) ? masker2.removeChild(moduleMask4) : null;
						moduleMask4.graphics.clear();
						moduleMask4 = null;
						
					}
					
					// if moduleMask5 needs to be cleaned up
					if(moduleMask5 != null) {
						
						TweenMax.killTweensOf(moduleMask5);
						
						(masker2.contains(moduleMask5)) ? masker2.removeChild(moduleMask5) : null;
						moduleMask5.graphics.clear();
						moduleMask5 = null;
						
					}
					
					// check to see if news graphics exist and need to be cleaned up
					if(newsItems != null) {
						
						var i:int = newsItems.length;
						
						while(i--) {
							
							TweenMax.killTweensOf(newsItems[i]);
							
							if(masker2.contains(newsItems[i])) {
								masker2.removeChild(newsItems[i]);							
							}
							
							newsItems[i].graphics.clear();
							
						}
						
						newsItems = null;
						
					}
					
				}
				
				TweenMax.killTweensOf(moduleMask);
				
				moduleMask.graphics.clear();
				moduleMask = null;
			}
			
			// if the clean was not called from a browser resize event
			if(fullClean) {
				newsStore = null;
			}
			
		}
		
		// this function tweens the blur positions when a sub-menu is in the way
		internal static function pushDraw(pushMod:int, back:Boolean = false):void {
			
			if(!Tracker.isLoading && Tracker.mTweened) {
				
				// if we are to adjust the x forward
				if(!back) {
					
					var dif:int;
					
					if(!Tracker.portOn && !Tracker.newsOn) {
						dif = pushMod - modulePos - Tracker.moduleDif;
					}
					else {
						dif = pushMod - 282;
					}
					
					TweenMax.to(moduleMask, 0.5, {x: Tracker.moduleX + dif - 16, ease: Quint.easeOut});
					
					// if moduleMask2 exists
					if(moduleMask2 != null) {
						TweenMax.to(moduleMask2, 0.5, {x: mm2x + dif, ease: Quint.easeOut});
					}
					
					// if moduleMask3 exists
					if(moduleMask3 != null) {
						TweenMax.to(moduleMask3, 0.5, {x: mm3x + dif, ease: Quint.easeOut});
					}
					
					// if moduleMask4 exists
					if(moduleMask4 != null) {
						if(!Tracker.portOn) {
							TweenMax.to(moduleMask4, 0.5, {x: mm4x + dif, ease: Quint.easeOut});
						}
						else {
							if(mm4x <= 250) {
								var minus:int = 282 - mm4x;
								TweenMax.to(moduleMask4, 0.5, {x: pushMod, width: thumbWidth - minus, ease: Quint.easeOut});
							}
							else {
								TweenMax.to(moduleMask4, 0.5, {x: mm4x + dif, ease: Quint.easeOut});
							}
						}
					}
					
					// if moduleMask5 exists
					if(moduleMask5 != null) {
						TweenMax.to(moduleMask5, 0.5, {x: mm5x + dif, ease: Quint.easeOut});
					}
					
					// if news graphics exist
					if(newsItems != null) {
						
						var i:int = newsItems.length;
						
						while(i--) {
							
							TweenMax.to(newsItems[i], 0.5, {x: newsStore[i] + dif, ease: Quint.easeOut});
							
						}
						
					}
					
				}
				
				// if we are to adjust the x back
				else {
					
					TweenMax.to(moduleMask, 0.5, {x: modulePos, ease: Quint.easeOut});
					
					// if moduleMask2 exists
					if(moduleMask2 != null) {
						TweenMax.to(moduleMask2, 0.5, {x: mm2x, ease: Quint.easeOut});
					}
					
					// if moduleMask3 exists
					if(moduleMask3 != null) {
						TweenMax.to(moduleMask3, 0.5, {x: mm3x, ease: Quint.easeOut});
					}
					
					// if moduleMask4 exists
					if(moduleMask4 != null) {
						if(!Tracker.portOn) {
							TweenMax.to(moduleMask4, 0.5, {x: mm4x, ease: Quint.easeOut});
						}
						else {
							TweenMax.to(moduleMask4, 0.5, {x: mm4x, width: thumbWidth, ease: Quint.easeOut});
						}
					}
					
					// if moduleMask5 exists
					if(moduleMask5 != null) {
						TweenMax.to(moduleMask5, 0.5, {x: mm5x, ease: Quint.easeOut});
					}
					
					// if news graphics exist
					if(newsItems != null) {
						
						var j:int = newsItems.length;
						
						while(j--) {
	
							TweenMax.to(newsItems[j], 0.5, {x: newsStore[j], ease: Quint.easeOut});
							
						}
						
					}
					
				}
			}
			
		}
		
		// wipes the "success" message for the contact form
		internal static function wipeMessage(go:Boolean):void {
			
			if(moduleMask3 != null) {
				if(!go) {
					mesOn = true;
					TweenMax.to(moduleMask3, 0.75, {width: Tracker.contactObj.mWidth, ease: Quint.easeInOut});
				}
				else {
					mesOn = false;
					TweenMax.to(moduleMask3, 0.75, {width: 0, ease: Quint.easeInOut});
				}
			}
			
		}
		
		// returns the portfolio arrow background to its normal state
		internal static function returnPort():void {
			TweenMax.to(moduleMask, 0.75, {height: Tracker.moduleH + 16, ease: Quint.easeInOut});
		}
		
		// tweens out the portfolio blur graphics
		internal static function outPort():void {
			
			TweenMax.to(moduleMask2, 0.5, {scaleX: 0, ease: Quint.easeOut});
			TweenMax.to(moduleMask3, 0.5, {scaleX: 0, ease: Quint.easeOut});
			
		}
		
		// kills the small thumbs for the porfolio
		private static function killThumbs():void {
			
			if(moduleMask4 != null) {
				TweenMax.killTweensOf(moduleMask4);
				moduleMask4.graphics.clear();
				moduleMask4 = null;
			}
			
		}
		
		// animates the small thumbs out for the portfolio module
		internal static function noThumbs():void {
			
			if(moduleMask4 != null) {
				TweenMax.to(moduleMask4, 0.5, {scaleY: 0, ease: Quint.easeOut, onComplete: killThumbs});
				Tracker.moduleDif = 0;
			}
			
		}
		
		// animate the gallery arrows in
		internal static function galArrows():void {
			
			if(moduleMask3 != null) {
				
				TweenMax.to(moduleMask3, 0.5, {scaleY: 1, ease: Quint.easeOut});
				
			}
			
		}
		
		// toggle the porfolio arrows
		internal static function portArrows(showMask:Boolean):void {
			
			if(moduleMask5 != null) {
				
				if(!showMask) {
					portActivated = true;
					TweenMax.to(moduleMask5, 0.5, {scaleX: 0, ease: Quint.easeOut});
				}
				else {
					portActivated = false;
					Tracker.moduleDif = 0;
					TweenMax.to(moduleMask5, 0.5, {scaleX: 1, ease: Quint.easeOut});
				}
			}
			
		}
		
		// fires every time the porfolio thumbstrip is shifted
		internal static function shiftThumbs(num:Number):void {
			
			Tracker.moduleDif = num;
			var dif:Number = modulePos;
			dif += num;
			mm4x = dif;
			TweenMax.to(moduleMask4, 0.75, {x: dif, ease: Quint.easeInOut});
			
		}
		
		// fires each time a portfolio small thumbnail is loaded in
		internal static function updateThumbs(i:int, bw:int, tw:int):void {
			
			thumbWidth = bw + 32 + (tw * i);
			TweenMax.to(moduleMask4, 0.5, {width: thumbWidth, ease: Quint.easeOut});
			
		}
		
		// utility function for drawing a shape
		private static function drawShape(sh:Shape, w:int, h:int):void {
			
			sh.graphics.clear();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, w, h);
			sh.graphics.endFill();
			
		}
		
		// builds the portfolio thumbnails when a category is activated
		internal static function buildThumbs(fromHere:Boolean = false):void {

			if(Tracker.portObj) {
			
				killThumbs();
				
				moduleMask4 = new Shape();
				drawShape(moduleMask4, Tracker.portObj.tw, Tracker.portObj.th);
				
				var dif:Number;
				
				if(!fromHere) {
					dif = modulePos;
					moduleMask4.width = Tracker.portObj.bw;
				}
				
				// if called from a browser resize event
				else {
					moduleMask4.width = thumbWidth;
					dif = modulePos;
					dif += Tracker.moduleDif;
				}
				
				mm4x = dif;
				moduleMask4.x = mm4x;
				moduleMask4.y = (Tracker.stageH >> 1) - (Tracker.portObj.myTotal >> 1) + Tracker.portObj.dif;
				
				(isOn == 0) ? masker.addChild(moduleMask4) : masker2.addChild(moduleMask4);
				
			}
			
		}
		
		// positions the two conntrol graphics for the portfolio module
		internal static function portControl(w:int, h:int, yPos:int, difY:int, fromResize:Boolean):void {
			
			if(moduleMask2 != null) {
				moduleMask2.graphics.clear();
			}
			if(moduleMask3 != null) {
				moduleMask3.graphics.clear();
			}
			
			moduleMask2 = new Shape();
			drawShape(moduleMask2, w, h);
			
			mm2x = modulePos + moduleMask.width;
			moduleMask2.x = mm2x;
			moduleMask2.y = (Tracker.stageH >> 1) - ((yPos + difY) >> 1) + yPos - 8;
			
			moduleMask3 = new Shape();
			drawShape(moduleMask3, 81, 42)
			mm3x = mm2x;
			moduleMask3.x = mm3x
			moduleMask3.y = moduleMask2.y + h;
			
			// find which main container is active
			if(isOn == 0) {
				masker.addChild(moduleMask2);
				masker.addChild(moduleMask3);
			}
			else {
				masker2.addChild(moduleMask2);
				masker2.addChild(moduleMask3);
			}
			
			if(!fromResize) {
				moduleMask2.scaleX = moduleMask3.scaleX = 0;
				TweenMax.to(moduleMask2, 0.75, {scaleX: 1, ease: Quint.easeOut});
				TweenMax.to(moduleMask3, 0.75, {scaleX: 1, ease: Quint.easeOut});
			}
			
			// if called from a browser resize event
			else {
				buildThumbs(true);
			}
			
		}
		
		// updates the main blur for the portfolio module
		internal static function updatePort(goTween:Boolean, yy:int, howHigh:int, easeBoth:Boolean, isLast:Boolean):void {
			
			var laster:int = isLast ? 16 : 0;
			
			if(goTween) {
				
				if(!easeBoth) {
					if(howHigh == 0) {
						TweenMax.to(moduleMask, 0.75, {y: yy, ease: Quint.easeOut});
					}
					else {
						TweenMax.to(moduleMask, 0.75, {height: Tracker.moduleH + howHigh + laster, y: yy, ease: Quint.easeOut});
					}
				}
				else {
					if(howHigh == 0) {
						TweenMax.to(moduleMask, 0.75, {y: yy, ease: Quint.easeInOut});
					}
					else {
						TweenMax.to(moduleMask, 0.75, {height: Tracker.moduleH + howHigh + laster, y: yy, ease: Quint.easeInOut});
					}
				}
				
			}
			
			else {
				
				TweenMax.killTweensOf(moduleMask);
				moduleMask.y = yy;
				(howHigh != 0) ? moduleMask.height = Tracker.moduleH + howHigh + laster : null;
				
			}
			
			
		}
		
		// cleans up all the tracking vars if an unknown swf is loaded as a module
		internal static function cleanUp():void {
			
			Tracker.galleryOn = false;
			Tracker.contactOn = false;
			Tracker.portOn = false;
			Tracker.newsOn = false;
			Tracker.openNews = false;
			galActivated = false;
			portActivated = false;
			bigOn = false;
			thumbWidth = 0;
			Tracker.portObj = null;
			Tracker.newsObj = null;
			Tracker.contactObj = null;
			
		}
		
		// this function draws the blur set for each module
		internal static function drawModule(pos:String, wid:int, h:int, myX:int, myY:int, longText:Boolean, contact:Boolean, gallery:Boolean, portfolio:Boolean, news:Boolean, fromResize:Boolean, noTween:Boolean):void {
			
			if(!Tracker.isLoading) {
			
				var hh:int, small:Boolean = false, yy:Number = 0, mid:Number, scalingX:Boolean = true, tw:int = Tracker.stageW, th:int = Tracker.stageH;
				
				if(!longText) {
					hh = h + 17;
				}
				
				// if longText module is active we apply some extra math here
				else {
					if(h == 16 || h + 32 >= th) {
						hh = th;
					}
					else {
						hh = h - 32;
						small = true;
					}
				}
				
				if(!longText) {
					(!portfolio) ? yy = myY - 16 : yy = 0;
				}
				else if(small) {
					yy = (th >> 1) - (hh >> 1);
					yy = (yy > 0) ? int(yy + 0.5) : int(yy - 0.5); 
				}
				
				modulePos = myX - 16;
				storeY = yy;
				storeH = hh;
				
				// if a basic draw is to occur (only in need of a single graphic)
				if(!contact && !gallery && !portfolio && !news) {
					Tracker.galleryOn = false;
					Tracker.contactOn = false;
					Tracker.portOn = false;
					Tracker.newsOn = false;
					Tracker.openNews = false;
					galActivated = false;
					portActivated = false;
					bigOn = false;
					thumbWidth = 0;
					Tracker.portObj = null;
					Tracker.newsObj = null;
					Tracker.contactObj = null;
					
					moduleMask = new Shape();
					drawShape(moduleMask, wid, hh);
					
				}
				
				// if the portfolio module is active
				else if(portfolio) {
					
					Tracker.galleryOn = false;
					Tracker.contactOn = false;
					Tracker.newsOn = false;
					Tracker.portOn = true;
					Tracker.openNews = false;
					galActivated = false;
					bigOn = false;
					Tracker.newsObj = null;
					Tracker.contactObj = null;
					
					moduleMask = new Shape();
					moduleMask5 = new Shape();
					drawShape(moduleMask, wid, hh);
					drawShape(moduleMask5, tw - wid - modulePos - 16, 66);
	
					mm5x = Tracker.stageW;
					moduleMask5.x = mm5x;
					moduleMask5.y = th;
					moduleMask5.rotation = 180;
					moduleMask5.scaleX = 0;
					
				}
				
				// if the gallery module is active
				else if(gallery) {
					
					Tracker.portOn = false;
					Tracker.contactOn = false;
					Tracker.newsOn = false;
					Tracker.galleryOn = true;
					portActivated = false;
					Tracker.openNews = false;
					Tracker.portObj = null;
					Tracker.newsObj = null;
					Tracker.contactObj = null;
					scalingX = false;
					
					thumbWidth = 0;
					
					var sideH:Number = ((th - hh) >> 1) - 8;
					sideH = (sideH > 0) ? int(sideH + 0.5) : int(sideH - 0.5); 
					
					moduleMask = new Shape();
					moduleMask2 = new Shape();
					drawShape(moduleMask, Tracker.galThumbW + Tracker.galSpace, hh);
					drawShape(moduleMask2, Tracker.totalGal, hh);
					
					moduleMask2.y = yy;
					
					moduleMask3 = new Shape();
					drawShape(moduleMask3, 74, sideH);
					
					mm3x = tw;
					
					moduleMask3.rotation = 180;
					
					moduleMask3.x = tw;
					moduleMask3.y = th;
					
					(bigOn) ? moduleMask3.scaleX = 0 : null;
					
					if(!fromResize) {
						mm2x = Tracker.galThumbW + 266 + Tracker.galSpace;
						galActivated = false;
						moduleMask3.scaleY = 0;
					}
					
					moduleMask2.x = mm2x;
					
				}
				
				// if the news module is active
				else if(news) {
					
					Tracker.galleryOn = false;
					Tracker.contactOn = false;
					Tracker.portOn = false;
					Tracker.newsOn = true;
					Tracker.portObj = null;
					Tracker.contactObj = null;
					galActivated = false;
					portActivated = false;
					bigOn = false;
					scalingX = false;
					
					moduleMask = new Shape();
					moduleMask2 = new Shape();
					
					if(!oneNews) {
						drawShape(moduleMask, wid - 32, hh);
						drawShape(moduleMask2, 66, (th >> 1) - (Tracker.moduleH >> 1) - 16);
					}
					else {
						drawShape(moduleMask, wid - 32, hh);
					}
					
					var nTotal:int = Tracker.newsObj.newsTotal;
					var nw:int = Tracker.newsObj.newsWidth;
					var bDif:int = nw - 16;
					var bCount:int = 266;
					
					var nsp:Container;
					
					newsItems = [];
					nHeight = Tracker.newsObj.newsHeight;
					nY = yy;
					
					// if the news array needs to be built
					if(newsStore == null) {
						
						newsStore = [];
						
						for(var i:int = 0; i < nTotal; i++) {
							
							nsp = new Container(nw, nHeight, 0x000000, i);
							nsp.x = bCount;
							nsp.xx = bCount;
							nsp.y = yy;
							
							newsStore[i] = bCount;
							bCount += bDif;
							
							newsItems[i] = nsp;
							
							(isOn == 0) ? masker.addChild(nsp) : masker2.addChild(nsp);
							
							(!fromResize) ? nsp.scaleY = 0 : null;
							
						}
					}
					
					// if the news array already exists
					else {
						
						for(var j:int = 0; j < nTotal; j++) {
							
							nsp = new Container(nw, nHeight, 0x000000, j);
							
							if(newsStore[j] >= 266) {
								nsp.x = newsStore[j];
							}
							else {
								nsp.x = 266;
								nsp.scaleX = 0;
							}
							
							nsp.xx = bCount;
							nsp.y = yy;
							
							bCount += bDif;
							
							newsItems[j] = nsp;
							
							(isOn == 0) ? masker.addChild(nsp) : masker2.addChild(nsp);
							
						}
						
					}
					
					// if a news item is open
					if(Tracker.openNews) {
						
						var newsDif:int = (Tracker.stageH >> 1) - (storeNewsH >> 1);
						var newsDifH:int = storeNewsH;
						
						if(newsDif < 16) {
							newsDif = 16;
						}
						if(newsDifH > Tracker.stageH - 32) {
							newsDifH = Tracker.stageH - 32;
						}
						
						newsItems[Tracker.newsNumber].y = newsDif;
						newsItems[Tracker.newsNumber].height = newsDifH;
					}
	
					mm2x = tw;
					moduleMask2.x = mm2x;
					moduleMask2.y = th;
					moduleMask2.rotation = 180;
					
					if(!fromResize) {
						moduleMask2.scaleX = 0;
					}
					else {
						moduleMask.width = newsW;
					}
					
				}
				
				// if the contact module is active
				else {
					
					var lHeight:int = Tracker.contactObj.leftHeight + 27;
					
					Tracker.portOn = false;
					Tracker.galleryOn = false;
					Tracker.newsOn = false;
					Tracker.contactOn = true;
					Tracker.openNews = false;
					galActivated = false;
					portActivated = false;
					bigOn = false;
					thumbWidth = 0;
					Tracker.portObj = null;
					Tracker.newsObj = null;
					scalingX = false;
					
					moduleMask = new Shape();
					moduleMask2 = new Shape();
					drawShape(moduleMask, 332, lHeight);
					drawShape(moduleMask2, Tracker.contactObj.rightWidth + 32, Tracker.contactObj.rightHeight + 32);
	
					mm2x = modulePos + 336;
					moduleMask2.x = mm2x;
					moduleMask2.y = yy;
					
					moduleMask3 = new Shape();
					drawShape(moduleMask3, Tracker.contactObj.mWidth, 20);
	
					(!mesOn) ? moduleMask3.width = 0 : null;
					mm3x = modulePos;
					moduleMask3.x = mm3x;
					moduleMask3.y = yy + lHeight + 4;
					
				}
				
				moduleMask.x = modulePos;
				
				if(!galActivated) {
					moduleMask.y = yy;
				}
				else {
					moduleMask.width = m1w;
					moduleMask.height = m1h;
					moduleMask.y = yy + storeDif;
					moduleMask2.width = m2w;
					moduleMask2.x = m2x;
				}
				
				(gallery) ? galActivated = true : null;
				
				// news and long text require the TweenMax OverwriteManager to be toggled
				if(!news && !longText) {
					OverwriteManager.mode = OverwriteManager.ALL_IMMEDIATE;
				}
				else {
					OverwriteManager.mode = OverwriteManager.AUTO;
				}
				
				// isOn tells us which main container is active
				if(isOn == 0) {
					masker.addChild(moduleMask);
					if(gallery || contact) {
						masker.addChild(moduleMask2);
						masker.addChild(moduleMask3);
					}
					else if(news) {
						masker.addChild(moduleMask2);
					}
					else if(portfolio) {
						masker.addChild(moduleMask5);
						if(!portActivated) {
							TweenMax.to(moduleMask5, 0.5, {scaleX: 1, ease: Quint.easeOut});
						}
					}
				}
				else {
					masker2.addChild(moduleMask);
					if(gallery || contact) {
						masker2.addChild(moduleMask2);
						masker2.addChild(moduleMask3);
					}
					else if(news) {
						masker2.addChild(moduleMask2);
					}
					else if(portfolio) {
						masker2.addChild(moduleMask5);
						if(!portActivated) {
							TweenMax.to(moduleMask5, 0.5, {scaleX: 1, ease: Quint.easeOut});
						}
					}
				}
				
				// if the function was not a result of a browser resize event
				if(!fromResize) {
					if(!noTween) {
						if(!scalingX) {
							moduleMask.scaleY = 0;
							TweenMax.to(moduleMask, 0.5, {scaleY: 1, ease: Quint.easeOut, onComplete: checkModule});
							if(gallery) {
								moduleMask2.scaleY = 0;
								TweenMax.to(moduleMask2, 0.5, {scaleY: 1, ease: Quint.easeOut});
							}
						}
						else {
							moduleMask.scaleX = 0;
							TweenMax.to(moduleMask, 0.5, {scaleX: 1, ease: Quint.easeOut, onComplete: checkModule});
						}
					}
					else {
						Tracker.mTweened = true;
					}
				}
			}
		}
		
		// restores the news items to their proper scaleY
		internal static function checkModule():void {
			
			if(newsItems != null) {
				
				var i:int = newsItems.length;
				
				while(i--) {
					
					newsItems[i].scaleY = 1;
					
				}
				
			}
			
			Tracker.mTweened = true;
			
		}
		
		internal static function setGallery():void {
			
			bigOn = false;
			galActivated = false;
			storeDif = 0;
			
		}
		
		// adjusts the main graphic for the gallery module
		internal static function adjustBlur(difX:int):void {
			
			if(!bigOn) {
				TweenMax.to(moduleMask2, 0.75, {width: difX, ease: Quint.easeOut});
			}
			else {
				TweenMax.to(moduleMask2, 0.75, {width: difX, ease: Quint.easeInOut});
			}
			
		}
		
		// just a utility function which is faster than Math.ceil()
		private static function ceiler(i:Number):Number {
   			return i == int(i) ? i : int(i + 1);
		}
		
		// adjusts the blur graphics up for a gallery item click
		internal static function adjustBig(w:int, h:int, yy:int, difX:int):void {
			
			var xx:Number = mm2x;
			
			storeDif = yy;
			
			TweenMax.to(moduleMask, 0.5, {width: w + (Tracker.galSpace << 1), height: h + 48, y: storeY + yy, ease: Quint.easeOut});
			
			mm2x = xx + difX
			TweenMax.to(moduleMask2, 0.5, {x: mm2x, ease: Quint.easeOut});
			
			if(moduleMask3.scaleX != 0) {
				TweenMax.to(moduleMask3, 0.5, {scaleX: 0, ease: Quint.easeOut});
			}
			
			bigOn = true;
			
		}
		
		// adjusts the blur graphics down for a gallery item close action
		internal static function adjustSmall(difX:int):void {
			
			storeDif = 0;
			
			var xx:Number = mm2x;
			
			TweenMax.to(moduleMask, 0.5, {width: Tracker.galThumbW + Tracker.galSpace, height: storeH, y: storeY, ease: Quint.easeOut});
			
			mm2x = xx - difX;
			
			TweenMax.to(moduleMask2, 0.5, {x: mm2x, ease: Quint.easeOut});
			TweenMax.to(moduleMask3, 0.5, {scaleX: 1, ease: Quint.easeOut});
			
			bigOn = false;
			
		}
		
		// stores the correct width for the news graphics when a browser resize occurs
		internal static function storeNews():void {
			
			if(TweenMax.isTweening(moduleMask)) {
				TweenMax.killTweensOf(moduleMask, true);
			}
			
			newsW = moduleMask.width;
		
		}
		
		// animates the news arrows in when the news module loads
		internal static function newsArrow():void {
			
			TweenMax.to(moduleMask2, 0.5, {scaleX: 1, ease: Quint.easeOut});
			
		}
		
		// closes a news item when closed
		internal static function closeNews(i:int):void {

			TweenMax.to(newsItems[i], 0.75, {y: nY, height: nHeight, ease: Quint.easeOut});
			
		}
		
		// opens up a news item when clicked
		internal static function openNews(i:int, yy:int, hh:int, tween:Boolean):void {
			
			storeNewsH = hh;
			var newsDifY:int = nY + yy;
			(newsDifY < 16) ? newsDifY = 0 : null;
			
			if(!tween) {
				TweenMax.to(newsItems[i], 0.75, {y: newsDifY, height: hh, ease: Quint.easeOut});
			}
			else {
				TweenMax.killTweensOf(newsItems[i]);
				newsItems[i].y = newsDifY;
				newsItems[i].height = hh;
			}
			
		}
		// shifts the news items upon an arrow click
		internal static function shiftNews(xx:int):void {
			
			var dif:int = Tracker.moduleW;
			dif += xx;
			
			TweenMax.to(moduleMask, 0.75, {width: dif, ease: Quint.easeOut});
			
			var i:int = newsItems.length;
			var nDif:int;
			
			// checks to see if a news item is open and closes it if necessary
			while(i--) {
				
				nDif = newsItems[i].xx;
				nDif += xx;
				newsStore[i] = nDif;
				
				if(nDif < 266) {
					if(newsItems[i].scaleX != 0) {
						TweenMax.to(newsItems[i], 0.75, {scaleX: 0, ease: Quint.easeOut});
					}
				}
				else if(newsItems[i].scaleX != 1) {
					TweenMax.to(newsItems[i], 0.75, {scaleX: 1, ease: Quint.easeOut});
				}
				
				if(nDif < 266) {
					nDif = 266;
				}
				
				TweenMax.to(newsItems[i], 0.75, {x: nDif, ease: Quint.easeOut});
				
			}
			
		}
		
		// called when a sub-menu is activated
		internal static function showSub(i:int):void {
			
			(bg[i] != null) ? TweenMax.to(bg[i], 0.6, {scaleX: 1, scaleY: 1, ease: Quint.easeInOut}) : null;
			(bg2[i] != null) ? TweenMax.to(bg2[i], 0.6, {scaleX: 1, scaleY: 1, ease: Quint.easeInOut}) : null;
			
			if(Tracker.template.contains(masterSprite)) {
				Tracker.template.setChildIndex(masterSprite, 3);
			}
			
		}
		
		// called when a sub-menu is deactivated
		internal static function hideSub(i:int, fast:Boolean = false):void {

			var tim:Number;
			(!fast) ? tim = 0.4 : tim = 0.25;
			
			(bg[i] != null) ? TweenMax.to(bg[i], tim, {scaleX: 0, scaleY: 0, ease: Quint.easeOut}) : null;
			(bg2[i] != null) ? TweenMax.to(bg2[i], tim, {scaleX: 0, scaleY: 0, ease: Quint.easeOut}) : null;
		}
		
		// checks to see which main container is active
		private static function checkMask(test:Boolean = false):Boolean {
			
			var tru:Boolean;
			
			if(!test) {
				if(masker != null) {
					tru = true;
					TweenMax.killTweensOf(masker, true);
				}
				else {
					tru = false;
				}
			}
			else {
				if(masker2 != null) {
					tru = true;
					TweenMax.killTweensOf(masker2, true);
				}
				else {
					tru = false;
				}
			}
			
			return tru;
			
		}
		
		// kills main container #1
		private static function killOne():void {
			
			if(canvas != null) {
				canvas.dispose();
			}
			
			var can:Boolean = checkMask(), i:int = bg.length;
			
			while(i--) {
				TweenMax.killTweensOf(bg[i]);
				if(can) {
					(masker.contains(bg[i])) ? masker.removeChild(bg[i]) : null;
				}
				bg[i].graphics.clear();
				bg[i] = null;
			}
				
			bg = [];
				
			if(sp != null) {
				sp.removeChild(blur);
				masterSprite.removeChild(sp);
				sp = null;
			}
			if(masker != null) {
				masterSprite.removeChild(masker);
				masker.graphics.clear();
				masker = null;
			}
			
			blur = null;
			canvas = null;
				
		}
		
		// kills main container #2
		private static function killTwo():void {
			
			if(canvas2 != null) {
				canvas2.dispose();
			}
			
			var can:Boolean = checkMask(true), i:int = bg2.length;
			
			while(i--) {
				TweenMax.killTweensOf(bg2[i]);
				if(can) {
					(masker2.contains(bg2[i])) ? masker2.removeChild(bg2[i]) : null;
				}
				bg2[i].graphics.clear();
				bg2[i] = null;
			}
				
			bg2 = [];
				
			if(sp2 != null) {
				sp2.removeChild(blur2);
				masterSprite.removeChild(sp2);
				sp2 = null;
			}
			if(masker2 != null) {
				masterSprite.removeChild(masker2);
				masker2.graphics.clear();
				masker2 = null;
			}
			
			blur2 = null;
			canvas2 = null;
			
		}
		
		// called once the bg transition has finished wiping
		private static function addListen():void {
			
			CreateMenu.menuListen();
			Tracker.testReady();
			Tracker.template.visibleModule();
			
		}
		
		// forces tweens to complete if a browser resize event occurs while a bg transition is taking place
		private static function maskCheck():void {
			
			  TweenMax.killTweensOf(masker, true);
			  TweenMax.killTweensOf(masker2, true);
			
		}
		
		// draws the module preloader background
		internal static function drawPreloader():void {
			
			TweenMax.killTweensOf(preloader);
			
			preloader = new Shape();
			drawShape(preloader, 177, 119);
			preloader.x = Tracker.stageW;
			preloader.y = (Tracker.stageH >> 1) - 59.5;
			
			TweenMax.to(preloader, 0.5, {x: Tracker.stageW - 177, ease: Quint.easeOut});
			
			(isOn == 0) ? masker.addChild(preloader) : masker2.addChild(preloader);
			
		}
		
		// kills the module preloader
		private static function killPre():void {
			
			if(masker != null) {
				if(preloader != null) {
					(masker.contains(preloader)) ? masker.removeChild(preloader) : null;
				}
			}
			if(masker2 != null) {
				if(preloader != null) {
					(masker2.contains(preloader)) ? masker2.removeChild(preloader) : null;
				}
			}
			if(preloader != null) {
				TweenMax.killTweensOf(preloader);
				preloader.graphics.clear();
				preloader = null;
			}
			
		}
		
		// tweens out the module preloader
		internal static function killPreloader():void {
			
			if(preloader != null) {
				TweenMax.to(preloader, 0.5, {x: Tracker.stageW, ease: Quint.easeOut, onComplete: killPre});
			}
			
		}
		
		// draws the blur background that is used for all blurs
		internal static function draw(bit:Bitmap, bitID:int, reSize:Boolean = false):void {
			
			Tracker.template.dontLoad = false;
			
			// if the function was called from a browser resize event
			if(reSize) {
				killOne();
				killTwo();
				storeGallery();
				killModule();
			}
			
			isOn = bitID;
			
			// checks to see which main container should be activated
			if(isOn == 0) {
				
				canvas = bit.bitmapData.clone();
				
				blur = new Bitmap(canvas);
	
				blur.filters = [bf];
				
				sp = new Sprite();
				sp.mouseEnabled = false;
				sp.addChild(blur);
				
				sp.x = bit.x;
				sp.y = bit.y;
				
				blur.x = 0;
				blur.y = 0;
				blur.width = bit.width;
				blur.height = bit.height;

				masker = new Sprite();
				masker.graphics.beginFill(0x000000);
				masker.graphics.drawRect(0, 0, 250, Tracker.stageH);
				masker.graphics.endFill();
				masker.mouseEnabled = false;
				
				sp.mask = masker;
				
				masterSprite.addChild(sp);
				masterSprite.addChild(masker);
				
				// if the function was not called from a browser resize event
				if(!reSize) {
					
					masker.scaleY = 0;
					masker.y = 0;
					TweenMax.to(masker, 1, {scaleY: 1, ease: Quint.easeInOut, onComplete: addListen});
					
					if(masker2 != null) {
						TweenMax.to(masker2, 1, {y: Tracker.stageH, ease: Quint.easeInOut, onComplete: killTwo});
					}
				}

			}
			
			// if main container #2 should be activated
			else {

				canvas2 = bit.bitmapData.clone();
				
				blur2 = new Bitmap(canvas2);
	
				blur2.filters = [bf];
				
				sp2 = new Sprite();
				sp2.mouseEnabled = false;
				sp2.addChild(blur2);
				
				sp2.x = bit.x;
				sp2.y = bit.y;
				
				blur2.x = 0;
				blur2.y = 0;
				blur2.width = bit.width;
				blur2.height = bit.height;

				masker2 = new Sprite();
				masker2.graphics.beginFill(0x000000);
				masker2.graphics.drawRect(0, 0, 250, Tracker.stageH);
				masker2.graphics.endFill();
				masker2.mouseEnabled = false;
				
				sp2.mask = masker2;
				
				masterSprite.addChild(sp2);
				masterSprite.addChild(masker2);
				
				// if the function was not called from a browser resize event
				if(!reSize) {
					
					masker2.scaleY = 0;
					masker2.y = 0;
					TweenMax.to(masker2, 1, {scaleY: 1, ease: Quint.easeInOut, onComplete: addListen});
					
					if(masker != null) {
						TweenMax.to(masker, 1, {y: Tracker.stageH, ease: Quint.easeInOut, onComplete: killOne});
					}
					
				}

			}
			
			(Tracker.isLoading) ? drawPreloader() : null;
			
			Tracker.template.fixIndex();
			
		}
    }
}













