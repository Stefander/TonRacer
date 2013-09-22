package physics
{
	import flash.geom.Point;
	
	public class CollisionData
	{
		public var impactPoint:Point;
		public var pA:Point;
		public var pB:Point;
		public var pC:Point;
		public var intersectionPoint:Point;
		public var intersectionSpace:Point;
		public var impactNormal:Number;
		public var surfaceNormal:Number;
		
		public function CollisionData(iP:Point, A:Point, B:Point, C:Point, interP:Point, impactAngle:Number, iSpace:Point):void
		{
			impactPoint = iP;
			intersectionPoint = interP;
			pA = A;
			impactNormal = impactAngle;
			intersectionSpace = iSpace;
			pB = B;
			pC = C;
		}
		
	}
}