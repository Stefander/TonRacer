package world.objects
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import physics.PhysConvexObject;
	import physics.PhysWorld;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class LotusShape extends Sprite
	{
		var bovenkant:Sprite = new Sprite();
		var onderkant:Sprite = new Sprite();
		var bovenkant2:Sprite = new Sprite();
		var onderkant2:Sprite = new Sprite();
		var lotusContainer:Sprite = new Sprite();
		public var collisionPoints:Array = new Array(	new Point( -10, 35), 
										new Point(120, 35), 
										new Point(130, 10),
										new Point(130, -10),
										new Point(120, -35), 
										new Point( -10, -35));
		
		public function LotusShape()
		{
			addChild(lotusContainer);
			
			bovenkant = drawLotus(4,1,0xffffff);
			bovenkant.y = -73;
			bovenkant.x -= bovenkant.width / 2;
			lotusContainer.addChild(bovenkant);
			
			onderkant = drawLotus(4,1,0xffffff);
			onderkant.scaleY = -1;
			onderkant.y = 73;
			onderkant.x -= onderkant.width / 2;
			lotusContainer.addChild(onderkant);
			var lotusScale:Number = 0.5;
			lotusContainer.x-=10;
			lotusContainer.scaleX = lotusScale;
			lotusContainer.scaleY = lotusScale;
		}
		
		public function drawLotus(line1Weight:Number,line2Weight:Number,color:uint):Sprite
		{
			var shapeMc:Sprite = new Sprite();
			// Je weet de Lotus Elise! :D
			
			// Buitenste rand
			shapeMc.graphics.lineStyle(line1Weight, color);
			shapeMc.graphics.moveTo(0, 73);
			shapeMc.graphics.curveTo(2, 19, 21, 12);
			shapeMc.graphics.curveTo(23, 9, 28, 5);
			shapeMc.graphics.lineTo(36, 2);
			shapeMc.graphics.lineTo(65, 1);
			shapeMc.graphics.curveTo(83, 0, 91, 8);
			shapeMc.graphics.moveTo(87, 5);
			shapeMc.graphics.curveTo(134, 11, 173, 10);
			shapeMc.graphics.curveTo(202, 11, 210, 8);
			shapeMc.graphics.moveTo(206, 12);
			shapeMc.graphics.curveTo(217, 4, 235, 5);
			shapeMc.graphics.curveTo(266, 6, 274, 16);
			shapeMc.graphics.curveTo(296, 32, 297, 73);
			
			// Binnenste graphics
			shapeMc.graphics.lineStyle(line2Weight, color);
			
			// Koplampen
			shapeMc.graphics.moveTo(274, 20);
			shapeMc.graphics.curveTo(260, 15, 264, 27);
			shapeMc.graphics.curveTo(266, 35, 276, 34);
			shapeMc.graphics.curveTo(287, 30, 274, 20);
			shapeMc.graphics.moveTo(270, 18);
			shapeMc.graphics.curveTo(265, 23, 270, 34);
			
			// Kleine lampje eronder
			shapeMc.graphics.moveTo(288, 41);
			shapeMc.graphics.curveTo(286, 31, 284, 41);
			shapeMc.graphics.curveTo(286, 51, 288, 41);
			shapeMc.graphics.moveTo(286, 36);
			shapeMc.graphics.curveTo(270, 41, 286, 45);
			
			// Hood detail
			shapeMc.graphics.moveTo(214, 36);
			shapeMc.graphics.curveTo(221, 30, 231, 34);
			shapeMc.graphics.lineTo(257, 42);
			shapeMc.graphics.curveTo(266, 44, 269, 55);
			shapeMc.graphics.lineTo(270, 73);
			
			shapeMc.graphics.moveTo(250, 72);
			shapeMc.graphics.curveTo(236, 73, 232, 61);
			shapeMc.graphics.lineTo(225, 45);
			shapeMc.graphics.curveTo(218, 33, 237, 38);
			shapeMc.graphics.lineTo(253, 44);
			shapeMc.graphics.curveTo(262, 46, 264, 55);
			shapeMc.graphics.curveTo(270, 73, 250, 72);
			
			// Luchtinlaat voorkant hood
			shapeMc.graphics.moveTo(260, 71);
			shapeMc.graphics.curveTo(252, 72, 252, 64);
			shapeMc.graphics.lineTo(250, 55);
			shapeMc.graphics.curveTo(248, 47, 257, 49);
			shapeMc.graphics.curveTo(263, 51, 265, 60);
			
			// Voorruit
			shapeMc.graphics.moveTo(196, 20);
			shapeMc.graphics.curveTo(224, 36, 227, 73);
			shapeMc.graphics.moveTo(170, 73);
			shapeMc.graphics.lineTo(170, 36);
			shapeMc.graphics.curveTo(174, 26, 196, 20);
			
			// Interieur in voorruit
			shapeMc.graphics.moveTo(193, 21);
			shapeMc.graphics.curveTo(195, 45, 195, 73);
			
			shapeMc.graphics.moveTo(199, 34);
			shapeMc.graphics.curveTo(192, 30, 199, 26);
			shapeMc.graphics.curveTo(206, 30, 199, 34);
			
			shapeMc.graphics.moveTo(198, 73);
			shapeMc.graphics.lineTo(198, 37);
			shapeMc.graphics.curveTo(200, 37, 203, 37);
			shapeMc.graphics.curveTo(216,50,218,73);
			
			shapeMc.graphics.moveTo(200, 73);
			shapeMc.graphics.lineTo(200, 39);
			shapeMc.graphics.curveTo(214, 50, 215, 73);
			
			shapeMc.graphics.moveTo(202, 25);
			shapeMc.graphics.curveTo(213,29,224,73);
			
			// Interieur en body details
			shapeMc.graphics.moveTo(185, 23);
			shapeMc.graphics.lineTo(123, 25);
			shapeMc.graphics.curveTo(112, 25, 110, 36);
			shapeMc.graphics.lineTo(109, 73);
			
			shapeMc.graphics.moveTo(196, 20);
			shapeMc.graphics.lineTo(117, 22);
			shapeMc.graphics.lineTo(109, 29);
			
			shapeMc.graphics.moveTo(104, 73);
			shapeMc.graphics.lineTo(104, 45);
			shapeMc.graphics.curveTo(104, 32, 108, 29);
			shapeMc.graphics.curveTo(111, 30, 112, 30);
			
			shapeMc.graphics.moveTo(106, 32);
			shapeMc.graphics.lineTo(56, 33);
			shapeMc.graphics.curveTo(83, 21, 117, 22);
			shapeMc.graphics.curveTo(112,12,118, 8);
			
			shapeMc.graphics.moveTo(100, 25);
			shapeMc.graphics.curveTo(90, 27, 100, 29);
			shapeMc.graphics.curveTo(110, 27, 100, 25);
			
			shapeMc.graphics.moveTo(97, 73);
			shapeMc.graphics.lineTo(97, 45);
			shapeMc.graphics.curveTo(97, 38, 86, 38);
			shapeMc.graphics.lineTo(52, 39);
			shapeMc.graphics.curveTo(18, 42, 18, 73);
			
			// Achterkant detail
			shapeMc.graphics.moveTo(14, 73);
			shapeMc.graphics.curveTo(14, 47, 19, 33);
			shapeMc.graphics.curveTo(20, 28, 20, 26);
			shapeMc.graphics.curveTo(19, 19, 33, 10);
			shapeMc.graphics.curveTo(14, 17, 8, 32);
			
			//shapeMc.graphics.lineTo(17, 42);
			shapeMc.graphics.lineTo(7, 53);
			shapeMc.graphics.lineTo(10, 57);
			shapeMc.graphics.lineTo(10, 64);
			
			// Achterkant detail in kofferbakdinges
			shapeMc.graphics.moveTo(86, 73);
			shapeMc.graphics.curveTo(86, 70, 81, 70);
			shapeMc.graphics.lineTo(32, 71);
			
			shapeMc.graphics.moveTo(94, 73);
			shapeMc.graphics.lineTo(94, 46);
			shapeMc.graphics.curveTo(94, 41, 88, 41);
			shapeMc.graphics.curveTo(52, 41, 38, 46);
			
			shapeMc.graphics.moveTo(91, 73);
			shapeMc.graphics.lineTo(91, 46);
			shapeMc.graphics.curveTo(92, 43, 87, 43);
			shapeMc.graphics.curveTo(48,43,38,48);
			
			// Extra vormlijnen
			shapeMc.graphics.moveTo(21, 24);
			shapeMc.graphics.curveTo(59, 23, 91, 18);
			
			shapeMc.graphics.moveTo(40, 11);
			shapeMc.graphics.lineTo(73, 10);
			
			shapeMc.graphics.moveTo(191, 16);
			shapeMc.graphics.curveTo(233, 16, 258, 20);
			
			return shapeMc;
		}
	}
}