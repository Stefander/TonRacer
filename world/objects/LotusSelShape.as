package world.objects
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class LotusSelShape extends MovieClip
	{
		var lotusSel:Sprite = new Sprite();
		
		public function LotusSelShape():void
		{
			lotusSel = drawLotusSelect();
			lotusSel.scaleX = 0.8;
			lotusSel.scaleY = 0.8;
			addChild(lotusSel);
		}
		
		public function drawLotusSelect():Sprite
		{
			var shapeMc:Sprite = new Sprite();
			// Je weet de Lotus Elise! :D
			var g:Graphics = shapeMc.graphics;
			
			g.lineStyle(2, 0xffffff);
			
			// Buitenste rand
			g.moveTo(203, 175);
			g.curveTo(237, 174, 269, 169);
			g.curveTo(278, 161, 297, 160);
			g.lineTo(342, 150);
			g.curveTo(357, 146, 362, 149);
			g.lineTo(381, 146);
			g.curveTo(396, 148, 396, 115);
			g.curveTo(396, 101, 391, 89);
			g.curveTo(391, 81, 382, 70);
			g.curveTo(373, 50, 363, 46);
			g.curveTo(347, 40, 306, 49);
			g.curveTo(292, 45, 294, 40);
			g.lineTo(311, 34);
			g.curveTo(315, 33, 312, 29);
			g.curveTo(308, 20, 297, 26);
			g.lineTo(282, 32);
			g.lineTo(258, 13);
			g.curveTo(242, 4, 205,10);
			g.curveTo(202, 3, 187, 5);
			g.curveTo(133, 8, 86, 25);
			g.curveTo(71, 32, 62, 42);
			g.curveTo(40, 46, 20, 56);
			g.curveTo(8, 63, 8, 73);
			g.curveTo(7, 89, 1, 105);
			g.curveTo(5, 111, 6, 118);
			g.curveTo(5, 150, 26, 174);
			g.lineTo(59,167);
			g.curveTo(63, 164, 63, 155);
			g.curveTo(79, 154, 128, 161);
			g.curveTo(130, 180, 157, 197);
			g.lineTo(191, 190);
			g.curveTo(204, 188, 203, 175);
			
			g.lineStyle(1, 0xffffff);
			
			// Koplampen
			// L
			g.moveTo(226, 118);
			g.curveTo(213, 122, 187, 107);
			g.curveTo(168, 92, 173, 88);
			g.curveTo(176, 84, 202, 95);
			g.curveTo(228, 112, 226, 118);
			
			// R
			g.moveTo(373, 90);
			g.curveTo(378, 91, 381, 72);
			g.curveTo(376, 58, 368, 51);
			g.curveTo(357, 57, 360, 69);
			g.curveTo(364, 82, 373, 90);
			
			// Kleine lampjes
			// L
			g.moveTo(256, 120);
			g.curveTo(252, 123, 238, 116);
			g.curveTo(231, 114, 225, 105);
			g.curveTo(238, 105, 245, 109);
			g.curveTo(258, 116, 256, 120);
			
			// R
			g.moveTo(358, 99);
			g.curveTo(350, 98, 348, 86);
			g.curveTo(348, 82, 354, 80);
			g.curveTo(360, 80, 362, 90);
			g.curveTo(363, 99, 358, 99);
			
			// Detail voorkant
			g.moveTo(275, 156);
			g.curveTo(244, 156, 238, 152);
			g.curveTo(222,146,222, 139);
			g.curveTo(221, 135, 235, 132);
			g.lineTo(260, 126);

			// Grill
			g.moveTo(260, 132);
			g.curveTo(259, 128, 272, 126);
			g.lineTo(353, 109);
			g.curveTo(360, 106, 361, 119);
			g.curveTo(363, 133, 320, 146);
			g.curveTo(268,156,260,132);

			// Voorruit
			g.moveTo(296, 48);
			g.curveTo(281, 30, 256, 15);
			g.curveTo(247, 9, 234, 11);
			g.curveTo(187, 16, 134, 31);
			g.curveTo(123, 35, 123, 45);
			g.curveTo(124, 60, 131, 77);
			g.curveTo(224, 67, 296, 48);
			
			// Voorruit frame 
			g.moveTo(204, 10);
			g.curveTo(147, 20, 128, 28);
			g.curveTo(117, 34, 117, 49);
			g.lineTo(120, 79);
			g.curveTo(122, 87, 113, 89);
			g.curveTo(106, 94, 77, 90);
			g.curveTo(43, 81, 37, 87);
			g.curveTo(34, 99, 57, 121);
			g.curveTo(85, 142, 124, 146);
			g.curveTo(71, 127, 54, 101);
			g.curveTo(51, 96, 53, 93);
			g.curveTo(55, 87, 68, 88);
			
			// Outline in het raam
			g.moveTo(210, 14);
			g.curveTo(218, 22, 228, 33);
			g.curveTo(231, 36, 254, 42);
			g.curveTo(263, 46, 296, 48);
			
			// Wielen silhouet
			// LV
			g.moveTo(127, 160);
			g.curveTo(124, 147 , 124, 140);
			g.curveTo(129, 113, 147, 105);
			g.curveTo(169, 129, 179, 157);
			g.curveTo(181, 167, 203, 175);
			
			// RV
			g.moveTo(362,149);
			g.curveTo(375, 145, 381, 137);
			g.curveTo(396, 112, 390, 88);
			
			// LA
			g.moveTo(63, 155);
			g.lineTo(52, 156);
			g.curveTo(41, 150, 40, 139);
			g.curveTo(31, 106, 19, 93);
			g.curveTo(10, 93, 6, 118);
			
			// Wielframes
			// LV
			g.moveTo(146, 118);
			g.curveTo(129, 125, 130, 151);
			g.curveTo(137, 183, 158, 187);
			g.curveTo(173, 184, 171, 153);
			g.curveTo(165, 120, 146, 118);
			
			// LA
			g.moveTo(16, 102);
			g.curveTo(10, 105, 10, 138);
			g.curveTo(15, 159, 26, 167);
			g.curveTo(35, 165, 33, 135);
			g.curveTo(26, 104, 16, 102);
			
			g.moveTo(73, 78);
			g.curveTo(41, 64, 20, 60);
			g.curveTo(13, 64, 5, 90);
			g.moveTo(20, 60);
			g.curveTo(40,63,52, 50);
			g.moveTo(153, 7);
			g.curveTo(93, 20, 87, 27);
			g.curveTo(85, 25, 77, 46);
			g.curveTo(74, 51, 71, 69);
			g.curveTo(53, 66, 46, 59);
			g.curveTo(51, 49, 61, 42);
			
			// Luchtinlaat voorruit
			// L
			g.moveTo(202,85);
			g.curveTo(219, 86, 254, 81);
			g.curveTo(250,70, 235, 66);
			g.curveTo(260, 69, 286, 90);
			g.moveTo(254,81);
			g.curveTo(259,80,259, 76);
			g.curveTo(266, 77, 271, 82);
			g.curveTo(220, 90, 184, 82);
			
			// R
			g.moveTo(296, 86);
			g.curveTo(271, 65, 260, 61);
			
			g.moveTo(282, 75);
			g.curveTo(308,67,306,56);
			
			
			return shapeMc;
		}
	}
}