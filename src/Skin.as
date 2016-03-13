package 
{
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.geom.*;
	
	public class Skin extends MovieClip
	{
		// Storage
		internal var data		: SkinData;
		
		public var hairLayer	: MovieClip;
		public var hairLayerBack: MovieClip;
		
		public var head			: MovieClip;
		public var body			: MovieClip;
		public var upperArm1	: MovieClip;
		public var upperArm2	: MovieClip;
		public var lowerArm1	: MovieClip;
		public var lowerArm2	: MovieClip;
		public var hand1		: MovieClip;
		public var hand2		: MovieClip;
		public var upperLeg1	: MovieClip;
		public var upperLeg2	: MovieClip;
		public var lowerLeg1	: MovieClip;
		public var lowerLeg2	: MovieClip;
		public var foot1		: MovieClip;
		public var foot2		: MovieClip;
		
		// Constructor
		public function Skin(pData:SkinData) {
			super();
			
			data = pData;
			
			_setup_base();
		}
		
		private function _setup_base() : void {
			var fade = 0.5;
			
			// Z-index: 0
			foot2 = addChild( _newPart(data.foot2, -7, 38) );
			lowerArm2 = addChild( _newPart(data.lowerArm, -7, 8) ); lowerArm2.rotation = 15;
			lowerArm2.transform.colorTransform = new ColorTransform(fade, fade, fade, 1.0, 0, 0, 0, 0);
			
			// Z-index: 1
			upperArm2 = addChild( _newPart(data.upperArm, -5, 1) ); upperArm2.rotation = 45;
			upperArm2.transform.colorTransform = new ColorTransform(fade, fade, fade, 1.0, 0, 0, 0, 0);
			hand2 = addChild( _newPart(data.hand3, -10, 15) );
			lowerLeg2 = addChild( _newPart(data.lowerLeg2, -7, 27) );
			
			// Z-index: 2
			upperLeg2 = addChild( _newPart(data.upperLeg2, -6, 15) );
			
			// Z-index: 3
			body = addChild( _newPart(data.body, 0, 0) );
			lowerLeg1 = addChild( _newPart(data.lowerLeg1, 3, 28) );
			
			// Z-index: 4
			hairLayerBack = addChild( _newPart(data.hair.itemClass2 ? data.hair.itemClass2 : MovieClip, 0, -2) );
			head = addChild( _newPart(data.head, 0, -2) );
			upperArm1 = addChild( _newPart(data.upperArm, 6, 2) ); upperArm1.rotation = -15;
			upperLeg1 = addChild( _newPart(data.upperLeg1, 1, 10) );
			foot1 = addChild( _newPart(data.foot1, 5, 40) );
			
			// Z-index: 5
			hand1 = addChild( _newPart(data.hand3, 4, 13) );
			hairLayer = addChild( _newPart(data.hair.itemClass, 0, -2) );
			
			// Z-index: 6
			lowerArm1 = addChild( _newPart(data.lowerArm, 12, 9) ); lowerArm1.rotation = 40;
		}
		
		private function _newPart(pClass:Class, pX:Number, pY:Number) : MovieClip {
			if(pClass == null) {
				trace("[Skin](_newPart) pClass is null");
				return new MovieClip();
			}
			var tMC:MovieClip = new pClass();
			tMC.x = pX;
			tMC.y = pY;
			return tMC;
		}
	}
}
