package 副本.t{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	
	import mx.core.UIComponent;
	
	public class DrawingCurves extends UIComponent {
		private var x0:Number = 100;
		private var y0:Number = 200;
		private var x1:Number=0;
		private var y1:Number=0;
		private var x2:Number = 300;
		private var y2:Number = 200;
		private var i:Number=0;
		private var xx:Number;
		private var yy:Number;
		private var movex:int=0;
		
		public function DrawingCurves() {
			init();
		}
		private function init():void {
			
			this.addEventListener(Event.ENTER_FRAME, MouseMove);
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			/*Drawing(0,0,30,106,100,100);
			Drawing(100,100,159,90,120,150);
			Drawing(120,150,100,188,150,180);
			Drawing(150,180,210,170,200,220);
			Drawing(200,220,154,364,350,400);
			Drawing(350,400,428,420,430,430);*/
			
		}
		private function MouseMove(event):void {
			//txt.text="X:"+mouseX+" Y:"+mouseY;
			/*x1 = mouseX;
			y1 = mouseY;
			graphics.clear();
			graphics.lineStyle(1);
			graphics.moveTo(x0, y0);
			graphics.curveTo(x1, y1, x2, y2);*/
			var s:Sprite=new Sprite();
			var color=0x888888;//Math.floor(Math.random()*16777215);
			Drawing(0,0,30,106,100,100,s,color);
			Drawing(100,100,159,90,120,150,s,color);
			Drawing(120,150,100,188,150,180,s,color);
			Drawing(150,180,210,170,200,220,s,color);
			Drawing(200,220,154,364,350,400,s,color);
			Drawing(350,400,428,420,430,430,s,color);
			addChild(s);
			s.alpha=0;
			s.addEventListener(Event.ENTER_FRAME,showout);
			s.x=Math.cos(movex*Math.PI/180*0.1)*80+400;
			s.y=Math.sin(movex*Math.PI/180*0.3)*80+200;
			s.rotation=movex*180/Math.PI*0.002;
		}
		private function DrawingC(e):void {
			i++;
			x1 =(x2-x0)/2+Math.sin(i*0.02)*300;
			y1 =y0+Math.cos(i*0.02)*300;
			//graphics.clear();
			graphics.lineStyle(0.25,Math.floor(Math.random()*16777215));
			graphics.moveTo(xx, yy);
			graphics.curveTo(x1, y1, x2, y2);
		}
		private function Drawing(sx,sy,cx,cy,ex,ey,s,color) {
			
			s.graphics.lineStyle(0.25,color);
			s.graphics.moveTo(sx, sy);
			s.graphics.curveTo(cx, cy, ex, ey);
			
			movex+=1;
			
		}
		private function showout(e) {
			
			if (e.target.alpha>=1) {
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,showout);
				e.target.addEventListener(Event.ENTER_FRAME,showin);
				
			} else {
				e.target.alpha+=0.1;
			}
		}
		private function showin(e) {
			
			e.target.alpha-=0.05;
			if (e.target.alpha<=0) {
				e.target.removeEventListener(Event.ENTER_FRAME,showin);
				removeChild(e.target);
			}
		}
	}
}