﻿package zj.sos;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IClientRegistry;
import org.red5.server.api.IConnection;
import org.red5.server.api.IContext;
import org.red5.server.api.IScope;
import org.red5.server.api.Red5;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.exception.ClientRejectedException;

import zj.chat.User.ChatUser;
import zj.sos.User.SOSUser;

public class SOSApp extends ApplicationAdapter{

	private IScope sosScope;
	
	public List clientList=null;
	
	public List userOtherList=null;
	
	private String clientName;
	
	
	private SOSUser sosUser;
	
	private ISharedObject userSO;
	
	@Override
	public synchronized boolean start(IScope scope) {
		
		System.out.println("启动");
		
		sosScope=scope;
		
		clientList=new ArrayList();
		
		userOtherList=new ArrayList();
		
		return super.start(scope);
	}
	
	
	@Override
	public synchronized boolean connect(IConnection conn, IScope scope, Object[] params) {
		
		//客户端登录名
		clientName=params[0].toString();
		
		IClient client=conn.getClient();
		//添加客户端登录名
		client.setAttribute("clientName", clientName);
		client.setAttribute("clientId", client.getId());
		client.setAttribute("x", params[1].toString());
		client.setAttribute("y", params[2].toString());
		
		if(checkOnlineClientName(clientName)){
			
			return super.rejectClient("此人已登录");
			
		}else{
			/*
			userSO = getSharedObject(sosScope, "userSharedObj", false);
			userSO.beginUpdate();
			userSO.setAttribute("x", 20);
			userSO.setAttribute("y", 100);
			userSO.endUpdate();
			*/
			return super.connect(conn, scope, params);
		}
	}

	
	@Override
	public synchronized boolean join(IClient client, IScope scope) {
		
		String name=(String)client.getAttribute("clientName");
		String id=client.getId();
		String x=(String)client.getAttribute("x");
		String y=(String)client.getAttribute("y");
		
		
		sosUser=new SOSUser();
		sosUser.setUserId(id);
		sosUser.setUserName(name);
		sosUser.setX(x);
		sosUser.setY(y);
		
		clientList.add(sosUser);
		
		
		return super.join(client, scope);
	}
	
	
	@Override
	public synchronized void leave(IClient client, IScope scope) {
		
		String client_leave_name=(String) client.getAttribute("clientName");
		
		for(int i=0;i<clientList.size();i++){
			sosUser=(SOSUser)clientList.get(i);
			String cname=(String) sosUser.getUserName();
			if(cname.equals(client_leave_name)){
				clientList.remove(i);
			}
		}
		//更新客户列表
		sendClientList();
		//更新客户状态
		//sendClientStatus(client_leave_name+" 离开了");
		
		
		super.leave(client, scope);
	}
	
	
	//客户登录
	public String clientLogin(){
		
		//当前客户
		IConnection conn=Red5.getConnectionLocal();
		IClient client=conn.getClient();
		
		String client_login_name=(String)client.getAttribute("clientName");
		
		//更新客户列表
		sendClientList();
		
		//更新客户状态
		//sendClientStatus(client_login_name+" 进来了");

		return "欢迎你,"+client_login_name;
	}
	
	//发送客户列表
	private void sendClientList(){
		
		invokeAllClient("sendAllClientList",clientList);

	}
	
	/***
	 * 接受新坐标 并通知所有用户(自己除外)
	 * @param x
	 * @param y
	 */
	public void userMove_xy(String x,String y){
		IConnection current = Red5.getConnectionLocal();
		IClient client=current.getClient();
		String _name=(String)client.getAttribute("clientName");
		String _id=client.getId();
		
		//更新用户列表信息
		for(int i=0;i<clientList.size();i++){
			sosUser=(SOSUser)clientList.get(i);
			String cname=(String) sosUser.getUserName();
			if(cname.equals(_name)){
				sosUser.setUserId(_id);
				sosUser.setUserName(_name);
				sosUser.setX(x);
				sosUser.setY(y);
			}
		}

		sendUserNewPosition(_name);
	}
	
	private void sendUserNewPosition(String _name){
		IConnection current = Red5.getConnectionLocal();
		
		IScope iscope=current.getScope();	//当前所在域
		Collection<Set<IConnection>> conCollection = iscope.getConnections();	//当前域中所有连接中的链接
		for (Set<IConnection> conset : conCollection) {
			for (IConnection cons : conset) {
				if (cons != null) {
					if (cons instanceof IServiceCapableConnection) {
							
						IServiceCapableConnection isc=(IServiceCapableConnection) cons;
						IClient client=isc.getClient();
						String n=(String)client.getAttribute("clientName");
						
						if(_name==n){
							
						}else{						
							isc.invoke("updateUserModelXY", new Object[]{clientList});	
						}
							
					}
				}		
			}
		}
	}
	
	/***
	 * 	群聊消息
	 * @param msg
	 */
	public void sendMessage(String msg){
		//chatUser.setUserMessage(msg);
		//String message=chatUser.getUserName()+":"+msg;
		IConnection current = Red5.getConnectionLocal();
		IClient client=current.getClient();
		String client_msg_name=(String)client.getAttribute("clientName");
		String message=client_msg_name+":"+msg;
		sendClientMessage(message);
		
		//return msg;
	}
	
	//发送消息
	private void sendClientMessage(String msg){
		invokeAllClient("sendAllClientMsg",msg);
	}
	

	/***
	 * 发送所有客户端
	 * @param clientMethod
	 * @param obj
	 */
	private void invokeAllClient(String clientMethod,Object obj){
		IConnection current = Red5.getConnectionLocal();
        
		//Notify Users of the current Scope
		
		IScope iscope=current.getScope();	//当前所在域
		Collection<Set<IConnection>> conCollection = iscope.getConnections();	//当前域中所有连接中的链接
		for (Set<IConnection> conset : conCollection) {
			for (IConnection cons : conset) {
				if (cons != null) {
					if (cons instanceof IServiceCapableConnection) {
							
						IServiceCapableConnection isc=(IServiceCapableConnection) cons;
							
						//isc.invoke("callFromServer", new Object[]{"i am server"});
						isc.invoke(clientMethod, new Object[]{obj});	
						//((IServiceCapableConnection) cons).invoke("callFromServer", new Object[] {"hah"});
							
					}
				}		
			}
		}
	}
	
	/****
	 * 检查在线重名
	 * @param clientName
	 * @return
	 */
	private boolean checkOnlineClientName(String clientName){
		boolean flag=false;
		
		for(int i=0;i<clientList.size();i++){
			sosUser=(SOSUser)clientList.get(i);
			String cname=(String) sosUser.getUserName();
			if(cname.equals(clientName)){
				//clientList.remove(i);
				flag=true;
			}
		}
		return flag;
	}
	
	
	
	
	public void setballxy(String x,String y){
		userSO.beginUpdate();
		userSO.setAttribute("x", x);
		userSO.setAttribute("y", y);
		userSO.endUpdate();
	}
	
	public String getMsg() {   
        return "this msg from server";   
    }

}
