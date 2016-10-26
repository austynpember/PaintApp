
package com.hansoninc.paintapp.colors
{
	import com.adobe.serialization.json.*;
	import com.hansoninc.util.GridView;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	public class ColorPallet extends Sprite
	{
		private var panel:Sprite;
		
		public function ColorPallet(){
			//addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			initPanel();
			loadJSON();
		}
		
		private function init (e:Event = null):void
		{
			
		}
		
		private function initPanel():void
		{
			panel = new Sprite();
			addChild(panel);
			panel.graphics.lineStyle(2,0x000000,1);
			panel.graphics.beginFill(0xAAAAAA,1);
			panel.graphics.drawRect(0,0,82,82);
			panel.graphics.endFill();
		}
		
		private function loadJSON():void
		{
			var colorLoader:URLLoader = new URLLoader();
			colorLoader.load(new URLRequest("colors.JSON"));
			colorLoader.addEventListener(Event.COMPLETE, parseJSON);
			
		}	
		private function parseJSON(e:Event):void
		{
			(e.target as URLLoader).removeEventListener(Event.COMPLETE, parseJSON);
			var objsDehydrated:String = (e.target as URLLoader).data as String;
			var objsRehydrated:Array = JSON.decode(objsDehydrated);
			createButtonArray(objsRehydrated);
		
		}

		private function createButtonArray(arr:Array):void 
		{
			
			/*for (var nextKey:* in arr) {
				trace(nextKey) // would return "name"
				trace(arr[nextKey]) // would return "dave"
			}
			
			for each (var nextVal:* in arr) {
				trace(nextKey) // returns "dave"
			}
			 
			*/
			var swatchesArray:Array = [];
			for each (var nextObject:Object in arr)
			{
				var tempSwatch:ColorSwatch = ColorSwatch.createFrom(nextObject);
				addChild(tempSwatch);
				swatchesArray.push(tempSwatch);
				
			}
			
			GridView.makeUniformGrid(swatchesArray, { direction: "x", clipsXBegin: 0, clipsYBegin: 0, clipsPerRow: 3, xSpacing: 0, ySpacing: 0 });
		}
	}// End ColorPallet Class

}
