/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// GameManager.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 25, 2014, 9:32:24 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game
{
	import aurora.core.GlobalSetting;
	import aurora.resource.caches.ResourcePool;
	import aurora.utils.ShareObjectUtil;
	
	import com.game.view.game.GameConst;
	import com.game.vo.RankVO;
	import com.preloader.PreUrl;
	
	import game.databin.table.TetrisLevelTable;
	import game.databin.vo.TetrisLevelVO;

	/**
	 * 
	 * @author txiejun
	 * @created Dec 25, 2014, 9:32:24 PM
	 */
	public class GameManager
	{
		private static var _levelTab:TetrisLevelTable;
		private static var xml:XML;
		private static var _top10:Array = [];
		public static var imgPath:String;
		public static var gameMode:int;
		public static var gameLevel:int = 1;
		public static var bestScore:Number = 0;
		public static var gridVisible:Boolean = true;
		public static var nextVisible:Boolean = true;
		
		public function GameManager()
		{
		}
		
		public static function init():void
		{
			if(_levelTab == null)
			{
				_levelTab = new TetrisLevelTable();
				_levelTab.binaryRead(ResourcePool.get(PreUrl.DATABIN_TETRIS_LEVEL));
				
				var data:Array = read();
				if(data)
				{
					setTop10(data);
				}
			}
			if(xml == null)
			{
				xml = new XML(ResourcePool.get(PreUrl.CONFIG_URL));
				var soundPath:XMLList = xml.sound_path;
				var imgPath:XMLList = xml.img_path;
				imgPath = imgPath.@url;
			}
			
		}
		
		public static function getTetrisLevelVO(lv:int):TetrisLevelVO
		{
			init();
			return _levelTab.getTetrisLevelVO(lv);
		}
		
		public static function updateTop10(vo:RankVO):void
		{
			if(_top10 && vo)
			{
				var isChange:Boolean = false;
				if(_top10.length < 10)
				{
					_top10.push(vo);
					isChange = true;
				}
				else
				{
					var temp:RankVO = _top10[9];
					if(temp && temp.score < vo.score)
					{
						_top10[9] = vo;
						isChange = true;
					}
				}
				if(isChange)
				{
//					_top10.sortOn(["score", "time"], [Array.DESCENDING, Array.NUMERIC]);
					_top10.sort(compareFunction);
					save(_top10);
				}
			}
		}
		
		private static function compareFunction(item1:RankVO, item2:RankVO):int
		{
			var result:int = 0;
			if(item1 && item2)
			{
				if(item1.score > item2.score)
				{
					result = -1;
				}
				else if(item1.score < item2.score)
				{
					result = 1;
				}
				else
				{
					if(item1.time<item1.time)
					{
						result = -1;
					}
					else if(item1.time > item2.time)
					{
						result = 1;	
					}
				}
			}
			return result;
		}
		
		/**
		 * 保存本地数据 
		 * @param data
		 * 
		 */		
		public static function save(data:Array):void
		{
			if(data)
			{
				ShareObjectUtil.save(GameConst.TETRIS_LOCAL_DATA, data);
			}
		}
		
		/**
		 * 读取本地数据 
		 * @return 
		 * 
		 */		
		public static function read():Array
		{
			return ShareObjectUtil.read(GameConst.TETRIS_LOCAL_DATA);
		}
		
		public static function isTop10(score:Number):Boolean
		{
			var result:Boolean = false;
			if(_top10)
			{
				if(_top10.length < 10)
				{
					result = true;
				}
				else
				{
					var vo:RankVO = _top10[9];
					if(vo && vo.score < score)
					{
						result = true;
					}
				}
			}
			return result;
		}
		
		public static function getTop10():Array
		{
			return _top10;
		}
		
		public static function setTop10(data:Array):void
		{
			_top10 = data;
			if(_top10 == null)
			{
				_top10 = [];
			}
		}
		
	}
}
