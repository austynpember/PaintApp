package com.hansoninc.paintapp.tools
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class Normal extends ToolButton
	{
		public function Normal()
		{
			super();
			action = PaintApp.NORMAL;
			initIcon("pencil_icon.gif");
		}

	}// End class Normal
}