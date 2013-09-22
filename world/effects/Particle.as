package world.effects
{	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Particle extends Sprite
	{	
		// PUBLIC
		public var size:Number=Math.random()*2+1;
		public var rotationSpeed:Number; // Optional
		public var xSpeed:Number;
		public var angle:Number;
		public var ySpeed:Number;
		
		// PRIVATE
		private var mLifeTime:Number = Math.random()*30+5;

		/// Constructor GridExplosion
		public function Particle(parX:Number,parY:Number,velocity:Number):void
		{
			// Bereken de X en Y speed van de particle
			var tempSpeed:Point = Point.polar(velocity/1.5, Math.random()*Math.PI*2);//angle-Math.PI+((Math.random()*Math.PI)-Math.PI/2));
			xSpeed = tempSpeed.x;
			ySpeed = tempSpeed.y;
			this.x = parX+((Math.random()*5)-2.5);
			this.y = parY+((Math.random()*5)-2.5);
			
			graphics.beginFill(0xffffff, 1);
			graphics.drawCircle( -size / 2, -size / 2, size);
			graphics.endFill();
		}
		
		public function remove():void
		{
			Sprite(parent).removeChild(this);
		}
		
		/// Update de explosie instance
		public function update():void
		{
			this.alpha -= (1 / mLifeTime);
			
			if(this.x+xSpeed < 640 && this.x+xSpeed > 0)
				this.x += xSpeed;
			else if(this.y+ySpeed < 360 && this.y+ySpeed > 0)
				this.y += ySpeed;
			else
				remove();
				
			if (this.alpha <= 0)
				remove();
				
		
			//this.rotation += rotationSpeed;
			
		/*	if (this.alpha <= 0)
				Sprite(parent).removeChild(this);*/
		}
		
	}
}