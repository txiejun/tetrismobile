/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// NativeManager.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jan 5, 2015, 2:17:42 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.manager
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;

	/**
	 * 
	 * @author txiejun
	 * @created Jan 5, 2015, 2:17:42 PM
	 */
	public class NativeManager
	{
		public function NativeManager()
		{
		}
		
		/**
		 * 是否关闭 休眠模式
		 * @param value
		 */
		public static function keepAwake(value:Boolean):void
		{
			if(value)
			{
				NativeApplication.nativeApplication.systemIdleMode= SystemIdleMode.KEEP_AWAKE;
			}
			else
			{
				NativeApplication.nativeApplication.systemIdleMode= SystemIdleMode.NORMAL;
			}
		}
		
		/**
		 * 版本号 
		 * @return 
		 * 
		 */		
		public static function get version():String
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;//配置文件
			trace("appDescriptor:",appDescriptor);
			var ns:Namespace =appDescriptor.namespace();
			return "" +appDescriptor.ns::versionNumber;
		}
	}
}
