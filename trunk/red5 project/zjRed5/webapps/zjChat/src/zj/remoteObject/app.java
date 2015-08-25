package zj.remoteObject;

import org.red5.server.adapter.ApplicationAdapter;

public class app extends ApplicationAdapter{
	
	public String echo(String name){   
        System.out.println("diaoyong");   
        return name+name;   
    }   

}
