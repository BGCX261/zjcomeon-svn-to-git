package User_Model
{
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	

	public class UserModel extends UIComponent
	{
		private var baseSprite:Sprite;
		
		//组件
		public var modelImg:Loader;
		public var model:Sprite;
		public var _userNameTxt:TextField;
		public var _userMessagePao:TextField;
		
		//属性
		private var _userName:String;
		private var _user_x:Number;
		private var _user_y:Number;
		private var modelSize:Number=30;
		
		private var msgTime:Timer;
		
		public function UserModel(userName:String)
		{
			baseSprite=new Sprite();
			//baseSprite.graphics.beginFill(0x999999,1);
			//baseSprite.graphics.drawRect(0,0,50,50);
			//baseSprite.graphics.endFill();
			this.addChild(baseSprite);
			
			
			createModelImage();
			
			createUserNameTxt(userName);
			
			
			msgTime=new Timer(5000,1);
		}
		
		
		private function createModelImage():void{
			
		}
		
		public function createSelfModel():void{
			/*model=new Sprite();
			model.graphics.beginFill(0x000000,1);
			model.graphics.drawRect(0,0,16,16);
			model.graphics.endFill();
			
			baseSprite.addChild(model);*/
			
			modelImg=new Loader();
			
			
			baseSprite.addChild(modelImg);
			
			modelImg.load(new URLRequest("image/user.gif"));
			
			
		}
		
		public function createOtherModel():void{
			/*model=new Sprite();
			model.graphics.beginFill(0xcccccc,1);
			model.graphics.drawRect(0,0,16,16);
			model.graphics.endFill();
			
			baseSprite.addChild(model);*/
			
			modelImg=new Loader();
			
			
			baseSprite.addChild(modelImg);
			
			modelImg.load(new URLRequest("image/userOther.gif"));
		}
		
		
		private function createUserNameTxt(userName:String):void{
			_userNameTxt=new TextField();
			_userNameTxt.y=modelSize;
			_userNameTxt.width=150;
			_userNameTxt.height=20;
			_userNameTxt.border=0;
			_userNameTxt.wordWrap=true;
			_userNameTxt.selectable = false; 
			_userNameTxt.text=userName;
			
			baseSprite.addChild(_userNameTxt);
		}
		
		private function createUserMessagePao():void{
			_userMessagePao=new TextField();
			_userMessagePao.y=-modelSize;
			_userMessagePao.width=150;
			_userMessagePao.height=20;
			_userMessagePao.border=0;
			_userMessagePao.wordWrap=true;
			_userMessagePao.selectable = false; 
			
			baseSprite.addChild(_userMessagePao);
		}
		
		public function setNewMessage(newMsg:String):void{
			//TweenMax.to(_userMessagePao,2,{autoAlpha:1});
			
			createUserMessagePao();
			
			_userMessagePao.text=newMsg;
			
			//TweenMax.to(_userMessagePao,5,{autoAlpha:0});
			
			timeClearMessage();
		}
		
		
		private function timeClearMessage():void{
			
			msgTime.addEventListener(TimerEvent.TIMER_COMPLETE,removeMsg);
			msgTime.start();
		}
		
		private function removeMsg(e:TimerEvent){
			trace("timer over")
			baseSprite.removeChild(_userMessagePao);
		}
		
		
		/*********
		 * 
		 * 
		 * 
		 * **/
		public function get userName():String
		{
			return _userName;
		}
		
		public function set userName(value:String):void
		{
			_userName = value;
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
		
		
	}
}