package com.hansoninc.paintapp.tools
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	public class Polygon extends ToolButton
	{	
		public function Polygon()
		{
			super();
			action = PaintApp.POLYGON;
			initIcon("polygon.png");
			
		}
	} //End class Polygon
}