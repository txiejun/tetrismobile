/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// TetrisMobile.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jan 3, 2015, 12:25:52 AM
/////////////////////////////////////////////////////////////////////////////////////////
package
{
	import aurora.core.GlobalSetting;
	import aurora.core.Parameters;
	import aurora.logging.LogManager;
	import aurora.utils.ArrayUtil;
	
	import com.preloader.PreLang;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * 
	 * @author txiejun
	 * @created Jan 3, 2015, 12:25:52 AM
	 */
	[SWF(width="720",height="1200",backgroundColor="#000000", frameRate="60")]
	public class TetrisMobile extends Sprite
	{
		private var app:Application;
		
		public function TetrisMobile()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			Parameters.getInstance().init(loaderInfo.parameters);
			
			this.stage.showDefaultContextMenu = false;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.stageFocusRect = false;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			app = new Application();
			this.addChild(app);
			
			GlobalSetting.gameWidth = 720;
			GlobalSetting.gameHeight = 1200;
			
			this.stage.addEventListener(Event.RESIZE, autoSize);
			autoSize();
			
//			var stats:Stats = new Stats();
//			this.addChild(stats);
			
			
			var list:Array = [];
			for (var i:int = 1; i<= 54; i++)
			{
				list.push(i);
			}
			trace("list1:", list.join(","))
			ArrayUtil.randomArray(list);
			trace("list2:", list.join(","))
		}
		
		private function autoSize(event:Event = null):void
		{
			var guiSize:Rectangle = new Rectangle(0, 0, GlobalSetting.gameWidth, GlobalSetting.gameHeight);
			var deviceSize:Rectangle = new Rectangle(0, 0,
				Math.min(stage.stageWidth, stage.stageHeight),
				Math.max(stage.stageWidth, stage.stageHeight));
			var appScale:Number = 1;
			var appSize:Rectangle = guiSize.clone();
			var appLeftOffset:Number = 0;
			var appTopOffset:Number = 0;
			
			// if device is wider than GUI's aspect ratio, height determines scale
			var d:Number = deviceSize.width/deviceSize.height;
			var g:Number = guiSize.width/guiSize.height;
			LogManager.info("guiSize:{0}, deviceSize:{1}, d:{2}, g:{3}, stageSize:{4},{5}, fullScreenSize:{6},{7}", guiSize, deviceSize, d, g, stage.stageWidth, stage.stageHeight, stage.fullScreenWidth, stage.fullScreenHeight);
			if (d > g) 
			{
				appScale = deviceSize.height / guiSize.height;
				appSize.width = deviceSize.width / appScale;
				appLeftOffset = Math.round((appSize.width - guiSize.width) / 2);
				appTopOffset = 0;
			} 
				// if device is taller than GUI's aspect ratio, width determines scale
			else 
			{
				appScale = deviceSize.width / guiSize.width;
				appSize.height = deviceSize.height / appScale;
				appLeftOffset = 0;
				appTopOffset = Math.round((appSize.height - guiSize.height) / 2);
			}
			trace("appScale:", appScale, appLeftOffset, appTopOffset);
			GlobalSetting.appScale = appScale;
			if(app)
			{
				app.scaleX = appScale;
				app.scaleY = appScale;
				app.x = appLeftOffset * appScale;
				app.y = appTopOffset * appScale;
			}
		}
		
	}
}
