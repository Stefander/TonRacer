package svg
{	
	/**
	 * @class TonRacer SVG File Importer
	 * @description Deze class kan een SVG-bestand importeren, SVG is een opensource vectorgraphics bestand, deze kan
	 * geëxporteerd worden uit bijvoorbeeld Illustrator, en kan direct door deze loader ingeladen worden door het maken
	 * van een nieuwe instance van deze class.
	 * @author Stefan Wijnker en Helen Triolo
	**/
	
	// IMPORTS
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	
	// XML IMPORTS
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import XML;
	import XMLList;
	import flash.xml.XMLNode;
	import world.objects.Car;

	// CUSTOM IMPORTS
	import svg.SVGLoader;
	
	public class SVGFile extends Sprite
	{
		// PUBLIC
		public var collisionPoints:Array = new Array();		// Hier wordt de collision data ingestopt
		
		// PRIVATE
		private var xmlFile:XML = new XML();					// Hier wordt de SVG data ingestopt
		private var xmlLoader:URLLoader = new URLLoader();		// De loader waar we de SVG data mee gaan laden
		private var paths:XMLList;								// De path nodes van de SVG file
		public var holder:Sprite = new Sprite();				// Waar de paths op getekend worden
		private var fileLocation:String;
		private var toUpdate;								// Welke instance moet updaten als de physicsdata geladen is
		
		/**
		 * @method SVGFile ()
		 * @description De constructor voor het inladen van de SVG
		 * @param location (String) De locatie van het SVG-bestand
		 */
		public function SVGFile(location:String):void
		{
			fileLocation = location;
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			xmlLoader.load(new URLRequest(location));
			addChild(holder);
		}
		
		/**
		 * @method loadError ()
		 * @description Wordt gebruikt indien er een error is geconstateerd tijdens het laden van de SVG
		**/
		public function loadError(e:IOErrorEvent):void
		{
			var fileName:String = String(e.text).split("/")[String(e.text).split("/").length-1];
			trace("ERROR! \"" + fileName + "\" is niet gevonden");
		}
		
		public function pleaseUpdate(updateTarget:*):void
		{
			toUpdate = updateTarget;
		}
		
		/**
		 * @method xmlLoaded ()
		 * @description Deze functie wordt getriggered op het moment dat het SVG-bestand is ingeladen. Aangezien een SVG-
		 * bestand ongeveer hetzelfde ingedeeld is als een XML-bestand, kan deze op dezelfde manier worden ingeladen.
		**/
		private function xmlLoaded(e:Event):void
		{
			xmlFile = XML(xmlLoader.data);
			
			// Gebruik de namespaces van de SVG data
			if (xmlFile.namespace("") != undefined) { default xml namespace = xmlFile.namespace(""); }
			
			// Bepaal het aantal pathnodes en de g-tag indeling
			if (xmlFile.g.g.length() == 0)
				
				if (xmlFile.g.length() == 0)
					paths = XMLList(xmlFile);
				else
					paths = xmlFile.g;
			else
				paths = xmlFile.g.g;
				
			//paths = (xmlFile.g.g.length() == 0) ? (xmlFile.g.length xmlFile.g : xmlFile.g.g;
			
			// Loop door de g-nodes heen, parse de data en teken alles op het scherm
			for (var i:Number = 0; i < paths.length(); i++)
			{
				if (paths[i].@id.toXMLString() != "coll" && paths[i].@id.toXMLString() != "collision")
				{
					// Lijndikte van de huidige g-node
					var lineWeight:Number = SVGLoader.extractLineWidth(XMLList(paths[i]));
					holder.graphics.lineStyle(lineWeight, 0xffffff, 1);
					
					// Teken de pathnodes
					getShapes(i,holder);
				}
				else
				{
					getCollision(i);
				}
			}
			// Centeren die boel
			holder.x -= holder.width/2;
			holder.y -= holder.height/2;
		}

		/** 
		 * @method getShapes ()
		 * @description Teken de geparsete commando's uit de SVGLoader op het scherm
		 * @param iPath (Number) Index van de g-node
		**/
		private function getShapes(iPath:Number,target:Sprite):void
		{
			// Laad de tekencommando's uit de data
			var conv:Array = SVGLoader.returnCommands(XMLList(paths[iPath]));
			
			// Voor elke pathnode in de commando's
			for (var j:Number = 0; j < conv.length; j++)
			{
				// Voor elk commando binnen de pathnodes
				for (var i:Number = 0; i < conv[j].length; i++) 
				{	
					// Beslis wat te doen met de data op de huidige positie
					switch (conv[j][i][0])
					{
						case "F" :
							target.graphics.beginFill(0xffffff, 1);
							break;
						case "D" :
							// Ff een verzekering inbouwen voor als hij de waarde niet goed leest uit de SVG
							conv[j][i][1] = (conv[j][i][1] < 3) ? conv[j][i][1] : 2;
							target.graphics.lineStyle(conv[j][i][1], 0xffffff,1);
							break;
						case "M" :
							target.graphics.moveTo(conv[j][i][1][0], conv[j][i][1][1]);
							break;
						case "L" :
							target.graphics.lineTo(conv[j][i][1][0], conv[j][i][1][1]);
							break;
						case "C" :
							target.graphics.curveTo(conv[j][i][1][0], conv[j][i][1][1], conv[j][i][1][2], conv[j][i][1][3]);
							break;
					}
				}
			}
		}
		
		/**
		 * @method getCollision ()
		 * @description Deze functie wordt gebruikt zodra een path node layer name "coll" of "collision" is, laad deze in als collision data points voor de content manager in plaats van hem 
		 * te tekenen op het scherm
		 * @param	collNode (Number) De path node van
		**/
		public function getCollision(collNode:Number):void
		{
			var collPoints:Array = SVGLoader.returnCommands(XMLList(paths[collNode]));
			for (var coll:Number = 0; coll < collPoints.length; coll++)
			{
				for (var j:Number = 0; j < collPoints[coll].length-1; j++)
				{
					switch(collPoints[coll][j][0])
					{
						case "M":
							collisionPoints.push(new Point(collPoints[coll][j][1][0], collPoints[coll][j][1][1]));
							break;
						case "L":
							collisionPoints.push(new Point(collPoints[coll][j][1][0], collPoints[coll][j][1][1]));
							break;
						case "C":
							collisionPoints.push(new Point(collPoints[coll][j][1][0], collPoints[coll][j][1][2]));
							break;
					}
				}
			}
			
			if (toUpdate != null)
				toUpdate.setPhysData(collisionPoints);
		}
	}
}