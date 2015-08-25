package SVGRender
{
	import com.degrafa.GeometryGroup;
	
	public class DegrafaGeometry extends GeometryGroup
	{
		private var type:String;
		
		public function DegrafaGeometry(type:String="")
		{
			this.type=type;
		}
		
		public function getType():String{
			return type;
		}
		public function setType(type:String):void{
			this.type=type;
		}

	}
}