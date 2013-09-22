package world.objects
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import physics.PhysWorld;
	import physics.PhysConvexObject;
	import flash.geom.Point;
	
	public class AchieveImage extends Sprite
	{
		public function AchieveImage():void
		{
			drawImage();
		}
		
		public function drawImage():void
		{
			// Je weet de achievement image! :D
			var g:Graphics = graphics;
			graphics.drawCircle( -25, -25, 50);
			
		}
	}
}