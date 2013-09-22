package game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.filters.GlowFilter;
	import menu.Menu;
	import game.ContentManager;
	import menu.MenuScreen;
	import game.TonGame;
	import world.gamestate.GameState;
	import sound.SoundManager;
	import world.effects.Grid;
	import fonts.SciFont;

	public class Game extends Sprite
	{
		// PRIVATE
		private var mGameState:GameState = new GameState();
		public var contentManager:ContentManager;
		private var sndManager:SoundManager = new SoundManager();
		private var mMenuContainer:Menu;
		private var mGameContainer:TonGame;
		public var gameZoom:Number = 10;
		public var totalZoom:Number = 10;
		private var gameActive:Boolean = false;
		private var zoomDelay:Number = 75;
		private var contentLoaded:Boolean = false;
		private var usingXML:Boolean = false;
		private var fadeDelay:Number = 20;
		private var currentDelay:Number = 0;
		private var achievementList:Array = new Array();
		private var isSwitchingToGame:Boolean = false;
		private var isSwitchingToMenu:Boolean = false;
		private var mScaleContainer:Sprite = new Sprite();
		private var loadingContent:Sprite;
		public var grid:Grid;
		private var countdownSprite:Sprite;
		private var countdownNum:Number = 3;
		private var currentCount:Number = 3;
		private var countdownTimer:Timer = new Timer(1100,countdownNum+1);
		
		public function Game() 
		{			
			contentManager =  new ContentManager("TonRacer.xml",this);
			loadingContent = SciFont.write("Loading content..", 0xffffff, 12, 500);
			loadingContent.filters = [new GlowFilter(0x4545d4, 1, 10, 10, 2, 2)];
			loadingContent.x = mGameState.resX / 2 - loadingContent.width / 2;
			loadingContent.y = mGameState.resY / 2 - loadingContent.height / 2;
			addChild(loadingContent);
			mScaleContainer.y = 180;
			mScaleContainer.x = 320;
			mScaleContainer.visible = false;
		}
		
		public function playSound(length:Number, pitch:Number):void
		{
			sndManager.playSound(length, pitch);
		}
		
		public function xmlLoaded(success:Boolean):void
		{
			usingXML = (success) ? true : false;
			loadingContent.visible = false;
			contentLoaded = true;
			countdownTimer.addEventListener("timer", triggerCountdown);
			mMenuContainer = new Menu(mGameState, this);
			grid = new Grid(this);
			mGameContainer = new TonGame(mGameState, this, grid);
			addChild(grid);
			//grid.alpha = 0;
			addChild(mScaleContainer);
			addChild(mMenuContainer);
			mScaleContainer.addChild(mGameContainer);
			countdownSprite = new Sprite();
			addChild(countdownSprite);
			var glowFilter:GlowFilter = new GlowFilter(0x4545d4, 1, 10, 10, 2, 2);
			countdownSprite.filters = [glowFilter];
			countdownSprite.x = 320;
			countdownSprite.y = 150;
			
			// Add event listeners for key, menu and the gameLoop
			addEventListener(Event.ENTER_FRAME, gameLoop);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		private function triggerCountdown(e:TimerEvent):void
		{
			var countSprite:Sprite = SciFont.write((currentCount > 0) ? String(currentCount) : (contentManager.getString("MenuData.CountDownFinishText") != "") ? contentManager.getString("MenuData.CountDownFinishText") : "GO   :D", 0xffffff, 90, 900);
			countSprite.x -= countSprite.width / 2;
			countSprite.y = -20;
			countdownSprite.addChild(countSprite);
			currentCount--;
			if (currentCount == -1)
			{
				currentCount = countdownNum;
				countdownTimer.stop();
				countdownTimer.reset();
			}
		}
		
		private function gameLoop(e:Event):void
		{
			// Pas nadat de XML ingeladen is
			if (contentLoaded == true)
			{
				loadingContent.visible = false;
				//grid.alpha = 1 - mMenuContainer.alpha;
				for (var i:Number = 0; i < countdownSprite.numChildren; i++)
				{
					var scaleMult:Number = 0.95;
					countdownSprite.getChildAt(i).scaleX *= scaleMult;
					countdownSprite.getChildAt(i).x *= scaleMult;
					countdownSprite.getChildAt(i).scaleY *= scaleMult;
					countdownSprite.getChildAt(i).y+= scaleMult;
					countdownSprite.getChildAt(i).alpha *= scaleMult;
					
					if (countdownSprite.getChildAt(i).alpha < 0.1)
						countdownSprite.removeChildAt(i);
				}
				
				if (gameActive && gameZoom < 2)
				{
					mMenuContainer.visible = false;
					mGameContainer.visible = true;
					mGameContainer.update();
				}
				else
				{
					mGameContainer.visible = false;
					mMenuContainer.visible = true;
					mMenuContainer.update();
				}
				
				mGameContainer.x = 0-320;
				mGameContainer.y = 0 - mGameContainer.height / 2;
				if (gameZoom < 5)
				{
					mScaleContainer.visible = true;
					mScaleContainer.scaleX = (gameZoom < 1) ? 1 : gameZoom;
					mScaleContainer.scaleY = (gameZoom < 1) ? 1 : gameZoom;
				}
				else
				{
					mScaleContainer.visible = false;
				}
				
				if (isSwitchingToGame)
				{
					
				grid.alpha = 1 - mMenuContainer.alpha;
				
					if (currentDelay < zoomDelay)
					{
						currentDelay++;
						if (currentDelay >= fadeDelay)
							mMenuContainer.alpha = 1-(currentDelay) / zoomDelay;
							
					}
					else
					{
						mMenuContainer.alpha = 0;
						grid.zoomOut();
						gameActive = true;
						
						currentDelay = 0;
						isSwitchingToGame = false;
					}
				
				}
				
				if (isSwitchingToMenu)
				{
				grid.alpha = 1;
					grid.alpha = 1;
					grid.gridVerMc.x = -20;
					if(grid.mZoomIn == false)
						grid.zoomIn();
						
					if (grid.currentZoom < 100)
					{
						mMenuContainer.createMenuScreen(MenuScreen.RESULTS);
						//mMenuContainer.toggleLogo();
						mMenuContainer.disableGame();
						mMenuContainer.alpha = 1;
					}
					gameActive = false;
					isSwitchingToMenu = false;
				}
				
				// Update de grid
				grid.updateGrid();
			}
		}
		
		public function resetGame():void
		{
			// Reset de gamestate
			mGameState.reset();
			
			// Reset de game
			mScaleContainer.removeChild(mGameContainer);
			mGameContainer = new TonGame(mGameState, this, grid);
			mScaleContainer.addChild(mGameContainer);
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			/*if (e.keyCode == 32)
				gameActive = !gameActive;*/
				
			if (gameActive)
				mGameContainer.keyDown(e);
			else
				mMenuContainer.keyDown(e);
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			if (gameActive)
				mGameContainer.keyUp(e);
			else
				mMenuContainer.keyUp(e);
		}
		
		public function switchToMenu():void
		{
			isSwitchingToMenu = true;
		}
		
		public function switchToGame(selectedCar:Number):void
		{
			isSwitchingToGame = true;
			mGameContainer.createCar(selectedCar);
			countdownTimer.start();
		}
	}
}