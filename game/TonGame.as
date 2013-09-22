package game
{
	/**
	 * @class TonRacer class
	 * @description In deze class wordt de daadwerkelijke game afgehandeld, en ook alle effecten zoals particles en de score,
	 * het wel of niet updaten gebeurt in de Game class.
	 * @author Stefan Wijnker
	**/
	
	/*
			____            .    _  .
		   /# /_\_          |\_|/__/|
		  |  |/o\o\        / / \/ \  \
		  |  \\_/_/       /__|O||O|__ \
		 / |_   |        |/_ \_/\_/ _\ |
		|  ||\_ ~|       | | (____) | ||
		|  ||| \/        \/\___/\__/  //
		|  |||_          (_/         ||
		 \//  |           |          ||
		  ||  |           |          ||\
		  ||_  \           \        //_/
		  \_|  o|           \______//
		  /\___/          __ || __||
		 /  ||||__       (____(____)
			(___)_)
*/

	// IMPORTS
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.filters.GlowFilter;
	
	// CUSTOM IMPORTS
	import game.Game;
	import math.CustomMath;
	import fonts.SciFont;
	import physics.PhysWorld;
	import physics.PhysConvexObject;
	import world.objects.Car;
	import world.effects.Grid;
	import world.effects.Particle;
	import world.effects.Borders;
	import world.effects.Container;
	import world.gamestate.GameState;
	import world.objects.Obstacle;
	
	public class TonGame extends Sprite 
	{
		// PRIVATE
		
		// Gameplay
		private var MAX_ANGLE:Number 				= 40;				// Maximale hoek van de auto
		private var spawnDelay:Number 				= 60; 				// Elke seconde (60 frames) een nieuw object
		
		// Particles
		private var feedbackSpeed:Number 			= 5;				// Snelheid van de score feedback particles
		
		// Graphics
		private var borders:Borders 				= new Borders();	// De '3D' randen aan boven en onderkant
		private var achieveText:Sprite				= new Sprite();		// De placeholder voor de achievement graphics
		private var debugView:Sprite;									// Sprite voor de debug view
		private var mGrid:Grid;											// Het grid op de achtergrond
		private var world:PhysWorld;									// De PhysWorld voor de physics engine
		private var carShape:Sprite;									// Het visuele gedeelte van de auto
		private var carPhys:PhysConvexObject;							// De physics versie van de physics engine
		private var scoreValue:Sprite;									// De score sprite met de huidige score
		private var bounceTimer:Timer 				= new Timer(50, 0);// De timer die beslist of de bounce geregisteerd wordt
		private var enableBounceReg:Boolean 		= true;				// Of de volgende bounce geregistreerd wordt
		
		// Containers
		private var gameContainer:Sprite 			= new Sprite();		// Container waar de game in terecht zal komen
		private var obstacleContainer:Sprite 		= new Sprite();		// Container voor alle 'obstacles'
		private var scoreFeedbackContainer:Sprite 	= new Sprite();		// Container voor de particles voor de score feedback
		private var parContainer:Container 			= new Container();	// Botsingparticle container
		
		// Internal
		private var menuReturnTimer:Timer 			= new Timer(1500, 1);// Timer voor het results scherm (1.5s)
		private var objectNum:Number 				= 0;				// Hoeveelheid huidig gespawnde objecten
		private var curSpawnDelay:Number 			= 0;				// Huidige telindex voor spawn delay
		private var upPressed:Boolean 				= false;			// Of het pijltje naar boven ingedrukt is
		private var downPressed:Boolean 			= false;			// Of het pijltje naar onder ingedrukt is
		private var enableAngular:Boolean 			= true;				// Of de auto momenteel verticaal mag bewegen
		private var gGame:Game;											// Instance van de overkoepelende Game-class
		public var gameState:GameState;									// Instance van de huidige GameState
		
		/**
		 * @method TonGame ()
		 * @description Constructor van de TonGame class, voor het initialiseren van alle variabelen en om alle benodigde 
		 * children toe te voegen
		 * @param	gState (GameState) De instance van de GameState class
		 * @param	game   (Game) Instance van de 'master' Game class om functies aan te roepen
		 * @param	grid   (Grid) De instance van het grid, zodat ik daar commando's aan kan geven
		**/
		public function TonGame(gState:GameState,game:Game,grid:Grid):void
		{
			// Wijs de instances toe aan variabelen
			gGame = game;
			gameState = gState;
			mGrid = grid;
			
			// Creeer de physics engine
			world = new PhysWorld(this);
			
			// Hang een eventListener aan menuReturnTimer
			menuReturnTimer.addEventListener("timer", returnToMenu);
			
			// Debug view sprite voor de physics
			debugView = world.getDebugSprite();
			
			// Maak tijdelijke auto voor de speler aan
			carShape = new Sprite();
			
			// Verwijzing naar de physics instantie van de auto
			//carPhys = carShape.carPhys;
			
			// Scoretekst bovenaan het scherm
			var scoreText:Sprite = SciFont.write("Score", 0xffffff, 5, 600, 5);
			scoreText.x = gameState.resX/2-scoreText.width/2;
			scoreText.y = 17;
			
			// De huidige score
			scoreValue = SciFont.write(gameState.score.toString(), 0xffffff, 8, 6000, 3);
			scoreValue.x = gameState.resX/2-scoreValue.width/2;
			scoreValue.y = 26;
			
			// Gooi er een glow filter over de score en de algemene botsingparticlecontainer (Scrabble! :D) voor de looks
			scoreValue.filters = [new GlowFilter(0x4545d4, 1, 3, 3, 2)];
			parContainer.filters = [new GlowFilter(0xf49821, 1, 4, 4, 2)];
			
			// Voeg de gameContainer en de debug view toe aan de stage
			addChild(debugView);
			addChild(gameContainer);
			
			// En voeg de onderdelen van de game toe aan de gameContainer
			gameContainer.addChild(borders);
			gameContainer.addChild(obstacleContainer);
			gameContainer.addChild(scoreFeedbackContainer);
			gameContainer.addChild(parContainer);
			gameContainer.addChild(scoreText);
			gameContainer.addChild(scoreValue);
			
			// Hou de score feedback alpha een beetje doorzichtig
			scoreFeedbackContainer.alpha = 0.8;
			
			// Zet de debug view standaard uit
			debugView.visible = false;
			
			bounceTimer.start();
			bounceTimer.addEventListener("timer", enableBounce);
		}
		
		private function enableBounce(e:TimerEvent):void
		{
			enableBounceReg = true;
		}
		
		public function createCar(index:Number):void
		{
			var carArray:Array = gGame.contentManager.getCars();
			carShape = carArray[index].getVisualData();
			
			world.addConvexBody("player", carArray[index].getPhysData(), 2, 150, 150);
			carPhys = world.getConvexBody("player");
			carShape.x = carPhys.getPosition().x-carPhys.getCenterOfMass().x;
			carShape.y = carPhys.getPosition().y;
			carShape.scaleY = carPhys.getScale();
			carShape.scaleX = carShape.scaleY;
			
			carShape.filters = [new GlowFilter(carArray[index].getColor(), 1, 7, 7, 2)];
			gameContainer.addChild(carShape);
		}
		
		/**
		 * @method returnToMenu ()
		 * @description Deze functie brengt de speler weer terug naar het menu
		**/
		public function returnToMenu(e:TimerEvent):void
		{
			// Geef een commando aan de parent om terug te switchen naar het menu
			gGame.switchToMenu();
			
			// Reset de menuReturnTimer weer
			menuReturnTimer.reset();
			menuReturnTimer.stop();
		}
		
		/**
		 * @method triggerAchievement ()
		 * @description Activeert de achievement tekst in het beeld en unlockt de achievement in de GameState
		**/
		public function triggerAchievement():void
		{
			// Doe het alleen als de achievement nog niet geunlocked is
			if (gameState.achievementUnlocked == false)
			{	
				// Teken de achievement tekst
				achieveText = SciFont.write("Achievement unlocked!", 0x9999ff, 10, 4000);
				achieveText.x = 110;
				achieveText.y = 150;
				achieveText.visible = true;
				
				// Voeg hem toe aan de stage
				addChild(achieveText);
				
				// Teken de ondertitel
				var achieveDesc:Sprite = SciFont.write("Ferrari Enzo", 0xffffff, 8, 700);
				achieveDesc.x = 100;
				achieveDesc.y = 20;
				
				// Voeg hem toe als child van de achievement tekst
				achieveText.addChild(achieveDesc);
				
				// Unlock hem in de GameState
				gameState.achievementUnlocked = true;
			}
		}
		
		/**
		 * @method createExplosion ()
		 * @description Maakt een explosie met displacement maps, is momenteel even uitgeschakeld vanwege wat kuren met de
		 * performance
		 * @param expX (Number) De X positie van de explosie
		 * @param expY (Number) De Y positie van de explosie
		 * @param intensity (Number) De kracht van de explosie
		**/
		public function createExplosion(expX:Number, expY:Number, intensity:Number):void
		{
			// Maak explosie :D
			mGrid.createExplosion(expX, expY, intensity);
		}
		
		/**
		 * @method updateScore ()
		 * @description Vernieuwt de score, maakt de feedback particles aan en de normale botsing particles
		 * @param impX (Number) De X coordinaat van de impact
		 * @param impY (Number) De Y coordinaat van de impact
		 * @param angle (Number) De hoek van de impact
		 * @param velocity (Number) De snelheid van de impact
		 * @param value (Number) De score die het oplevert
		**/
		public function updateScore(impX:Number,impY:Number,targetName:String,angle:Number,velocity:Number,value:Number):void
		{
			// Maak nieuwe particles (met first generation! Fail! :( )
			for (var i:Number = 0; i < (Math.random()*5)+3; i++)
			{
				// Nieuwe particle instance
				var tempParticle:Particle = new Particle(impX, impY, velocity);
				// Voeg hem toe aan de algemene particlecontainer
				parContainer.addChild(tempParticle);
			}
			if (enableBounceReg)
			{
				enableBounceReg = false;
				bounceTimer.reset();
				bounceTimer.start();
				gameState.hitMissArray.push(targetName);
				// Maak score feedback particle (met m'n tekstclass :)) op aangegeven positie
				var scoreFeedback:Sprite = SciFont.write(".", (value > 0) ? 0x9999ff : 0xff0000, 20/(CustomMath.numStringInArray(targetName,gameState.hitMissArray)/2), 100);
				scoreFeedback.x = impX;
				scoreFeedback.y = impY - 10;
				
				// Voeg hem toe aan de feedbackContainer
				scoreFeedbackContainer.addChild(scoreFeedback);
			}
		}
		
		/**
		 * @method keyDown ()
		 * @description Deze functie wordt getriggered door de Game class op het moment dat er een knop ingedrukt wordt
		**/
		public function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 38: // Pijltje omhoog
					upPressed = true;
					break;
				case 40: // Pijltje omlaag
					downPressed = true;
					break;
				case 68: 
					// Switch naar debug view en zet de gameContainer uit (en andersom)
					debugView.visible = (debugView.visible) ? false : true;
					gameContainer.visible = (gameContainer.visible) ? false : true;
					break;
			}
		}
		
		/**
		 * @method keyUp ()
		 * @description Deze functie wordt getriggered door de Game class op het moment dat er een knop losgelaten wordt
		**/
		public function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 38: // Pijltje omhoog
					upPressed = false;
					break;
				case 40: // Pijltje omlaag
					downPressed = false;
					break;
			}
			
			// Schakel nu weer de mogelijkheid voor de speler in om te manouvreren
			enableAngular = true;
		}
		
		/**
		 * @method obstacleObject ()
		 * @description Genereert elke keer als de functie aangeroepen wordt een cone in het veld (inclusief physics)
		**/
		public function obstacleObject() 
		{
			var obstacleArray:Array = gGame.contentManager.getObstacles();
			var randomObstacle:Number = Math.round(Math.random() * (obstacleArray.length-1));
			
			if((obstacleArray[randomObstacle].getObstacleName() == "cone" || world.getStringBodyAmount(obstacleArray[randomObstacle].getObstacleName()) < 1) == false)
			{
				while ((obstacleArray[randomObstacle].getObstacleName() == "cone" || world.getStringBodyAmount(obstacleArray[randomObstacle].getObstacleName()) < 1) == false)
				{
					randomObstacle = Math.round(Math.random() * (obstacleArray.length-1));
				}
			}
			
			// Creeer een nieuwe obstacle helemaal los van de obstacleArray in de ContentManager
			var tempObstacle:Obstacle = new Obstacle(	obstacleArray[randomObstacle].getObstacleName(),
														obstacleArray[randomObstacle].getVisualData(),
														obstacleArray[randomObstacle].getMass(),
														CustomMath.cloneArray(obstacleArray[randomObstacle].getPhysData()),
														obstacleArray[randomObstacle].getColor()	);
			
			var physInstanceName:String = obstacleArray[randomObstacle].getObstacleName() + String(objectNum);
			world.addConvexBody(physInstanceName, tempObstacle.getPhysData(), tempObstacle.getMass(), 680, Math.random() * 250 + 60);
			world.getConvexBody(physInstanceName).setCurrentVelocity(new Point( -10, 0));
			world.getConvexBody(physInstanceName).setLinearVelocity(new Point( -10, 0));
			
			tempObstacle.setPhysInstance(world, physInstanceName);
			
			// Voeg hem toe aan de obstacle container
			obstacleContainer.addChild(tempObstacle);
			
			// Itereer het aantal gespawnde bodies
			objectNum++;
			
			// Zet de spawnteller terug op 0
			curSpawnDelay = 0;
		}
		
		/**
		 * @method update ()
		 * @description Wordt elke frame aangeroepen, dient om posities en rotaties te updaten
		**/
		public function update():void 
		{	
			// Speciaal voor Ton, na 10 objecten naar de results pagina
			if (gameState.removedArray.length >= 10 && gameState.tonMode)
				menuReturnTimer.start();
			
			// Als de tonMode aan staat en er minder dan 10 gespawnde objecten zijn
			if ((world.getAddedAmount() <= 10 && gameState.tonMode) || (gameState.tonMode == false))
			{
				// Ga vrolijk verder met doortellen als hij er nog niet is
				if(curSpawnDelay < spawnDelay)
					curSpawnDelay++;
				else
					obstacleObject();
			}
			
			if (achieveText.visible)
			{
				achieveText.alpha -= 0.008;
				if (achieveText.alpha <= 0)
					achieveText.visible = false;
			}
		
			// Update de physics
			world.update();
			parContainer.update();
			//trace(parContainer.numChildren);
			// Update de score feedback posities
			for (var feed:Number = 0; feed < scoreFeedbackContainer.numChildren; feed++)
			{
				var feedbackItem:Sprite = Sprite(scoreFeedbackContainer.getChildAt(feed));
				var distToScore:Number = Point.distance(new Point(scoreValue.x+scoreValue.width/2, scoreValue.y), new Point(feedbackItem.x, feedbackItem.y));
				var dAngle:Number = Math.atan2(scoreValue.y - feedbackItem.y, scoreValue.x+scoreValue.width/2 - feedbackItem.x);
				
				var newPos:Point = Point.polar((distToScore / 10) + 1, dAngle);
				
				feedbackItem.alpha = (distToScore / 80 < 1 && distToScore / 80 > 0) ? distToScore / 80 : 1;
				feedbackItem.scaleX = feedbackItem.alpha+0.5;
				feedbackItem.scaleY = feedbackItem.alpha+0.5;
				feedbackItem.x += newPos.x;
				feedbackItem.y += newPos.y;
				
				if ((distToScore > 0 && distToScore < 10) || (distToScore < 0 && distToScore > -10))
				{
					gameState.score += Math.round(3*feedbackItem.height);
					SciFont.update(scoreValue, gameState.score.toString(), 0xffffff, 8, 4000, 3);
					scoreValue.x = gameState.resX/2-scoreValue.width/2;
					scoreFeedbackContainer.removeChildAt(feed);
				}
			}
			
			// Update de obstacles
			for (var obstacle:Number = 0; obstacle < obstacleContainer.numChildren; obstacle++)
			{
				Obstacle(obstacleContainer.getChildAt(obstacle)).update();
			}
			
			var linearX:Number = (carShape.x < 160) ? 2.0 : 0;
			
			carPhys.setLinearVelocity((upPressed && enableAngular) ? new Point(linearX,-5) : (downPressed && enableAngular) ? new Point(linearX,5) : new Point(linearX,0));
			carPhys.setCurrentVelocity(((upPressed == false && downPressed == false) || enableAngular == false) ? new Point(0,carPhys.getCurrentVelocity().y*0.7) : carPhys.getCurrentVelocity());
			carPhys.setAngularVelocity((upPressed && carPhys.getAngle() < MAX_ANGLE && enableAngular) ? 2 : (downPressed && carPhys.getAngle() > -MAX_ANGLE && enableAngular) ? -2 : -carPhys.getAngle()*0.2);
			
			if (carPhys.getAngle() > MAX_ANGLE || carPhys.getAngle() < -MAX_ANGLE)
				enableAngular = false;
				
			// Update de auto
			carShape.x = carPhys.getPosition().x+(carPhys.getCenterOfMass().x/2);
			carShape.y = carPhys.getPosition().y+carPhys.getCenterOfMass().y;
			carShape.rotation = -carPhys.getAngle();
			
			// Update de borders
			borders.updateBorders();
		}
	}
}