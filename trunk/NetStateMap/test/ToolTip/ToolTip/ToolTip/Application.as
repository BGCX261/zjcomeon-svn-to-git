

package {
	
	
	import com.hybrid.ui.ToolTip;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import flash.text.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.system.*;
	
	
	public class Application extends MovieClip {
		
		
		private var _tf:TextField;
	 	private var _timer:Timer;
		
		
		public function Application(){
			 level1.level2.buttonMode = true;
			 level1.level2.addEventListener( MouseEvent.MOUSE_OVER, this.onMouseOver );
			 
			 level0.buttonMode = true;
			 level0.addEventListener( MouseEvent.MOUSE_OVER, this.onMouseOverZero );
			 
			 level2.buttonMode = true;
			 level2.addEventListener( MouseEvent.MOUSE_OVER, this.onMouseOverTwo );
			 
			 this.debug();
		}
		
		private function onMouseOver( event:MouseEvent ):void {
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.size = 12;
			tf.color = 0xff0000;
			var tt:ToolTip = new ToolTip();
			tt.hook = true;
			tt.cornerRadius = 20;
			tt.autoSize = true;
			tt.align = "right";
			tt.show( level1.level2, "Simple ToolTip", "Hook Enabled, Corner Radius 20, AutoSize Width, Align Right, Basic Format" );
			//this.traceDisplayList( stage );
		}
		
		
		private function onMouseOverZero( event:MouseEvent ):void {
			var tf:TextFormat = new TextFormat();
			tf.font = "georgia";  //font in library
			tf.bold = true;
			tf.size = 20;
			tf.color = 0x01430E;
			
			var contentFormat:TextFormat = new TextFormat();
			contentFormat.size = 14;
			contentFormat.color = 0xFFFFFF;
			contentFormat.bold = false;
			
			var tt:ToolTip = new ToolTip();
			tt.tipWidth = 250;
			tt.delay = 1000;
			tt.titleFormat = tf;
			tt.contentFormat = contentFormat;
			tt.align = "left";
			tt.colors = [ 0xB5FEB4, 0x003300 ];
			tt.show( level0, "Styled Tip", "Custom Colors, 1000ms Delay, No Hook, Left Align, More Complex Format" );
		}
		
		private function onMouseOverTwo( event:MouseEvent ):void {
			var tt:ToolTip = new ToolTip();
			tt.align = "center";
			tt.hook = true;
			tt.cornerRadius = 0;
			tt.show( level2, "Simple Tip", "Align Center, Hook Enabled, <i>Width Defaults To 200px</i>, Square / Corner Radius 0" );
		}
		
		private function debug():void {
			/* Memory Testing */
			_tf = new TextField()
			addChild( _tf );
			this._timer = new Timer( 25 );
			this._timer.addEventListener( "timer", onTimer );
			this._timer.start();
		}
		
		private function onTimer( event:TimerEvent ):void {
			_tf.text = flash.system.System.totalMemory.toString()
		}
		
		function traceDisplayList(container:DisplayObjectContainer, indentString:String = ""):void{
			var child:DisplayObject;
			for (var i:uint=0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i);
				trace(indentString, child, child.name); 
				if (container.getChildAt(i) is DisplayObjectContainer)
				{
					traceDisplayList(DisplayObjectContainer(child), indentString + "    ")
				}
			}
		}


		
		
		
		
		
	}
}