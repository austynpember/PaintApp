package com.hansoninc.paintapp.tools
{
	import com.hansoninc.paintapp.colors.ColorPallet;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.MouseEvent;
	import com.hansoninc.util.GridView;
	
	public class ToolPanel extends Sprite
	{
		private var _panel:Sprite;
		
		public var colorPallet:ColorPallet;
		public var scalar:Scalar;
		
		public var toolButton1:ToolButton;
		public var toolButton2:ToolButton;
		public var toolButton3:ToolButton;
		public var toolButton4:ToolButton;
		public var toolButton5:ToolButton;
		public var toolButton6:ToolButton;
		public var toolButton7:ToolButton;
		
		public function ToolPanel()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function init(e:Event = null):void {
			initPanel();
			
			colorPallet = new ColorPallet();
			addChild(colorPallet);
			colorPallet.y = 180;
			
			initScale();
			
			var tools:Array = [Normal, Eraser, Polygon, Line, PaintBucket, Cut, Save];
			var toolButtons:Array = [];
			for each (var nextToolButton:Class in tools) {
				trace("a");
				var tmpClass:Class = nextToolButton;
				var toolButton:ToolButton = new tmpClass();
				addChild(toolButton);
				toolButtons.push(toolButton);
			}
			GridView.makeUniformGrid(toolButtons, { direction: "x", clipsXBegin: 0, clipsYBegin: 0, clipsPerRow: 2, xSpacing: 0, ySpacing: 0 });
			
			//addEventListener(MouseEvent.CLICK, function() { var whatToSay:String = this.width; repeatSomething(whatToSay); }, false, 0, true);
			//removeEventListener(MouseEvent.CLICK, function() { trace("hello"); });
			
			/*toolButton1 = new Normal();
			addChild(toolButton1);
			
			toolButton2 = new Eraser();
			addChild(toolButton2);
			toolButton2.x = 41;	
			
			toolButton3 = new Polygon();
			addChild(toolButton3);
			toolButton3.y = 41;
			
			toolButton4 = new Line();
			addChild(toolButton4);
			toolButton4.x = 41;
			toolButton4.y = 41;
			
			toolButton5 = new PaintBucket();
			addChild(toolButton5);
			toolButton5.y = 82;
			
			toolButton6 = new Cut();
			addChild(toolButton6);
			toolButton6.x = 41;
			toolButton6.y = 82;
			
			toolButton7 = new Save();
			addChild(toolButton7);
			toolButton7.y = 124;*/
		}
		
		public function destroy(e:Event = null):void {
			
		}
		
		public function repeatSomething(s:String):void {
			trace(s);
		}
		
		/*public function dispatch(e:MouseEvent):void
		{
			var par:* = parent;
			dispatchEvent(new Event(par.drawMode(e)));
		}*/
		
		private function initPanel():void
		{
			_panel = new Sprite();
			addChild(_panel);
			_panel.graphics.lineStyle(2,0x000000,1);
			_panel.graphics.beginFill(0xAAAAAA,1);
			_panel.graphics.drawRect(0,0,82,stage.stageHeight);
			_panel.graphics.endFill();
		}
		
		private function initScale():void
		{
			scalar = new Scalar();
			addChild(scalar);
			scalar.x = 25;
			scalar.y = 270;
		}
	}
	
}