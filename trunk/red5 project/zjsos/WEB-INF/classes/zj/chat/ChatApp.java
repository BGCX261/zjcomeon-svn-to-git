package zj.chat;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IClientRegistry;
import org.red5.server.api.IConnection;
import org.red5.server.api.IContext;
import org.red5.server.api.IScope;
import org.red5.server.api.Red5;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.exception.ClientRejectedException;

import zj.chat.User.ChatUser;

public class ChatApp extends ApplicationAdapter{

	private IScope chatScope;
	
	public List clientList=null;
	
	private String clientName;
	
	
	private ChatUser chatUser;
	
	@Override
	public synchronized boolean start(IScope scope) {
		
		System.out.println("启动");
		
		chatScope=scope;
		
		clientList=new ArrayList();
		
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
		
		if(checkOnlineClientName(clientName)){
			
			return super.rejectClient("此人已登录");
			
		}else{
			return super.connect(conn, scope, params);
		}
	}

	
	@Override
	public synchronized boolean join(IClient client, IScope scope) {
		
		String name=(String)client.getAttribute("clientName");
		String id=client.getId();
		
		chatUser=new ChatUser();
		chatUser.setUserId(id);
		chatUser.setUserName(name);
		
		clientList.add(chatUser);
		
		
		return super.join(client, scope);
	}
	
	
	@Override
	public synchronized void leave(IClient client, IScope scope) {
		
		String client_leave_name=(String) client.getAttribute("clientName");
		
		for(int i=0;i<clientList.size();i++){
			chatUser=(ChatUser)clientList.get(i);
			String cname=(String) chatUser.getUserName();
			if(cname.equals(client_leave_name)){
				clientList.remove(i);
			}
		}
		//更新客户列表
		sendClientList();
		//更新客户状态
		sendClientStatus(client_leave_name+" 离开了");
		
		
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
		sendClientStatus(client_login_name+" 进来了");
		
	
			/*
			chatUser=new ChatUser();
			chatUser.setUserId(client.getId());
			chatUser.setUserName(clientName);
			chatUser.setUserSex("");
		*/
			return "欢迎你,"+client_login_name;
	}
	
	//群聊消息
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
	
	//发送客户列表
	private void sendClientList(){
		
		invokeAllClient("sendAllClientList",clientList);

	}
	
	//发送客户状态
	private void sendClientStatus(String clientState){
		
		invokeAllClient("sendAllClientStatus",clientState);
	}
	
	//发送消息
	private void sendClientMessage(String msg){
		invokeAllClient("sendAllClientMsg",msg);
	}
	
	//发送所有客户端
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
	
	//检查在线重名
	private boolean checkOnlineClientName(String clientName){
		boolean flag=false;
		
		for(int i=0;i<clientList.size();i++){
			chatUser=(ChatUser)clientList.get(i);
			String cname=(String) chatUser.getUserName();
			if(cname.equals(clientName)){
				//clientList.remove(i);
				flag=true;
			}
		}
		return flag;
	}
	
	
	public String getMsg() {   
        return "this msg from server";   
    }

}
