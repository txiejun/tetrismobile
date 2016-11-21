/////////////////////////////////////////////////////////////////////////////////////////
// YEGAME Confidential 
// Copyright 2012. All rights reserved. 
// 
// SimpleLoader.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Created Sep 18, 2012 8:51:32 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.preloader
{
	import aurora.resource.URLUtil;
	import aurora.resource.loading.LoadConst;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 简单的显示对象加载器 -主要用于预加载的一些事务
	 * @author txiejun
	 * @contact txiejun@126.com
	 * @created Sep 18, 2012 8:51:32 PM
	 */
	public class SimpleLoader extends Loader
	{
		protected var _url:String = null;
		protected var _oldUrl:String = null;
		private var inited:Boolean = false;
		public var callBack:Function;
		public var progressHandler:Function;
		/**
		 * 加载模式
		 * 1 采用yy5ver_11_name.png的方式 
		 * 2采用name.png?ver=11
		 */		
		public var loadMode:int = LoadConst.PREFIX_1;
		protected var _numPrefixTries:int = 0;
		
		public function SimpleLoader(url:String = "")
		{
			if(url)
			{
				$load(url);
			}
		}
		
		private function onComplete(event:Event):void
		{
			if(callBack!=null)
			{
				callBack(this);
			}
			dispose();
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			if(progressHandler != null)
			{
				progressHandler(event.clone());
			}
		}
		
		private function onError(event:ErrorEvent):void
		{
			var needStop:Boolean = false;
			if(_url.indexOf(URLUtil.prefix) != -1)
			{
				//prefix 版本号 - 报错
				if(_numPrefixTries<1)
				{
					_url = URLUtil.wrapper2(_oldUrl);
					_numPrefixTries ++;
				}
				else
				{
					needStop = true;
				}
				if (needStop == false)
				{
					_url = URLUtil.wrapper2(_oldUrl);
					originalLoad(_url);
				}
			}
			else
			{
				trace("SimpleLoader.onError(), "+ event.text);
				if(callBack!=null)
				{
					callBack(null);
				}
				dispose();
			}
		}
		
		public function $load(url:String):void
		{
			_numPrefixTries = 0;
			_url = url;
			_oldUrl = _url;
			if(loadMode == LoadConst.PREFIX_1)
			{
				_url = URLUtil.wrapper(_url);
			}
			else if(loadMode == LoadConst.PREFIX_2)
			{
				_url = URLUtil.wrapper2(_url);
			}
			
			init();
			originalLoad(_url);
		}
		
		protected function originalLoad(url:String):void
		{
			load(new URLRequest(url));
		}
		
		public function init():void
		{
			if(!inited)
			{
				inited = true;
				contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				if(progressHandler !=null)
				{
					contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
				}
			}
		}
		
		public function stop():void
		{
			try
			{
				this.close();
			}
			catch (error:Error)
			{
				// Ignore any errors thrown by close()
			}
		}
		
		public function dispose():void
		{
			_url = "";
			_oldUrl = "";
			_numPrefixTries = 0;
			stop();
			if(inited)
			{
				contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				callBack = null;
				progressHandler = null;
				inited = false;
			}
		}

		public function get url():String
		{
			return _url;
		}

	}
}