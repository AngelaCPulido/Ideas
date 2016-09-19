package cj.qcreative.banner.utils {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
    public final class CheckContain {
		
		public static function simpleCheck(holder:Object, obj:Sprite):void {
			(holder.contains(obj)) ? holder.removeChild(obj) : null;
		}
		
		public static function removeLoader(holder:Sprite, loader:Loader):void {
			
			if(loader != null) {
				(holder.contains(loader)) ? holder.removeChild(loader) : null;
				if(loader.content) {
					if(loader.content is Bitmap) {
						BitmapData(Bitmap(loader.content).bitmapData).dispose();
					}
					loader.unload();
				}
			}
		}
		
		public static function check(con:Array, obj:Shape):void {
			
			for each(var s:Object in con) {
				
				(s.contains(obj)) ? s.removeChild(obj) : null;
				obj.graphics.clear();
				
			}
			
		}
		
		public static function holdCheck(holder:Sprite, one:Boolean):void {
			
			var loader:Loader;
			var i:int = holder.numChildren;
			
			if(one) {

				while(i--) {
					
					if(holder.getChildAt(i) is Loader) {
						loader = Loader(holder.getChildAt(i));
						
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








