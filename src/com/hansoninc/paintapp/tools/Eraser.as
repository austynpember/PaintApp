package com.hansoninc.paintapp.tools
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	public class Eraser extends ToolButton
	{
		public function Eraser()
		{
			super();
			action = PaintApp.ERASER;

			initIcon("eraser.gif");
		}

	}// End Class Eraser
}