package 
{
	import com.adobe.images.*;
	import com.piterwilson.utils.*;
	import com.fewfre.utils.AssetManager;
	import com.fewfre.display.*;
	import com.fewfre.events.*;
	import com.fewfre.utils.*;
	
	import dressroom.ui.*;
	import dressroom.ui.panes.*;
	import dressroom.ui.buttons.*;
	import dressroom.data.*;
	import dressroom.world.data.*;
	import dressroom.world.elements.*;
	
	import fl.controls.*;
	import fl.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*
	import flash.external.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class Main extends MovieClip
	{
		// Storage
		public static var assets	: AssetManager;
		public static var costumes	: Costumes;
		
		internal var character		: Character;
		internal var loadingSpinner	: MovieClip;
		
		internal var shop			: RoundedRectangle;
		internal var shopTabs		: ShopTabContainer;
		internal var animateButton	: SpriteButton;
		internal var linkTray		: LinkTray;
		internal var scaleSlider	: FancySlider;
		
		internal var currentlyColoringType:String="";
		internal var configCurrentlyColoringType:String;
		
		internal var tabPanes:Array; // Must contain all TabPanes to be able to close them properly.
		internal var tabPanesMap:Object; // Tab pane should be stored in here to easy access the one you desire.
		internal var colorTabPane:TabPane;
		internal var configColorTabPane:TabPane;
		
		/*internal var shop			: RoundedRectangle;
		internal var shopTabs		: GUI.ShopTabContainer;
		internal var psColorPick	: com.piterwilson.utils.ColorPicker;
		public var scaleSlider		: fl.controls.Slider;
		
		internal var currentlyColoringType:String="";
		
		internal var selectedSwatch:int=0;
		internal var colorSwatches:Array;
		
		internal var tabPanes:Array;
		internal var tabPanesMap:Object;
		internal var tabColorPane:GUI.Tab;*/
		
		// Constructor
		public function Main()
		{
			super();
			
			assets = new AssetManager();
			assets.load([
				"resources/resources.swf"
			]);
			assets.addEventListener(AssetManager.LOADING_FINISHED, _onLoadComplete);
			
			loadingSpinner = addChild( new $Loader() );
			loadingSpinner.x = 900 * 0.5;
			loadingSpinner.y = 425 * 0.5;
			loadingSpinner.scaleX = 2;
			loadingSpinner.scaleY = 2;
			
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 10;
			
			addEventListener("enterFrame", update);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
		}
		
		internal function _onLoadComplete(event:Event) : void
		{
			removeChild( loadingSpinner );
			loadingSpinner = null;
				
			costumes = new Costumes( assets );
			costumes.init();
			
			/****************************
			* Create Character
			*****************************/
			var parms:flash.net.URLVariables = null;
			try {
				var urlPath:String = ExternalInterface.call("eval", "window.location.href");
				if(urlPath && urlPath.indexOf("?") > 0) {
					urlPath = urlPath.substr(urlPath.indexOf("?") + 1, urlPath.length);
					parms = new flash.net.URLVariables();
					parms.decode(urlPath);
				}
			} catch (error:Error) { };
			
			this.character = addChild(new Character({ x:180, y:375,
				skin:costumes.skins[costumes.defaultSkinIndex],
				pose:costumes.poses[costumes.defaultPoseIndex],
				params:parms
			}));
			
			/****************************
			* Setup UI
			*****************************/
			this.shop = addChild(new RoundedRectangle(450, 10, ConstantsApp.SHOP_WIDTH, ConstantsApp.APP_HEIGHT));//ShopTabContainer(450, 10, 440, ConstantsApp.APP_HEIGHT);
			this.shop.drawSimpleGradient([ 0x112528, 0x1E3D42 ], 15, 0x6A8fA2, 0x11171C, 0x324650);
			
			this.shopTabs = addChild(new ShopTabContainer(380, 10, 60, ConstantsApp.APP_HEIGHT));
			this.shopTabs.addEventListener(ShopTabContainer.EVENT_SHOP_TAB_CLICKED, _onTabClicked);
			
			// Toolbox
			var tools:RoundedRectangle = addChild(new RoundedRectangle(5, 10, 365, 35));
			tools.drawSimpleGradient([ 0x112528, 0x1E3D42 ], 15, 0x6A8fA2, 0x11171C, 0x324650);
			
			var btn:ButtonBase, tButtonSize = 28, tButtonSizeSpace=5;
			btn = tools.addChild(new SpriteButton({ x:tButtonSizeSpace, y:4, width:tButtonSize, height:tButtonSize, obj_scale:0.4, obj:new $LargeDownload() }));
			btn.addEventListener(ButtonBase.CLICK, _onSaveClicked);
			
			animateButton = tools.addChild(new SpriteButton({ x:tButtonSizeSpace+(tButtonSize+tButtonSizeSpace), y:4, width:tButtonSize, height:tButtonSize, obj_scale:0.5, obj:new $PauseButton() }));
			animateButton.addEventListener(ButtonBase.CLICK, _onPlayerAnimationToggle);
			
			btn = tools.addChild(new SpriteButton({ x:tButtonSizeSpace+(tButtonSize+tButtonSizeSpace)*2, y:4, width:tButtonSize, height:tButtonSize, obj_scale:0.5, obj:new $Refresh() }));
			btn.addEventListener(ButtonBase.CLICK, _onRandomizeDesignClicked);
			
			btn = tools.addChild(new SpriteButton({ x:tButtonSizeSpace+(tButtonSize+tButtonSizeSpace)*3, y:4, width:tButtonSize, height:tButtonSize, obj_scale:0.45, obj:new $Link() }));
			btn.addEventListener(ButtonBase.CLICK, _onShareButtonClicked);
			linkTray = new LinkTray({ x:stage.stageWidth * 0.5, y:stage.stageHeight * 0.5 });
			linkTray.addEventListener(LinkTray.CLOSE, _onShareTrayClosed);
			
			btn = tools.addChild(new SpriteButton({ x:tools.width-tButtonSizeSpace-tButtonSize, y:4, width:tButtonSize, height:tButtonSize, obj_scale:0.35, obj:new $GitHubIcon() }));
			btn.addEventListener(ButtonBase.CLICK, function():void { navigateToURL(new URLRequest(ConstantsApp.SOURCE_URL), "_blank");  });
			
			var tSliderWidth = 315 - (tButtonSize+tButtonSizeSpace)*4.5;
			this.scaleSlider = tools.addChild(new FancySlider({ x:tools.width*0.5-tSliderWidth*0.5+(tButtonSize+tButtonSizeSpace)*1.5, y:tools.Height*0.5, value: character.outfit.scaleX*10, min:10, max:50, width:tSliderWidth }));
			this.scaleSlider.addEventListener(FancySlider.CHANGE, _onScaleSliderChange);
			
			/****************************
			* Create tabs and panes
			*****************************/
			this.tabPanes = new Array();
			this.tabPanesMap = new Object();
			
			tabPanes.push( colorTabPane = new ColorPickerTabPane({}) );
			colorTabPane.addEventListener(ColorPickerTabPane.EVENT_COLOR_PICKED, _onColorPickChanged);
			colorTabPane.addEventListener(ColorPickerTabPane.EVENT_DEFAULT_CLICKED, _onDefaultsButtonClicked);
			colorTabPane.addEventListener(ColorPickerTabPane.EVENT_EXIT, _onColorPickerBackClicked);
			
			// Create the panes
			var tTypes = [ ITEM.SKIN, ITEM.HAIR, ITEM.OBJECT, ITEM.POSE ], tData:ItemData;
			for(var i:int = 0; i < tTypes.length; i++) {
				tabPanes.push( tabPanesMap[tTypes[i]] = _setupPane(tTypes[i]) );
				// Based on what the character is wearing at start, toggle on the appropriate buttons.
				tData = character.getItemData(tTypes[i]);
				if(tData) {
					var tIndex:int = FewfUtils.getIndexFromArrayWithKeyVal(costumes.getArrayByType(tTypes[i]), "id", tData.id);
					tabPanesMap[tTypes[i]].buttons[ tIndex ].toggleOn();
				}
			}
			
			// Select First Pane
			shopTabs.tabs[0].toggleOn();
		}
		
		private function _setupPane(pType:String) : TabPane {
			var tPane:TabPane = new TabPane();
			_setupPaneButtons(tPane, costumes.getArrayByType(pType));
			tPane.infoBar.colorWheel.addEventListener(ButtonBase.CLICK, function(){ _colorButtonClicked(pType); });
			tPane.infoBar.imageCont.addEventListener(MouseEvent.CLICK, function(){ _removeItem(pType); });
			tPane.infoBar.refreshButton.addEventListener(ButtonBase.CLICK, function(){ _randomItemOfType(pType); });
			return tPane;
		}
		
		private function _setupPaneButtons(pPane:TabPane, pItemArray:Array) : void {
			var tType:String = pItemArray[0].type;
			
			pPane.addInfoBar( new ShopInfoBar({}) );
			
			var xoff = 15;
			var yoff = 5;//15;
			var wCtr = 0;
			var w = 0;
			var h = 0;
			var i = 0;
			
			var radius = 60;
			var spacing = 65;
			var buttonPerRow = 6;
			var scale = 1;
			if(tType == ITEM.SKIN || tType == ITEM.POSE) {
					buttonPerRow = 4;
					var space = 5;
					radius = Math.floor((385 - (space * (buttonPerRow-1))) / buttonPerRow);
					spacing = radius + space;
					scale = 1;
			}
			
			var shopItem : MovieClip;
			var shopItemButton : PushButton;
			while (i < pItemArray.length) 
			{
				shopItem = costumes.getItemImage(pItemArray[i]);
				/*if(tType == ITEM.SKIN && i == pItemArray.length-1) {
					shopItem = new MovieClip();
					var tText = shopItem.addChild(new TextField());
					tText.defaultTextFormat = new flash.text.TextFormat("Verdana", 15, 0xC2C2DA);
					tText.autoSize = flash.text.TextFieldAutoSize.CENTER;
					tText.text = "Invisible";
					tText.x = (shopItemButton.width - tText.textWidth) * 0.5 - 2;
					tText.y = (shopItemButton.Height - tText.textHeight) * 0.5 - 2;
				}*/
				shopItem.scaleX = shopItem.scaleY = scale;
					
				shopItemButton = new PushButton({ x:xoff + spacing * w, y:yoff + spacing * h, width:radius, height:radius, obj:shopItem, id:i, data:{ type:tType, id:i } });
				pPane.addItem(shopItemButton);
				pPane.buttons.push(shopItemButton);
				shopItemButton.addEventListener(PushButton.STATE_CHANGED_AFTER, _onItemToggled);
				++wCtr;
				++w;
				if (wCtr >= buttonPerRow) 
				{
					w = 0;
					wCtr = 0;
					++h;
				}
				++i;
			}
			pPane.UpdatePane();
		}
		
		public function update(pEvent:Event):void
		{
			if(loadingSpinner != null) {
				loadingSpinner.rotation += 10;
			}
		}
		
		private function handleMouseWheel(pEvent:MouseEvent) : void {
			if(this.mouseX < this.shopTabs.x) {
				scaleSlider.updateViaMouseWheelDelta(pEvent.delta);
				character.scale = scaleSlider.getValueAsScale();
			}
		}
		
		private function _onScaleSliderChange(pEvent:Event):void {
			character.scale = scaleSlider.getValueAsScale();
		}
		
		private function _onColorPickerBackClicked(pEvent:Event):void {
			_selectTab( getTabByType( this.colorTabPane.infoBar.data.type ) );
		}
		
		private function _onPlayerAnimationToggle(pEvent:Event):void {
			character.animatePose = !character.animatePose;
			if(character.animatePose) {
				character.outfit.play();
				animateButton.ChangeImage(new $PauseButton());
			} else {
				character.outfit.stop();
				animateButton.ChangeImage(new $PlayButton());
			}
		}
		
		private function _onSaveClicked(pEvent:Event) : void {
			Main.costumes.saveMovieClipAsBitmap(this.character, "character");
		}
		
		private function _onItemToggled(pEvent:FewfEvent) : void {
			var tType = pEvent.data.type;
			var tItemArray:Array = costumes.getArrayByType(tType);
			var tInfoBar:ShopInfoBar = getInfoBarByType(tType);
			
			// De-select all buttons that aren't the clicked one.
			var tButtons:Array = getButtonArrayByType(tType);
			for(var i:int = 0; i < tButtons.length; i++) {
				if(tButtons[i].data.id != pEvent.data.id) {
					if (tButtons[i].pushed)  { tButtons[i].toggleOff(); }
				}
			}
			
			var tButton:PushButton = tButtons[pEvent.data.id];
			var tData:ItemData;
			// If clicked button is toggled on, equip it. Otherwise remove it.
			if(tButton.pushed) {
				tData = tItemArray[pEvent.data.id];
				setCurItemID(tType, tButton.id);
				this.character.setItemData(tData);
				
				tInfoBar.addInfo( tData, costumes.getItemImage(tData) );
				tInfoBar.showColorWheel(costumes.getNumOfCustomColors(tButton.Image) > 0);
			} else {
				_removeItem(tType);
			}
		}
		
		private function _removeItem(pType:String) : void {
			var tTabPane = getTabByType(pType);
			if(tTabPane.infoBar.hasData == false) { return; }
			
			// If item has a default value, toggle it on. otherwise remove item.
			if(pType == ITEM.SKIN || pType == ITEM.POSE) {
				var tDefaultIndex = (pType == ITEM.POSE ? costumes.defaultPoseIndex : costumes.defaultSkinIndex);
				tTabPane.buttons[costumes.defaultSkinIndex].toggleOn();
			} else {
				this.character.removeItem(pType);
				tTabPane.infoBar.removeInfo();
				tTabPane.buttons[ tTabPane.selectedButtonIndex ].toggleOff();
			}
		}
		
		private function _onRandomizeDesignClicked(pEvent:Event) : void {
			for(var i:int = 0; i < ITEM.LAYERING.length; i++) {
				_randomItemOfType(ITEM.LAYERING[i]);
			}
			_randomItemOfType(ITEM.POSE);
		}
		
		private function _randomItemOfType(pType:String) : void {
			var tButtons = getButtonArrayByType(pType);
			var tLength = tButtons.length; //if(pType == ITEM.SKIN) { /* Don't select "transparent" */ tLength--; }
			tButtons[ Math.floor(Math.random() * tLength) ].toggleOn();
		}
		
		private function _onShareButtonClicked(pEvent:Event) : void {
			var tURL = "";
			try {
				tURL = ExternalInterface.call("eval", "window.location.origin+window.location.pathname");
				tURL += "?"+this.character.getParams();
			} catch (error:Error) {
				tURL = "<error creating link>";
			};
			
			linkTray.open(tURL);
			addChild(linkTray);
		}
		
		private function _onShareTrayClosed(pEvent:Event) : void {
			removeChild(linkTray);
		}
		
		//{REGION Get TabPane data
			private function getTabByType(pType:String) : TabPane {
				return tabPanesMap[pType];
			}
			
			private function getInfoBarByType(pType:String) : ShopInfoBar {
				return getTabByType(pType).infoBar;
			}
			
			private function getButtonArrayByType(pType:String) : Array {
				return getTabByType(pType).buttons;
			}
			
			private function getCurItemID(pType:String) : int {
				return getTabByType(pType).selectedButtonIndex;
			}
			
			private function setCurItemID(pType:String, pID:int) : void {
				getTabByType(pType).selectedButtonIndex = pID;
			}
		//}END Get TabPane data
		
		//{REGION TabPane Management
			private function _onTabClicked(pEvent:flash.events.DataEvent) : void {
				_selectTab( getTabByType(pEvent.data) );
			}
			
			private function _selectTab(pTab:TabPane) : void {
				_hideAllTabs();
				this.shop.addChild(pTab).active = true;
			}
			
			private function _hideTab(pTab:TabPane) : void {
				if(!pTab.active) { return; }
				this.shop.removeChild(pTab).active = false;
			}

			private function _hideAllTabs() : void {
				for(var i = 0; i < this.tabPanes.length; i++) {
					_hideTab(this.tabPanes[ i ]);
				}
			}
		//}END TabPane Management
		
		//{REGION Color Tab
			private function _onColorPickChanged(pEvent:flash.events.DataEvent):void
			{
				var tVal:uint = uint(pEvent.data);
				
				this.character.colorItem(this.currentlyColoringType, this.colorTabPane.selectedSwatch, tVal.toString(16));
				var tItem:MovieClip = this.character.getItemFromIndex(this.currentlyColoringType);
				if (tItem != null) {
					costumes.copyColor( tItem, getButtonArrayByType(this.currentlyColoringType)[ getCurItemID(this.currentlyColoringType) ].Image );
					costumes.copyColor(tItem, getInfoBarByType( this.currentlyColoringType ).Image );
					costumes.copyColor(tItem, this.colorTabPane.infoBar.Image);
				}
				return;
			}

			private function _onDefaultsButtonClicked(pEvent:Event) : void
			{
				var tMC:MovieClip = this.character.getItemFromIndex(this.currentlyColoringType);
				if (tMC != null) 
				{
					costumes.colorDefault(tMC);
					costumes.copyColor( tMC, getButtonArrayByType(this.currentlyColoringType)[ getCurItemID(this.currentlyColoringType) ].Image );
					costumes.copyColor(tMC, getInfoBarByType(this.currentlyColoringType).Image);
					costumes.copyColor(tMC, this.colorTabPane.infoBar.Image);
					this.colorTabPane.setupSwatches( this.character.getColors(this.currentlyColoringType) );
				}
			}
			
			private function _colorButtonClicked(pType:String) : void {
				if(this.character.getItemFromIndex(pType) == null) { return; }
				
				var tData:ItemData = getInfoBarByType(pType).data;
				this.colorTabPane.infoBar.addInfo( tData, costumes.getItemImage(tData) );
				this.currentlyColoringType = pType;
				this.colorTabPane.setupSwatches( this.character.getColors(pType) );
				_selectTab(this.colorTabPane);
			}
		//}END Color Tab
	}
}
