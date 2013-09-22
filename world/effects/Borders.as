package world.effects
{	
	// Imports
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class Borders extends Sprite
	{	
		private var borderMc:Sprite = new Sprite();
		private var edgeMc:Sprite = new Sprite();
		
		// VARIABLES
		private var edgeWidth:Number = 150;
		private var currentPos:Number = 0;
		private var speed:Number = 10;
		private var topBorder:Number = 40;
		
		public function Borders():void
		{
			borderMc.graphics.lineStyle(6, 0x526600);
			borderMc.graphics.moveTo( -10, topBorder);
			borderMc.graphics.lineTo(680, topBorder);
			borderMc.graphics.moveTo( -10, 330);
			borderMc.graphics.lineTo(680, 330);
			
			borderMc.graphics.lineStyle(2, 0xffffff);
			borderMc.graphics.moveTo( -10, topBorder);
			borderMc.graphics.lineTo(680, topBorder);
			borderMc.graphics.moveTo( -10, 330);
			borderMc.graphics.lineTo(680, 330);
			
			updateBorders();
			// Glow filter over de auto heen voor de looks
			//var glow:GlowFilter = new GlowFilter(0xccff00,1,5,5,2,1);
			//bordersMc.filters = [glow];
			addChild(edgeMc);
			addChild(borderMc);
		}
				
		public function updateBorders():void
		{
			if (currentPos < edgeWidth)
			{
				edgeMc.graphics.clear();
				var g:Graphics = edgeMc.graphics;
				
				g.lineStyle(5, 0x526600);
				for (var i:Number = 0; i < 900 / edgeWidth; i++)
				{
					var currX:Number = i * edgeWidth - currentPos;
					var xDistortion:Number = currX+(currX - (900 / 2))*0.5;
					g.moveTo(currX, topBorder);
					g.lineTo(xDistortion, -10);
					
					g.moveTo(currX, 330);
					g.lineTo(xDistortion, 370);
					
					// Teken de strepen op het scherm
					if (i / 2 == Math.round(i / 2))
						g.drawRect(currX, 175, edgeWidth, 10);
				}
				
				g.lineStyle(1, 0xffffff);
				for (var j:Number = 0; j < 900 / edgeWidth; j++)
				{
					var currX2:Number = j * edgeWidth - currentPos;
					var xDistortion2:Number = currX2+(currX2 - (900 / 2))*0.5;
					g.moveTo(currX2, topBorder);
					g.lineTo(xDistortion2, -10);
					
					g.moveTo(currX2, 330);
					g.lineTo(xDistortion2, 370);
					
					// Teken de dunne strepen op het scherm
					if (j / 2 == Math.round(j / 2))
						g.drawRect(currX2, 175, edgeWidth, 10);
				}
			}
			else
				currentPos-=edgeWidth*2;
			
			currentPos+=speed;
		}
	}
}