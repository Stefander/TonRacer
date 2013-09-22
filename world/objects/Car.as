package world.objects
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import svg.SVGFile;
	
	public class Car
	{
		private var mCarName:String;
		private var mVisualData;
		private var mSelData:Sprite;
		private var mPlayable:Boolean;
		
		private var mColor:uint;
		private var mPhysData:Array;
		
		private var mScale:Number;
		
		public function Car(carName:String,carVisualData:*,carSelectionData:Sprite,carPlayable:Boolean,carPhysData:Array,carColor:uint):void
		{
			mColor = carColor;
			mCarName = carName;
			mVisualData = carVisualData;
			
			if (mVisualData is SVGFile)
				SVGFile(mVisualData).pleaseUpdate(this);
				
			mSelData = carSelectionData;
			mPlayable = carPlayable;
			
			if (carPhysData.length != 0)
				mPhysData = carPhysData;
			else
				mPhysData = new Array();
		}
		
		public function getScale():Number					{	return mScale; 						}
		public function setScale(newScale:Number):void		{	mScale =  newScale;					}
		public function getVisualData():Sprite				{	return mVisualData;					}
		public function getSelectionData():Sprite			{	return mSelData;					}
		public function getCarName():String					{	return mCarName;					}
		public function getPlayable():Boolean				{	return mPlayable;					}
		public function getColor():uint						{	return mColor;						}
		public function getPhysData():Array					{	return mPhysData;					}
		public function setPlayable(toggle:Boolean):void	{	mPlayable = toggle;					}
		public function setPhysData(physData:Array):void	{	mPhysData = physData;				}
	}
}