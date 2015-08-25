/*
Write by Jose Bravo 02/2009
*/

package SVGRender
{
	import SVGRender.SVGRead.SVGParser;
	import SVGRender.SVGRead.SVGRender;
	
	import com.degrafa.GeometryGroup;
	import com.degrafa.Surface;
	import com.degrafa.geometry.Geometry;
	import com.degrafa.paint.SolidFill;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	
	
	
	public class SVGToGeometry extends SVGRender
	{
		
		private var PopupPanel:Panel;		
				
		public function cargar(svg:Object):Surface{
			var surface:Surface=new Surface();
			var parser:SVGParser;			
			
				if(svg is XML){
					parser = new SVGParser(svg as XML);
					this.svg_object = parser.parse();
				
				} else if(svg is Object) {
					this.svg_object = svg;
				}			
			
			var geometricGroup:GeometryGroup=new GeometryGroup();
			surface.addChild(geometricGroup);
			visit(svg_object, geometricGroup);
			return surface;
		}
				
		override protected function personalizeObject(elt:Object, g:GeometryGroup, s:Geometry):void{
			var geo:GeometryGroup;			
			geo=new DegrafaGeometry(elt.id);			
			
				g.addChild(geo);
				geo.geometryCollection.addItem(s);
				geo.addEventListener(MouseEvent.CLICK, onMouseClick);
				geo.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				geo.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				
			
			
				if(elt.transform)
						geo.transform.matrix = elt.transform;
				if(elt.styleenv["display"]=="none")
						geo.visible = false;
			
		}
		
		
		 protected function onMouseOver(e:MouseEvent):void{
	       var a:DegrafaGeometry= e.target as DegrafaGeometry; 
	       a.alpha=0.6;
	       PopupPanel=new Panel();
	       PopupPanel.x=Application.application.mouseX+5 ;
           PopupPanel.y=Application.application.mouseY+5 ;          
	       var label:Label=new Label();
	       label.text=a.getType();
	       PopupPanel.addChild(label);
	       PopUpManager.addPopUp(PopupPanel,Application.application.canvas);
	       
		}
		 protected function onMouseOut(e:MouseEvent):void{
		 	 var a:DegrafaGeometry= e.target as DegrafaGeometry; 
		 	 a.alpha=1;
			PopUpManager.removePopUp(PopupPanel);
			
        	
		}
		 protected function onMouseClick(e:MouseEvent):void{
			 var a:DegrafaGeometry= e.target as DegrafaGeometry; 
			 var figura:Geometry= a.geometryCollection.pop();
			 figura.fill=new SolidFill("red");	
			 a.geometryCollection.push(figura);	
			 
		 }
		
	}
}