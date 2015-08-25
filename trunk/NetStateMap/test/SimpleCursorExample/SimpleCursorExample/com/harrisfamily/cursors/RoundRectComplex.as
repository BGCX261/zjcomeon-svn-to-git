package com.harrisfamily.cursors
{
	import flash.display.Sprite;

	public class RoundRectComplex extends Sprite
	{
		public function RoundRectComplex()
		{

			this.graphics.lineStyle( 1 , 0x000000 , 1 );
			this.graphics.drawRoundRectComplex( 0 , 0 , 45 , 25 , 5 , 0 , 0 , 5 );		
			
			super();
			
		}
		
	}
}