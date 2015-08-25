package User_Model
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import mx.controls.Text;
	import mx.core.UIComponent;

	public class UserOtherModel extends UIComponent
	{
		private var baseSprite:Sprite;
		
		public var model:Sprite;
		public var userNameTxt:TextField;
		
		private var _userName:String;
		private var _user_x:Number;
		private var _user_y:Number;
		
		
		public function UserOtherModel(userName:String)
		{
			baseSprite=new Sprite();
			//baseSprite.graphics.beginFill(0x999999,1);
			//baseSprite.graphics.drawRect(0,0,50,50);
			//baseSprite.graphics.endFill();
			this.addChild(baseSprite);
			
			
			createModel();	
			
			
			_userName=userName;
			
			createUserNameTxt(userName);
		}
		
		public function get user_y():Number
		{
			return _user_y;
		}

		public function set user_y(value:Number):void
		{
			_user_y = value;
		}

		public function get user_x():Number
		{
			return _user_x;
		}

		public function set user_x(value:Number):void
		{
			_user_x = value;
		}

		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}

		private function createModel():void{
			model=new Sprite();
			model.graphics.beginFill(0xcccccc,1);
			model.graphics.drawRect(0,0,16,16);
			model.graphics.endFill();
			
			baseSprite.addChild(model);
		}
		
		private function createUserNameTxt(userName:String):void{
			userNameTxt=new TextField();
			userNameTxt.y=16;
			userNameTxt.width=150;
			userNameTxt.height=20;
			userNameTxt.border=0;
			userNameTxt.wordWrap=true;
			userNameTxt.selectable = false; 
			userNameTxt.text=userName;
			
			baseSprite.addChild(userNameTxt);
		}
		
		
	}
}