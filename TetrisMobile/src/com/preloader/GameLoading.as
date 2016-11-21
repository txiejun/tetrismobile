/////////////////////////////////////////////////////////////////////////////////////////
// YEGAME Confidential 
// Copyright 2013. All rights reserved. 
// 
// GameLoading.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jul 5, 2013 4:12:26 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.preloader
{
	import aurora.com.FilterCommon;
	import aurora.core.FontStyle;
	import aurora.core.Parameters;
	import aurora.ui.interfaces.ILoading;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * 全屏遮罩的 进度条显示
	 * @author txiejun
	 * @created Jul 5, 2013 4:12:26 PM
	 */
	public class GameLoading extends Sprite implements ILoading
	{
		private const BLACK_FILTER:GlowFilter = new GlowFilter(0x000000, 1, 3, 3, 6);
		private static var instance:GameLoading = null;
		//所有内容放在此容器中
		private var container:Sprite;
		//背景图片
		private var welcome:SimpleLoader;
		private var logo:SimpleLoader;
		/**
		 * 进度条
		 */		
		private var progressBar:SimpleProgressBar;
		private var totalText:TextField;
		/**
		 * 警告提示 
		 */		
		private var warnTxt:TextField;
		/**
		 * 刷新提示 
		 */		
		private var freshText:TextField;
		/**
		 * 随机提示 
		 */		
		private var tipTxt:TextField;
		
		private var _gameName:String="";
		private var welcomeLoaded:Boolean = false;
		
		private var _barWidth:Number=500;
		private var _barHeight:Number = 40;
		private var minWidth:int = 1000;
		private var minHeight:int = 600;
		private var index:int;
		private var time:int = 0;
		private var _itemPercent:Number = 0;
		private var _totalPercent:Number = 0;
		
		public function GameLoading()
		{
			container = new Sprite();
			this.addChild(container);
			addEventListener(Event.ADDED_TO_STAGE, initView);
			
		}
		
		public static function getInstance():GameLoading
		{
			if (instance == null)
			{
				instance=new GameLoading();
			}
			return instance;
		}
		
		private function initView(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initView);
			stage.addEventListener(Event.RESIZE, layout);
			
			welcome = new SimpleLoader();
			welcome.callBack = onComplete;
			container.addChild(welcome);
			
			logo = new SimpleLoader();
			logo.callBack = onComplete;
			container.addChild(logo);
			
			progressBar = new SimpleProgressBar();
			container.addChild(progressBar);
			progressBar.width = _barWidth;
			progressBar.height = _barHeight;
			progressBar.textAlign = SimpleProgressBar.RIGHT;
			 
			var bars:SimpleScaleBitmap = new SimpleScaleBitmap();
			bars.scale9Grid = new Rectangle(10, 5, 214, 4);
			bars.bitmapData = new load_bar();
			
			var barbgs:SimpleScaleBitmap = new SimpleScaleBitmap();
			barbgs.scale9Grid = new Rectangle(10, 5, 214, 4);
			barbgs.bitmapData = new load_bar_bg();
			
			progressBar.setSkin(bars, barbgs);
//			progressBar.setSkin(new Bitmap(new load_bar()), new Bitmap(new load_bar_bg()));
			var tf:TextFormat = new TextFormat(FontStyle.defaultFontName, FontStyle.defaultFontSize, 0x00FFFF, false, null, null, null, null, "center");
			progressBar.setTextFormat(tf);
			
			tf = new TextFormat(FontStyle.defaultFontName, FontStyle.defaultFontSize, 0x00FF00, false, null, null, null, null, "center");
			totalText=createTextField("", 0, 0, minWidth, 30, tf, container);
			totalText.filters = [FilterCommon.BLACK_FILTER];
			
			tf = new TextFormat(FontStyle.defaultFontName, FontStyle.defaultFontSize, 0xFFFF00, false, null, null, null, null, "center");
			tipTxt = createTextField("", 0, 0, minWidth, 30, tf, container);
			
			tf = new TextFormat(FontStyle.defaultFontName, FontStyle.defaultFontSize, 0xfff779, false, null, null, null, null, "center");
			warnTxt=createTextField("", 0, 0, minWidth, 30, tf, container);
			
			tf = new TextFormat(FontStyle.defaultFontName, FontStyle.defaultFontSize, 0xfff779, false, null, null, null, null, "center");
			freshText = createTextField("", 0, 0, minWidth, 30, tf, container);
			freshText.addEventListener(TextEvent.LINK, onLinkHandler);
			
//			warnTxt.htmlText = PreLang.LOADING_WARN;
			setGameName("俄罗斯方块");
			
			layout();
		}
		
		private function drawMask(g:Graphics, width:Number,heigth:Number = 10, color:int = 0xFF0000):void
		{
			if(g)
			{
				g.clear();
				g.beginFill(color);
				g.drawRoundRect(0, 0, width, heigth, 10, 10 );
				g.endFill();
			}
		}
		
		private function createTextField(txt:String, px:Number, py:Number, tw:Number, th:Number, tf:TextFormat, parent:DisplayObjectContainer):TextField
		{
			var t:TextField=new TextField;
			t.defaultTextFormat=tf;
			t.selectable=false;
			t.width=tw;
			t.height=th;
			t.x=px;
			t.y=py;
			t.htmlText=txt;
			parent.addChild(t);
			return t;
		}
		
		private function onLinkHandler(event:TextEvent):void
		{
			ExternalInterface.call('reloadPage');
		}
		
		private function onComplete(loader:Loader):void
		{
			layout();
		}
		
		public function setGameName(value:String):void
		{
			_gameName = value;
			var str:String=PreLang.LOADING_TIPS_0 + _gameName + PreLang.LOADING_TIPS_1 +"<A href='event:reload'><FONT COLOR='#00F7FE'><b><u>"+PreLang.LOADING_TIPS_2+"</u></b></FONT></A></p>";
//			freshText.htmlText = str;
		}
		
		/**
		 * 把 字符串形式的颜色值转换成uint
		 * Map "#77EE11" to 0x77EE11
		 * @param color
		 * @return 
		 * 
		 */		
		private function getColor(color:String):uint
		{
			var result:uint = 0;
			var n:Number;
			if (color)
			{
				if (color.charAt(0) == "#")
				{
					n = Number("0x" + color.slice(1));
				}
				else if (color.charAt(1) == "x" && color.charAt(0) == '0')
				{
					n = Number(color);
				}
				if(!isNaN(n))
				{
					result = uint(n);
				}
			}
			return result;
		}
		
		public function layout(e:Event=null):void
		{
			if (stage)
			{
				drawMask(this.graphics, stage.stageWidth, stage.stageHeight, getColor(Parameters.getInstance().bg_color));
				container.x = (stage.stageWidth - minWidth) * 0.5;
				container.y = (stage.stageHeight - minHeight) * 0.5;
				if (welcome)
				{
					welcome.x = (minWidth - welcome.width) * 0.5;
					welcome.y = (minHeight - welcome.height) * 0.5;
				}
				
				if(logo)
				{				
					logo.x = (minWidth - logo.width) * 0.5;
					logo.y = 0;
				}
				
				if(progressBar)
				{
					progressBar.x = (minWidth - progressBar.width) * 0.5;
					progressBar.y = 435;
				}
				
				totalText.x = (minWidth - totalText.width) * 0.5;
				totalText.y = 440;
				
				tipTxt.x = (minWidth - totalText.width) * 0.5;
				tipTxt.y = 485;
				
				warnTxt.x = (minWidth - totalText.width) * 0.5;
				warnTxt.y = 530;
				
				freshText.x = (minWidth - totalText.width) * 0.5;
				freshText.y = 550;
			}
		}
		
		public function setItemLabel(value:String):void
		{
			totalText.htmlText=value;
		}
		
		public function setItemPercent(str:String, value:Number, total:Number):void
		{
			if(total>0)
			{
				_itemPercent=value / total;
				if(str == null)
				{
					str = "";
				}
				str = str.replace("{percent}", int(itemPercent * 100));
				setItemLabel(str);
			}
		}
		
		public function setTotalPercent(value:Number, total:Number):void
		{
			if(total > 0)
			{
				_totalPercent=value / total;
				progressBar.percent = totalPercent;
				setTotalLabel(int(totalPercent * 100) + "%");
				
				if(this.stage && this.hasEventListener(Event.ENTER_FRAME) == false)
				{
//					this.addEventListener(Event.ENTER_FRAME, onFrame);
					time = getTimer();
//					random();
				}
			}
		}
		
		public function setTotalLabel(value:String):void
		{
			progressBar.htmlText = value;
		}
		
		public function loadBG(rootUrl:String, proxyName:String=""):void
		{
			if(!welcomeLoaded)
			{
				welcomeLoaded = true;
				var url:String ;
				if (proxyName == "baidu")
				{
					url = rootUrl + "baidubg.jpg";
				}
				else
				{
					url = rootUrl + "bg.jpg";
				}
				welcome.$load(url);
//				logo.$load(rootUrl + "logo.swf");
			}
		}
		
		private function onFrame(event:Event):void
		{
			if(getTimer() - time >= 5000)
			{
				time = getTimer();
				random();
			}
		}
		
		private function random():void
		{
			index = Math.floor(Math.random() * PreLang.tips.length);
			if(index < PreLang.tips.length)
			{
				var tip:String = PreLang.tips[index];
				tipTxt.htmlText = tip;
			}
		}
		
		/**
		 * 显示加载条 
		 * @param parent
		 * 
		 */		
		public function show(parent:DisplayObjectContainer):void
		{
			if(parent && this.parent != parent)
			{
				parent.addChild(this);
			}
		}
		
		public function get itemPercent():Number
		{
			return _itemPercent;
		}
		
		public function get totalPercent():Number
		{
			return _totalPercent;
		}
		
		public function dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
			time = 0;
//			this.removeEventListener(Event.ENTER_FRAME, onFrame);
		}

	}
}