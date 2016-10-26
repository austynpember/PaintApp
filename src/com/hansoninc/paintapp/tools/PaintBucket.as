package com.hansoninc.paintapp.tools
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class PaintBucket extends ToolButton
	{
		public function PaintBucket()
		{
			super();
			action = PaintApp.PAINTBUCKET;
			initIcon("paintbucket.png");
		}
	}
}