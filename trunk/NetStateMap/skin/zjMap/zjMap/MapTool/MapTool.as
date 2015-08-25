package zjMap.MapTool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.sliderClasses.Slider;
	import mx.controls.sliderClasses.SliderDirection;
	import mx.core.UIComponent;
	
	import spark.components.HSlider;
	
	public class MapTool extends UIComponent
	{
		
		private var navWidth:Number = 240;
		private var navHeight:Number = 100;
		private var btnSpriteSize:Number = 32;

		/**刻度*/
		public var zVSlider:MapVSlider;
		/**默认刻度间隔*/
		public var zVSliderInterval:Number = 0.1;
		public var zVSliderValue:Number = 30;
		public var zVSliderMaxVal:Number = 80;
		public var zVSliderMiniVal:Number = 10;
		
		/**纵列间隔*/
		private var topGap:Number = 0;
		
		/**按钮组对象*/
		private var toolBtnGroupSelected:*;
		private var toolBtnGroupArr:ArrayCollection = new ArrayCollection();
		/**地图锁*/
		private var zLock:MapLock;
		private var _show_lock:Boolean;
		/**标记移动锁*/
		private var zMove:MarkMove;
		private var _show_move:Boolean;
		/**标记链接锁*/
		private var zConnect:MarkToConnect;
		private var _show_conn:Boolean;
		
		/**
		 * 工具
		 * 
		 * @mapScale:	缩放当前值 由地图组提供
		 * @lock:		地图拖动锁
		 * @move:		标记位置编辑锁
		 * @conn:		标记连接锁
		 * */
		public function MapTool(mapScale:Number = 1,lock:Boolean = true, move:Boolean = true, conn:Boolean = true)
		{
			super();

			_show_lock = lock;	/**显示开关*/
			_show_move = move;	/**显示开关*/
			_show_conn = conn;	/**显示开关*/

			if(lock){
				drawLock(false);
			}
			if(move){
				drawMarkMove(false);
			}
			if(conn){
				drawMarkConnect(false);
			}
			trace("init move:",zMove.lockState)
			trace("init conn:",zConnect.lockState)
			
			drawZoomSlider("VERTICAL");
			
			
			this.addEventListener(MouseEvent.CLICK,toggleToolButton);

		}
		
		/**
		 * 
		 * 绘制锁(用于固定地图位置) 
		 * 
		 * */
		private function drawLock(state:Boolean):void{
			zLock = new MapLock(state);
			
			this.addChild(zLock);
			
			zLock.useHandCursor = true;
			zLock.buttonMode = true;
			
			
			topGap += 32;
			
			//toolBtnGroupArr.push(zLock);
		}
		
		/**
		 * 
		 * 绘制标记移动按钮
		 * 
		 * */
		private function drawMarkMove(state:Boolean):void{
			zMove = new MarkMove(state);
			this.addChild(zMove);
			
			zMove.useHandCursor = true;
			zMove.buttonMode = true;
			
			zMove.y = topGap;
			
			topGap += 32;
			
			toolBtnGroupArr.addItem(zMove);
		}
		
		/**
		 * 
		 * 绘制标记链接按钮
		 * 
		 * */
		private function  drawMarkConnect(state:Boolean):void{
			zConnect = new MarkToConnect(state);
			this.addChild(zConnect);
			
			zConnect.useHandCursor = true;
			zConnect.buttonMode = true;
			
			zConnect.y = topGap;
			
			topGap += 32;
			
			toolBtnGroupArr.addItem(zConnect);
		}
		
		/**
		 * 切换工具按钮，每次只能响应1个，其他关闭
		 * 
		 * */
		private function toggleToolButton(evt:MouseEvent):void{
			
			if(evt.target.hasOwnProperty("lockState")){

				if(toolBtnGroupSelected != undefined && toolBtnGroupSelected == evt.target){
					
					if(toolBtnGroupSelected.lockState){
						toolBtnGroupSelected.lockState = false;
					
						toolBtnGroupSelected = null;
					}
				}else{
					toolBtnGroupSelected = evt.target;
					
					for(var i:int = 0;i<toolBtnGroupArr.length;i++){
						if(toolBtnGroupArr.getItemAt(i).hasOwnProperty("lockState")){
							
							if(toolBtnGroupSelected == toolBtnGroupArr.getItemAt(i)){
								toolBtnGroupArr.getItemAt(i).lockState = true;
							}else{
								toolBtnGroupArr.getItemAt(i).lockState = false;
							}
						}
					}
				}
				
				trace("move:",zMove.lockState)
				trace("conn:",zConnect.lockState)
			}
			
		}
		
		/**
		 * 
		 * drawZoomSlider
		 * 
		 * @param dir：方向 (垂直vertical   水平horizon)
		 * */
		private function drawZoomSlider(sliderDir:String=null):void{
			
			
			if(sliderDir == "VERTICAL"){
				
				zVSlider = new MapVSlider(200,zVSliderInterval,zVSliderValue,zVSliderMaxVal,zVSliderMiniVal);	//
				
				this.addChild(zVSlider);
				
				zVSlider.y = topGap;
				
				topGap += 32;
			}
		}
		
		
		
		/**
		 * 鼠标滚轮控制刻度
		 * */
		public function setSliderValueFromMouseWheel(val:Number):void{
			zVSlider.slider.value = val;
		}
		
		/**
		 * 返回刻度当前值
		 * */
		public function getSliderValue():Number{
			return zVSlider.slider.value;
		}
		
		/**
		 * 返回刻度最小值
		 * */
		public function getSliderMiniValue():Number{
			return zVSlider.slider.minimum;
		}
		
		/**
		 * 返回刻度最大值
		 * */
		public function getSliderMaxValue():Number{
			return zVSlider.slider.maximum;
		}
		
		
		/**
		 * 返回地图锁状态
		 * */
		public function getLockState():Boolean{
			if(zLock){
				return zLock.lockState;
			}else{
				return false;
			}
		}
		
		/**
		 * 返回标记移动开关值
		 * */
		public function getMMoveAble():Boolean{
			if(zMove){
				return zMove.lockState;
			}else{
				return false;
			}
		}
		
		/**
		 * 返回标记移动开关值
		 * */
		public function getMConnectAble():Boolean{
			if(zConnect){
				return zConnect.lockState;
			}else{
				return false;
			}
		}
		
		/**
		 * 设置标记移动开关值
		 * */
		public function setMDishAble(tf:Boolean):void{
			zConnect.setLockStateIcon(tf);
		}

		public function get show_lock():Boolean
		{
			return _show_lock;
		}

		public function set show_lock(value:Boolean):void
		{
			_show_lock = value;
		}

		public function get show_move():Boolean
		{
			return _show_move;
		}

		public function set show_move(value:Boolean):void
		{
			_show_move = value;
		}

		public function get show_conn():Boolean
		{
			return _show_conn;
		}

		public function set show_conn(value:Boolean):void
		{
			_show_conn = value;
		}


	}
}