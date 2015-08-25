﻿package{	import flash.display.Sprite;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.filters.BitmapFilter;	import flash.filters.DropShadowFilter;		public class Tooltip extends Sprite	{		/* Vars */		//var tween:Tween;		private var tooltip:Sprite = new Sprite();		private var bmpFilter:BitmapFilter;		private var textfield:TextField = new TextField();		private var textformat:TextFormat = new TextFormat();		//var font:Harmony = new Harmony();		public function Tooltip(w:int, h:int, cornerRadius:int, txt:String, bgColor:uint, txtColor:uint, alfa:Number, useArrow:Boolean, dir:String, dist:int):void		{						/* 创建 */			tooltip = new Sprite();			tooltip.graphics.beginFill(bgColor, alfa);					tooltip.graphics.drawRoundRect(0, 0, w, h, cornerRadius, cornerRadius);			tooltip.graphics.endFill();									tooltip.graphics.beginFill(0xff0000, alfa);			if (useArrow && dir == "up")			{				//tooltip.graphics.moveTo(tooltip.width / 2 - 16, tooltip.height);				//tooltip.graphics.lineTo(tooltip.width / 2, tooltip.height + 14.5);				//tooltip.graphics.lineTo(tooltip.width / 2 + 16, tooltip.height - 14.5);												tooltip.graphics.moveTo(tooltip.width / 2 - 20, tooltip.height);				tooltip.graphics.lineTo(tooltip.width / 2 - 25, tooltip.height + 25);								tooltip.graphics.lineTo(tooltip.width / 2 + 10, tooltip.height - 20);								tooltip.graphics.lineTo(tooltip.width / 2 - 20, tooltip.height);			}			if (useArrow && dir == "down")			{				tooltip.graphics.moveTo(tooltip.width / 2 - 16, 0);				tooltip.graphics.lineTo(tooltip.width / 2, -14.5);				tooltip.graphics.lineTo(tooltip.width / 2 + 16, 0);			}			tooltip.graphics.endFill();			/* 滤镜 */			bmpFilter = new DropShadowFilter(4,90,bgColor,0.5,4,4,0.5);			tooltip.filters = [bmpFilter];			addChild(tooltip);						/* 文本属性 */						textfield.selectable = false;						textfield.width = w;			textfield.height = h;			textfield.text = txt;			textfield.x = 10;			textfield.y = 10;						textformat.size = 12;			textformat.color = txtColor;						textfield.setTextFormat(textformat);						tooltip.addChild(textfield);												//tween = new Tween(tooltip,"alpha",Strong.easeOut,0,tooltip.alpha,1,true);		}	}}