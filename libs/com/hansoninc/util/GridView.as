/**
* ...
* @author Matt.Braun
* @version 0.1
*/

package com.hansoninc.util {
	
	import flash.display.*;

	public class GridView {
		
		private var clipsArray:Array = [];
		private var delta:Number;
		private var initializeObj:Object;
		
		public function GridView( clips:Array, initObj:Object ) {
			
			GridView.makeUniformGrid( clips, initObj );
			
		}
		
	public static function makeUniformGrid( clips:Array, initObj:Object = null ):void
		{ 
			if (initObj == null) {
				initObj = { direction: "x", clipsXBegin: 0, clipsYBegin: 0, clipsPerRow: 10, xSpacing: 0, ySpacing: 0 };
			};
			
			var delta:Number = 0;
			var direction:String = initObj.direction;
			var clipsXBegin:Number = initObj.clipsXBegin;
			var clipsYBegin:Number = initObj.clipsYBegin;
			var clipsPerRow:Number = initObj.clipsPerRow;
			var xSpacing:Number = initObj.xSpacing;
			var ySpacing:Number = initObj.ySpacing;
			var i:Number = 0;
			var nEndX:Number = 0;
			var nEndY:Number = 0;
			
			switch (direction) {
				case "x" :
					//track current row max height
					var currentRowHeight:Number = 0;
					nEndY = clipsYBegin;
					//Reposition elements in the grid view
					for (i = 0; i < clips.length; i++) {
						delta = i-Math.floor(i / clipsPerRow) * clipsPerRow;
						// set it to the correct place.
						nEndX = delta * (clips[i].width + xSpacing) + clipsXBegin;
						//Only Set X at the start of each row
						if (i % clipsPerRow == 0) {
							nEndY += currentRowHeight + ySpacing;
							currentRowHeight == 0;
						}
						clips[i].x = nEndX;
						clips[i].y = nEndY;
						
						//Check is current obejcts height is the tallest in this row
						if (clips[i].height > currentRowHeight) currentRowHeight = clips[i].height;
					}
					break;
				case "y" :
					//track current column max width
					var currentColumnWidth:Number = 0;
					nEndX = clipsXBegin;
					//Reposition elements in the grid view
					for (i = 0; i < clips.length; i++) {
						delta = i-Math.floor(i/clipsPerRow)*clipsPerRow;
						// set it to the correct place.
						//Only Set X at the start of each row
						if (i % clipsPerRow == 0) {
							nEndX += currentColumnWidth + xSpacing;
							currentColumnWidth = 0;
						}
						nEndY = delta * (clips[i].height + ySpacing) + clipsYBegin;
						clips[i].x = nEndX;
						clips[i].y = nEndY;
						
						//Check is current obejcts width is the widest in this column
						if (clips[i].width > currentColumnWidth) currentColumnWidth = clips[i].width;
					}
					break;
			}
			
		}
		
	}
	
}