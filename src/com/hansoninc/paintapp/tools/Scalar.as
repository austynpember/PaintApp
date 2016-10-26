package com.hansoninc.paintapp.tools
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import events.InfoEvent;
	
	public class Scalar extends Sprite
	{
		private var container:Sprite;
		private var back:Sprite;
		private var scalar:Sprite;
		private var rect:Rectangle;
		
		public var currentPos:int; 
		//private var 
		
		public function Scalar()
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function init(e:Event = null):void
		{
			//Sprite container for scaling tool.
			container = this;
			
			//Backdrop box for scaling
			back = new Sprite();
			container.addChild(back);
			back.graphics.lineStyle(3,0x000000,1)
			back.graphics.beginFill(0x999999);
			back.graphics.drawRect(0,0,30,80);
			back.graphics.endFill();
			back.graphics.beginFill(0x333333);
			back.graphics.drawRect(12,10,6,60);
			back.graphics.endFill();
			
			//Scaling brush size tool
			scalar = new Sprite();
			container.addChild(scalar);
			scalar.graphics.lineStyle(3,0x000000,1)
			scalar.graphics.beginFill(0xAAAAAA);
			scalar.graphics.drawRect(5,5,20,10);
			scalar.graphics.endFill();
			
			rect = new Rectangle(0,0,0,60);
			
			scalar.addEventListener(MouseEvent.MOUSE_DOWN, scalarMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, scalarMouseUp);

		}
		
		private function destroy(e:Event = null):void
		{
			scalar.removeEventListener(MouseEvent.MOUSE_DOWN, scalarMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, scalarMouseUp);
		}
		//Scaler Button Mouse Commands
		
		private function scalarMouseDown(e:MouseEvent):void
		{
			scalar.startDrag(false,rect);
		}
		
		private function scalarMouseUp(event:MouseEvent):void
		{
			scalar.stopDrag();
			dispatchEvent(new InfoEvent(PaintApp.CHANGE_BRUSH_SIZE, { brushSize: getBsize() }));
		}	
		
		public function getBsize ():int
		{
			var currentPos:int = new int(scalar.y + 1);
			return currentPos;
		}

		
	}// End class Scalar
}