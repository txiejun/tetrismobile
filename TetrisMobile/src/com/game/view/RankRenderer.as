/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// RankRenderer.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jan 2, 2015, 1:34:08 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view
{
	import aurora.mobile.core.UISprite;
	import aurora.mobile.core.UITextField;
	
	import com.game.vo.RankVO;
	
	/**
	 * 
	 * @author txiejun
	 * @created Jan 2, 2015, 1:34:08 PM
	 */
	public class RankRenderer extends UISprite
	{
		private var txtName:UITextField;
		private var txtScore:UITextField;
		
		public function RankRenderer()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.setSize(457, 71);
			
			txtName = new UITextField();
			txtName.defaultTextFormat = Style.getFormat(24, 0xFFFFFF);
			txtName.width = 262;
			txtName.height = 34;
			txtName.multiline = false;
			txtName.wordWrap = false;
			txtName.selectable = false;
			txtName.y = (this.height - txtName.height) * 0.5;
			this.addChild(txtName);
			
			txtScore = new UITextField();
			txtScore.defaultTextFormat = Style.getFormat(24, 0xFFFFFF);
			txtScore.width = 197;
			txtScore.height = 34;
			txtScore.multiline = false;
			txtScore.wordWrap = false;
			txtScore.selectable = false;
			txtScore.x = txtName.x + txtName.width + 2;
			txtScore.y = (this.height - txtScore.height) * 0.5;
			this.addChild(txtScore);
		}
		
		public function setVO(vo:RankVO):void
		{
			if(vo)
			{
				txtScore.text = vo.score.toString();
				txtName.text = vo.name;
			}
			else
			{
				dispose();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			txtScore.text = "";
			txtName.text = "";
		}
	}
}
