/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2012. All rights reserved. 
// 
// ScaleBitmap.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Created Dec 26, 2012 5:08:42 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.preloader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 支持九宫格的位图
	 * @author txiejun
	 * 
	 * @created Dec 26, 2012 5:08:42 PM
	 */
	public class SimpleScaleBitmap extends Bitmap
	{
		protected var _originalBmpData:BitmapData;
		protected var _scale9Grid:Rectangle;
		protected var _width:Number;
		protected var _height:Number;
		
		public function SimpleScaleBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			
			_originalBmpData = bitmapData;
		}
		
		private function setBitmapData():void
		{
			if(_originalBmpData)
			{
				if(_scale9Grid)
				{
					if(!(_scale9Grid.x >= 0 && 
						_scale9Grid.right <= _originalBmpData.width && 
						_scale9Grid.y >= 0 && 
						_scale9Grid.bottom <= _originalBmpData.height))
					{
						throw new Error("The scale9Grid:" + _scale9Grid + " does not match the original BitmapData.");
					}
				}
				
				if(_width <= 0 || isNaN(_width))
				{
					_width = _originalBmpData.width;
				}
				if(_height <= 0 || isNaN(_height))
				{
					_height = _originalBmpData.height;
				}
				
				super.bitmapData = scale9Fill(_originalBmpData, _scale9Grid, _width, _height);
				super.width = _width;
				super.height = _height;
			}
		}
		
		/**
		 * 九宫格填充 位图 
		 * @param originalBmpData
		 * @param innerRect
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		public static function scale9Fill(originalBmpData:BitmapData, innerRect:Rectangle, width:Number, height:Number):BitmapData
		{
			var result:BitmapData = originalBmpData;
			if(originalBmpData && innerRect)
			{
				result = new BitmapData(width, height, true, 0x00000000);
				
				var originCols:Array = [0, innerRect.x, innerRect.right, originalBmpData.width];
				var originRows:Array = [0, innerRect.y, innerRect.bottom, originalBmpData.height];
				var right:Number = originCols[3] - originCols[2];
				var bottom:Number = originRows[3] - originRows[2];
				var drawCols:Array = [0, innerRect.x, width - right, width];
				var drawRows:Array = [0, innerRect.y, height - bottom, height];
				var drawRect:Rectangle = new Rectangle();
				var originRect:Rectangle = new Rectangle();
				var mat:Matrix = new Matrix();
				
				originalBmpData.lock();
				for (var i:int = 0; i < 3; ++i) 
				{
					for (var j:int = 0; j < 3; ++j) 
					{
						originRect.x = originCols[i];
						originRect.y = originRows[j];
						originRect.width = originCols[i+1] - originCols[i];
						originRect.height = originRows[j+1] - originRows[j];
						
						drawRect.x = drawCols[i];
						drawRect.y = drawRows[j];
						drawRect.width = drawCols[i+1] - drawCols[i];
						drawRect.height = drawRows[j+1] - drawRows[j];
						
						mat.identity();
						mat.scale(drawRect.width/originRect.width, drawRect.height/originRect.height);
						mat.translate(drawRect.x - originRect.x * mat.a, drawRect.y - originRect.y * mat.d);
						
						result.draw(originalBmpData, mat, null, null, drawRect, true);
					}
				}
				originalBmpData.unlock();
			}
			
			return result;
		}
		
		override public function set bitmapData(bmpData:BitmapData):void
		{
			_originalBmpData = bmpData;
			setBitmapData();
		}
		
		/**
		 * 九宫格的内部矩形框
		 * @param innerRectangle
		 * 
		 */		
		override public function set scale9Grid(innerRectangle:Rectangle):void
		{
			if(innerRectangle)
			{
				if(_scale9Grid == null || !_scale9Grid.equals(innerRectangle))
				{
					_scale9Grid = innerRectangle;
					setBitmapData();
				}
			}
			else
			{
				_scale9Grid = null;
				setBitmapData();
			}
		}
		
		override public function get scale9Grid():Rectangle
		{
			return _scale9Grid;
		}
		
		override public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = value;
				setBitmapData();
			}
		}

		override public function set height(value:Number):void
		{
			if(_height != value)
			{
				_height = value;
				setBitmapData();
			}
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if(_width != w || _height != h)
			{
				_width = w;
				_height = h;
				setBitmapData();
			}
		}
		
		public function getOriginalBitmapData():BitmapData
		{
			return _originalBmpData;
		}
		
		public function dispose():void
		{
			_originalBmpData = null;
			_scale9Grid = null;
			super.bitmapData = null;
		}
	}
}

