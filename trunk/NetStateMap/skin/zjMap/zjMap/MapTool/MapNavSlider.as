package zjMap.MapTool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.controls.HSlider;
	import mx.controls.sliderClasses.Slider;
	import mx.controls.sliderClasses.SliderDirection;
	import mx.core.UIComponent;
	
	public class MapNavSlider extends UIComponent
	{
		
		public var slider:Slider = new Slider();;
		private var _sliderWidth:Number;
		private var _sliderDir:String;
		
		public var slider_center:UIComponent;
		public var zoomIn:UIComponent = new UIComponent();
		public var zoomOut:UIComponent = new UIComponent();
		
		private var url_center:String = "skin/map_VSliderTrack_Skin2.png";
		private var url_left:String = "skin/map_Slider_left.png";
		private var url_right:String = "skin/map_Slider_right.png";
		private var centerLd:Loader;
		private var leftLd:Loader;
		private var rightLd:Loader;
		
		/**
		 * 
		 * @param w:宽度
		 * 
		 * */
		public function MapNavSlider(w:Number,dir:String=null)
		{
			super();
			
			sliderWidth = w - 40;//减40是为左右两侧按钮让出区域

			loadSliderBtn();
			
		}
		
		
		private function loadSliderBtn():void{
			leftLd = new Loader();
			leftLd.name = "leftLd";
			leftLd.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_leftbtn);
			leftLd.load(new URLRequest(url_left));	
			
			centerLd = new Loader();
			centerLd.name = "centerLd";
			centerLd.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_centerbtn);
			centerLd.load(new URLRequest(url_center));	
			
			rightLd = new Loader();
			rightLd.name = "rightLd";
			rightLd.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_rightbtn);
			rightLd.load(new URLRequest(url_right));		
		}
		
		private function onLoadComplete_leftbtn(evt:Event):void{
			var image:Bitmap = Bitmap(leftLd.content);  
			var imgData:BitmapData = image.bitmapData;  
			image.width = 20;
			image.height = 30;
			
			
			//zoomIn.graphics.lineStyle(0,0x000000);
			zoomIn.graphics.drawRect(0,0,20,30);
			addChild(zoomIn);

			zoomIn.x = 0;
			
			zoomIn.addChild(image);
			
			zoomIn.useHandCursor = true;
			zoomIn.buttonMode = true;
		}
		private function onLoadComplete_rightbtn(evt:Event):void{
			var image:Bitmap = Bitmap(rightLd.content);  
			var imgData:BitmapData = image.bitmapData;  
			image.width = 20;
			image.height = 30;
			
			//zoomOut.graphics.lineStyle(0,0x000000);
			zoomOut.graphics.drawRect(0,0,20,30);
			addChild(zoomOut);
			
			zoomOut.x = sliderWidth + 20; //中间宽度 + 按钮宽度
			
			zoomOut.addChild(image);
			
			zoomOut.useHandCursor = true;
			zoomOut.buttonMode = true;
		}
		
		private function onLoadComplete_centerbtn(evt:Event):void{
			var image:Bitmap = Bitmap(centerLd.content);  
			var imgData:BitmapData = image.bitmapData;  
			
			slider_center = new UIComponent();
			slider_center.graphics.lineStyle(0,0xff0000);
			slider_center.graphics.beginBitmapFill(imgData);
			slider_center.graphics.drawRect(0,0,sliderWidth,30);
			slider_center.graphics.endFill();
			addChild(slider_center);
			slider_center.x = 20;

			
			
			slider.styleName = "MapNavSlider";
			//slider.labels = ["min","max"];
			slider.value = 1;
			slider.maximum = 1.6;
			slider.minimum = 0.4;
			//slider.tickValues = [0,0.5,1,1.5,2];
			//slider.tickInterval = 0.3;
			slider.snapInterval = 0.3;
			
			slider.showDataTip = false;
			slider.liveDragging = true;
			slider.useHandCursor = true;
			slider.buttonMode = true;
			slider_center.addChild(slider);
			
			slider.width = sliderWidth;
			slider.x = 0;
			slider.y = 10;
		}

		public function get sliderWidth():Number
		{
			return _sliderWidth;
		}

		public function set sliderWidth(value:Number):void
		{
			_sliderWidth = value;
		}

		public function get sliderDir():String
		{
			return _sliderDir;
		}

		public function set sliderDir(value:String):void
		{
			_sliderDir = value;
		}

		

	}
}