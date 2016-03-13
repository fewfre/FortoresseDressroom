package GUI 
{
	import flash.display.*;
	import flash.display.Shape;
	import flash.events.*;
	
	public class ShopTabContainer extends RoundedRectangle
	{
		// Storage
		public var DefaultX:Number;
		public var DefaultY:Number;

		var skinTab		: GUI.PushButton;
		var hairTab		: GUI.PushButton;
		var gunsTab		: GUI.PushButton;
		var posesTab	: GUI.PushButton;
		
		// Constants
		public static const TAB_SKIN_CLICK:String="tab1_click";
		public static const TAB_HAIR_CLICK:String="tab2_click";
		public static const TAB_GUNS_CLICK:String="tab3_click";
		public static const TAB_POSES_CLICK:String="tab4_click";
		
		// Constructor
		public function ShopTabContainer(pX:Number, pY:Number, pWidth:Number, pHeight:Number)
		{
			super(pX, pY, pWidth, pHeight);
			this.DefaultX = pX;
			this.DefaultY = pY;
			
			this.drawSimpleGradient([ 0x112528, 0x1E3D42 ], 15, 6983586, 1120028, 3294800);
			
			// _drawLine(5, 29, this.Width);
			
			var tXSpacing:Number = 0;//55;
			var tX:Number = 5-tXSpacing;
			var tYSpacing:Number = 43;//0;
			var tY:Number = 10-tYSpacing;
			var tWidth:Number = 50;
			var tHeight:Number = 38;
			
			this.skinTab = _addTab("Skin", tX += tXSpacing, tY += tYSpacing, tWidth, tHeight, this.tabSkinClicked);
			this.hairTab = _addTab("Hair", tX += tXSpacing, tY += tYSpacing, tWidth, tHeight, this.tabHairClicked);
			this.gunsTab = _addTab("Guns", tX += tXSpacing, tY += tYSpacing, tWidth, tHeight, this.tabGunsClicked);
			this.posesTab = _addTab("Poses", tX += tXSpacing, tY += tYSpacing, tWidth, tHeight, this.tabPosesClicked);
			
			this.skinTab.ToggleOn();
		}
		
		private function _addTab(pText:String, pX:Number, pY:Number, pWidth:Number, pHeight:Number, pEvent:Function) : GUI.PushButton {
			var tBttn:GUI.PushButton = new GUI.PushButton(pX, pY, pWidth, pHeight, pText);
			addChild(tBttn);
			tBttn.addEventListener("state_changed_before", pEvent, false, 0, true);
			return tBttn;
		}
		
		private function _drawLine(pX:Number, pY:Number, pWidth:Number) : void {
			var tLine:Shape = new Shape();
			tLine.x = pX;
			tLine.y = pY;
			addChild(tLine);
			
			tLine.graphics.lineStyle(1, 1120284, 1, true);
			tLine.graphics.moveTo(0, 0);
			tLine.graphics.lineTo(pWidth - 10, 0);
			
			tLine.graphics.lineStyle(1, 6325657, 1, true);
			tLine.graphics.moveTo(0, 1);
			tLine.graphics.lineTo(pWidth - 10, 1);
		}

		function tabSkinClicked(arg1:*) : void	{ untoggle(this.skinTab, TAB_SKIN_CLICK); }
		function tabHairClicked(arg1:*) : void	{ untoggle(this.hairTab, TAB_HAIR_CLICK); }
		function tabGunsClicked(arg1:*) : void	{ untoggle(this.gunsTab, TAB_GUNS_CLICK); }
		function tabPosesClicked(arg1:*) : void	{ untoggle(this.posesTab, TAB_POSES_CLICK); }

		public function UnpressAll() : void {
			untoggle();
		}
		
		private function untoggle(pTab:GUI.PushButton=null, pEvent:String=null) : void {
			if (pTab != null && pTab.Pushed) { return; }
			
			if (this.skinTab.Pushed && this.skinTab != pTab) {
				this.skinTab.ToggleOff();
			}
			if (this.hairTab.Pushed && this.hairTab != pTab) {
				this.hairTab.ToggleOff();
			}
			if (this.gunsTab.Pushed && this.gunsTab != pTab) {
				this.gunsTab.ToggleOff();
			}
			if (this.posesTab.Pushed && this.posesTab != pTab) {
				this.posesTab.ToggleOff();
			}
			if(pEvent!=null) { dispatchEvent(new flash.events.Event(pEvent)); }
		}
	}
}
