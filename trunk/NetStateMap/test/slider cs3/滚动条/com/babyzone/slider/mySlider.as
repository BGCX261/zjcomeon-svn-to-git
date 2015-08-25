package com.babyzone.slider  {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.events.*;
	/*
	num:滚动条的最大刻度值，
	setMiddle方法，设置滑块为中间的情况
	reset 重置
	setMc 控制传入的Islider
	deliveData 传送消息到mc
	*/
	public class mySlider extends MovieClip {

		//滑块可拖动区域
		private var drag_area:Rectangle;
		//滑块移动的刻度
		private var numBer:Number;
		//滑块的最大刻度
		private var maxNum:Number;
		//要处理的对象
		private var iObj:ISlider;
		//设置滑块参照的坐标
		private var relateX:Number;
		private var relateWidth:Number;
		
		public function mySlider(num:Number) {
			maxNum = num;
			drag_area = new Rectangle(this.scrollable_area.x,this.scrollable_area.y, this.scrollable_area.width - this.scroller.width,0);
			this.scroller.addEventListener( MouseEvent.MOUSE_DOWN, scroller_drag );
			relateX = drag_area.x;
			relateWidth = drag_area.width;
		}
	/*----------------------------滑块拖动效果--------------------------------*/
	private function scroller_drag( e:MouseEvent ):void {
			this.scroller.startDrag(false, drag_area);
			stage.addEventListener(MouseEvent.MOUSE_UP, up);
			//当移动滑块，强制重绘屏幕
			stage.addEventListener(MouseEvent.MOUSE_MOVE,updateScreen);
		}
	private function up( e:MouseEvent ):void {
			this.scroller.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, up);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateScreen);
		}
	private function updateScreen(e:MouseEvent) {
			//当前刻度
			numBer = maxNum * (this.scroller.x - relateX) / drag_area.width;
			numBer = numBer < -0.8? -0.8:numBer;
			if (iObj) {
				deliveData(numBer);
			}
			
		}
	public function reset():void {
			this.scroller.x = this.scrollable_area.x;
			numBer = maxNum * (this.scroller.x - drag_area.x) /relateWidth ;
			deliveData(numBer);
		}
	public function setMiddle():void {
			this.scroller.x =drag_area.x+(this.scrollable_area.width - this.scroller.width) / 2;
			relateX =this.scroller.x;
			relateWidth = drag_area.width/2;
		}
	/*----------------------------滑块拖动效果 end----------------------------*/
	
	/*----------------------------对传入的MC，设置----------------------------*/
	public function setMc(mc:ISlider):void {
			iObj = mc;
		}
	private function deliveData(num:Number):void {
			iObj.updateData(num);
		}
	}
}
