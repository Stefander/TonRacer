package world.gamestate
{
	import world.objects.Car;
	public class GameState
	{
		// PUBLIC
		public var selectedCar:Number;							// De auto die op dit moment geselecteerd is
		public var numGames:Number = 0;							// Aantal games gespeeld
		public var score:Number = 0;							// Huidige score
		public var lastHighscore:Number = 0;					// De highscore van het laatste potje
		public var totalHighscore:Number = 0;					// De totale highscore die gehaald is tijdens het spelen van de game
		public var totalBounces:Number = 0;						// Totale aantal bounces
		public var hitMissArray:Array;							// Deze moet bijgehouden worden in-game (speciaal voor Ton)
		public var useGlow:Boolean = true;						// Of de graphics engine glows moet/mag gebruiken
		public var resX:Number = 640;							// De horizontale schermresolutie
		public var resY:Number = 360;							// De verticale schermresolutie
		public var removedArray:Array = new Array();			// De array die alle verwijderde bodies bijhoudt
		public var achievementUnlocked:Boolean = false;			// Bouncer achievement?
		public var tonMode:Boolean = true;						// Tonmode activated?
		
		public function GameState():void
		{
			// Reset all values (voor het begin van de game)
			reset();
		}
		
		public function reset():void
		{
			hitMissArray = new Array();
			removedArray = new Array();
		}
		
		public function finishGame():void
		{
			lastHighscore = score;
			totalHighscore += score;
			numGames++;
			totalBounces += hitMissArray.length;
			score = 0;
		}
	}
}