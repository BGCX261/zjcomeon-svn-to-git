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
	 * 
	 * 手掌闭合
	 * */
	
	public class CursorCloseHand extends Sprite
	{
		private var closehandLoader:Loader;
		private var closehand:String = "images/cursor/closehand.png";
		
		public function CursorCloseHand()
		{
			super();

			closehandLoader =new Loader();
			closehandLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_close);
			closehandLoader.load(new URLRequest(closehand));
		}
		
		private function onLoadComplete_close(evt:Event):void{
			
			var image:Bitmap = Bitmap(closehandLoader.content);  
			image.width = 16;
			image.height = 16;
			
			this.addChild(image);
		}
		
	}
}