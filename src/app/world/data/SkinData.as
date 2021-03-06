package app.world.data
{
	import com.fewfre.utils.Fewf;
	import app.data.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class SkinData extends ItemData
	{
		// Storage
		public var hair			: ItemData;
		public var isZombie:Boolean;
		
		// Constructor
		public function SkinData(pID:int, pSex:String) {
			super({ id:""+pID, type:ITEM.SKIN, sex:pSex });
			
			var id = pID;
			isZombie = (id <= 15 && id >= 11) || id == 7;
			if(isZombie) { sex = (id <= 15 && id >= 13) ? SEX.MALE : SEX.FEMALE; }
			
			classMap = {};
			var tSex = sex == SEX.FEMALE ? "1" : "2";
			
			// Hair may be replaced, so we don't want it in the classMap.
			_getDefaultHairFromID();
			
			// Head
			classMap.T		= Fewf.assets.getLoadedClass( _getHeadFromID() );
			// Torso / Pelvis
			classMap.C		= Fewf.assets.getLoadedClass( "M_"+id+"_C"+(sex == SEX.FEMALE || isZombie ? "" : "2") );
			
			// Upper Arms
			classMap.BS		= Fewf.assets.getLoadedClass( "M_"+id+"_BS"+(sex == SEX.FEMALE || isZombie ? "" : "2") );
			classMap.BI		= Fewf.assets.getLoadedClass( "M_"+id+"_BI" );
			// Hands
			classMap.M1		= Fewf.assets.getLoadedClass( "M_"+id+"_M1" );
			classMap.M2		= Fewf.assets.getLoadedClass( "M_"+id+"_M2" );
			classMap.M3		= Fewf.assets.getLoadedClass( "M_"+id+"_M3" );
			classMap.M4		= Fewf.assets.getLoadedClass( "M_"+id+"_M4" );
			
			// Upper Legs
			classMap.JS1	= Fewf.assets.getLoadedClass( "M_"+id+"_JS1" );
			classMap.JS2	= Fewf.assets.getLoadedClass( "M_"+id+"_JS2" );
			// Lower Legs
			classMap.JI1	= Fewf.assets.getLoadedClass( "M_"+id+"_JI1" );
			classMap.JI2	= Fewf.assets.getLoadedClass( "M_"+id+"_JI2" );
			// Feet
			classMap.P1		= Fewf.assets.getLoadedClass( "M_"+id+"_P1" );
			classMap.P2		= Fewf.assets.getLoadedClass( "M_"+id+"_P2" );
			
			if(sex) this.id += (sex == SEX.FEMALE ? "F" : "M");
		}
		
		private function _getHeadFromID() : String {
			// "n" on the end represents a black skin
			// "z" on the end represents a zombie
			// Female: E_tf / E_tfn
			// Male: E_th / E_th2 / E_th3 / E_th4 / E_th5 (unused?) / E_th6 / E_thn
			switch(int(id)) {
				case 0: return sex == SEX.MALE ? "E_th" : "E_tf";
				case 1: return sex == SEX.MALE ? "E_th" : "E_tf";
				case 2: return sex == SEX.MALE ? "E_th" : "E_tf";
				case 3: return sex == SEX.MALE ? "E_th" : "E_tf";
				case 4: return sex == SEX.MALE ? "E_th" : "E_tf";
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
			if(isZombie) { hair = null; return; }
			var tHairID:int = -1;
			switch(int(id)) {
				case 0:	tHairID = sex == SEX.MALE ? 3 : 1; break;
				case 1:	tHairID = sex == SEX.MALE ? 3 : 5; break;
				case 2:	tHairID = sex == SEX.MALE ? 4 : 8; break;
				case 3:	tHairID = sex == SEX.MALE ? 4 : 1; break;
				case 4:	tHairID = sex == SEX.MALE ? 3 : 7; break;
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
			hair = Costumes.instance.getItemFromTypeID(ITEM.HAIR, ""+tHairID);
		}
	}
}
