// JSON Object that will be deHydrated and reHydrated
// Color Swatches

package com.hansoninc.paintapp.colors
{
	import events.InfoEvent;
	
	import flash.display.Sprite;
	import flash.events.*;
	
	public class ColorSwatch extends Sprite
	{
		private var _color:String;
		private var _value:Number;
		public function get value():Number
		{
			return _value;
		}
		
		public function ColorSwatch(color:String,value:Number)
		{
			
			_color = color;
			_value = value;
			drawColor();
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		

		

		private function init(e:Event = null):void
		{
			addEventListener(MouseEvent.CLICK, dispatchButtonEvent)
		}
		private function destroy(e:Event = null):void
		{
			removeEventListener(MouseEvent.CLICK, dispatchButtonEvent)
		}
		public function toObject():Object
		{
			return { color: _color, value: _value };
		}
		
		public static function createFrom(object:Object):ColorSwatch
		{
			return new ColorSwatch(object.color,object.value);
		}
		
		private function drawColor():void
		{
			this.graphics.lineStyle(1,0x000000,1);
			this.graphics.beginFill(_value,1);
			this.graphics.drawRect(0,0,26,26);
			this.graphics.endFill();
		}
		
		private function dispatchButtonEvent(e:MouseEvent):void	
		{
			//dispatchEvent(new InfoEvent(PaintApp.CHANGECOLOR, { value: _value } ) );
			dispatchEvent(new Event(PaintApp.CHANGECOLOR, true) );
		}
		
	}
}