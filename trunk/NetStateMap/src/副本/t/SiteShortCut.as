package 副本.t
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SiteShortCut extends Sprite{
		
		private var ssc:Sprite;
		
		private var _defaultWidth:Number = 200;
		private var _defaultHeight:Number = 22;
		
		private var siteScTxt:TextField;
		private var textformat:TextFormat;
		
		private var _sscId:String;
		private var _sscCName:String;
		private var _sscEName:String;
		private var _sscPos:String;
		
		/**
		 * 
		 * 构造函数
		 * @param object ： json数据对象
		 * 					包含 id、cn、en、state
		 * */
		public function SiteShortCut(object:Object){
			
			super();
			
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			
			
			//设置属性
			this.sscCName = object.cn;
			this.sscEName = object.en;
			this.sscId = object.id;
			this.sscPos = object.pos;
			
			
			//创建显示文本
			siteScTxt = new TextField();
			
			siteScTxt.autoSize = TextFieldAutoSize.LEFT;
			//siteScTxt.width = 100;
			//siteScTxt.height = 30;
			siteScTxt.htmlText = object.en+"("+object.cn+")";	
			siteScTxt.x = 4;
			siteScTxt.y = 4;
			
			siteScTxt.selectable = false;
			siteScTxt.mouseEnabled = false;
			
			textformat = new TextFormat();
			textformat.size = 12;
			textformat.color = 0x000000;
			
			siteScTxt.setTextFormat(textformat);
			
			this.addChild(siteScTxt);
			
			var _buffer:Number = 4;
			var cfWidth:Number = this.siteScTxt.textWidth + ( _buffer * 2 );
			var cfHeight:Number = this.siteScTxt.textHeight + ( _buffer * 2 );
			this._defaultWidth = cfWidth < this._defaultWidth ? cfWidth : this._defaultWidth;
			this._defaultHeight = cfHeight < this._defaultHeight ? cfHeight : this._defaultHeight;
			drawBackground();
		}
		
		/**
		 * 
		 * 画背景
		 * */
		private function drawBackground():void{
			this.graphics.clear();
			this.graphics.lineStyle(1,0xbfbfbf);
			this.graphics.beginFill(0xeeeeee);
			this.graphics.drawRoundRect(0,0,_defaultWidth,30,6);
			this.graphics.endFill();
			//this.addChild(ssc);
		}

		public function get sscId():String
		{
			return _sscId;
		}

		public function set sscId(value:String):void
		{
			_sscId = value;
		}

		public function get sscCName():String
		{
			return _sscCName;
		}

		public function set sscCName(value:String):void
		{
			_sscCName = value;
		}

		public function get sscEName():String
		{
			return _sscEName;
		}

		public function set sscEName(value:String):void
		{
			_sscEName = value;
		}

		public function get sscPos():String
		{
			return _sscPos;
		}

		public function set sscPos(value:String):void
		{
			_sscPos = value;
		}


	}
}