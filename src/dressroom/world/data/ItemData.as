package dressroom.world.data
{
	import flash.display.*;
	import flash.geom.*;
	
	public class ItemData
	{
		public var id			: String;
		public var type			: String;
		public var gender		: String;
		public var itemClass	: Class;
		public var classMap		: Object;
		
		// pData = { id:String, type:String, itemClass:Class, ?gender:String, ?classMap:Object<Class> }
		public function ItemData(pData:Object) {
			super();
			id = pData.id;
			type = pData.type;
			gender = pData.gender;
			itemClass = pData.itemClass;
			classMap = pData.classMap;
		}
		
		public function getPart(pID:String) : Class {
			return !classMap ? null : (classMap[pID] ? classMap[pID] : null);
		}
	}
}