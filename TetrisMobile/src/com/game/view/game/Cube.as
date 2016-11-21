/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// Cube.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 27, 2014, 9:49:56 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view.game
{
	import aurora.core.IDataRenderer;
	import aurora.core.IDisposable;
	import aurora.mobile.core.FrameDesc;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 方块
	 * @author txiejun
	 * @created Dec 27, 2014, 9:49:56 PM
	 */
	public class Cube extends Bitmap implements IDisposable, IDataRenderer
	{
		protected static var _desc:FrameDesc;
		private var _data:Object;
		protected var _height:Number=0;
		protected var _width:Number=0;
		
		public function Cube()
		{
			super();
			this.width = GameConst.CUBE_SIZE;
			this.height = GameConst.CUBE_SIZE;
		}
		
		/**
		 * 设置方块样式 
		 * @param source
		 * @param frames
		 * 
		 */		
		public static function setStyle(source:BitmapData, frames:int):void
		{
			if(source && frames > 0)
			{
				//解析资源
				if(_desc == null)
				{
					_desc = new FrameDesc();
				}
				else
				{
					_desc.dispose();
				}
				_desc.numBitmapData = source;
				_desc.numberWidth=_desc.numBitmapData.width / frames;
				_desc.numberHeight=_desc.numBitmapData.height;
				var numberBitmapData:BitmapData;
				_desc.numArray = new Vector.<BitmapData>(frames);
				for (var i:int=0; i < frames; i++)
				{
					var rect:Rectangle = new Rectangle(i * _desc.numberWidth, 0, _desc.numberWidth, _desc.numberHeight);
					numberBitmapData=new BitmapData(_desc.numberWidth, _desc.numberHeight, true, 0x00ffffff);
					numberBitmapData.copyPixels(_desc.numBitmapData, rect, new Point(0, 0));
					_desc.numArray[i]=numberBitmapData;
				}
			}
		}
		
		public static function getSkinNum():int
		{
			if(_desc && _desc.numArray)
			{
				return _desc.numArray.length;	
			}
			return 0;
		}
		
		/**
		 * 设置方块皮肤 
		 * @param index
		 * 
		 */		
		public function setSkin(index:int):void
		{
			if(_desc)
			{
				var curFrame:BitmapData = _desc.getFrame(index);
				if(curFrame)
				{
					this.bitmapData = curFrame;
					this.scaleX = this.width/curFrame.width;
					this.scaleY = this.scaleX;
				}
				else
				{
					trace("Cube.setSkin is Null index:", index);
				}
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width=value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height=value;
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function dispose():void
		{
			this.bitmapData = null;
			this.data = null;
		}
	}
}
