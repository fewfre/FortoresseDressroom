package dressroom.ui.panes
{
	import dressroom.data.*;
	import dressroom.ui.*;
	import dressroom.ui.buttons.*;
	import fl.containers.*;
	import flash.display.*;
	
	public class TabPane extends MovieClip
	{
		// Storage
		public var active : Boolean;
		public var infoBar : ShopInfoBar;
		public var buttons : Array;
		public var selectedButtonIndex : int;
		
		var Pane:fl.containers.ScrollPane;
		var content:MovieClip;
		
		// Constructor
		public function TabPane() {
			super();
			active = false;
			infoBar = null;
			buttons = [];
			selectedButtonIndex = -1;
			this.content = new MovieClip();
		}

		public function addItem(pItem:Sprite) : Sprite {
			return this.content.addChild(pItem);
		}

		public function addInfoBar(pBar:ShopInfoBar) : void {
			this.infoBar = this.addChild(pBar);
		}

		public function UpdatePane(pItemPane:Boolean=true) : void {
			this.x = 5;
			this.y = 5;//40;
			if (pItemPane) 
			{
				this.content.graphics.beginFill(0, 0);
				this.content.graphics.drawRect(0, 0, this.content.width + 30, this.content.height + 20);
				this.content.graphics.endFill();
			}
			var tStyle:*=new MovieClip();
			tStyle.graphics.clear();
			this.Pane = new fl.containers.ScrollPane();
			this.Pane.source = this.content;
			this.Pane.setStyle("upSkin", tStyle);
			this.Pane.setSize(ConstantsApp.PANE_WIDTH, 330);//350);
			this.Pane.move(0, this.infoBar==null ? 0 : 60);
			this.Pane.verticalLineScrollSize = 25;
			this.Pane.verticalPageScrollSize = 25;
			
			addChild(this.Pane);
		}
	}
}
