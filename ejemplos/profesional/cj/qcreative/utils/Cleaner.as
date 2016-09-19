package cj.qcreative.utils {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import com.greensock.TweenMax;
	
	// this class acts as a recursive cleaner and is used when advanced cleanup is necessary
    public final class Cleaner {
		
		// passes every child through the clean function
		private static function removeIt(obj:Object):void {
			
			if(obj is DisplayObjectContainer) {
				
				while(obj.numChildren) {
					
					var it:Object = obj.getChildAt(0);
					obj.removeChild(it);
					clean(it);
					
				}
			}
		}
		
		// finds what the object is and performs specific cleanup
		public static function clean(obj:Object):void {
			
			switch(obj) {
				
				// if the object is a Sprite
				case Sprite:
					
					if(TweenMax.isTweening(obj)) {
						TweenMax.killTweensOf(obj);
					}
					removeIt(obj);
				
				break;
				
				// if the object is a MovieClip
				case MovieClip:
				
					if(TweenMax.isTweening(obj)) {
						TweenMax.killTweensOf(obj);
					}
					obj.stop();
					removeIt(obj);
				
				break;
				
				// if the object is a Bitmap
				case Bitmap:
					
					if(TweenMax.isTweening(obj)) {
						TweenMax.killTweensOf(obj);
					}
					obj.bitmapData.dispose();
					removeIt(obj);
				
				break;
				
				// if the object is a Loader
				case Loader:
					
					if(TweenMax.isTweening(obj)) {
						TweenMax.killTweensOf(obj);
					}
				
					if(obj.content) {
						if(obj.content is Bitmap) {
							BitmapData(Bitmap(obj.content).bitmapData).dispose();
						}
						obj.unload();
					}
					
					try {
						obj.close();
					}
					catch(event:*) {};
				
				break;
				
				// if the object is a Shape
				case Shape:
					
					if(TweenMax.isTweening(obj)) {
						TweenMax.killTweensOf(obj);
					}
					obj.graphics.clear();
						
				
				break;
				
				// if the object is a TextField
				case TextField:
					
					if(TweenMax.isTweening(obj)) {
						TweenMax.killTweensOf(obj);
					}
				
				break;
				
			}
		}
    }
}








