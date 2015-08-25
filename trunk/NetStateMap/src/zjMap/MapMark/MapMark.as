package zjMap.MapMark
{
	
	import com.degrafa.GeometryGroup;
	import com.greensock.TweenMax;
	import com.hybrid.ui.ToolTip;
	import com.hybrid.ui.ToolTip1;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.managers.ToolTipManager;
	import mx.states.OverrideBase;
	
	import zjMap.MapMark.MarkEvent.MouseDownEvent;
	
	public class MapMark extends Sprite
	{
		public var _siteId:String;
		public var _siteCn:String;
		public var _siteEn:String;
		private var _siteType:String;

		private var _tipmsg:String;
		
		private var _locPos:Point;		//本地坐标 xml
		private var _glPos:Point;		//全局坐标 转化
		
		private var _objData:Object;
		
		private var marker_url:String = "images/marker/";
		private var makerShadow_url:String = "images/marker/shadow50.png"
		private var makerLoader:Loader;
		private var makerShadowLoader:Loader;
		
		
		public var makerImgBtn:Sprite = new Sprite();
		
		private var imgWidth:Number = 22;
		private var imgHeight:Number = 36;
		private var shadowWidth:Number = 27;
		private var shadowHeight:Number = 20;
		
		
		private var size:Number = 5;
		
		/**拖动开关*/
		private var _drapEnable:Boolean;
		
		private var _color:uint = 0xffffff;//0xC6C3BD;
		private var _stroke:uint = 0x000000;//0x96928D;
		
		
		private var timer:Timer = new Timer(500, 1);
		
		private var markTip:ToolTip1;
		
		private var dir:String = "up";
		private var dist:Number = 10;
		
		private var tipContainer:GeometryGroup;
		
		private var markGlow:GlowFilter = new GlowFilter(0x999999,0.5,30,30,2);
		
		private var _copySource:MapMark;
		
		public function MapMark(data:Object, moveable:Boolean=false){
			super();
			
			
			_objData = data;
	
			this.siteId = _objData.id;
			this.siteEn = _objData.en;
			this.siteCn = _objData.cn;
			this.siteType = _objData.type;
			
			_locPos = data.loc_pos;
			_glPos = data.gl_pos; 
			
			drawMark(false);
			drawMakerOrShadow();
			
			createTip();
			
			tipmsg = "";
			updateTipContent();
			
			
			_drapEnable = moveable;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,showTooltip);
			
			
			
			
		}
		
		/**
		 * 
		 * 加载 标记和影子
		 * */
		private function drawMakerOrShadow():void{
			makerLoader =new Loader();
			makerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_maker);
			makerLoader.load(new URLRequest(switchMakerType()));
			
			makerShadowLoader =new Loader();
			makerShadowLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete_makerShadow);
			makerShadowLoader.load(new URLRequest(makerShadow_url));
			
		}
		
		private function switchMakerType():String{
			var url:String = "";
			switch(siteType){
				case "1":
					url = marker_url+"marker_orange.png";
				break;
				
				case "2":
					url =  marker_url+"marker_red.png";
				break;
				
				case "3":
					url =  marker_url+"marker_blue.png";
				break;
				
				case "4":
					url =  marker_url+"marker_green.png";
				break;
			}
			return url;
		}
		
		/**
		 * 添加标记
		 * */
		private function onLoadComplete_maker(evt:Event):void{
			var image:Bitmap = Bitmap(makerLoader.content);  
			var topImgData:BitmapData = image.bitmapData;  
			image.width = makerLoader.content.width;
			image.height = makerLoader.content.height;  
			
			/*this.graphics.beginFill(0xff0000);
			this.graphics.drawRect(0,0,image.width,image.height);
			this.graphics.endFill();*/
			
			image.x = -imgWidth/2;
			image.y = -imgHeight;
			this.addChild(image);
		}
		
		/**
		 * 添加标记影子
		 * */
		private function onLoadComplete_makerShadow(evt:Event):void{
			var image:Bitmap = Bitmap(makerShadowLoader.content);  
			var topImgData:BitmapData = image.bitmapData;  
			image.width = shadowWidth;
			image.height = shadowHeight;  
			
		/*	this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,image.width,image.height);
			this.graphics.endFill();*/
			
			image.x = imgWidth-shadowWidth+3;
			image.y = -shadowHeight;
			
			this.addChild(image);
		}
		
		private function drawMark(f:Boolean):void{
			if(f){
				this.graphics.clear();
				this.graphics.lineStyle(3,0x666666,1);
				setColor(0xffffff,1);
				this.graphics.drawCircle(0,0,6);
				setColor(0x666666,1);
				this.graphics.drawCircle(0,0,2);
				this.graphics.endFill();
				
				
				var shadow:DropShadowFilter = new DropShadowFilter();
				shadow.angle = 45;
				shadow.alpha = 0.5;
				shadow.color = 0x00000;
				//this.filters = [shadow];
			}
		}
		
		/**
		 * 
		 * 设置颜色
		 * */
		public function setColor(color:uint,alpha:Number):void{
			//this.graphics.clear();
			//this.graphics.lineStyle(1,_stroke);
			this.graphics.beginFill(color,alpha);
			//this.graphics.drawCircle(0,0,size);
			//this.graphics.endFill();
		}
		
		/**
		 * 设置选中效果
		 * */
		public function setSelected():void{
			setColor(0x578DCA,1);
		}
		/**
		 * 设置未选中效果
		 * */
		public function setUnSelected():void{
			setColor(_color,1);
		}
		
		/**
		 * 返回当前坐标
		 * */
		public function getPosition():Point{
			return new Point(this.x, this.y);
		}
		
		/**
		 * 
		 * 拖动
		 * 
		 * */
		/*
			var mde:MouseDownEvent = new MouseDownEvent();
			mde.mm = this.drapEnable.toString();
			dispatchEvent(mde);

		private function onMarkDrapDown(evt:MouseEvent):void{
			if(drapEnable){
				this.startDrag(false);
				this.addEventListener(MouseEvent.MOUSE_MOVE,onMarkDrapMove);
				this.addEventListener(MouseEvent.MOUSE_UP,onMarkDrapUp);
			}
		}
		private function onMarkDrapMove(evt:MouseEvent):void{
			//var msg:String = "坐标:"+this.x+","+this.y;
			//setTipContent(msg);
		}
		private function onMarkDrapUp(evt:MouseEvent):void{
			if(drapEnable){
				this.stopDrag();
				
				//tipContainer = this.parent as GeometryGroup;
				
				//currentMarkPos = new Point(this.x,this.y);	//记录当前移动后的坐
				
				this.removeEventListener(MouseEvent.MOUSE_UP,onMarkDrapUp);
			}
		}
		*/
		
		/**
		 * 创建tip
		 * */
		private function createTip():void{
			var tf_title:TextFormat = new TextFormat(null,12,0xffffff,true);
			
			var tf_content:TextFormat = new TextFormat(null,12,0xffffff,false);
			
			markTip = new ToolTip1();
			markTip.hook = true;
			markTip.hookSize = 15;
			markTip.cornerRadius = 6;
			markTip.autoSize = true;
			markTip.align = "right";
			markTip.bgAlpha = .65
			
			markTip.colors = [0x000000,0x000000];
			markTip.titleFormat = tf_title;
			markTip.contentFormat = tf_content;
			
			markTip.delay = 1;
			
		}
		/**
		 * 设置当前tip内容
		 * */
		public function updateTipContent(msg:String = ""):void{
			if(markTip){
				
				this.tipmsg = "";
				
				//this.tipmsg = siteEn+"("+siteCn+")\n";
				this.tipmsg += "全局坐标:"+glPos.x +","+ glPos.y+"\n";
				this.tipmsg += "本地坐标:"+locPos.x+","+ locPos.y+"\n";
				this.tipmsg += msg;
				
				markTip.setContent(this.siteEn+"("+this.siteCn+")",tipmsg);
			}
		}
		
		/**
		 * 
		 * 高亮
		 * 
		 * */
		private function onMarkHighLight(evt:MouseEvent):void{
			
			showTooltip(null);

		}
		
		private function showTooltip(evt:MouseEvent):void{
	
			markTip.show(this,this.siteEn+"("+this.siteCn+")",tipmsg);
			
			//markTip.filters = [markGlow]
			this.addEventListener(MouseEvent.MOUSE_OUT,onMarkNormal);
		}
		
		private function onMarkNormal(evt:MouseEvent):void{
			hideTooltip();
		}
		
		private function hideTooltip():void{
			markTip.hide();
		}
		
		private function getParent():GeometryGroup{
			if(this.parent as GeometryGroup){
				return this.parent as GeometryGroup;
			}
			
			return this.parent as GeometryGroup;
		}

		
		/**
		 * 覆盖x
		 * 
		 * */
		override public function set x(value:Number):void{
			
			super.x = value;
			
			glPos.x = x;
		}
		/**
		 * 覆盖x
		 * 
		 * */
		override public function set y(value:Number):void{
			
			super.y = value;
			
			glPos.y = y;
		}
		
		
		public function get siteId():String
		{
			return _siteId;
		}

		public function set siteId(value:String):void
		{
			_siteId = value;
		}

		public function get siteCn():String
		{
			return _siteCn;
		}

		public function set siteCn(value:String):void
		{
			_siteCn = value;
		}

		public function get siteEn():String
		{
			return _siteEn;
		}

		public function set siteEn(value:String):void
		{
			_siteEn = value;
		}

		

		/**复制来源*/
		public function get copySource():MapMark
		{
			return _copySource;
		}

		/**
		 * @private
		 */
		public function set copySource(value:MapMark):void
		{
			_copySource = value;
		}

		
		/**
		 * 设置标记移动
		 * @param able:是否可以
		 * */
		public function setMarkerMove(able:Boolean):void{
			if(able == true){
				
				drapEnable = true;
				
				//this.addEventListener(MouseEvent.MOUSE_DOWN,onMarkDrapDown);
			}else{
				
				drapEnable = false;
				
				//this.removeEventListener(MouseEvent.MOUSE_DOWN,onMarkDrapDown);
			}
	
		}

		public function get objData():Object
		{
			return _objData;
		}

		public function set objData(value:Object):void
		{
			_objData = value;
		}

		public function get siteType():String
		{
			return _siteType;
		}

		public function set siteType(value:String):void
		{
			_siteType = value;
		}
		

		public function get tipmsg():String
		{
			return _tipmsg;
		}

		public function set tipmsg(value:String):void
		{
			_tipmsg = value;
		}

		/**本地坐标点*/
		public function get locPos():Point
		{
			return _locPos;
		}

		/**
		 * @private
		 */
		public function set locPos(value:Point):void
		{
			_locPos = value;
		}

		/**全局坐标*/
		public function get glPos():Point
		{
			return _glPos;
		}

		/**
		 * @private
		 */
		public function set glPos(value:Point):void
		{
			_glPos = value;
		}

		public function get drapEnable():Boolean
		{
			return _drapEnable;
		}

		public function set drapEnable(value:Boolean):void
		{
			_drapEnable = value;
			/*if(value){
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onMarkDrapDown);
				this.addEventListener(MouseEvent.MOUSE_DOWN,onMarkDrapDown);
			}else{
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onMarkDrapDown);
			}*/
		}

	
	}
}