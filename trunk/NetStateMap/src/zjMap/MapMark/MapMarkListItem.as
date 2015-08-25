package zjMap.MapMark
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class MapMarkListItem extends Sprite
	{
	
		private var _itemData:Object;
		
		private var _itemId:String;
		
		private var mark:Loader;
		private var marker_url:String = "images/marker/mm_20_white.png";
		
		
		private var paddingLeft:Number = 0;
		private var paddingTop:Number = 0;
		
		private var itemWidth:Number = 180;
		private var itemHeight:Number = 26;
		
		public var markSize:Number = 12;
		public var markWidth:Number = 50;
		public var markHeight:Number = 26;
		
		/**高亮颜色*/
		private var highlight:uint = 0x2C82C3;
		
		private var markerDescTxt:TextField;
		/**
		 * 
		 * @param data:标记数据
		 * */
		public function MapMarkListItem(data:Object){
			
			_itemData = data;
			
			_itemId = data.id;
			
			
			drawBackground();
			
			drawContent();
			
			
			this.useHandCursor = true;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onItemOver);
			
			
		}
		
		private function onItemOver(evt:MouseEvent):void{
			//markerDescTxt.textColor = highlight;
			
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize:0xcccccc, amount:1}});
			
			this.addEventListener(MouseEvent.MOUSE_OUT,onItemOut);
		}
		private function onItemOut(evt:MouseEvent):void{
			//markerDescTxt.textColor = 0x333333;
			
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize:0xffffff, amount:1},onComplete:function():void{
				TweenMax.killTweensOf(this);
			}});
				
			this.removeEventListener(MouseEvent.MOUSE_OUT,onItemOut);
		}
		
		/**
		 * 
		 * 绘制背景
		 * */
		private function drawBackground():void{
			this.graphics.lineStyle(0,0xffffff);
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,itemWidth,itemHeight);
			this.graphics.endFill();
			
		}
		/**
		 * 绘制图形 描述
		 * 
		 * */
		private function drawContent():void{
			//mark =new Loader();
			//mark.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_maker);
			//mark.load(new URLRequest(marker_url));
			
			
			markerDescTxt = new TextField();
			
			markerDescTxt.autoSize = TextFieldAutoSize.LEFT;
			
			markerDescTxt.text = itemData.cn;
			
			markerDescTxt.selectable = false;
			markerDescTxt.mouseEnabled = false;
			
			markerDescTxt.setTextFormat(new TextFormat(null,12,0x333333));
			
			//markerDescTxt.width = markWidth;
			//markerDescTxt.height = markHeight;
			
			this.addChild(markerDescTxt);
			
			markerDescTxt.x = 20;
			//markerDescTxt.y = paddingTop + 10 
		}
		
		private function onLoadComplete_maker(evt:Event):void{
			var image:Bitmap = Bitmap(mark.content);  
			image.width = markSize;
			image.height = markHeight;  
			
			this.addChild(image);
			
			
			image.x = paddingLeft + 10;
			image.y = paddingTop + 10;
			
		}
		
		

		public function get itemData():Object
		{
			return _itemData;
		}

		public function set itemData(value:Object):void
		{
			_itemData = value;
		}

		public function get itemId():String
		{
			return _itemId;
		}

		public function set itemId(value:String):void
		{
			_itemId = value;
		}


	}
}