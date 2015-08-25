package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	import mx.preloaders.Preloader;
	public class zjPreloader extends Sprite implements IPreloaderDisplay
	{
		[Embed(source="images/loadswf.swf", symbol="zjPreLoad")]
		private var LoaderMC:Class;
		private var _loader_mc:MovieClip
		
		private var _preloader:Preloader;
		
		public function zjPreloader()
		{
			super();
			this._loader_mc = new LoaderMC()
			this.addChild(this._loader_mc);
			//this._loader_mc.gotoAndStop(50)
			
		}
		
		public function get backgroundAlpha():Number
		{
			return 0;
		}
		
		public function set backgroundAlpha(value:Number):void
		{
		}
		
		public function get backgroundColor():uint
		{
			return 0;
		}
		
		public function set backgroundColor(value:uint):void
		{
		}
		
		public function get backgroundImage():Object
		{
			return null;
		}
		
		public function set backgroundImage(value:Object):void
		{
		}
		
		public function get backgroundSize():String
		{
			return null;
		}
		
		public function set backgroundSize(value:String):void
		{
		}
		
		public function set preloader(obj:Sprite):void
		{
			_preloader = obj as Preloader;
			_preloader.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE,initCompleteEventHandler);
		}
		
		public function get stageHeight():Number
		{
			return 0;
		}
		
		public function set stageHeight(value:Number):void
		{
		}
		
		public function get stageWidth():Number
		{
			return 0;
		}
		
		public function set stageWidth(value:Number):void
		{
		}
		
		public function initialize():void
		{
			_loader_mc.x = stage.stageWidth / 2 - _loader_mc.width/2;
			_loader_mc.y = stage.stageHeight / 2 - _loader_mc.height/2;
		}
		
		private function progressEventHandler(eo:ProgressEvent):void
		{
			
			//_loader_mc.gotoAndStop(Math.round((eo.bytesLoaded / eo.bytesTotal )*100))
			//_loader_mc.show_txt.text =Math.round((eo.bytesLoaded / eo.bytesTotal )*100)+" %"
		}
		
		private function initCompleteEventHandler(eo:FlexEvent):void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
	}
}