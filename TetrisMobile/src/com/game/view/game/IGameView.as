package com.game.view.game
{
	import flash.display.Sprite;

	public interface IGameView
	{
		function get nextBlockLayer():Sprite;
		function setLevel(value:Number):void;
		function setTarget(value:Number):void;
		function setScore(value:Number):void;
	}
}