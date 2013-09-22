package menu
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import menu.Menu;
	import menu.MenuScreen;
	import fonts.SciFont;
	import world.objects.LotusSelShape;
	import flash.filters.GlowFilter;
	import game.ContentManager;
	import world.objects.Car;
	
	public class CheatMenu extends Sprite 
	{	
		private var mMenu:Menu;
		private var cheatsTitle:Sprite;
		private var inputFeedback:Sprite;
		private var cheatString:String = "";
		private var maxCheatLength:Number = 6;
		private var cheatSize:Number = 25;
		
		public function CheatMenu(menu:Menu,cManager:ContentManager) 
		{
			mMenu = menu;
			cheatsTitle = SciFont.write("cheats", 0xffffff, 14, 400);
			addChild(cheatsTitle);
			cheatsTitle.x = 20;
			cheatsTitle.y = 20;
			cheatsTitle.filters = [new GlowFilter(0x4545d4,1,6,6,2)];
			
			inputFeedback = SciFont.write("enter cheat", 0xffffff, cheatSize-10, 5000);
			inputFeedback.x = mMenu.gameState.resX / 2 - inputFeedback.width / 2;
			inputFeedback.y = mMenu.gameState.resY / 2 - inputFeedback.height / 2;
			addChild(inputFeedback);
		}
		
		public function keyDown(e:KeyboardEvent):void
		{	
			if (cheatString.length < maxCheatLength)
			{
				switch(e.keyCode)
				{
					case 65:
						cheatString += "a";
						break;
					case 66:
						cheatString += "b";
						break;
					case 67:
						cheatString += "c";
						break;
					case 68:
						cheatString += "d";
						break;
					case 69:
						cheatString += "e";
						break;
					case 70:
						cheatString += "f";
						break;
					case 71:
						cheatString += "g";
						break;
					case 72:
						cheatString += "h";
						break;
					case 73:
						cheatString += "i";
						break;
					case 74:
						cheatString += "j";
						break;
					case 75:
						cheatString += "k";
						break;
					case 76:
						cheatString += "l";
						break;
					case 77:
						cheatString += "m";
						break;
					case 78:
						cheatString += "n";
						break;
					case 79:
						cheatString += "o";
						break;
					case 80:
						cheatString += "p";
						break;
					case 81:
						cheatString += "q";
						break;
					case 82:
						cheatString += "r";
						break;
					case 83:
						cheatString += "s";
						break;
					case 84:
						cheatString += "t";
						break;
					case 85:
						cheatString += "u";
						break;
					case 86:
						cheatString += "v";
						break;
					case 87:
						cheatString += "w";
						break;
					case 88:
						cheatString += "x";
						break;
					case 89:
						cheatString += "y";
						break;
					case 90:
						cheatString += "z";
						break;
				}
			}
			
			switch(e.keyCode)
			{
				case 13:
					validateCheat();
					break;
				case 32:
					validateCheat();
					break;
			}
			
			SciFont.update(inputFeedback, cheatString, 0xffffff, cheatSize, 8000);
			
			inputFeedback.x = mMenu.gameState.resX / 2 - inputFeedback.width / 2;
			inputFeedback.y = mMenu.gameState.resY / 2 - inputFeedback.height / 2;
		}
		
		public function clearCheat():void
		{
			cheatString = "";
			SciFont.update(inputFeedback, cheatString, 0xffffff, cheatSize, 8000);
		}
		
		private function validateCheat():void
		{
			switch(cheatString)
			{
				case "bier":
					mMenu.gameState.totalHighscore = 99999;
					mMenu.gameState.numGames = 99999;
					mMenu.gameState.score = 99999;
					mMenu.gameState.lastHighscore = 99999;
					mMenu.gameState.totalBounces = 99999;
					mMenu.updateStats();
					break;
				case "enzo":
					break;
			}
			
			// Terug naar hoofdmenu
			mMenu.createMenuScreen(MenuScreen.MAIN_MENU);
			mMenu.toggleLogo();
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function update():void
		{	
			
		}
	}
}