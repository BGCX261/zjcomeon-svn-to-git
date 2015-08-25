package zjMap.MapCurosr
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * 
	 * 拖动地图时改变鼠标指针图形
	 * 手掌打开
	 * 
	 * */
	
	public class CursorOpenHand extends Sprite
	{
		private var openhandLoader:Loader;
		private var openhand:String = "images/cursor/openhand.png";
		
		private var open:Sprite;
		
		public function CursorOpenHand()
		{
			super();

			openhandLoader =new Loader();
			openhandLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_open);
			openhandLoader.load(new URLRequest(openhand));
		}
		
		private function onLoadComplete_open(evt:Event):void{
			
			var image:Bitmap = Bitmap(openhandLoader.content);  
			image.width = 16;
			image.height = 16;
			
			this.addChild(image);
		}
	}
}