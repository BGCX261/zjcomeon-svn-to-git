package {
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;

	/**
	 * 提示文本
	 * @author Flying http://www.riafan.com
	 */
	public class AS3ToolTip{
		private static var toolTip : TextField;
		private static var format : TextFormat;
		private static var owner :DisplayObjectContainer;
		//tooltip对象是否可用
		public static var enabled : Boolean = true;
		//目标对象数组
		private static var owners : Array = new  Array();
		//文本对象数组
		private static var texts : Array = new Array();
		
		public function AS3ToolTip() {
			
		}
		
		/**
		 * 获取/设置提示文本的顶级显示对象
		 */
		public static function get root() :DisplayObjectContainer{
			return owner;
		}

		public static function set root(value :DisplayObjectContainer) : void {
			if (owner == null){
				owner = value;
			}
		}
		
		/**
		 * 新建一个提示文本
		 *
		 * @param   owner  要设置提示文本的目标对象
		 * @param   text  提示文本的内容
		 */
		 
		public static function create(owner:InteractiveObject, text: String) : void {
		 	owners.push(owner);
			texts.push(text);
		 	owner.addEventListener(MouseEvent.MOUSE_OVER, AS3ToolTip.showToolTip);
			owner.addEventListener(MouseEvent.MOUSE_OUT, AS3ToolTip.hideToolTip);
			
		}
		/**
		 * 显示提示文本
		 */
		 
		private static function showToolTip(e : MouseEvent) : void {
			//初始化动态文本
			toolTip = new TextField();
			toolTip.visible = true;
			toolTip.text = findText(InteractiveObject(e.currentTarget));
			toolTip.background = true;
			toolTip.backgroundColor= 0xFFCC66;
			toolTip.border = true;
			toolTip.borderColor = 0x000000;
			toolTip.multiline = false;
			toolTip.wordWrap = false;
			toolTip.autoSize = TextFieldAutoSize.CENTER;
			toolTip.x = owner.mouseX + 16;	
			toolTip.y = owner.mouseY - 24;
			
			//设置动态文本样式
			format = new TextFormat();
			format.font = "_sans";
			format.leftMargin = 4;
			format.rightMargin = 4;
			format.size = 12;
			toolTip.setTextFormat(format);
			owner.addChild(toolTip);
			
		}
		
		/**
		 * 隐藏提示文本
		 */

		private static function hideToolTip(e : MouseEvent) : void {
			toolTip.visible = false;  
			owner.removeEventListener(MouseEvent.MOUSE_OVER, showToolTip);
			owner.removeEventListener(MouseEvent.MOUSE_OUT, hideToolTip);  
		}
		
		/**
		 * 返回特定文本
		 * 
		 * @param   target  目标对象
		*/
		
		private static function findText(owner:InteractiveObject) : String {
			var index : int = owners.indexOf(owner);
			return texts[index];
		}
	}
}