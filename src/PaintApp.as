// This is the main controller for the PaintApp Program.
// Program written by Austyn Pember.

package
{
	import com.adobe.serialization.json.*;
	import com.hansoninc.paintapp.Canvas;
	import com.hansoninc.paintapp.tools.ToolPanel;
	import com.hansoninc.paintapp.colors.ColorSwatch;
	
	import events.InfoEvent;
	
	import flash.display.*;
	import flash.events.*;
	
	public class PaintApp extends Sprite
	{
		// Symbols on stage
		public var canvas:Canvas;
		public var toolPanel:ToolPanel;
		
		// Internal variables		
		private static var _mode:String;
		public static function get mode():String {
			return _mode;
		}
		
		public static function set mode(value:String):void {
			_mode = value;
		}
		
		// Public constants
		public static var NORMAL:String = "Normal";
		public static var ERASER:String = "Eraser";
		public static var POLYGON:String = "Polygon";
		public static var LINE:String = "Line";
		public static var CHANGECOLOR:String = "ChangeColor";
		public static var CHANGE_BRUSH_SIZE:String = "ChangeBrushSize";
		public static var PAINTBUCKET:String = "PaintBucket";
		public static var CUT:String = "Cut";
		public static var SAVE:String = "Save";
		
		public function PaintApp()
		// Main
		{
			//Setting Stage
			this.stage.nativeWindow.visible = true;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Init and destroy methods to kickoff and terminate in case of mem leak.
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
		}

		private function init (e:Event = null):void
		// Kickoff
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			canvas = new Canvas();
			addChild(canvas);
			
			toolPanel = new ToolPanel();
			addChild(toolPanel);
			
			//Add Listeners to listen for called string... then initiate function with given call.
			addEventListener(PaintApp.NORMAL, drawMode);
			addEventListener(PaintApp.ERASER, drawMode);
			addEventListener(PaintApp.POLYGON, drawMode);
			addEventListener(PaintApp.LINE, drawMode);
			addEventListener(PaintApp.PAINTBUCKET, drawMode);
			addEventListener(PaintApp.CUT, drawMode);
			addEventListener(PaintApp.SAVE, drawMode);
			addEventListener(PaintApp.CHANGECOLOR, changeColor);
			addEventListener(PaintApp.CHANGE_BRUSH_SIZE, changeBrushSize);
		}
		
		private function destroy (e:Event = null):void
		{
			removeEventListener(PaintApp.NORMAL, drawMode);
			removeEventListener(PaintApp.ERASER, drawMode);
			removeEventListener(PaintApp.POLYGON, drawMode);
			removeEventListener(PaintApp.LINE, drawMode);
			removeEventListener(PaintApp.PAINTBUCKET, drawMode);
			removeEventListener(PaintApp.CUT, drawMode);
			removeEventListener(PaintApp.SAVE, drawMode);
			removeEventListener(PaintApp.CHANGECOLOR, changeColor);
			removeEventListener(PaintApp.CHANGE_BRUSH_SIZE, changeBrushSize);
		}
		
		public function drawMode (e:Event):void
			//Function that gets called based on a toolButton click
			//Decides based on "action" of clicked button which function to call
			//inside of the Canvas class.
		{
			var type:String = new String(e.target.action);
			
			switch(type)
			{
				case "Normal":
				canvas.normalDraw();
				break;
				
				case "Eraser":
				canvas.eraserBrush();
				break;
				
				case "Polygon":
				canvas.drawPoly();
				break;
				
				case "Line":
				canvas.drawLine();
				break;
				
				case "PaintBucket":
				canvas.paintBucket();
				break;
				
				case "Cut":
				canvas.cut();
				break;
				
				case "Save":
				canvas.saveCanvas();
				break;
				
			}
		}	// End drawMode
		
		public function changeColor (e:Event):void
			//Function using an InfoEvent listening for a certain color from colorPallet.collorSwatch to be clicked.
			// Then changes canvas.brushColor to that 0xHEX value. (FROM JSON FILE)
		{
			canvas.brushColor = (e.target as ColorSwatch).value //e.data.value;	
		}
		
		public function changeBrushSize(e:InfoEvent):void {
			canvas.bSize = e.data.brushSize;
		}
		
	}// End PaintApp
}