package zjMap.MapTool
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;

	public class MarkMove extends UIComponent
	{
		
		private var url_lock:String = "images/marker/immovable.png";
		private var url_unlock:String = "images/marker/movable.png";
		
		private var lockLd:Loader;

		private var _lockState:Boolean;
		
		public function MarkMove(state:Boolean){
			
			super();
			
			drawBackground();
			
			createLockBtn();
			
			//this.addEventListener(MouseEvent.CLICK,onToggleMapLock);
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
			
		}
		/**
		 * 加载图标
		 * */
		private function loadLockIcon(url:String):void{
			lockLd.load(new URLRequest(url));
		}
		
		
		/**
		 * 调用外部函数
		 * */
		public function onLockEvent():void{
			
			this.parentApplication.setMakerMove(lockState);
				
		}
		
		/**
		 * 外部设置开关图标
		 * */
		public function setLockStateIcon(tf:Boolean):void{
			if(tf){
				
				loadLockIcon(url_lock);
				
			}else{
				
				loadLockIcon(url_unlock);
			}
			
			onLockEvent();
		}

		public function get lockState():Boolean
		{
			return _lockState;
		}

		public function set lockState(value:Boolean):void
		{
			_lockState = value;
			
			setLockStateIcon(value);
		}


	}
}