package zjMap.MapTool
{
	
	import mx.core.UIComponent;
	
	public class ToolBtn extends UIComponent
	{
		private var _lockState:Boolean;
		
		public function ToolBtn()
		{
			super();
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