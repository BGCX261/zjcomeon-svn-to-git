package com.babyzone.slider  {
	
	/*
	mc: 	重设角度的元件剪辑
	angle:  角度,1代表一圈
	speed   缓动的速度 0-1
	*/
	
	import flash.display.MovieClip;
	import flash.events.Event;
	public class rotateMc extends MovieClip implements ISlider {
		
		private var this_mc:MovieClip;
		private var realNum:Number=0;
		private var mcSpeed:Number;
		
		public function rotateMc(mc:MovieClip,speed:Number) {
			this_mc = mc;
			mcSpeed = speed;
			this.addEventListener(Event.ENTER_FRAME, setRotate);
		}
		public function updateData(num:Number):void{
			realNum = num * 360;
		}
		public function setRotate(e:Event):void {
			var thisRotation = this_mc.rotation >= 0? this_mc.rotation:this_mc.rotation + 360;
			this_mc.rotation += (realNum - thisRotation) * mcSpeed;
		}
	}
	
}
