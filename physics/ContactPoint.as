package physics
{
	import flash.geom.Point;
	import physics.PhysConvexObject;
	public class ContactPoint
	{
		public var impactPoint:Point;
		public var velocity1:Point;
		public var velocity2:Point;
		public var normal:Number;
		public var intersectPoint:Point;
		public var body1Name:String;
		public var body2Name:String;
		
		public function ContactPoint(ip:Point,p:Point,n:Number,v1:Point,v2:Point,b1name:String,b2name:String):void
		{
			impactPoint = ip;
			velocity1 = v1;
			velocity2 = v2;
			intersectPoint = p;
			normal = n;
			body1Name = b1name;
			body2Name = b2name;
		}
		
		public static function isBodyInList(list:Array, bodyName:String):Boolean
		{
			var output:Boolean = false;
			for (var i:Number = 0; i < list.length; i++)
			{
				if (bodyName == list[i].body2Name)
				{
					output = true;
					break;
				}
			}
			
			return output;
		}
		
		public static function isPointInList(list:Array, collPoint:Point):Boolean
		{
			var output:Boolean = false;
			for (var i:Number = 0; i < list.length; i++)
			{
				if (list[i].impactPoint.x == collPoint.x && list[i].impactPoint.y == collPoint.y)
				{
					output = true;
					break;
				}
			}
			
			return output;
		}
	}
}