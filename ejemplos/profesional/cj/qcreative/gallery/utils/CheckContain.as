package cj.qcreative.gallery.utils {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	// this class checks to see if a display object contains a particlur child
    public final class CheckContain {
		
		// if the object contains the child
		public static function simpleCheck(holder:Object, obj:Sprite):void {
			(holder.contains(obj)) ? holder.removeChild(obj) : null;
		}
		
		// removes and cleans up a Loader
		public static function removeLoader(holder:Sprite, loader:DisplayObject):void {
			
			if(loader != null) {
				(holder.contains(loader)) ? holder.removeChild(loader) : null;
				if(Loader(loader).content) {
					if(Loader(loader).content is Bitmap) {
						BitmapData(Bitmap(Loader(loader).content).bitmapData).dispose();
					}
					Loader(loader).unload();
				}
			}
		}
		
		// removes and cleans up a Bitmap
		public static function removeSnapshot(holder:Sprite, loader:DisplayObject):void {
			
			if(loader != null) {
				(holder.contains(loader)) ? holder.removeChild(loader) : null;
				BitmapData(Bitmap(loader).bitmapData).dispose();
			}
			
		}
		
		// cleans up an Array
		public static function check(con:Array, obj:Shape):void {
			
			for each(var s:Object in con) {
				
				(s.contains(obj)) ? s.removeChild(obj) : null;
				obj.graphics.clear();
				
			}
			
		}
		
		// thorough clean of a container
		public static function holdCheck(holder:Sprite, one:Boolean):void {
			
			var loader:Loader;
			var i:int = holder.numChildren;
			
			if(one) {

				while(i--) {
					
					if(holder.getChildAt(i) is Loader) {
						loader = Loader(holder.getChildAt(i));
						i = 0;
						break;
					}
					
				}
				
				if(loader != null) {
					(holder.contains(loader)) ? holder.removeChild(loader) : null;
					if(loader.content != null) {
						if(loader.content is Bitmap) {
							BitmapData(Bitmap(loader.content).bitmapData).dispose();
						}
						loader.unload();
					}
				}
				
			}
			else {
				
				while(i--) {
					
					if(holder.getChildAt(i) is Loader) {
						loader = Loader(holder.getChildAt(i));
						i = 0;
						break;
					}
					
				}
				
				if(loader != null) {
					(holder.contains(loader)) ? holder.removeChild(loader) : null;
					if(loader.content != null) {
						if(loader.content is Bitmap) {
							BitmapData(Bitmap(loader.content).bitmapData).dispose();
						}
						loader.unload();
					}
				}
			}
			
			
		}
    }
}








