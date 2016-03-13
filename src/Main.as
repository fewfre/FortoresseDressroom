package 
{
	import GUI.*;
	import data.*;
	import com.adobe.images.*;
	import com.piterwilson.utils.*;
	import fl.controls.*;
	import fl.events.*;
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event
	import flash.events.MouseEvent;
	import flash.external.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class Main extends MovieClip
	{
		// Storage
		public static var costumes	: Costumes;
		
		//internal var character		: TheMouse;
		internal var character		: Character;
		
		internal var shop			: RoundedRectangle;
		internal var shopTabs		: GUI.ShopTabContainer;
		internal var psColorPick	: com.piterwilson.utils.ColorPicker;
		public var scaleSlider		: fl.controls.Slider;
		
		internal var currentlyColoringType:String="";
		
		internal var selectedSwatch:int=0;
		internal var colorSwatches:Array;
		
		internal var tabPanes:Array;
		internal var tabPanesMap:Object;
		internal var tabColorPane:GUI.Tab;
		
		// Initial asset load data
		internal var loaders:Array;
		internal var loadingSpinner:MovieClip;
		internal var loaded_MCs:Array;
		
		// Constructor
		public function Main()
		{
			super();
			
			this.loaded_MCs = new Array();
			
			stage.align = flash.display.StageAlign.TOP;
			stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			stage.frameRate = 10;
			
			this.loaders = new Array();
			this.loaders.push(newAssetLoader("resources/resources.swf"));
			
			loadingSpinner = new $Loader();
			addChild( loadingSpinner );
			loadingSpinner.x = 900 * 0.5;
			loadingSpinner.y = 425 * 0.5;
			loadingSpinner.scaleX = 2;
			loadingSpinner.scaleY = 2;
			
			addEventListener("enterFrame", this.Update, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			
			this.__setProp_scaleSlider_Scene1_Layer1_0();
		}
		internal function newAssetLoader(pUrl:String) : Loader {
			var tLoader:Loader = new Loader();
			tLoader.contentLoaderInfo.addEventListener(Event.INIT, this.dataLoaded);
			tLoader.load(new flash.net.URLRequest(pUrl));
			return tLoader;
		}
		
		internal function dataLoaded(event:Event) : void {
			this.loaded_MCs.push( MovieClip(event.target.content) );
			
			checkIfLoadingDone();
		}
		
		internal function checkIfLoadingDone() : void {
			if(this.loaded_MCs.length >= this.loaders.length) {
				creatorLoaded();
				
				for(var i = 0; i < this.loaders.length; i++) {
					this.loaders[i].contentLoaderInfo.removeEventListener(Event.INIT, this.dataLoaded);
					this.loaders[i] = null;
				}
				this.loaders = null;
				
				removeChild( loadingSpinner );
				loadingSpinner = null;
			}
		}
		
		internal function creatorLoaded():*
		{
			trace("resources loaded...");
			costumes = new Costumes( this.loaded_MCs );
			costumes.init();
			
			var defaults_btn:GUI.Clickable;
			var i:int;
			
			this.character = addChild(new Character(costumes.skins[costumes.defaultSkinIndex], null, null, costumes.poses[costumes.defaultPoseIndex]));
			this.character.x = 180;
			this.character.y = 300;//180;
			this.character.scaleX = 1;
			this.character.scaleY = 1;
			
			var btn:SpriteButton = addChild(new SpriteButton(5, 5, 60, 60, new $LargeDownload(), 1));
			btn.doMouseover = true;
			btn.Image.scaleX = btn.Image.scaleY = 1;
			btn.addEventListener(flash.events.MouseEvent.MOUSE_UP, function():void { saveScreenshot(); });
			
			var sSlider:fl.controls.Slider = this.scaleSlider;
			sSlider.addEventListener(fl.events.SliderEvent.CHANGE, function():*
			{
				character.outfit.scaleX = sSlider.value;
				character.outfit.scaleY = sSlider.value;
				return;
			})
			sSlider.addEventListener(fl.events.SliderEvent.THUMB_DRAG, function():*
			{
				character.outfit.scaleX = sSlider.value;
				character.outfit.scaleY = sSlider.value;
				return;
			})
			
			this.shop = new GUI.RoundedRectangle(450, 10, ConstantsApp.SHOP_WIDTH, ConstantsApp.APP_HEIGHT);//GUI.ShopTabContainer(450, 10, 440, ConstantsApp.APP_HEIGHT);
			this.shop.drawSimpleGradient([ 0x112528, 0x1E3D42 ], 15, 6983586, 1120028, 3294800);
			addChild(this.shop);
			this.shopTabs = new GUI.ShopTabContainer(380, 10, 60, ConstantsApp.APP_HEIGHT);
			addChild(this.shopTabs);
			
			this.shopTabs.addEventListener(ShopTabContainer.TAB_SKIN_CLICK, this.tabSkinClicked, false, 0, true);
			this.shopTabs.addEventListener(ShopTabContainer.TAB_HAIR_CLICK, this.tabHairClicked, false, 0, true);
			this.shopTabs.addEventListener(ShopTabContainer.TAB_GUNS_CLICK, this.tabGunsClicked, false, 0, true);
			this.shopTabs.addEventListener(ShopTabContainer.TAB_POSES_CLICK, this.tabPosesClicked, false, 0, true);
			
			this.tabPanes = new Array();
			this.tabPanesMap = new Object();
			var tPane:GUI.Tab = null;
			
			tPane = tabPanesMap[SHOP_ITEM_TYPE.SKIN] = this.tabPanes[this.tabPanes.push(new GUI.Tab())-1];
			_setupPane(tPane, costumes.skins, this.buttonSkinClickAfter, true);
			//tPane.infoBar.colorWheel.addEventListener(MouseEvent.MOUSE_UP, this.colorBtnSkinClicked, false, 0, true);
			tPane.infoBar.imageCont.addEventListener(MouseEvent.MOUSE_UP, this.removeSkinClicked, false, 0, true);
			// Select Default Skin
			tPane.infoBar.addInfo(costumes.skins[costumes.defaultSkinIndex], new Skin( costumes.skins[costumes.defaultSkinIndex] ));
			tPane.buttons[costumes.defaultSkinIndex].ToggleOn();
			// Select Pane
			this.shop.addChild(tPane);
			tPane.active = true;
			
			tPane = tabPanesMap[SHOP_ITEM_TYPE.HAIR] = this.tabPanes[this.tabPanes.push(new GUI.Tab())-1];
			_setupPane(tPane, costumes.hair, this.buttonHairClickAfter);
			//tPane.infoBar.colorWheel.addEventListener(MouseEvent.MOUSE_UP, this.colorBtnHairClicked, false, 0, true);
			tPane.infoBar.imageCont.addEventListener(MouseEvent.MOUSE_UP, this.removeHairClicked, false, 0, true);
			
			tPane = tabPanesMap[SHOP_ITEM_TYPE.PRIMARY_WEAPON] = this.tabPanes[this.tabPanes.push(new GUI.Tab())-1];
			_setupPane(tPane, costumes.guns, this.buttonGunClickAfter);
			//tPane.infoBar.colorWheel.addEventListener(MouseEvent.MOUSE_UP, this.colorBtnGunClicked, false, 0, true);
			tPane.infoBar.imageCont.addEventListener(MouseEvent.MOUSE_UP, this.removeGunClicked, false, 0, true);
			
			tPane = tabPanesMap[SHOP_ITEM_TYPE.POSE] = this.tabPanes[this.tabPanes.push(new GUI.Tab())-1];
			_setupPane(tPane, costumes.poses, this.buttonPoseClickAfter);
			//tPane.infoBar.colorWheel.addEventListener(MouseEvent.MOUSE_UP, this.colorBtnGunClicked, false, 0, true);
			tPane.infoBar.imageCont.addEventListener(MouseEvent.MOUSE_UP, this.removePoseClicked, false, 0, true);
			// Select Default Pose
			tPane.infoBar.addInfo(costumes.poses[costumes.defaultPoseIndex], new MovieClip());
			tPane.buttons[costumes.defaultPoseIndex].ToggleOn();
		}
		
		private function _setupPane(pPane:GUI.Tab, pItemArray:Array, pChangeListener:Function, pIsSkin:Boolean=false) : GUI.Tab {
			var shopItem : MovieClip;
			var shopItemButton : GUI.SpritePushButton;
			
			pPane.addInfoBar( new ShopInfoBar({}) );
			
			var xoff = 15;
			var yoff = 5;//15;
			var radius = 60;
			var spacing = 65;
			var buttonPerRow = 6;
			var wCtr = 0;
			var w = 0;
			var h = 0;
			var i = 0;
			while (i < pItemArray.length) 
			{
				if(pIsSkin) {
					shopItem = new Skin(costumes.skins[i]);
					// 385
					buttonPerRow = 4;
					var space = 5;
					radius = Math.floor((385 - (space * (buttonPerRow-1))) / buttonPerRow);
					spacing = radius + space;
					shopItem.scaleX = shopItem.scaleY = 1.25;
				} else {
					shopItem = new pItemArray[i].itemClass();
					// costumes.colorDefault(shopItem);
				}
				shopItemButton = new GUI.SpritePushButton(xoff + spacing * w, yoff + spacing * h, radius, radius, shopItem, i);
				pPane.addItem(shopItemButton);
				pPane.buttons.push(shopItemButton);
				shopItemButton.addEventListener("state_changed_after", pChangeListener, false, 0, true);
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
			return pPane;
		}
		
		private function _setupColorPickerPane() : void {
			this.tabColorPane = new GUI.Tab();
			this.tabColorPane.addInfoBar( new ShopInfoBar({ showBackButton:true }) );
			// this.tabColorPane.infoBar.colorWheelEnabled = false;
			this.tabColorPane.infoBar.colorWheel.addEventListener(MouseEvent.MOUSE_UP, this.colorPickerBackClicked, false, 0, true);
			
			this.psColorPick = new com.piterwilson.utils.ColorPicker();
			this.psColorPick.x = 105;
			this.psColorPick.y = 5;
			this.psColorPick.addEventListener(com.piterwilson.utils.ColorPicker.COLOR_PICKED, this.colorPickChanged, false, 0, true);
			this.tabColorPane.addItem(this.psColorPick);
			
			i = -1;
			colorSwatches = new Array();
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch1OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch1OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch2OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch2OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch3OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch3OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch4OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch4OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch5OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch5OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch6OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch6OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch7OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch7OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch8OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch8OnClick, false, 0, true);
			i++;
			colorSwatches.push(new GUI.ColorSwatch());
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.ENTER_PRESSED, this.colorSwatch9OnEnterPressed, false, 0, true);
			this.colorSwatches[i].addEventListener(GUI.ColorSwatch.BUTTON_CLICK, this.colorSwatch9OnClick, false, 0, true);
			
			for(var k = 0; k < colorSwatches.length; k++) {
				this.colorSwatches[k].x = 5;
				this.colorSwatches[k].y = 45 + (k * 30);
				this.tabColorPane.addItem(this.colorSwatches[k]);
			}
			
			//defaults_btn = new GUI.Clickable(6, 325, 100, 22, "Defaults");
			defaults_btn = new GUI.Clickable(6, 10, 100, 22, "Defaults");
			defaults_btn.addEventListener("button_click", this.defaults_btnClicked, false, 0, true);
			this.tabColorPane.addItem(defaults_btn);
			this.tabColorPane.UpdatePane(false);
		}

		public function Update(pEvent:Event):void
		{
			if(loadingSpinner != null) {
				loadingSpinner.rotation += 10;
			}
		}
		
		public function handleMouseWheel(pEvent:MouseEvent) : void {
			if(this.mouseX < this.shopTabs.x) {
				scaleSlider.value += pEvent.delta * 0.2;
				character.outfit.scaleX = scaleSlider.value;
				character.outfit.scaleY = scaleSlider.value;
			}
		}

		internal function colorPickChanged(pEvent:flash.events.DataEvent):void
		{
			var tVal:uint = uint(pEvent.data);
			
			colorSwatches[this.selectedSwatch].Value = tVal;
			
			this.character.colorItem(this.currentlyColoringType, this.selectedSwatch, tVal.toString(16));
			var tItem:MovieClip = this.character.getItem(this.currentlyColoringType);
			if (tItem != null) {
				costumes.copyColor( tItem, getButtonArrayByType(this.currentlyColoringType)[ getCurItemID(this.currentlyColoringType) ].Image );
				costumes.copyColor(tItem, getInfoBarByType( this.currentlyColoringType ).Image );
				costumes.copyColor(tItem, this.tabColorPane.infoBar.Image);
			}
			return;
		}

		internal function saveScreenshot() : void
		{
			var tRect:flash.geom.Rectangle = this.character.getBounds(this.character);
			var tBitmap:flash.display.BitmapData = new flash.display.BitmapData(this.character.width, this.character.height, true, 16777215);
			tBitmap.draw(this.character, new flash.geom.Matrix(1, 0, 0, 1, -tRect.left, -tRect.top));
			( new flash.net.FileReference() ).save( com.adobe.images.PNGEncoder.encode(tBitmap), "mouse.png" );
		}

		public function tabSkinClicked(pEvent:Event) : void { _tabClicked( getTabByType(SHOP_ITEM_TYPE.SKIN) ); }
		public function tabHairClicked(pEvent:Event) : void { _tabClicked( getTabByType(SHOP_ITEM_TYPE.HAIR) ); }
		public function tabGunsClicked(pEvent:Event) : void { _tabClicked( getTabByType(SHOP_ITEM_TYPE.PRIMARY_WEAPON) ); }
		public function tabPosesClicked(pEvent:Event) : void { _tabClicked( getTabByType(SHOP_ITEM_TYPE.POSE) ); }
		
		internal function _tabClicked(pTab:GUI.Tab) : void {
			this.HideAllTabs();
			pTab.active = true;
			this.shop.addChild(pTab);
		}

		public function buttonHairClickAfter(pEvent:Event):void {
			toggleItemSelection(SHOP_ITEM_TYPE.HAIR, pEvent.target, costumes.hair, false, getInfoBarByType(SHOP_ITEM_TYPE.HAIR));
		}

		public function buttonGunClickAfter(pEvent:Event):void {
			toggleItemSelection(SHOP_ITEM_TYPE.PRIMARY_WEAPON, pEvent.target, costumes.guns, false, getInfoBarByType(SHOP_ITEM_TYPE.PRIMARY_WEAPON));
		}
		
		private function toggleItemSelection(pType:String, pTarget:GUI.SpritePushButton, pItemArray:Array, pColorDefault:Boolean=false, pInfoBar:ShopInfoBar=null) : void {
			var tButton:GUI.SpritePushButton = null;
			var tData:ShopItemData = null;
			
			var tButtons:Array = getButtonArrayByType(pType);
			var i:int=0;
			while (i < tButtons.length) 
			{
				tButton = tButtons[i] as GUI.SpritePushButton;
				tData = pItemArray[tButton.id];
				
				if (tButton.id != pTarget.id) {
					if (tButton.Pushed) { tButton.ToggleOff(); }
				}
				else if (tButton.Pushed) {
					setCurItemID(pType, tButton.id);
					this.character.addItem( pType, tData );
					
					//pTabButt.ChangeImage( costumes.copyColor(tButton.Image, new tData.itemClass()) );
					
					if(pInfoBar != null) {
						pInfoBar.addInfo( tData, new tData.itemClass() );
						pInfoBar.colorWheelActive = false;//costumes.getNumOfCustomColors(tButton.Image) > 0;
					}
					
					if(pColorDefault) { this.character.colorDefault(pType); }
				} else {
					this.character.removeItem(pType);
					//pTabButt.ChangeImage(new $Cadeau());
					
					if(pInfoBar != null) { pInfoBar.removeInfo(); }
				}
				i++ ;
			}
		}

		public function buttonSkinClickAfter(pEvent:Event):void {
			var pType:String = SHOP_ITEM_TYPE.SKIN;
			var pInfoBar:ShopInfoBar = getInfoBarByType(pType);
			
			var tTarget:GUI.SpritePushButton = pEvent.target as GUI.SpritePushButton;
			var tButton:GUI.SpritePushButton = null;
			var tData:ShopItemData = null;
			var tDataArray:Array = costumes.getArrayByType(pType);
			
			var tButtons:Array = getButtonArrayByType(pType);
			var i:int = 0;
			while (i < tButtons.length) {
				tButton = tButtons[i] as GUI.SpritePushButton;
				tData = tDataArray[tButton.id];
				
				if (tButton.id != tTarget.id) {
					if (tButton.Pushed) { tButton.ToggleOff(); }
				}
				else if (tButton.Pushed) {
					setCurItemID(pType, tButton.id);
					this.character.addItem( pType, tData );
					
					pInfoBar.addInfo( tData, new Skin(tData) );
					pInfoBar.colorWheelActive = false;//tDataArray[tButton.id].id == -1;
				} else {
					this.character.setSkin(tDataArray[costumes.defaultSkinIndex]);
					pInfoBar.addInfo( tDataArray[costumes.defaultSkinIndex], new Skin(tDataArray[costumes.defaultSkinIndex]) );
					tButtons[costumes.defaultSkinIndex].ToggleOn();
				}
				i++;
			}
		}

		public function buttonPoseClickAfter(pEvent:Event):void {
			var pType:String = SHOP_ITEM_TYPE.POSE;
			var pInfoBar:ShopInfoBar = getInfoBarByType(pType);
			
			var tTarget:GUI.SpritePushButton = pEvent.target as GUI.SpritePushButton;
			var tButton:GUI.SpritePushButton = null;
			var tData:ShopItemData = null;
			var tDataArray:Array = costumes.getArrayByType(pType);
			
			var tButtons:Array = getButtonArrayByType(pType);
			var i:int = 0;
			while (i < tButtons.length) {
				tButton = tButtons[i] as GUI.SpritePushButton;
				tData = tDataArray[tButton.id];
				
				if (tButton.id != tTarget.id) {
					if (tButton.Pushed) { tButton.ToggleOff(); }
				}
				else if (tButton.Pushed) {
					setCurItemID(pType, tButton.id);
					this.character.updatePose(tData.itemClass);
					
					pInfoBar.addInfo( tData, new MovieClip() );
					pInfoBar.colorWheelActive = false;
				} else {
					this.character.updatePose(tDataArray[costumes.defaultPoseIndex].itemClass);
					pInfoBar.addInfo( tDataArray[costumes.defaultPoseIndex], new MovieClip() );
					tButtons[costumes.defaultPoseIndex].ToggleOn();
				}
				i++;
			}
		}

		/*public function buttonClickBefore(pEvent:Event):void { toggleItemBefore(this.buttons_head); }
		public function buttonEyesClickBefore(pEvent:Event):void { toggleItemBefore(this.buttons_eyes); }
		public function buttonEarsClickBefore(pEvent:Event):void { toggleItemBefore(this.buttons_ears); }
		public function buttonMouthClickBefore(pEvent:Event):void { toggleItemBefore(this.buttons_mouth); }
		public function buttonNeckClickBefore(pEvent:Event):void { toggleItemBefore(this.buttons_neck); }
		
		private function toggleItemBefore(pItemArray:Array) : void {
			var tButton:GUI.SpritePushButton = null;
			var i:int = 0;
			while (i < pItemArray.length) {
				tButton = pItemArray[i] as GUI.SpritePushButton;
				if (tButton.Pushed) {
					tButton.Unpressed();
					tButton.Pushed = false;
				}
				++i;
			}
		}*/

		public function removeGunClicked(pEvent:Event):void { _removeItem(SHOP_ITEM_TYPE.PRIMARY_WEAPON); }
		public function removeHairClicked(pEvent:Event):void { _removeItem(SHOP_ITEM_TYPE.HAIR); }
		
		private function _removeItem(pType:String) : void {
			if(getInfoBarByType(pType).hasData == false) { return; }
			this.character.removeItem(pType);
			getInfoBarByType(pType).removeInfo();
			getButtonArrayByType(pType)[ getCurItemID(pType) ].ToggleOff();
		}
		public function removeSkinClicked(pEvent:Event):void {
			var pType:String = SHOP_ITEM_TYPE.SKIN;
			var tDataArray:Array = costumes.getArrayByType(pType);
			
			this.character.addItem(pType, tDataArray[costumes.defaultSkinIndex]);
			getInfoBarByType(pType).addInfo( tDataArray[costumes.defaultSkinIndex], new Skin(tDataArray[costumes.defaultSkinIndex]) );
			getButtonArrayByType(pType)[ getCurItemID(pType) ].ToggleOff();
			getButtonArrayByType(pType)[costumes.defaultSkinIndex].ToggleOn();
		}
		public function removePoseClicked(pEvent:Event):void {
			var pType:String = SHOP_ITEM_TYPE.POSE;
			var tDataArray:Array = costumes.getArrayByType(pType);
			
			this.character.updatePose(tDataArray[costumes.defaultPoseIndex].itemClass);
			getInfoBarByType(pType).addInfo( tDataArray[costumes.defaultPoseIndex], new MovieClip() );
			getButtonArrayByType(pType)[ getCurItemID(pType) ].ToggleOff();
			getButtonArrayByType(pType)[costumes.defaultPoseIndex].ToggleOn();
		}
		
		private function getTabByType(pType:String) : GUI.Tab {
			return tabPanesMap[pType];
		}
		
		private function getCurItemID(pType:String) : int {
			return getTabByType(pType).selectedButton;
		}
		
		private function setCurItemID(pType:String, pID:int) : void {
			getTabByType(pType).selectedButton = pID;
		}
		
		private function getInfoBarByType(pType:String) : GUI.ShopInfoBar {
			return getTabByType(pType).infoBar;
		}
		
		private function getButtonArrayByType(pType:String) : Array {
			return getTabByType(pType).buttons;
		}

		public function HideAllTabs() : void
		{
			for(var i = 0; i < this.tabPanes.length; i++) {
				_hideTab(this.tabPanes[ i ]);
			}
			//_hideTab(this.tabColorPane);
		}
		
		internal function _hideTab(pTab:GUI.Tab) : void {
			if(!pTab.active) { return; }
			
			pTab.active = false;
			try {
				this.shop.removeChild(pTab);
			} catch (e:Error) { };
		}

		internal function setupSwatches(pSwatches:Array):*
		{
			var tLength:int = pSwatches.length;
			
			for(var i = 0; i < colorSwatches.length; i++) {
				colorSwatches[i].alpha = 0;
				
				if (tLength > i) {
					this.colorSwatches[i].alpha = 1;
					this.colorSwatches[i].Value = pSwatches[i];
					if (this.selectedSwatch == i) {
						this.psColorPick.setCursor(this.colorSwatches[i].TextValue);
					}
				}
			}
			if (tLength > 9) {
				trace("!!! more than 9 colors !!!");
			}
		}

		/*public function colorBtnHairClicked(pEvent:Event):void { _colorClicked(SHOP_ITEM_TYPE.HAIR); }
		public function colorBtnGunClicked(pEvent:Event):void { _colorClicked(SHOP_ITEM_TYPE.PRIMARY_WEAPON); }
		
		private function _colorClicked(pType:String) : void {
			if(this.character.getItem(pType) == null) { return; }
			if(getInfoBarByType(pType).colorWheelActive == false) { return; }
			
			this.selectSwatch(0, false);
			this.HideAllTabs();
			this.tabColorPane.active = true;
			var tData:ShopItemData = getInfoBarByType(pType).data;
			this.tabColorPane.infoBar.addInfo( tData, costumes.copyColor(this.character.getItem(pType), new tData.itemClass()) );
			this.currentlyColoringType = pType;
			this.setupSwatches( this.character.getColors(pType) );
			this.shop.addChild(this.tabColorPane);
		}*/

		internal function defaults_btnClicked(pEvent:Event) : void
		{
			var tMC:MovieClip = this.character.getItem(this.currentlyColoringType);
			if (tMC != null) 
			{
				costumes.colorDefault(tMC);
				costumes.copyColor( tMC, getButtonArrayByType(this.currentlyColoringType)[ getCurItemID(this.currentlyColoringType) ].Image );
				costumes.copyColor(tMC, getInfoBarByType(this.currentlyColoringType).Image);
				costumes.copyColor(tMC, this.tabColorPane.infoBar.Image);
				this.setupSwatches( this.character.getColors(this.currentlyColoringType) );
			}
		}
		
		function colorPickerBackClicked(pEvent:Event):void {
			_tabClicked( getTabByType( this.tabColorPane.infoBar.data.type ) );
		}

		internal function colorSwatch1OnEnterPressed(pEvent:Event) : void { this.selectSwatch(0); }
		internal function colorSwatch2OnEnterPressed(pEvent:Event) : void { this.selectSwatch(1); }
		internal function colorSwatch3OnEnterPressed(pEvent:Event) : void { this.selectSwatch(2); }
		internal function colorSwatch4OnEnterPressed(pEvent:Event) : void { this.selectSwatch(3); }
		internal function colorSwatch5OnEnterPressed(pEvent:Event) : void { this.selectSwatch(4); }
		internal function colorSwatch6OnEnterPressed(pEvent:Event) : void { this.selectSwatch(5); }
		internal function colorSwatch7OnEnterPressed(pEvent:Event) : void { this.selectSwatch(6); }
		internal function colorSwatch8OnEnterPressed(pEvent:Event) : void { this.selectSwatch(7); }
		internal function colorSwatch9OnEnterPressed(pEvent:Event) : void { this.selectSwatch(8); }

		function colorSwatch1OnClick(pEvent:Event):void { this.selectSwatch(0); }
		function colorSwatch2OnClick(pEvent:Event):void { this.selectSwatch(1); }
		function colorSwatch3OnClick(pEvent:Event):void { this.selectSwatch(2); }
		function colorSwatch4OnClick(pEvent:Event):void { this.selectSwatch(3); }
		function colorSwatch5OnClick(pEvent:Event):void { this.selectSwatch(4); }
		function colorSwatch6OnClick(pEvent:Event):void { this.selectSwatch(5); }
		function colorSwatch7OnClick(pEvent:Event):void { this.selectSwatch(6); }
		function colorSwatch8OnClick(pEvent:Event):void { this.selectSwatch(7); }
		function colorSwatch9OnClick(pEvent:Event):void { this.selectSwatch(8); }
		
		internal function selectSwatch(pNum:int, pSetCursor:Boolean=true) : void {
			for(var i = 0; i < colorSwatches.length; i++) {
				colorSwatches[i].unselect();
			}
			this.selectedSwatch = pNum;
			colorSwatches[pNum].select();
			if(pSetCursor) { this.psColorPick.setCursor(this.colorSwatches[pNum].TextValue); }
		}
		
		internal function __setProp_scaleSlider_Scene1_Layer1_0():*
		{
			try {
				this.scaleSlider["componentInspectorSetting"] = true;
			}
			catch (e:Error) { };
			
			this.scaleSlider.direction = "horizontal";
			this.scaleSlider.enabled = true;
			this.scaleSlider.liveDragging = false;
			this.scaleSlider.maximum = 10;
			this.scaleSlider.minimum = 1;
			this.scaleSlider.snapInterval = 0;
			this.scaleSlider.tickInterval = 0;
			this.scaleSlider.value = 6;
			this.scaleSlider.visible = true;
			
			try {
				this.scaleSlider["componentInspectorSetting"] = false;
			}
			catch (e:Error) { };
		}
	}
}
