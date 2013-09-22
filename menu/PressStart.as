package menu
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import menu.Menu;
	import menu.MenuScreen;
	import fonts.SciFont;
	
	public class PressStart extends Sprite 
	{	
		private var mMenu:Menu;
		private var pressStart:Sprite;
		private var fadeSpeed:Number = .02;
		
		public function PressStart(menu:Menu) 
		{
			mMenu = menu;
			pressStart = SciFont.write("druk op spatie", 0xffffff, 10, 400);
			addChild(pressStart);
			pressStart.x = mMenu.gameState.resX / 2 - (pressStart.width/2)-2;
			pressStart.y = 273;
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 32 || e.keyCode == 13)
			{
				mMenu.createMenuScreen(MenuScreen.MAIN_MENU);
				mMenu.playSound(1, 300);
			}
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function update():void
		{	
			pressStart.alpha -= fadeSpeed;
			pressStart.alpha = Math.round(pressStart.alpha * 1000) / 1000;
			if (pressStart.alpha < fadeSpeed)
			{
				fadeSpeed = -fadeSpeed;
				pressStart.alpha = 0;
			}
			if (pressStart.alpha > 1)
			{
				fadeSpeed = -fadeSpeed;
				pressStart.alpha = 1;
			}
		}
	}
}