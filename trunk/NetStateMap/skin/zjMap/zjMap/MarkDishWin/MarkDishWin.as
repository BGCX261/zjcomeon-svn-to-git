package zjMap.MarkDishWin
{
	import SuperPanel.net.brandonmeyer.containers.SuperPanel;
	
	import mx.events.CloseEvent;
	
	public class MarkDishWin extends SuperPanel
	{
		public function MarkDishWin()
		{
			super();
			
			this.styleName = "superpanel"
			this.width = 300;
			this.height = 200;
			
			this.allowDrag = true;
			this.allowClose = true;
			
			
			this.title = "My Panel ";
			
			this.addEventListener(CloseEvent.CLOSE, onCloseDishWin);
			
		}
		
		private function onCloseDishWin(evt:CloseEvent):void{
			this.parent.removeChild(this);
		}
	}
}