package zjMap.MapMark.MarkEvent
{
	import flash.events.Event;
	
	public class MouseDownEvent extends Event
	{
		public static const MARK_MOUSEDOWN:String="mark_mousedown";
		private var _mm:String
		public function MouseDownEvent()
		{
			super(MARK_MOUSEDOWN);
		}
		
		public function get mm():String
		{
			return _mm;
		}

		public function set mm(value:String):void
		{
			_mm = value;
		}

	}
}