package zjMap.MapTool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.controls.HSlider;
	import mx.controls.sliderClasses.Slider;
	import mx.controls.sliderClasses.SliderDirection;
	import mx.core.UIComponent;
	
	public class MapVSlider extends UIComponent
	{
		
		public var slider:Slider = new Slider();;
		private var _sliderHeight:Number;
		private var _sliderDir:String;
		
		private var _sliderInterval:Number;
		private var _sliderValue:Number;
		private var _sliderMax:Number;
		private var _sliderMini:Number;
		
		public var slider_center:UIComponent;
		public var zoomIn:UIComponent = new UIComponent();
		public var zoomOut:UIComponent = new UIComponent();
		
		private var url_center:String = "skin/map_VSliderTrack_Skin2_bg.png";
		private var url_up:String = "skin/map_Slider_up.png";
		private var url_down:String = "skin/map_Slider_down.png";
		private var centerLd:Loader;
		private var upLd:Loader;
		private var downLd:Loader;
		
		/**
		 * 
		 * @param h:高度
		 * @param interval:间隔
		 * @param value:当前值
		 * @param max:最大
		 * @param mini最小
		 * */
		public function MapVSlider(h:Number,interval:Number,value:Number,max:Number,mini:Number,dir:String=null)
		{
			super();
			
			sliderHeight = h - 24 - 24 -6;//减40是为左右两侧按钮让出区域
			
			_sliderInterval = interval;	//刻度间隔
			_sliderValue = value;		//当前值
			_sliderMax = max;			//最大
			_sliderMini = mini;			//最小
			
			drawBackground();
			
			
			loadSliderBtn();
			
		}
		
		/**
		 * 背景
		 * */
		private function drawBackground():void{
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRoundRect(0,0,30,200,6);
			this.graphics.endFill();
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.angle = 90;
			shadow.alpha = 0.32;
			shadow.color = 0x00000;
			this.filters = [shadow];
		}
		
		/**
		 * 按钮图标
		 * */
		private function loadSliderBtn():void{
			upLd = new Loader();
			upLd.name = "upLd";
			upLd.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_upbtn);
			upLd.load(new URLRequest(url_up));	
			
			centerLd = new Loader();
			centerLd.name = "centerLd";
			centerLd.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_centerbtn);
			centerLd.load(new URLRequest(url_center));	
			
			downLd = new Loader();
			downLd.name = "downLd";
			downLd.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_downbtn);
			downLd.load(new URLRequest(url_down));		
		}
		
		private function onLoadComplete_upbtn(evt:Event):void{
			var image:Bitmap = Bitmap(upLd.content);  
			var imgData:BitmapData = image.bitmapData;  
			image.width = 23;
			image.height = 24;
			
			
			//zoomIn.graphics.lineStyle(0,0x000000);
			zoomIn.graphics.drawRect(0,0,23,24);
			addChild(zoomIn);

			zoomIn.x = 3;
			zoomIn.y = 3;
			
			zoomIn.addChild(image);
			
			zoomIn.useHandCursor = true;
			zoomIn.buttonMode = true;
		}
		private function onLoadComplete_downbtn(evt:Event):void{
			var image:Bitmap = Bitmap(downLd.content);  
			var imgData:BitmapData = image.bitmapData;  
			image.width = 23;
			image.height = 24;
			
			//zoomOut.graphics.lineStyle(0,0x000000);
			zoomOut.graphics.drawRect(0,0,23,24);
			addChild(zoomOut);
			
			zoomOut.x = 3;
			zoomOut.y = sliderHeight + 24 + 3; //中间宽度 + 按钮宽度
			
			zoomOut.addChild(image);
			
			zoomOut.useHandCursor = true;
			zoomOut.buttonMode = true;
		}
		
		private function onLoadComplete_centerbtn(evt:Event):void{
			var image:Bitmap = Bitmap(centerLd.content);  
			var imgData:BitmapData = image.bitmapData;  
			
			slider_center = new UIComponent();
			//slider_center.graphics.lineStyle(0,0xff0000);
			slider_center.graphics.beginBitmapFill(imgData);
			slider_center.graphics.drawRect(0,0,15,sliderHeight);
			slider_center.graphics.endFill();
			addChild(slider_center);
			slider_center.x = 7;
			slider_center.y = 24+3;


			slider.styleName = "MapNavVSlider";
			slider.direction = SliderDirection.VERTICAL;

			//slider.labels = ["min","max"];
			slider.value = sliderInterval * sliderValue;
			slider.maximum = sliderInterval * sliderMax;
			slider.minimum = sliderInterval * sliderMini;
			//slider.tickValues = [0,0.5,1,1.5,2];
			//slider.tickInterval = 0.3;
			slider.snapInterval = sliderInterval;
			
			slider.showDataTip = true;
			slider.liveDragging = true;
			slider.useHandCursor = true;
			slider.buttonMode = true;
			slider_center.addChild(slider);
			
			slider.height = sliderHeight;
			slider.width = 20;
			slider.x = 0;
		}

		

		public function get sliderDir():String
		{
			return _sliderDir;
		}

		public function set sliderDir(value:String):void
		{
			_sliderDir = value;
		}

		public function get sliderHeight():Number
		{
			return _sliderHeight;
		}

		public function set sliderHeight(value:Number):void
		{
			_sliderHeight = value;
		}

		public function get sliderInterval():Number
		{
			return _sliderInterval;
		}

		public function set sliderInterval(value:Number):void
		{
			_sliderInterval = value;
		}

		public function get sliderValue():Number
		{
			return _sliderValue;
		}

		public function set sliderValue(value:Number):void
		{
			_sliderValue = value;
		}

		public function get sliderMax():Number
		{
			return _sliderMax;
		}

		public function set sliderMax(value:Number):void
		{
			_sliderMax = value;
		}

		public function get sliderMini():Number
		{
			return _sliderMini;
		}

		public function set sliderMini(value:Number):void
		{
			_sliderMini = value;
		}

		

	}
}