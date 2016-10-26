package com.hansoninc.paintapp.tools
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class Cut extends ToolButton
	{
		public function Cut()
		{
			super();
			action = PaintApp.CUT;
			
			initIcon("cut.png");
		}
	}
}