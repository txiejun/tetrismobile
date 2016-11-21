package com.manager
{
	import aurora.core.GlobalSetting;
	import aurora.resource.caches.ResourcePool;
	import aurora.timer.TimerManager;
	import aurora.utils.Reflection;
	
	import com.preloader.PreUrl;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;
	
	public class CursorManager extends EventDispatcher
	{
		private var lib:Dictionary;
		private var cursors:Dictionary;
		private var currentName:String="";
		private var cursorLayer:Stage;
		private var queue:Array;
		public var enabledCursor:Boolean=true; //禁止使用鼠标管理器
		public static var handlerEnabled:Boolean; //是否禁止其它操作

		public function CursorManager()
		{
			lib=new Dictionary();
			cursors=new Dictionary();
			queue=[];
		}

		public static function init(c:Stage):void
		{
			getInstance().cursorLayer=c;
		}

		private static var instance:CursorManager;

		public static function getInstance():CursorManager
		{
			if (instance == null)
			{
				instance=new CursorManager();
			}
			return instance;
		}

		public static function setCursor2():void
		{
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(0, 0);
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(5, true);
			var frame:BitmapData = null;
			var clazz:Class;
			for(var i:int = 1; i<= 5; ++i)
			{
				clazz = Reflection.getClass("sysCursor_" + i, ResourcePool.get(PreUrl.MOVIE_UI));
				if (clazz)
				{
					frame=new clazz(0, 0);
				}
				bitmapDatas[i-1] = frame;
			}
			cursorData.data = bitmapDatas;
			cursorData.frameRate = 5;
			Mouse.registerCursor("myAnimatedCursor", cursorData);
//			Mouse.cursor = "myAnimatedCursor";
		}
		
		public function registerCursor(name:String, cursorClass:Class):void
		{
			lib[name]=cursorClass;
		}

		
		public static function hideSystemCursor():void
		{
			Mouse.hide();
		}

		public static function showSystemCursor():void
		{
			Mouse.show();
		}

		private function makeCursorImages(name:String):Vector.<BitmapData>
		{
			var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
			var cursorFrame:BitmapData = null;
			var clazz:Class;
			for(var i:int = 1; i<= 5; ++i)
			{
				clazz = Reflection.getClass("sysCursor_" + i, ResourcePool.get(PreUrl.MOVIE_UI));
				if (clazz)
				{
					cursorFrame=new clazz(0, 0);
				}
				cursorData.push( cursorFrame );
			}
			
			return cursorData;
		}
		
		/**
		 * 设置系统级的光标
		 * @param name
		 * @param param
		 * @return
		 *
		 */
		public function setSysCursor(name:String, param:Object=null):Boolean
		{
			var result:Boolean = false;
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			mouseCursorData.data = makeCursorImages(name);
			if(mouseCursorData.data.length > 0 && mouseCursorData.data[0] != null)
			{
				mouseCursorData.frameRate = 5;
				Mouse.registerCursor( name, mouseCursorData );
				Mouse.cursor = name;
				result = true;
			}
			Mouse.show();
			return result;
		}
	}
}
