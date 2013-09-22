package fonts
{
	/**
	 * @class TonRacer SciFont
	 * @description Shapeclass voor het in-game lettertype
	 * Geconverteerd naar class door Stefan Wijnker, GDD-B
	 * @author Stefan Wijnker
	 * @source Space Age font, DaFont.com
	**/
	
	// IMPORTS
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	// CUSTOM IMPORTS
	import fonts.FontChar;
	
	public class SciFont
	{	
		// PRIVATE
		private static var fontHeight:Number 		= 24;	// Hoogte van de 'standaard' font
		private static var g:Graphics;						// Afkorting voor het tekenen
		private static var charSprite:FontChar;				// De sprite die gebruikt wordt tijdens het tekenen van de karakters
		
		/**
		 * @method write ()
		 * @description Deze method 'tekent' de tekst met behulp van alle draw* functies in deze class
		 * @param	inputString (String) De tekst die getekend moet worden
		 * @param	color (uint) De kleur van de tekst
		 * @param	size (Number) De grootte van de tekst
		 * @param	xLimit (Number) Wanneer hij deze x-waarde bereikt heeft komt er een nieuwe regel
		 * @param	space (Number) Ruimte tussen de letters
		**/
		public static function write(inputString:String, color:uint, size:Number, xLimit:Number, space:Number = -1):Sprite // STRAKS TERUGGEVEN ALS MOVIECLIP!
		{
			// De output sprite
			var output:Sprite = new Sprite();
			
			// De huidige coordinaten op de sprite
			var tempX:Number = 0;
			var tempY:Number = 0;
			
			// Voor elk teken in de input string
			for (var i:Number = 0; i < inputString.length; i++)
			{
				// Als hij niet leeg is
				if (inputString.charAt(i) != " ")
				{
					// Teken het karakter
					var drawChar:FontChar = drawChar(inputString.toLowerCase().charAt(i), color, size);
					
					// Als hij te ver zou gaan, ga naar de volgende regel
					if (drawChar.charWidth + tempX > xLimit)
					{
						tempX = 0;
						tempY+=size+10;
					}
					// Teken de karakter op deze positie
					drawChar.x = tempX;
					drawChar.y = tempY;
					
					// Verzet de huidige coordinaten weer naar de breedte van het karakter plus de offset
					tempX += drawChar.charWidth + 2;
					
					// Voeg het karakter toe in de string
					output.addChild(drawChar);
				}
				else {
					// Lege ruimte door spatie
					tempX += 10;
				}
			}
			
			return (output);
		}
		
		/**
		 * @method update ()
		 * @description Update van een oude sprite die nieuwe tekst nodig heeft
		 * @param	oldSprite (Sprite) De sprite die vervangen moet worden
		 * @param	inputString (String) De nieuwe tekst voor de sprite
		 * @param	color (uint) De kleur van de nieuwe tekst
		 * @param	size (Number) De grootte van de tekst
		 * @param	xLimit (Number) Wanneer hij terugspringt naar de volgend regel
		 * @param	space (Number) Ruimte tussen de letters
		**/
		public static function update(oldSprite:Sprite, inputString:String, color:uint, size:Number, xLimit:Number, space:Number = -1):void
		{
			// Haal de oude sprite leeg
			while(oldSprite.numChildren > 0)
				oldSprite.removeChildAt(0);
		
			// Teken over de oude heen
			oldSprite.addChild(write(inputString, color, size, xLimit, space));
		}
		/**
		 * @method drawChar ()
		 * @description Tekent het inputChar karakter, geeft een FontChar terug met de breedte van het karakter
		 * @param	inputChar (String) Het karakter dat getekend moet worden
		 * @param	color (uint) De kleur van het karakter
		 * @param	size (Number) Grootte van het karakter
		**/
		private static function drawChar(inputChar:String, color:uint, size:Number):FontChar
		{
			// Gebruik de fontChar die al gedeclareerd is
			charSprite = new FontChar();
			
			// In de gewenste kleur
			charSprite.graphics.beginFill(color);
			
			// Gebruik g als afkorting, is wel zo lekker als je vertyft veel letters en symbolen met de hand moet maken
			g = charSprite.graphics;
			
			// Deze switch zorgt ervoor dat de juiste functie aangeroepen wordt voor het gewenste karakter
			switch(inputChar)
			{
				case "a":
					drawA();
					break;
				case "b":
					drawB();
					break;
				case "c":
					drawC();
					break;
				case "d":
					drawD();
					break;
				case "e":
					drawE();
					break;
				case "f":
					drawF();
					break;
				case "g":
					drawG();
					break;
				case "h":
					drawH();
					break;
				case "i":
					drawI();
					break;
				case "j":
					drawJ();
					break;
				case "k":
					drawK();
					break;
				case "l":
					drawL();
					break;
				case "m":
					drawM();
					break;
				case "n":
					drawN();
					break;
				case "o":
					drawO();
					break;
				case "p":
					drawP();
					break;
				case "q":
					drawQ();
					break;
				case "r":
					drawR();
					break;
				case "s":
					drawS();
					break;
				case "t":
					drawT();
					break;
				case "u":
					drawU();
					break;
				case "v":
					drawV();
					break;
				case "w":
					drawW();
					break;
				case "x":
					drawX();
					break;
				case "y":
					drawY();
					break;
				case "z":
					drawZ();
					break;
				case "1":
					draw1();
					break;
				case "2":
					draw2();
					break;
				case "3":
					draw3();
					break;
				case "4":
					draw4();
					break;
				case "5":
					draw5();
					break;
				case "6":
					draw6();
					break;
				case "7":
					draw7();
					break;
				case "8":
					draw8();
					break;
				case "9":
					draw9();
					break;
				case ".":
					drawPoint();
					break;
				case ":":
					drawDoublePoint();
					break;
				case "/":
					drawSlash();
					break;
				case "-":
					drawStreep();
					break;
				case "0":
					draw0();
					break;
			}
			
			// Nu het karakter getekend is, hebben we de fill niet meer nodig
			charSprite.graphics.endFill();
			
			// Vergroot of verklein de FontChar (inclusief de charWidth) aan de hand van de opgegeven grootte
			charSprite.scaleX = size / fontHeight;
			charSprite.charWidth *= charSprite.scaleX;
			charSprite.scaleY = size / fontHeight;
			
			return charSprite;
		}
		
		// WARNING: SAAIE DRAWING CODE BEYOND THIS POINT!
		
		private static function drawA():void
		{
			g.moveTo(23, 15);
			g.curveTo(19, 15, 19, 19);
			g.curveTo(19, 22, 23, 22);
			g.curveTo(27, 22, 27, 19);
			g.curveTo(27, 15, 23, 15);
			
			g.moveTo(7, 22);
			g.curveTo(6, 24, 3, 23);
			g.curveTo(1, 21, 3, 19);
			g.lineTo(18, 2);
			g.curveTo(20, 0, 23, 0);
			g.curveTo(25, 0, 27, 1);
			g.lineTo(44, 20);
			g.curveTo(45, 21, 43, 23);
			g.curveTo(40, 24, 39, 22);
			g.lineTo(25, 7);
			g.curveTo(23, 5, 21, 7);
			g.lineTo(7, 22);
			
			charSprite.charWidth = 45;
		}
		
		private static function drawB():void
		{
			g.moveTo(0, 9);
			g.lineTo(5, 9);
			g.lineTo(5, 4);
			g.lineTo(36, 4);
			g.curveTo(41, 4, 41, 7);
			g.curveTo(41, 9, 36, 9);
			g.lineTo(0, 9);
			g.lineTo(0, 15);
			g.lineTo(36, 15);
			g.lineTo(44, 12);
			g.curveTo(46, 11, 46, 7);
			g.curveTo(45, 1, 41, 0);
			g.lineTo(2, 0);
			g.curveTo(0,0, 0, 2);
			g.lineTo(0, 9);
			
			g.moveTo(0, 15);
			g.lineTo(0, 22);
			g.curveTo(0, 24, 2, 24);
			g.lineTo(43, 24);
			g.curveTo(46, 22, 46, 17);
			g.curveTo(46, 14, 44, 12);
			g.lineTo(36, 15);
			g.curveTo(41, 15, 41, 18);
			g.curveTo(41, 20, 36, 20);
			g.lineTo(5, 20);
			g.lineTo(5, 15);
			g.lineTo(0, 15);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawC():void
		{
			g.moveTo(0, 12);
			g.curveTo(1, 2, 8, 0);
			g.lineTo(46, 0);
			g.curveTo(48, 0, 48, 2);
			g.curveTo(48, 4, 46, 4);
			g.lineTo(10, 4);
			g.curveTo(5, 6, 5, 12);
			g.curveTo(5, 18, 9, 20);
			g.lineTo(45, 20);
			g.curveTo(48, 19, 48, 22);
			g.curveTo(48, 24, 46, 24);
			g.lineTo(5, 24);
			g.curveTo(1, 21, 0, 12);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawD():void
		{
			g.moveTo(48, 12);
			g.curveTo(48, 2, 40, 0);
			g.lineTo(2, 0);
			g.curveTo(0, 0, 0, 2);
			g.lineTo(0, 22);
			g.curveTo(0, 24, 2, 24);
			g.lineTo(5, 24);
			g.lineTo(5, 5);
			g.lineTo(38, 5);
			g.curveTo(42, 6, 43, 12);
			g.curveTo(43, 18, 38, 19);
			g.lineTo(5, 19);
			g.lineTo(5, 24);
			g.lineTo(42, 24);
			g.curveTo(48, 20, 48, 12);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawE():void
		{
			g.moveTo(0, 12);
			g.curveTo(1, 2, 8, 0);
			g.lineTo(46, 0);
			g.curveTo(48, 0, 48, 2);
			g.curveTo(48, 4, 46, 4);
			g.lineTo(10, 4);
			g.curveTo(5, 6, 5, 12);
			g.curveTo(5, 18, 9, 19);
			g.lineTo(45, 19);
			g.curveTo(48, 19, 48, 22);
			g.curveTo(48, 24, 46, 24);
			g.lineTo(5, 24);
			g.curveTo(1, 21, 0, 12);
			
			g.moveTo(10, 12);
			g.curveTo(10, 10, 12, 10);
			g.lineTo(43, 10);
			g.curveTo(45, 10, 45, 12);
			g.curveTo(45, 14, 43, 14);
			g.lineTo(12, 14);
			g.curveTo(10, 14, 10, 12);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawF():void
		{
			g.moveTo(0, 12);
			g.curveTo(1, 2, 8, 0);
			g.lineTo(46, 0);
			g.curveTo(48, 0, 48, 2);
			g.curveTo(48, 5, 45, 5);
			g.lineTo(10, 5);
			g.curveTo(6, 6, 5, 11);
			g.lineTo(5, 24);
			g.lineTo(2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 12);
			
			g.moveTo(10, 12);
			g.curveTo(10, 10, 12, 10);
			g.lineTo(43, 10);
			g.curveTo(45, 10, 45, 12);
			g.curveTo(45, 14, 43, 14);
			g.lineTo(12, 14);
			g.curveTo(10, 14, 10, 11);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawG():void
		{
			g.moveTo(0, 12);
			g.curveTo(1, 2, 8, 0);
			g.lineTo(46, 0);
			g.curveTo(48, 0, 48, 2);
			g.curveTo(48, 4, 46, 4);
			g.lineTo(11, 4);
			g.curveTo(5, 5, 5, 12);
			g.curveTo(5, 20, 9, 20);
			g.lineTo(41, 20);
			g.curveTo(44, 20, 44, 17);
			g.curveTo(44, 14, 41, 14);
			g.lineTo(17, 14);
			g.curveTo(16, 14, 15, 12);
			g.curveTo(16, 10, 17, 10);
			g.lineTo(43, 10);
			g.curveTo(48, 10, 48, 17);
			g.curveTo(48, 23, 45, 24);
			g.lineTo(5, 24);
			g.curveTo(0, 24, 0, 12);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawH():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			g.curveTo(5, 9, 11, 10);
			g.lineTo(36, 10);
			g.curveTo(40, 10, 41, 12);
			g.lineTo(41, 2);
			g.curveTo(41, 0, 44, 0);
			g.curveTo(46, 0, 46, 2);
			g.lineTo(46, 22);
			g.curveTo(46, 24, 44, 24);
			g.curveTo(41, 24, 41, 22);
			g.curveTo(41, 15, 35, 15);
			g.lineTo(9, 15);
			g.curveTo(5, 15, 5, 12);
			g.lineTo(5, 22);
			g.curveTo(5, 24, 2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 2);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawI():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			g.lineTo(5, 22);
			g.curveTo(5, 24, 2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 2);
			
			charSprite.charWidth = 5;
		}
		
		private static function drawJ():void
		{
			g.moveTo(43, 2);
			g.curveTo(43, 0, 45, 0);
			g.curveTo(48, 0, 48, 2);
			g.lineTo(48, 17);
			g.curveTo(47, 21, 42, 24);
			g.lineTo(4, 24);
			g.curveTo(0, 22, 0, 15);
			g.curveTo(0, 13, 2, 12);
			g.curveTo(5, 12, 5, 15);
			g.curveTo(5, 18, 9, 19);
			g.lineTo(39, 19);
			g.curveTo(43, 19, 43, 13);
			g.lineTo(43, 2);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawK():void
		{
			g.moveTo(5, 22);
			g.curveTo(5, 24, 2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			g.lineTo(5, 10);
			g.lineTo(25, 10);
			g.curveTo(35, 10, 43, 0);
			g.curveTo(46, 0, 46, 2);
			g.curveTo(41, 9, 32, 12);
			g.curveTo(41, 15, 46, 22);
			g.curveTo(46, 24, 44, 24);
			g.curveTo(35, 15, 27, 15);
			g.lineTo(5, 15);
			g.lineTo(5, 22);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawL():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			g.lineTo(5, 12);
			g.curveTo(5, 18, 9, 19);
			g.lineTo(45, 19);
			g.curveTo(48, 19, 48, 22);
			g.curveTo(48, 24, 46, 24);
			g.lineTo(5, 24);
			g.curveTo(0, 23, 0, 12);
			g.lineTo(0, 2);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawM():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			g.curveTo(9, 9, 25, 11);
			g.curveTo(38, 10, 45, 2);
			g.curveTo(45, 0, 47, 0);
			g.curveTo(50, 0, 50, 2);
			g.lineTo(50, 22);
			g.curveTo(50, 24, 47, 24);
			g.curveTo(45, 24, 45, 22);
			g.lineTo(45, 7);
			g.curveTo(41, 14, 25, 15);
			g.curveTo(9, 14, 5, 7);
			g.lineTo(5, 22);
			g.curveTo(5, 24, 2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 2);
			
			g.moveTo(25, 18);
			g.curveTo(22, 18, 22, 22);
			g.curveTo(22, 24, 25, 24);
			g.curveTo(28, 24, 28, 22);
			g.curveTo(28, 18, 25, 18);
			
			charSprite.charWidth = 50;
		}
		
		private static function drawN():void
		{
			g.moveTo(0, 8);
			g.curveTo(1, 2, 6, 0);
			g.lineTo(38, 0);
			g.curveTo(45, 1, 46, 9);
			g.lineTo(46, 22);
			g.curveTo(46, 24, 44, 24);
			g.curveTo(41, 24, 41, 22);
			g.lineTo(41, 10);
			g.curveTo(40, 5, 35, 5);
			g.lineTo(12, 5);
			g.curveTo(5, 5, 5, 12);
			g.lineTo(5, 22);
			g.curveTo(5, 24, 2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 12);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawO():void
		{
			g.moveTo(0, 8);
			g.curveTo(1, 2, 5, 0);
			g.lineTo(40, 0);
			g.curveTo(46, 1, 48, 9);
			g.lineTo(48, 16);
			g.curveTo(47, 22, 42, 24);
			g.lineTo(6, 24);
			g.curveTo(0, 24, 0, 12);
			g.lineTo(5, 12);
			g.curveTo(5, 18, 9, 20);
			g.lineTo(38, 20);
			g.curveTo(43, 20, 43, 12);
			g.curveTo(43, 5, 39, 4);
			g.lineTo(8, 4);
			g.curveTo(5, 5, 5, 12);
			g.lineTo(0, 12);
			g.lineTo(0, 8);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawP():void
		{
			g.moveTo(0, 10);
			g.lineTo(5, 10);
			g.lineTo(5, 4);
			g.lineTo(39, 4);
			g.curveTo(41, 4, 41, 7);
			g.curveTo(41, 10, 39, 10);
			g.lineTo(0, 10);
			g.lineTo(0, 15);
			g.lineTo(40, 15);
			g.curveTo(46, 15, 46, 7);
			g.curveTo(45, 1, 41, 0);
			g.lineTo(2, 0);
			g.curveTo(0,0, 0, 2);
			g.lineTo(0, 10);
			
			g.moveTo(0, 15);
			g.lineTo(0, 22);
			g.curveTo(0, 24, 2, 24);
			g.curveTo(5, 24, 5, 20);
			g.lineTo(5, 15);
			g.lineTo(0, 15);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawQ():void
		{
			g.moveTo(0, 8);
			g.curveTo(1, 2, 5, 0);
			g.lineTo(40, 0);
			g.curveTo(46, 1, 48, 9);
			g.lineTo(48, 16);
			g.curveTo(47, 22, 42, 24);
			g.lineTo(35, 24);
			g.curveTo(32, 21, 35, 19);
			g.lineTo(38, 19);
			g.curveTo(43, 19, 43, 12);
			g.curveTo(43, 5, 39, 4);
			g.lineTo(8, 4);
			g.curveTo(5, 5, 5, 12);
			g.curveTo(5, 18, 9, 19);
			g.lineTo(24, 19);
			g.curveTo(27, 19, 27, 22);
			g.curveTo(27, 24, 25, 24);
			g.lineTo(6, 24);
			g.curveTo(0, 22, 0, 12);
			g.lineTo(0, 8);
			
			g.moveTo(30, 11);
			g.curveTo(27, 11, 27, 14);
			g.curveTo(27, 17, 30, 17);
			g.curveTo(34, 17, 34, 14);
			g.curveTo(34, 11, 30, 11);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawR():void
		{
			g.moveTo(0, 6);
			g.curveTo(1, 1, 6, 0);
			g.lineTo(41, 0);
			g.curveTo(45, 1, 46, 7);
			g.curveTo(46, 9, 44, 9);
			g.curveTo(42, 9, 41, 7);
			g.curveTo(41, 5, 39, 4);
			g.lineTo(7, 4);
			g.curveTo(5, 5, 5, 7);
			g.lineTo(5, 10);
			g.lineTo(27, 10);
			g.curveTo(42, 11, 46, 21);
			g.curveTo(46, 24, 44, 24);
			g.lineTo(42, 24);
			g.curveTo(35, 14, 22, 15);
			g.lineTo(5, 15);
			g.lineTo(5, 24);
			g.lineTo(2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 6);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawS():void
		{
			g.moveTo(47, 2);
			g.curveTo(47, 0, 45, 0);
			g.lineTo(5, 0);
			g.curveTo(1, 1, 0, 7);
			g.curveTo(1, 13, 5, 14);
			g.lineTo(41, 14);
			g.curveTo(43, 14, 43, 17);
			g.curveTo(43, 19, 41, 19);
			g.lineTo(4, 19);
			g.curveTo(1, 19, 1, 22);
			g.curveTo(1, 24, 4, 24);
			g.lineTo(45, 24);
			g.curveTo(48, 22, 48, 17);
			g.curveTo(47, 10, 42, 9);
			g.lineTo(7, 9);
			g.curveTo(5, 9, 5, 7);
			g.curveTo(5, 5, 7, 5);
			g.lineTo(45, 5);
			g.curveTo(47, 5, 47, 2);
			
			charSprite.charWidth = 47;
		}
		
		private static function drawT():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(44, 0);
			g.curveTo(46, 0, 46, 2);
			g.curveTo(46, 4, 44, 5);
			g.lineTo(30, 5);
			g.curveTo(26, 5, 26, 10);
			g.lineTo(26, 22);
			g.curveTo(26, 24, 23, 24);
			g.curveTo(20, 24, 20, 22);
			g.lineTo(20, 9);
			g.curveTo(20, 6, 21, 5);
			g.lineTo(2, 5);
			g.curveTo(0, 5, 0, 2);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawU():void
		{
			g.moveTo(43, 2);
			g.curveTo(43, 0, 45, 0);
			g.curveTo(48, 0, 48, 2);
			g.lineTo(48, 17);
			g.curveTo(48, 21, 43, 24);
			g.lineTo(6, 24);
			g.curveTo(0, 22, 0, 15);
			g.lineTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			
			g.lineTo(5, 13);
			g.curveTo(5, 18, 9, 19);
			g.lineTo(39, 19);
			g.curveTo(43, 19, 43, 13);
			g.lineTo(43, 2);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawV():void
		{
			g.moveTo(0, 3);
			g.curveTo(0, 0, 1, 0);
			g.curveTo(4, 0, 5, 2);
			g.lineTo(19, 20);
			g.curveTo(21, 21, 23, 20);
			g.lineTo(37, 2);
			g.curveTo(38, 0, 41, 0);
			g.curveTo(43, 0, 42, 3);
			g.lineTo(27, 22);
			g.curveTo(24, 24, 21, 24);
			g.curveTo(17, 24, 15, 22);
			g.lineTo(0, 2);
			
			charSprite.charWidth = 42;
		}
		
		private static function drawW():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 2);
			g.lineTo(5, 12);
			g.curveTo(5, 18, 9, 20);
			g.lineTo(26, 20);
			g.curveTo(24, 18, 24, 15);
			g.lineTo(24, 2);
			g.curveTo(24, 0, 26, 0);
			g.curveTo(30, 0, 30, 2);
			g.lineTo(30, 15);
			g.curveTo(30, 18, 33, 20);
			g.lineTo(45, 20);
			g.curveTo(48, 18, 49, 14);
			g.lineTo(49, 2);
			g.curveTo(49, 0, 51, 0);
			g.curveTo(54, 0, 54, 2);
			g.lineTo(54, 15);
			g.curveTo(53, 22, 47, 24);
			g.lineTo(6, 24);
			g.curveTo(1, 22, 0, 15);
			g.lineTo(0, 2);
			
			charSprite.charWidth = 54;
		}
		
		private static function drawX():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.curveTo(15, 2, 17, 12);
			g.curveTo(16, 23, 2, 24);
			g.curveTo(0, 24, 0, 22);
			g.curveTo(0, 20, 2, 20);
			g.curveTo(11, 18, 12, 12);
			g.curveTo(11, 5, 2, 4);
			g.curveTo(0, 4, 0, 2);
			
			g.moveTo(24, 9);
			g.curveTo(27, 9, 27, 12);
			g.curveTo(27, 15, 24, 15);
			g.curveTo(20, 16, 20, 12);
			g.curveTo(20, 8, 24, 9);
			
			g.moveTo(44, 0);
			g.curveTo(48, 0, 48, 2);
			g.curveTo(48, 4, 45, 4);
			g.curveTo(36, 6, 35, 12);
			g.curveTo(36, 17, 45, 20);
			g.curveTo(48, 20, 48, 22);
			g.curveTo(48, 24, 44, 24);
			g.curveTo(30, 21, 30, 12);
			g.curveTo(30, 3, 44, 0);
			
			charSprite.charWidth = 48;
		}
		
		private static function drawY():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(3, 0);
			g.curveTo(5, 0, 5, 1);
			g.curveTo(9, 8, 24, 9);
			g.curveTo(37, 8, 44, 0);
			g.curveTo(47, 0, 47, 2);
			g.curveTo(39, 14, 24, 14);
			g.curveTo(5, 14, 0, 2);
			
			g.moveTo(25, 18);
			g.curveTo(22, 18, 22, 22);
			g.curveTo(22, 24, 25, 24);
			g.curveTo(28, 24, 28, 22);
			g.curveTo(28, 18, 25, 18);
			
			charSprite.charWidth = 47;
		}
		
		private static function drawZ():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(44, 0);
			g.curveTo(47, 1, 47, 5);
			g.curveTo(47, 9, 45, 9);
			g.lineTo(8, 20);
			g.lineTo(45, 20);
			g.curveTo(47, 20, 47, 22);
			g.curveTo(47, 24, 45, 24);
			g.lineTo(2, 24);
			g.curveTo(0, 24, 0, 22);
			g.curveTo(0, 16, 4, 15);
			g.lineTo(39, 5);
			g.lineTo(2, 5);
			g.curveTo(0, 5, 0, 2);
			
			charSprite.charWidth = 47;
		}
		
		private static function draw1():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(8, 0);
			g.curveTo(12, 1, 13, 6);
			g.lineTo(13, 22);
			g.curveTo(13, 24, 10, 24);
			g.curveTo(8, 24, 8, 22);
			g.lineTo(8, 7);
			g.curveTo(7, 5, 6, 5);
			g.lineTo(2, 5);
			g.curveTo(0, 5, 0, 2);
			
			charSprite.charWidth = 13;
		}
		
		private static function draw2():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(41, 0);
			g.curveTo(47, 1, 46, 7);
			g.curveTo(46, 14, 41, 15);
			g.lineTo(7, 15);
			g.curveTo(5, 15, 5, 17);
			g.lineTo(5, 20);
			g.lineTo(44, 20);
			g.curveTo(46, 20, 46, 22);
			g.curveTo(46, 24, 44, 24);
			g.lineTo(2, 24);
			g.curveTo(0, 24, 0, 22);
			g.lineTo(0, 15);
			g.curveTo(0, 10, 5, 10);
			g.lineTo(39, 10);
			g.curveTo(41, 9, 41, 7);
			g.curveTo(41, 5, 39, 5);
			g.lineTo(2, 5);
			g.curveTo(0, 5, 0, 2);
			
			charSprite.charWidth = 47;
		}
		
		private static function draw3():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.lineTo(41, 0);
			g.curveTo(46, 1, 46, 7);
			g.curveTo(46, 11, 45, 12);
			g.curveTo(46, 13, 46, 18);
			g.curveTo(46, 22, 42, 24);
			g.lineTo(2, 24);
			g.curveTo(0, 24, 0, 22);
			g.curveTo(0, 20, 2, 20);
			g.lineTo(40, 20);
			g.curveTo(42, 20, 42, 17);
			g.curveTo(42, 14, 39, 14);
			g.lineTo(9, 14);
			g.curveTo(7, 14, 7, 12);
			g.curveTo(7, 10, 9, 10);
			g.lineTo(40, 10);
			g.curveTo(42, 10, 42, 7);
			g.curveTo(42, 4, 39, 5);
			g.lineTo(2, 5);
			g.curveTo(0, 5, 0, 2);
			
			charSprite.charWidth = 46;
		}
		
		private static function draw4():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 0, 2, 0);
			g.curveTo(5, 0, 5, 2);
			g.lineTo(5, 9);
			g.curveTo(5, 12, 7, 12);
			g.lineTo(41, 12);
			g.lineTo(41, 2);
			g.curveTo(41, 0, 43, 0);
			g.curveTo(46, 0, 46, 2);
			g.lineTo(46, 22);
			g.curveTo(46, 24, 43, 24);
			g.curveTo(41, 24, 41, 22);
			g.lineTo(41, 17);
			g.lineTo(6, 17);
			g.curveTo(1, 16, 0, 10);
			g.lineTo(0, 2);
			
			charSprite.charWidth = 46;
		}
		
		private static function draw5():void
		{
			g.moveTo(47, 2);
			g.curveTo(47, 0, 45, 0);
			g.lineTo(2, 0);
			g.curveTo(0, 0, 0, 2);
			g.lineTo(0,8);
			g.curveTo(1, 13, 5, 14);
			g.lineTo(41, 14);
			g.curveTo(43, 14, 43, 17);
			g.curveTo(43, 19, 41, 19);
			g.lineTo(4, 19);
			g.curveTo(1, 19, 1, 22);
			g.curveTo(1, 24, 4, 24);
			g.lineTo(45, 24);
			g.curveTo(48, 22, 48, 17);
			g.curveTo(47, 10, 42, 9);
			g.lineTo(7, 9);
			g.curveTo(5, 9, 5, 7);
			g.lineTo(5, 5);
			g.lineTo(45, 5);
			g.curveTo(47, 5, 47, 2);
			
			charSprite.charWidth = 47;
		}
		
		private static function draw6():void
		{
			g.moveTo(0, 12);
			g.curveTo(1, 2, 8, 0);
			g.lineTo(46, 0);
			g.curveTo(48, 0, 48, 2);
			g.curveTo(48, 4, 46, 4);
			g.lineTo(11, 4);
			g.curveTo(5, 5, 5, 12);
			g.curveTo(5, 20, 9, 20);
			g.lineTo(41, 20);
			g.curveTo(44, 20, 44, 17);
			g.curveTo(44, 14, 41, 14);
			g.lineTo(17, 14);
			g.curveTo(16, 14, 16, 17);
			g.curveTo(16, 20, 18, 20);
			g.lineTo(12, 20);
			g.curveTo(11, 10, 17, 10);
			g.lineTo(43, 10);
			g.curveTo(48, 10, 48, 17);
			g.curveTo(48, 23, 45, 24);
			g.lineTo(5, 24);
			g.curveTo(0, 24, 0, 12);
			
			charSprite.charWidth = 48;
		}
		
		private static function draw7():void
		{
			g.moveTo(0, 2);
			g.curveTo(0, 5, 2, 5);
			g.lineTo(40, 5);
			g.curveTo(41, 7, 41, 7);
			g.curveTo(41, 9, 40, 9);
			g.lineTo(3, 20);
			g.curveTo(1, 20, 2, 23);
			g.curveTo(4, 24, 8, 23);
			g.lineTo(43, 13);
			g.curveTo(46, 13, 46, 7);
			g.curveTo(45, 1, 41, 0);
			g.lineTo(2, 0);
			g.curveTo(0, 0, 0, 2);
			
			charSprite.charWidth = 46;
		}
		
		private static function draw8():void
		{
			g.moveTo(9, 9);
			g.curveTo(4, 9, 4, 7);
			g.curveTo(4, 4, 9, 4);
			g.lineTo(36, 4);
			g.curveTo(41, 4, 41, 7);
			g.curveTo(41, 9, 36, 9);
			g.lineTo(9, 9);
			g.lineTo(9, 12);
			g.lineTo(36, 12);
			g.lineTo(44, 12);
			g.curveTo(46, 11, 46, 7);
			g.curveTo(45, 1, 41, 0);
			g.lineTo(5, 0);
			g.curveTo(0,0, 0, 5);
			g.curveTo(0, 11, 3, 12);
			g.lineTo(9, 12);
		
			g.moveTo(3, 12);
			g.curveTo(0, 14, 0, 18);
			g.curveTo(0, 24, 6, 24);
			g.lineTo(43, 24);
			g.curveTo(46, 22, 46, 17);
			g.curveTo(46, 14, 44, 12);
			g.lineTo(36, 15);
			g.curveTo(41, 15, 41, 18);
			g.curveTo(41, 20, 36, 20);
			g.lineTo(7, 20);
			g.curveTo(5, 20, 4, 17);
			g.curveTo(5, 15, 7, 15);
			g.lineTo(36, 15);
			g.lineTo(44, 12);
			g.lineTo(3, 12);
			
			charSprite.charWidth = 46;
		}
		
		private static function draw9():void
		{
			g.moveTo(0, 7);
			g.curveTo(0, 0, 5, 0);
			g.lineTo(44, 0);
			g.curveTo(46, 0, 46, 2);
			g.curveTo(46, 5, 44, 5);
			g.lineTo(7, 5);
			g.curveTo(5, 5, 5, 7);
			g.curveTo(5, 10, 7, 10);
			g.lineTo(41, 10);
			g.curveTo(46, 10, 46, 16);
			g.lineTo(46, 22);
			g.curveTo(46, 24, 44, 24);
			g.curveTo(41, 24, 41, 22);
			g.lineTo(41, 17);
			g.curveTo(41, 15, 39, 15);
			g.lineTo(6, 15);
			g.curveTo(0, 15, 0, 7);
			
			charSprite.charWidth = 46;
		}
		
		private static function drawPoint():void
		{
			g.moveTo(5, 18);
			g.curveTo(2, 18, 2, 22);
			g.curveTo(2, 24, 5, 24);
			g.curveTo(8, 24, 8, 22);
			g.curveTo(8, 18, 5, 18);
			
			charSprite.charWidth = 8;
		}
		
		private static function drawDoublePoint():void
		{
			g.moveTo(3, 0);
			g.curveTo(7, 0, 7, 4);
			g.curveTo(7, 7, 3, 7);
			g.curveTo(0, 7, 0, 4);
			g.curveTo(0, 0, 3, 0);
			
			g.moveTo(3, 17);
			g.curveTo(7, 17, 7, 21);
			g.curveTo(7, 24, 3, 24);
			g.curveTo(0, 24, 0, 21);
			g.curveTo(0, 17, 3, 17);
			
			charSprite.charWidth = 8;
		}
		
		private static function drawSlash():void
		{
			g.moveTo(12, 1);
			g.curveTo(13, 0, 16, 0);
			g.curveTo(17, 1, 17, 3);
			g.lineTo(5, 23);
			g.curveTo(4, 24, 1, 24);
			g.curveTo(0, 23, 0, 20);
			g.lineTo(12, 1);
			
			charSprite.charWidth = 17;
		}
		
		private static function drawStreep():void
		{
			g.moveTo(0, 12);
			g.curveTo(0, 10, 2, 10);
			g.lineTo(33, 10);
			g.curveTo(35, 10, 35, 12);
			g.curveTo(35, 14, 33, 14);
			g.lineTo(12, 14);
			g.curveTo(0, 14, 0, 12);
			
			charSprite.charWidth = 35;
		}
		
		private static function draw0():void
		{
			g.moveTo(0, 8);
			g.curveTo(1, 2, 5, 0);
			g.lineTo(40, 0);
			g.curveTo(46, 1, 48, 9);
			g.lineTo(48, 16);
			g.curveTo(47, 22, 42, 24);
			g.lineTo(6, 24);
			g.curveTo(0, 24, 0, 12);
			g.lineTo(5, 12);
			g.curveTo(5, 18, 9, 20);
			g.lineTo(38, 20);
			g.curveTo(43, 20, 43, 12);
			g.curveTo(43, 5, 39, 4);
			g.lineTo(8, 4);
			g.curveTo(5, 5, 5, 12);
			g.lineTo(0, 12);
			g.lineTo(0, 8);
			
			g.moveTo(8, 12);
			g.curveTo(8, 10, 12, 10);
			g.lineTo(38, 10);
			g.curveTo(40, 10, 40, 12);
			g.curveTo(40, 14, 38, 14);
			g.lineTo(12, 14);
			g.curveTo(8, 14, 8, 12);
			
			charSprite.charWidth = 48;
		}
	}
}