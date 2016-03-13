package 
{
	import com.piterwilson.utils.*;
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.geom.*;
	
	public class Character extends flash.display.Sprite
	{
		// Storage
		public var outfit:MovieClip;
		
		internal var skinData:SkinData;
		internal var weaponData:ShopItemData;
		internal var hairData:ShopItemData;
		
		internal var skin:MovieClip;
		internal var weapon:MovieClip;
		internal var hair:MovieClip;
		
		internal var pose:Class;
		
		internal var scale:Number;
		
		// Constructor
		public function Character(pSkin:SkinData, pWeapon:ShopItemData, pHair:ShopItemData, pPose:ShopItemData)
		//public function Character(hat_item:MovieClip, eye_item:MovieClip, ear_item:MovieClip, mouth_item:MovieClip, neck_item:MovieClip, hair_item:MovieClip, tail_item:MovieClip, paw_item:MovieClip, back_item:MovieClip, backPaw_item:MovieClip, hide_hat:Boolean=true, hide_eye:Boolean=true, hide_ear:Boolean=true, hide_mouth:Boolean=true, hide_neck:Boolean=true)
		{
			super();
			
			this.skinData = pSkin;
			
			this.weaponData = pWeapon;
			this.hairData = pHair;
			
			this.pose = pPose.itemClass;
			
			updatePose(this.pose);
		}
		
		public function updatePose(pPose:Class=null) {
			if(pPose) { this.pose = pPose; }
			var tScale = 3;
			if(outfit != null) { tScale = outfit.scaleX; removeChild(outfit); }
			outfit = addChild(new pose());
			outfit.scaleX = outfit.scaleY = tScale;
			
			var tHairData = hairData ? hairData : skinData.hair;
			
			var part:MovieClip = null;
			var tChild:* = null;
			var tChildType:String = null;
			
			var i:Number = 0;
			while (i < outfit.numChildren) {
				tChild = outfit.getChildAt(i);
				tChildType = tChild.name;
				//if (part != null){
					/*switch (tChildType){
						case "O": if(weaponData) { part = new weaponData.itemClass(); } break;
						case "TH": if(hairData) { part = new hairData.itemClass(); break; } // else check for default skin hair
						default: part = new (skinData.getPartClassFromType(tChildType))(); break;
					}*/
					//if (part == null) { trace("[Character](setPose) No part: "+tChildType); part = new MovieClip(); }
					//part.transform.matrix = tChild.transform.matrix;
					//part.x = tChild.x;
					//part.y = tChild.y;
					part = tChild;
					switch (tChildType){
						case "O": if(weaponData) { this.weapon = part.addChild(new weaponData.itemClass()); } break;
						case "CH": if(tHairData.itemClass2) { part.addChild(new tHairData.itemClass2()); } break;
						case "T": {
							part.addChild(new (skinData.getPartClassFromType(tChildType))());
							part.addChild(new tHairData.itemClass());
							break;
						} // else check for default skin hair
						default: part.addChild(new (skinData.getPartClassFromType(tChildType))()); break;
					}
					//outfit.removeChildAt(i);
					//outfit.addChildAt(part, i);
				//}
				part = null;
				i++;
			}
		}

		/*
			public function colorDefault(pType:String) : void {
				var tItem:MovieClip = this.getItem(pType);
				if (tItem == null) { return; }
				
				var tChild:DisplayObject;
				var tHex:int=0;
				var tR:*=0;
				var tG:*=0;
				var tB:*=0;
				
				var i:int = 0;
				while (i < tItem.numChildren) {
					tChild = tItem.getChildAt(i)
					if (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7) 
					{
						tHex = int("0x" + tChild.name.substr(tChild.name.indexOf("_") + 1, 6));
						tR = tHex >> 16 & 255;
						tG = tHex >> 8 & 255;
						tB = tHex & 255;
						tChild.transform.colorTransform = new flash.geom.ColorTransform(tR / 128, tG / 128, tB / 128);
					}
					i++;
				}
				return;
			}

			public function getColors(pType:String) : Array {
				var tItem:MovieClip = this.getItem(pType);
				if (tItem == null) { return new Array(); }
				
				var tChild:DisplayObject;
				var tTransform:*=null;
				var tArray:*=new Array();
				
				var i:int=0;
				while (i < tItem.numChildren) {
					tChild = tItem.getChildAt(i);
					if (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7) {
						tTransform = tChild.transform.colorTransform;
						tArray[tChild.name.charAt(7)] = com.piterwilson.utils.ColorMathUtil.RGBToHex(tTransform.redMultiplier * 128, tTransform.greenMultiplier * 128, tTransform.blueMultiplier * 128);
					}
					i++;
				}
				return tArray;
			}

			public function colorItem(pType:String, arg2:int, pColor:String) : void {
				var tItem:MovieClip = this.getItem(pType);
				if (tItem == null) { return; }
				
				var tChild:DisplayObject;
				var tHex:int=0;
				var tR:*=0;
				var tG:*=0;
				var tB:*=0;
				
				var i:int=0;
				while (i < tItem.numChildren) {
					tChild = tItem.getChildAt(i);
					if (tChild.name.indexOf("Couleur") == 0 && tChild.name.length > 7) {
						if (arg2 == tChild.name.charAt(7)) {
							tHex = int("0x" + pColor);
							tR = tHex >> 16 & 255;
							tG = tHex >> 8 & 255;
							tB = tHex & 255;
							tChild.transform.colorTransform = new flash.geom.ColorTransform(tR / 128, tG / 128, tB / 128);
						}
					}
					i++;
				}
			}
		*/

		public function setHair(pData:ShopItemData, pRemove:Boolean=true) : void {
			this.hairData = pData;
			//if(pRemove) { this.outfit.removeChild(this.hair); }
			//_insertAbove(this.hair = pMC, null);
			updatePose();
		}

		public function setWeapon(pData:ShopItemData, pRemove:Boolean=true) : void {
			this.weaponData = pData;
			//if(pRemove) { this.outfit.removeChild(this.weapon); }
			//_insertAbove(this.weapon = pMC, null);
			updatePose();
		}

		public function setSkin(pData:ShopItemData, pRemove:Boolean=true) : void {
			this.skinData = pData;
			//if(pRemove) { this.outfit.removeChild(this.weapon); }
			//_insertAbove(this.weapon = pMC, null);
			updatePose();
		}

		public function getItem(pType:String):MovieClip
		{
			switch(pType) {
				case SHOP_ITEM_TYPE.HAIR				: return this.hair; break;
				case SHOP_ITEM_TYPE.PRIMARY_WEAPON		:
				case SHOP_ITEM_TYPE.SECONDARY_WEAPON	: return this.weapon; break;
				case SHOP_ITEM_TYPE.SKIN				: return this.skin; break;
				default: trace("[Character](getItem) Unknown Type: "+pType); break;
			}
		}
		
		public function addItem(pType:String, pItem:ShopItemData) : void {
			switch(pType) {
				case SHOP_ITEM_TYPE.HAIR				: setHair(pItem); break;
				case SHOP_ITEM_TYPE.PRIMARY_WEAPON		:
				case SHOP_ITEM_TYPE.SECONDARY_WEAPON	: setWeapon(pItem); break;
				case SHOP_ITEM_TYPE.SKIN				: setSkin(pItem); break;
				default: trace("[Character](addItem) Unknown Type: "+pType); break;
			}
		}
		
		public function removeItem(pType:String) : void {
			switch(pType) {
				case SHOP_ITEM_TYPE.HAIR				: this.hairData = null; break;//this.hair.alpha = 0; break;
				case SHOP_ITEM_TYPE.PRIMARY_WEAPON		:
				case SHOP_ITEM_TYPE.SECONDARY_WEAPON	: this.weaponData = null; break;//this.weapon.alpha = 0; break;
				case SHOP_ITEM_TYPE.SKIN				: this.skinData = null; break;//this.skin.alpha = 0; break;
				default: trace("[Character](removeItem) Unknown Type: "+pType); break;
			}
			updatePose();
		}
	}
}
