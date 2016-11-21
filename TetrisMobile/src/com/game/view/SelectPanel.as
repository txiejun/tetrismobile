/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// SelectPanel.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 27, 2014, 10:21:42 AM
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
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 关卡选择
	 * @author txiejun
	 * @created Dec 27, 2014, 10:21:42 AM
	 */
	public class SelectPanel extends Panel
	{
		/**
		 * 1-点击模式， 2-手势模式
		 */		
		private var mode:int;
		private var btnPlay:Button;
		private var title:Bitmap;
		private var levelLayer:Sprite;
		private var levelNum:int = 15;
		private var curCheckBox:CheckBox;
		private var curLevel:int;
		
		public function SelectPanel()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			this.setSize(720, 1200);
			this.bgSkin = Style.getSkin("inner_bg");
			
			title = new Bitmap();
			title.x = 0;
			title.y = 100;
			this.addChild(title);
			
			levelLayer = new Sprite();
			levelLayer.x = 100;
			levelLayer.y = 320;
			this.addChild(levelLayer);
			levelLayer.addEventListener(MouseEvent.CLICK, onClickLevel);
			
			initLevel();
			
			btnPlay = new Button();
			btnPlay.setStyle(Style.getBitmapData("level_play"));
			btnPlay.addEventListener(MouseEvent.CLICK, onClickPlay);
			
			this.addChild(btnPlay);
			btnPlay.validateNow();
			btnPlay.x = (this.width - btnPlay.width) * 0.5;
			btnPlay.y = 1040;
		}
		
		private function initLevel():void
		{
			var checkBox:CheckBox;
			for(var i:int = 1; i<=levelNum; ++i)
			{
				checkBox = new CheckBox();
				checkBox.setStyle(Style.getBitmapData("level_" + i));
				checkBox.data = i;
				levelLayer.addChild(checkBox);
			}
			
			LayoutUtil.layoutGrid(levelLayer, 3,60, 70);
		}
		
		private function onClickLevel(event:MouseEvent):void
		{
			var check:CheckBox = event.target as CheckBox;
			selectBtn(check);
		}
		
		private function selectBtn(check:CheckBox):void
		{
			if(check && curCheckBox!=check)
			{
				if(curCheckBox)
				{
					curCheckBox.selected = false;
				}
				curCheckBox = check;
				curCheckBox.selected = true;
				curLevel = curCheckBox.data as int;
			}
		}
		
		public function setMode(value:int):void
		{
			if(this.mode != value)
			{
				this.mode = value;
				if(mode == 1)
				{
					this.title.bitmapData = Style.getBitmapData("select_touch");
				}
				else if(mode == 2)
				{
					this.title.bitmapData = Style.getBitmapData("select_gesture");
				}
			}
		}
		
		public function getMode():int
		{
			return this.mode;
		}
		
		private function getBtnByLevel(lv:int):CheckBox
		{
			var index:int = 0;
			var check:CheckBox;
			while(index < levelLayer.numChildren)
			{
				check = levelLayer.getChildAt(index) as CheckBox;
				if(check && int(check.data) == lv)
				{
					return check;	
				}
				++index;
			}
			return null;
		}
		
		/**
		 * 根据给定的等级选中按钮 
		 * @param value
		 * 
		 */		
		public function setSelectByLevel(value:int):void
		{
			if(value >=1 && value <= levelNum)
			{
				selectBtn(getBtnByLevel(value));
			}
		}
		
		private function onClickPlay(event:MouseEvent):void
		{
			this.close();
			
			EventManager.dispatchEvent(ModuleCommand.SHOW_GAME_WINDOW, [this.mode, this.curLevel]);
		}
		
	}
}
