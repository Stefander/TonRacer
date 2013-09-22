package menu
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import fonts.SciFont;
	import sound.SoundManager;
	import menu.Menu;
	import game.ContentManager;
	
	public class MainMenu extends Sprite 
	{	
		// PUBLIC
		public var selItem:Number = 0;				// De huidige geselecteerde positie in het menu
		
		// PRIVATE
		public var visibleArray:Array;
		private var menuContainer:Sprite = new Sprite();
		private var menuList:Array = new Array();
		private var itemSize:Number = 12;
		private var visibleAmount:Number = 5;
		private var menuSpeed:Number = 5;
		private var rotateRemain:Number = 0;
		private var ySnap:Number = 0.2;
		private var mMenu:Menu;
		
		public function MainMenu(menu:Menu,cManager:ContentManager):void 
		{
			//menu.logo.visible = false;
			addChild(menuContainer);
			menuContainer.x = 319;
			menuContainer.y = 270;
			mMenu = menu;
			var menuStrings:Array = cManager.getMenuStrings();
			// Menu items toevoegen
			addMenuItem(menuStrings[0]);
			addMenuItem(menuStrings[1]);
			//addMenuItem(menuStrings[2]);
			addMenuItem(menuStrings[3]);
			//addMenuItem(menuStrings[4]);
			addMenuItem(menuStrings[5]);
			
			updateMenu();
		}
		
		public function gotoScreen(index:Number):void
		{
			switch(index)
			{
				case 0:
					mMenu.toggleLogo();
					mMenu.createMenuScreen(MenuScreen.CHOOSE_CAR);
					break;
				case 1:
					mMenu.toggleLogo();
					mMenu.createMenuScreen(MenuScreen.CHOOSE_CAR);
					break;			
				/*case 2:
					mMenu.toggleLogo();
					mMenu.createMenuScreen(MenuScreen.OPTIONS);
					break;*/
				case 2:
					mMenu.toggleLogo();
					mMenu.createMenuScreen(MenuScreen.CHEATS);
					break;
				case 3:
					mMenu.createMenuScreen(MenuScreen.PRESS_START);
					break;
			}
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (rotateRemain == 0)
			{
				switch(e.keyCode)
				{
					case 38:
						moveUp();
						break;
					case 40:
						moveDown();
						break;
					case 32:
						gotoScreen(selItem);
						mMenu.playSound(1, 300);
						break;
					case 13:
						gotoScreen(selItem);
						mMenu.playSound(1, 300);
						break;
				}
			}
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function addMenuItem(inputString:String):void
		{
			var menuItem:Sprite = SciFont.write(inputString, 0xffffff, itemSize, 500); 
			menuList.push(menuItem);
			menuItem.x -= menuItem.width / 2;
			menuContainer.addChild(menuItem);
		}
		
		private function moveDown():void
		{
			if (selItem < menuList.length-1)
				selItem++;
			else
				selItem = 0;
				
			mMenu.playSound(1, 200);
			
			rotateRemain = -40;
		}
		
		private function moveUp():void
		{
			if (selItem > 0)
				selItem--;
			else
				selItem = menuList.length - 1;
				
			mMenu.playSound(1, 200);
			
			rotateRemain = 40;
		}
		
		private function updateMenu():void 
		{
			visibleArray = new Array();
			// Bereken welke zichtbaar zijn
			for (var i:Number = 0; i < visibleAmount; i++)
			{
				var itemIndex:Number = i - 2;
				
				if ((selItem + itemIndex) < 0)
					visibleArray.push(selItem + menuList.length + itemIndex);
				else if ((selItem + itemIndex) > menuList.length - 1)
					visibleArray.push(itemIndex+(selItem-(menuList.length)));
				else
					visibleArray.push(selItem + itemIndex);
			}
			
			// Zet alle scales naar 0
			for (var j:Number = 0; j < menuList.length; j++)
			{
				menuList[j].scaleY = 0;
			}
			
			for ( var k:Number = 0; k < 5; k++)
			{
				var pos:Number = k - 2;
				
				var targetY:Number = menuList[visibleArray[pos + 2]].y;
				targetY = (pos * 40) - (menuList[visibleArray[pos + 2]].scaleY*itemSize);
				menuList[visibleArray[pos + 2]].y = targetY;
				var tempScale:Number = (targetY < 0) ? (80+targetY)/80 : (80-targetY)/80;
				menuList[visibleArray[pos + 2]].scaleY = tempScale + 0.2;
				menuList[visibleArray[pos + 2]].alpha = tempScale + 0.1;
			}
		}
		
		public function update():void
		{	
			
			if (rotateRemain != 0)
			{
				var yTranslate:Number = (rotateRemain > 0) ? menuSpeed : -menuSpeed;

				for (var i:Number = 0; i < menuList.length; i++)
				{
					menuList[i].y += yTranslate;
					var tempScale:Number = (menuList[i].y < 0) ? (80+menuList[i].y)/80 : (80-menuList[i].y)/80;
					menuList[i].scaleY = tempScale + 0.2;
					menuList[i].alpha = (visibleArray.indexOf(i) != -1) ? tempScale + 0.1 : 0;
				}
				
				rotateRemain -= yTranslate;
				
				if (rotateRemain == 0)
					updateMenu();
			}
		}
	}
}