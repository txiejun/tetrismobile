/////////////////////////////////////////////////////////////////////////////////////////
// YEGAME Confidential 
// Copyright 2013. All rights reserved. 
// 
// PreLang.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jul 5, 2013 4:30:06 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.preloader
{
	/**
	 *
	 * @author txiejun
	 * @created Jul 5, 2013 4:30:06 PM
	 */
	public class PreLang
	{
		public static const MAIN_0:String = "初始化...";
		public static const MAIN_1:String="加载版本文件";
		public static const MAIN_2:String="加载创建角色页面";
		public static const MAIN_3:String="加载游戏主文件";
		
		public static const CONFIG_6:String="UI资源";
		public static const CONFIG_7:String="鼠标资源";
		public static const CONFIG_8:String="配置文件";
		
		public static const tips:Array=[];
		public static const LOADING_TIPS_0:String="《";
		public static const LOADING_TIPS_1:String="》是一款别具风格的休闲小游戏，祝大家在游戏中玩得愉快。";
		public static const LOADING_TIPS_2:String="请点此刷新";
		public static const LOADING_TIPS_3:String="游戏资源加载中... ";
		public static const LOADING_WARN:String = "抵制不良游戏  拒绝盗版游戏  注意自我保护  谨防受骗上当 适度游戏益脑  沉迷游戏伤身  合理安排时间  享受健康生活";
		public static const PROXY_NAME_BAIDU:String ="baidu";
		public static const GAME_NAME:String ="俄罗斯方块";
		
		public function PreLang()
		{
		}
		
		public static function getRandomTip():String
		{
			return tips[Math.floor(Math.random() * tips.length)];
		}
	}
}