package world.effects
{	
	import flash.display.Sprite;
	import world.effects.Particle;
	
	public class Container extends Sprite
	{	
		/// Constructor Container
		public function Container():void
		{
		}
		
		/// Update alle children van deze container
		public function update():void
		{
			for (var i:Number = 0; i < this.numChildren; i++)
			{
				Particle(this.getChildAt(i)).update();
			}
		}
		
	}
}