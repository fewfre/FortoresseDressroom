package app
{
	import app.data.*;
	import app.ui.LoaderDisplay;
	import app.world.World;
	
	import com.fewfre.utils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.system.Capabilities;

	public class Main extends MovieClip
	{
		// Storage
		private var _loaderDisplay	: LoaderDisplay;
		private var _world			: World;
		private var _config			: Object;
		private var _defaultLang	: String;

		// Constructor
		public function Main() {
			super();
			
			if (stage) {
				this._start();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, this._start);
			}
		}
		
		private function _start(...args:*) {
			Fewf.init(stage, this.loaderInfo.parameters.swfUrlBase);
			
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.frameRate = 10;

			BrowserMouseWheelPrevention.init(stage);

			_loaderDisplay = addChild( new LoaderDisplay({ x:stage.stageWidth * 0.5, y:stage.stageHeight * 0.5 }) );
			
			_startPreload();
		}
		
		private function _startPreload() : void {
			Fewf.assets.load([
				Fewf.swfUrlBase+"resources/config.json",
			]);
			Fewf.assets.addEventListener(AssetManager.LOADING_FINISHED, _onPreloadComplete);
		}
		
		private function _onPreloadComplete(event:Event) : void {
			Fewf.assets.removeEventListener(AssetManager.LOADING_FINISHED, _onPreloadComplete);
			_config = Fewf.assets.getData("config");
			_defaultLang = _getDefaultLang(_config.languages["default"]);
			
			_startInitialLoad();
		}
		
		private function _startInitialLoad() : void {
			Fewf.assets.load([
				Fewf.swfUrlBase+"resources/i18n/"+_defaultLang+".json",
			]);
			Fewf.assets.addEventListener(AssetManager.LOADING_FINISHED, _onInitialLoadComplete);
		}
		
		private function _onInitialLoadComplete(event:Event) : void {
			Fewf.assets.removeEventListener(AssetManager.LOADING_FINISHED, _onInitialLoadComplete);
			Fewf.i18n.parseFile(_defaultLang, Fewf.assets.getData(_defaultLang));
			
			_startLoad();
		}
		
		// Start main load
		private function _startLoad() : void {
			Fewf.assets.load([
				[Fewf.swfUrlBase+"resources/interface.swf", { useCurrentDomain:true }],
				Fewf.swfUrlBase+"resources/flags.swf",
				// Game assets
				Fewf.swfUrlBase+"resources/resources.swf",
			]);
			Fewf.assets.addEventListener(AssetManager.LOADING_FINISHED, _onLoadComplete);
		}

		private function _onLoadComplete(event:Event) : void {
			Fewf.assets.removeEventListener(AssetManager.LOADING_FINISHED, _onLoadComplete);
			_loaderDisplay.destroy();
			removeChild( _loaderDisplay );
			_loaderDisplay = null;
			
			_world = addChild(new World(stage));
		}
		
		private function _getDefaultLang(pConfigLang:String) : String {
			var tFlagDefaultLangExists = false;
			// http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#language
			if(Capabilities.language) {
				var tLanguages = _config.languages.list;
				for each(tLang in tLanguages) {
					if(Capabilities.language == tLang.code || Capabilities.language == tLang.code.split("-")[0]) {
						return tLang.code;
					}
					if(pConfigLang == tLang.code) {
						tFlagDefaultLangExists = true;
					}
				}
			}
			return tFlagDefaultLangExists ? pConfigLang : "en";
		}
	}
}
