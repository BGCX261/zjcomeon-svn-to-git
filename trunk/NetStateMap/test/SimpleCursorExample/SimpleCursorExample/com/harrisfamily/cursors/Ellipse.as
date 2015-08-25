package com.harrisfamily.cursors
{
	import flash.display.Sprite;

	public class Ellipse extends Sprite
	{
		public function Ellipse()
		{
			
			this.graphics.lineStyle( 1 , 0x000000 , 1 );
			this.graphics.drawEllipse( 0 , 0 , 50 , 10 );
			
			super();
		}
		
	}
}