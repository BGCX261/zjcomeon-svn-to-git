package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	import spark.components.Spinner;
	

	public class Person extends UIComponent
	{
		//基础
		private var baseSprit:Sprite;
		
		//图片加载器
		public var baseImage:Loader
		
		
		private static var defaultState="image/1_02.gif"; 
		
		private static var upState="image/1_11.gif";
		private static var downState="image/1_02.gif";
		private static var leftState="image/1_05.gif";
		private static var rightState="image/1_08.gif";
		
		public function Person()
		{
			
			baseSprit=new Sprite();
			baseSprit.graphics.beginFill(0xff0000);
			baseSprit.graphics.drawRect(0,0,32,32);
			baseSprit.graphics.endFill()
			this.addChild(baseSprit);
			
			baseImage=new Loader();
			
			baseImage.addEventListener(Event.COMPLETE, completeHandler);
			baseImage.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			baseImage.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			
			baseImage.load(new URLRequest(defaultState));
			
			//baseSprit.addChild(baseImage);
			this.addChild(baseImage);
			
		}

		public function changeMoveState(state:String):void{
			switch(state){
				case "up":
					baseImage.unload();
					baseImage.load(new URLRequest(upState));
					break;
				
				case "down":
					baseImage.unload();
					baseImage.load(new URLRequest(downState));
					break;
				
				case "left":
					baseImage.unload();
					baseImage.load(new URLRequest(leftState));
					break;
				
				case "right":
					baseImage.unload();
					baseImage.load(new URLRequest(rightState));
					break;
			}
		}
		
		private function completeHandler():void{
			
		}
		
		private function progressHandler():void{
			
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void{
			Alert.show("加载错误");
		}
	}
}