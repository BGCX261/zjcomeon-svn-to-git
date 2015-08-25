package
{
	import away3dlite.core.base.*;
	import away3dlite.core.utils.*;
	import away3dlite.loaders.*;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	import com.greensock.*;
	
	import mx.collections.*;
	
	public class ApplicationManager extends BasicTemplate
	{
		private static const SEARCH_STRING:String = "landscape";
		private static const MAX_RESULTS:int = 50;
		private static const API_KEY:String = "7156b88ce37eaec1c270a43c1aac7237";
		private static const PHOTO_HEIGHT:Number = 50;
		private static const PHOTO_WIDTH:Number = PHOTO_HEIGHT * 1.618;
		private static const PHOTO_CLOUD_WIDTH:Number = 1000;
		private static const PHOTO_CLOUD_HEIGHT:Number = 1000;
		private static const PHOTO_CLOUD_DEPTH:Number = 3000;
		private static const NUMBER_PHOTOS:int = 300;
		private static const CAMERA_JUMP_TIME:Number = 3;
		private static const CAMERA_DIST_FROM_PHOTO:Number = 30;
		private static const CAMERA_DIST_JUMP_BACK:Number = 100;
		
		[Embed(source="../media/texture.jpg")]
		protected static const DefaultTexture:Class;
		
		protected var textures:ArrayCollection = new ArrayCollection();
		protected var photos:ArrayCollection = new ArrayCollection();
		protected var loadedTextures:int = 0;	
		
		override protected function onInit():void
		{
			for (var i:int = 0; i < MAX_RESULTS; ++i)
				addTexture(Cast.bitmap(DefaultTexture));
				
			for (var j:int = 0; j < NUMBER_PHOTOS; ++j)
				createPlane();				
			
			flickrSearch(SEARCH_STRING);
			
			this.debug = false;

			
			this.camera.x = 0;
			this.camera.y = 0;
			this.camera.z = 10;	
			this.camera.lookAt(new Vector3D(0, 0, 0), new Vector3D(0, 1, 0));
				
			var randomPhoto:Mesh = photos.getItemAt(Math.random() * (MAX_RESULTS - 1)) as Mesh;
				
			this.camera.x = randomPhoto.x;
			this.camera.y = randomPhoto.y;
			this.camera.z = randomPhoto.z + CAMERA_DIST_FROM_PHOTO;
			
			bezierJump();
		}
		
		protected function addTexture(data:BitmapData):void
		{
			var texture:BitmapMaterial = new BitmapMaterial(data);
			texture.smooth = true;
			textures.addItem(texture);
		}
		
		protected function createPlane():void
		{
			var mesh:Plane = new Plane(textures.getItemAt(Math.random() * (MAX_RESULTS - 1)) as BitmapMaterial, PHOTO_WIDTH, PHOTO_HEIGHT, 1, 1, false);
			
			mesh.x = Math.random() * PHOTO_CLOUD_WIDTH;
			mesh.y = Math.random() * PHOTO_CLOUD_HEIGHT;
			mesh.z = Math.random() * PHOTO_CLOUD_DEPTH;		
			
			scene.addChild(mesh);
			
			photos.addItem(mesh);
		}
		
		public function flickrSearch(search:String):void
		{
			var service:FlickrService = new FlickrService(API_KEY);
			service.addEventListener(FlickrResultEvent.PHOTOS_SEARCH, onPhotosSearch);
  			service.photos.search("", search, "any", "", null, null, null, null, -1, "", MAX_RESULTS, 1);
		}
		
		protected function onPhotosSearch(event:FlickrResultEvent):void 
		{
			for each (var photo:Photo in event.data.photos.photos)
			{
				var imageURL:String = 'http://static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret + '_m.jpg';
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(
					Event.COMPLETE, 
					function(event:Event):void
					{
						var texture:BitmapMaterial = textures.getItemAt(loadedTextures) as BitmapMaterial;
						texture.bitmap = event.currentTarget.content.bitmapData;
						++loadedTextures;
						loadedTextures %= MAX_RESULTS;
					}
				);
				loader.load(new URLRequest(imageURL));	
			}
		}
		
		protected function bezierJump():void
		{
			var randomPhoto:Mesh = photos.getItemAt(Math.random() * (MAX_RESULTS - 1)) as Mesh;
			TweenMax.to(this.camera,CAMERA_JUMP_TIME,
				{
					x: randomPhoto.x,
					y: randomPhoto.y,
					z: randomPhoto.z + CAMERA_DIST_FROM_PHOTO,
					delay: 2,					
					bezier: 
					[{
						x: this.camera.x,
						y: this.camera.y,
						z: this.camera.z + CAMERA_DIST_JUMP_BACK
					}],
					onComplete: bezierJump
				}
			);
		}
	}
}