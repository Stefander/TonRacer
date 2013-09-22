package world.effects
{	
	public class GridExplosion
	{	
		// PRIVATE
		private var speed:Number = 10;								// Snelheid waarmee de explosie expandt
		private var dispFadeSpeed:Number = .5;						// Snelheid waarmee de displacement wegfade
		private var dispFrames:Number = dispAlpha / dispFadeSpeed;	// Aantal frames voor de fade
		private var expIntensity:Number;
		
		// PROTECTED
		
		// PUBLIC
		public var expRadius:Number = 25;							// Huidige radius
		public var dispAlpha:Number = 30;							// Intensiteit van de displacement
		public var xPos:Number;										// De X positie van de explosie
		public var yPos:Number;										// De Y positie van de explosie
		public var activeExp:Boolean = true;						// Is de explosie momenteel actief?

		/// Constructor GridExplosion
		public function GridExplosion(inX:Number,inY:Number,intensity:Number):void
		{
			// Declareer de X en Y positie van de explosie
			xPos = inX;
			yPos = inY;
			expIntensity = intensity;
		}
		
		/// Update de explosie instance
		public function updateExplosion():void
		{
			// Update de waardes
			if(expRadius<expIntensity-dispFrames)
				expRadius+=speed;
			else
			{	
				// Tijdens het faden wordt de explosie evengoed langzaam groter
				expRadius ++;
				
				// Als hij nog zichtbaar is, fade hem weg
				if(dispAlpha > 0)
					// Maak de explosie minder intensief
					dispAlpha-=dispFadeSpeed;
				else
					// Maak de explosie inactief (deze wordt automatisch verwijderd door de Grid-class)
					activeExp = false;
			}
		}
		
	}
}