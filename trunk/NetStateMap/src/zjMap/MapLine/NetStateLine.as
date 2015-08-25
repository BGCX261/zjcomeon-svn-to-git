package zjMap.MapLine
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	
	/**
	 * 
	 * 网络状态线
	 * 
	 * */	
	public class NetStateLine extends Sprite{
		
		/**id*/
		private var _nslId:String;
		/**起始点*/
		private var _s_point:Point;
		/**目标点*/
		private var _e_point:Point;
		/**起始备份点*/
		private var _p_point:Point;
		
		private var _state:String;
		
		private var lineWeight:Number = 3;
		
		private var shadow:DropShadowFilter = new DropShadowFilter(4,90,0x000000,.32);
		public function NetStateLine(_s:Point, _e:Point ,_st:String,animate:Boolean){
			
			/**
			 * 
			 * 网络线id
			 * @param 
			 * 起始x - 起始y & 终止x - 终止y 
			 * */
			nslId = (_s.x+"-"+_s.y) + "&" + (_e.x+"-"+_e.y);
			
			/**
			 * 设置状态
			 * */
			this.state = _st;
			
			s_point = new Point (_s.x, _s.y);
			
			p_point = _s;
			
			e_point = _e;
			
			
			color = pingState(this.state);
			
			if(animate){
				this.AnimateLine();
				this.filters = [shadow];
			}else{
				NormalLine();
			}
			
			
			
		}
		
		/**
		 * 画线
		 * */
		public function AnimateLine():void{

				
				
				TweenLite.to(p_point,Point.distance (this.s_point,this.e_point)/200,{ x:e_point.x, y:e_point.y ,
					onUpdate:NormalLine,onComplete:drawLineComplete});

		}
		
		/**
		 * 普通画线
		 * */
		private function NormalLine():void {
			
			graphics.clear ();
			graphics.lineStyle (lineWeight, 0xffffff,1,false,"normal",CapsStyle.ROUND);
			graphics.moveTo (s_point.x, s_point.y);
			graphics.lineTo (p_point.x, p_point.y);
			
		}
		
		/**
		 * 先从父级中删除，再画线
		 * */
		public function resetLine():void{

			//toLine();
			/**延时删除网络线*/
			//TweenLite.delayedCall(10, myDelayedCall, [line,tpoint,fpoint]);
			//this.parent.removeChild(this);
			//graphics.clear ();
			//toLine();
		}
		
		
		
		/**
		 * 连接完成
		 * */
		private function drawLineComplete():void{
			trace("complete:",s_point,e_point)
		}
		
		/*private function cubic_curve(gra:Graphics,pt1,pt2,pt0,pt3){
			　　gra.moveTo(pt0.x,pt0.y);
			　　var pos_x;
			　　var pos_y;
			　　for(var i=0;i<=1;i+=1/100)
			　　{
				　　　　pos_x = Math.pow(i,3)*(pt3.x+3*(pt1.x-pt2.x)-pt0.x)
					　　　　　　　　+3*Math.pow(i,2)*(pt0.x-2*pt1.x+pt2.x)
					　　　　　　　　+3*i*(pt1.x-pt0.x)+pt0.x;
				　　　　pos_y = Math.pow(i,3)*(pt3.y+3*(pt1.y-pt2.y)-pt0.y)
					　　　　　　　　+3*Math.pow(i,2)*(pt0.y-2*pt1.y+pt2.y)
					　　　　　　　　+3*i*(pt1.y-pt0.y)+pt0.y;
				　　　　gra.lineTo(pos_x,pos_y);
			　　}
		}*/
		
		
		public function set color(_c:uint):void {
			var _colorTransForm:ColorTransform = new ColorTransform();
			_colorTransForm .color = _c;
			transform.colorTransform = _colorTransForm;
		}
		
		/**
		 * 
		 * 网络状态解析
		 * 
		 * @param state: 0 异常  1 正常
		 * */
		private function pingState(_st:String):uint{
			var color:uint = 0x11D02F;
			if(_st == "0"){
				color = 0xCF1E08;
				
			}
			if(_st == "1"){
				color = 0x559E06;
			}
			
			if(_st == "clear"){
				color = 0x00ffffff;
			}
			
			if(_st == "shadow"){
				color = 0xcccccc;
			}
			
			return color;
		}

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			_state = value;
		}

		public function get nslId():String
		{
			return _nslId;
		}

		public function set nslId(value:String):void
		{
			_nslId = value;
		}

		/**起始点*/
		public function get s_point():Point
		{
			return _s_point;
		}

		/**
		 * @private
		 */
		public function set s_point(value:Point):void
		{
			_s_point = value;
		}

		/**目标点*/
		public function get e_point():Point
		{
			return _e_point;
		}

		/**
		 * @private
		 */
		public function set e_point(value:Point):void
		{
			_e_point = value;
		}

		/**备份点*/
		public function get p_point():Point
		{
			return _p_point;
		}

		/**
		 * @private
		 */
		public function set p_point(value:Point):void
		{
			_p_point = value;
		}

		
	}
}