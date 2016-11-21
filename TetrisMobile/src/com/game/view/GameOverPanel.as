/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// GameOverPanel.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 27, 2014, 10:44:20 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.event.EventManager;
	import aurora.graphics.BitmapText;
	import aurora.mobile.controls.Button;
	import aurora.mobile.controls.Panel;
	import aurora.mobile.controls.TextInput;
	
	import com.game.GameManager;
	import com.game.ModuleCommand;
	import com.game.vo.RankVO;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 游戏结束界面
	 * @author txiejun
	 * @created Dec 27, 2014, 10:44:20 PM
	 */
	public class GameOverPanel extends Panel
	{
		private var txtLevel:BitmapText;
		private var txtScore:BitmapText;
		private var txtBestScore:BitmapText;
		private var txtName:TextInput;
		private var btnOK:Button;
		private var btnShare:Button;
		private var _isTop10:Boolean = false;
		private var top10Layer:Sprite;
		private var gameOverLayer:Sprite;
		private var btnRetry:Button;
		private var btnMainMenu:Button;
		private var score:Number = 0;
		
		public function GameOverPanel()
		{
			super();
			
			initView();
		}
		
		public function get isTop10():Boolean
		{
			return _isTop10;
		}

		public function set isTop10(value:Boolean):void
		{
			_isTop10 = value;
			if(_isTop10)
			{
				this.bgSkin = Style.getSkin("top10_bg");
				top10Layer.visible = true;
				gameOverLayer.visible = false;
				txtLevel.y = 227;
				txtScore.y = 273;
				txtBestScore.y = 330; 
			}
			else
			{
				this.bgSkin = Style.getSkin("game_over_bg");
				top10Layer.visible = false;
				gameOverLayer.visible = true;
				txtLevel.y = 236;
				txtScore.y = 285;
				txtBestScore.y = 343; 
			}
		}

		private function initView():void
		{
			this.setSize(576, 753);
			this.bgSkin = Style.getSkin("game_over_bg");
			
			txtLevel = new BitmapText();
			txtLevel.hspace = 1;
			txtLevel.registerTemplate("0123456789");
			txtLevel.source = Style.getBitmapData("num_white_small");
			this.addChild(txtLevel);
			txtLevel.x = 450;
			txtLevel.y = 236;
			
			txtScore = new BitmapText();
			txtScore.hspace = 1;
			txtScore.registerTemplate("0123456789");
			txtScore.source = Style.getBitmapData("num_yellow");
			this.addChild(txtScore);
			txtScore.x = 450;
			txtScore.y = 285;
			
			txtBestScore = new BitmapText();
			txtBestScore.hspace = 1;
			txtBestScore.registerTemplate("0123456789");
			txtBestScore.source = Style.getBitmapData("num_white");
			this.addChild(txtBestScore);
			txtBestScore.x = 450;
			txtBestScore.y = 343; 
			
			top10Layer = new Sprite();
			this.addChild(top10Layer);
			top10Layer.visible = false;
			
			gameOverLayer = new Sprite();
			this.addChild(gameOverLayer);
			
			initTop10();
			
			initGameOver();
		}
		
		private function initTop10():void
		{
			txtName = new TextInput();
			txtName.setTextFormat(Style.getFormat(24));
			txtName.setSize(428, 75);
			txtName.bgSkin = Style.getSkin("name_input_box");
			txtName.x = (this.width - txtName.width) * 0.5;
			txtName.y = 410;
			txtName.text = "请输入您的名字";
			txtName.maxChars = 30;
			top10Layer.addChild(txtName);
			
			btnOK = new Button();
			btnOK.setStyle(Style.getBitmapData("ok"));
			btnOK.x = (this.width - btnOK.width) * 0.5;
			btnOK.y = 510;
			top10Layer.addChild(btnOK);
			btnOK.addEventListener(MouseEvent.CLICK, onClickOK);
			
			btnShare = new Button();
			btnShare.setStyle(Style.getBitmapData("share"));
			btnShare.x = (this.width - btnShare.width) * 0.5;
			btnShare.y = 600;
			top10Layer.addChild(btnShare);
			btnShare.addEventListener(MouseEvent.CLICK, onClickShare);
		}
		
		private function initGameOver():void
		{
			btnRetry = new Button();
			btnRetry.setStyle(Style.getBitmapData("game_over_retry"));
			gameOverLayer.addChild(btnRetry);
			btnRetry.x = (this.width - btnRetry.width) * 0.5;;
			btnRetry.y = 420;
			btnRetry.addEventListener(MouseEvent.CLICK, onClickRetry);
			
			btnMainMenu = new Button();
			btnMainMenu.setStyle(Style.getBitmapData("main_menu"));
			gameOverLayer.addChild(btnMainMenu);
			btnMainMenu.x = (this.width - btnMainMenu.width) * 0.5;
			btnMainMenu.y = 570;
			btnMainMenu.addEventListener(MouseEvent.CLICK, onClickMainMenu);
		}
		
		private function onClickRetry(event:MouseEvent):void
		{
			this.close();
			EventManager.dispatchEvent(ModuleCommand.PAUSE_NEW_GAME);
		}
		
		private function onClickMainMenu(event:MouseEvent):void
		{
			this.close();
			EventManager.dispatchEvent(ModuleCommand.PAUSE_MAIN_MENU);
		}
		
		private function onClickOK(event:MouseEvent):void
		{
			this.close();
			var vo:RankVO = new RankVO();
			vo.score = score;
			vo.name = txtName.text;
			vo.time = new Date().time;
			GameManager.updateTop10(vo);
			EventManager.dispatchEvent(ModuleCommand.SHOW_RANK_PANEL, [true]);
		}
		
		private function onClickShare(event:MouseEvent):void
		{
			EventManager.dispatchEvent(ModuleCommand.SHARE_GAME);
		}
		
		public function setLevel(value:int):void
		{
			txtLevel.text = value.toString();
			txtLevel.x = 450 + (55-txtLevel.width) * 0.5;
		}
		
		public function setScore(value:Number):void
		{
			score = value;
			txtScore.text = value.toString();
			txtScore.x = (500 - txtScore.width);
		}
		
		public function setBestScore(value:Number):void
		{
			txtBestScore.text = value.toString();
			txtBestScore.x = (500 - txtBestScore.width);
		}
	}
}
