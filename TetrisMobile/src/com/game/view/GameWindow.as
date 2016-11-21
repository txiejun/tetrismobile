/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// MainGame.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 25, 2014, 6:18:35 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.event.EventManager;
	import aurora.graphics.BitmapText;
	import aurora.input.keyboard.KeyManager;
	import aurora.input.keyboard.Keys;
	import aurora.mobile.controls.Button;
	import aurora.mobile.controls.CheckBox;
	import aurora.mobile.controls.Panel;
	import aurora.mobile.core.FrameClip;
	import aurora.utils.GraphicsUtil;
	
	import com.game.GameManager;
	import com.game.ModuleCommand;
	import com.game.view.game.IGameView;
	import com.game.view.game.MainGame;
	import com.preloader.PreUrl;
	import com.sound.MusicManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 游戏区域
	 * @author txiejun
	 * @created Dec 25, 2014, 6:18:35 PM
	 */
	public class GameWindow extends Panel implements IGameView
	{
		private var btnPause:Button;
		private var btnSave:Sprite;
		private var txtLevel:BitmapText;
		private var txtTarget:BitmapText;
		private var txtScore:BitmapText;
		/**
		 * 游戏住程序 
		 */		
		private var mainGame:MainGame;
		private var _nextBlockLayer:Sprite;
		
		public function GameWindow()
		{
			super();
			initView();
		}
		
		/**
		 * 下一个方块列表 
		 */
		public function get nextBlockLayer():Sprite
		{
			return _nextBlockLayer;
		}

		private function initView():void
		{
			this.setSize(720, 1200);
			this.bgSkin = Style.getSkin("game");
			
			btnPause = new Button();
			btnPause.setStyle(Style.getBitmapData("pause_button"));
			btnPause.addEventListener(MouseEvent.CLICK, onClickPause);
			this.addChild(btnPause);
			btnPause.x = 596;
			btnPause.y = 107;
//			KeyManager.getInstance().addKeyListener(onClickPause, [Keys.CTRL]);
			
			txtScore = new BitmapText();
			txtScore.hspace = 1;
			txtScore.registerTemplate("0123456789");
			txtScore.source = Style.getBitmapData("num_yellow");
			this.addChild(txtScore);
			txtScore.x = 200;
			txtScore.y = 120;
			
			txtLevel = new BitmapText();
			txtLevel.hspace = 1;
			txtLevel.registerTemplate("0123456789");
			txtLevel.source = Style.getBitmapData("num_yellow");
			this.addChild(txtLevel);
			txtLevel.x = 50;
			txtLevel.y = 320;
			
			txtTarget = new BitmapText();
			txtTarget.hspace = 1;
			txtTarget.registerTemplate("0123456789");
			txtTarget.source = Style.getBitmapData("num_yellow");
			this.addChild(txtTarget);
			txtTarget.x = 50;
			txtTarget.y = 500;
			
			btnSave = new Sprite();
			GraphicsUtil.drawRect(btnSave.graphics, 0, 0, 120, 190, 0);
			btnSave.mouseChildren = false;
			btnSave.useHandCursor = true;
			btnSave.buttonMode = true;
			this.addChild(btnSave);
			btnSave.x = 2;
			btnSave.y = 910;
			btnSave.addEventListener(MouseEvent.CLICK, onClickSave);
			
			_nextBlockLayer = new Sprite();
			this.addChild(_nextBlockLayer);
			_nextBlockLayer.x = 600;
			_nextBlockLayer.y = 265;
			
			mainGame = new MainGame();
			mainGame.gameView = this;
			this.addChild(mainGame);
			mainGame.x = 135;
			mainGame.y = 202;
			
		}
		
		public function onClickPause(event:MouseEvent = null):void
		{
			this.pauseGame();
			EventManager.dispatchEvent(ModuleCommand.SHOW_PAUSE_MENU);
		}
		
		private function onClickSave(event:MouseEvent):void
		{
			EventManager.dispatchEvent(ModuleCommand.SAVE_CUBE);
		}
		
		public function setInfo(mode:int, level:int):void
		{
			if(this.mainGame)
			{
				mainGame.setInfo(mode, level);
			}
			setNextVisible(GameManager.nextVisible);
			setGridVisible(GameManager.gridVisible);
		}
		
		public function setLevel(value:Number):void
		{
			if(txtLevel)
			{
				txtLevel.text = value.toString();
				txtLevel.x = (120 - txtLevel.width) * 0.5;
			}
		}
		
		public function setTarget(value:Number):void
		{
			if(txtTarget)
			{
				txtTarget.text = value.toString();
				txtTarget.x = (120 - txtTarget.width) * 0.5;
			}
		}
		
		public function setScore(value:Number):void
		{
			txtScore.text = value.toString();
			txtScore.x = (this.width - txtScore.width) * 0.5 - 20;
		}
		
		public function startGame():void
		{
			mainGame.startGame();
		}
		
		public function endGame():void
		{
			mainGame.endGame();
		}
		
		public function resumeGame():void
		{
			mainGame.resumeGame();
		}
		
		public function pauseGame():void
		{
			mainGame.pauseGame();
		}
		
		public function isGaming():Boolean
		{
			return mainGame.isGaming();
		}
		
		/**
		 * 是否显示/隐藏网格 
		 * @param value
		 * 
		 */		
		public function setGridVisible(value:Boolean):void
		{
			mainGame.setGridVisible(value);
		}
		
		/**
		 * 是否显示/隐藏下一个方块
		 * @param value
		 * 
		 */		
		public function setNextVisible(value:Boolean):void
		{
			if(_nextBlockLayer)
			{
				_nextBlockLayer.visible = value;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			txtLevel.text = "";
			txtTarget.text = "";
			txtScore.text = "";
			mainGame.dispose();
		}
	}
}
