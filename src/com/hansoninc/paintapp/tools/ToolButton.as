

package com.hansoninc.paintapp.tools
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class ToolButton extends Sprite
	{	
		/*private var _normal:Normal;
		private var _eraser:Eraser;*/
		
		private var loader:Loader;
		public var action:String;
		
		public function ToolButton()
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			initBoarder();
			buttonMode = true;
		} // End constructor
		
		private function init(e:Event = null):void{
			addEventListener(MouseEvent.CLICK, dispatchButtonEvent);
		}
		private function destroy(e:Event = null):void{
			removeEventListener(MouseEvent.CLICK, dispatchButtonEvent);
		}
		private function dispatchButtonEvent (e:Event):void{
			dispatchEvent(new Event(this.action, true));
		}
		
		private function initBoarder():void
		{
			var boarder:Sprite = new Sprite;
			addChild(boarder);
			boarder.graphics.lineStyle(1,0x000000,1);
			boarder.graphics.beginFill(0x9900FF,1);
			boarder.graphics.drawRect(0,0,40,40);
			boarder.graphics.endFill();
		}
		
		protected function initIcon(iconURL:String):void
		{
			loader = new Loader();
			addChild(loader);
			loader.load(new URLRequest(iconURL));
			loader.x = 4;
			loader.y = 4;
		}
	}
}