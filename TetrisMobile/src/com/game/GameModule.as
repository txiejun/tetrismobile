/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// GameModule.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 26, 2014, 10:59:26 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game
{
	import aurora.event.events.ResizeEvent;
	import aurora.input.keyboard.KeyManager;
	import aurora.layer.LayerManager;
	import aurora.logging.LogManager;
	import aurora.mobile.manager.PopUpManager;
	import aurora.module.ModuleBase;
	
	import com.game.view.ContinuePanel;
	import com.game.view.GameOverPanel;
	import com.game.view.GameWindow;
	import com.game.view.MainWindow;
	import com.game.view.MenuPanel;
	import com.game.view.RankPanel;
	import com.game.view.SelectPanel;
	import com.game.view.SettingPanel;
	import com.sound.MusicManager;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	/**
	 * 
	 * @author txiejun
	 * @created Dec 26, 2014, 10:59:26 PM
	 */
	public class GameModule extends ModuleBase
	{
		private static var _instance:GameModule;
		
		private var mainWindow:MainWindow;
		private var settingPanel:SettingPanel;
		private var rankPanel:RankPanel;
		private var selectPanel:SelectPanel;
		private var gameWindow:GameWindow;
		private var menuPanel:MenuPanel;
		private var continuePanel:ContinuePanel;
		private var gameOverPanel:GameOverPanel;
		
		public function GameModule()
		{
			super();
		}
		
		public static function getInstance():GameModule
		{
			if(_instance == null)
			{
				_instance = new GameModule();
			}
			return _instance;
		}
		
		override protected function initListeners():void
		{
			addMessageListener(ModuleCommand.SHOW_MIAN_WINDOW, onShowMainWindow);
			addMessageListener(ModuleCommand.SHOW_SETTING_PANEL, onShowSettingPanel);
			addMessageListener(ModuleCommand.SHOW_RANK_PANEL, onShowRankPanel);
			addMessageListener(ModuleCommand.SHARE_GAME, onShareGame);
			addMessageListener(ModuleCommand.SHOW_SELECT_PANEL, onShowSelectPanel);
			addMessageListener(ModuleCommand.SHOW_GAME_WINDOW, onShowGameWindow);
			addMessageListener(ModuleCommand.SHOW_PAUSE_MENU, onShowPauseMenu);
			addMessageListener(ModuleCommand.SAVE_CUBE, onSaveCube);
			addMessageListener(ModuleCommand.PAUSE_RESUME, onPauseResume);
			addMessageListener(ModuleCommand.PAUSE_NEW_GAME, onPauseNewGame);
			addMessageListener(ModuleCommand.PAUSE_OPTIONS, onPauseOptions);
			addMessageListener(ModuleCommand.PAUSE_MAIN_MENU, onPauseMainMenu);
			addMessageListener(ModuleCommand.CONTINUE_GAME, onContinueGame);
			addMessageListener(ModuleCommand.SHOW_GAME_OVER_PANEL, onShowGameOverPanel);
			addMessageListener(ModuleCommand.SET_SHOW_NEXT, onSetShowNext);
			addMessageListener(ModuleCommand.SET_SHOW_DROP_POS, onSetShowDropPos);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		private function keyHandler(e:KeyboardEvent):void
		{
			LogManager.info("e.keyCode:{0}", e.keyCode);
			if(e.keyCode==Keyboard.BACK)
			{
				//返回键
				e.preventDefault();
				LogManager.info("e.BACK");
				NativeApplication.nativeApplication.exit();
			}
			else if(e.keyCode== Keyboard.MENU)
			{
				//菜单键
				
			}
			else if(e.keyCode == Keyboard.SEARCH)
			{
				
			}
			else if(e.keyCode == Keyboard.HOME)
			{
				//home键
				
			}
		}
		
		
		private function onActivate(event:Event):void
		{
			//激活
			MusicManager.openGameSound = true;
			MusicManager.openBackSound = true;
			MusicManager.playMusic();
			LogManager.info("onActivate");
		}
		
		private function onDeactivate(event:Event):void
		{
			//后台运行
			LogManager.info("onDeactivate");
			MusicManager.openGameSound = false;
			MusicManager.openBackSound = false;
			MusicManager.stopMusic();
			MusicManager.stopSound();
			if(gameWindow && gameWindow.isGaming())
			{
				gameWindow.pauseGame();
				onShowPauseMenu();
			}
		}
		
		private function onShowMainWindow():void
		{
			if(mainWindow == null)
			{
				mainWindow = new MainWindow();
			}
			
			LayerManager.uiLayer.addChildAt(mainWindow, 0);
		}
		
		private function onShowSettingPanel():void
		{
			if(settingPanel == null)
			{
				settingPanel = new SettingPanel();
			}
			settingPanel.open(true);
		}
		
		private function onShowRankPanel(isGameOver:Boolean = false):void
		{
			if(rankPanel == null)
			{
				rankPanel = new RankPanel();
			}
			rankPanel.isGameOver = isGameOver;
			rankPanel.setInfo();
			rankPanel.open(true);
		}
		
		private function onShareGame():void
		{
			trace("分享游戏。。。");	
		}
		
		/**
		 * 打开选择关卡界面 
		 * @param mode 1-点击模式，2-手势模式
		 * 
		 */		
		private function onShowSelectPanel(mode:int):void
		{
			if(selectPanel == null)
			{
				selectPanel = new SelectPanel();
			}
			selectPanel.setMode(mode);
			selectPanel.setSelectByLevel(1);
			selectPanel.open(true);
		}
		
		private function onShowGameWindow(mode:int, level:int, isResume:Boolean = false, resumeType:int = 1):void
		{
			if(gameWindow == null)
			{
				gameWindow = new GameWindow();
			}
			GameManager.gameMode = mode;
			GameManager.gameLevel = level;
			gameWindow.setInfo(mode, level);
			gameWindow.open(true);
			
			if(isResume && resumeType == 1)
			{
				gameWindow.resumeGame();
			}
			else
			{
				gameWindow.startGame();
			}
			
		}
		
		private function onShowPauseMenu():void
		{
			if(menuPanel == null)
			{
				menuPanel = new MenuPanel();
			}
			PopUpManager.getInstance().addPopUp(menuPanel, true, null, {bgAlpha:0.6});
			PopUpManager.getInstance().centerPopUp(menuPanel);
			menuPanel.y += 100; 
		}
		
		private function onSaveCube():void
		{
			
		}
		
		/**
		 *  
		 * @param type 1-当前游戏恢复，2-离开游戏后继续之前类型游戏
		 * 
		 */		
		private function onPauseResume(type:int = 1):void
		{
			onShowGameWindow(GameManager.gameMode, GameManager.gameLevel, true, type);
		}
		
		private function onContinueGame():void
		{
			if(continuePanel == null)
			{
				continuePanel = new ContinuePanel();
			}
			PopUpManager.getInstance().addPopUp(continuePanel, true, null, {bgAlpha:0.6});
			PopUpManager.getInstance().centerPopUp(continuePanel);
		}
		
		private function onPauseNewGame():void
		{
			if(gameWindow)
			{
				gameWindow.endGame();
			}
			onShowSelectPanel(GameManager.gameMode);
		}
		
		private function onPauseOptions():void
		{
			onShowSettingPanel();
		}
		
		private function onPauseMainMenu():void
		{
			if(gameWindow)
			{
				gameWindow.endGame();
			}
			PopUpManager.getInstance().removeAllPopUps();
		}
		
		private function onShowGameOverPanel(score:Number, bestScore:Number, level:int):void
		{
			if(gameOverPanel == null)
			{
				gameOverPanel = new GameOverPanel();
			}
			gameOverPanel.setLevel(level);
			gameOverPanel.setScore(score);
			gameOverPanel.setBestScore(bestScore);
			gameOverPanel.isTop10 = GameManager.isTop10(score);
			PopUpManager.getInstance().addPopUp(gameOverPanel, true, null, {bgAlpha:0.6});
			PopUpManager.getInstance().centerPopUp(gameOverPanel);
			gameOverPanel.y += 50;
		}
		
		private function onSetShowNext(isSelect:Boolean):void
		{
			GameManager.nextVisible = isSelect;
			if(gameWindow)
			{
				gameWindow.setNextVisible(isSelect);
			}
		}
		
		private function onSetShowDropPos(isSelect:Boolean):void
		{
			GameManager.gridVisible = isSelect;
			if(gameWindow)
			{
				gameWindow.setGridVisible(isSelect);
			}
		}
		
	}
}
