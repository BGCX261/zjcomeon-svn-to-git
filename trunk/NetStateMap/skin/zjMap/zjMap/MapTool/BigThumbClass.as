package zjMap.MapTool
{
	import mx.controls.sliderClasses.SliderThumb;
	import mx.skins.halo.SliderTrackSkin;
	
	public class BigThumbClass extends SliderThumb
	{
		public function BigThumbClass()
		{
			super();
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRoundRect(0,0,20,18,6,6);
			this.graphics.endFill();
		}
		
		
		
		override protected function measure():void{
			super.measure();
			measuredWidth = 20;
			measuredHeight = 18;
		}
	}
}