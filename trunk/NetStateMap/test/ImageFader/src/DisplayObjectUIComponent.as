package
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	public class DisplayObjectUIComponent extends UIComponent
	{
		public function DisplayObjectUIComponent(displayObject:DisplayObject)
		{
		    super ();
		
		    explicitHeight = displayObject.height;
		    explicitWidth = displayObject.width;		
		    addChild (displayObject);
		}
	}
}