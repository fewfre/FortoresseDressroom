package
{
	import flash.display.*;
	import flash.display.MovieClip;
    import flash.geom.*;
	
	public class ShopItemData
	{
		public var id:int;
		public var type:String;
		public var itemClass:Class;
		public var itemClass2:Class; // Needed for the "back" of hair one.
		
		public function ShopItemData(pID:int, pType:String, pClass:Class) {
			super();
			id = pID;
			type = pType;
			itemClass = pClass;
		}
	}
}