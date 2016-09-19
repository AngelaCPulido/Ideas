package cj.qcreative.news {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.filters.BlurFilter;
	import flash.display.BlendMode;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class manages the main title for an item
    public final class MyTitle {
		
		// begin private vars
		private static var yy:Number, theW:int;
		
		private static const h:int = 24;
		// end private vars
		
		// performance enhancement to avoid expensive Math.ceil call
		private static function ceil(val:Number):Number {
    		return val == int(val) ? val : int(val + 1);
		}
		
		// stores the width of the item
		internal static function calculate(ww:int, hh:int, dist:int):void {
			
			theW = ww;
			yy = hh - dist;

		}
		
		// sets up the title background blur
		internal static function setUp(bit:Bitmap, sp:MyHolder, theText:Sprite):Number {
			
			var bf:BlurFilter, bHolder:Sprite, tf:TextField, hBitH:int, wPlus:int, hPlus:int, spr:Shape, sh:Shape, master:Sprite, masterMask:Shape;
			
			bf = new BlurFilter(27, 27, 3);
			
			bHolder = new Sprite();
			bHolder.addChild(bit);
			bit.filters = [bf];
			
			tf = TextField(theText.getChildAt(0));

			tf.height = (tf.textHeight + 2 + 0.5) | 0;
			theText.x = 30;
			
			hBitH = yy - tf.height - 4;
			
			theText.y = hBitH;
			
			wPlus = theW - 40;
			hPlus = tf.height + 10;
			
			spr = new Shape();
			spr.graphics.beginFill(0x000000);
			spr.graphics.drawRect(0, 0, wPlus, hPlus);
			spr.graphics.endFill();
			spr.x = 20;
			spr.y = hBitH - 5;
			spr.scaleX = 0;
			spr.name = "black";
			
			sh = new Shape();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, wPlus, hPlus);
			sh.graphics.endFill();
			sh.x = 20;
			sh.y = hBitH - 5;
			bHolder.mask = sh;
			
			master = new Sprite();
			master.name = "master";
			
			masterMask = new Shape();
			masterMask.name = "masker";
			masterMask.graphics.beginFill(0x000000);
			masterMask.graphics.drawRect(0, 0, wPlus, hPlus);
			masterMask.graphics.endFill();
			masterMask.x = 20;
			masterMask.y = hBitH - 5;
			masterMask.scaleX = 0;
			
			master.addChild(bHolder);
			master.addChild(spr);
			master.addChild(sh);
			master.addChild(theText);
			
			master.mask = masterMask;
			
			master.mouseEnabled = false;
			master.mouseChildren = false;
			
			sp.addChild(master);
			sp.addChild(masterMask);
			
			TweenMax.to(masterMask, 0.5, {scaleX: 1, ease: Quint.easeOut});
			
			return  hBitH - 3 + hPlus;
			
		}
		
		// THERE IS NO NEED FOR GARBAGE COLLECTION FOR THIS CLASS.  
		// THE GC FOR THE OBJECTS CREATED IN THIS CLASS ARE CLEANED BY THE DOCUMENT CLASS
		
    }
}








