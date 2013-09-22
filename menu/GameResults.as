package menu
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import menu.Menu;
	import menu.MenuScreen;
	import flash.filters.GlowFilter;
	import fonts.SciFont;
	import math.CustomMath;
	
	public class GameResults extends Sprite 
	{	
		private var mMenu:Menu;
		private var resultTitle:Sprite;
		private var calculatedResults:Boolean = false;
		private var resultData:Sprite;
		
		public function GameResults(menu:Menu) 
		{
			mMenu = menu;
			
			resultTitle = SciFont.write("results", 0xffffff, 14, 400);
			addChild(resultTitle);
			resultTitle.x = 20;
			resultTitle.y = 20;
			
			var textFilter:GlowFilter = new GlowFilter(0x4545d4,1,6,6,2);
			resultTitle.filters = [textFilter];
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 32 || e.keyCode == 13)
			{
				mMenu.createMenuScreen(MenuScreen.MAIN_MENU);
				mMenu.toggleLogo();
				mMenu.gameState.finishGame();
				mMenu.updateStats();
				calculatedResults = false;
				removeChild(resultData);
			}
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function calculateResults():Sprite
		{
			var outputSprite:Sprite = new Sprite();
			var nameContainer:Sprite = new Sprite();
			var bounceContainer:Sprite = new Sprite();
			nameContainer.x = 40;
			nameContainer.y = 70;
			bounceContainer.x = 340;
			bounceContainer.y = 70;
			
			var verticalSpacer:Number = 16;
			outputSprite.addChild(nameContainer);
			outputSprite.addChild(bounceContainer);
			mMenu.gameState.removedArray.sort();
			
			var objectNames:Sprite = SciFont.write("Obstacle", 0xffffff, 10, 300);
			objectNames.y = -25;
			nameContainer.addChild(objectNames);
			
			objectNames.filters = [new GlowFilter(0x4545d4, 1, 5, 5, 2)];
			
			var bounceAmounts:Sprite = SciFont.write("Bounces", 0xffffff, 10, 300);
			bounceAmounts.y = -25;
			bounceContainer.addChild(bounceAmounts);
			
			bounceAmounts.filters = [new GlowFilter(0x4545d4, 1, 5, 5, 2)];
			
			for (var i:Number = 0; i < mMenu.gameState.removedArray.length; i++)
			{
				var tempName:Sprite = SciFont.write(mMenu.gameState.removedArray[i], 0xffffff, 7, 400);
				var tempBounce:Sprite = SciFont.write(String(CustomMath.numStringInArray(mMenu.gameState.removedArray[i], mMenu.gameState.hitMissArray)), 0xffffff, 7, 100);
				tempBounce.y = i * verticalSpacer;
				tempName.y = i * verticalSpacer;
				bounceContainer.addChild(tempBounce);
				nameContainer.addChild(tempName);
			}
			var totalBounces:Sprite = SciFont.write(String(mMenu.gameState.hitMissArray.length), 0xffffff, 12, 200);
			totalBounces.y = mMenu.gameState.removedArray.length * verticalSpacer+5;
			bounceContainer.addChild(totalBounces);
			outputSprite.x = 40;
			outputSprite.y = 35;
			outputSprite.alpha = 0;
			return outputSprite;
		}
		
		public function update():void
		{	
			if (calculatedResults == false)
			{
				resultData = calculateResults();
				calculatedResults = true;
				addChild(resultData);
			}
			
			if (resultData.alpha < 1)
				resultData.alpha += 0.05;
		}
	}
}