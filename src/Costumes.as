package
{
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.geom.*;
	import mx.utils.StringUtil;
	
	public class Costumes
	{
		private const _MAX_COSTUMES_TO_CHECK_TO:Number = 250;
		
		public var loadedData:Array;
		
		public var guns:Array;
		public var hair:Array;
		
		public var skins:Array;
		public var poses:Array;
		
		public var defaultSkinIndex:int;
		public var defaultPoseIndex:int;
		
		public function Costumes(pMCs:Array) {
			super();
			loadedData = pMCs;
		}
		
		public function init() : Costumes {
			this.guns = _setupCostumeArray("Arme_", "gun");
			this.hair = _setupCostumeArray("E_", SHOP_ITEM_TYPE.HAIR);
			this.hair.unshift( new ShopItemData(-1, SHOP_ITEM_TYPE.HAIR, MovieClip) );
			
			this.skins = new Array();
			
			for(var i = 0; i < _MAX_COSTUMES_TO_CHECK_TO; i++) {
				if(getLoadedClass( "M_"+i+"_BS" ) != null) {
					this.skins.push( new SkinData( i, GENDER.FEMALE ) );
				}
				if(getLoadedClass( "M_"+i+"_BS2" ) != null) {
					this.skins.push( new SkinData( i, GENDER.MALE ) );
				}
			}
			this.defaultSkinIndex = getIndexFromArrayWithID(this.skins, ConstantsApp.DEFAULT_SKIN_ID);
			
			this.poses = _setupCostumeArray("Anim_", ShopItemData.POSE);
			this.defaultPoseIndex = getIndexFromArrayWithID(this.poses, ConstantsApp.DEFAULT_POSE_ID);
			
			return this;
		}
		
		public function getLoadedClass(pName:String, pTrace:Boolean=false) : Class {
			for(var i = 0; i < loadedData.length; i++) {
				if(loadedData[i].loaderInfo.applicationDomain.hasDefinition(pName)) {
					return loadedData[i].loaderInfo.applicationDomain.getDefinition( pName ) as Class;
				}
			}
			if(pTrace) { trace("ERROR: No Linkage by name: "+pName); }
			return null;
		}
		
		private function _setupCostumeArray(pBase:String, pType:String) : Array {
			var tArray:Array = new Array();
			var tClass:Class;
			for(var i = 1; i <= _MAX_COSTUMES_TO_CHECK_TO; i++) {
				tClass = getLoadedClass( pBase+i );
				if(tClass != null) {
					// Do some check for special scenarios.
					if(pType == "gun") { pType = _getGunTypeFromID(i); }
					if(pType == SHOP_ITEM_TYPE.HAIR && i == 1) { continue; }
					
					tArray.push( new ShopItemData(i, pType, tClass) );
					if(pType == SHOP_ITEM_TYPE.HAIR && i == 2) { tArray[tArray.length-1].itemClass2 = getLoadedClass( pBase+1 ); }
				}
			}
			return tArray;
		}
		
		private function _getGunTypeFromID(pID:int) : String {
			return [2, 8, 9, 12].indexOf(pID) > -1 ? SHOP_ITEM_TYPE.SECONDARY_WEAPON : SHOP_ITEM_TYPE.PRIMARY_WEAPON;
		}
		
		public function getArrayByType(pType:String) : Array {
			switch(pType) {
				case SHOP_ITEM_TYPE.SKIN:				return skins;
				case SHOP_ITEM_TYPE.PRIMARY_WEAPON:		
				case SHOP_ITEM_TYPE.SECONDARY_WEAPON:	return guns;
				case SHOP_ITEM_TYPE.HAIR:				return hair;
				case SHOP_ITEM_TYPE.POSE:				return poses;
				default: trace("[Costumes](getArrayByType) Unknown type: "+pType);
			}
			return null;
		}
		
		public function getItemFromTypeID(pType:String, pID:int) : ShopItemData {
			var tArray:Array = getArrayByType(pType);
			if(pType == SHOP_ITEM_TYPE.HAIR && pID == 1) {
				pID = 2;
			}
			return tArray[getIndexFromArrayWithID(tArray, pID)];
		}
		
		public function getIndexFromArrayWithID(pArray:Array, pID:int) : int {
			for(var i = 0; i < pArray.length; i++) {
				if(pArray[i].id == pID) {
					return i;
				}
			}
			return null;
		}

		/*public function copyColor(copyFromMC:MovieClip, copyToMC:MovieClip) : MovieClip {
			if (copyFromMC == null || copyToMC == null) { return; }
			var tChild1:*=null;
			var tChild2:*=null;
			var i:int = 0;
			while (i < copyFromMC.numChildren) 
			{
				tChild1 = copyFromMC.getChildAt(i);
				tChild2 = copyToMC.getChildAt(i);
				if (tChild1.name.indexOf("Couleur") == 0 && tChild1.name.length > 7) 
				{
					tChild2.transform.colorTransform = tChild1.transform.colorTransform;
				}
				++i;
			}
			return copyToMC;
		}

		public function colorDefault(pMC:MovieClip) : MovieClip {
			var tChild:*=null;
			var tChildName:*=null;
			var tHex:int=0;
			var tR:*=0;
			var tG:*=0;
			var tB:*=0;
			if (pMC == null) 
			{
				return;
			}
			var loc1:*=0;
			while (loc1 < pMC.numChildren) 
			{
				tChild = pMC.getChildAt(loc1);
				if (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7) 
				{
					tChildName = tChild.name;
					tHex = int("0x" + tChildName.substr(tChildName.indexOf("_") + 1, 6));
					tR = tHex >> 16 & 255;
					tG = tHex >> 8 & 255;
					tB = tHex & 255;
					tChild.transform.colorTransform = new flash.geom.ColorTransform(tR / 128, tG / 128, tB / 128);;
				}
				++loc1;
			}
			return pMC;
		}
		
		public function getNumOfCustomColors(pMC:MovieClip) : int {
			var tChild:*=null;
			var num:int = 0;
			var i:int = 0;
			while (i < pMC.numChildren) 
			{
				tChild = pMC.getChildAt(i);
				if (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7) 
				{
					num++;
				}
				++i;
			}
			return num;
		}*/
	}
}