/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// Application.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jan 4, 2015, 10:34:19 PM
/////////////////////////////////////////////////////////////////////////////////////////
package
{
	import aurora.core.Engine;
	import aurora.core.FontStyle;
	import aurora.core.GlobalSetting;
	import aurora.core.Parameters;
	import aurora.event.EventManager;
	import aurora.layer.LayerManager;
	import aurora.logging.LogManager;
	import aurora.mobile.core.UISystem;
	import aurora.mobile.manager.PopUpManager;
	import aurora.resource.ResourceManager;
	import aurora.resource.loading.LoadConst;
	import aurora.resource.loading.ResEvent;
	import aurora.timer.TimerManager;
	import aurora.utils.Reflection;
	
	import com.game.GameManager;
	import com.game.GameModule;
	import com.game.ModuleCommand;
	import com.game.view.GameWindow;
	import com.game.view.MainWindow;
	import com.game.vo.RankVO;
	import com.manager.CursorManager;
	import com.preloader.GameLoading;
	import com.preloader.PreLang;
	import com.preloader.PreUrl;
	import com.sound.MusicManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.system.Security;
	
	/**
	 * 
	 * @author txiejun
	 * @created Jan 4, 2015, 10:34:19 PM
	 */
	public class Application extends Sprite
	{
		public function Application()
		{
			FontStyle.checkFont();
			registerClassAlias(Reflection.getFullClassName(RankVO), RankVO);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		
		private function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			GlobalSetting.initialize(this);
			Engine.initialize(this);
			LogManager.initialize();
			LogManager.setData(PreLang.GAME_NAME);
//			LogManager.getClientTarget().setOpen();
			PreUrl.wrapperURL();
			
			//显示加载进度条
			GameLoading.getInstance().show(this);
			GameLoading.getInstance().setGameName(PreLang.GAME_NAME);
			GameLoading.getInstance().setItemLabel(PreLang.MAIN_0);
			GameLoading.getInstance().setTotalPercent(0.01, 1);
			GameLoading.getInstance().loadBG(PreUrl.LOADBG, Parameters.getInstance().proxyName);
			
			startLoad();
		}
		
		/**
		 * 开始加载 
		 * 
		 */		
		private function startLoad():void
		{
			ResourceManager.getInstance().addEventListener(ResEvent.LIST_COMPLETE, onAllComplete);
			ResourceManager.getInstance().addEventListener(ResEvent.RES_COMPLETE, onItemComplete);
			ResourceManager.getInstance().addEventListener(ResEvent.RES_PROGRESS, onItemProgress);
			ResourceManager.getInstance().setMode(LoadConst.MODE_SINGLE_THREAD);
			
			var clientVer:String = Parameters.getInstance().clientVersion;
			
			ResourceManager.getInstance().add(PreUrl.MAIN_UI, {tip:PreLang.CONFIG_6, loadKey:"main_ui"});
			ResourceManager.getInstance().add(PreUrl.MOVIE_UI, {tip:PreLang.CONFIG_7, loadKey:"movie"});
			ResourceManager.getInstance().add(PreUrl.CONFIG_URL, {tip:PreLang.CONFIG_8, loadKey:"config"});
			ResourceManager.getInstance().add(PreUrl.DATABIN_TETRIS_LEVEL, {tip:PreLang.CONFIG_8, loadKey:"databin"});
			
			ResourceManager.getInstance().start();
			
		}
		
		private function onAllComplete(event:ResEvent):void
		{
			ResourceManager.getInstance().removeEventListener(ResEvent.LIST_COMPLETE, onAllComplete);
			ResourceManager.getInstance().removeEventListener(ResEvent.RES_COMPLETE, onItemComplete);
			ResourceManager.getInstance().removeEventListener(ResEvent.RES_PROGRESS, onItemProgress);
			
			GameLoading.getInstance().setItemLabel("资源加载完成,正在解析配置...");
			preParseConfig();
			
			CursorManager.setCursor2();
			GameLoading.getInstance().setItemLabel("解析配置完成");
			GameLoading.getInstance().setTotalPercent(0.95, 1);
			
			initGame();
		}
		
		private function onItemComplete(event:ResEvent):void
		{
			GameLoading.getInstance().setItemLabel(event.getModel("tip") + "加载完成");
			GameLoading.getInstance().setTotalPercent(event.resIndex, event.resTotal);
		}
		
		private function onItemProgress(event:ResEvent):void
		{
			GameLoading.getInstance().setItemPercent("载入" + event.getModel("tip") + "{percent}% " + event.speed + "kb/s", event.bytesLoaded, event.bytesTotal);
		}
		
		/**
		 * 预解析部分配置 
		 * 
		 */		
		private function preParseConfig():void
		{
			GameManager.init();
		}
		
		/**
		 * 初始化游戏 
		 * 
		 */		
		private function initGame():void
		{
			LayerManager.createMainLayer();
			CursorManager.init(GlobalSetting.stage);
			TimerManager.addToFrame(UISystem.update);
			PopUpManager.getInstance().registerContainer(LayerManager.popUpLayer);
			GameModule.getInstance();
			EventManager.dispatchEvent(ModuleCommand.SHOW_MIAN_WINDOW);
			GameLoading.getInstance().dispose();
			MusicManager.init();
			MusicManager.playMusic();
		}
	}
}
