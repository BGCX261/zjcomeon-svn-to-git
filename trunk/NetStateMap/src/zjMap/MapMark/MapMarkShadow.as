package zjMap.MapMark
{
	
	import com.hybrid.ui.ToolTip1;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	
	
	public class MapMarkShadow extends Sprite
	{
		private var _shadowId:String;		//编号
		
		private var _locPos:Point;		//本地坐标 xml
		private var _glPos:Point;		//全局坐标 转化
		
		private var _objData:Object;
		
		private var makerShadow_url:String = "images/marker/shadow50.png"
		private var makerShadowLoader:Loader;
		
		private var shadowWidth:Number = 27;
		private var shadowHeight:Number = 20;
		

		public function MapMarkShadow(data:Object){
			super();
			
			
			_objData = data;
	
			this.shadowId = "shadow-"+_objData.id;
			
			_locPos = data.loc_pos;
			_glPos = data.gl_pos; 
			
			drawMakerOrShadow();
			
		}
		
		/**
		 * 
		 * 加载 标记和影子
		 * */
		private function drawMakerOrShadow():void{
			makerShadowLoader =new Loader();
			makerShadowLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_makerShadow);
			makerShadowLoader.load(new URLRequest(makerShadow_url));
			
		}
		
		/**
		 * 添加标记影子
		 * */
		private function onLoadComplete_makerShadow(evt:Event):void{
			var image:Bitmap = Bitmap(makerShadowLoader.content);  
			var topImgData:BitmapData = image.bitmapData;  
			image.width = shadowWidth;
			image.height = shadowHeight;  
			
		/*	this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,image.width,image.height);
			this.graphics.endFill();*/
			
			image.x = -3;
			image.y = -shadowHeight;
			
			this.addChild(image);
		}

		
		
		
	

		
		public function get objData():Object
		{
			return _objData;
		}

		public function set objData(value:Object):void
		{
			_objData = value;
		}

		
		/**本地坐标点*/
		public function get locPos():Point
		{
			return _locPos;
		}

		/**
		 * @private
		 */
		public function set locPos(value:Point):void
		{
			_locPos = value;
		}

		/**全局坐标*/
		public function get glPos():Point
		{
			return _glPos;
		}

		/**
		 * @private
		 */
		public function set glPos(value:Point):void
		{
			_glPos = value;
		}

		public function get shadowId():String
		{
			return _shadowId;
		}

		public function set shadowId(value:String):void
		{
			_shadowId = value;
		}

	
	}
}