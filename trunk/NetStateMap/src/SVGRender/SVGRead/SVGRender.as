/* Author: Lucas Lorentz Lara - 25/09/2008
	Modifify by Jose Bravo - 02/2009 for compatibily with DEGRAFA Library
*/

package SVGRender.SVGRead {
	import com.degrafa.GeometryGroup;
	import com.degrafa.geometry.Circle;
	import com.degrafa.geometry.Ellipse;
	import com.degrafa.geometry.Geometry;
	import com.degrafa.geometry.Line;
	import com.degrafa.geometry.Path;
	import com.degrafa.geometry.Polygon;
	import com.degrafa.geometry.Polyline;
	import com.degrafa.geometry.RegularRectangle;
	import com.degrafa.geometry.RoundedRectangle;
	import com.degrafa.paint.GradientStop;
	import com.degrafa.paint.LinearGradientFill;
	import com.degrafa.paint.RadialGradientFill;
	import com.degrafa.paint.RadialGradientStroke;
	import com.degrafa.paint.SolidFill;
	import com.degrafa.paint.SolidStroke;
	
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
		
	public class SVGRender {
		protected var svg_object:Object;
		protected var currentFontSize:Number;
		protected var currentViewBox:Object;
		
		public function visit(elt:Object, obj:GeometryGroup):void {
		 	var flag:Boolean=true;
						
			//se pregunta si existe un TAG padre para obtener sus estilos
			// y sus TAG hijos los hereden
			if(elt.parent){
				elt.styleenv = elt.parent.styleenv; //inherits parent style
			} else {
				elt.styleenv = new Object();
			}
			
			 //se mesclan los estilos del current TAG con los del TAG padre
 			if(svg_object.styles[elt.type]!=null){
				elt.styleenv = SVGUtil.mergeObjectStyles(elt.styleenv, svg_object.styles[elt.type]);
			}
			
			if(elt["class"]){
				for each(var className:String in String(elt["class"]).split(" "))
					elt.styleenv = SVGUtil.mergeObjectStyles(elt.styleenv, svg_object.styles["."+className]);
			}

			if(elt.style)
				elt.styleenv = SVGUtil.mergeObjectStyles(elt.styleenv, elt.style);
								
		/* hasta aqui ya tenemos un array con los estilos para el objeto 
			este array se encuentra en la variable elt.styleenv
			elt es un objeto que contiene la información del xml
		*/		
								
			//Testing
			var oldFontSize:Number = currentFontSize;
			var oldViewBox:Object = currentViewBox;
			if(elt.styleenv["font-size"]!=null){
				currentFontSize = getUserUnit(elt.styleenv["font-size"] , currentFontSize, currentViewBox.height);
			}
			if(elt.viewBox!=null){
				currentViewBox = elt.viewBox;
			}
								
			switch(elt.type){
				case 'svg':
				visitSvg(elt, obj);						
				 break;
				
				case 'rect':
				visitRect(elt, obj);	
							
				break;
				
				case 'path':
				visitPath(elt, obj);
							
				break;
				
				case 'polygon':
				visitPolygon(elt, obj);					
				 break;
				
				case 'polyline':
				visitPolyline(elt, obj); 				
				break;
				
				case 'line':
				visitLine(elt, obj); 	
				break;
				
				case 'circle':
				visitCircle(elt, obj);		
				break;
				
				case 'ellipse':
				visitEllipse(elt, obj); 	
				break;
				
				case 'g':
				visitG(elt, obj); 
					
				break;
				
				case 'clipPath':
				visitClipPath(elt, obj);	
				 break;
				
				case 'defs':
				visitDefs(elt, obj); break;
				/*
				case 'use':
				obj = visitUse(elt); break;
				
				case 'notSupported':
				obj = new Sprite(); break;
				*/
				default:
					flag=false;
			}
			
			if(flag!=false){	
				currentFontSize = oldFontSize;
				currentViewBox = oldViewBox;				
			}
		}		
		
		protected function visitSvg(elt:Object, viewBox:GeometryGroup):void {
			// the view box
						
			viewBox.name = "viewBox";
			viewBox.graphics.drawRect(0,0,elt.viewBox.width, elt.viewBox.height);			
			var activeArea:GeometryGroup = new GeometryGroup();
			activeArea.name = "activeArea";
			viewBox.addChild(activeArea);
		
		
			// iterate through the children of the svg node
			for each(var childElt:Object in elt.children) {	
				visit(childElt, viewBox);
			}
			
			// find the minimum point in the active area.
		   // var min:Point = new Point(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
		    //var r:Rectangle;
		
		    // find the minimum point in the active area.
		    var min:Point = new Point(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
		    var r:Rectangle;		    
		    var i:int = 0;
		    var c:DisplayObject;
			for (i = 0; i < activeArea.numChildren; i++) {
				c = activeArea.getChildAt(i);
				r = c.getBounds(activeArea);
				min.x = Math.min(min.x, r.x);
				min.y = Math.min(min.y, r.y);
			}			
			
			// move the transform into the activeArea layer
			activeArea.x = min.x;
			activeArea.y = min.y;
			for (i = 0; i < activeArea.numChildren; i++) {
				c = activeArea.getChildAt(i);
				c.x -= min.x;
				c.y -= min.y;
			}

			//Testing
			if(elt.width!=null && elt.height!=null){
				var activeAreaWidth:Number = elt.viewBox.width || activeArea.width;
				var activeAreaHeight:Number = elt.viewBox.height || activeArea.height;
				
				activeArea.scaleX = getUserUnit(elt.width, currentFontSize, currentViewBox.width)/activeAreaWidth;
				activeArea.scaleY = getUserUnit(elt.height, currentFontSize, currentViewBox.height)/activeAreaHeight;
				
				activeArea.scaleX = Math.min(activeArea.scaleX, activeArea.scaleY);
				activeArea.scaleY = Math.min(activeArea.scaleX, activeArea.scaleY);
			}
			
		}
		
		protected function visitG(elt:Object, s:GeometryGroup ):void {			
			
	        if( elt.x != null )
                s.x = getUserUnit(elt.x, currentFontSize, currentViewBox.width);
            if( elt.y != null )
                s.y =  getUserUnit(elt.y, currentFontSize, currentViewBox.height);
						
			for each(var childElt:Object in elt.children) {
				visit(childElt, s);
			}
		}
		
		protected function beginFill(s:Geometry, elt:Object):void {
			
			var color:uint = SVGColor.parseToInt(elt.styleenv.fill);
			var noFill:Boolean = elt.styleenv.fill==null || elt.styleenv.fill == '' || elt.styleenv.fill=="none";
			var fill_opacity:Number = Number(elt.styleenv["opacity"]?elt.styleenv["opacity"]: (elt.styleenv["fill-opacity"]? elt.styleenv["fill-opacity"] : 1));

			if(!noFill && elt.styleenv.fill.indexOf("url")>-1){
				var id:String = StringUtil.rtrim(String(elt.styleenv.fill).split("(")[1], ")");
				id = StringUtil.ltrim(id, "#");

				var grad:Object = svg_object.gradients[id];
				var stops:Array=new Array();
				switch(grad.type){
					case GradientType.LINEAR: {
						var x1:Number = getUserUnit(grad.x1, currentFontSize, currentViewBox.width);
						var y1:Number = getUserUnit(grad.y1, currentFontSize, currentViewBox.height);
						var x2:Number = getUserUnit(grad.x2, currentFontSize, currentViewBox.width);
						var y2:Number = getUserUnit(grad.y2, currentFontSize, currentViewBox.height);
						var angulo:Number=Math.atan2(y2-y1, x2-x1)*(180/Math.PI);						
						var gradiente:LinearGradientFill= new LinearGradientFill();
						gradiente.id="gradiente1";
						gradiente.angle=angulo;
						
						for(var i:int=0; i< grad.colors.length; i++){
							stops.push(new GradientStop(grad.colors[i], grad.alphas[i], grad.ratios[i]));
						}
						gradiente.gradientStops=stops;						
						s.fill=gradiente;
						break;
					}
					case GradientType.RADIAL: {
						
						var cx:Number = getUserUnit(grad.cx, currentFontSize, currentViewBox.width);
						var cy:Number = getUserUnit(grad.cy, currentFontSize, currentViewBox.height);
						var r:Number = getUserUnit(grad.r, currentFontSize, currentViewBox.width);
						var fx:Number = getUserUnit(grad.fx, currentFontSize, currentViewBox.width);
						var fy:Number = getUserUnit(grad.fy, currentFontSize, currentViewBox.height);
					
						var gradienteRadial:RadialGradientFill=new RadialGradientFill();
						var f:Object = { x:fx-cx, y:fy-cy };
						
						
						
						
						
						grad.focalRatio = Math.sqrt( (f.x*f.x)+(f.y*f.y) )/r;
						gradienteRadial.focalPointRatio=Math.sqrt( (f.x*f.x)+(f.y*f.y) )/r;
						if(grad.r==0){
							
								stops.push(new GradientStop(grad.colors[grad.colors.length-1], grad.alphas[grad.alphas.length-1]));
						}							
						else{
							for(var i2:int=0; i2< grad.colors.length; i2++){								
								stops.push(new GradientStop(grad.colors[i2], grad.alphas[i2], grad.ratios[i2]));
							}
						}
						
						gradienteRadial.gradientStops=stops;
						s.fill=gradiente;
						break;
					}
				}
				return;
			}
			s.fill=new SolidFill(color, noFill?0:fill_opacity);
		}
		
		
		protected function flashLinearGradient( x1:Number, y1:Number, x2:Number, y2:Number ):Matrix { 
                 var w:Number = x2-x1;
				 var h:Number = y2-y1; 
                 var a:Number = Math.atan2(h,w); 
                 var vl:Number = Math.sqrt( Math.pow(w,2) + Math.pow(h,2) ); 
                  
                 var matr:Matrix = new flash.geom.Matrix(); 
                 matr.createGradientBox( 1, 1, 0, 0., 0. ); 
  
                 matr.rotate( a ); 
                 matr.scale( vl, vl ); 
                 matr.translate( x1, y1 ); 
                  
                 return matr; 
         } 
		 
		protected function flashRadialGradient( cx:Number, cy:Number, r:Number, fx:Number, fy:Number ):Matrix { 
                 var d :Number= r*2; 
                 var matr:Matrix = new flash.geom.Matrix(); 
                 matr.createGradientBox( d, d, 0, 0., 0. ); 
  
                 var a:Number = Math.atan2(fy-cy,fx-cx); 
                 matr.translate( -cx, -cy ); 
                 matr.rotate( -a );
                 matr.translate( cx, cy ); 
				 
				 matr.translate( cx-r, cy-r ); 

                 return matr; 
         } 
		
		protected function beginStroke(s:Geometry, elt:Object):void {
			var color:uint = SVGColor.parseToInt(elt.styleenv.stroke);
			var noStroke:Boolean = elt.styleenv.stroke==null || elt.styleenv.stroke == '' || elt.styleenv.stroke=="none";
			var stroke_opacity:Number = Number(elt.styleenv["opacity"]?elt.styleenv["opacity"]: (elt.styleenv["stroke-opacity"]? elt.styleenv["stroke-opacity"] : 1));
			var w:Number = 1;
			
			if(elt.styleenv["stroke-width"])
				w = getUserUnit(elt.styleenv["stroke-width"], currentFontSize, Math.sqrt(Math.pow(currentViewBox.width,2)+Math.pow(currentViewBox.height,2))/Math.sqrt(2));

			var stroke_linecap:String = CapsStyle.NONE;

			if(elt.styleenv["stroke-linecap"]){
				var linecap:String = StringUtil.trim(elt.styleenv["stroke-linecap"]).toLowerCase(); 
				if(linecap=="round")
					stroke_linecap = CapsStyle.ROUND;
				else if(linecap=="square")
					stroke_linecap = CapsStyle.SQUARE;
			}
				
			var stroke_linejoin:String = JointStyle.MITER;
			
			if(elt.styleenv["stroke-linejoin"]){
				var linejoin:String = StringUtil.trim(elt.styleenv["stroke-linejoin"]).toLowerCase(); 
				if(linejoin=="round"){
					stroke_linejoin = JointStyle.ROUND;
					var rs:RadialGradientStroke=new RadialGradientStroke();
					
				}
				else if(linejoin=="bevel")
					stroke_linejoin = JointStyle.BEVEL;
			}
			if(noStroke)
				s.stroke=new SolidStroke("",0,0);
			else
				s.stroke=new SolidStroke(color, stroke_opacity, w);
		}
				
		private static function notImplemented(s:String):void {
			trace("renderer has not implemented " + s);
		}
		
		
		protected function getUserUnit(s:String, relativeReference:Number = 1, percentageReference:Number = 1):Number {
			var value:Number;
			
			if(s.indexOf("pt")!=-1){
				value = Number(StringUtil.remove(s, "pt"));
				return value*1.25;
			} else if(s.indexOf("pc")!=-1){
				value = Number(StringUtil.remove(s, "pc"));
				return value*15;
			} else if(s.indexOf("mm")!=-1){
				value = Number(StringUtil.remove(s, "mm"));
				return value*3.543307;
			} else if(s.indexOf("cm")!=-1){
				value = Number(StringUtil.remove(s, "cm"));
				return value*35.43307;
			} else if(s.indexOf("in")!=-1){
				value = Number(StringUtil.remove(s, "in"));
				return value*90;
			} else if(s.indexOf("px")!=-1){
				value = Number(StringUtil.remove(s, "px"));
				return value;
				
			//Relative
			} else if(s.indexOf("em")!=-1){
				value = Number(StringUtil.remove(s, "em"));
				return value*relativeReference;
				
			//Percentage
			} else if(s.indexOf("%")!=-1){
				value = Number(StringUtil.remove(s, "%"));
				return value/100*percentageReference;
				
			} else {
				return Number(s);
			}
		}
		
		/*///////////////////////////////////////////////////////////////////////////////
		         METODOS QUE SON SOBRESCRITOS POR LAS CLASES QUE HEREDAN DE ESTA
		///////////////////////////////////////////////////////////////////////////////*/
		protected function visitRect(elt:Object,g:GeometryGroup):void {
			var s:Geometry;
			var x:Number = getUserUnit(elt.x, currentFontSize, currentViewBox.width);
			var y:Number = getUserUnit(elt.y, currentFontSize, currentViewBox.height);
			var width:Number = getUserUnit(elt.width, currentFontSize, currentViewBox.width);
			var height:Number = getUserUnit(elt.height, currentFontSize, currentViewBox.height);					
								
			if(elt.isRound) {
				var rx:Number = getUserUnit(elt.rx, currentFontSize, currentViewBox.width);
				var ry:Number = getUserUnit(elt.ry, currentFontSize, currentViewBox.height);
				
				s=new RoundedRectangle(x, y, width, height, rx);
			} else {
				s=new RegularRectangle(x, y, width, height);
			}		
			beginFill(s, elt);
			
			beginStroke(s, elt);
			personalizeObject(elt, g, s);
			
		}		
		protected function visitPath(elt:Object, g:GeometryGroup):void{
			var s:Path = new Path();
        	beginFill(s, elt);
			beginStroke(s, elt);
        	s.data=elt.d;
			personalizeObject(elt, g, s);
		}
		
		
		protected function visitPolygon(elt:Object, g:GeometryGroup):void {
			var points:Array=elt.points;				
			var s:Polygon = new Polygon(points);				
			beginFill(s, elt);
            beginStroke(s, elt);
            personalizeObject(elt, g, s);
		}		
		protected function visitPolyline(elt:Object, g:GeometryGroup):void {
			var points:Array=elt.points;				
			var s:Polyline = new Polyline(points);				
			beginFill(s, elt);
            beginStroke(s, elt);
             personalizeObject(elt, g, s);
		}		
		protected function visitLine(elt:Object, g:GeometryGroup):void {
			var s:Line = new Line();
			personalizeObject(elt, g, s);
		}		
		protected function visitCircle(elt:Object, g:GeometryGroup):void {
				var s:Circle = new Circle();
			
			var cx:Number = getUserUnit(elt.cx, currentFontSize, currentViewBox.width);
			var cy:Number = getUserUnit(elt.cy, currentFontSize, currentViewBox.height);
			var r:Number = getUserUnit(elt.r, currentFontSize, currentViewBox.width); //Its based on width?
			
			beginFill(s, elt);
			s.centerX=cx;
			s.centerY=cy;
			s.radius=r;
			personalizeObject(elt, g, s);
		}		
		protected function visitEllipse(elt:Object, g:GeometryGroup):void {
				var s:Ellipse = new Ellipse();
			
			var cx:Number = getUserUnit(elt.cx, currentFontSize, currentViewBox.width);
			var cy:Number = getUserUnit(elt.cy, currentFontSize, currentViewBox.height);
			var rx:Number = getUserUnit(elt.rx, currentFontSize, currentViewBox.width);
			var ry:Number = getUserUnit(elt.ry, currentFontSize, currentViewBox.height);
			
			beginFill(s, elt);
			beginStroke(s,elt);
			s.horizontalCenter=cx;
			s.verticalCenter=cy;
			personalizeObject(elt, g, s);
		}		
		protected function visitClipPath(elt:Object, g:GeometryGroup):void {
			
		}	
		protected function visitDefs(elt:Object,  g:GeometryGroup):void {}		
		protected function visitUse(elt:Object,  g:GeometryGroup):void {}		
		
		
		protected function personalizeObject(elt:Object, g:GeometryGroup,  s:Geometry):void{}
		/*////////////////////////////////////////////////////////////////////////////////*/	
		
	}
}