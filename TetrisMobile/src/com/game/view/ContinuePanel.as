/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// ContinuePanel.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 27, 2014, 4:21:58 PM
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
	 * 是否继续界面
	 * @author txiejun
	 * @created Dec 27, 2014, 4:21:58 PM
	 */
	public class ContinuePanel extends Panel
	{
		private var menuLayer:Sprite;
		private var skins:Array = ["continue", "new_game"];
		
		public function ContinuePanel()
		{
			super();
			
			initView();
		}
		
		private function initView():void
		{
			this.setSize(576, 390);
			this.bgSkin = Style.getSkin("continue_window");
			
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
					case "continue":
						this.close();
						EventManager.dispatchEvent(ModuleCommand.PAUSE_RESUME, [2]);
						break;
					case "new_game":
						this.close();
						EventManager.dispatchEvent(ModuleCommand.PAUSE_NEW_GAME);
						break;
					default:
						break;
				}
			}
		}
	}
}
