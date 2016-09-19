package cj.qcreative.portfolio {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.filters.BlurFilter;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	// this class sets up the section titles
    public final class MyTitle {
		
		// begin private vars
		private static var hBitW:Number,
		hBitH:Number;
		// end private vars
		
		// performance enhancement to avoid expensive Math.ceil call
		private static function ceil(val:Number):Number {
    		return val == int(val) ? val : int(val + 1);
		}
		
		// calculates and stores the position
		internal static function calculate(ww:int, hh:int):void {
			
			hBitW = ww >> 1;
			hBitH = hh >> 1;
			
		}
		
		// sets up the title
		internal static function setUp(i:int, bit:*, sp:Sprite, theText:Sprite, func:Function):Number {
			
			var bf:BlurFilter, 
			bHolder:Sprite, 
			tf:TextField, 
			w:int, 
			wPlus:int, 
			theX:Number, 
			spr:Sprite, 
			sh:Shape, 
			master:Sprite, 
			masterMask:Sprite, 
			yy:Number, 
			yyy:Number, 
			hPlus:int, 
			th:int;
			
			bf = new BlurFilter(27, 27, 3);
			
			bHolder = new Sprite();
			bHolder.addChild(bit);
			bit.filters = [bf];
			
			tf = TextField(theText.getChildAt(0));
			w = ceil(tf.textWidth + 5);
			
			th = tf.textHeight;
			hPlus = th + 18;
			yy = ((hBitH - (th >> 1)) + 0.5) | 0;
			yyy = ((hBitH - (hPlus >> 1)) + 0.5) | 0;
			
			tf.width = w;
			theText.x = ((hBitW - (w >> 1)) + 0.5) | 0;
			theText.y = yy;
			
			wPlus = w + 40;
			
			theX = hBitW - (wPlus >> 1);
			
			spr = new Sprite();
			spr.mouseEnabled = false;
			spr.graphics.beginFill(0x000000);
			spr.graphics.drawRect(0, 0, wPlus, hPlus);
			spr.graphics.endFill();
			spr.x = theX;
			spr.y = yyy;
			spr.scaleX = 0;
			spr.name = "black";
			
			sh = new Shape();
			sh.graphics.beginFill(0x000000);
			sh.graphics.drawRect(0, 0, wPlus, hPlus);
			sh.graphics.endFill();
			sh.x = theX;
			sh.y = yyy;
			bHolder.mask = sh;
			
			master = new Sprite();
			master.mouseEnabled = false;
			master.name = "master";
			
			masterMask = new Sprite();
			masterMask.mouseEnabled = false;
			masterMask.name = "masker";
			masterMask.graphics.beginFill(0x000000);
			masterMask.graphics.drawRect(0, 0, wPlus, hPlus);
			masterMask.graphics.endFill();
			masterMask.x = theX;
			masterMask.y = yyy;
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
			
			TweenMax.to(masterMask, 0.5, {scaleX: 1, ease: Quint.easeOut, onCompleteParams: [i], onComplete: func});
			
			return theX;
			
		}
		
		// THIS CLASS DOES NOT PERFORM GARBAGE COLLECTION FOR INSTANCES IT CREATES
		// INSTEAD ALL OBJECTS ARE GC'D FROM THE DOCUMENT CLASS
		
    }
}








