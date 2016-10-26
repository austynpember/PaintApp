package com.hansoninc.paintapp.tools
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	public class Line extends ToolButton
	{
		public function Line()
		{
			super();
			action = PaintApp.LINE;
			initIcon("line.jpg");
		}
	}
}