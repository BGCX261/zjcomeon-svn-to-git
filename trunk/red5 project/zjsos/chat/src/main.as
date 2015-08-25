private function loadStyle():void{
	StyleManager.loadStyleDeclarations("css/mainCss.swf");
}

//显示登陆窗
private function showLoginWin():void{
	loginWin=LoginWindow(PopUpManager.createPopUp(this,LoginWindow,true));
	PopUpManager.centerPopUp(loginWin);
}
//隐藏登陆窗
private function hideLoginWin():void{
	PopUpManager.removePopUp(loginWin);
	loginWin=null;
}

//改变登陆窗状态
private function changeLoginStateView():void{
	if(loginWin!=null){
		loginWin.loginStateView.selectedChild=loginWin.login;
		loginWin.clientName.text=loginWin.loginNameFocus;
	}
}