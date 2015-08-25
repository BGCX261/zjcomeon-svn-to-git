package zjMap.MapMark
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.controls.Alert;
	
	public class OceanIsle extends Sprite
	{
		private var txt:TextField;
		private var _oiData:Object;
		
		public function OceanIsle(data:Object)
		{
			super();
			
			_oiData = data;
			
			/*this.graphics.beginFill(0xff0000);
			this.graphics.drawRect(0,0,10,10);
			this.graphics.endFill();*/
			
			createTxt();
		}
		
		private function createTxt():void{
			
			txt = new TextField();
			
			txt.autoSize = TextFieldAutoSize.LEFT;
			
			txt.text = oiData.text;
			
			txt.selectable = false;
			txt.mouseEnabled = false;
			
			txt.setTextFormat(new TextFormat(null,16,0xffffff,true));
			
			this.addChild(txt);
			
		}

		public function get oiData():Object
		{
			return _oiData;
		}

		public function set oiData(value:Object):void
		{
			_oiData = value;
		}

	}
}