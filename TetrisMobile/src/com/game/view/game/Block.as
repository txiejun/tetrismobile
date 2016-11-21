/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// Block.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 28, 2014, 12:42:15 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view.game
{
	import aurora.core.IDataRenderer;
	import aurora.core.IDisposable;
	import aurora.utils.MathUtil;
	
	import flash.display.Sprite;
	
	/**
	 * 一个具体的俄罗斯方块 (四个Cube组成的图形)
	 * @author txiejun
	 * @created Dec 28, 2014, 12:42:15 PM
	 */
	public class Block extends Sprite implements IBlock
	{
		protected var _data:Object;
		public var cubeList:Vector.<Cube>;
		/**
		 * 方块定义
		 */		
		protected var shapeList:Array;
		protected var _blockType:int = 0;
		/**
		 * 方块的索引，对于不同的俄罗斯方块形状 方向个数不同 
		 */		
		protected var _shapeIndex:int = 0;
		protected var _skinIndex:int = 0;
		protected var skinNum:int;
		
		public function Block()
		{
			super();
			init();
		}
		
		/**
		 * 俄罗斯方块的类型 分别为 0-方形，1-长形，2-Z形，3-反Z形，4-T形，5-到L形，6-L形 
		 */
		public function get blockType():int
		{
			return _blockType;
		}

		protected function init():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			cubeList = new Vector.<Cube>(4);
			skinNum = Cube.getSkinNum();
			_skinIndex = MathUtil.random(0, skinNum-1);
			render();
			trace("this.name:", this.name, _skinIndex);
		}
		
		public function getShape():Array
		{
			if(shapeList && _shapeIndex < shapeList.length)
			{
				return shapeList[_shapeIndex];
			}
			return null;
		}
		
		public function render():void
		{
			if(shapeList && _shapeIndex < shapeList.length)
			{
				var shape:Array = shapeList[_shapeIndex];
				var pos:Array = [];
				var cube:Cube;
				if(shape && shape.length >= 4)
				{
					for(var i:int = 0;i<4; ++i)
					{
						pos = shape[i];
						if(pos)
						{
							cube = cubeList[i];
							if(cube == null)
							{
								cube = new Cube();
								cubeList[i] = cube;
							}
							cube.setSkin(_skinIndex);
							if(cube.parent != this)
							{
								this.addChild(cube);
							}
							cube.x = pos[0] * GameConst.CUBE_SIZE;
							cube.y = pos[1] * GameConst.CUBE_SIZE;
						}
					}
				}
			}
		}
		
		public function preShape():void
		{
			if(shapeList && shapeList.length > 0)
			{
				--_shapeIndex;
				if(_shapeIndex<0)
				{
					_shapeIndex = shapeList.length -1;
				}
			}
		}
		
		public function nextShape():void
		{
			if(shapeList && shapeList.length > 0)
			{
				++_shapeIndex;
				if(_shapeIndex >= shapeList.length)
				{
					_shapeIndex = 0;
				}
			}
		}
		
		public function randomShape():void
		{
			if(shapeList && shapeList.length > 0)
			{
				_shapeIndex = MathUtil.random(0, shapeList.length - 1);
			}
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
			data = null;
			if(cubeList)
			{
				for each(var c:Cube in cubeList)
				{
					if(c)
					{
						c.dispose();
						if(c.parent)
						{
							c.parent.removeChild(c);
						}
					}
				}
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}
