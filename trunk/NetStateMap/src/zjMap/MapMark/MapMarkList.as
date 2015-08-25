package zjMap.MapMark
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	public class MapMarkList extends UIComponent
	{
		private var _lstWidth:Number;
		
		private var _lstHeight:Number;
		
		/**背景加载器*/
		private var bgLoader:Loader;
		private var bgImgData:BitmapData;
		private var bg_url:String = "images/markList/markList_bg.png";
		
		/**按钮加载器*/
		private var upLoader:Loader;
		private var downLoader:Loader;
		private var up_url:String = "images/markList/up.png";
		private var down_url:String = "images/markList/down.png";
		
		
		public var init_Width:Number = 70;		/**初始宽*/
		private var expand_Width:Number = 180;	/**展开宽*/
		
		
		private var cellWidth:Number = expand_Width;	/**列宽*/
		private var cellHeight:Number = 26;	/**列高*/
		
		private var btnHeight:Number = 9;		/**按钮高度*/
		
		private var cellGap:Number = 16;		/**行内间隔*/
		
		private var content_top:Number = 40;	/**定点位置*/
		
		private var box:Sprite;				/**身体*/
		private var title:Sprite;				/**标题*/
		private var content:Sprite;			/**内容*/
		private var contentMask:Sprite;		/**遮罩*/
		
		private var titleDesc:TextField;		/**标题描述*/
		
		/**按钮*/
		private var udBtnBg:Sprite;
		private var upBtn:Sprite;
		private var downBtn:Sprite;
		private var scrollDir:String;		/**滚屏方向*/
		
		
		
		private var _isShow:Boolean;
		
		private var _markerData:Array;
		
		private var totalNum:Number = 0;
		
		/**列数*/
		private var cellNum:Number = 1;
		private var showRowNum:Number = 8;
		
		/**shadow*/
		private var shadow:DropShadowFilter = new DropShadowFilter(4,45,0x000000,.32);
		
		
		
		
		/**起始标记*/
		public var fromMarker:MapMarkListItem = null;
		/**目标标记*/
		public var toMarker:MapMarkListItem = null;
		
		/**
		 * 
		 * 创建标记列表
		 * @param sitesMarkArrCol:所有标记数据集合
		 * @param titleDesc:标题描述
		 * */
		public function MapMarkList(markerDataArray:Array,titleDesc:String){
			super();
			
			_markerData = markerDataArray;
			
			lstWidth = init_Width;		/**初始宽*/
			
			lstHeight = cellHeight + btnHeight;	/**初始高=行高+按钮高*/
			
			//初始化
			initShape(lstWidth,lstHeight,titleDesc);
			
			bgLoader =new Loader();
			bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_bg);
			//bgLoader.load(new URLRequest(bg_url));
			
			
			upLoader =new Loader();
			upLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_upbtn);
			upLoader.load(new URLRequest(up_url));
			
			downLoader =new Loader();
			downLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_downbtn);
			downLoader.load(new URLRequest(down_url));
			
			
			
		}
		
		/**
		 * 初始化图形
		 * @param lstWidth:宽
		 * @param lstHeight：高
		 * @param titleDesc：标题描述
		 * */
		private function initShape(lstWidth:Number,lstHeight:Number,desc:String):void{
			
			
			
			//背景
			box = new Sprite();
			this.addChild(box);
			drawListBackground();
			
			
			//内容遮罩
			contentMask = new Sprite();
			box.addChild(contentMask);
			resetContentMask(0);
			//内容
			content = new Sprite();
			box.addChild(content);
			resetContent();
			
			
			//标题
			title = new Sprite();
			box.addChild(title);
			titleDesc = new TextField();
			titleDesc.htmlText = desc;
			title.addChild(titleDesc);
			drawListTitle();
			
			
			//按钮
			udBtnBg = new Sprite();
			box.addChild(udBtnBg);
			drawUdBtn();
			udBtnBg.addEventListener(MouseEvent.MOUSE_OVER,onBtnHover);
			udBtnBg.addEventListener(MouseEvent.CLICK,onShowList);
			
		}
		
		/**
		 * 背景加载器
		 * */
		private function onLoadComplete_bg(evt:Event):void{
			var image:Bitmap = Bitmap(bgLoader.content);  
			bgImgData = image.bitmapData;  
			
			drawListBackground();
		}
		
		
		/**
		 * 按钮加载器
		 * */
		private function onLoadComplete_upbtn(evt:Event):void{
			var image:Bitmap = Bitmap(upLoader.content);  
			var imgData:BitmapData = image.bitmapData; 
			
			/**按钮up*/
			upBtn = new Sprite();
			upBtn.graphics.beginFill(0xff0000,0);
			upBtn.graphics.drawRect(0,0,16,16);
			upBtn.graphics.endFill();
			
		
			upBtn.addChild(image);
			
			upBtn.visible = false;
			upBtn.buttonMode = true;
			upBtn.useHandCursor = true;
			
			box.addChild(upBtn);
			upBtn.x = -16;//expand_Width - 32;
			upBtn.y = 32;
				
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN,srcollContent_up);
			upBtn.addEventListener(MouseEvent.MOUSE_UP,stopSrcollContent);
		}
		
		/**
		 * 按钮加载器
		 * */
		private function onLoadComplete_downbtn(evt:Event):void{
			var image:Bitmap = Bitmap(downLoader.content);  
			var imgData:BitmapData = image.bitmapData; 
			
			/**按钮up*/
			downBtn = new Sprite();
			downBtn.graphics.beginFill(0x00ff00,0);
			downBtn.graphics.drawRect(0,0,20,20);
			downBtn.graphics.endFill();
			
			
			downBtn.addChild(image);
			
			downBtn.visible = false;
			downBtn.buttonMode = true;
			downBtn.useHandCursor = true;
			
			box.addChild(downBtn);
			downBtn.x = -16;//expand_Width - 16;
			downBtn.y = showRowNum*cellHeight;
				
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN,srcollContent_down);
			downBtn.addEventListener(MouseEvent.MOUSE_UP,stopSrcollContent);
		}
		
		/**
		 * 绘制背景
		 * */
		private function drawListBackground():void{

			box.graphics.clear();
			box.graphics.lineStyle(1,0x999999);
			//box.graphics.beginBitmapFill(bgImgData,null,true);
			//box.graphics.beginGradientFill(GradientType.LINEAR,[0xE6E6E6,0xFBFBFB,0xF6F6F6],[0.7,0.7,0.7],[0,130,255]);
			/*
			box.graphics.beginFill(0xffffff,1);
			box.graphics.drawRect(0,0,lstWidth+1,lstHeight+1);*/
			
			box.graphics.beginFill(0xffffff);
			box.graphics.moveTo(0,0);
			box.graphics.lineTo(0,lstHeight);
			box.graphics.lineTo(-lstWidth,lstHeight);
			box.graphics.lineTo(-lstWidth,0);
			box.graphics.lineTo(0,0);
			
			box.graphics.endFill();
			
			box.filters = [shadow];
		}
		
		/**
		 * 绘制标题
		 * */
		private function drawListTitle():void{
			title.graphics.clear();
			title.graphics.beginFill(0xffffff,1);
			title.graphics.drawRect(0,0,lstWidth-1,cellHeight-1);
			title.graphics.endFill();
			title.x = -lstWidth+1;
			title.y = 1;
			
			
			//txt.autoSize = TextFieldAutoSize.CENTER;
			titleDesc.selectable = true;
			titleDesc.mouseEnabled = false;
			titleDesc.height = cellHeight;
			titleDesc.x = 0 + cellGap;
			titleDesc.y = 4;
			titleDesc.setTextFormat(new TextFormat(null,12,0x333333,false));
			
		}
		
		
		/**
		 * 绘制按钮背景
		 * */
		private function drawUdBtn():void{
		
			udBtnBg.graphics.clear();

			if(!_isShow){
				udBtnBg.graphics.beginFill(0xffffff,1);
			}else{
				udBtnBg.graphics.beginFill(0x2C82C3,1);
			}
			udBtnBg.graphics.drawRect(0,0,lstWidth-1,btnHeight-1);
			udBtnBg.graphics.endFill();
			
			udBtnBg.x = -lstWidth+1;
			udBtnBg.y = 1+lstHeight - btnHeight;
			
			
			
		}
		
		/**
		 * 交互效果 over
		 * */
		private function onBtnHover(evt:MouseEvent):void{
			TweenMax.to(udBtnBg, 0, {colorMatrixFilter:{colorize:0x2C82C3, amount:1}});
			
			
			udBtnBg.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
		}
		/**
		 * 交互效果 out
		 * */
		private function onBtnOut(evt:MouseEvent):void{
			//if(!_isShow){
				TweenMax.to(udBtnBg, 0, {colorMatrixFilter:{colorize:0xffffff, amount:1},onComplete:function():void{
					TweenMax.killTweensOf(udBtnBg);
				}});
			/*}else{
				TweenMax.to(udBtnBg, 0.5, {colorMatrixFilter:{colorize:0xcccccc, amount:1},onComplete:function():void{
					TweenMax.killTweensOf(udBtnBg);
				}});
			}*/
			
			udBtnBg.removeEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
		}
		
		/**
		 * 显示列表
		 * */
		private function onShowList(evt:MouseEvent):void{
			if(!_isShow){
				
				lstWidth = expand_Width;
				lstHeight = showRowNum*cellHeight + cellHeight + btnHeight;
				_isShow = true;
				
				upBtn.visible = true;
				downBtn.visible = true;
					
			}else{
				
				lstWidth = init_Width;
				
				lstHeight = cellHeight + btnHeight;
					
				_isShow = false;
				
				upBtn.visible = false;
				downBtn.visible = false;
			}
			
			drawListBackground();
			
			resetContentMask(lstHeight - cellHeight - btnHeight);
			
			drawListTitle();
			
			drawUdBtn();
		}

		
		/**
		 * 
		 * 创建标记列表项
		 * */
		
		public function drawMarkerItem():void{
			
			/*if(markerData.length % cellNum == 0){
				rowNum = markerData.length/cellNum;
			}else{
				rowNum = Math.floor(markerData.length/cellNum) + 1;
			}*/
			
			//总数
			totalNum = markerData.length * cellHeight;
			
			for(var i:int=0;i<markerData.length;i++){
				var markItem:MapMarkListItem = new MapMarkListItem(markerData[i]);
				content.addChild(markItem);
					
				//var ypos:Number = Math.floor(i/cellNum) * cellHeight;		//
						
				//var xpos:Number = i % cellNum * cellWidth;
				//trace(markerData[i].pos)
				markItem.x = -expand_Width;
				markItem.y = (cellHeight) * i ;
				
				markItem.addEventListener(MouseEvent.CLICK,findItemForMap);
				
				
			}
			
		}
		
		/**
		 * 标记项点击 定位
		 * 
		 * */
		private function findItemForMap(evt:MouseEvent):void{
			if(evt.target is MapMarkListItem){
				var markItem:MapMarkListItem = evt.target as MapMarkListItem;
				
				var markpoint:Point = markItem.itemData.pos;

				this.parentApplication.initMapPosition(markpoint,1.5);
			}
		}
		
		/**
		 * 
		 * 重新绘制背景高度
		 * 重新绘制把手位置
		 * 列表坐标位置
		 * */
		private function resetAll():void{
			
			//lstHeight = rowNum * cellHeight + 70;
			//lstWidth = cellNum * cellWidth + 20 ;
			//this.y =  - height;
			//bgLoader.load(new URLRequest(bg_url));
			//headLoader.load(new URLRequest(head_url));
			//titleLoader.load(new URLRequest(title_url));
			//footLoader.load(new URLRequest(foot_url));
			//toggleLoader.load(new URLRequest(toggle_url));
			
			
			//resetContentMask();
			var page:Number = markerData.length / (showRowNum * cellNum);
			
			var totalHeight:Number = showRowNum * cellHeight;//page * rowNum * cellHeight;
			
			
			//resetContent(totalHeight);
		}
		
		/**
		 * 
		 * 根据列表高度重新绘制遮罩
		 * */
		private function resetContentMask(height:Number):void{
			contentMask.graphics.clear();
			contentMask.graphics.beginFill(0xff0000,1);
			contentMask.graphics.drawRect(0,0,lstWidth-1-20,height-1);
			contentMask.x = -lstWidth+1;
			contentMask.y = cellHeight;
	
		}
		/**
		 * 
		 * 根据列表高度重新绘制内容框
		 * */
		private function resetContent():void{
			var h:Number = cellHeight * showRowNum;
			
			
			content.graphics.clear();
			content.graphics.beginFill(0xffffff,1);
			content.graphics.drawRect(0,0,expand_Width,height);
			content.graphics.endFill();
			
			content.y = cellHeight;		//定点位置
			content.x = 0;
			
			content.mask = contentMask;	//遮罩
		}

		/**
		 * 
		 * 内容滚屏--up
		 * */
		private function srcollContent_up(evt:MouseEvent):void{		
			//trace(rowNum*cellHeight , content_top,content.y)
		
			/*var pp:Number = content.height - (contentMask.height+1) ;
			if(Math.abs(content.y) > pp){
				
			}else{
				content.y -= 20;
			}*/
			scrollDir = "up";
			this.addEventListener(Event.ENTER_FRAME,srcollContent);
		
		}
		
		/**
		 * 
		 * 内容滚屏--down
		 * */
		private function srcollContent_down(evt:MouseEvent):void{
			scrollDir = "down";
			this.addEventListener(Event.ENTER_FRAME,srcollContent);		
			//this.parentApplication.cy.text = content.height+" "+contentMask.height+" "+""+" "+content.y
		}
		private function stopSrcollContent(evt:MouseEvent):void{
			this.removeEventListener(Event.ENTER_FRAME,srcollContent);
		}
		private function srcollContent(evt:Event):void{
			
			
			if(scrollDir == "up"){
				
				content.y = content.y + 10;
				
				if(content.y > cellHeight){
					content.y = cellHeight;
				}
			}
			if(scrollDir == "down"){
				content.y = content.y - 10;
				
				var showH:Number = showRowNum * cellHeight;
				var h:Number = showH - totalNum + cellHeight;
				if(content.y < h){
					content.y = h;
				}
			}

		}
			
		public function get markerData():Array
		{
			return _markerData;
		}
		
		public function set markerData(value:Array):void
		{
			_markerData = value;
		}

		public function get isShow():Boolean
		{
			return _isShow;
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}

		public function get lstWidth():Number
		{
			return _lstWidth;
		}

		public function set lstWidth(value:Number):void
		{
			_lstWidth = value;
		}

		public function get lstHeight():Number
		{
			return _lstHeight;
		}

		public function set lstHeight(value:Number):void
		{
			_lstHeight = value;
		}



	}
}