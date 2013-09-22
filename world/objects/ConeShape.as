package world.objects
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import physics.PhysWorld;
	import physics.PhysConvexObject;
	import flash.geom.Point;
	
	public class ConeShape extends Sprite
	{
		var coneSprite:Sprite = new Sprite();
		var objectNum:Number;
		var world:PhysWorld;
		var objectContainer:Sprite;
		public var collisionPoints:Array;
		
		public function ConeShape():void
		{
			drawCone();
			addChild(coneSprite);
			collisionPoints = new Array(new Point(-10,10),new Point(10,10),new Point(10,-10),new Point(-10,-10));
		}
		
		public function drawCone():void
		{
			// Je weet de road cone! :D
			var g:Graphics = coneSprite.graphics;
			
			g.lineStyle(2, 0xffffff);
			g.moveTo( -10, -10);
			g.lineTo( 10, -10);
			g.lineTo(10, 10);
			g.lineTo( -10, 10);
			g.lineTo( -10, -10);
			
			g.drawCircle(0, 0, 2);
			
			g.lineStyle(1, 0xffffff);
			g.drawCircle(0, 0, 6);
		}
	}
}