package zjMap.MapMark
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	public class MarkLegend extends UIComponent
	{
		
		[Bindable] 
		private var legends:XMLList; 
		
		private var legend_num:Number;
		
		private var legendWidth:Number = 90;
		private var legendHeight:Number = 40;
		private var topgap:Number = 10;
		private var leftgap:Number = 20;
		
		private var _shapeWidth:Number;
		private var _shapeHeight:Number;
		
		public function MarkLegend()
		{
			super();
			
			_shapeWidth = leftgap * 2 + legendWidth * 4;
			_shapeHeight = legendHeight ;
			
			loadLegendXML();
		}
		
		private function loadLegendXML():void{
			var request:URLRequest = new URLRequest("data/legend.xml");  
			var loader:URLLoader = new URLLoader(request);  
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);  
		}
		
		private function loaderCompleteHandler(evt:Event):void{
			var xml:XML = XML(evt.target.data)
			
			legends = xml.legend as XMLList;
			
			legend_num = legends.length();
			
			
			
			drawBackground();
		}
		/**
		 * 背景
		 * */
		private function drawBackground():void{
		
			
			this.graphics.beginFill(0x000000,0.5);
			this.graphics.drawRoundRect(0,0,shapeWidth,shapeHeight,6);
			this.graphics.endFill();
				
			drawLegend();
		}
		
		private function drawLegend():void{
			
			for(var i:int=0;i<legends.length();i++){
				//legends[i].@des;
				var ml:mLegend = new mLegend(legends[i].@img,legends[i].@desc,legendWidth,legendHeight);
				
				this.addChild(ml);
				
				ml.x = i * legendWidth ;
				ml.y = 0;
			}
		}

		public function get shapeWidth():Number
		{
			return _shapeWidth;
		}

		public function set shapeWidth(value:Number):void
		{
			_shapeWidth = value;
		}

		public function get shapeHeight():Number
		{
			return _shapeHeight;
		}

		public function set shapeHeight(value:Number):void
		{
			_shapeHeight = value;
		}


	}
}