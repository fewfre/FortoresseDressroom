package app
{
	import app.data.*;
	import app.ui.LoaderDisplay;
	import app.world.World;
	
	import com.fewfre.utils.*;

	import flash.display.*;
	import flash.events.*;

	public class Main extends MovieClip
	{
		// Storage
		private var _loaderDisplay	: LoaderDisplay;
		private var _world			: World;

		// Constructor
		public function Main() {
			super();
			Fewf.init();
			
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 10;
			
			BrowserMouseWheelPrevention.init(stage);
			
			// Start preload
			Fewf.assets.load([
				"resources/config.json",
			]);
			Fewf.assets.addEventListener(AssetManager.LOADING_FINISHED, _onPreloadComplete);

			_loaderDisplay = addChild( new LoaderDisplay({ x:stage.stageWidth * 0.5, y:stage.stageHeight * 0.5 }) );
		}
		
		private function _onPreloadComplete(event:Event) : void {
			Fewf.assets.removeEventListener(AssetManager.LOADING_FINISHED, _onPreloadComplete);
			ConstantsApp.lang = Fewf.assets.getData("config").language;
			
			// Start main load
			Fewf.assets.load([
				"resources/resources.swf",
				"resources/i18n/"+ConstantsApp.lang+".json",
			]);
			Fewf.assets.addEventListener(AssetManager.LOADING_FINISHED, _onLoadComplete);
		}

		private function _onLoadComplete(event:Event) : void {
			Fewf.assets.removeEventListener(AssetManager.LOADING_FINISHED, _onLoadComplete);
			_loaderDisplay.destroy();
			removeChild( _loaderDisplay );
			_loaderDisplay = null;
			
			Fewf.i18n.parseFile(Fewf.assets.getData(ConstantsApp.lang));
			
			_world = addChild(new World(stage));
		}
	}
}
