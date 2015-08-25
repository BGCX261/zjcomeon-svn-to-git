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

package net.digitalprimates.flex2.mx.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.AnimateProperty;
	import mx.effects.easing.*;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import net.digitalprimates.flex2.mx.controls.shadow.HangingShadow;
	
	use namespace mx_internal;

[Style(name="baseShadowDistance", type="Number", inherit="no")]
[Style(name="baseShadowHeight", type="Number", inherit="no")]
[Style(name="blurRatio", type="Number", inherit="no")]
[Style(name="circleSmooshAmount", type="Number", inherit="no")]

[IconFile("Carousel.png")]
[Event(name="animationComplete", type="flash.events.Event")]

	public class Carousel extends Container
	{
		public static const INITIAL_SCALE:Number = 1;

		/** Index of the currently selected child as they were originally specified to the component
		 *  As we are playing with depths and resetting child indicies throughout this component, 
		 * getChildAt( selectedIndex ) may not be the same as selectedChild
		 **/
		private var _selectedIndex:int = 0;
		private var _selectedChild:UIComponent;
		
		/** Representation of the main child's representation in radians
		 **/
		private var _currentPosition:Number = 0;

		/** Describes if the circle will move children horizontally or vertically
		 **/
		private var _direction:String = "horizontal";

		/** A container that holds all of the drawn drop shadows.
		 **/
		protected var shadowContainer:Container;

		/** Radius of the circle determined by the width of the circle and the children
		 *  As we don't want the circle's radius shrinking or growing during animation, we determine
		 *  this size by subtracting the width of the widest child from the borders. This ensures every
		 *  child has sufficient room to clear the edges of the screen.
		 *  If there is insufficient size for the minSizes of the children to fit, the radius will be the smallest
		 *  size capable of maneuvering all children, reardless of unscaledWidth and unscaledHeight, causing scrollbars
		 **/
		protected var radius:Number = 100;

		/** internal state variables used by commit properties when a change to either selectedIndex or selectedChild occurs **/		
		protected var selectedIndexChanged:Boolean = false;

		/** An offset, in radians, added to the position of every child. This simply guarantees that the child at position 0
		 * is at the very front instead of the right hand side **/		
		protected static const radianOffset:Number = Math.PI/2;

		/** The blurEffectDictionary holds references to the blur effects, using the actual child as a key. There are other ways
		 *  to approach this, however, this is extremely fast as we use the reference to the child as our entry in the hashmap to
		 *  modify the blur as the child moves into the background**/		
		protected var blurEffectDictionary:Dictionary = new Dictionary( false );

		/** The shadowDictionary holds references to the hanging shadows, using the actual child as a key. This is extremely fast as 
		 * we use the reference to the child as our entry in the hashmap to modify the shadow as the child moves into the background**/		
		protected var shadowDictionary:Dictionary = new Dictionary( false );

		/** The orderedChildren holds references to the children of this container in their originally specified order. As the children
		 *  move around the circle, it is necessary to change their childIndex to ensure they do not overlap. This array preserves the
		 * original order specified by the user**/		
		protected var orderedChildren:Array;

		/** The orderedChildDepths is an array collection that uses the ordererChildren as a source. It applies a sort
		 *  function which keeps the children sorted by their 'y' position. Using this order, we set the child index to
		 *  ensure that the children overlap eachother correctly
		 ***/		
		protected var orderedChildDepths:ArrayCollection;

		/** A reference to an animate property effect that will be used when the selectedIndex or selectedChild is changed**/		
		protected var animateProperty:AnimateProperty;

		/** The selectedIndex indicates the 0-based index of the currently selected (most forward) child. Changing this index
		 * causes the Carousel to animate to the appropriate position **/
		[Bindable("change")]
		public function get selectedIndex():int {
			return _selectedIndex;
		}

		public function set selectedIndex( value:int ):void {
			if ( _selectedIndex == value )
				return;
				
			_selectedIndex = value;
			selectedIndexChanged = true;
			dispatchEvent( new Event( 'change' ) );
			this.invalidateProperties();
		}

		/** The selectedChild contains a reference to the child at the currently selected index (selectedIndex = 0 )
		 * Changing this value causes the Carousel to animate to the appropriate position **/
		[Bindable("change")]
		public function get selectedChild():UIComponent {
			return _selectedChild;
		}

		public function set selectedChild( value:UIComponent ):void {
			if ( _selectedChild == value )
				return;
				
			_selectedChild = value;
			
			for ( var i:int=0; i<orderedChildren.length; i++ ) {
				if ( orderedChildren[i] == value ) {
					this.selectedIndex = i;
					break;
				}
			}
		}
		
		/** When animating the change of position, current position contains the location (in radians) of the current position. This will likely be
		 *  a numeric number between the integer selectedIndex values. So, when animating between selectedIndex 1 and 2, the currentPosition will
		 *  move in tenths of a radian between those two values over a fixed amount of time. **/
		[Bindable("currentPositionChanged")]
		public function get currentPosition():Number {
			return _currentPosition;
		}

		public function set currentPosition(value:Number):void {
			_currentPosition = value;
			
			dispatchEvent( new Event( 'currentPositionChanged' ) );
			
			invalidateDisplayList();

			if ( currentPosition == selectedIndex ) {
				dispatchEvent( new Event( 'animationComplete' ) );
			}
		}

		/** Direction determines if the pieces animate horizontally or vertically **/
	    [Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="horizontal")]
		public function get direction():String {
			return _direction;
		}

		public function set direction(value:String):void {
			_direction = value;
			//Not implemented in this version. 
			//Direction allows the user to create a carousel or ferris wheel like component
			invalidateDisplayList();
		}

		/** These methods are responsible for setting our default styles if a user does not 
		 * specify them in a style sheet or some other capacity. This method works very well 
		 * and is from the mind of Michael Schmalle of Teoti Graphix [http://www.teotigraphix.com/]
		 **/
		private static var stylesInited:Boolean = initStyles();
		public static function createSelector(selectorName:String):CSSStyleDeclaration  {
			var selector:CSSStyleDeclaration =
			StyleManager.getStyleDeclaration(selectorName);
			
			if (!selector) {
				selector = new CSSStyleDeclaration();
				StyleManager.setStyleDeclaration(selectorName, selector, false);
			}
			
			return selector;
		} 
		   
		protected static function initStyles():Boolean {
			var styles:CSSStyleDeclaration = createSelector("Carousel");
			   
			styles.defaultFactory = function():void {
				this.baseShadowDistance = 60;
				this.baseShadowHeight = 10;
				this.blurRatio = 13.375;
				this.circleSmooshAmount = .1;
				this.horizontalScrollPolicy = "off";
				this.verticalScrollPolicy = "off";		
			}
	
			return true;
		}

		/** This method is called to compute our point on a circle with a given center, a given radius and a given number
		 *  of radians. We also vertically 'smoosh' the circle by multiplying its value by a provided multiplier
		 *  'circleSmooshAmount'. This gives us the appearance of an elipse with less complexity.
		 **/
		protected function getPointOnCircle( center:Point, radius:Number, t:Number ):Point {
			var point:Point = new Point();
			point.x = center.x + radius * Math.cos( t );
			point.y =  center.y + ( radius * Math.sin( t ) * getStyle( "circleSmooshAmount" ) );
			return point;
		}

		/** This method is called to compute the current scale of our child given their position on the circle.
		 *  As children move toward the background, they get smaller according to the return of this method
		 **/
		protected function getScale( center:Point, radius:Number, yPosition:Number ):Number {
			var distanceFromBottom:Number = ( center.y + ( radius * getStyle( "circleSmooshAmount" ) ) - yPosition );
			var scaleAmount:Number = ( INITIAL_SCALE - ( distanceFromBottom/500 ) );
			
			return scaleAmount;
		}

		/** This method is called to compute the current blur of our child given their position on the circle.
		 *  As children move toward the background, they get increasingly blurred according to the return of this method
		 **/
		protected function getBlur( center:Point, radius:Number, yPosition:Number ):Number {
			var distanceFromBottom:Number = ( center.y + ( radius * getStyle( "circleSmooshAmount" ) ) - yPosition );
			var blurAmount:Number = distanceFromBottom/(getStyle( "blurRatio" ));

			return blurAmount;
		}

		/** This method is called to compute the distance between the child and the child's shadow given their position on the circle.
		 *  As children move toward the background, the shadow gets closer to the child based on the return of this method 
		 **/
		protected function getShadowDistance( center:Point, radius:Number, yPosition:Number ):Number {
			var distanceFromBottom:Number = ( center.y + ( radius * getStyle( "circleSmooshAmount" ) ) - yPosition );
			var shadowDistance:Number = getStyle( "baseShadowDistance" ) - ( distanceFromBottom/2 );

			return shadowDistance;
		}

		/** This is a convenience method. It allows us to specify the center of the child as a point, and computes the
		 *  X and Y offset required to center the child. It also calls methods to move the child forward or backward
		 *  in z-index to ensure the animations are correct **/
		protected function childCenterMove( child:UIComponent, point:Point ):void {
			child.move( point.x-(child.width/2), point.y-(child.height/2) );

			//We referesh the orderedChildDepths so that it applies the sort function right now. This collection is
			//sorted by y position. In our component, the y-position directly corresponds to the depth here. The
			//further down the screen, the 'closer' it is to the user
			orderedChildDepths.refresh();
			
			//Now set the child index based on the position of this item in the sorted collection
			setChildIndex( child, orderedChildDepths.getItemIndex( child ) );
		}

		/** This is a debugging method. It simply draws the path that our children take through layout so
		 *  we can ensure they adhere to the path **/
		public function drawPath():void {
			var centerOfCircle:Point = new Point( unscaledWidth/2, unscaledHeight/2 ); 

			graphics.clear();
			graphics.lineStyle( 2, 0xFFFFFF );

			graphics.moveTo( unscaledWidth/2, unscaledHeight/2 );
			for ( var t:Number=0;t<2*Math.PI; t+=.01 ) {
				var newPoint:Point = getPointOnCircle( centerOfCircle, radius, t );
				graphics.lineTo( newPoint.x, newPoint.y );
			}
		}

		/** By default, the container class looks to see if we have a border. If we do not, it
		 *  moves the contentPane to the 0th position. Unfortunately, that would move our shadows in
		 *  front of our carousel objects. By overriding this method, we are just setting our shadowContainer
		 *  to be the 0th index child if and when flex needs to create a contentPane (needs to scroll this container) **/
		override mx_internal function createContentPane():void {
			super.createContentPane();
			
			this.rawChildren.setChildIndex( shadowContainer, 0 );
		}

		/** updateDisplayList does the animation time heavy lifting. It determines the size of the circle that can be drawn.
		 *  The padding between each child around the circle and then calls method to size, determine the position, scale and
		 *  blur of each of the children. Those values are then applied. Note, updateDisplay list uses our orderedChildren
		 *  array to ensure the original order of the children is preserved despite our manipulations of their order.
		 **/
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void {
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			var centerOfCircle:Point = new Point( unscaledWidth/2, unscaledHeight/2 ); 

			//We resize the shadowContainer to the same size as our component.
			//This ensures that the x and y positions of the components moving around the carousel
			//track with the x and y of the shadows moving on this container
			shadowContainer.setActualSize( unscaledWidth, unscaledHeight );
			
			var maxChildWidth:Number = 0;
			var child:UIComponent;
			for ( var i:int=0; i<orderedChildren.length; i++ ) {
				child = orderedChildren[ i ] as UIComponent;
				child.setActualSize( child.getExplicitOrMeasuredWidth(), child.getExplicitOrMeasuredHeight() );
				maxChildWidth = Math.max( maxChildWidth, child.width );
			}

			radius = ( unscaledWidth /2 ) - ( maxChildWidth / 2 ) ;
			
			/** In a circle, we have a total of 2pi radians. So, in this case, we take the number of children present
			 * and divide up those sizes that everything spaces evenly **/
			var childPaddingInRadians:Number;
			var childDistanceInRadians:Number;
			childPaddingInRadians = (2*Math.PI)/(numChildren);
			
			for ( var j:int=0; j<orderedChildren.length; j++ ) {
				child = orderedChildren[ j ] as UIComponent;
				
				childDistanceInRadians = (j*childPaddingInRadians) + radianOffset - ( currentPosition * childPaddingInRadians ) ;
				var newPoint:Point = getPointOnCircle( centerOfCircle, radius, childDistanceInRadians );
				
				//Set the appropriate scale of the children as the move backward in 3d space.
				var scale:Number =  getScale( centerOfCircle, radius, newPoint.y );
				child.scaleX = scale;
				child.scaleY = scale;

				//Reapply the blur to the child. The base amount is determined by a style
				var blur:Number = getBlur( centerOfCircle, radius, newPoint.y );				
				( blurEffectDictionary[ child ] as BlurFilter ).blurX = blur;
				( blurEffectDictionary[ child ] as BlurFilter ).blurY = blur;
				( blurEffectDictionary[ child ] as BlurFilter ).quality = 1;
				child.filters = [ blurEffectDictionary[ child ] ];

				childCenterMove( child, newPoint );

				//Position the hanging shadow below the child. The base distance is determined by a style
				//This only works as the shadowContainer is mapped to the same size as this component so the
				//x and y positions correspond 1 to 1
				var shadow:HangingShadow;
				shadow = ( shadowDictionary[ child ] as HangingShadow );
				shadow.setActualSize( child.width, getStyle("baseShadowHeight") );
				shadow.move( child.x, child.y + child.height + getShadowDistance( centerOfCircle, radius, newPoint.y ) );
				shadow.scaleY = scale;
			}
		}

		/** commitProperties starts the majority of the heavy lifting here. It is called by use when the selectedIndex or selectedChild
		 *  changes. We create a new animation effect that moves us from the current selected index to the newly selectedIndex.
		 *  Sometimes it is easier to move around the circle to the right, and sometimes to the left, to acheive this result. The
		 *  commitProperties makes this determination and sets up the proper values and starts the effect playing.
		 *  selectedChild changes
		 **/
		override protected function commitProperties():void {
			super.commitProperties();

			if ( selectedIndexChanged ) {
				selectedIndexChanged = false;
				
				if ( !animateProperty ) {
					animateProperty = new AnimateProperty( this );
				}
				
				if ( !animateProperty.isPlaying ) {
					//Current position can get bigger and bigger, let's ensure we stay real and realize that it is just a factor
					//of the number of children 
					currentPosition %= numChildren;
					
					if ( currentPosition < 0 ) {
						currentPosition = numChildren + currentPosition;
					}
				}

				//Determine if it is easier to move right or left around the circle to get to our new position
				var newPosition:Number;
				var moveVector:Number = selectedIndex-currentPosition;
				var moveScalar:Number = Math.abs( moveVector );
				
				if ( moveScalar > ( numChildren/2 ) ) {
					if ( moveVector < 0 ) {
						newPosition = numChildren + selectedIndex;
					} else {
						newPosition = ( selectedIndex - numChildren );
					}
				} else {
					newPosition = selectedIndex;
				}

				animateProperty.property = "currentPosition";
				animateProperty.fromValue = currentPosition;
				animateProperty.toValue = newPosition;
				//The duration of this effect is based on how far we must move. This way a one position move is not painfully slow 
				animateProperty.duration = 700 * Math.abs( currentPosition-newPosition );
				animateProperty.easingFunction = Quadratic.easeInOut;
				animateProperty.suspendBackgroundProcessing = true;
				animateProperty.play();
			}
		}
		
		/** 
		 * We implmenet a measure method in this component to provide a concept of why we might do so. In truth, this 
		 * component makes most of its calculations based on the largest radius we could have in the given space. So,
		 * implementing a measure method is a little strange. We are specifying how much space we need, which is really
		 * dependent upon how much we are given. 
		 *
		 * Here we decide that we need 2.5 times the space of the largest child at mimimum and enough space for all 
		 * of the children arranged horizontally, ideally. If we have this much space, we know that we can at least 
		 * display some form of a carousel and center the middle child.
		 *  
		 * For height we ask for 50% more than the tallest child. We also need to take into account our shadowDistance and size.
		 * 
		 **/
		override protected function measure():void {
			super.measure();

			var maxChildWidth:Number = 0;
			var maxChildHeight:Number = 0;
			var totalWidth:Number = 0;
			var child:UIComponent;
			for ( var i:int=0; i<numChildren; i++ ) {
				child = getChildAt( i ) as UIComponent;
				maxChildWidth = Math.max( maxChildWidth, child.getExplicitOrMeasuredWidth()/child.scaleX );
				maxChildHeight = Math.max( maxChildHeight, child.getExplicitOrMeasuredHeight()/child.scaleY );
				totalWidth += ( child.getExplicitOrMeasuredWidth()/child.scaleX ); 
			}
			
			this.measuredMinWidth = maxChildWidth * 2.5;
			this.measuredWidth = totalWidth/2;
			
			this.measuredMinHeight = measuredHeight = ( maxChildHeight * 1.5 ) + getStyle( 'baseShadowDistance' ) + getStyle("baseShadowHeight"); 
		}

		/** CreateChildren is overriden here to provide some additional functionality. After the children are created, we loop through
		 *  the available children and setup a blurEffect for each and add them to the orderedChildren array to preserve their originally
		 *  intended order moving forward. 
		 * 
		 *  Next we create hang shadows for each of the children and add these shadows to a shadow container. The shadows, like the
		 *  blurs, are mapped to the children using dictionaries for ease of retrieval. We create the separate shadow container to ensure
		 *  the shadows are also clipped when required by the container
		 **/
		override protected function createChildren():void {
			super.createChildren();

			if ( !shadowContainer ) {
				shadowContainer = new Container();
				//We need the shadow container to always underlay the other display objects, so we add it at position 0 
				this.rawChildren.addChildAt( shadowContainer, 0 );
			}

			orderedChildren = new Array();
			var child:UIComponent;
			var shadow:HangingShadow;
			for ( var i:int=0; i<numChildren; i++ ) {
				child = getChildAt(i) as UIComponent;
				child.addEventListener(MouseEvent.CLICK, handleItemClick, false, 0, true );
				orderedChildren.push( child );
				blurEffectDictionary[ child ] = new BlurFilter( 0, 0, 1 );
				child.filters = [ blurEffectDictionary[ child ] ];

				shadow = new HangingShadow();
				shadowDictionary[ child ] = shadow;
				shadowContainer.addChild( shadow );
			}

			//Create a new array collection based on the children in the orderedChildren array 
			orderedChildDepths = new ArrayCollection( orderedChildren );
			
			//Establish a new for this collection Sort based on the 'y' property of the UIComponent being displayed
			var sort:Sort = new Sort();
			sort.fields = [new SortField( 'y', false, false, true ) ];
			orderedChildDepths.sort = sort;
			orderedChildDepths.refresh();
		}

		/** When a child is clicked, we ensure it becomes the newly selectedChild **/
		protected function handleItemClick( event:MouseEvent ):void {
			this.selectedChild = event.currentTarget as UIComponent;
		}
		
		public function Carousel() {
			super();
		}		
	}
}