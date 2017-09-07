package app.data
{
	import com.adobe.images.*;
	import com.fewfre.utils.*;
	import app.data.*;
	import app.world.data.*;
	import app.world.elements.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.net.*;
	
	public class Costumes
	{
		private static var _instance:Costumes;
		public static function get instance() : Costumes {
			if(!_instance) { new Costumes(); }
			return _instance;
		}
		
		private const _MAX_COSTUMES_TO_CHECK_TO:Number = 250;
		
		public var hair:Array;
		public var objects:Array;
		
		public var skins:Array;
		public var poses:Array;
		
		public var defaultSkinIndex:int;
		public var defaultPoseIndex:int;
		
		public function Costumes() {
			if(_instance){ throw new Error("Singleton class; Call using Costumes.instance"); }
			_instance = this;
			
			var i:int;
			var tSkinParts = [ "B", "JI1", "JI2", "JS1", "JS2", "P1", "P2", "M1", "M2", "BI1", "BI2", "BS1", "BS2", "TS", "T", "CH" ];
			
			this.hair = _setupCostumeArray({ base:"E_", type:ITEM.HAIR });
			for(i = 0; i < hair.length; i++) { hair[i].classMap = { T:hair[i].itemClass }; }
			this.hair[0].classMap.CH = this.hair[0].itemClass;
			this.hair[0].classMap.T = this.hair[1].itemClass;
			this.hair.splice(1, 1).itemClass;
			
			this.objects = _setupCostumeArray({ base:"Arme_", type:ITEM.OBJECT, itemClassToClassMap:"O" });
			
			this.skins = new Array();
			for(i = 0; i < _MAX_COSTUMES_TO_CHECK_TO; i++) {
				if(Fewf.assets.getLoadedClass( "M_"+i+"_BS" ) != null) {
					this.skins.push( new SkinData( i, SEX.FEMALE ) );
				}
				if(Fewf.assets.getLoadedClass( "M_"+i+"_BS2" ) != null) {
					this.skins.push( new SkinData( i, SEX.MALE ) );
				}
			}
			this.defaultSkinIndex = FewfUtils.getFromArrayWithKeyVal(this.skins, "id", ConstantsApp.DEFAULT_SKIN_ID);
			
			this.poses = _setupCostumeArray({ base:"Anim_", type:ITEM.POSE });
			this.defaultPoseIndex = FewfUtils.getFromArrayWithKeyVal(this.poses, "id", ConstantsApp.DEFAULT_POSE_ID);
		}
		
		// pData = { base:String, type:String, after:String, pad:int, map:Array, sex:Boolean, itemClassToClassMap:String OR Array }
		private function _setupCostumeArray(pData:Object) : Array {
			var tArray:Array = new Array();
			var tClassName:String;
			var tClass:Class;
			var tSexSpecificParts:int;
			for(var i = 0; i <= _MAX_COSTUMES_TO_CHECK_TO; i++) {
				if(pData.map) {
					for(var g:int = 0; g < (pData.sex ? 2 : 1); g++) {
						var tClassMap = {  }, tClassSuccess = null;
						tSexSpecificParts = 0;
						for(var j = 0; j <= pData.map.length; j++) {
							tClass = Fewf.assets.getLoadedClass( tClassName = pData.base+(pData.pad ? zeroPad(i, pData.pad) : i)+(pData.after ? pData.after : "")+pData.map[j] );
							if(tClass) { tClassMap[pData.map[j]] = tClass; tClassSuccess = tClass; }
							else if(pData.sex){
								tClass = Fewf.assets.getLoadedClass( tClassName+"_"+(g==0?1:2) );
								if(tClass) { tClassMap[pData.map[j]] = tClass; tClassSuccess = tClass; tSexSpecificParts++ }
							}
						}
						if(tClassSuccess) {
							var tIsSexSpecific = pData.sex && tSexSpecificParts > 0;
							tArray.push( new ItemData({ id:i+(tIsSexSpecific ? (g==1 ? "M" : "F") : ""), type:pData.type, classMap:tClassMap, itemClass:tClassSuccess, sex:(tIsSexSpecific ? (g==1?SEX.MALE:SEX.FEMALE) : null) }) );
						}
						if(tSexSpecificParts == 0) {
							break;
						}
					}
				} else {
					tClass = Fewf.assets.getLoadedClass( pData.base+(pData.pad ? zeroPad(i, pData.pad) : i)+(pData.after ? pData.after : "") );
					if(tClass != null) {
						tArray.push( new ItemData({ id:i, type:pData.type, itemClass:tClass}) );
						if(pData.itemClassToClassMap) {
							tArray[tArray.length-1].classMap = {};
							if(pData.itemClassToClassMap is Array) {
								for(var c:int = 0; c < pData.itemClassToClassMap.length; c++) {
									tArray[tArray.length-1].classMap[pData.itemClassToClassMap[c]] = tClass;
								}
							} else {
								tArray[tArray.length-1].classMap[pData.itemClassToClassMap] = tClass;
							}
						}
					}
				}
			}
			return tArray;
		}
		
		public function zeroPad(number:int, width:int):String {
			var ret:String = ""+number;
			while( ret.length < width )
				ret="0" + ret;
			return ret;
		}
		
		public function getArrayByType(pType:String) : Array {
			switch(pType) {
				case ITEM.HAIR:		return hair;
				case ITEM.OBJECT:	return objects;
				
				case ITEM.SKIN:		return skins;
				case ITEM.POSE:		return poses;
				default: trace("[Costumes](getArrayByType) Unknown type: "+pType);
			}
			return null;
		}
		
		public function getItemFromTypeID(pType:String, pID:String) : ItemData {
			return FewfUtils.getFromArrayWithKeyVal(getArrayByType(pType), "id", pID);
		}

		/****************************
		* Color
		*****************************/
		public function copyColor(copyFromMC:MovieClip, copyToMC:MovieClip) : MovieClip {
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
			if (pMC == null) { return; }
			
			var tChild:*=null;
			var tHex:int=0;
			var loc1:*=0;
			while (loc1 < pMC.numChildren)
			{
				tChild = pMC.getChildAt(loc1);
				if (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7)
				{
					tHex = int("0x" + tChild.name.substr(tChild.name.indexOf("_") + 1, 6));
					applyColorToObject(tChild, tHex);
				}
				++loc1;
			}
			return pMC;
		}
		
		// pData = { obj:DisplayObject, color:String OR int, ?swatch:int, ?name:String }
		public function colorItem(pData:Object) : void {
			if (pData.obj == null) { return; }
			
			var tHex:int = pData.color is Number ? pData.color : int("0x" + pData.color);
			
			var tChild:DisplayObject;
			var i:int=0;
			while (i < pData.obj.numChildren) {
				tChild = pData.obj.getChildAt(i);
				if (tChild.name == pData.name || (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7)) {
					if (!pData.swatch || pData.swatch == tChild.name.charAt(7)) {
						applyColorToObject(tChild, tHex);
					}
				}
				i++;
			}
		}
		
		// pColor is an int hex value. ex: 0x000000
		public function applyColorToObject(pItem:DisplayObject, pColor:int) : void {
			var tR:*=pColor >> 16 & 255;
			var tG:*=pColor >> 8 & 255;
			var tB:*=pColor & 255;
			pItem.transform.colorTransform = new flash.geom.ColorTransform(tR / 128, tG / 128, tB / 128);
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
		}
		
		public function getColoredItemImage(pData:ItemData) : MovieClip {
			/*return colorItem({ obj:getItemImage(pData), colors:pData.colors });*/
			return getItemImage(pData); // Colored items not supported
		}
		
		/****************************
		* Asset Creation
		*****************************/
		public function getItemImage(pData:ItemData) : MovieClip {
			var tItem:MovieClip;
			switch(pData.type) {
				case ITEM.SKIN:
					tItem = getDefaultPoseSetup({ skin:pData });
					break;
				case ITEM.POSE:
					tItem = getDefaultPoseSetup({ pose:pData });
					break;
				/*case ITEM.SHIRT:
				case ITEM.PANTS:
				case ITEM.SHOES:
					tItem = new Pose(poses[defaultPoseIndex]).apply({ items:[ pData ], removeBlanks:true });
					break;*/
				default:
					tItem = new pData.itemClass();
					colorDefault(tItem);
					break;
			}
			return tItem;
		}
		
		// pData = { ?pose:ItemData, ?skin:SkinData }
		public function getDefaultPoseSetup(pData:Object) : Pose {
			var tPoseData = pData.pose ? pData.pose : poses[defaultPoseIndex];
			var tSkinData = pData.skin ? pData.skin : skins[defaultSkinIndex];
			
			tPose = new Pose(tPoseData);
			tPose.apply({ items:[
				tSkinData
			] });
			tPose.stopAtLastFrame();
			
			return tPose;
		}
	}
}
