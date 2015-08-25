package zjMap.skin 
{
	import flash.events.ProgressEvent;
	
	import mx.preloaders.DownloadProgressBar;

	public class Preloader extends DownloadProgressBar {
		
		public function Preloader() { 
			super();
			//var img:Image;            
			//加载背景图片没有成功，如果哪位知道 请赐教
			//this.backgroundImage = img;
			
			downloadingLabel="正在下载应用";
			//var d:DownloadProgressBar=new DownloadProgressBar();
			showPercentage=true;             //显示上载百分数
			
			initializingLabel="初始化应用";
			
			MINIMUM_DISPLAY_TIME=2000;
		}
		
		override protected function showDisplayForInit( elapsedTime:int, count:int):Boolean {
			return true;
		}
		
		override protected function showDisplayForDownloading( elapsedTime:int, event:ProgressEvent):Boolean {
			return true;
		}
	}
}

