package 
{
	import flash.display.*;
	import flash.geom.*;
	
	public class SkinData extends ShopItemData
	{
		// Storage
		public var gender:String;
		public var isZombie:Boolean;
		
		public var hair			: ShopItemData; // E_#
		public var head			: Class; // E_tf# / E_th# (female / male) (# is number [blank for "1"], "n" for black, or z# for zombie)
		
		public var body			: Class; // M_#_C / M_#_C2 (female / male)
		
		public var upperArm		: Class; // M_#_BS / M_#_BS2 (female / male)
		public var lowerArm		: Class; // M_#_BI
		
		public var hand1		: Class; // M_#_M1
		public var hand2		: Class; // M_#_M2
		public var hand3		: Class; // M_#_M3
		public var hand4		: Class; // M_#_M4
		
		public var upperLeg1	: Class; // M_#_JS1
		public var upperLeg2	: Class; // M_#_JS2
		public var lowerLeg1	: Class; // M_#_JI1
		public var lowerLeg2	: Class; // M_#_JI2
		public var foot1		: Class; // M_#_P1
		public var foot2		: Class; // M_#_P2
		
		// Constructor
		public function SkinData(pID:int, pGender:String) {
			super(pID, SHOP_ITEM_TYPE.SKIN, null);
			
			gender = pGender;
			isZombie = (id <= 15 && id >= 11) || id == 7;
			if(isZombie) { gender = (id <= 15 && id >= 13) ? GENDER.MALE : GENDER.FEMALE; }
			
			_initSkin();
		}
		
		private function _initSkin() : void {
			_getDefaultHairFromID();
			
			head		= Main.costumes.getLoadedClass( _getHeadFromID() );
			
			body		= Main.costumes.getLoadedClass( "M_"+id+"_C"+(gender == GENDER.FEMALE || isZombie ? "" : "2") );
			
			upperArm	= Main.costumes.getLoadedClass( "M_"+id+"_BS"+(gender == GENDER.FEMALE || isZombie ? "" : "2") );
			lowerArm	= Main.costumes.getLoadedClass( "M_"+id+"_BI" );
			
			hand1		= Main.costumes.getLoadedClass( "M_"+id+"_M1" );
			hand2		= Main.costumes.getLoadedClass( "M_"+id+"_M2" );
			hand3		= Main.costumes.getLoadedClass( "M_"+id+"_M3" );
			hand4		= Main.costumes.getLoadedClass( "M_"+id+"_M4" );
			
			upperLeg1	= Main.costumes.getLoadedClass( "M_"+id+"_JS1" );
			upperLeg2	= Main.costumes.getLoadedClass( "M_"+id+"_JS2" );
			lowerLeg1	= Main.costumes.getLoadedClass( "M_"+id+"_JI1" );
			lowerLeg2	= Main.costumes.getLoadedClass( "M_"+id+"_JI2" );
			foot1		= Main.costumes.getLoadedClass( "M_"+id+"_P1" );
			foot2		= Main.costumes.getLoadedClass( "M_"+id+"_P2" );
		}
		
		private function _getHeadFromID() : String {
			// "n" on the end represents a black skin
			// "z" on the end represents a zombie
			// Female: E_tf / E_tfn
			// Male: E_th / E_th2 / E_th3 / E_th4 / E_th5 (unused?) / E_th6 / E_thn
			switch(id) {
				case 0: return gender == GENDER.MALE ? "E_th" : "E_tf";
				case 1: return gender == GENDER.MALE ? "E_th" : "E_tf";
				case 2: return gender == GENDER.MALE ? "E_th" : "E_tf";
				case 3: return gender == GENDER.MALE ? "E_th" : "E_tf";
				case 4: return gender == GENDER.MALE ? "E_th" : "E_tf";
				case 5: return "E_tf";
				case 6: return "E_th";
				case 7: return "E_tfz1";
				case 8: return "E_tf";
				case 9: return "E_tf";
				case 10: return "E_tf";
				case 11: return "E_tfz2";
				case 12: return "E_tfz3";
				case 13: return "E_tfz4";
				case 14: return "E_tfz5";
				case 15: return "E_tfz6";
				case 16: return "E_tf";
				case 17: return "E_tf";
				case 18: return "E_tfn";
				case 19: return "E_thn";
				case 20: return "E_th3";
				case 21: return "E_th4";
				case 22: return "E_th6";
				case 23: return "E_th";
				case 24: return "E_th2";
			}
			return "E_th";
		}
		
		private function _getDefaultHairFromID() : void {
			var tHairID:int = -1;
			switch(id) {
				case 0:	tHairID = gender == GENDER.MALE ? 3 : 1; break;
				case 1:	tHairID = gender == GENDER.MALE ? 3 : 5; break;
				case 2:	tHairID = gender == GENDER.MALE ? 4 : 8; break;
				case 3:	tHairID = gender == GENDER.MALE ? 4 : 1; break;
				case 4:	tHairID = gender == GENDER.MALE ? 3 : 7; break;
				case 5:	tHairID = 1; break;
				case 6:	tHairID = 4; break;
				case 7:	tHairID = -1; break; // Zombie
				case 8:	tHairID = 13; break;
				case 9:	tHairID = 14; break;
				case 10:tHairID = 15; break;
				case 11:tHairID = -1; break; // Zombie
				case 12:tHairID = -1; break; // Zombie
				case 13:tHairID = -1; break; // Zombie
				case 14:tHairID = -1; break; // Zombie
				case 15:tHairID = -1; break; // Zombie
				case 16:tHairID = 16; break;
				case 17:tHairID = 17; break;
				case 18:tHairID = 18; break;
				case 19:tHairID = 19; break;
				case 20:tHairID = 20; break;
				case 21:tHairID = 21; break;
				case 22:tHairID = 22; break;
				case 23:tHairID = 23; break;
				case 24:tHairID = 24; break;
			}
			hair = Main.costumes.getItemFromTypeID(SHOP_ITEM_TYPE.HAIR, tHairID);
		}
		
		public function getPartClassFromType(pType:String) : Class {
			switch(pType) {
				case "T":	return head;
				case "CH":	return MovieClip;
				case "C":	return body;
				case "BS":	return upperArm;
				case "BI":	return lowerArm;
				case "M1":	return hand1;
				case "M2":	return hand2;
				case "M3":	return hand3;
				case "M4":	return hand4;
				case "JS1":	return upperLeg1;
				case "JS2":	return upperLeg2;
				case "JI1":	return lowerLeg1;
				case "JI2":	return lowerLeg2;
				case "P1":	return foot1;
				case "P2":	return foot2;
				default: {
					trace("[SkinData](getPartFromType) Unknown skin part: "+pType);
					return MovieClip;
				}
			}
		}
	}
}
