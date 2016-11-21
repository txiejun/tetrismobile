/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// Block0.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 30, 2014, 4:20:22 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view.game.blocks
{
	import com.game.view.game.Block;
	
	/**
	 * Z形
	 * --
	 *  --
	 * @author txiejun
	 * @created Dec 30, 2014, 4:20:22 PM
	 */
	public class Block2 extends Block
	{
		public function Block2()
		{
			this._blockType = 2;
			this.name = "Z形";
			shapeList = [[[1, 2], [2, 2], [0, 3], [1, 3]],
						[[0, 1], [0, 2], [1, 2], [1, 3]]];
			super();
			
		}
	}
}
