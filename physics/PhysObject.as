package physics
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import physics.PhysObjectType;

	public class PhysObject
	{
		private var mMass:Number = 0;
		private var mCenterOfMass:Number = new Point(0,0);
		private var mCollisionPoints:Array;
		private var mLinearVelocity:Point = new Point(0,0);
		private var mAngularVelocity:Point = new Point(0,0);
		private var mRotation:Number = 0;
		private var mShapeType:PhysObjectType;
		
		public function PhysObject():void
		{
			
		}
	}
	
}