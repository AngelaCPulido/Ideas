package cj.qcreative.gallery {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import cj.qcreative.Tracker;
	import cj.qcreative.gallery.graphics.Drawing;
	import cj.qcreative.gallery.utils.CheckContain;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	// this class controls the blur buffer
    public final class BlurDesc {
		
		// begin private vars
		private static const time:Number = 0.75,
		easer:Function = Linear.easeNone;
		
		private static var w:int,
		ow:int,
		h:int,
		w2:int,
		t2:int,
		tStart:int,
		tEnd:int,
		tMargin:int,
		descH:int,
		
		kickTitle:Function,
		kickDesc:Function,
		switcher:Function,
		
		goT:Boolean,
		goD:Boolean,
		
		myGrad:Shape,
		myMask:Shape,
		cover:Shape,
		
		master:Sprite,
		iMask:Sprite,
		myHold:Sprite,
		
		loader:DisplayObject,
		bf:BlurFilter;
		// end private vars
		
		// activates the blur backgrounds for the info
		internal static function makeMasks(marginT:int):void {
			
			goT = false;
			goD = false;
			
			myGrad = new Shape();
			myMask = new Shape();
			cover = new Shape();
			
			master = new Sprite();
			iMask = new Sprite();
			myHold = new Sprite();
			
			bf = new BlurFilter(27, 27, 3);
			
			tMargin = marginT;
			t2 = tMargin * 2;
			
			GalleryTracker.blurHolder = myHold;
			
			cover.alpha = 0.5;
			myGrad.rotation = 180;
			
			master.cacheAsBitmap = true;
			iMask.cacheAsBitmap = true;
			
			iMask.name = "iMask";
			master.name = "master";
			
			myHold.mask = myMask;
			master.mask = iMask;
			
			master.mouseEnabled = iMask.mouseEnabled = myHold.mouseEnabled = false;
			
			iMask.addChild(myGrad);
			myHold.addChild(cover);
			master.addChild(myMask);
			master.addChild(myHold);
			GalleryTracker.myGal.addChild(iMask);
			GalleryTracker.myGal.addChild(master);
			
		}
		
		// wipes the onfo in and out
		internal static function wipe(out:Boolean = false, kickBack:Boolean = false, mySwitch:Function = null):void {
			
			GalleryTracker.infoWorking = true;
			
			TweenMax.killTweensOf(myGrad);
			
			master.visible = true;
			
			(mySwitch != null) ? switcher = mySwitch : null;
				
			if(out) {
				myGrad.x = tStart;
			}
			else {
				myGrad.x = tEnd;
			}
			
			if(out) {

				TweenMax.to(myGrad, time, {x: tEnd, ease: easer, onCompleteParams: [kickBack], onComplete: startSlide});
				
			}
			else {

				TweenMax.to(myGrad, time, {x: tStart, ease: easer, onComplete: flipBoo});
			}
		}
		
		// notify the document class that the info tween has finished
		private static function flipBoo():void {
			
			GalleryTracker.infoWorking = false;
			
		}
		
		// load in the next item
		private static function startSlide(kicker:Boolean):void {
			
			GalleryTracker.infoWorking = false;
				
			if(kicker) {
				switcher();
			}
			
		}
		
		// set up the blur background for the info
		internal static function setup(myLoader:DisplayObject, title:Boolean, desc:Boolean, kickT:Function, kickD:Function, hh:int, dWidth:int, dHeight:int, titleH:int):void {
			
			ow = dWidth;
			w = ow - t2;
			w2 = w * 2;
			h = hh;
			tStart = -((tMargin - w) * 2) + t2 + tMargin;
			tEnd = tStart - w2;
			
			loader = myLoader;
			kickTitle = kickT;
			kickDesc = kickD;
			
			var descH = dHeight + 9;
			goT = title;
			goD = desc;
			
			if(goT && goD) {
				
				var dub:int = titleH + descH;
				
				Drawing.drawShape(myMask, 0xFFFFFF, tMargin, 0, w, dub);
				Drawing.drawShape(cover, 0x000000, tMargin, 0, w, descH);
				
				Drawing.drawGradient(myGrad, w, w2, dub);
				
				myMask.y = h - titleH - descH - tMargin;
				cover.y = myMask.y + titleH;
				myGrad.y = myMask.y + dub;
				
				kickTitle(myMask.y, master);
				kickDesc(cover.y, master);
				
			}
			else if(!goT && goD) {
				
				Drawing.drawShape(myMask, 0xFFFFFF, tMargin, 0, w, descH);
				Drawing.drawShape(cover, 0x000000, tMargin, 0, w, descH);
				
				Drawing.drawGradient(myGrad, w, w2, descH);
				
				myMask.y = cover.y = h - descH - tMargin;
				myGrad.y = myMask.y + descH;
				
				kickDesc(cover.y, master);
				
			}
			else if(goT && !goD) {
				
				Drawing.drawShape(myMask, 0xFFFFFF, tMargin, 0, w, titleH);
				
				Drawing.drawGradient(myGrad, w, w2, titleH);
				
				myMask.y = h - titleH - tMargin;
				myGrad.y = myMask.y + titleH;
				
				kickTitle(myMask.y, master);
				
			}
			
			loader.filters = [bf];
			myHold.addChildAt(loader, 0);
			
			master.visible = false;

			GalleryTracker.myGal.setChildIndex(master, GalleryTracker.myGal.numChildren - 1);
			
		}
		
		// kill the previous background when it is no longer needed
		internal static function killSwf():void {
			
			GalleryTracker.infoWorking = false;
			
			if(goT) {
				kickTitle(myMask.y, master, true);
			}
				
			if(goD) {	
				kickDesc(cover.y, master, true);
			}
			
			myMask.graphics.clear();
			myGrad.graphics.clear();
			cover.graphics.clear();
			
			if(loader != null) {
				
				if(loader is Loader) { 
					CheckContain.removeLoader(myHold, loader);
				}
				else {
					CheckContain.removeSnapshot(myHold, loader);
				}
				loader = null;
			}
			
		}
		
		// GARBAGE COLLECTION
		internal static function finalKill():void {
			
			if(GalleryTracker.blurHolder != null) {
				
				TweenMax.killTweensOf(myGrad);
				
				if(loader != null) {
				
					if(loader is Loader) { 
						CheckContain.removeLoader(myHold, loader);
					}
					else {
						CheckContain.removeSnapshot(myHold, loader);
					}
					loader = null;
				}
				
				iMask.removeChild(myGrad);
				myHold.removeChild(cover);
				master.removeChild(myMask);
				master.removeChild(myHold);
				
				myMask.graphics.clear();
				myGrad.graphics.clear();
				cover.graphics.clear();
				
			}
			
			kickTitle = null;
			kickDesc = null;
			switcher = null;
			myGrad = null;
			myMask = null;
			cover = null;
			myMask = null;
			master = null;
			iMask = null;
			myHold = null;
			loader = null;
			
		}
		
		
    }
}








