/**
 
 The MIT License
 
 Copyright (c) 2008 Duncan Reid ( http://www.hy-brid.com )
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 **/



package com.hybrid.ui {
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	//import fl.transitions.Tween;
	//import fl.transitions.easing.*;
	//import fl.transitions.TweenEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.events.TweenEvent;
	
	/**
	 * Public Setters:
	 
	 *		tipWidth 				Number				Set the width of the tooltip
	 *		titleFormat				TextFormat			Format for the title of the tooltip
	 * 		stylesheet				StyleSheet			StyleSheet object
	 *		contentFormat			TextFormat			Format for the bodycopy of the tooltip
	 *		titleEmbed				Boolean				Allow font embed for the title
	 *		contentEmbed			Boolean				Allow font embed for the content
	 *		align					String				left, right, center
	 *		delay					Number				Time in milliseconds to delay the display of the tooltip
	 *		hook					Boolean				Displays a hook on the bottom of the tooltip
	 *		hookSize				Number				Size of the hook
	 *		cornerRadius			Number				Corner radius of the tooltip, same for all 4 sides
	 *		colors					Array				Array of 2 color values ( [0xXXXXXX, 0xXXXXXX] ); 
	 *		autoSize				Boolean				Will autosize the fields and size of the tip with no wrapping or multi-line capabilities, 
	 helpful with 1 word items like "Play" or "Pause"
	 * 		border					Number				Color Value: 0xFFFFFF
	 *		borderSize				Number				Size Of Border
	 *		buffer					Number				text buffer
	 * 		bgAlpha					Number				0 - 1, transparency setting for the background of the ToolTip
	 *
	 * Example:
	 
	 var tf:TextFormat = new TextFormat();
	 tf.bold = true;
	 tf.size = 12;
	 tf.color = 0xff0000;
	 
	 var tt:ToolTip = new ToolTip();
	 tt.hook = true;
	 tt.hookSize = 20;
	 tt.cornerRadius = 20;
	 tt.align = "center";
	 tt.titleFormat = tf;
	 tt.show( DisplayObject, "Title Of This ToolTip", "Some Copy that would go below the ToolTip Title" );
	 *
	 *
	 * @author Duncan Reid, www.hy-brid.com
	 * @date October 17, 2008
	 * @version 1.2
	 */
	
	public class ToolTip1 extends Sprite {
		
		
		//objects
		private var _stage:Stage;
		private var _parentObject:DisplayObject;
		private var _tf:TextField;  // title field
		private var _cf:TextField;  //content field
		private var _contentContainer:Sprite = new Sprite(); // container to hold both textfields
		//private var _tween:Tween;
		private var _tween:TweenMax;
		
		//formats
		private var _titleFormat:TextFormat;
		private var _contentFormat:TextFormat;
		
		//stylesheet
		private var _stylesheet:StyleSheet;
		
		/* check for stylesheet override */
		private var _styleOverride:Boolean = false;
		
		/* check for format override */
		private var _titleOverride:Boolean = false;
		private var _contentOverride:Boolean = false;
		
		// font embedding
		private var _titleEmbed:Boolean = false;
		private var _contentEmbed:Boolean = false;
		
		//defaults
		private var _defaultWidth:Number = 200;
		private var _defaultHeight:Number;
		private var _buffer:Number = 10;
		private var _align:String = "center"
		private var _cornerRadius:Number = 12;
		private var _bgColors:Array = [0xFFFFFF, 0x9C9C9C];
		private var _autoSize:Boolean = false;
		private var _hookEnabled:Boolean = false;
		private var _delay:Number = 0;  //millilseconds
		private var _hookSize:Number = 10;
		private var _border:Number;
		private var _borderSize:Number = 1;
		private var _bgAlpha:Number = 1;  // transparency setting for the background of the tooltip
		
		//offsets
		private var _offSet:Number;
		private var _hookOffSet:Number;
		
		//delay
		private var _timer:Timer;
		
		
		
		public function ToolTip1():void {
			//do not disturb parent display object mouse events
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
			//setup delay timer
			_timer = new Timer(this._delay, 1);
			_timer.addEventListener("timer", timerHandler);
		}
		
		public function setContent( title:String, content:String = null ):void {
			this.graphics.clear();
			this.addCopy( title, content );
			this.setOffset();
			this.drawBG();
		}
		
		public function show( p:DisplayObject, title:String, content:String=null ):void {
			//get the stage from the parent
			this._stage = p.stage;
			this._parentObject = p;
			// added : DR : 04.29.2010
			var onStage:Boolean = this.addedToStage( this._contentContainer );
			if( ! onStage ){
				this.addChild( this._contentContainer );
			}
			// end add
			this.addCopy( title, content );
			this.setOffset();
			this.drawBG();
			this.bgGlow();
			
			//initialize coordinates
			var parentCoords:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
			var globalPoint:Point = p.localToGlobal(parentCoords);
			this.x = globalPoint.x + this._offSet;
			this.y = globalPoint.y - this.height - 10;
			
			this.alpha = 0;
			this._stage.addChild( this );
			this._parentObject.addEventListener( MouseEvent.MOUSE_OUT, this.onMouseOut );
			//removed mouse move handler in lieu of enterframe for smoother movement
			//this._parentObject.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMovement );
			
			this.follow( true );
			_timer.start();
		}
		
		public function hide():void {
			this.animate( false );
		}
		
		private function timerHandler( event:TimerEvent ):void {
			this.animate(true);
		}
		
		private function onMouseOut( event:MouseEvent ):void {
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.hide();
		}
		
		private function follow( value:Boolean ):void {
			if( value ){
				addEventListener( Event.ENTER_FRAME, this.eof );
			}else{
				removeEventListener( Event.ENTER_FRAME, this.eof );
			}
		}
		
		private function eof( event:Event ):void {
			this.position();
		}
		
		private function position():void {
			var speed:Number = 3;
			var parentCoords:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
			var globalPoint:Point = _parentObject.localToGlobal(parentCoords);
			var xp:Number = globalPoint.x + this._offSet;
			var yp:Number = globalPoint.y - this.height - 10;
			
			var overhangRight:Number = this._defaultWidth + xp;
			if( overhangRight > stage.stageWidth ){
				xp =  stage.stageWidth -  this._defaultWidth;
			}
			if( xp < 0 ) {
				xp = 0;
			}
			if( (yp) < 0 ){
				yp = 0;
			}
			this.x += ( xp - this.x ) / speed;
			this.y += ( yp - this.y ) / speed;
		}
		
		private function addCopy( title:String, content:String = null ):void {
			if( this._tf == null ){
				this._tf = this.createField( this._titleEmbed ); 
			}
			// if using a stylesheet for title field
			if( this._styleOverride ){
				this._tf.styleSheet = this._stylesheet;
			}
			this._tf.htmlText = title;
			
			// if not using a stylesheet
			if( ! this._styleOverride ){
				// if format has not been set, set default
				if( ! this._titleOverride ){
					this.initTitleFormat();
				}
				this._tf.setTextFormat( this._titleFormat );
			}
			if( this._autoSize ){
				this._defaultWidth = this._tf.textWidth + 4 + ( _buffer * 2 );
			}else{
				this._tf.width = this._defaultWidth - ( _buffer * 2 );
			}
			
			
			
			this._tf.x = this._tf.y = this._buffer;
			this.textGlow( this._tf );
			this._contentContainer.addChild( this._tf );
			
			//if using content
			if( content != null ){
				
				if( this._cf == null ){
					this._cf = this.createField( this._contentEmbed );
				}
				
				// if using a stylesheet for title field
				if( this._styleOverride ){
					this._cf.styleSheet = this._stylesheet;
				}
				
				this._cf.htmlText = content;
				
				// if not using a stylesheet
				if( ! this._styleOverride ){
					// if format has not been set, set default
					if( ! this._contentOverride ){
						this.initContentFormat();
					}
					this._cf.setTextFormat( this._contentFormat );
				}
				
				var bounds:Rectangle = this.getBounds( this );
				this._cf.x = this._buffer;
				this._cf.y = this._tf.y +  this._tf.textHeight;
				this.textGlow( this._cf );
				
				if( this._autoSize ){
					var cfWidth:Number = this._cf.textWidth + 4 + ( _buffer * 2 )
					this._defaultWidth = cfWidth > this._defaultWidth ? cfWidth : this._defaultWidth;
				}else{
					this._cf.width = this._defaultWidth - ( _buffer * 2 );
				}
				this._contentContainer.addChild( this._cf );	
			}
		}
		
		//create field
		private function createField( embed:Boolean ):TextField {
			var tf:TextField = new TextField();
			tf.embedFonts = embed;
			tf.gridFitType = "pixel";
			//tf.border = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			if( ! this._autoSize ){
				tf.multiline = true;
				tf.wordWrap = true;
			}
			return tf;
		}
		
		//draw background, use drawing api if we need a hook
		private function drawBG():void {
			/* re-add : 04.29.2010 : clear graphics in the event this is a re-usable tip */
			this.graphics.clear();
			/* end add */
			var bounds:Rectangle = this.getBounds( this );
			
			var h:Number = isNaN( this._defaultHeight ) ? bounds.height + ( this._buffer * 2 ) : this._defaultHeight;
			var fillType:String = GradientType.LINEAR;
			//var colors:Array = [0xFFFFFF, 0x9C9C9C];
			var alphas:Array = [ this._bgAlpha, this._bgAlpha];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			var radians:Number = 90 * Math.PI / 180;
			matr.createGradientBox(this._defaultWidth, h, radians, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			if( ! isNaN( this._border )){
				this.graphics.lineStyle( _borderSize, _border, 1 );
			}
			this.graphics.beginGradientFill(fillType, this._bgColors, alphas, ratios, matr, spreadMethod); 
			if( this._hookEnabled ){
				var xp:Number = 0; var yp:Number = 0; var w:Number = this._defaultWidth; 
				this.graphics.moveTo ( xp + this._cornerRadius, yp );
				this.graphics.lineTo ( xp + w - this._cornerRadius, yp );
				this.graphics.curveTo ( xp + w, yp, xp + w, yp + this._cornerRadius );
				this.graphics.lineTo ( xp + w, yp + h - this._cornerRadius );
				this.graphics.curveTo ( xp + w, yp + h, xp + w - this._cornerRadius, yp + h );
				
				//hook
				this.graphics.lineTo ( xp + this._hookOffSet + this._hookSize, yp + h );
				this.graphics.lineTo ( xp + this._hookOffSet , yp + h + this._hookSize );
				this.graphics.lineTo ( xp + this._hookOffSet - this._hookSize, yp + h );
				this.graphics.lineTo ( xp + this._cornerRadius, yp + h );
				
				this.graphics.curveTo ( xp, yp + h, xp, yp + h - this._cornerRadius );
				this.graphics.lineTo ( xp, yp + this._cornerRadius );
				this.graphics.curveTo ( xp, yp, xp + this._cornerRadius, yp );
				this.graphics.endFill();
			}else{
				this.graphics.drawRoundRect( 0, 0, this._defaultWidth, h, this._cornerRadius );
			}
		}
		
		
		
		
		/* Fade In / Out */
		
		private function animate( show:Boolean ):void {
			var end:int = show == true ? 1 : 0;
			// added : DR : 04.29.2010
			//if( _tween != null && _tween.isPlaying ) {
			
			if( _tween != null) {	
				//_tween.stop();
				_tween.kill();
			}
			// end add
			//_tween = new Tween( this, "alpha", Strong.easeOut, this.alpha, end, .5, true );
			_tween = new TweenMax(this,0.5,{autoAlpha:1});
			if( ! show ){
				//_tween.addEventListener( TweenEvent.MOTION_FINISH, onComplete );
				_tween.addEventListener( TweenEvent.COMPLETE, onComplete );
				_timer.reset();
			}
		}
		
		private function onComplete( event:TweenEvent ):void {
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.cleanUp();
		}
		
		/* End Fade */
		
		
		
		
		/** Getters / Setters */
		
		public function set buffer( value:Number ):void {
			this._buffer = value;
		}
		
		public function get buffer():Number {
			return this._buffer;
		}
		
		public function set bgAlpha( value:Number ):void {
			this._bgAlpha = value;
		}
		
		public function get bgAlpha():Number {
			return this._bgAlpha;
		}
		
		public function set tipWidth( value:Number ):void {
			this._defaultWidth = value;
		}
		
		public function set titleFormat( tf:TextFormat ):void {
			this._titleFormat = tf;
			if( this._titleFormat.font == null ){
				this._titleFormat.font = "_sans";
			}
			this._titleOverride = true;
		}
		
		public function set contentFormat( tf:TextFormat ):void {
			this._contentFormat = tf;
			if( this._contentFormat.font == null ){
				this._contentFormat.font = "_sans";
			}
			this._contentOverride = true;
		}
		
		public function set stylesheet( ts:StyleSheet ):void {
			this._stylesheet = ts;
			this._styleOverride = true;
		}
		
		public function set align( value:String ):void {
			var a:String = value.toLowerCase();
			var values:String = "right left center";
			if( values.indexOf( value ) == -1 ){
				throw new Error( this + " : Invalid Align Property, options are: 'right', 'left' & 'center'" );
			}else{
				this._align = a;
			}
		}
		
		public function set delay( value:Number ):void {
			this._delay = value;
			this._timer.delay = value;
		}
		
		public function set hook( value:Boolean ):void {
			this._hookEnabled = value;
		}
		
		public function set hookSize( value:Number ):void {
			this._hookSize = value;
		}
		
		public function set cornerRadius( value:Number ):void {
			this._cornerRadius = value;
		}
		
		public function set colors( colArray:Array ):void {
			this._bgColors = colArray;
		}
		
		public function set autoSize( value:Boolean ):void {
			this._autoSize = value;
		}
		
		public function set border( value:Number ):void {
			this._border = value;
		}
		
		public function set borderSize( value:Number ):void {
			this._borderSize = value;
		}
		
		public function set tipHeight( value:Number ):void {
			this._defaultHeight = value;
		}
		
		public function set titleEmbed( value:Boolean ):void {
			this._titleEmbed = value;
		}
		
		public function set contentEmbed( value:Boolean ):void {
			this._contentEmbed = value;
		}
		
		
		
		
		/* End Getters / Setters */
		
		
		
		/* Cosmetic */
		
		private function textGlow( field:TextField ):void {
			var color:Number = 0x000000;
			var alpha:Number = 0.35;
			var blurX:Number = 2;
			var blurY:Number = 2;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var filter:GlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			field.filters = myFilters;
		}
		
		private function bgGlow():void {
			var color:Number = 0x000000;
			var alpha:Number = 0.20;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var filter:GlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters;
		}
		
		private function initTitleFormat():void {
			_titleFormat = new TextFormat();
			_titleFormat.font = "_sans";
			_titleFormat.bold = true;
			_titleFormat.size = 20;
			_titleFormat.color = 0x333333;
		}
		
		private function initContentFormat():void {
			_contentFormat = new TextFormat();
			_contentFormat.font = "_sans";
			_contentFormat.bold = false;
			_contentFormat.size = 14;
			_contentFormat.color = 0x333333;
		}
		
		/* End Cosmetic */
		
		
		
		/* Helpers */
		
		private function addedToStage( displayObject:DisplayObject ):Boolean {
			var hasStage:Stage = displayObject.stage;
			return hasStage == null ? false : true;
		}
		/*
		//Check if font is a device font
		private function isDeviceFont( format:TextFormat ):Boolean {
		var font:String = format.font;
		var device:String = "_sans _serif _typewriter";
		return device.indexOf( font ) > -1;
		//_sans
		//_serif
		//_typewriter
		}
		
		private function isDeviceStyleSheet( sheet:StyleSheet ):Boolean {
		var styleNames:Array = sheet.styleNames;
		var len:int = styleNames.length;
		var isDevice:Boolean = false;
		for( var i:int = 0; i < len; i++ ){
		//var style:String = styleNames[i];
		var style:Object = sheet.getStyle(styleNames[i]);
		var fmt:TextFormat = new TextFormat();
		fmt = sheet.transform( style );
		var isDeviceFont:Boolean = this.isDeviceFont( fmt );
		//trace("IS DEVICE FONT : " + isDeviceFont );
		}
		return false;
		}
		*/
		
		private function setOffset():void {
			switch( this._align ){
				case "left":
					this._offSet = - _defaultWidth +  ( _buffer * 3 ) + this._hookSize; 
					this._hookOffSet = this._defaultWidth - ( _buffer * 3 ) - this._hookSize; 
					break;
				
				case "right":
					this._offSet = 0 - ( _buffer * 3 ) - this._hookSize;
					this._hookOffSet =  _buffer * 3 + this._hookSize;
					break;
				
				case "center":
					this._offSet = - ( _defaultWidth / 2 );
					this._hookOffSet =  ( _defaultWidth / 2 );
					break;
				
				default:
					this._offSet = - ( _defaultWidth / 2 );
					this._hookOffSet =  ( _defaultWidth / 2 );;
					break;
			}
		}
		
		/* End Helpers */
		
		
		
		/* Clean */
		
		private function cleanUp():void {
			this._parentObject.removeEventListener( MouseEvent.MOUSE_OUT, this.onMouseOut );
			//this._parentObject.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMovement );
			this.follow( false );
			this._tf.filters = [];
			this.filters = [];
			this._contentContainer.removeChild( this._tf );
			this._tf = null;
			if( this._cf != null ){
				this._cf.filters = []
				this._contentContainer.removeChild( this._cf );
			}
			this.graphics.clear();
			removeChild( this._contentContainer );
			parent.removeChild( this );
		}
		
		/* End Clean */
		
		
		/* 
		private function onMouseMovement( event:MouseEvent ):void {
		var parentCoords:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
		var globalPoint:Point = _parentObject.localToGlobal(parentCoords);
		this.x = globalPoint.x - this.width;
		this.y = globalPoint.y - this.height - 10;
		event.updateAfterEvent();
		}
		*/
		
		
		
		
	}
}
