package UI_Model
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	public class mainUI extends UIComponent
	{
		private var baseSprite:Sprite;
		
		public function mainUI(stageWidth:Number,stageHeight:Number)
		{
			this.name="mainUI";
			
			//this.width=stageWidth;
			//this.height=stageHeight;
			
			baseSprite=new Sprite();
			baseSprite.graphics.beginFill(0xffffff);
			baseSprite.graphics.drawRect(0,0,stageWidth,stageHeight);
			baseSprite.graphics.endFill();
			
			this.addChild(baseSprite);
			
			//this.addEventListener(ResizeEvent.RESIZE,changeStageSize);
			
		}
		
		public function changeStageSize(stageWidth:Number,stageHeight:Number){
			baseSprite.graphics.clear();
			baseSprite.graphics.beginFill(0x999999);
			baseSprite.graphics.drawRect(0,0,stageWidth,stageHeight);
			baseSprite.graphics.endFill();
		}
	}
}