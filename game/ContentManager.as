package game
{
	/** 
	 * @class TonRacer ContentManager
	 * @description Deze class laadt alle content in uit de opgegeven XML
	 * @author Stefan Wijnker
	**/
	
	// IMPORTS
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import world.objects.LotusShape;
	import world.objects.LotusSelShape;
	import world.objects.EnzoShape;
	import physics.PhysWorld;
	import svg.SVGFile;
	import game.TonGame;
	import world.objects.Car;
	import world.objects.ConeShape;
	import world.objects.Obstacle;
	
	public class ContentManager
	{
		// PRIVATE
		private var XMLFile:XML = new XML();				// In deze variabele wordt alle XML data opgeslagen
		private var XMLLoader:URLLoader = new URLLoader();	// Deze loader wordt gebruikt om de XML data in te laden
		private var mGame:Game;								// Instance van de Game class, hebben we nodig om te laten weten dat de XML ingeladen is
		private var usingXML:Boolean = false;
		private var carData:Array = new Array();
		private var obstacleData:Array = new Array();
		private var menuStrings:Array = new Array();
		private var contentFolder:String = "content/";
		
		/**
		 * @method ContentManager ()
		 * @description Constructor voor de content manager
		 * @param xmlLocation (String) De locatie van de XML file
		 * @param game (Game) De instance van de parentclass Game
		**/
		public function ContentManager(xmlLocation:String,game:Game):void
		{
			mGame = game;
			XMLLoader.addEventListener(Event.COMPLETE, contentLoaded);
			XMLLoader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			XMLLoader.load(new URLRequest(xmlLocation));
		}
		
		/**
		 * @method loadError ()
		 * @description Deze functie wordt aangeroepen op het moment dat het niet gelukt is om de file te laden
		**/
		public function loadError(e:IOErrorEvent):void
		{
			var fileName:String = String(e.text).split("/")[String(e.text).split("/").length-1];
			//trace("ERROR! Bestand \"" + fileName + "\" niet gevonden");
			parseDefaultData();
			mGame.xmlLoaded(false);
		}
		
		/**
		 * @method contentLoaded ()
		 * @description Wordt aangeroepen op het moment dat de content uit de XML geladen is, deze functie stopt hem in
		 * de XMLFile variabele zodat hij in de hele class beschikbaar is
		**/
		private function contentLoaded(e:Event):void
		{
			XMLFile = XML(XMLLoader.data);
			// Parse de auto's
			parseData();
			
			// Stuur een signaal naar de Game class dat alles klaar is
			usingXML = true;
			mGame.xmlLoaded(true);
		}
		
		/**
		 * @method getString ()
		 * @description Haalt een string uit de XML data
		 * @param	inputChild (String) Locatie van de string in de XML
		**/
		public function getString(inputChild:String):String
		{
			//trace(inputChild);
			var childSplit:Array = inputChild.split(".");
			var returnString:String = "";
			switch(childSplit.length)
			{
				case 1:
					returnString = XMLFile.child(childSplit[0]);
					break;
				case 2:
					returnString = XMLFile.child(childSplit[0]).child(childSplit[1]);
					break;
				case 3:
					returnString = XMLFile.child(childSplit[0]).child(childSplit[1]).child(childSplit[2]);
					break;
				default:
					break;
			}
			return returnString;
		}
		
		/**
		 * @method parseDefaultData ()
		 * @description Als de XML niet gevonden is, specificeer dan gewoon de 2 normale auto's en alle obstakels en stop ze in de carData array, geef ook alle strings voor het hoofdmenu hun
		 * default waarde
		**/
		public function parseDefaultData():void
		{
			var lotusShape:LotusShape = new LotusShape();
			carData.push(new Car( "Lotus Elise",
									lotusShape,
									new LotusSelShape(),
									true, lotusShape.collisionPoints, 0xff0000 ));
			var enzoShape:EnzoShape = new EnzoShape();
			carData.push(new Car( "Ferrari Enzo",
									enzoShape,
									new LotusSelShape(),
									false, enzoShape.collisionPoints, 0x00ff00 ));
									
			// Laad default obstacles
			var coneShape:ConeShape = new ConeShape();
			obstacleData.push(new Obstacle("cone",
										coneShape,
										1,
										coneShape.collisionPoints,
										0xff0000));
			//obstacleData.push(new Obstacle("cone",
			menuStrings.push("New Game", "Ton Game", "Options", "Cheats", "Credits", "Quit");
		}
		
		/**
		 * @method parseData ()
		 * @description Als de XML ingeladen is, laadt deze functie alle auto data uit de XML in een temp array en laadt alle SVG's die erin staan, vervolgens wordt er voor iedere auto een
		 * nieuwe Car class aangemaakt en deze wordt in de carData array gestopt.
		**/
		public function parseData():void
		{
			// Parse de cars
			for (var c:Number = 0; c < XMLFile.RacerData.Car.length(); c++)
			{
				var tempArray:Array = new Array( XMLFile.RacerData.Car[c].CarName, 
										XMLFile.RacerData.Car[c].CarData, 
										XMLFile.RacerData.Car[c].CarSelData,
										XMLFile.RacerData.Car[c].Playable,
										uint(XMLFile.RacerData.Car[c].CarColor) );
				
				// Laad de 2 opgegeven SVG's, en anders de default gebruiken
				if (tempArray[1] != "")
					tempArray[1] = new SVGFile(contentFolder + tempArray[1]);
				else
				{ 
					switch(String(tempArray[0]))
					{
						case "Ferrari Enzo":
							tempArray[1] = new EnzoShape();
							break;
						case "Lotus Elise":
							tempArray[1] = new LotusShape();
							break;
						default:
							tempArray[1] = new LotusShape();
							break;
					}
				}
					
				if (tempArray[2] != "")
					tempArray[2] = new SVGFile(contentFolder + tempArray[2]);
				else
					tempArray[2] = new LotusSelShape();
					
				carData.push(new Car(tempArray[0], tempArray[1], tempArray[2], Boolean(tempArray[3]), tempArray[1].collisionPoints, tempArray[4] ));
			}
			
			// Parse alle obstacles
			for (var o:Number = 0; o < XMLFile.RacerData.Obstacle.length(); o++)
			{
				var tempObstacle:Array = new Array(	XMLFile.RacerData.Obstacle[o].ObstacleName,
													XMLFile.RacerData.Obstacle[o].ObstacleData,
													XMLFile.RacerData.Obstacle[o].ObstacleMass,
													uint(XMLFile.RacerData.Obstacle[o].ObstacleColor));
				if (tempObstacle[1] != "")
					tempObstacle[1] = new SVGFile(contentFolder + tempObstacle[1]);
				else
				{
					switch(String(tempObstacle[0]))
					{
						case "Cone":
							tempObstacle[1] = new ConeShape();
							break;
						default:
							tempObstacle[1] = new ConeShape();
							break;
					}
				}
				
				obstacleData.push(new Obstacle(tempObstacle[0], tempObstacle[1], tempObstacle[2], tempObstacle[1].collisionPoints, tempObstacle[3]));
			}
			
			// Laad menu strings uit XML
			menuStrings.push(	XMLFile.MenuData.MenuItemNames.NewGame,
								XMLFile.MenuData.MenuItemNames.TonGame,
								XMLFile.MenuData.MenuItemNames.Options,
								XMLFile.MenuData.MenuItemNames.Cheats,
								XMLFile.MenuData.MenuItemNames.Credits,
								XMLFile.MenuData.MenuItemNames.QuitGame );
		}
		
		/**
		 * @method getCars ()
		 * @description Geeft de carData-array
		**/
		public function getCars():Array
		{
			return carData;
		}
		
		/**
		 * @method getObstacles ()
		 * @description Geeft de array met de data voor de obstacles
		**/
		public function getObstacles():Array
		{
			return obstacleData;
		}
		
		/**
		 * @method getMenuStrings ()
		 * @description Geeft de menuStrings-array
		**/
		public function getMenuStrings():Array
		{
			return menuStrings;
		}
	}
}