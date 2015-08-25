package zjMap.MapTool
{
	import mx.skins.halo.SliderTrackSkin;
	
	public class MapNavSliderTrackSkin extends SliderTrackSkin
	{
		public function MapNavSliderTrackSkin()
		{
			super();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			trace("track",unscaledWidth,unscaledHeight)
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
		}
		
		
		override public function get measuredHeight():Number
		{
			return 18;
		}
	}
}