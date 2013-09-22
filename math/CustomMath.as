package math
{
	import adobe.utils.ProductManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CustomMath
	{
		/* 
		Custom math class voor het berekenen van hoeken en afstanden omdat dat brak is in de Flash API.
		Lang leve wiskundeboeken!
		*/
		
		public static function calculateBounds(inputPoints:Array):Rectangle
		{
			var lowX:Number = 0;
			var lowY:Number = 0;
			var highY:Number = 0;
			var highX:Number = 0;
			
			for (var i:Number = 0; i < inputPoints.length; i++)
			{
				if (lowX > inputPoints[i].x)
					lowX = inputPoints[i].x;
				if (lowY > inputPoints[i].y)
					lowY = inputPoints[i].y;
				if (highX < inputPoints[i].x)
					highX = inputPoints[i].x;
				if (highY < inputPoints[i].y)
					highY = inputPoints[i].y;
			}
			
			var output:Rectangle = new Rectangle(lowX, lowY, highX - lowX, highY - lowY);
			
			return output;
		}
		
		static public function cloneArray(inputArray:Array):Array
		{
			var output:Array = new Array();
			for (var i:Number = 0; i < inputArray.length; i++)
			{
				output.push(inputArray[i]);
			}
			return output;
		}
		
		static public function numStringInArray(src:String, array:Array):Number
		{
			var output:Number = 0;
			for (var i:Number = 0; i < array.length; i++)
			{
				if (array[i] == src)
					output++;
			}
			return output;
		}
		
		static public function scalePuntOmOrigin(inPoint:Point, inOrigin:Point, scaleValue:Number):Point
		{
			var hoekOrigin:Number = Math.atan2(inPoint.y - inOrigin.y, inPoint.x - inOrigin.x);
			var afstand:Number = Point.distance(inPoint, inOrigin);
			var nieuwAfstand:Number = afstand * scaleValue;
			var nieuwPoint:Point = Point.polar(nieuwAfstand, hoekOrigin);
			return new Point(inOrigin.x + nieuwPoint.x, inOrigin.y + nieuwPoint.y);
		}
		
		static public function berekenZwaartepunt(collPoints:Array):Point
		{
			var aX:Number = 0;
			var aY:Number = 0;
			
			for (var i:Number = 0; i < collPoints.length; i++)
			{
				aX += collPoints[i].x;
				aY += collPoints[i].y;
			}
			aX = aX / collPoints.length;
			aY = aY / collPoints.length;
			return new Point(aX, aY);
		}
		
		static public function pointSubst(p1:Point, p2:Point):Point
		{
			return new Point(p1.x - p2.x, p1.y - p2.y);
		}
		
		static public function pointAdd(p1:Point, p2:Point):Point
		{
			return new Point(p1.x + p2.x, p1.y + p2.y);
		}
		
		static public function pointMult(p1:Point, multiplier:Number):Point
		{
			return new Point(p1.x * multiplier, p1.y * multiplier);
		}
		
		static public function crossProduct(p1:Point, p2:Point):Number
		{
			return p1.x * p2.y - p1.y * p2.x;
		}
		
		static public function dotProduct(p1:Point, p2:Point):Number
		{
			return p1.x * p2.x + p1.y * p2.y;
		}
		
        static public function cubicBezierToQuadratic(P0:Object, P1:Object, P2:Object, P3:Object):Array
        {
            // calculates the useful base points
            var PA:Object = getPointOnSegment(P0, P1, 3/4);
            var PB:Object = getPointOnSegment(P3, P2, 3/4);
            
            // get 1/16 of the [P3, P0] segment
            var dx:Number = (P3.x - P0.x)/16;
            var dy:Number = (P3.y - P0.y)/16;
            
            // calculates control point 1
            var Pc_1:Object = getPointOnSegment(P0, P1, 3/8);
            
            // calculates control point 2
            var Pc_2:Object = getPointOnSegment(PA, PB, 3/8);
            Pc_2.x -= dx;
            Pc_2.y -= dy;
            
            // calculates control point 3
            var Pc_3:Object = getPointOnSegment(PB, PA, 3/8);
            Pc_3.x += dx;
            Pc_3.y += dy;
            
            // calculates control point 4
            var Pc_4:Object = getPointOnSegment(P3, P2, 3/8);
            
            // calculates the 3 anchor points
            var Pa_1:Object = getMiddle(Pc_1, Pc_2);
            var Pa_2:Object = getMiddle(PA, PB);
            var Pa_3:Object = getMiddle(Pc_3, Pc_4);
            
            // draw the four quadratic subsegments
            return ([{cx:Pc_1.x, cy:Pc_1.y, ax:Pa_1.x, ay:Pa_1.y},
                    {cx:Pc_2.x, cy:Pc_2.y, ax:Pa_2.x, ay:Pa_2.y},
                    {cx:Pc_3.x, cy:Pc_3.y, ax:Pa_3.x, ay:Pa_3.y},
                    {cx:Pc_4.x, cy:Pc_4.y, ax:P3.x, ay:P3.y}]);
                        
        }
            
        static public function getMiddle(P0:Object, P1:Object):Object
        {
            return {x: ((P0.x + P1.x) / 2), y: ((P0.y + P1.y) / 2)};
        }    
		
		static public function normalizeRad(inputAngle:Number):Number
		{
			var radOutput:Number = inputAngle;
			
			while ( radOutput >= Math.PI*2 )
			{
				radOutput -= Math.PI*2;
			}
			while ( radOutput < -Math.PI*2 )
			{
				radOutput += Math.PI*2;
			}
			return radOutput;
		}
        
        static public function getPointOnSegment(P0:Object, P1:Object, ratio:Number):Object 
        {
            return {x: (P0.x + ((P1.x - P0.x) * ratio)), y: (P0.y + ((P1.y - P0.y) * ratio))};
        }
		
		public static function lineIntersection(a1:Point, a2:Point, b1:Point, b2:Point):Point
		{
			var x1:Number = a1.x, x2:Number = a2.x, x3:Number = b1.x, x4:Number = b2.x;
			var y1:Number = a1.y, y2:Number = a2.y, y3:Number = b1.y, y4:Number = b2.y;
			
			var z1:Number = (x1 -x2), z2:Number = (x3 - x4), z3:Number = (y1 - y2), z4:Number = (y3 - y4);
			
			var d:Number = z1 * z4 - z3 * z2;
			
			if (d == 0) return null;
			
			// Get x en y
			var pre:Number = (x1*y2 - y1*x2), post:Number = (x3*y4 - y3*x4);
			var x:Number = ( pre * z2 - z1 * post ) / d;
			var y:Number = ( pre * z4 - z3 * post ) / d;
 
			// Check if the x and y coordinates are within both lines
			if ( x < Math.min(x1, x2) || x > Math.max(x1, x2) || x < Math.min(x3, x4) || x > Math.max(x3, x4) ) 
				return null;
			if ( y < Math.min(y1, y2) || y > Math.max(y1, y2) || y < Math.min(y3, y4) || y > Math.max(y3, y4) ) 
				return null;

			return new Point(x, y);
		}
		
		public static function rectContainsPoint(inRect:Rectangle, inPoint:Point):Boolean
		{
			return (inPoint.x > inRect.left && inPoint.x < inRect.right && inPoint.y > inRect.top && inPoint.y < inRect.bottom);
		}
		
		public static function doBoundsIntersect(in1:Rectangle, in2:Rectangle):Boolean
		{
			return (in1.intersects(in2));
		}
		
		public static function rndTussen(num1:Number, num2:Number):Number
		{
			return num1+(Math.random()*(num2-num1)+1);
		}
		 
		public static function radNaarDeg(num:Number):Number
		{
			return num*180/Math.PI;
		}
		 
		public static function degNaarRad(num:Number):Number
		{
			return num/180*Math.PI;
		}
		 
		public static function degSin(num:Number):Number
		{
			return Math.sin(num/180*Math.PI);
		}
		 
		public static function degCos(num:Number):Number
		{
			return Math.cos(num/180*Math.PI);
		}
		 
		public static function degTan(num:Number):Number
		{
			return Math.tan(num/180*Math.PI);
		}
		 
		public static function angleTussenRad(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.atan2((y1-y2), (x1-x2));
		}
		 
		public static function angleTussenDeg(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.atan2((y1-y2), (x1-x2))*180/Math.PI;
		}
		 
		public static function afstandTussen(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return Math.sqrt(Math.pow((y1-y2),2)+ Math.pow((x1-x2),2));
		}
		
		public static function draaiPuntOmPunt(p:Point,d:Number,o:Point):Point
		{
			var np:Point = new Point();
			d = -d;
			p.x+= (0 - o.x);
			p.y+= (0 - o.y);
			np.x = (p.x * Math.cos(d * (Math.PI/180))) - (p.y * Math.sin(d * (Math.PI/180)));
			np.y = Math.sin(d * (Math.PI / 180)) * p.x + Math.cos(d * (Math.PI / 180)) * p.y;
			np.x += (0 + o.x);
			np.y += (0 + o.y);
			return np; 
		}
	}
}
