import com.greensock.TweenMax;

import flash.events.MouseEvent;



//添加用户模型
public function addUserModel():void
{			
	_user_model = new UserModel(userName.text);
	_user_model.x=200;
	_user_model.y=200;
	
	
	//模型
	_user_model.createSelfModel();
	_user_model.userName=userName.text;
	_user_model.user_x=200;
	_user_model.user_y=200;
	
	_user_model.name=userName.text;
	
	//添加
	_mainUI.addChild(_user_model);
	//集合
	userModelArrayCollection.addItem(_user_model);
	
	
	
	
	_mainUI.addEventListener(MouseEvent.CLICK, clickMover)
}

//添加其他用户模型
public function addUserOtherModel(user:Object):void
{
	/*if(_mainUI.getChildByName(userOtherName)){
		_mainUI.removeChild(_mainUI.getChildByName(userOtherName));
	}*/
		
	_user_other_model=new UserModel(user.userName);
	_user_other_model.x=user.x;
	_user_other_model.y=user.y;
	
	//模型
	_user_other_model.createOtherModel();
	_user_other_model.userName=user.userName;
	_user_other_model.user_x=user.x;
	_user_other_model.user_y=user.x;
	
	_user_other_model.name=user.userName;
	
	//添加
	_mainUI.addChild(_user_other_model);	
	
	//集合
	userModelArrayCollection.addItem(_user_other_model);
}

//移除用户模型
public function removeUserModel():void{
	
	//this.removeChild(_user_model);
	_mainUI.removeChild(_user_model);
	
	_user_model_index=userModelArrayCollection.getItemIndex(_user_model);
	userModelArrayCollection.removeItemAt(_user_model_index);
	
	_mainUI.removeEventListener(MouseEvent.CLICK,clickMover);
}

public function clickMover(e:MouseEvent):void{
	//trace(e.currentTarget,e.target)
	if(e.currentTarget==_mainUI){
		trace("click",this.mouseX,this.mouseY)
		TweenMax.to(_user_model,2,{x:this.mouseX,y:this.mouseY});
		
		var newX:Number=this.mouseX;
		var newY:Number=this.mouseY;
	
		nc.call("userMove_xy",null,newX,newY);
	}
	
	
	
	//nc.call("setballxy",null,newX,newY);
}















//按钮区切换
private function changeControllBar(tp:Number):void{
	
	//登录成功
	if(tp==1){
		loadBar.includeInLayout=false;	//加载条隐藏
		loadBar.visible=false;
		
		userName.enabled=false;			//登录名显示、不可用
		userName.includeInLayout=true;
		userName.visible=true;
		
		onconnBtn.visible=false;		//登录按钮隐藏
		onconnBtn.includeInLayout=false;
		
		disconnBtn.visible=true;		//退出按钮显示
		disconnBtn.includeInLayout=true;
		
		userMessage.enabled=true;		//聊天按钮可用
		sendMsgBtn.enabled=true;
	}
	
	//登录中
	if(tp==2){
		loadBar.includeInLayout=true;	//加载条显示
		loadBar.visible=true;
		
		userName.enabled=false;			//登录名隐藏、不可用
		userName.includeInLayout=false;
		userName.visible=false;
		
		onconnBtn.visible=false;		//登录按钮隐藏
		onconnBtn.includeInLayout=false;
		
		disconnBtn.visible=false;		//退出按钮显示
		disconnBtn.includeInLayout=false;
		
		userMessage.enabled=false;		//聊天按钮不可用
		sendMsgBtn.enabled=false;
	}
	
	//退出（初始）
	if(tp==3){
		loadBar.includeInLayout=false;	//加载条隐藏
		loadBar.visible=false;
		
		usersArrayCollection.source=null;	
		
		userName.text="";				//登录名隐藏、可用
		userName.enabled=true;
		userName.includeInLayout=true;
		userName.visible=true;
		
		onconnBtn.visible=true;			//登录按钮显示
		onconnBtn.includeInLayout=true;
			
		disconnBtn.visible=false;		//退出按钮隐藏
		disconnBtn.includeInLayout=false;
		
		userMessage.enabled=false;		//聊天按钮不可用
		sendMsgBtn.enabled=false;
	}
}