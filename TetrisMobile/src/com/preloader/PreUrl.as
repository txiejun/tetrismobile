/////////////////////////////////////////////////////////////////////////////////////////
// YEGAME Confidential 
// Copyright 2013. All rights reserved. 
// 
// PreUrl.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Jul 5, 2013 5:06:59 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.preloader
{
	import aurora.core.GlobalSetting;
	import aurora.core.Parameters;

	/**
	 *
	 * @author txiejun
	 * @created Jul 5, 2013 5:06:59 PM
	 */
	public class PreUrl
	{
		//cdn目录
		public static var CDN_URL:String = "";
		/**
		 * RES目录- 
		 * 
		 */		
		public static var LOCAL_URL:String="";
		
		/** 主程序**/
		public static var GAME_URL:String = "MainGame.swf";
		public static var CREATE_ROLE_URL:String = "CreateRole.swf";
		public static var VER_URL:String = "res/version.txt";
		public static var LOADBG:String = "res/loading/";
		public static var MAIN_UI:String="res/main_ui/main_ui.swf";
		public static var MAIN_PATH:String="res/main_ui/";
		public static var MOVIE_UI:String="res/main_ui/movie.swf";
		public static var SOUND_URL:String = "res/sound/";
		public static var MUSICS_URL:String="res/musics/";
		
		public static var CONFIG_URL:String = "res/config/config.xml";
		public static var DATABIN_TETRIS_LEVEL:String = "res/config/tetrisLevel.bin";
		
		public function PreUrl()
		{
		}
		
		public static function wrapperURL():void
		{
			if (Parameters.getInstance().isCdn == "true")
			{
				PreUrl.CDN_URL = Parameters.getInstance().cdnUrl;
				PreUrl.LOCAL_URL = Parameters.getInstance().resourceHost;
			}
			else
			{
				PreUrl.CDN_URL = Parameters.getInstance().resourceHost;
				PreUrl.LOCAL_URL = Parameters.getInstance().resourceHost;
			}
			
			GAME_URL = LOCAL_URL + GAME_URL;
			CREATE_ROLE_URL = LOCAL_URL + CREATE_ROLE_URL;
			VER_URL = LOCAL_URL + VER_URL;
			LOADBG = LOCAL_URL + LOADBG;
			CONFIG_URL = LOCAL_URL + CONFIG_URL;
			DATABIN_TETRIS_LEVEL = LOCAL_URL + DATABIN_TETRIS_LEVEL;
			MAIN_UI = LOCAL_URL + MAIN_UI;
			MAIN_PATH = LOCAL_URL + MAIN_PATH;
			MOVIE_UI = LOCAL_URL + MOVIE_UI;
			SOUND_URL = LOCAL_URL + SOUND_URL;
			MUSICS_URL = LOCAL_URL + MUSICS_URL;
		}
	}
}