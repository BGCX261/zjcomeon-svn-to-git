package zjMap.MapTool 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public final class zjSlider extends Sprite
	{
		public final function zjSlider():void
		{
			addListeners();
		}
		
		private final function addListeners():void
		{
			slider.thumb.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
			slider.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
			//stage.addEventListener(MouseEvent.MOUSE_UP, terminateDrag);
		}
		
		private final function initDrag(e:MouseEvent):void
		{
			slider.thumb.startDrag(false, new Rectangle(slider.bar.x, slider.thumb.y, slider.bar.width - slider.thumb.width, 0));
			slider.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
		}
		
		private final function onSliderMove(e:MouseEvent):void
		{
			slider.thumb.txtTF.text = slider.thumb.x; //
		}
		
		private final function terminateDrag(e:MouseEvent):void
		{
			slider.thumb.stopDrag();
			slider.removeEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSliderMove);

		}
	}
}