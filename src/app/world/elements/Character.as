package app.world.elements
{
	import com.piterwilson.utils.*;
	import app.data.*;
	import app.world.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	public class Character extends Sprite
	{
		// Storage
		public var outfit:MovieClip;
		public var animatePose:Boolean;
		
		private var _itemDataMap:Object;
		
		// Properties
		public function set scale(pVal:Number) : void { outfit.scaleX = outfit.scaleY = pVal; }
		
		// Constructor
		// pData = { x:Number, y:Number, [various "__Data"s], ?params:URLVariables }
		public function Character(pData:Object)
		{
			super();
			animatePose = true;
			
			this.x = pData.x;
			this.y = pData.y;
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, function () { startDrag(); });
			this.addEventListener(MouseEvent.MOUSE_UP, function () { stopDrag(); });
			
			/****************************
			* Store Data
			*****************************/
			_itemDataMap = {};
			_itemDataMap[ITEM.SKIN] = pData.skin;
			_itemDataMap[ITEM.HAIR] = pData.hair;
			_itemDataMap[ITEM.OBJECT] = pData.object;
			_itemDataMap[ITEM.POSE] = pData.pose;
			
			if(pData.params) parseParams(pData.params);
			
			updatePose();
		}
		
		public function updatePose() {
			var tScale = 3;
			if(outfit != null) { tScale = outfit.scaleX; removeChild(outfit); }
			outfit = addChild(new Pose(getItemData(ITEM.POSE))) as Pose;
			outfit.scaleX = outfit.scaleY = tScale;
			// Don't let the pose eat mouse input
			outfit.mouseChildren = false;
			outfit.mouseEnabled = false;
			
			outfit.apply({
				items:[
					getItemData(ITEM.SKIN),
					getItemData(ITEM.HAIR),
					getItemData(ITEM.OBJECT)
				]
			});
			if(animatePose) outfit.play(); else outfit.stopAtLastFrame();
		}
		
		public function parseParams(pParams:URLVariables) : void {
			trace(pParams.toString());
			_setParamToType(pParams, ITEM.SKIN, "s", false);
			_setParamToType(pParams, ITEM.HAIR, "d");
			_setParamToType(pParams, ITEM.OBJECT, "o");
			_setParamToType(pParams, ITEM.POSE, "p", false);
		}
		private function _setParamToType(pParams:URLVariables, pType:String, pParam:String, pAllowNull:Boolean=true) {
			var tData:ItemData = null;
			if(pParams[pParam] != null) {
				if(pParams[pParam] == '') {
					tData = null;
				} else {
					tData = Costumes.instance.getItemFromTypeID(pType, pParams[pParam]);
				}
			}
			_itemDataMap[pType] = pAllowNull ? tData : ( tData == null ? _itemDataMap[pType] : tData );
		}
		
		public function getParams() : URLVariables {
			var tParms = new URLVariables();
			
			var tData:ItemData;
			tParms.s = (tData = getItemData(ITEM.SKIN)) ? tData.id : '';
			tParms.d = (tData = getItemData(ITEM.HAIR)) ? tData.id : '';
			tParms.o = (tData = getItemData(ITEM.OBJECT)) ? tData.id : '';
			tParms.p = (tData = getItemData(ITEM.POSE)) ? tData.id : '';
			
			return tParms;
		}

		/****************************
		* Update Data
		*****************************/
		public function getItemData(pType:String) : ItemData {
			return _itemDataMap[pType];
		}
		
		public function setItemData(pItem:ItemData) : void {
			_itemDataMap[pItem.type] = pItem;
			updatePose();
		}
		
		public function removeItem(pType:String) : void {
			_itemDataMap[pType] = null;
			updatePose();
		}
	}
}
