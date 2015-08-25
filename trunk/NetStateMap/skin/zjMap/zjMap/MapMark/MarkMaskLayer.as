package zjMap.MapMark
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;

	public class MarkMaskLayer extends Sprite
	{
		private var bg:Sprite;
		private var bgmask:Sprite;
		private var ld:Loader;
		private var _layerShow:Boolean;
		private var url:String = "images/marker/markmasklayer.png";
		
		private var shadow:DropShadowFilter = new DropShadowFilter(4,90,0x000000,0.32);
		
		public function MarkMaskLayer(width:Number,height:Number)
		{
			
			bg = new Sprite();
			this.addChild(bg);
			
			bgmask = new Sprite();
			this.addChild(bgmask);
			
			_layerShow = false;
			
			reDraw(width,height);
			
			createImage()
		}
		
		/**
		 * 重新绘制背景层
		 * @param width:宽
		 * @param height:高
		 * */
		public function reDraw(width:Number,height:Number):void{
				bg.filters = null;
				bg.graphics.clear();
				
				bg.graphics.beginFill(0x333333,.6);
				bg.graphics.drawRect(0,0,width,height);
				
				bg.graphics.endFill();
				
				bg.filters = [ shadow ]
					
				reBgMaskDraw(width,height);
		}
		
		public function reBgMaskDraw(width:Number,height:Number):void{
			
			bgmask.graphics.clear();
			
			bgmask.graphics.beginFill(0x333333,.6);
			bgmask.graphics.drawRect(0,0,width,height);
			
			bgmask.graphics.endFill();
			
		}
		
		public function setBgHeight(height:Number):void{
			TweenLite.to(bg,1,{height:height});
			TweenLite.to(bgmask,1,{height:height});
		}
		
		private function createImage():void{
			ld =new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			loadImage(url);
		}
		
		private function loadComplete(evt:Event):void{
			/*if(this.numChildren > 0){
				this.removeChildAt(0);
			}*/
			var image:Bitmap = Bitmap(ld.content);
			image.width = 1400;
			image.height = 1200;
			this.addChild(image);
			
			image.mask = bgmask;
		}
		
		/**
		 * 加载图标
		 * */
		private function loadImage(url:String):void{
			ld.load(new URLRequest(url));
		}
		
		private function onToggleImage():void{
			if(layerShow){
				layerShow = false;
				
				loadImage(url);
				
			}else{
				layerShow = true;
				
				loadImage(url);
			}
		}

		public function get layerShow():Boolean
		{
			return _layerShow;
		}

		public function set layerShow(value:Boolean):void
		{
			_layerShow = value;
		}

	}
}