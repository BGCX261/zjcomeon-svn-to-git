package zjMap.MapLine 
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	

	/**
	 * ...
	 */
	public class TweenLine extends Sprite  
	{
		private var s_point:Point;
		private var e_point:Point;
		private var p_point:Point;
		public function TweenLine(_s:Point, _e:Point ,_c:uint=0):void {                        
			s_point = new Point (_s.x, _s.y);
			p_point = _s;
			e_point = _e;
			color = _c;
			TweenLite.to(p_point, Point.distance (_s,_e)/500, { x:e_point.x, y:e_point.y ,onUpdate:setPPoint} );
		}
		private function setPPoint():void {
			trace(p_point,s_point  );
			drawLine();
		}
		private function drawLine():void {
			graphics.clear ();
			graphics.lineStyle (3, 0xffffff);
			graphics.moveTo (s_point.x, s_point.y);
			graphics.lineTo (p_point.x, p_point.y);
		}
		public function set color(_c:uint):void {
			var _colorTransForm:ColorTransform = new ColorTransform();
			_colorTransForm .color = _c;
			transform.colorTransform = _colorTransForm;
		}
	}
	
}