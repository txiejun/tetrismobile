/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// RankPanel.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 26, 2014, 11:58:57 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.event.EventManager;
	import aurora.layout.LayoutUtil;
	import aurora.mobile.controls.Button;
	import aurora.mobile.controls.Panel;
	import aurora.mobile.manager.PopUpManager;
	
	import com.game.GameManager;
	import com.game.ModuleCommand;
	import com.game.vo.RankVO;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 排行榜
	 * @author txiejun
	 * @created Dec 26, 2014, 11:58:57 PM
	 */
	public class RankPanel extends Panel
	{
		private var btnBack:Button;
		public var isGameOver:Boolean = false;
		private var listLayer:Sprite;
		private var renders:Vector.<RankRenderer>;
		
		public function RankPanel()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			this.setSize(720, 1200);
			this.bgSkin = Style.getSkin("inner_bg");
			
			var title:Bitmap = Style.getBitmap("statistic_title");
			title.x = 0;
			title.y = 100;
			this.addChild(title);
			
			var options_content:Bitmap = Style.getBitmap("statistic_content");
			options_content.x = 70;
			options_content.y = 280;
			this.addChild(options_content);
			
			listLayer = new Sprite();
			listLayer.x = 188;
			listLayer.y = 283;
			this.addChild(listLayer);
			
			btnBack = new Button();
			btnBack.setStyle(Style.getBitmapData("back_button"));
			btnBack.addEventListener(MouseEvent.CLICK, onClickBack);
			
			this.addChild(btnBack);
			btnBack.validateNow();
			btnBack.x = (this.width - btnBack.width) * 0.5;
			btnBack.y = 1040;
			
			renders = new Vector.<RankRenderer>();
			
		}
		
		private function onClickBack(event:MouseEvent):void
		{
			this.close();
			
			if(isGameOver)
			{
				EventManager.dispatchEvent(ModuleCommand.PAUSE_NEW_GAME);
			}
		}
		
		private function clear():void
		{
			if(renders)
			{
				for each(var r:RankRenderer in renders)
				{
					r.dispose();
				}
			}
		}
		
		public function setInfo():void
		{
			var list:Array = GameManager.getTop10();
			if(list && list.length > 0)
			{
				var vo:RankVO;
				var render:RankRenderer;
				if(renders == null)
				{
					renders = new Vector.<RankRenderer>();
				}
				var len:int = renders.length;
				var i:int;
				for(i = 0; i<list.length;++i)
				{
					vo = list[i];
					if(i<len)
					{
						render = renders[i];
					}
					else
					{
						render = new RankRenderer();
						renders.push(render);
					}
					
					render.setVO(vo);
					listLayer.addChild(render);
				}
				for(i; i<len; ++i)
				{
					render = renders[i];
					render.dispose();
				}
				
				LayoutUtil.layoutVectical(listLayer,1);
			}
			else
			{
				clear();
			}
		}
	}
}
