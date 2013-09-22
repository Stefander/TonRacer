package menu
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import menu.Menu;
	import menu.MenuScreen;
	import flash.filters.GlowFilter;
	import fonts.SciFont;
	
	public class Options extends Sprite 
	{	
		private var mMenu:Menu;
		private var optionsTitle:Sprite;
		
		public function Options(menu:Menu) 
		{
			mMenu = menu;
			
			optionsTitle = SciFont.write("options", 0xffffff, 14, 400);
			addChild(optionsTitle);
			optionsTitle.x = 20;
			optionsTitle.y = 20;
			
			var textFilter:GlowFilter = new GlowFilter(0x4545d4,1,6,6,2);
			optionsTitle.filters = [textFilter];
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 32 || e.keyCode == 13)
			{
				mMenu.createMenuScreen(MenuScreen.MAIN_MENU);
				mMenu.toggleLogo();
			}
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function update():void
		{	

		}
	}
}