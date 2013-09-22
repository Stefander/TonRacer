package sound
{
	/**
	 * @class TonRacer SoundManager
	 * @description Deze SoundManager heeft een aantal functies om geluiden af te spelen i.c.m. de ToneManager,
	 * deze class wordt ook gebruikt voor het maken van de achtergrondmuziek in het menu
	 * @author Stefan Wijnker
	**/
	
	// IMPORTS
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	// CUSTOM IMPORTS
	import sound.ToneManager;
	
	public class SoundManager extends Sprite
	{
		// PRIVATE
		private var toneManager:ToneManager = new ToneManager();	// Een instance van de ToneManager-class
		private var musicArray:Array 		= new Array();			// De array waar alle muziek in wordt gestopt
		private var bpmIndex:Number 		= 0;					// Huidige positie in de muziekarray
		private var currentMusic:Number;							// Welk nummer nu aan het afspelen is
		
		/**
		 * @method SoundManager ()
		 * @description Dit is de constructor van de SoundManager class
		**/
		public function SoundManager():void
		{
			// Initialiseer achtergrondmuziek
			
			// D-BLOCK & S-TE-FAN - THE NATURE OF OUR MIND
			// http://www.youtube.com/watch?v=58HUgtK7sHM
			musicArray.push(new Array( 	110, 30, 110, 30, 90, 80, 120, 40, 120, 40, 
										100, 90, 130, 45, 130, 45, 100, 90, 130, 40, 
										110, 40, 90, 40, 110, 30, 110, 30, 90, 80, 
										120, 40, 120, 40, 100, 90, 130, 45, 130, 45, 
										100, 90, 130, 40, 110, 40, 90, 40)); 
			
			// HEADHUNTERZ - POWER OF THE MIND
			// http://www.youtube.com/watch?v=OG0f_IEZ8mM
			musicArray.push(new Array(	80, 30, 80, 160, 155, 30, 155, 30, 130, 30,
										130, 115, 120, 30, 90, 100, 30, 70, 100, 90,
										100, 30, 100, 110, 120, 30, 130, 150, 90, 30,
										90, 30, 80, 30, 80, 160, 155, 30, 155, 30,
										130, 30, 130, 155, 120, 30, 100, 110, 120, 30,
										120, 110, 120, 30, 120, 110, 120, 30, 120, 110,
										90, 30, 90, 30 ));

			// HEADHUNTERZ - BLAME IT ON THE MUSIC
			// http://www.youtube.com/watch?v=2fUttI6cKdw
			musicArray.push(new Array(	80, 80, 90, 80, 100, 80, 110, 80, 120, 80,
										125, 80, 120, 80, 110, 80, 0, 80, 90, 80,
										100, 80, 90, 80, 100, 80, 90, 80, 100, 80,
										90, 80, 80, 80, 90, 80, 100, 80, 110, 80, 
										120, 80, 125, 80, 120, 80, 110, 80, 0, 80, 
										90, 80, 100, 80, 90, 80, 100, 80, 90, 80, 
										100, 80, 90, 80 ));

			// NOISECONTROLLERS - CONTROL ALT DELETE
			// http://www.youtube.com/watch?v=LmoQey2um0c
			musicArray.push(new Array(	155, 100, 155, 100, 155, 100, 155, 170, 150, 90, 
										145, 90, 140, 90, 130, 125, 120, 85, 130, 85, 
										135, 85, 145, 140, 130, 90, 140, 90, 145, 90, 
										150, 170, 155, 100, 150, 100, 145, 100, 155, 170, 
										150, 90, 145, 90, 140, 90, 130, 125, 120, 85, 
										130, 85, 135, 85, 130, 155, 130, 90, 140, 
										90, 150, 90, 165, 165 ));
										
			// FRANCESCO ZETA - FAIRYLAND
			// http://www.youtube.com/watch?v=RyWX0lpS11Y
			musicArray.push(new Array(	135, 70, 135, 70, 135, 70, 90, 70, 130, 65,
										130, 65, 130, 65, 100, 130, 135, 75, 135, 75,
										135, 75, 100, 75, 100, 70, 90, 70, 130, 70,
										130, 70, 135, 70, 135, 70, 135, 70, 90, 70, 
										130, 65, 130, 65, 130, 65, 100, 130, 135, 75, 
										135, 75, 135, 75, 100, 75, 100, 70, 90, 70, 
										130, 70, 130, 70 ));
			
			// Kies een willekeurig nummer om mee te beginnen
			currentMusic = Math.round(Math.random() * (musicArray.length - 1));
				
			// Hoe snel de noten achter elkaar komen (BPM), hier op 140
			var bpmCounter:Timer = new Timer(140);
			bpmCounter.addEventListener("timer", beat);
			
			// Start de timer
			bpmCounter.start();
		}
		
		/**
		 * @method menuChangeSound ()
		 * @description Dit is de functie voor als de speler met de pijltjestoetsen door het menu navigeert
		**/
		public function playSound(length:Number,pitch:Number):void
		{
			// Speel een korte lage noot af
			toneManager.speelNoot(length, pitch);
		}
		
		/**
		 * @method beat ()
		 * @description Deze method wordt aangeroepen op het moment dat er een nieuwe noot afgespeeld moet worden, dit wordt
		 * getriggered door de bpmCounter timer.
		**/
		private function beat(e:TimerEvent):void
		{
			// Als er een noot op deze plek staat
			if (musicArray[currentMusic][bpmIndex] != 0)
			{
				// En als de huidige positie niet verder is dan de lengte van de muziek
				if (bpmIndex < musicArray[currentMusic].length - 1)
				{
					// Speel de noot af en itereer de bpmIndex
					toneManager.speelNoot(1,musicArray[currentMusic][bpmIndex]+20);
					bpmIndex++;
				}
				else
				{
					// Anders gewoon resetten naar 0 en kies een ander muziekje uit
					bpmIndex = 0;
					currentMusic = Math.round(Math.random() * (musicArray.length-1));
				}
			}
			else
				bpmIndex++;
		}
	}
}