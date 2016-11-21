/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// MenuPanel.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 27, 2014, 3:32:36 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.event.EventManager;
	import aurora.layout.LayoutUtil;
	import aurora.mobile.controls.Button;
	import aurora.mobile.controls.Panel;
	
	import com.game.ModuleCommand;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 菜单选项
	 * @author txiejun
	 * @created Dec 27, 2014, 3:32:36 PM
	 */
	public class MenuPanel extends Panel
	{
		private var menuLayer:Sprite;
		private var skins:Array = ["pause_resume", "pause_restart", "pause_options", "main_menu"];
		
		public function MenuPanel()
		{
			super();
			
			initView();
		}
		
		private function initView():void
		{
			this.setSize(576, 650);
			this.bgSkin = Style.getSkin("pause_window");
			
			menuLayer = new Sprite();
			this.addChild(menuLayer);
			menuLayer.x = 70;
			menuLayer.y = 70;
			
			var btn:Button;
			var len:int = skins.length;
			for (var i:int = 0; i< len; ++i)
			{
				btn = new Button();
				btn.setStyle(Style.getBitmapData(skins[i]));
				btn.data = skins[i];
				menuLayer.addChild(btn);
			}
			menuLayer.addEventListener(MouseEvent.CLICK, onClickMenu);
			LayoutUtil.layoutVectical(menuLayer, 60, 0);
			
		}
		
		private function onClickMenu(event:MouseEvent):void
		{
			var btn:Button = event.target as Button;
			if(btn)
			{
				switch(btn.data)
				{
					case "pause_resume":
						this.close();
						EventManager.dispatchEvent(ModuleCommand.PAUSE_RESUME);
						break;
					case "pause_restart":
						this.close();
						EventManager.dispatchEvent(ModuleCommand.PAUSE_NEW_GAME);
						break;
					case "pause_options":
						EventManager.dispatchEvent(ModuleCommand.PAUSE_OPTIONS);
						break;
					case "main_menu":
						this.close();
						EventManager.dispatchEvent(ModuleCommand.PAUSE_MAIN_MENU);
						break;
					default:
						break;
				}
			}
		}
	}
}
