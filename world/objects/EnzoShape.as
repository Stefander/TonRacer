package world.objects
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class EnzoShape extends MovieClip
	{
		var bovenkant:Sprite = new Sprite();
		var onderkant:Sprite = new Sprite();
		var enzoContainer:Sprite = new Sprite();
		public var collisionPoints:Array = 	new Array(	new Point( -60, 35), 
														new Point(105, 35), 
														new Point(115, 10),
														new Point(115, -10),
														new Point(105, -35), 
														new Point( -60, -35));
		
		public function EnzoShape():void
		{
			var enzoScale:Number = 0.6;
			enzoContainer.scaleX = enzoScale;
			enzoContainer.scaleY = enzoScale;
			enzoContainer.x = -10;
			addChild(enzoContainer);
			bovenkant = drawEnzo();
			bovenkant.y = -71;
			bovenkant.x -= bovenkant.width / 2;
			enzoContainer.addChild(bovenkant);
			
			onderkant = drawEnzo();
			onderkant.scaleY = -1;
			onderkant.y = 71;
			onderkant.x -= onderkant.width / 2;
			enzoContainer.addChild(onderkant);
		}
		
		public function drawEnzo():Sprite
		{
			var shapeMc:Sprite = new Sprite();
			// Je weet de Ferrari Enzo! :D
			
			shapeMc.graphics.lineStyle(3, 0xffffff);
			
			// Outline
			shapeMc.graphics.moveTo(2, 71);
			shapeMc.graphics.lineTo(2, 66);
			shapeMc.graphics.lineTo(0, 62);
			shapeMc.graphics.curveTo(1, 29, 6, 28);
			shapeMc.graphics.curveTo(8,13,13,12);
			shapeMc.graphics.curveTo(25, 7, 97, 8);
			shapeMc.graphics.lineTo(193, 10);
			shapeMc.graphics.moveTo(201, 10);
			shapeMc.graphics.lineTo(234, 10);
			shapeMc.graphics.curveTo(243, 10, 264, 18);
			shapeMc.graphics.curveTo(276, 21, 279, 31);
			shapeMc.graphics.curveTo(285, 60, 289, 63);
			shapeMc.graphics.curveTo(291, 65, 291, 71);
			
			// Dunnere lijn
			shapeMc.graphics.lineStyle(1, 0xfffffff);
			
			// Body shapes
			shapeMc.graphics.moveTo(289, 63);
			shapeMc.graphics.curveTo(235, 39, 183, 27);
			shapeMc.graphics.curveTo(149, 23, 116, 27);
			
			shapeMc.graphics.moveTo(217, 11);
			shapeMc.graphics.curveTo(236, 12, 269, 22);
			shapeMc.graphics.curveTo(276, 41, 279, 71);
			
			shapeMc.graphics.moveTo(261, 17);
			shapeMc.graphics.curveTo(274, 17, 277, 36);
			shapeMc.graphics.lineTo(283, 58);
			shapeMc.graphics.curveTo(237, 36, 185, 26);
			
			shapeMc.graphics.moveTo(221, 35);
			shapeMc.graphics.curveTo(250, 36, 270, 34);
			shapeMc.graphics.curveTo(224, 32, 186, 24);
			
			// Voorruit
			shapeMc.graphics.moveTo(165, 71);
			shapeMc.graphics.lineTo(165, 42);
			shapeMc.graphics.curveTo(172, 34, 182, 30);
			shapeMc.graphics.curveTo(211, 36, 211, 71);
			
			// Voorruit frame
			shapeMc.graphics.moveTo(216, 71);
			shapeMc.graphics.curveTo(214, 40, 199, 34);
			shapeMc.graphics.lineTo(180, 28);
			
			// Hood detail
			shapeMc.graphics.moveTo(243, 42);
			shapeMc.graphics.curveTo(243, 36, 247, 36);
			shapeMc.graphics.moveTo(253, 35);
			shapeMc.graphics.curveTo(257, 37, 257, 47);
			
			// Headlights
			shapeMc.graphics.moveTo(267, 29);
			shapeMc.graphics.lineTo(248, 28);
			shapeMc.graphics.curveTo(242, 28, 242, 22);
			shapeMc.graphics.curveTo(240, 18, 247, 18);
			shapeMc.graphics.lineTo(263, 23);
			shapeMc.graphics.curveTo(267, 24, 267, 29);	
			shapeMc.graphics.moveTo(247, 28);
			shapeMc.graphics.lineTo(244, 17);
			shapeMc.graphics.moveTo(245, 22);
			shapeMc.graphics.lineTo(260, 22);
			shapeMc.graphics.lineTo(261, 29);
			
			// Dak detail
			shapeMc.graphics.moveTo(118, 61);
			shapeMc.graphics.lineTo(154, 61);
			shapeMc.graphics.curveTo(161, 61, 161, 53);
			
			shapeMc.graphics.moveTo(154, 37);
			shapeMc.graphics.lineTo(160, 27);
			shapeMc.graphics.curveTo(129, 26, 124, 39);
			
			shapeMc.graphics.moveTo(121, 39);
			shapeMc.graphics.curveTo(128, 26, 153, 25);
			
			shapeMc.graphics.moveTo(162, 35);
			shapeMc.graphics.lineTo(158, 35);
			shapeMc.graphics.curveTo(159, 31, 162, 27);
		
			shapeMc.graphics.curveTo(169, 28, 175, 28);
			shapeMc.graphics.curveTo(167, 31, 162, 35);
			
			shapeMc.graphics.moveTo(119, 14);
			shapeMc.graphics.lineTo(119, 9);
			
			shapeMc.graphics.moveTo(181, 14);
			shapeMc.graphics.lineTo(181, 9);
			
			shapeMc.graphics.moveTo(186, 17);
			shapeMc.graphics.lineTo(187, 11);
			
			// Lijn achterbak
			shapeMc.graphics.moveTo(46, 49);
			shapeMc.graphics.curveTo(75, 35, 106, 29);
			
			// Lijn uitlaat
			shapeMc.graphics.moveTo(59, 32);
			shapeMc.graphics.curveTo(59, 35, 16, 45);
			
			shapeMc.graphics.moveTo(102, 31);
			shapeMc.graphics.curveTo(99, 31, 98, 36);
			shapeMc.graphics.curveTo(99, 39, 104, 37);
			shapeMc.graphics.curveTo(109, 36, 108, 33);
			shapeMc.graphics.curveTo(107, 30, 102, 31);
			
			shapeMc.graphics.moveTo(107, 25);
			shapeMc.graphics.lineTo(99, 11);
			shapeMc.graphics.lineTo(103, 10);
			shapeMc.graphics.lineTo(106, 17);
			shapeMc.graphics.lineTo(103, 19);
			shapeMc.graphics.moveTo(106, 17);
			shapeMc.graphics.lineTo(119, 14);
			
			shapeMc.graphics.moveTo(3, 66);
			shapeMc.graphics.curveTo(4, 32, 7, 27);
			
			shapeMc.graphics.moveTo(11, 32);
			shapeMc.graphics.curveTo(8, 38, 8, 71);
			
			shapeMc.graphics.moveTo(11, 32);
			shapeMc.graphics.curveTo(7, 34, 6, 71);
			
			shapeMc.graphics.moveTo(11, 32);
			shapeMc.graphics.curveTo(21, 31, 21, 28);
			shapeMc.graphics.curveTo(21, 24, 13, 24);
			shapeMc.graphics.curveTo(10, 24, 9, 28);
			shapeMc.graphics.curveTo(9, 32, 11, 32);
			shapeMc.graphics.lineTo(13, 24);
			shapeMc.graphics.lineTo(16, 14);
			shapeMc.graphics.moveTo(23, 18);
			shapeMc.graphics.curveTo(23, 14, 16, 14);
			shapeMc.graphics.curveTo(12, 15, 12, 19);
			shapeMc.graphics.curveTo(12, 22, 16, 22);
			shapeMc.graphics.curveTo(23,21,23,18);
			
			shapeMc.graphics.moveTo(40, 32);
			shapeMc.graphics.lineTo(40, 39);
			
			// Plate detail
			shapeMc.graphics.moveTo(199, 34);
			shapeMc.graphics.curveTo(200, 31, 206, 31);
			
			shapeMc.graphics.moveTo(161, 71);
			shapeMc.graphics.curveTo(161, 39, 163, 37);
			shapeMc.graphics.lineTo(180, 28);
			shapeMc.graphics.curveTo(186, 29, 186, 19);
			shapeMc.graphics.curveTo(186, 14, 177, 14);
			shapeMc.graphics.curveTo(150, 10, 120, 14);
			shapeMc.graphics.curveTo(115, 15, 115, 20);
			shapeMc.graphics.curveTo(115, 27, 118, 39);
			shapeMc.graphics.lineTo(118, 71);
			
			shapeMc.graphics.moveTo(163, 37);
			shapeMc.graphics.lineTo(118, 39);
			shapeMc.graphics.curveTo(82, 40, 62, 45);
			shapeMc.graphics.curveTo(44, 49, 44, 71);
			
			shapeMc.graphics.moveTo(115, 24);
			shapeMc.graphics.curveTo(70, 29, 14, 32);
			shapeMc.graphics.curveTo(87, 32, 107, 25);
			
			shapeMc.graphics.moveTo(20, 71); 
			shapeMc.graphics.curveTo(23, 8, 34, 8);
			
			shapeMc.graphics.moveTo(11, 71);
			shapeMc.graphics.curveTo(11, 34, 14, 32);
			
			// Achterkant achterklep ding
			shapeMc.graphics.moveTo(110, 71);
			shapeMc.graphics.lineTo(110, 50);
			shapeMc.graphics.curveTo(110, 46, 103, 46);
			shapeMc.graphics.lineTo(66, 50);
			shapeMc.graphics.curveTo(47, 55, 46, 71);
			
			shapeMc.graphics.moveTo(111, 40);
			shapeMc.graphics.curveTo(111, 44, 105, 44);
			shapeMc.graphics.lineTo(65, 47);
			shapeMc.graphics.curveTo(59, 48, 59, 46);
			
			shapeMc.graphics.moveTo(115, 24);
			shapeMc.graphics.curveTo(70, 30, 10, 32);
			
			// Voorkant logo
			shapeMc.graphics.moveTo(287, 71);
			shapeMc.graphics.curveTo(287, 69, 285, 69);
			shapeMc.graphics.curveTo(283, 69, 283, 71);
			
			// Spiegel
			shapeMc.graphics.moveTo(200, 18);
			//shapeMc.graphics.curveTo(203, 18, 201, 13);
			shapeMc.graphics.curveTo(203,18,200, 10);
			shapeMc.graphics.lineStyle(2, 0xffffff);
			shapeMc.graphics.curveTo(197, 0, 191, 1);
			shapeMc.graphics.lineTo(194, 10);
			shapeMc.graphics.lineStyle(1, 0xffffff);
			shapeMc.graphics.curveTo(196, 19, 200, 18);
			
			shapeMc.graphics.moveTo(196, 14);
			shapeMc.graphics.lineTo(201,13);
			
			return shapeMc;
		}
		
	}
}