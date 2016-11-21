package com.game.view.game
{
	import aurora.core.IDataRenderer;
	import aurora.core.IDisposable;
	
	public interface IBlock extends IDisposable, IDataRenderer
	{
		function getShape():Array;
		function preShape():void;
		function nextShape():void;
		function randomShape():void;
		function render():void;
	}
}