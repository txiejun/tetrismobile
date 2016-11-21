/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// SettingPanel.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 26, 2014, 11:01:55 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.event.EventManager;
	import aurora.layout.LayoutUtil;
	import aurora.mobile.controls.Button;
	import aurora.mobile.controls.CheckBox;
	import aurora.mobile.controls.Panel;
	import aurora.mobile.manager.PopUpManager;
	
	import com.game.ModuleCommand;
	import com.sound.MusicManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 设置界面
	 * @author txiejun
	 * @created Dec 26, 2014, 11:01:55 PM
	 */
	public class SettingPanel extends Panel
	{
		private var checkLayer:Sprite;
		private var btnBack:Button;
		private var info:Array = ["music", "sound", "show_next", "show_drop_pos"];
		
		public function SettingPanel()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			this.setSize(720, 1200);
			this.bgSkin = Style.getSkin("inner_bg");
			
			var title:Bitmap = Style.getBitmap("options_title");
			title.x = 0;
			title.y = 100;
			this.addChild(title);
			
			var options_content:Bitmap = Style.getBitmap("options_content");
			options_content.x = 70;
			options_content.y = 300;
			this.addChild(options_content);
			
			checkLayer = new Sprite();
			this.addChild(checkLayer);
			checkLayer.x = 500;
			checkLayer.y = 300;
			
			var checkBox:CheckBox;
			for (var i:int = 0; i< 4; ++i)
			{
				checkBox = new CheckBox();
				checkBox.setStyle(Style.getBitmapData("check_box"));
				checkBox.data = info[i];
				checkBox.selected = true;
				checkBox.addEventListener(Event.CHANGE, onClickCheck);
				checkLayer.addChild(checkBox);
			}
			
			LayoutUtil.layoutVectical(checkLayer, 80, 45);
			
			btnBack = new Button();
			btnBack.setStyle(Style.getBitmapData("back_button"));
			btnBack.addEventListener(MouseEvent.CLICK, onClickBack);
			
			this.addChild(btnBack);
			btnBack.validateNow();
			btnBack.x = (this.width - btnBack.width) * 0.5;
			btnBack.y = 1040;
		}
		
		private function onClickBack(event:MouseEvent):void
		{
			this.close();
		}
		
		private function onClickCheck(event:Event):void
		{
			var checkBox:CheckBox = event.currentTarget as CheckBox;
			if(checkBox)
			{
				switch(checkBox.data as String)
				{
					case "music":
						MusicManager.openBackSound = checkBox.selected;
						if(MusicManager.openBackSound == false)
						{
							MusicManager.stopMusic();
						}
						else
						{
							MusicManager.playMusic();
						}
						break;
					case "sound":
						MusicManager.openGameSound = checkBox.selected;
						if(MusicManager.openGameSound == false)
						{
							MusicManager.stopSound();
						}
						break;
					case "show_next":
						EventManager.dispatchEvent(ModuleCommand.SET_SHOW_NEXT, [checkBox.selected]);
						break;
					case "show_drop_pos":
						EventManager.dispatchEvent(ModuleCommand.SET_SHOW_DROP_POS, [checkBox.selected]);
						break;
					default:
						break;
				}
			}
		}
		
	}
}
