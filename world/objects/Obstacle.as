package world.objects
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import svg.SVGFile;
	import physics.PhysWorld;
	import physics.PhysConvexObject;
	import world.objects.ConeShape;
	import flash.filters.GlowFilter;
	
	public class Obstacle extends Sprite
	{
		private var mObstacleName:String;
		private var mVisualData;
		private var mColor:uint;
		private var mPhysData:Array;
		private var mMass:Number;
		private var mScale:Number;
		private var mWorld:PhysWorld;
		private var mPhysInstance:PhysConvexObject;
		
		public function Obstacle(obstacleName:String,obstacleVisualData:*,obstacleMass:Number,obPhysData:Array,obstacleColor:uint):void
		{
			mColor = obstacleColor;
			mObstacleName = obstacleName;
			mVisualData = obstacleVisualData;
			
			if (mVisualData is SVGFile)
				SVGFile(mVisualData).pleaseUpdate(this);
			
			addChild(Sprite(mVisualData));
			mMass = obstacleMass;
			
			if (obPhysData.length != 0)
				mPhysData = obPhysData;
			else
				mPhysData = new Array();
				
			mVisualData.filters = [new GlowFilter(obstacleColor, 1, 7, 7, 2)];
		}
		
		public function getScale():Number					{	return mScale; 						}
		public function getVisualData():Sprite				{	if (mVisualData is SVGFile)
																	return mVisualData;
																else
																	return new ConeShape(); 		}
		public function getMass():Number					{	return mMass;						}
		public function getObstacleName():String			{	return mObstacleName;				}
		public function getColor():uint						{	return mColor;						}
		public function getPhysData():Array					{	return mPhysData;					}
		public function setScale(newScale:Number):void		{	mScale =  newScale;					}
		public function setPhysData(physData:Array):void	{	mPhysData = physData;				}
		public function setWorld(world:PhysWorld):void		{	mWorld = world;						}
		public function setPhysInstance(world:PhysWorld, iName:String):void	{	mPhysInstance = 
																world.getConvexBody(iName);			}
		
		/// Pas aanroepen als de physInstance er is, anders error jeweetzelluf
		public function update():void
		{
			mVisualData.x = mPhysInstance.getPosition().x;
			mVisualData.y = mPhysInstance.getPosition().y;
			mVisualData.rotation = -mPhysInstance.getAngle();
		}
	}
}