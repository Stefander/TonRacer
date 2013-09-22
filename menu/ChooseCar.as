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
	
	public class ChooseCar extends Sprite 
	{	
		private var mMenu:Menu;
		private var chooseCar:Sprite;
		private var currentCarIndex:Sprite;
		private var carShape:Sprite;
		private var carDesc:Sprite;
		private var carArray:Array;
		private var carSelectionArray:Array = new Array();
		private var curSelected:Number = 0;
		private var toMove:Number = 0;
		private var moveAmount:Number = 640;
		
		public function ChooseCar(menu:Menu,cManager:ContentManager) 
		{
			carArray = cManager.getCars();
			mMenu = menu;
			chooseCar = SciFont.write("kies je waggel", 0xffffff, 14, 400);
			addChild(chooseCar);
			chooseCar.x = 20;
			chooseCar.y = 20;
			
			currentCarIndex = SciFont.write(String((curSelected+1) + "/" + carArray.length), 0xffffff, 12, 400);
			currentCarIndex.x = mMenu.gameState.resX / 2 - currentCarIndex.width / 2;
			currentCarIndex.y = 330;
			addChild(currentCarIndex);
			
			for (var i:Number = 0; i < carArray.length; i++)
			{
				var carContainer:Sprite = new Sprite();
				addChild(carContainer);
				carSelectionArray.push(carContainer);
				carShape = Car(carArray[i]).getSelectionData();
				carShape.x = mMenu.gameState.resX / 2 - carShape.width / 2 - carShape.getBounds(carShape).left;	
				carShape.y = mMenu.gameState.resY / 2 - carShape.height / 2 - carShape.getBounds(carShape).top;
				
				carContainer.addChild(carShape);
				
				//addChild(lotusShape);
				
				carDesc = SciFont.write(Car(carArray[i]).getCarName(), 0xffffff, 8, 400);
				carDesc.x = mMenu.gameState.resX/2-carDesc.width/2;
				carDesc.y = 300;
				carContainer.addChild(carDesc);
				
				// Glow filter erover heen
				var glowFilter:GlowFilter = new GlowFilter(Car(carArray[i]).getColor(), 1, 10, 10, 2);
				carShape.filters = [glowFilter];
				if(i != curSelected)
					carContainer.visible = false;
			}
			
			var textFilter:GlowFilter = new GlowFilter(0x4545d4,1,6,6,2);
			chooseCar.filters = [textFilter];
		}
		
		public function moveRight():void
		{
			if(curSelected < carArray.length-1)
				curSelected ++;
			else
				curSelected = 0;
				
			mMenu.playSound(1, 200);
				
			SciFont.update(currentCarIndex, String((curSelected + 1) + "/" + carArray.length), 0xffffff, 12, 400);
			currentCarIndex.x = mMenu.gameState.resX / 2 - currentCarIndex.width / 2;
			
			carSelectionArray[curSelected].visible = true;
			toMove = -moveAmount;
			carSelectionArray[curSelected].x = -toMove;
		}
		
		public function moveLeft():void
		{
			if (curSelected > 0)
				curSelected--;
			else
				curSelected = carArray.length - 1;
				
			mMenu.playSound(1, 200);
				
			SciFont.update(currentCarIndex, String((curSelected + 1) + "/" + carArray.length), 0xffffff, 12, 400);
			currentCarIndex.x = mMenu.gameState.resX / 2 - currentCarIndex.width / 2;
			
			toMove = moveAmount;
			carSelectionArray[curSelected].visible = true;
			carSelectionArray[curSelected].x = -toMove;
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (toMove == 0)
			{
				switch(e.keyCode)
				{
					case 13:
						mMenu.enableGame(curSelected);
						mMenu.playSound(1, 300);
						break;
					case 32:
						mMenu.enableGame(curSelected);
						mMenu.playSound(1, 300);
						break;
					case 37:
						moveLeft();
						break;
					case 39:
						moveRight();
						break;
				}
			}
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function update():void
		{	
			if (toMove != 0)
			{
				for (var i:Number = 0; i < carSelectionArray.length; i++)
				{
					if (carSelectionArray[i].visible)
					{
						carSelectionArray[i].x+= toMove/5;
					}
				}
				
				toMove-= toMove / 5;
			}
			//trace(toMove);
			if (Math.abs(toMove) < 20)//(toMove > 0 && toMove <= 20) || (toMove < 0 && toMove >= -20))
			{
				for (var j:Number = 0; j < carSelectionArray.length; j++)
				{
					if (j != curSelected)
					{
						carSelectionArray[j].visible = false;
						toMove = 0;
						carSelectionArray[j].x = 0;
					}
				}
			}
		}
	}
}