package menu
{
	// Imports
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.printing.PrintJobOptions;
	
	// Custom classes
	import fonts.SciFont;
	import game.Game;
	import world.gamestate.GameState;
	import menu.MenuScreen;
	import world.gamestate.GameState;
	import world.effects.DancingLine;
	
	public class Menu extends Sprite 
	{	
		// VARIABLES
		private var numLines:Number = 4; 								// Hoeveel dansende lijnen op de achtergrond?
		
		// PUBLIC
		
		// PRIVATE
		public var gameState:GameState;
		private var mCurrentScreen:Number = MenuScreen.PRESS_START;
		private var mDancingLineContainer:Sprite = new Sprite();
		private var mMenuScreen:Array = new Array();
		public var logo:Sprite = new Sprite();
		private var mMenuFadeSpeed:Number = 0.08;
		private var mSwitching:Boolean = false;
		private var logoEnabled:Boolean = true;
		private var gGame:Game;
		private var logoFadeSpeed:Number = 0.08;
		private var statContainer:Sprite = new Sprite();
		private var scoreValue:Sprite = SciFont.write("0", 0xffffff, 10, 300);
		private var totalBounces:Sprite = SciFont.write("0", 0xffffff, 8, 300);
		private var totalGames:Sprite = SciFont.write("0", 0xffffff, 8, 300);
		
		private var mMain:Sprite;
		private var mCheats:CheatMenu;
		private var mChooseCar:Sprite;
		private var mOptions:Sprite;
		private var mResults:Sprite;
		private var mPressStart:Sprite;
		
		public function Menu(gState:GameState,game:Game) 
		{
			gameState = gState;
			gGame = game;
			// Create the dancing lines
			addChild(mDancingLineContainer);
			for(var i:Number = 0; i<numLines; i++)
			{
				var danceTest:DancingLine = new DancingLine(Math.round(Math.random()*2+1),0x9999ff);
				danceTest.y = gameState.resY/2;
				mDancingLineContainer.addChild(danceTest);
			}
			drawStats();
			statContainer.addChild(scoreValue);
			scoreValue.x = 25;
			scoreValue.y = 25;
			totalBounces.x = 25;
			totalBounces.y = 107;
			statContainer.addChild(totalBounces);
			totalGames.x = 25;
			totalGames.y = 70;
			statContainer.addChild(totalGames);
			statContainer.alpha = 0;
			// Statcontainer
			statContainer.y = 210;
			statContainer.x = 20;
			addChild(statContainer);
			
			// Fill the menuscreen array
			mMain = new MainMenu(this,game.contentManager);
			addChild(mMain);
			
			mPressStart = new PressStart(this);
			addChild(mPressStart);
			
			mChooseCar = new ChooseCar(this,game.contentManager);
			addChild(mChooseCar);
			
			mOptions = new Options(this);
			addChild(mOptions);
			
			mResults = new GameResults(this);
			addChild(mResults);
			
			mCheats = new CheatMenu(this,game.contentManager);
			addChild(mCheats);
			
			mMenuScreen.push(mPressStart);
			mMenuScreen.push(mMain);
			mMenuScreen.push(mChooseCar);
			mMenuScreen.push(mResults);
			mMenuScreen.push(mOptions);
			mMenuScreen.push(mCheats);
			
			for (var j:Number = 0; j < mMenuScreen.length; j++)
			{
				mMenuScreen[j].alpha = 0;
				mMenuScreen[j].visible = false;
			}
			
			var gameTitle:String = (game.contentManager.getString("MenuData.GameTitle") != "") ? game.contentManager.getString("MenuData.GameTitle") : "        ton      racer";
			logo = SciFont.write(gameTitle,0xffffff,40,400);
			addChild(logo);
			logo.alpha = 0;
			logo.x = gameState.resX/2-logo.width/2-2;
			logo.y = 30;

			// Glow filter erover heen voor de looks
			var glow:GlowFilter = new GlowFilter(0x4545d4,1,8,8,2,2);
			logo.filters = [glow];
			mDancingLineContainer.filters = [glow];
		}
		
		public function drawStats():void
		{
			var scoreTxt:Sprite = SciFont.write("Score", 0xffffff, 5, 200);
			scoreTxt.y = 10;
			var totalBouncesTxt:Sprite = SciFont.write("Total bounces", 0xffffff, 5, 200);
			totalBouncesTxt.y = 95;
			var totalGamesTxt:Sprite = SciFont.write("Games played", 0xffffff, 5, 200);
			totalGamesTxt.y = 58;
			statContainer.addChild(scoreTxt);
			statContainer.addChild(totalBouncesTxt);
			statContainer.addChild(totalGamesTxt);
		}
		
		public function updateStats():void
		{
			SciFont.update(scoreValue, String(gameState.lastHighscore), 0xffffff, 10, 300);
			SciFont.update(totalBounces, String(gameState.totalBounces), 0xffffff, 8, 300);
			SciFont.update(totalGames, String(gameState.numGames), 0xffffff, 8, 300);
		}
		
		public function toggleLogo():void
		{
			logoEnabled = (logoEnabled) ? false : true;
		}
		
		public function playSound(length:Number, pitch:Number):void
		{
			gGame.playSound(length, pitch);
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			if(mCurrentScreen != -1)
				mMenuScreen[mCurrentScreen].keyUp(e);
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if(mCurrentScreen != -1)
				mMenuScreen[mCurrentScreen].keyDown(e);
		}
		
		public function createMenuScreen(type:Number):void
		{
			//trace("Create type: " + type);
			switch(type)
			{
				case MenuScreen.CHEATS:
					mCheats.clearCheat();
			}
			mCurrentScreen = type;
		}
		
		public function enableGame(selectedCar:Number):void
		{
			// Update the dancing lines
			for(var i:Number = 0; i<numLines; i++)
			{
				DancingLine(mDancingLineContainer.getChildAt(i)).turnOff();
			}
			mCurrentScreen = -1;
			gGame.resetGame();
			gGame.switchToGame(selectedCar);
		}
		
		public function disableGame():void
		{
			// Update the dancing lines
			for(var i:Number = 0; i<numLines; i++)
			{
				DancingLine(mDancingLineContainer.getChildAt(i)).turnOn();
			}
		}
		
		public function update():void
		{
			// Update the dancing lines
			for(var i:Number = 0; i<numLines; i++)
			{
				DancingLine(mDancingLineContainer.getChildAt(i)).update();
			}
			
			// Update logo
			if (logoEnabled && logo.alpha < 1)
				logo.alpha += logoFadeSpeed;
			else if (logoEnabled == false && logo.alpha > 0)
				logo.alpha -= logoFadeSpeed;
				
			statContainer.alpha = (gameState.totalBounces > 0) ? logo.alpha*0.5 : 0;
			
			// Update the current visible screen
			for (var vis:Number = 0; vis < mMenuScreen.length; vis++)
			{
				if (vis != mCurrentScreen && mMenuScreen[vis].alpha > 0)
				{	
					mSwitching = true;
					mMenuScreen[vis].alpha -= mMenuFadeSpeed;
					
					if (mMenuScreen[vis].alpha == 0)
						mMenuScreen[vis].visible = false;
				}
				if (vis == mCurrentScreen)
				{
					if (mMenuScreen[vis].visible == false)
						mMenuScreen[vis].visible = true;
						
					if (mMenuScreen[vis].alpha < 1)
						mMenuScreen[vis].alpha += mMenuFadeSpeed;
					else
						mSwitching = false;
				}
			}
			
			if(mSwitching == false)
				mMenuScreen[mCurrentScreen].update();
		}
	}
}