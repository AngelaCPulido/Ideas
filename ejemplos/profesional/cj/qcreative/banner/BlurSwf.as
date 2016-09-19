package cj.qcreative.banner {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.filters.BlurFilter;
	import cj.qcreative.Tracker;
	import cj.qcreative.banner.utils.CheckContain;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	// this class draws the blur background for the titles and descriptions
    public class BlurSwf {
		
		// begin private vars
		private static const time:Number = 0.75, easer:Function = Linear.easeNone;
		
		private static var w:int,
		w2:int,
		h:int,
		tMargin:int,
		
		kickTitle:Function,
		kickDesc:Function,
		switcher:Function,
		
		goT:Boolean,
		goD:Boolean,
		
		myMask:Shape,
		cover:Shape,
		grad1:Shape,
		grad2:Shape,
		
		master:Sprite,
		container:Sprite,
		iMask:Sprite,
		myGrad:Sprite,
		holder:Sprite,
		
		loader:Loader,
		bf:BlurFilter;
		// end private vars
		
		// initializes the class
		internal static function makeMasks(ww:int, hh:int, marginT:int, func:Function, kickT:Function, kickD:Function):void {
			
			goT = false;
			goD = false;
			
			// create the Shapes
			myMask = new Shape();
			cover = new Shape();
			grad1 = new Shape();
			grad2 = new Shape();
			
			// create the Sprites
			master = new Sprite();
			container = new Sprite();
			iMask = new Sprite();
			myGrad = new Sprite();
			holder = new Sprite();
			
			BannerTracker.blurHolder = master;
			
			bf = new BlurFilter(27, 27, 3);
			
			tMargin = marginT;
			w = ww - (tMargin * 2);
			w2 = w * 2;
			h = hh;
			
			// store the passed functions so we can call them later
			switcher = func;
			kickTitle = kickT;
			kickDesc = kickD;
			
			myMask.x = tMargin;
			cover.x = tMargin;
			iMask.x = tMargin;
			grad2.x = w;
			
			myGrad.rotation = 180;
			cover.alpha = 0.5;
			
			master.mask = myMask;
			container.mask = iMask;
			
			// add the children
			myGrad.addChild(grad1);
			myGrad.addChild(grad2);
			iMask.addChild(myGrad);
			master.addChild(myMask);
			master.addChild(cover);
			container.addChild(master);
			holder.addChild(container);
			holder.addChild(iMask);
			BannerTracker.banner.addChild(holder);
			
			container.cacheAsBitmap = iMask.cacheAsBitmap = true;
			
			master.mouseEnabled = container.mouseEnabled = iMask.mouseEnabled = myGrad.mouseEnabled = holder.mouseEnabled = false;
			
		}
		
		// called when info is to wipe in or out
		internal static function wipe(out:Boolean = false, kickBack:Boolean = false, setPos:Boolean = false):void {
			
			BannerTracker.infoWorking = true;
			
			TweenMax.killTweensOf(myGrad);
			
			master.visible = true;
				
			if(!setPos) {
				if(out) {
					myGrad.x = w2;
				}
				else {
					myGrad.x = 0;
				}
			}
			
			// if info is to wipe out
			if(out) {

				TweenMax.to(myGrad, time, {x: 0, ease: easer, onCompleteParams: [kickBack], onComplete: startSlide});
				
			}
			
			// if info is to wipe in
			else {
				
				TweenMax.to(myGrad, time, {x: w2, ease: easer, onComplete: restoreGrad});
				
			}

		}
		
		// lets the banner know the wipe in animation has finsihed
		private static function restoreGrad():void {
			
			BannerTracker.infoWorking = false;
			
			(BannerTracker.playOn) ? BannerTracker.banner.startTim() : null;
			
		}
		
		// lets the banner know it can move on to the next slide
		private static function startSlide(kicker:Boolean):void {
			
			BannerTracker.infoWorking = false;
				
			if(kicker) {
				switcher();
			}
			
		}
		
		// utility function for drawing a Shape
		private static function drawShape(sh:Shape, hh:int):void {
			
			sh.graphics.clear();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, w, hh);
			sh.graphics.endFill();
			
		}
		
		// utility function for drawing a gradient
		private static function drawGradient(hh:int):void {
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, hh);
			
			grad1.graphics.clear();
			grad1.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 1], [0, 255], matr, SpreadMethod.PAD);
			grad1.graphics.drawRect(0, 0, w, hh);
			grad1.graphics.endFill();
				
			grad2.graphics.clear();
			grad2.graphics.beginFill(0x000000);
			grad2.graphics.drawRect(0, 0, w, hh);
			grad2.graphics.endFill();
			
		}
		
		// sets up the blurs
		internal static function setup(myLoader:Loader, titl:Boolean, desc:Boolean, dHeight:int, titleH:int):void {
			
			killSwf();
			
			loader = myLoader;
			goT = titl;
			goD = desc;
			
			var descH:int = dHeight + 18;
			
			// if both the title and description are used
			if(goT && goD) {
				
				drawShape(myMask, titleH + descH);
				drawShape(cover, descH);
				drawGradient(titleH + descH);
					
				myMask.y = iMask.y = h - titleH - descH - tMargin;
				cover.y =  myMask.y + titleH;
				myGrad.y = titleH + descH;
				
				kickTitle(myMask.y, master);
				kickDesc(cover.y, master);
				
			}
			
			// if only the description are used
			else if(!goT && goD) {
				
				drawShape(myMask, descH);
				drawShape(cover, descH);
				drawGradient(descH);
					
				myMask.y = iMask.y = cover.y = h - descH - tMargin;
				myGrad.y = descH;
				
				kickDesc(myMask.y, master);
				
			}
			
			// if only the title is used
			else if(goT && !goD) {
				
				drawShape(myMask, titleH);
				drawGradient(titleH);
					
				myMask.y = iMask.y = h - titleH - tMargin;
				myGrad.y = titleH;
				
				kickTitle(myMask.y, master);
				
			}
			
			loader.filters = [bf];
			master.addChildAt(loader, 0);
			
			BannerTracker.banner.setChildIndex(holder, BannerTracker.banner.numChildren - 1);
			
			master.visible = false;
			
		}
		
		// kill the previous info blur
		internal static function killSwf():void {
			
			if(goT) {
				kickTitle(myMask.y, master, true);
			}
				
			if(goD) {	
				kickDesc(cover.y, master, true);
			}
			
			myMask.graphics.clear();
			grad1.graphics.clear();
			grad2.graphics.clear();
			cover.graphics.clear();
			
			if(loader != null) {
				CheckContain.removeLoader(master, loader);
				loader = null;
			}
			
		}
		
		// GARBAGE COLLECTION
		internal static function finalKill():void {
			
			// if the module has been activated
			if(switcher != null) {
				
				TweenMax.killTweensOf(myGrad);
				CheckContain.removeLoader(master, loader);
				
				// remove all children
				myGrad.removeChild(grad1);
				myGrad.removeChild(grad2);
				iMask.removeChild(myGrad);
				master.removeChild(myMask);
				master.removeChild(cover);
				container.removeChild(master);
				holder.removeChild(container);
				holder.removeChild(iMask);
				
				// clear all graphics
				myMask.graphics.clear();
				grad1.graphics.clear();
				grad2.graphics.clear();
				cover.graphics.clear();
				
			}
			
			// set all vars to null
			kickTitle = null;
			kickDesc = null;
			switcher = null;
			loader = null;
			myMask = null;
			cover = null;
			grad1 = null;
			grad2 = null;
			master = null;
			container = null;
			iMask = null;
			myGrad = null;
			holder = null;
			
		}
		
    }
}








