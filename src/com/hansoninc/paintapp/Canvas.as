package com.hansoninc.paintapp
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.*;
	import flash.utils.ByteArray;
	
	public class Canvas extends Sprite
	{
		//Stage Variables
		private var _canvasBitmap:Bitmap;
		private var _lastPoint:Point;
		private var _canvas:Sprite;
		private var _drawCanvas:Sprite;
		private var _drawStyle:String;
		private var _tracker:int;
		private var _slice:Rectangle;
		private var _destPoint:Point;
		private var _transferSprite:Sprite;
		private var surface:Sprite;
		
		//Public vars
		public var bSize:uint;
		public var brushColor:Number;
		public var brushAlpha:Number  = 1;
		
		// Public constants
		//public static const MY_VAR:String = "whatever";
		
		// Private vars
		private var toolMode:String;
		
		// Private helper objects
		private var saveByteArray:ByteArray;
		private var saveFile:File;
		private var fileStream:FileStream;
		
		public function Canvas()
		// Main Drawing Surface with 2 layers.  Bitmap, and overlay Sprite.
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initSurface();
			//Makes background
			
			initCanvas();
			//Sets up drawing canvas

			setToolMode();
			//Assigns toolmode for doing different things.
		}
		
		
		private function destroy(e:Event):void
		{
			removeListeners();
		}

		private function initSurface():void
			//Surface will be light gray for drawing
		{
			surface = new Sprite();
			addChild(surface);
			surface.graphics.beginFill(0xEEEEEE);
			surface.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			surface.graphics.endFill();
		}
		
		public function initCanvas():void
		//Initialize the private invisible canvas that is a bitmap with bitmapData
		{
			_canvas = new Sprite();
			addChild(_canvas);
			_canvas.graphics.beginFill(0xEEEEEE, 1);
			_canvas.graphics.drawRect(0, 0, stage.stageWidth,stage.stageHeight);
			_canvas.alpha = 0;
			
			_canvasBitmap = new Bitmap();
			_canvasBitmap.bitmapData = new BitmapData(stage.stageWidth,stage.stageHeight, true, 0x00000000);
			addChild(_canvasBitmap);
			
			_drawCanvas = new Sprite();
			addChild(_drawCanvas);
			
			redrawCanvas();
		}
		
		/**
		 * Sets the canvas's draw mode. See PaintApp for possible values. 
		 * 
		 */		
		public function redrawCanvas():void
			//Refresher function that takes the information in the canvas down to the BITMAP
		{
			//Drawing BMP data from canvas onto surface.
			var blendMode:String = (_drawStyle == PaintApp.NORMAL) ? BlendMode.NORMAL : BlendMode.ERASE;;
			_canvasBitmap.bitmapData.draw(_drawCanvas, null, null, blendMode, null, true);

			//Removing all children incase any get built.
			for(var i:int = _drawCanvas.numChildren-1 ; i >= 0; i--)
				_drawCanvas.removeChildAt(i);
			
		}// End redrawCanvas
		
		
		// *** Function set up to assign canvas the correct drawing mode based on functions called in next section *** //
		
		public function setToolMode():void
		{
			
			switch(toolMode)
				//Assigns the correct Tool Mode (polygon,line,normal, etc...)
			{	
				case "Drawing" :
					normalMode();
					break;
				
				case "Line" :
					lineMode();
					break;
				
				case "Polygon" :
					polyMode();
					break;
				
				case "PaintBucket" : 
					fillMode();
					break;
				
				case "Cut" : 
					cutMode();
					break;
				
				default:
					normalMode();
					break;
			}
		}
		
		// ****** Functions for Drawing/Tool MODES, called from PaintApp based on toolPanel.toolButton.*  ****** //
		
		public function normalDraw():void
		{
			_drawStyle = PaintApp.NORMAL;
			toolMode = "Drawing";
			setToolMode();
		}
		
		public function eraserBrush():void
		{
			_drawStyle = PaintApp.ERASER;
			toolMode = "Drawing";
			setToolMode();
		}
		
		public function drawPoly():void
		{
			_drawStyle = PaintApp.NORMAL;
			toolMode = "Polygon";
			setToolMode();
		}
		
		public function paintBucket():void
		{
			toolMode = "PaintBucket";
			setToolMode();
		}
		
		
		public function drawLine():void
		{
			_drawStyle = PaintApp.NORMAL;
			toolMode = "Line";
			setToolMode();
		}
		
		public function cut():void
		{
			_drawStyle = PaintApp.NORMAL;
			toolMode = "Cut";
			setToolMode();
		}
		
		// ****** END functions for Drawing/Tool MODES ***** //
		
		public function saveCanvas():void
		{
			redrawCanvas();
			
			//pngenc = new PNGEncoder();
			saveByteArray = PNGEncoder.encode(_canvasBitmap.bitmapData);
			saveFile = File.desktopDirectory.resolvePath("snapshot.jpg");
			
			fileStream = new FileStream();
			//open file in write mode
			fileStream.open(saveFile,FileMode.WRITE);
			//write bytes from the byte array
			fileStream.writeBytes(saveByteArray);	
			//close the file
			fileStream.close();
		}
		
		//************************ BEGIN DRAWING MODES *************************** //
		
		//
		// Normal Drawing Mode
		//
		
		public function normalMode():void
		{
			removeListeners();
			_drawCanvas.graphics.clear();
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, beginDraw);
			_canvas.addEventListener(MouseEvent.MOUSE_UP, endDraw);
		}
		public function beginDraw(e:MouseEvent):void
		{
			_lastPoint = new Point(mouseX, mouseY);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, doDraw);
			
		}// End drawCanvas
		
		public function doDraw(e:MouseEvent):void
		{
	
			if (!e.buttonDown) {
				endDraw(e);
				return;
			}
			_drawCanvas.graphics.lineStyle(bSize, brushColor, brushAlpha);
			_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
			_drawCanvas.graphics.lineTo(mouseX, mouseY);
			_lastPoint = new Point(mouseX, mouseY);
			
			redrawCanvas();
			_drawCanvas.graphics.clear();
			
		}// End doDraw
		
		public function endDraw(e:MouseEvent):void
		{
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, doDraw);
		}// End endDraw
	
		
		//
		// POLYGON FUNCTIONS
		//
		
		public function polyMode():void
		{
			removeListeners();
			_drawCanvas.graphics.clear();
			stage.addEventListener(MouseEvent.CLICK, beginPoly);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, terminatePoly);
		}
		
		private function beginPoly(e:MouseEvent):void
		{	
			if (mouseX > 84)  // If mouse is not on the toolPanel
			{
				_drawCanvas.graphics.lineStyle(bSize, brushColor,brushAlpha);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, updatePoly);
				
				if (_lastPoint != null)
				{
					_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
					_drawCanvas.graphics.lineTo(mouseX, mouseY);
					redrawCanvas();
					_lastPoint = new Point(mouseX, mouseY);
						
					if (_tracker == 1)
						//Counting to see if this is the 2nd click to make the line
						//If it is, clear graphics and reset click counter.
						// This was done to eliminate problem where Line was not able to be 
						// drawn to a previous line, until clear had been called.
						{
							_drawCanvas.graphics.clear();
							_tracker = 0;
						}
					else
					{
							_tracker++;
					}
				}
				else 
					//Setting Initial Click if no other tools have been used yet.
				{
					_lastPoint = new Point(mouseX, mouseY);
				}	
			}// End IF statement for if you are clicking on the Stage
		}//End function BeginPoly

		
		private function terminatePoly(e:MouseEvent):void
			//Right Click termination in order to finish desired polygon and start a new one.
		{
			removeListeners();
			_drawCanvas.graphics.clear();
			polyMode();
		}
		
		private function updatePoly(e:MouseEvent):void
			//Update Line being drawn.
		{
			if(_lastPoint == null)
				return;
			if(e.buttonDown)
				return;
			_drawCanvas.graphics.clear();
			_drawCanvas.graphics.lineStyle(bSize, brushColor,brushAlpha);
			_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
			_drawCanvas.graphics.lineTo(mouseX, mouseY);
		}
		
		
		//
		//Line Functions
		//
		
		/**
		 * 
		 * @param mode werwer
		 * @return  wer
		 * 
		 */
		public function lineMode():void
		{
			removeListeners();
			_drawCanvas.graphics.clear();
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, beginLine);
			_canvas.addEventListener(MouseEvent.MOUSE_UP, endLine);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, updateLine);
			
		}
		private function beginLine(e:MouseEvent):void
		{
			_lastPoint = new Point(mouseX, mouseY);
			_drawCanvas.graphics.lineStyle(bSize, brushColor,brushAlpha,false,"normal",CapsStyle.NONE,null,3);
			_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
		}	
		private function endLine(e:MouseEvent):void
		{
			redrawCanvas();
			_drawCanvas.graphics.clear();
		}
		private function updateLine(e:MouseEvent):void
		{
			if(_lastPoint == null)
				return;
			if (!e.buttonDown) {
				endLine(e);
				return;
			}
			_drawCanvas.graphics.clear();
			_drawCanvas.graphics.lineStyle(bSize, brushColor,brushAlpha,false,"normal",CapsStyle.NONE,null,3);
			_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
			_drawCanvas.graphics.lineTo(mouseX, mouseY);
		}
		
		//
		// Paintbucket functions
		//
		
		private function fillMode():void
		{
			removeListeners();
			_drawCanvas.graphics.clear();
			_canvas.addEventListener(MouseEvent.CLICK, beginFill);
		}
		private function beginFill(e:MouseEvent):void
		{
			var xx:Number=e.localX;
			var yy:Number=e.localY;
			var tempColor:Number = ((0xFF * brushAlpha) << 24) + brushColor;
			//Transformed old RGB color into ARGB color.
			_canvasBitmap.bitmapData.floodFill(xx,yy,tempColor);

		}
		
		// 
		// Cut/Paste Functions
		//
		
		private function cutMode():void
		{
			removeListeners();
			_drawCanvas.graphics.clear();
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, beginSlice);
			_canvas.addEventListener(MouseEvent.MOUSE_UP, endSlice);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, updateSlice);
			_canvas.addEventListener(MouseEvent.RIGHT_CLICK, terminateCut);
		}
		
		private function beginSlice(e:MouseEvent):void
		{
			_lastPoint = new Point(mouseX, mouseY);
			_drawCanvas.graphics.lineStyle(1,0x000000,1);
			_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
		}
		
		private function updateSlice(e:MouseEvent):void
			//Function to display the cutting Box
		{
			if(_lastPoint == null)
				return;
			if (!e.buttonDown) {
				endSlice(e);
				return;
			}
			_drawCanvas.graphics.clear();
			_drawCanvas.graphics.lineStyle(1,0x000000,1);
			_drawCanvas.graphics.moveTo(_lastPoint.x, _lastPoint.y);
			makeCut();
		}
		
		private function makeCut():void
			//Function Enables all 4 rectangle drawing methods based on initial point.
		{
			var tmpSlice:Rectangle = getCorrectedSliceRect();
			_drawCanvas.graphics.drawRect(tmpSlice.top, tmpSlice.left, tmpSlice.width, tmpSlice.height);
		}
		
		private function endSlice(e:MouseEvent):void
		{
			if(_lastPoint == null)
				return;
			_slice = getCorrectedSliceRect();
			trace("Saving slice:", _slice);
			
			//Begin tranfer Functions to get the selected cut into the desired location.
			transferSlice();
		}
		
		private function getCorrectedSliceRect():Rectangle {
			// TODO: Unbreak this
			trace(mouseY, _lastPoint.y);
			trace(mouseX, _lastPoint.x);
			var top:Number = Math.min(mouseY, _lastPoint.y);
			var left:Number = Math.min(mouseX, _lastPoint.x);
			var tmpRect:Rectangle = new Rectangle(top, left, Math.abs(mouseX - _lastPoint.x), Math.abs(mouseY - _lastPoint.y));
			_drawCanvas.graphics.lineStyle(1, 0xFF0000);
			_drawCanvas.graphics.drawRect(tmpRect.x, tmpRect.y, tmpRect.width, tmpRect.height);
			_drawCanvas.graphics.drawRect(0, 0, 10, 10);
			return tmpRect;
			
		}
		
		// Slice Transfer Functions ( Inside Cut/Paste )
		
		private function transferSlice():void
		{
			//Remove Slection of slice listeners.
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, beginSlice);
			_canvas.removeEventListener(MouseEvent.MOUSE_UP, endSlice);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, updateSlice);
			
	
			//Add new event listeners for the dragging phase.
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, beginSliceDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, endSliceDrag);

		}
		
		private function beginSliceDrag(e:MouseEvent):void
		{
			
			trace("Transferring slice from:", _slice);
			// Make a new Bitmap (transferBMP) with DATA as slice variables
			// Then copy the pixels of the selection area to the newly created bitmap.
			// Add the bitmap to a transferSprite and use StartDrag.
			_drawCanvas.graphics.lineStyle(1, 0xFF0000);
			_drawCanvas.graphics.drawRect(_slice.x, _slice.y, _slice.width, _slice.height);
			var transferData:BitmapData = new BitmapData(Math.abs(_slice.width),Math.abs(_slice.height),true,0);
			var transferBMP:Bitmap = new Bitmap(transferData);
			transferBMP.bitmapData.copyPixels(_canvasBitmap.bitmapData,_slice, new Point());
			_transferSprite = new Sprite();
			_drawCanvas.addChild(_transferSprite)
			_transferSprite.addChild(transferBMP);
			_transferSprite.x = _slice.x;
			_transferSprite.y = _slice.y;
			_transferSprite.addChild(transferBMP);
			
			_transferSprite.startDrag();
			
		}
		/**
		 * Ends a slide
		 * @param e
		 * 
		 */		
		private function endSliceDrag(e:MouseEvent):void
		{
			//End the Cut/Paste method, making sure to redrawCanvas to make permanent.
			stopDrag();
			_drawCanvas.graphics.clear();
			redrawCanvas();
		}
		
		
		private function terminateCut(e:MouseEvent):void
			//Right Click termination in order to finish desired Cut/Paste and start a new one.
		{
			_drawCanvas.graphics.clear();
			removeListeners();
			cutMode();
		}
		
		
		
		// ************************ END DRAWING MODES *************************** //
		
		//
		//Remove EventListeners
		//
		
		private function removeListeners():void
		{
			_lastPoint = null;
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, beginDraw);
			_canvas.removeEventListener(MouseEvent.MOUSE_UP, endDraw);
			
			stage.removeEventListener(MouseEvent.CLICK, beginPoly);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, terminatePoly);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePoly);
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, beginLine);
			_canvas.removeEventListener(MouseEvent.MOUSE_UP, endLine);
			_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, updateLine);
			
			_canvas.removeEventListener(MouseEvent.CLICK, beginFill);
			
			_canvas.removeEventListener(MouseEvent.MOUSE_DOWN, beginSliceDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endSliceDrag);
			_canvas.removeEventListener(MouseEvent.RIGHT_CLICK, terminateCut);
		}
		
	}// End Canvas Constructor
	
}// End Package