/////////////////////////////////////////////////////////////////////////////////////////
// TXIEJUN Confidential 
// Copyright 2015. All rights reserved. 
// 
// MainGame.as
// Summary // TODO Auto-generated summary stub
// Version 1.0
// Author txiejun
// Contact txiejun@126.com
// Created Dec 27, 2014, 4:55:19 PM
/////////////////////////////////////////////////////////////////////////////////////////
package com.game.view.game
{
	import aurora.core.GlobalSetting;
	import aurora.core.IDisposable;
	import aurora.event.EventManager;
	import aurora.input.keyboard.KeyManager;
	import aurora.input.keyboard.Keys;
	import aurora.logging.LogManager;
	import aurora.mobile.core.UISprite;
	import aurora.timer.Clock;
	import aurora.timer.IUpdater;
	import aurora.timer.UpdaterManager;
	import aurora.utils.GraphicsUtil;
	import aurora.utils.MathUtil;
	
	import com.game.GameManager;
	import com.game.ModuleCommand;
	import com.game.view.game.blocks.Block0;
	import com.game.view.game.blocks.Block1;
	import com.game.view.game.blocks.Block2;
	import com.game.view.game.blocks.Block3;
	import com.game.view.game.blocks.Block4;
	import com.game.view.game.blocks.Block5;
	import com.game.view.game.blocks.Block6;
	import com.sound.MusicManager;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	
	import game.databin.vo.TetrisLevelVO;
	
	
	/**
	 * 游戏主逻辑
	 * @author txiejun
	 * @created Dec 27, 2014, 4:55:19 PM
	 */
	public class MainGame extends Sprite implements IUpdater, IDisposable
	{
		private const GAME_START:int = 1;
		private const GAME_PAUSE:int = 2;
		private const GAME_END:int = 3;
		
		private const START_X:int=3;
		private const START_Y:int=-3;
		
		private const DIR_NULL:int = -99999;
		/**
		 * 原地 
		 */		
		private const DIR_DEFAULT:int = 0;
		/**
		 * 向左 
		 */		
		private const DIR_LEFT:int = -1;
		/**
		 * 向右 
		 */		
		private const DIR_RIGHT:int = 1;
		/**
		 * 向下 
		 */		
		private const DIR_DOWN:int = 2;
		/**
		 * 向上 
		 */		
		private const DIR_UP:int = 3;
		
		private var _width:Number=0;
		private var _height:Number=0;
		private var gridLayer:Shape;
		private var effectBottom:Sprite;
		private var gameLayer:Sprite;
		private var effectTop:Sprite;
		private var gameMask:Shape;
		/**
		 * 当前关卡目标分数 
		 */		
		private var targetScore:Number =0;
		/**
		 * 当前获得的分数 
		 */		
		private var score:Number = 0;
		/**
		 * 总分数 
		 */		
		private var totalScore:Number =0;
		/**
		 * 游戏等级 
		 */		
		private var level:int = 0;
		/**
		 * 游戏模式 
		 */		
		private var mode:int = 0;
		
		private var blocks:Array;
		private var state:int;
		/**
		 * 方块数据
		 */		
		private var cubeMap:Array;
		/**
		 * 方块显示对象 
		 */
		private var cubeList:Array;
		private var nowBlock:Block;
		private var nextBlock:Block;
		/**
		 * 下一个方块界面 
		 */		
		public var gameView:IGameView;
		
		private var nextBlocks:Array = [];
		
		private var xIndex:int;
		private var yIndex:int;
		private var _speedCount:int = 0;
		protected var _speed:int = 60;
		private var levelVO:TetrisLevelVO;
		private var touchPos:Point;
		private var touchStartPoint:Point;
		private var touchEndPoint:Point;
		private var isDown:Boolean = false;
		
		private var touchDir:int = -99999;
		/**
		 * 控制长按某个按键时 执行按键函数的间隔（INTERVAL*enterframe的间隔时间） 不影响单次按键 
		 */		
		private var keyFlag:uint=0; 
		private var lastKeyFlag:uint=0; 
		private var touchStartTime:int;
		private const INTERVAL:uint=1;
		private var touchInterval:int = 500;
		private const MOVE_INTERVAL:int = 40;
		private var touchTime:int;
		
		public function MainGame()
		{
			super();
			initView();
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
		
		private function initView():void
		{
			width = GameConst.ROW_MAX * GameConst.CUBE_SIZE;
			height = GameConst.COLUMN_MAX * GameConst.CUBE_SIZE;
			GraphicsUtil.drawRect(this.graphics, 0, 0, this.width, this.height, 0, 0x000000);
			
			gridLayer = new Shape();
			this.addChild(gridLayer);

			effectBottom = new Sprite();
			effectBottom.mouseChildren = false;
			effectBottom.mouseEnabled = false;
			this.addChild(effectBottom);
			
			gameLayer = new Sprite();
			gameLayer.mouseChildren = false;
			gameLayer.mouseEnabled = false;
			this.addChild(gameLayer);
			
			effectTop = new Sprite();
			effectTop.mouseChildren = false;
			effectTop.mouseEnabled = false;
			this.addChild(effectTop);
			
			gameMask = new Shape();
			GraphicsUtil.drawRect(gameMask.graphics, 0, 0, this.width, this.height, 0, 0x000000);
			this.addChild(gameMask);
			this.mask = gameMask;
			
			initGrid();
			
			initEvent();
			
			initData();
		}
		
		private function initGrid():void
		{
			var graphics:Graphics = gridLayer.graphics;
			graphics.clear();
			graphics.lineStyle(1, 0x14325a, 1);
			for(var i:int=0; i <= GameConst.ROW_MAX; i++)
			{
				graphics.moveTo(i * GameConst.CUBE_SIZE, 0);
				graphics.lineTo(i * GameConst.CUBE_SIZE, GameConst.COLUMN_MAX * GameConst.CUBE_SIZE);
			}
			for(var j:int=0; j <= GameConst.COLUMN_MAX; j++)
			{
				graphics.moveTo(0, j * GameConst.CUBE_SIZE);
				graphics.lineTo(GameConst.ROW_MAX * GameConst.CUBE_SIZE, j * GameConst.CUBE_SIZE);
			}
		}
		
		private function initEvent():void
		{
			GlobalSetting.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			GlobalSetting.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}
		
		private function initData():void
		{
			Cube.setStyle(Style.getBitmapData("cube"), 6);
			blocks = [Block0, Block1, Block2, Block3, Block4, Block5, Block6];
			
			cubeList = new Array();
			cubeMap = new Array();
			for(var j:int=0; j < GameConst.COLUMN_MAX; j++)
			{
				//背景数组，ROW_MAX*COLUMN_MAX格式
				cubeMap.push(new Array(GameConst.ROW_MAX));
				cubeList.push(new Array(GameConst.ROW_MAX));
			}
		}
		
		public function setInfo(mode:int, level:int):void
		{
			this.mode = mode;
			this.level = level;
		}
		
		public function startGame():void
		{
			dispose();
			state = GAME_START;
			for(var i:int=0; i < GameConst.COLUMN_MAX; i++)
			{
				for(var j:int=0; j < GameConst.ROW_MAX; j++)
				{
					cubeMap[i][j]=0;
					cubeList[i][j] = null;
				}
			}
			
			//计分系统初始化
			score=0;
			totalScore = 0;
			levelVO = GameManager.getTetrisLevelVO(level);
			if(levelVO)
			{
				_speed = levelVO.speed;
				targetScore = levelVO.target_score;
			}
			
			if(gameView)
			{
				gameView.setScore(this.totalScore);
				gameView.setTarget(targetScore);
				gameView.setLevel(level);
			}
			
			xIndex = START_X;
			yIndex = START_Y;
			
			nowBlock = randomBlock();
			nextBlock = randomBlock();
			addNextBlock(nextBlock);
			
			UpdaterManager.getInstance().addUpdater(this);
		}
		
		public function endGame():void
		{
			dispose();
			state = GAME_END;
		}
		
		public function resumeGame():void
		{
			state = GAME_START;
			UpdaterManager.getInstance().addUpdater(this);
		}
		
		public function pauseGame():void
		{
			state = GAME_PAUSE;
			UpdaterManager.getInstance().removeUpdater(this);
		}
		
		/**
		 * 是否显示/隐藏网格 
		 * @param value
		 * 
		 */		
		public function setGridVisible(value:Boolean):void
		{
			gridLayer.visible = value;
		}
		
		/**
		 * 产生随机的方块
		 *
		 */
		private function randomBlock():Block
		{
			var result:Block;
			if(blocks)
			{
				var index:int = MathUtil.random(0, blocks.length - 1);
				result = createBlock(index);
				if(result)
				{
					result.randomShape();
					result.render();
				}
			}
			return result;
		}
		
		/**
		 * 检测当前方块在direction的方向上移动一格后是否碰到障碍物
		 * @param xIndex 方块的x坐标索引
		 * @param yIndex 方块的y坐标索引
		 * @param direction 方向 (=0 原地，=-1 向左, =1 向右, =2 向下)
		 * @param shape 方块形状
		 * @return true=可行，false=不可行
		 *
		 */
		private function checkValidate(xIndex:int, yIndex:int, direction:int, shape:Array):Boolean
		{
			if(shape)
			{
				var i:int;
				var tempShap:Array = new Array();
				for(i=0; i < 4; i++)
				{
					tempShap.push(new Array(2));
				}
				for(i=0; i < 4; i++)
				{
					tempShap[i][0]=shape[i][0];
					tempShap[i][1]=shape[i][1];
				}
				switch (direction)
				{
					case DIR_LEFT:
						for(i=0; i < 4; i++)
						{
							tempShap[i][0]=tempShap[i][0] - 1;
						}
						break;
					case DIR_DEFAULT:
						break;
					case DIR_RIGHT:
						for(i=0; i < 4; i++)
						{
							tempShap[i][0]=tempShap[i][0] + 1;
						}
						break; 
					case DIR_DOWN:
						for(i=0; i < 4; i++)
						{
							tempShap[i][1]=tempShap[i][1] + 1;
						}
						break;
					default:
						 break;
				}
				for(i=0; i < 4; i++)
				{
					var indexI:int=xIndex + tempShap[i][0];
					var indexJ:int=yIndex + tempShap[i][1];
					if (indexI < 0 || indexI >= GameConst.ROW_MAX || indexJ >= GameConst.COLUMN_MAX)
					{
						//出界 
						return false;
					}
					else
					{
						if(indexJ<0)
						{
							continue;
						}
						if (cubeMap[indexJ][indexI] == 1)
						{
							//检测到当前方块和背景数组中的对象有重叠 说明碰到了障碍
							return false;
						}
					}
					
				}
				if (i >= 4)
				{
					return true;
				}
				else
				{
					return false;
				}	
			}
			return false;
		}
		
		/**
		 * 左移一格 
		 * 
		 */		
		private function leftAction():void
		{
			LogManager.info("leftAction =====");
			//左移可行性判断
			if (checkValidate(xIndex, yIndex, DIR_LEFT, nowBlock.getShape()))
			{
				MusicManager.playSound("snd_action");
				xIndex--;
				displayGame();
			}
		}
		
		/**
		 * 右移一格 
		 * 
		 */		
		private function rightAction():void
		{
			LogManager.info("rightAction =====");
			//右移可行性判断
			if (checkValidate(xIndex, yIndex, DIR_RIGHT, nowBlock.getShape()))
			{
				MusicManager.playSound("snd_action");
				xIndex++;
				displayGame();
			}
		}
		/**
		 * 向下移动一格 
		 * 
		 */		
		private function downAction():void
		{
			LogManager.info("downAction =====");
			//键盘控制下落
			if (checkValidate(xIndex, yIndex, DIR_DOWN, nowBlock.getShape()))
			{
				//右移可行性判断
				MusicManager.playSound("snd_action");
				yIndex++;
				displayGame();
			}
		}
		/**
		 * 一落到底 
		 * 
		 */		
		private function dropAction():void
		{
			LogManager.info("dropAction =====");
			if(nowBlock)
			{
				//一键下落到底
				while (checkValidate(xIndex, yIndex, DIR_DOWN, nowBlock.getShape()))
				{
					++yIndex;
				}
				
				dropBlock();
			}
		}
		
		/**
		 * 旋转 
		 * 
		 */		
		private function rotateAction():void
		{
			LogManager.info("rotateAction =====");
			//旋转
			if(nowBlock)
			{
				MusicManager.playSound("snd_rotate");
				nowBlock.nextShape();
				if(checkValidate(xIndex, yIndex, DIR_DEFAULT, nowBlock.getShape()) == false)
				{
					nowBlock.preShape();
				}
				else
				{
					displayGame();
				}
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			var intervalFlg:uint=Math.abs(keyFlag - lastKeyFlag);
			if (intervalFlg >= INTERVAL)
			{
				lastKeyFlag=keyFlag;
				onKeyDown(event);
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			keyFlag=lastKeyFlag + INTERVAL;
		}
		
		/**
		 * key按下 
		 * @param event
		 * 
		 */		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(state == GAME_START && nowBlock)
			{
				switch (event.keyCode)
				{
					case Keys.LEFT:
						leftAction();
						break;
					case Keys.RIGHT:
						rightAction();
						break;
					case Keys.UP:
						rotateAction();
						break;
					case Keys.DOWN:
						downAction();
						break;
					case Keys.SPACE:
						dropAction();
						break;
					default:
						break;
				}
			}
		}
		
		private function updateTouch(touchDir:int):void
		{
			if(touchDir == DIR_LEFT)
			{
				leftAction();
			}
			else if(touchDir == DIR_RIGHT)
			{
				rightAction();
			}
			else if(touchDir == DIR_DOWN)
			{
				downAction();
			}
		}
		
		/**
		 * ← → 上 下 
		 * @param event
		 * 
		 */		
		private function onMouseEvent(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_DOWN)
			{
				touchStartPoint = new Point(event.localX, event.localY);
				touchPos = touchStartPoint.clone();
				touchStartTime = getTimer();
				touchTime = touchStartTime;
				isDown = true;
				LogManager.info("MouseEvent.type:{0}, touchStartPoint:{1}", event.type, touchStartPoint);
//				effectTop.graphics.clear();
//				effectTop.graphics.lineStyle(8, 0xFF0000);
//				effectTop.graphics.moveTo(touchStartPoint.x, touchStartPoint.y);
			}
			else if(event.type == MouseEvent.MOUSE_UP)
			{
				onMouseUp(event);
			}
			else if(event.type == MouseEvent.MOUSE_MOVE)
			{
				if(isDown)
				{
					var t:int = getTimer() - touchTime;
					LogManager.info("move time :{0}", t);
					if(t>=MOVE_INTERVAL)
					{
						touchTime = getTimer();
						var curPos:Point = new Point(event.localX, event.localY);
						touchDir = getMoveDir(touchPos, curPos);
						touchPos = curPos;
						updateTouch(touchDir);
//						effectTop.graphics.lineTo(touchPos.x, touchPos.y);
					}
				}
			}
			else if(event.type == MouseEvent.MOUSE_OUT)
			{
				onMouseUp(event);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			touchEndPoint = new Point(event.localX, event.localY);
			LogManager.info("MouseEvent.type:{0}, touchEndPoint:{1}, isDown:{2}", event.type, touchEndPoint, isDown);
			if(isDown)
			{
				var t:int = getTimer() - touchStartTime;
				LogManager.info("uptime :{0}", t);
				if(t <= touchInterval)
				{
					touchDir = getMoveDir(touchStartPoint, touchEndPoint);
					if(touchDir == DIR_DEFAULT)
					{
						rotateAction();
					}
					else if(touchDir == DIR_DOWN)
					{
						dropAction();
					}
				}
			}
			isDown = false;
//			effectTop.graphics.clear();
		}
		
		private function getMoveDir(startPos:Point, endPos:Point):int
		{
			var dir:int = DIR_NULL;
			if(startPos && endPos)
			{
				var xVector:Number = endPos.x - startPos.x;
				var yVector:Number = endPos.y - startPos.y;
				var xDis:Number = Math.abs(xVector);
				var yDis:Number = Math.abs(yVector);
				
				if(xDis > 5 || yDis > 5)
				{
					if(Math.abs(xDis) > Math.abs(yDis))
					{
						//水平方向
						if(xVector > 0)
						{
							//向右
							dir = DIR_RIGHT;
						}
						else
						{
							//向左
							dir = DIR_LEFT;
						}
					}
					else
					{
						//垂直方向
						if(yVector > 0)
						{
							//向下
							dir = DIR_DOWN;
						}
						else
						{
							//向上
							dir = DIR_UP;
						}
					}
				}
				else
				{
					//理解为点击
					dir = DIR_DEFAULT;
				}
			}
			return dir;
		}
		
		public function onUpdate(clock:Clock):void
		{
			if(state == GAME_PAUSE)
			{
				return;
			}
			_speedCount += clock.frameCount;
			if(_speedCount >= _speed)
			{
				updateStep();
				_speedCount=0;
			}
			keyFlag++;
		}
		
		public function isGaming():Boolean
		{
			return state == GAME_START;
		}
		
		/**
		 * 帧数增量 
		 * @param addFrame 默认为1
		 * 
		 */		
		protected function updateStep():void 
		{
			dropBlock();
			displayGame();
		}
		
		/**
		 * 下落函数
		 * 当前方块下落一格是否碰到边界或方块
		 */
		private function dropBlock():void
		{
			if(nowBlock)
			{
				var isValidate:Boolean = checkValidate(xIndex, yIndex, DIR_DOWN, nowBlock.getShape());
				if(isValidate)
				{
					//如果当前方块下落一格没有碰到边界或方块则下落一格
					++yIndex;
				}
				else
				{
					//先填充
					holdBlock(nowBlock);
					nowBlock = null;
					//删除行判断
					var deleteList:Array = getDeleteRows(yIndex);
					var count:int = deleteBlock(deleteList);
					updateScoreAndLevel(count);
					
					var isOver:Boolean = false;
					for(var j:int=0; j < GameConst.ROW_MAX; j++)
					{
						if (cubeMap[0][j] == 1)
						{
							isOver = true;
							break;
						}
						
					}
					if (isOver)
					{
						//如果下一格碰到方块则游戏结束
						state = GAME_END;
						UpdaterManager.getInstance().removeUpdater(this);
						if(GameManager.bestScore<this.totalScore)
						{
							GameManager.bestScore = this.totalScore;
						}
						EventManager.dispatchEvent(ModuleCommand.SHOW_GAME_OVER_PANEL, [this.totalScore, GameManager.bestScore, level]);
					}
					else
					{
						//重置方块位置
						xIndex = START_X;
						yIndex = START_Y;
						
						nowBlock = nextBlock;
						if(nowBlock && nowBlock.parent)
						{
							nowBlock.parent.removeChild(nowBlock);
						}
						nowBlock.scaleX = 1;
						nowBlock.scaleY = 1;
						nextBlock = randomBlock();
						addNextBlock(nextBlock);
					}
				}
			}
		}
		
		/**
		 * 计算得分和升级 
		 * @param count 本次消除的行数 
		 * 
		 */		
		private function updateScoreAndLevel(count:int):void
		{
			var nowScore:int = 1;
			if(count == 1)
			{
				nowScore += 10; 
			}
			else if(count == 2)
			{
				nowScore += 30;
			}
			else if(count == 3)
			{
				nowScore += 60;
			}
			else if(count == 4)
			{
				nowScore += 100;
			}
			
			this.totalScore += nowScore;
			if(level < GameConst.MAX_LEVEL)
			{
				this.score += nowScore;
				//升级
				if(score >= targetScore)
				{
					++level;
					if(level > GameConst.MAX_LEVEL)
					{
						level = GameConst.MAX_LEVEL;
					}
					GameManager.gameLevel = level;
					this.score = 0;
					trace("恭喜升级：", level);
					levelVO = GameManager.getTetrisLevelVO(level);
					if(levelVO)
					{
						_speed = levelVO.speed;
						targetScore = levelVO.target_score;
					}
					if(gameView)
					{
						gameView.setTarget(targetScore);
						gameView.setLevel(level);
					}
				}
			}
			
			if(gameView)
			{
				gameView.setScore(this.totalScore);
			}
		}
		
		
		private function addNextBlock(block:Block):void
		{
			if(gameView && gameView.nextBlockLayer)
			{
				gameView.nextBlockLayer.addChild(block);
				block.x = 15;
				block.scaleX = 0.5;
				block.scaleY = 0.5;
			}
		}
		
		private function createNextBlock():void
		{
			if(nextBlocks == null)
			{
				nextBlocks = new Array();
			}
			while(nextBlocks.length < 3)
			{
				nextBlocks.push(randomBlock());
			}
		}
		
		private function holdBlock(block:Block):void
		{
			if(block)
			{
				MusicManager.playSound("snd_hold");
				var nowShape:Array = block.getShape();
				var cube:Cube;
				//碰到边界或方块
				for(var i:int=0; i < 4; i++)
				{
					//修改背景数组，将当前方块的位置改为边界类型
					var indexI:int=xIndex + nowShape[i][0];
					var indexJ:int=yIndex + nowShape[i][1];
					cube = block.cubeList[i];
					cube.data = new Point(indexI, indexJ);
					trace("data:", cube.data);
					if(indexJ>=0&&indexI>=0 && indexJ<GameConst.COLUMN_MAX&&indexI<GameConst.ROW_MAX)
					{
						cubeMap[indexJ][indexI]=1;
						if(cube.parent)
						{
							cube.parent.removeChild(cube);
						}
						gameLayer.addChild(cube);
						cube.x = indexI * GameConst.CUBE_SIZE;
						cube.y = indexJ * GameConst.CUBE_SIZE;
						cubeList[indexJ][indexI] = cube;
					}
					else
					{
						if(cube.parent)
						{
							cube.parent.removeChild(cube);
						}
						trace("出界：", cube.data);
						cube.dispose();
					}
				}
				block.cubeList = null;
				block.dispose();
			}
		}
		
		/**
		 * 获得可以被删除的行 
		 * @param index 当前所在位置
		 * @return 返回行标数组
		 * 
		 */		
		private function getDeleteRows(index:int=0):Array
		{
			var result:Array = null;
			if(index<0)
			{
				return result;
			}
			var cutCount:int=0;
			result = [];
			for(var i:int=index; i < GameConst.COLUMN_MAX && i<(index+4); i++)
			{
				for(var j:int=0; j < GameConst.ROW_MAX; j++)
				{
					if (cubeMap[i][j] == 0)
					{
						//如果该行有空，则开始判断下一行
						break;
					}
					else if (j >= GameConst.ROW_MAX-1)
					{
						//判断到该行最后一列都没有空 可删除该行
						result.push(i);
					}
				}
			}
			return result;
		}
		
		/**
		 * 从bgMap的第index行开始检测是否有可以消除的行
		 * @param index 检测开始的y方向索引
		 * @return 返回本次消除的行数
		 * 
		 */		
		private function deleteBlock(deleteList:Array):int
		{
			var len:int = 0;
			if(deleteList && deleteList.length>0)
			{
				len = deleteList.length;
				var j:int;
				var rowIndex:int;
				var cube:Cube;
				for(var i:int = 0; i<len; ++i)
				{
					rowIndex = deleteList[i];
					for(j=0; j < GameConst.ROW_MAX; j++)
					{
						cube = cubeList[rowIndex][j];
						if(cube)
						{ 
							cube.dispose();
							if(cube.parent)
							{
								cube.parent.removeChild(cube);
							}
						}
						cubeList[rowIndex][j] = null;
						cubeMap[rowIndex][j] = 0;
					}
					
					for(var k:int=rowIndex; k >= 0; k--)
					{
						//上方方块下落
						for(var m:int=0; m < GameConst.ROW_MAX; m++)
						{
							if(k>0)
							{
								cubeMap[k][m]=cubeMap[k-1][m];	
								cubeList[k][m]=cubeList[k-1][m];	
								cube = cubeList[k][m];
								if(cube)
								{
									cube.data = new Point(k, m);
									cube.x = m * GameConst.CUBE_SIZE;
									cube.y = k * GameConst.CUBE_SIZE;
								}
							}
						}
					}
				}
			}
			return len;
		}
		
		private function displayGame():void
		{
			if(nowBlock)
			{
				if(nowBlock.parent == null)
				{
					gameLayer.addChild(nowBlock);
				}
				nowBlock.render();
				nowBlock.x = xIndex * GameConst.CUBE_SIZE;
				nowBlock.y = yIndex * GameConst.CUBE_SIZE;
			}
		}
		
		/**
		 * 根据类型创建方块 
		 * @param blockType
		 * @return 
		 * 
		 */		
		private function createBlock(blockType:int):Block
		{
			var block:Block;
			if(blocks && blockType < blocks.length)
			{
				var cls:Class = blocks[blockType];
				if(cls)
				{
					block = new cls() as Block;
				}
			}
			return block;
		}
		
		
		private function clear():void
		{
			totalScore = 0;
			score = 0;
			targetScore = 0;
		}
		
		public function dispose():void
		{
			clear();
			UpdaterManager.getInstance().removeUpdater(this);
			if(nowBlock)
			{
				nowBlock.dispose();
			}
			nowBlock = null;
			
			if(nextBlock)
			{
				nextBlock.dispose();
			}
			nextBlock = null;
			if(cubeList)
			{
				var list:Array;
				var len:int = cubeList.length;
				var count:int;
				var c:Cube;
				for(var i:int = 0;i<len;++i)
				{
					list = cubeList[i];
					count = list.length;
					for(var j:int = 0; j< count; ++j)
					{
						c = list[j];
						if(c)
						{
							c.dispose();
							if(c.parent)
							{
								c.parent.removeChild(c);
							}
						}
						cubeList[i][j] = null;
					}
				}
			}
		}
		
	}
}
