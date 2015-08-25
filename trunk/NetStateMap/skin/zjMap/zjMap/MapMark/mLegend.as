package zjMap.MapMark
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.controls.Alert;
	
	public class mLegend extends Sprite
	{
		private var loader:Loader;
		private var txt:TextField;
		
		/**图标宽*/
		private var _lw:Number;
		private var _lh:Number;
		/**描述*/
		private var _desc:String;
		/**图标+文本宽度*/
		private var _ltWidth:Number;
		private var _ltHeight:Number;
		
		public function mLegend(url:String,str:String,width:Number,height:Number)
		{
			super();
			

			_desc = str;
			
			_ltWidth = width;
			
			_ltHeight = height;
			
			/*this.graphics.beginFill(0xffffff,0.4);
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill();*/
			
			drawIcon(url);
			
			
		}
		
		private function drawIcon(url:String):void{
			loader =new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderCompleteHandler);
			
			loader.load(new URLRequest(url));
		}
		private function loaderCompleteHandler(evt:Event):void{
			
			var image:Bitmap = Bitmap(loader.content);
			this.addChild(image);	
			
			
			lw = loader.content.width;
			lh = loader.content.height;
			
			image.y = (ltHeight - lh)/2;
			image.x = 10;
			
			image.filters = [ new DropShadowFilter(1,45,0,1,1)]
			
			drawText();
		}
		
		private function drawText():void{
			txt = new TextField();
			
			txt.autoSize = TextFieldAutoSize.LEFT;
			
			
			txt.wordWrap = true;	//自动换行
			
			txt.htmlText = desc;
			
			txt.selectable = false;
			txt.mouseEnabled = false;
			
			txt.filters = [ new DropShadowFilter(1,45,0,1,1)]
			
			var tf:TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0xffffff;
			tf.bold = false;
			
			txt.setTextFormat(tf);

			this.addChild(txt);
			
			
			if(txt.length > 10){
				tf.align = TextFormatAlign.LEFT;
				txt.width = txt.textWidth - 10;
			}
			
			txt.y = (ltHeight - txt.textHeight)/2 - 2;
			txt.x = lw + 15;
			
			//Alert.show(txt.length+"")
			
			

		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get lw():Number
		{
			return _lw;
		}

		public function set lw(value:Number):void
		{
			_lw = value;
		}

		public function get lh():Number
		{
			return _lh;
		}

		public function set lh(value:Number):void
		{
			_lh = value;
		}

		public function get ltWidth():Number
		{
			return _ltWidth;
		}

		public function set ltWidth(value:Number):void
		{
			_ltWidth = value;
		}

		public function get ltHeight():Number
		{
			return _ltHeight;
		}

		public function set ltHeight(value:Number):void
		{
			_ltHeight = value;
		}


	}
}