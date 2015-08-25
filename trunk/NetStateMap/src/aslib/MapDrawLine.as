
import zjMap.MapLine.NetStateLine;

/**
 * 
 * 画网络线
 * 
 * @param from：起始对象
 * 
 * @param to：目标对象
 * @param state：网络状态
 * */
private function pingSiteLine(from:Object, to:Object, state:String):void{
	var fx:String = from.pos.split(",")[0];
	var fy:String = from.pos.split(",")[1];
	
	var fp:Point = new Point(Number(fx),Number(fy));
	
	var tx:String = to.pos.split(",")[0];
	var ty:String = to.pos.split(",")[1];
	var tp:Point = new Point(Number(tx),Number(ty));
	
	//localToContent(
	
	
	var lineId:String = (fp.x+"-"+fp.y) + "&" + (tp.x+"-"+tp.y);
	
	trace(lineId);
	
	//先删除
	delNetStateLine(lineId)
	
	//再创建
	var line:NetStateLine = new NetStateLine(fp, tp,state);
	ping_group.addChild(line);
	netStateLineArrCol.addItem(line);
	
}

/**
 * 
 * 删除网络状态线
 * @param parent:父级容器
 * @param lineId:线id
 * */
private function delNetStateLine(lineId:String):void{
	for(var i:int=0;i<netStateLineArrCol.length;i++){
		if(netStateLineArrCol[i].nslId == lineId){
			
			(netStateLineArrCol[i] as NetStateLine).parent.removeChild(netStateLineArrCol[i]);
			
			netStateLineArrCol.removeItemAt(i);
			netStateLineArrCol.refresh();
			
		}
	}
}

/**
 * 
 * 查找网络状态线
 * @param lineId:线id
 * */
private function getNetStateLine(lineId:String):NetStateLine{
	var line:NetStateLine = null;
	
	for(var i:int=0;i<netStateLineArrCol.length;i++){
		if(netStateLineArrCol[i].nslId == lineId){
			line = netStateLineArrCol[i];
		}
	}
	
	return line;
}

/**
 * 
 * 延时删除网络线
 * @param line:当前网络线
 * @param tpoint:目标对象坐标
 * @param fpoint:起始对象坐标
 * */
private function myDelayedCall(line:Sprite, tpoint:Point, fpoint:Point):void{
	
	//ping_group.removeChild(line);
	
}