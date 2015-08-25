package zj.sharedObject;

import java.util.ArrayList;

import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.so.ISharedObject;

public class app extends ApplicationAdapter{

	private IScope appScope;
	
	private ISharedObject ballSO;
	
	@Override
	public synchronized boolean start(IScope scope) {
		
		System.out.println("启动");
		
		appScope=scope;

		
		return super.start(scope);
	}
	
	
	@Override
	public synchronized boolean connect(IConnection conn, IScope scope, Object[] params) {
		
		ballSO = getSharedObject(appScope, "ballSO", false);
		
		ballSO.beginUpdate();
		ballSO.setAttribute("x", 20);
		ballSO.setAttribute("y", 100);
		ballSO.endUpdate();
		
		return super.connect(conn, scope, params);
	}
	
	public void setballxy(String x,String y){
		ballSO.beginUpdate();
		ballSO.setAttribute("x", x);
		ballSO.setAttribute("y", y);
		ballSO.endUpdate();
	}

}
