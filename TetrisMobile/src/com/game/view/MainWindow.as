/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// MainWindow.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 26, 2014, 10:26:29 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.event.EventManager;
	import aurora.mobile.controls.Button;
	import aurora.mobile.core.UISprite;
	
	import com.game.GameManager;
	import com.game.ModuleCommand;
	import com.preloader.PreUrl;
	
	import flash.events.MouseEvent;
	
	/**
	 * 主界面
	 * @author txiejun
	 * @created Dec 26, 2014, 10:26:29 PM
	 */
	public class MainWindow extends UISprite
	{
		private var btnTouch:Button;
		private var btnGesture:Button;
		private var btnOptions:Button;
		private var btnStatistics:Button;
		private var btnShare:Button;
		
		public function MainWindow()
		{
			super();
			
			initView();
		}
		
		private function initView():void
		{
			this.setSize(720, 1200);
			this.bgSkin = Style.getSkin("main_bg");
			
			btnTouch = new Button();
			btnTouch.setStyle(Style.getBitmapData("play_touch"));
			btnTouch.addEventListener(MouseEvent.CLICK, onClickTouch);
			
			btnGesture = new Button();
			btnGesture.setStyle(Style.getBitmapData("play_gesture"));
			btnGesture.addEventListener(MouseEvent.CLICK, onClickGesture);

			this.addChild(btnTouch);
			this.addChild(btnGesture);
			btnTouch.validateNow();
			btnGesture.validateNow();
			
			btnTouch.x = 100;
			btnTouch.y = (this.height - btnTouch.height) * 0.5;
			btnGesture.x = btnTouch.x + btnTouch.width + 10;
			btnGesture.y = (this.height - btnGesture.height) * 0.5;
			
			btnOptions = new Button();
			btnOptions.setStyle(Style.getBitmapData("options"));
			btnOptions.addEventListener(MouseEvent.CLICK, onClickOptions);
			
			btnStatistics = new Button();
			btnStatistics.setStyle(Style.getBitmapData("statistics"));
			btnStatistics.addEventListener(MouseEvent.CLICK, onClickStatistics);
			
			btnShare = new Button();
			btnShare.setStyle(Style.getBitmapData("share"));
			btnShare.addEventListener(MouseEvent.CLICK, onClickShare);
			
			this.addChild(btnOptions);
			this.addChild(btnStatistics);
			this.addChild(btnShare);
			
			btnOptions.x = 118;
			btnOptions.y = 980;
			
			btnStatistics.x = 311;
			btnStatistics.y = 980;
			
			btnShare.x = 496;
			btnShare.y = 980;
			
		}
		
		private function onClickTouch(event:MouseEvent):void
		{
			if(GameManager.gameMode == 1)
			{
				EventManager.dispatchEvent(ModuleCommand.CONTINUE_GAME);
			}
			else
			{
				EventManager.dispatchEvent(ModuleCommand.SHOW_SELECT_PANEL, [1]);
			}
		}
		
		private function onClickGesture(event:MouseEvent):void
		{
			if(GameManager.gameMode == 2)
			{
				EventManager.dispatchEvent(ModuleCommand.CONTINUE_GAME);
			}
			else
			{
				EventManager.dispatchEvent(ModuleCommand.SHOW_SELECT_PANEL, [2]);
			}
		}
		
		private function onClickOptions(event:MouseEvent):void
		{
			EventManager.dispatchEvent(ModuleCommand.SHOW_SETTING_PANEL);
		}
		
		private function onClickStatistics(event:MouseEvent):void
		{
			EventManager.dispatchEvent(ModuleCommand.SHOW_RANK_PANEL);
		}
		
		private function onClickShare(event:MouseEvent):void
		{
			EventManager.dispatchEvent(ModuleCommand.SHARE_GAME);	
		}
	}
}
