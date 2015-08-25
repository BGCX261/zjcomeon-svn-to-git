package zjMap.MapTool
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;

	public class MapLock extends Sprite
	{
		
		private var url_lock:String = "images/lock/lock.png";
		private var url_unlock:String = "images/lock/unlock.png";
		
		private var lockLd:Loader;

		private var _lockState:Boolean;
		
		public function MapLock(state:Boolean){
			
			_lockState = state;
			
			drawBackground();
			
			createLockBtn();
			
			this.addEventListener(MouseEvent.CLICK,onToggleMapLock);
		}
		
		/**
		 * 背景
		 * */
		private function drawBackground():void{
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRoundRect(0,0,30,30,6);
			this.graphics.endFill();
		}
		
		/**
		 * 创建加载器
		 * */
		private function createLockBtn():void{
			lockLd =new Loader();
			lockLd.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete_lock);
			loadLockIcon(url_unlock);
		}
		private function loadComplete_lock(evt:Event):void{
			//this.removeChildAt(0);
			if(this.numChildren > 0){
				this.removeChildAt(0);
			}
			
			var image:Bitmap = Bitmap(lockLd.content);
			this.addChild(image);
			image.x = 3;
			
		}
		/**
		 * 加载图标
		 * */
		private function loadLockIcon(url:String):void{
			lockLd.load(new URLRequest(url));
		}
		
		
		/**
		 * 设置锁状态
		 * */
		private function onToggleMapLock(evt:MouseEvent):void{
			if(lockState){
				lockState = false;
				
				loadLockIcon(url_unlock);
				
			}else{
				lockState = true;
				
				loadLockIcon(url_lock);
			}
		}

		public function get lockState():Boolean
		{
			return _lockState;
		}

		public function set lockState(value:Boolean):void
		{
			_lockState = value;
		}

	}
}