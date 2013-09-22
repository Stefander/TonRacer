package world.effects
{	
	import flash.display.Sprite;
	import flash.geom.Point;
	import fonts.SciFont;
	import math.CustomMath;
	
	public class DancingLine extends Sprite
	{	
		// PRIVATE
		private var controlPoints:Array = new Array();		// De control points
		private var connectPoints:Array = new Array();		// De tussenliggende punten
		private var targetPoints:Array = new Array();		// Array met de target transforms voor de Y positie van de controlpoints
		private var lineWidth:Number = 600;					// Breedte van de lijn
		private var heightVar:Number = 30;					// De variabele hoogte (*2, naar boven en beneden)
		private var controlNum:Number = 4;//7;				// Aantal control points
		private var lineSprite:Sprite = new Sprite();		// Sprite waarop getekend moet worden
		private var speed:Number = 0.010;					// Snelheid van de lijnen
		private var ySnelheid:Number = 0;					// Huidige ysnelheid
		private var acceleration:Number = 0.5;				// Acceleratie
		public var lineActive:Boolean = true;				// Activatie van de lijn
		private var mColor:uint;
		private var mWeight:Number;
		
		/// Constructor DancingLine
		public function DancingLine(weight:Number,color:uint):void
		{
			initPoints();
			//drawPoints();
			drawLines(weight, color);
			mWeight = weight;
			mColor = color;
		}
		
		public function initPoints():void
		{
			for (var i:Number = 0; i <= controlNum; i++)
			{
				controlPoints.push(new Point(i * (lineWidth / (controlNum - 1)), 0));
				targetPoints.push(CustomMath.rndTussen(-heightVar,heightVar));
				
				if(i<controlNum)
					connectPoints.push(new Point(i * (lineWidth / (controlNum - 1)) + ((lineWidth / (controlNum - 1)) / 2), 0));
			}
		}
		
		public function drawPoints():void
		{	
			var ctrlPoint:Sprite;
			var pointMc:Sprite;
			var tempPoint:Sprite;
			
			for (var i:Number = 0; i < controlPoints.length; i++)
			{
				ctrlPoint = new Sprite();
				pointMc = SciFont.write(".", 0xffffff, 30, 30);
				ctrlPoint.addChild(pointMc);
				pointMc.x -= pointMc.width / 2+3;
				pointMc.y -= pointMc.height / 2+22;
				ctrlPoint.x = controlPoints[i].x;
				ctrlPoint.y = controlPoints[i].y;
				trace("ctrl: " + controlPoints[i]);
				addChild(ctrlPoint);
			}
			
			for (var j:Number = 0; j < connectPoints.length; j++)
			{
				ctrlPoint = new Sprite();
				pointMc = SciFont.write(".", 0xffffff, 30, 30);
				ctrlPoint.addChild(pointMc);
				pointMc.scaleX = 0.25;
				pointMc.scaleY = 0.25;
				pointMc.x -= pointMc.width / 2;
				pointMc.y -= pointMc.height / 2+5;
				ctrlPoint.x = connectPoints[j].x;
				ctrlPoint.y = connectPoints[j].y;
				trace("ctrl: " + connectPoints[j]);
				addChild(ctrlPoint);
			}
			
		}
		
		public function turnOff():void
		{
			lineActive = false;
			for (var i:Number = 0; i < targetPoints.length; i++)
			{
				targetPoints[i] = 0;
			}
		}
		
		public function turnOn():void
		{
			lineActive = true;
			for (var i:Number = 0; i < targetPoints.length; i++)
			{
				targetPoints[i] = CustomMath.rndTussen( -heightVar, heightVar);
			}			
		}
		
		public function drawLines(weight:Number,color:uint):void
		{			
			var xCurveOffset:Number = 60;
			// Bereken connect points
			for (var p:Number = 0; p < connectPoints.length; p++)
			{
				var dY:Number = (controlPoints[p].y - controlPoints[p + 1].y)/2;
				connectPoints[p].y = controlPoints[p].y - dY;
			}
			
			lineSprite.graphics.clear();
			lineSprite.graphics.lineStyle(weight, color);
			lineSprite.graphics.moveTo(controlPoints[0].x, controlPoints[0].y);
			lineSprite.graphics.curveTo(connectPoints[0].x-xCurveOffset, controlPoints[0].y, connectPoints[0].x, connectPoints[0].y);
			
			for (var i:Number = 1; i < controlPoints.length; i++)
			{
					lineSprite.graphics.curveTo(connectPoints[i-1].x+xCurveOffset, controlPoints[i].y, controlPoints[i].x, controlPoints[i].y);
					
					if (i < controlPoints.length - 1)
						lineSprite.graphics.curveTo(connectPoints[i].x-xCurveOffset, controlPoints[i].y, connectPoints[i].x, connectPoints[i].y);
			}
			
			addChild(lineSprite);
		}
		
		public function update():void
		{
			for (var i:Number = 0; i < controlPoints.length; i++)
			{
				var dY:Number = (targetPoints[i] - controlPoints[i].y);
				
					if (((dY < 0 && dY > -1) || (dY > 0 && dY < 1)) && lineActive)
						targetPoints[i] = CustomMath.rndTussen(-heightVar, heightVar);
					else
					{
						ySnelheid = (lineActive == false) ? 4 : (ySnelheid < 1) ? ySnelheid+acceleration : 1;
						controlPoints[i].y += ySnelheid * dY * speed;
					}
			}
			
			drawLines(mWeight,mColor);
		}
	}
}