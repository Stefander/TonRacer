package fonts
{
	/**
	 * @class TonRacer FontChar
	 * @description Deze class wordt gebruikt voor het schrijven van in-game karakters
	 * @author Stefan Wijnker
	**/
	
	// IMPORTS
	import flash.display.Sprite;
	
	public class FontChar extends Sprite
	{	
		// PUBLIC
		public var charWidth:Number;			// De breedte van het karakter
		
		/**
		 * @method FontChar ()
		 * @description De constructor functie van de FontChar
		**/
		public function FontChar():void
		{
			charWidth = 0;
		}
	}
}