package zj.sos;

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
		//删除离开客户模型
		removeClientModel(client_leave_name);
		
		super.leave(client, scope);
	}
	
	private void removeClientModel(String client_leave_name){
		
		invokeAllClient("removeClientModel",client_leave_name);
	}
	
	
	//客户登录
	public String clientLogin(){
		
		//当前客户
		IConnection conn=Red5.getConnectionLocal();
		IClient client=conn.getClient();
		
		String client_login_name=(String)client.getAttribute("clientName");
		
		//更新客户列表
		sendClientList();
		
		//更新客户模型
		//sendClientModel();
		
		//更新客户状态
		//sendClientStatus(client_login_name+" 进来了");

		return "欢迎你,"+client_login_name;
	}
	//发送客户列表
	private void sendClientList(){
		
		invokeAllClient("sendAllClientList",clientList);

	}
	
	private void sendClientModel(){
		invokeAllClient("sendAllClientModel",clientList);
	}
	
	
	/***
	 * 更新当前坐标，发送给所有用户（自己除外）
	 * @param x
	 * @param y
	 */
	public void userMove_xy(String x,String y){
		IConnection current = Red5.getConnectionLocal();
		IClient client=current.getClient();
		String _name=(String)client.getAttribute("clientName");
		String _id=client.getId();
		
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
	private void sendUserNewPosition(String selfName){
		invokeOtherClient(selfName,"updateUserModelXY",clientList);
	}
	
	/***
	 * 群聊消息
	 * @param msg
	 */
	public void sendMessage(String msg){
		IConnection current = Red5.getConnectionLocal();
		IClient client=current.getClient();
		String _name=(String)client.getAttribute("clientName");
		String _id=client.getId();
		
		for(int i=0;i<clientList.size();i++){
			sosUser=(SOSUser)clientList.get(i);
			String cname=(String) sosUser.getUserName();
			if(cname.equals(_name)){
				sosUser.setUserId(_id);
				sosUser.setUserName(_name);
				sosUser.setUserMessage(msg);
			}else{
				sosUser.setUserMessage("");
			}
		}
		
		sendClientMessage(_name);
	}
	private void sendClientMessage(String selfName){
		invokeOtherClient(selfName,"sendOtherClientMsg",clientList);
	}
	
	
	/***
	 * 发送给所有其他用户 ，自己除外
	 * @param _name
	 * @param clientMethod
	 * @param obj
	 */
	private void invokeOtherClient(String _name,String clientMethod,Object obj){
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
							isc.invoke(clientMethod, new Object[]{obj});	
						}
							
					}
				}		
			}
		}
	}
	
	/***
	 * 发送所有客户端
	 * @param clientMethod
	 * @param obj
	 */
	private void invokeAllClient(String clientMethod,Object obj){
		IConnection current = Red5.getConnectionLocal();
		
		IScope iscope=current.getScope();	//当前所在域
		Collection<Set<IConnection>> conCollection = iscope.getConnections();	//当前域中所有连接中的链接
		for (Set<IConnection> conset : conCollection) {
			for (IConnection cons : conset) {
				if (cons != null) {
					if (cons instanceof IServiceCapableConnection) {
							
						IServiceCapableConnection isc=(IServiceCapableConnection) cons;
								
						isc.invoke(clientMethod, new Object[]{obj});	
					}
				}		
			}
		}
	}
	
	//检查在线重名
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
