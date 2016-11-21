package 
{
	import aurora.core.FontStyle;
	import aurora.mobile.skins.Skin;
	import aurora.mobile.utils.ScaleBitmap;
	import aurora.mobile.utils.ScaleShape;
	import aurora.resource.caches.ResourcePool;
	import aurora.utils.Reflection;
	
	import com.preloader.PreUrl;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 * 所有样式在此定义
	 */
	public class Style
	{
		/**
		 * 指定名称和URL获取位图数据
		 */
		public static function getBitmapData(name:String, url:String = ""):BitmapData
		{
			if(!url)
			{
				url = PreUrl.MAIN_UI;
			}
			if (name == null || url == null)
				return null;
			var bitmapdata:BitmapData=null;
			var clazz:Class=Reflection.getClass(name, ResourcePool.get(url));
			if (clazz)
			{
				bitmapdata=new clazz(0, 0);
			}
			else
			{
				if(name)
				{
					trace("并未在'" + url +"'找到'" + name + "'");
				}
			}
			return bitmapdata;
		}
		
		public static function getBitmap(name:String, url:String = ""):Bitmap
		{
			var result:Bitmap = null;
			var data:BitmapData = getBitmapData(name, url);
			if(data)
			{
				result = new Bitmap(data);
			}
			return result;
		}
		
		public static function getScaleBitmap(name:String, url:String = "", rect:Rectangle=null):Bitmap
		{
			var result:ScaleBitmap = null;
			var data:BitmapData = getBitmapData(name, url);
			if(data)
			{
				result = new ScaleBitmap(data);
				result.scale9Grid = rect;
			}
			return result;
		}
		
		public static function getScaleShape(name:String, url:String = "", rect:Rectangle=null):Shape
		{
			var result:ScaleShape = null;
			var data:BitmapData = getBitmapData(name, url);
			if(data)
			{
				result = new ScaleShape(data);
				result.scale9Grid = rect;
			}
			return result;
		}
		
		/**
		 * 供外部使用获取普通皮肤的方法
		 * @param name
		 * @param url
		 * @param rect
		 * @return
		 *
		 */
		public static function getSkin(name:String, url:String = "", rect:Rectangle=null):Skin
		{
			if(!url)
			{
				url = PreUrl.MAIN_UI;
			}
			var skin:Skin=new Skin(getBitmapData(name, url), rect);
			return skin;
		}
		
		/**
		 * 获得文本样式 
		 * @param fontsize
		 * @param color
		 * @param bold
		 * @param align 对齐方式
		 * @param italic 是否斜体
		 * @return 
		 * 
		 */		
		public static function getFormat(fontsize:int = 18, color:uint = 0xfff779, bold:Boolean=true, align:String = "center", italic:Boolean = false):TextFormat
		{
			var result:TextFormat = new TextFormat(FontStyle.defaultFontName);
			result.size = fontsize;
			result.color = color;
			if(bold)
			{
				result.bold = "bold";
			}
			result.align = align;
			result.italic = italic;
			
			return result;
		}
		
	}
}