/*
Copyright (c) 2007 Digital Primates IT Consulting Group

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package net.digitalprimates.flex2.mx.controls.shadow
{
	import mx.core.UIComponent;
	import flash.filters.DropShadowFilter;
	import flash.events.Event;
	import flash.display.Graphics;
	import mx.events.ResizeEvent;
	import mx.controls.Image;
	import mx.events.MoveEvent;
	import mx.events.FlexEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;

	public class HangingShadow extends UIComponent
	{
		/** This class should really be something much lighter than a UIComponent
		 *  Perhaps even just drawn on the parent graphics layer. However, this is 
		 *  convenient for blur and scale and the point of this code is to demonstrate 
		 *  the major lifecycle methods of flex. It is not an illustration of best 
		 *  optimization practices **/ 
		protected var blurFilter:BlurFilter = new BlurFilter(32,16,2);

		override protected function updateDisplayList( uw:Number, uh:Number ):void {
			super.updateDisplayList( uw, uh );

			//draw the shadow and change filter settings
			var g:Graphics = graphics;
			g.clear();				
		    var matrix:Matrix = new Matrix( 200, 0, 0, 200, 0, 0 );// = {a:200, b:0, c:0, d:0, e:200, f:0, g:200, h:200, i:1};
		    g.beginGradientFill("radial", [0x000000, 0xFFFFFF], [.7,0], [0x7F, 0x0], matrix, "reflect", "linearRGB");

    		g.drawEllipse( 0, 0, uw, uh );
    		g.endFill();

			this.filters = [blurFilter];
		}

		public function HangingShadow() {
		}
	}
}