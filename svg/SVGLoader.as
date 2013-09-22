package svg
{
	public class SVGLoader
	{
		/**
		 * @class TonRacer AS3 Illustrator CS3 (13.0) SVG Loader
		 * @author Stefan Wijnker, Helen Triolo
		 * @description Deze class parset de SVG shape data van de file die ingeladen is, voor elke G node die er in de file
		 * te vinden is. Tevens worden alle objecten uit Illustrator 13.0 (spheres, polygons, polylines, lines, ellipsen en 
		 * vierkanten) geprocessed, evenals de lijndiktes in zowel de node als het tekenpathnode zelf. Basiscode van Helen is
		 * in AS2 en bevat slechts het inladen van de paths. Toevoegingen naast het porten naar AS3:
		 * 
		 * - Support voor Illustrator 13.0 objecten (spheres, polygons, polylines, lines, ellipsen en vierkanten)
		 * - Support voor alle soorten SVG exports van Illustrator CS3
		 * - Support voor lijndiktes in zowel de layer als de node zelf
		 * - Collision data extraction voor de PhysWorld & TonGame
		 * - Automatisch centeren van de geproduceerde afbeelding
		 * 
		 * @source Originele source: http://www.flash-creations.com/notes/sample_svgtoflash.php
		**/
		
		// Imports
		import flash.geom.Point;
		import math.CustomMath;
		import XMLList;
		
		/**
		 * @method returnCommands ()
		 * @description Geeft alle tekenopdrachten in de node voor de loader in een array terug zodat deze
		 * direct op het scherm getekend kunnen worden
		 * @param svgNode (XMLList) De XML data voor deze data paths
		**/
		public static function returnCommands(svgNode:XMLList):Array
		{
			// Maak een array voor alle tags in deze node
			var commandArray:Array = new Array();
			
			// Extract alle tekencommands
			var extractCommands:Array = extractCmds(svgNode);
			
			// Loop door alle paths heen in de node
			for (var i:Number = 0; i < extractCommands.length; i++)
			{
				commandArray.push(makeDrawCmds(extractCommands[i]));
			}
			
			return commandArray;
		}
		
		/**
		 * @method extractLineWidth ()
		 * @description Deze functie haalt de waarde van de lijndikte uit de XML data
		 * @param node (XMLList) De gewenste lijndikte zal uit deze XML data gehaald worden
		**/
		public static function extractLineWidth(node:XMLList):Number
		{
			// Als het niet goed gaat, zet standaard de lijndikte op 1
			var output:Number = 1;
			
			// Extract alle properties uit de @style tag
			if (node.@style != null)
			{
				// Scheid alle properties van elkaar (door middel van de puntkomma)
				var properties:Array = String(node.@style).split(";");
				for (var p:Number = 0; p < properties.length; p++)
				{
					// Aangezien stroke-width de enige property is die ik voor mijn loader nodig heb, gebruik deze
					if (properties[p].indexOf("stroke-width") != -1)
					{
						var tempArray:Array = String(properties[p]).split(":");
						output = tempArray[1];
					}
				}
			}
			
			return output;
		}
	
		/**
		 * @method strReplace ()
		 * @description Vervangt sFind met sReplace in inputString s
		 * @param	s (String) String die gemanipuleerd zal worden
		 * @param	sFind (String) Waar de string naar moet zoeken
		 * @param	sReplace (String) Waar dit vervolgens in veranderd wordt
		**/
		private static function strReplace(s:String, sFind:String, sReplace:String):String 
		{	return s.split(sFind).join(sReplace); }
		
		/**
		 * @method extractCmds ()
		 * @description Deze functie parset de path data zodat het makkelijker leesbaar wordt, alle entries worden 
		 * opgesplitst in arrays en alle foute symbolen worden eruit gehaald, verder worden (voor zover ik weet) alle
		 * bruikbare nodes die Illustrator CS3 heeft ingelezen
		 * @param node (XMLList) De XML data
		**/
		public static function extractCmds(node:XMLList):Array 
		{
			var i:Number;
			var startColor:Number;
			var thisColor:Number;
			
			// alle properties van de XML node
			var dstring:String = "";
			// Maak een tijdelijke dstring aan voor de data uit de d-property
			var tempDString:String = "";
			
			var returnArray:Array = new Array();
			
			// Illustrator 13 bestanden hebben heerlijk veel verschillende nodes, hier maar de belangrijkste
			var pathSearch:RegExp = /(<path.*?\/>)/sig;
			var pathArray:Array = node.toXMLString().match(pathSearch);
			
			var rectSearch:RegExp = /(<rect.*?\/>)/sig;
			var rectArray:Array = node.toXMLString().match(rectSearch);
			
			var lineSearch:RegExp = /(<line.*?\/>)/sig;
			var lineArray:Array = node.toXMLString().match(lineSearch);
			
			var circleSearch:RegExp = /(<circle.*?\/>)/sig;
			var circleArray:Array = node.toXMLString().match(circleSearch);
			
			var ellipseSearch:RegExp = /(<ellipse.*?\/>)/sig;
			var ellipseArray:Array = node.toXMLString().match(ellipseSearch);
			
			var polygonSearch:RegExp = /(<polygon.*?\/>)/sig;
			var polygonArray:Array = node.toXMLString().match(polygonSearch);
			
			var polyCount:Number = polygonArray.length;
			
			var polyLineSearch:RegExp = /(<polyline.*?\/>)/sig;
			var polyLineArray:Array = node.toXMLString().match(polyLineSearch);
			
			// Merge de twee laatste arrays, zijn technisch gezien hetzelfde
			for (var pLine:Number = 0; pLine < polyLineArray.length; pLine++)
			{
				polygonArray.push(polyLineArray[pLine]);
			}
			
			// Zoek eerst maar ff de ellipsen die het kutste zijn om te tekenen
			for (var sp:Number = 0; sp < ellipseArray.length; sp++)
			{
				var tempSphereValue:String;
				var ellipseCenterX:Number;
				var ellipseCenterY:Number;
				var ellipseRadiusX:Number;
				var ellipseRadiusY:Number;
				var testValue:Number = 1;
				var ellipseWeight:Number = 1;
				
				var sphereProps:Array = ellipseArray[sp].split(" ");
				for (var o:Number = 0; o < sphereProps.length; o++)
				{
					if (String(sphereProps[o]).indexOf("cx=") != -1)
					{
						tempSphereValue = String(sphereProps[o].replace("\"", "")).substr(3);
						ellipseCenterX = Number(tempSphereValue.substr(0, tempSphereValue.length - 1));
					}
					
					if (String(sphereProps[o]).indexOf("cy=") != -1)
					{
						tempSphereValue = String(sphereProps[o].replace("\"", "")).substr(3);
						ellipseCenterY = Number(tempSphereValue.substr(0, tempSphereValue.length - 1));
					}
					
					if (String(sphereProps[o]).indexOf("stroke-width=") != -1)
					{
						tempSphereValue = String(sphereProps[o].replace("\"", "")).substr(13);
						ellipseWeight = Number(tempSphereValue.substr(0, tempSphereValue.length - 1));
					}
					
					if (String(sphereProps[o]).indexOf("ry=") != -1)
					{
						tempSphereValue = String(sphereProps[o].replace("\"", "")).substr(3);
						tempSphereValue = String(tempSphereValue.replace("/>", ""));
						ellipseRadiusY = Number(tempSphereValue.substr(0, tempSphereValue.length - 1));
					}
					
					if (String(sphereProps[o]).indexOf("rx=") != -1)
					{
						tempSphereValue = String(sphereProps[o].replace("\"", "")).substr(3);
						ellipseRadiusX = Number(tempSphereValue.substr(0, tempSphereValue.length - 1));
					}
				}
				
				// Splits de tekencommando's ff in 2en omdat het anders te lang wordt
				tempDString = "D," + ellipseWeight + ",M," + (ellipseCenterX - ellipseRadiusX) + "," + ellipseCenterY + ",Q," + (ellipseCenterX - ellipseRadiusX) + "," + (ellipseCenterY - ellipseRadiusY) + "," + ellipseCenterX + "," + (ellipseCenterY - ellipseRadiusY) + ",Q," + (ellipseCenterX + ellipseRadiusX) + "," + (ellipseCenterY - ellipseRadiusY) + "," + (ellipseCenterX + ellipseRadiusX) + "," + ellipseCenterY + ",Q,"; 
				tempDString = tempDString + (ellipseCenterX + ellipseRadiusX) + "," + (ellipseCenterY + ellipseRadiusY) + "," + ellipseCenterX + "," + (ellipseCenterY + ellipseRadiusY) + ",Q," + (ellipseCenterX-ellipseRadiusX) + "," + (ellipseCenterY+ellipseRadiusY) + "," + (ellipseCenterX-ellipseRadiusX) + "," + (ellipseCenterY);
				returnArray.push(tempDString.split(","));
			}
			
			// Zoek de cirkels
			for (var cir:Number = 0; cir < circleArray.length; cir++)
			{
				var circleRadius:Number;
				var circleX:Number;
				var circleY:Number;
				var tempCircValue:String;
				var circleWeight:Number = 1;
				
				var circleProps:Array = circleArray[cir].split(" ");
				
				for (var r:Number = 0; r < circleProps.length; r++)
				{
					if (String(circleProps[r]).indexOf("cy=") != -1)
					{
						tempCircValue = String(circleProps[r].replace("\"", "")).substr(3);
						circleY = Number(tempCircValue.substr(0, tempCircValue.length - 1));
					}
					
					if (String(circleProps[r]).indexOf("stroke-width=") != -1)
					{
						tempCircValue = String(circleProps[r].replace("\"", "")).substr(13);
						circleWeight = Number(tempCircValue.substr(0, tempCircValue.length - 1));
					}
					
					if (String(circleProps[r]).indexOf("cx=") != -1)
					{
						tempCircValue = String(circleProps[r].replace("\"", "")).substr(3);
						circleX = Number(tempCircValue.substr(0, tempCircValue.length - 1));
					}
					
					if (String(circleProps[r]).indexOf("r=") != -1)
					{
						tempCircValue = String(circleProps[r].replace("\"", "")).substr(2);
						tempCircValue = String(tempCircValue.replace("/>", ""));
						circleRadius = Number(tempCircValue.substr(0, tempCircValue.length - 1));
					}
				}
				
				// Jat m ff lekker van de ellips
				tempDString = "D,"+circleWeight+",M," + (circleX - circleRadius) + "," + circleY + ",Q," + (circleX - circleRadius) + "," + (circleY - circleRadius) + "," + circleX + "," + (circleY - circleRadius) + ",Q," + (circleX + circleRadius) + "," + (circleY - circleRadius) + "," + (circleX + circleRadius) + "," + circleY + ",Q,"; 
				tempDString = tempDString + (circleX + circleRadius) + "," + (circleY + circleRadius) + "," + circleX + "," + (circleY + circleRadius) + ",Q," + (circleX-circleRadius) + "," + (circleY+circleRadius) + "," + (circleX-circleRadius) + "," + (circleY);
				
				returnArray.push(tempDString.split(","));
			}
			
			// Doe s ff zoeken naar polygons
			for (var poly:Number = 0; poly < polygonArray.length; poly++)
			{
				polygonArray[poly] = strReplace(polygonArray[poly], "&#xD;", "");
				polygonArray[poly] = strReplace(polygonArray[poly], "&#xA;", "");
				polygonArray[poly] = strReplace(polygonArray[poly], "\"", "");
				polygonArray[poly] = strReplace(polygonArray[poly], "/>", "");
				polygonArray[poly] = strReplace(polygonArray[poly], "&#x9;", "");
				
				var polyProps:Array = polygonArray[poly].split("=");
				var polyPointsIndex:Number;
				var polyWidthIndex:Number;
				
				var polyWidth:Number = 1;
					
				for (var d:Number = 0; d < polyProps.length; d++)
				{
					if (polyProps[d].search("points") != -1)
					{	
						polyPointsIndex = d + 1;
					}
					
					if (String(polyProps[d]).search("stroke-width") != -1)
					{	
						polyWidthIndex = d + 1;
						polyWidth = Number(strReplace(polyProps[polyWidthIndex], "\"", ""));
					}
				}
				
				var tempPolyPoints:String = polyProps[polyPointsIndex];
				
				if (tempPolyPoints != null)
				{
					var tempPolyArray:Array = tempPolyPoints.split(" ");
					
					var movePolySplit:Array = tempPolyArray[0].split(",");
					
					tempDString = "D," + polyWidth + ",M," + movePolySplit[0] + "," + movePolySplit[1];
					
					for (var pol:Number = 1; pol < tempPolyArray.length; pol++)
					{
						var polyPair:Array = tempPolyArray[pol].split(",");
						
						if (polyPair.length > 1)
						{
							tempDString += ",L," + polyPair[0] + "," + polyPair[1];
						}
					}
					
					if(poly < polyCount)
						tempDString += ",L," + movePolySplit[0] + "," + movePolySplit[1];
						
					returnArray.push(tempDString.split(","));
				}
			}
			
			// Loop door de rects heen
			for (var rect:Number = 0; rect < rectArray.length; rect++)
			{
				var rectPropArray:Array = String(rectArray[rect]).split(" ");
				var rectX1:Number;
				var rectY1:Number;
				var rectX2:Number;
				var rectY2:Number;
				var tempValue:String;
				var lineWeight:Number;

				for (var a:Number = 0; a < rectPropArray.length; a++)
				{
					if (String(rectPropArray[a]).indexOf("x=") != -1)
					{
						tempValue = String(rectPropArray[a].replace("\"", "")).substr(2);
						rectX1 = Number(tempValue.substr(0,tempValue.length-1));
					}
					
					if (String(rectPropArray[a]).indexOf("stroke-width=") != -1)
					{
						tempValue = String(rectPropArray[a].replace("\"", "")).substr(13);
						lineWeight = Number(tempValue.substr(0,tempValue.length-1));
					}
						
					if (String(rectPropArray[a]).indexOf("y=") != -1)
					{
						tempValue = String(rectPropArray[a].replace("\"", "")).substr(2);
						rectY1 = Number(tempValue.substr(0,tempValue.length-1));
					}
						
					if (String(rectPropArray[a]).indexOf("width=") != -1)
					{
						tempValue = String(rectPropArray[a].replace("\"", "")).substr(6);
						rectX2 = rectX1 + Number(tempValue.substr(0,tempValue.length-1));
					}
						
					if (String(rectPropArray[a]).indexOf("height=") != -1)
					{
						tempValue = String(rectPropArray[a].replace("\"", "")).substr(7);
						rectY2 = rectY1 + Number(tempValue.substr(0, tempValue.indexOf("\"")));
					}
				}
				
				tempDString = "D,"+ lineWeight +",M," + rectX1 + "," + rectY1 + ",L," + rectX2 + "," + rectY1 + ",L," + rectX2 + "," + rectY2 + ",L," + rectX1 + "," + rectY2 + ",L," + rectX1 + "," + rectY1;
				returnArray.push(tempDString.split(","));
			}
			
			// Loop door de lines heen
			for (var line:Number = 0; line < lineArray.length; line++)
			{
				var linePropArray = String(lineArray[line]).split(" ");
				var lineX1:Number;
				var lineY1:Number;
				var lineX2:Number;
				var lineY2:Number;
				var lineValue:String;
				var lWeight:Number;

				for (var b:Number = 0; b < linePropArray.length; b++)
				{
					if (String(linePropArray[b]).indexOf("x1=") != -1)
					{
						lineValue = String(linePropArray[b].replace("\"", "")).substr(3);
						lineX1 = Number(lineValue.substr(0, lineValue.length - 1));
					}
					
					if (String(linePropArray[b]).indexOf("stroke-width=") != -1)
					{
						lineValue = String(linePropArray[b].replace("\"", "")).substr(13);
						lWeight = Number(lineValue.substr(0,lineValue.length-1));
					}
						
					if (String(linePropArray[b]).indexOf("y1=") != -1)
					{
						lineValue = String(linePropArray[b].replace("\"", "")).substr(3);
						lineY1 = Number(lineValue.substr(0,lineValue.length-1));
					}
						
					if (String(linePropArray[b]).indexOf("x2=") != -1)
					{
						lineValue = String(linePropArray[b].replace("\"", "")).substr(3);
						lineX2 = Number(lineValue.substr(0,lineValue.length-1));
					}
						
					if (String(linePropArray[b]).indexOf("y2=") != -1)
					{
						lineValue = String(linePropArray[b].replace("\"", "")).substr(3);
						lineY2 = Number(lineValue.substr(0, lineValue.indexOf("\"")));
					}
				}
				
				tempDString = "D,"+lineValue+",M," + lineX1 + "," + lineY1 + ",L," + lineX2 + "," + lineY2;
				returnArray.push(tempDString.split(","));
			}
			
			// Loop door alle paths heen
			for (var gd:Number = 0; gd < pathArray.length; gd++)
			{
				var strokeWidth:Number = 1;
				// Vind alle benodigde properties
				var propertyArray:Array = String(pathArray[gd]).split(" ");
				
				for (var prop:Number = 0; prop < propertyArray.length; prop++)
				{
					if (String(propertyArray[prop]).indexOf("d=") != -1)
						tempDString = String(propertyArray[prop].replace("\"", "")).substr(2);
						
					if (String(propertyArray[prop]).indexOf("stroke-width=") != -1)
					{
						var tempStroke:String = propertyArray[prop].replace("\"", "").substr(13);
						strokeWidth = Number(tempStroke.substr(0, tempStroke.length - 1));
					}
				}
				
			tempDString = "D" + strokeWidth + tempDString;
			
			// Heeft de dstring komma's?
			if (tempDString.indexOf(",") > -1) 
				// Eventuele spaties vervangen door komma's
				dstring = (tempDString.indexOf(" ") > -1) ? strReplace(tempDString," ",",") : tempDString;
			else 
			{  
				// Verander spaties in komma's
				dstring = shrinkSequencesOf(tempDString, " ");
				dstring = strReplace(tempDString, " ",",");
			}	
			
			// Eerst de gekke tekens eruit die Illustrator erin stopt soms
			dstring = strReplace(dstring, "&#xD;", "");
			dstring = strReplace(dstring, "&#xA;", "");
			dstring = strReplace(dstring, "&#x9;", "");
			
			// Verwijder alle aanhalingstekens, alle tekenopdrachten krijgen komma's
			dstring = strReplace(dstring, "\"", "");
			dstring = strReplace(dstring, "c",",c,");
			dstring = strReplace(dstring, "C", ",C,");
			dstring = strReplace(dstring, "D", "D,");
			dstring = strReplace(dstring, "S",",S,");
			dstring = strReplace(dstring, "s",",s,");
			dstring = strReplace(dstring, "z",",z");
			dstring = strReplace(dstring, "M",",M,");
			dstring = strReplace(dstring, "L",",L,");
			dstring = strReplace(dstring, "l",",l,");
			dstring = strReplace(dstring, "H",",H,");
			dstring = strReplace(dstring, "h",",h,");
			dstring = strReplace(dstring, "V",",V,");
			dstring = strReplace(dstring, "v",",v,");
			dstring = strReplace(dstring, "Q",",Q,");
			dstring = strReplace(dstring, "q",",q,");
			dstring = strReplace(dstring, "T",",T,");
			dstring = strReplace(dstring, "t", ",t,");
			dstring = strReplace(dstring, "/>", "");
			
			// Adobe vindt dat er geen komma moet waar een negatief getal staat
			dstring = strReplace(dstring, "-", ",-");
			
			// Alle dubbele komma's weghalen
			dstring = strReplace(dstring, ",,", ",");
			
			// Spaties en nieuwe regels weghalen
			dstring = strReplace(dstring, " ","");
			dstring = strReplace(dstring, "\t", "");
			
			// Komma's gebruiken om alle data van de path op te splitsen in een array
			returnArray.push(dstring.split(","));
			}
			
			return returnArray;
		}
		
		/**
		 * @method shrinkSequencesOf ()
		 * @description Zorgt ervoor dat de waarde in ch in de string s maar 1 keer voorkomt
		 * @param	s (String) String die doorzocht moet worden
		 * @param	ch (String) Waarde die gevonden moet worden
		**/
		private static function shrinkSequencesOf(s:String, ch:String):String 
		{
			var len = s.length;
			var idx = 0;
			var idx2 = 0;
			var rs = "";
			
			// Zolang de indexOf geen -1 teruggeeft
			while ((idx2 = s.indexOf(ch, idx) + 1) != 0) 
			{
				// Gebruik de string vanaf het eerste teken
				rs += s.substring(idx, idx2);
				idx = idx2;
				
				// Verwijder alle characters die de waarde nog steeds hebben
				while ((s.charAt(idx) == ch) && (idx < len)) 
					idx++;
			}
			return rs + s.substring(idx, len);	
		}
		
		/**
		 * @method makeDrawCmds ()
		 * @description Parset alle commando's in het juiste formaat die door de tekenfunctie uitgevoerd zullen worden
		 * @param paths (Array) De commands die door de extractCmds functie zijn gegenereerd
		**/
		private static function makeDrawCmds(paths:Array):Array
		{
			// De path-array waar alle tekencommando's in zullen worden gepusht nadat ze geparset zijn
            var path:Array = new Array();
			
			// Eerste punt, laatste punt en laatste control point
            var firstP:Object;
            var lastP:Object;
            var lastC:Object;
			var qc:Array;
			var i:Number =0;
            
			// Huidige positie in de loop
            var pos:int = 0;
            
			// Loop door de patharray heen en parse de tekencommands in een werkbaar formaat
            while(pos < paths.length)
            {
                switch(paths[pos++])
                {
					case "D":
						path.push(['D', paths[pos].substring(0,1)]);
						pos += 1;
						break;
                    case "M":
                        // moveTo
                        firstP = lastP = {x:Number(paths[pos]), y:Number(paths[pos+1])};
                        path.push(['M', [firstP.x, firstP.y]]);
                        pos += 2;
						
                        if (pos < paths.length && paths[pos] is Number) 
						{  
                            while (pos < paths.length && paths[pos] is Number) 
							{	
								lastP = {x:Number(paths[pos]), y:Number(paths[pos+1])};
                                path.push(['L', [lastP.x, lastP.y]]);
                                firstP = lastP;
                                pos += 2; 
							}
                        }
                        break;
                        
                    case "l" :
						// lineTo
                        do
						{	
							lastP = {x:lastP.x+Number(paths[pos]), y:lastP.y+Number(paths[pos+1])};
                            path.push(['L', [lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 2;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "L" :
						// lineTo
                        do 
						{	
							lastP = {x:Number(paths[pos]), y:Number(paths[pos+1])};
                            path.push(['L', [lastP.x, lastP.y]]);                    
                            firstP = lastP;
                            pos += 2;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "h" :
						// Horizontale lineTo
                        do
						{
                            lastP = {x:lastP.x+Number(paths[pos]), y:lastP.y};
                            path.push(['L', [lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 1;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "H" :
						// Horizontale lineTo
                        do
						{
                            lastP = {x:Number(paths[pos]), y:lastP.y};
                            path.push(['L', [lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 1;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "v" :
						// Verticale lineTo
                        do
						{
                            lastP = {x:lastP.x, y:lastP.y+Number(paths[pos])};
                            path.push(['L', [lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 1;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "V" :
						// Verticale lineTo
                        do
						{
                            lastP = {x:lastP.x, y:Number(paths[pos])};
                            path.push(['L', [lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 1;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
            
                    case "q" :
                        do
						{
                            lastC = {x:lastP.x+Number(paths[pos]), y:lastP.y+Number(paths[pos+1])};
                            lastP = {x:lastP.x+Number(paths[pos+2]), y:lastP.y+Number(paths[pos+3])};
                            path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 4;
                        }  while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "Q" :
                        do
						{
                            lastC = {x:Number(paths[pos]), y:Number(paths[pos+1])};                    
                            lastP = {x:Number(paths[pos+2]), y:Number(paths[pos+3])};
                            path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 4;
                        }  while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "t" :
                        do
						{
                            lastC = {x:lastP.x, y:lastP.y+Number(paths[pos])};
                            lastP = {x:lastP.x, y:lastP.y+Number(paths[pos+1])};
                            path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 2;
                        }  while (pos < paths.length && paths[pos] is Number);
                        break;
                        
                    case "T" :
                        do
						{
                            lastC = {x:lastP.x, y:Number(paths[pos])};                    
                            lastP = {x:lastP.x, y:Number(paths[pos+1])};
                            path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
                            firstP = lastP;
                            pos += 2;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;                        
                        
                    case "c" :
						// curveTo
                        do
						{
                            if (!Number(paths[pos]) && !Number(paths[pos+1]) && !Number(paths[pos+2]) && !Number(paths[pos+3])) {
                            } else {
                                qc = CustomMath.cubicBezierToQuadratic({x:lastP.x, y:lastP.y},   
                                        {x:lastP.x+Number(paths[pos]), y:lastP.y+Number(paths[pos+1])},
                                        {x:lastP.x+Number(paths[pos+2]), y:lastP.y+Number(paths[pos+3])},
                                        {x:lastP.x+Number(paths[pos+4]), y:lastP.y+Number(paths[pos+5])});
                                for (i=0; i<qc.length; i++) {
                                    path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
                                }
                                lastC = {x:lastP.x+Number(paths[pos+2]), y:lastP.y+Number(paths[pos+3])};
                                lastP = {x:lastP.x+Number(paths[pos+4]), y:lastP.y+Number(paths[pos+5])};
                                firstP = lastP;
                            }
                            pos += 6;
                        } while (pos < paths.length && paths[pos] is Number);                            
                        break;
            
                    case "C" :
						// curveTo
                        do
						{
                            if (!Number(paths[pos]) && !Number(paths[pos+1]) && !Number(paths[pos+2]) && !Number(paths[pos+3])) {
                            } else {
                                qc = CustomMath.cubicBezierToQuadratic({x:firstP.x, y:firstP.y},   
                                        {x:Number(paths[pos]), y:Number(paths[pos+1])},
                                        {x:Number(paths[pos+2]), y:Number(paths[pos+3])},
                                        {x:Number(paths[pos+4]), y:Number(paths[pos+5])});
                                for (i=0; i<qc.length; i++) {                            
                                    path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
                                }
        
        
                                lastC = {x:Number(paths[pos+2]), y:Number(paths[pos+3])};
                                lastP = {x:Number(paths[pos+4]), y:Number(paths[pos+5])};
                                firstP = lastP;
                            }
                            pos += 6;
                        } while (pos < paths.length && paths[pos] is Number);
                        break;
                    case "A" :    
                        path.push(['L', [paths[pos+5], paths[pos+6]]]);        
                        
                        pos += 7;
                        break;
                    case "a" :      
                        path.push(['L', [lastP.x + paths[pos+5], lastP.y + paths[pos+6]]]);                                
                        pos += 7;
                        break;  
						
                    case "s" :
						// curveTo
                        if (!Number(paths[pos]) && !Number(paths[pos+1]) && !Number(paths[pos+2]) && !Number(paths[pos+3])) {
                        } else {
                            qc = CustomMath.cubicBezierToQuadratic({x:firstP.x, y:firstP.y},   
                                {x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)},
                                {x:lastP.x+Number(paths[pos]), y:lastP.y+Number(paths[pos+1])},
                                {x:lastP.x+Number(paths[pos+2]), y:lastP.y+Number(paths[pos+3])});
                            for (i=0; i<qc.length; i++) {
                                path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
                            }
    
                            lastC = {x:lastP.x+Number(paths[pos]), y:lastP.y+Number(paths[pos+1])};
                            lastP = {x:lastP.x+Number(paths[pos+2]), y:lastP.y+Number(paths[pos+3])};
                            firstP = lastP;
                        }
                        pos += 4;
                        break;
                        
                    case "S" :
						// curveTo
                        if (!Number(paths[pos]) && !Number(paths[pos+1]) && !Number(paths[pos+2]) && !Number(paths[pos+3])) {
                        } else {
                            qc = CustomMath.cubicBezierToQuadratic({x:firstP.x, y:firstP.y},   
                                {x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)},
                                {x:Number(paths[pos]), y:Number(paths[pos+1])},
                                {x:Number(paths[pos+2]), y:Number(paths[pos+3])});
                            for (i=0; i<qc.length; i++) {
                                path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
                            }
    
                            lastC = {x:Number(paths[pos]), y:Number(paths[pos+1])};
                            lastP = {x:Number(paths[pos+2]), y:Number(paths[pos+3])};
                            firstP = lastP;
                        }
                        pos += 4;
                        break;
						
                    case "z" :
                    case "Z" :
						// En trek een lijn naar het beginpunt zodat het path geencapsuleerd is
                        if (firstP.x != lastP.x || firstP.y != lastP.y) {
                            path.push(['L', [firstP.x, firstP.y]]);
                        }
                        pos++;
                        break;
                }
            }

            return path;
		}
	}
}
