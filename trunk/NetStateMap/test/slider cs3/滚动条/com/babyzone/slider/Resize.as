package com.babyzone.slider  {
	import flash.display.MovieClip;
	import flash.events.Event;
	/*
	mc: 	重设大小的元件剪辑
	speed:  缓动状态：0-1，1是正常状态
	*/
	public class Resize extends MovieClip implements ISlider {
		
		private var old_width:Number;//原始影片剪辑的属性
		private var old_height:Number;
		private var mcSpeed:Number;
		private var this_mc:MovieClip;
		private var scale:Number=1;
		
		public function Resize(mc:MovieClip,speed:Number) {
			old_width=mc.width;
			old_height=mc.height;
			this_mc = mc;
			mcSpeed = speed;
			this.addEventListener(Event.ENTER_FRAME, set_size);
		}
		
		public function updateData(num:Number):void{
			num++;
			scale = num;
		}
		
        private function set_size(e:Event):void {
			this_mc.scaleX+=(scale-this_mc.scaleX)*mcSpeed;
			this_mc.scaleY+=(scale-this_mc.scaleY)*mcSpeed;
		}
	}
}
