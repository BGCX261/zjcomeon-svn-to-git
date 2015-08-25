package zj.sharedObject;

import java.util.List;
import java.util.Map;

import org.red5.server.api.IAttributeStore;
import org.red5.server.api.so.ISharedObjectBase;
import org.red5.server.api.so.ISharedObjectListener;

public class SampleSharedObjectListener implements ISharedObjectListener {

	@Override
	public void onSharedObjectClear(ISharedObjectBase so) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectConnect(ISharedObjectBase so) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectDelete(ISharedObjectBase so, String key) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectDisconnect(ISharedObjectBase so) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectSend(ISharedObjectBase so, String method,
			List<?> params) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectUpdate(ISharedObjectBase so, String key,
			Object value) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectUpdate(ISharedObjectBase so,
			IAttributeStore values) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectUpdate(ISharedObjectBase so,
			Map<String, Object> values) {
		// TODO Auto-generated method stub

	}

}
