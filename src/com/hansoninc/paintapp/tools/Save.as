package com.hansoninc.paintapp.tools
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class Save extends ToolButton
	{
		public function Save()
		{
			super();
			action = PaintApp.SAVE;

			initIcon("save.gif");
		}
	}
}