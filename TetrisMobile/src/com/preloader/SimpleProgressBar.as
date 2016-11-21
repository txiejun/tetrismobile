package com.preloader
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 预加载进度条 
	 * @author kevin
	 * 
	 */	
	public class SimpleProgressBar extends Sprite
	{
		public static const CENTER:String="CENTER";
		public static const RIGHT:String="RIGHT";
		public static const TOP:String="TOP";
		public static const BOTTOM:String="BOTTOM";

		private var _barBg:Bitmap;
		/**
		 * bar 
		 */
		private var _bar:Bitmap;
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _maskSp:Shape;
		/**
		 * 是否是遮罩进度条 
		 */		
		private var _isMask:Boolean = false;
		private var _htmlText:String;
		private var _percent:Number=-1;
		private var percentChanged:Boolean=false;
		
		public var padding:Number=0;
		public var vpadding:Number=0;
		private var _textAlign:String=CENTER;
		private var _width:int;
		private var _height:int;
		
		public function SimpleProgressBar()
		{
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		private function createText():void
		{
			if(_textField == null)
			{
				_textField=new TextField();
			}
			_textField.height=24;
			if(_textFormat)
			{
				_textField.defaultTextFormat=_textFormat;
			}
			_textField.mouseEnabled=false;
//			_textField.filters = [new GlowFilter(0x000000, 1, 2, 2, 6)];
		}
		
		public function setTextFormat(value:TextFormat):void
		{
			_textFormat = value;
			if(_textField && _textFormat)
			{
				_textField.defaultTextFormat=_textFormat;
			}
		}
		
		public function set htmlText(param:String):void
		{
			_htmlText=param;
			createText();
			addChild(_textField);
			_textField.htmlText=_htmlText;
			updateDisplayList(width, height);
		}
		
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		/**
		 * 百分比 
		 * @param param
		 * 
		 */		
		public function set percent(param:Number):void
		{
			if (_percent != param)
			{
				_percent=param;
				_percent=Math.max(0, param);
				_percent=Math.min(1, param);
				if(isNaN(_percent))
				{
					_percent = 0;
				}
				percentChanged = true;
				
				updateDisplayList(width, height);
			}
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		/**
		 * 
		 * @param barSkin
		 * @param bgSkin
		 * 
		 */		
		public function setSkin(bar:Bitmap, bg:Bitmap = null, isMask:Boolean=true):void
		{
			_barBg = bg;
			_bar = bar;
			if(_barBg && bar)
			{
				_barBg.width = _width;
				_barBg.height = _height;
				this.addChild(_barBg);
				this.addChild(_bar);
				_bar.width = (_width - 2 * padding);
				_bar.height = (_height - 2 * vpadding);
				_isMask = isMask;
				if(_isMask)
				{
					_maskSp = new Shape();
					_maskSp.graphics.beginFill(0xff00);
					_maskSp.graphics.drawRect(0,0,_bar.width,_bar.height);
					_maskSp.graphics.endFill();
					addChild(_maskSp);
					_bar.mask = _maskSp;
				}
				
				if(_textField)
				{
					addChild(_textField);
				}
				
				updateDisplayList(width, height);
			}
		}

		public function get bar():Bitmap
		{
			return _bar;
		}

		public function get barBg():Bitmap
		{
			return _barBg;
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function set textAlign(value:String):void
		{
			if (_textAlign != value)
			{
				_textAlign=value;
				updateDisplayList(width, height);
			}
		}
		public function get textAlign():String
		{
			return _textAlign;
		}
		
		protected function updateDisplayList(w:Number, h:Number):void
		{
			if (_bar)
			{
				_bar.x=padding;
				_bar.y=vpadding;
				if(_isMask)
				{
					_maskSp.x = _bar.x;
					_maskSp.y= _bar.y;
				}
			}
			if(_textField)
			{
				if (_textAlign == CENTER)
				{
					_textField.width=w;
					_textField.y=(h - _textField.height) >> 1;
				}
				else if (_textAlign == RIGHT)
				{
					_textField.width=_textField.textWidth + 6;
					_textField.y=(h - _textField.height) >> 1;
					_textField.x=w + 2;
				}
				else if (_textAlign == TOP)
				{
					_textField.width=w;
					_textField.y=-h - 2;
				}
				else if (_textAlign == BOTTOM)
				{
					_textField.width=w;
					_textField.y=h + 2;
				}
			}
			
			if (percentChanged && _bar)
			{
				percentChanged=false;
				if(_isMask)
				{
					_maskSp.graphics.clear();
					_maskSp.graphics.beginFill(0xff00);
					_maskSp.graphics.drawRect(0,0,_bar.width*_percent,_bar.height);
					_maskSp.graphics.endFill();
					addChild(_maskSp);
					_bar.mask = _maskSp;
				}
				else
				{
					_bar.scaleX = _percent;
				}
			}
		}
	}
}