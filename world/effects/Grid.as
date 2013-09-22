package world.effects
{
	// Grid Class voor Clickable
	// Geschreven door Stefan Wijnker, GDD-B1
	// 30/10/2009
	
	// Imports
	import world.effects.GridExplosion;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.BitmapDataChannel;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import game.Game;
	import game.TonGame;
	import flash.geom.Rectangle;
	
	public class Grid extends MovieClip
	{	
		// Members
		
		// PRIVATE
		private var maxExplosions:Number = 2;				// Hoeveelheid explosies tegelijk op het scherm (VOORZICHTIG!)
		private var gridHorMc:Sprite = new Sprite(); 		// Sprite voor horizontale strepen
		public var gridVerMc:Sprite = new Sprite(); 		// Verticale strepen, deze moeten bewegen
		private var gridSpeed:Number = 1;					// Snelheid van de grid in px/frame
		private var blockSize:Number = 20;					// Grootte van de blocks
		private var screenWidth:Number = 640;				// Breedte van het speelveld
		private var screenHeight:Number = 360;				// Hoogte van het speelveld
		private var explosions:Array;						// Aantal explosies op het grid
		private var gridColor:uint = 0x13133b;				// Kleur van het grid
		private var gebruikParent:Boolean = false;			// Stage of grid als target voor displacement
		private var mapScale:Number = 2;					// Impact detail
		private var blurAmount:Number = 10;					// Hoeveelheid blur op de generereerde displacementmap
		private var dispMap:BitmapData;						// De holder voor de displacementmap
		public var currentZoom:Number;						// Huidige zoom
		private var totalZoom:Number = 650;					// Totale zoom
		public var mZoomIn:Boolean = false;					// Zoomt in momenteel?
		public var mZoomOut:Boolean = false;				// Zoomt uit momenteel?
		public var mCurrentSize:Number = currentZoom;		// Is de grid dezelfde grootte?
		private var mZoomSpeed:Number = 3;					// Snelheid van de zoom
		//private var parent:TonGame;
		private var mGame:Game;
		
		// PROTECTED
		
		// PUBLIC
		
		/// Grid constructor
		public function Grid(game:Game):void
		{
			currentZoom = 650;
			mGame = game;
			// Teken de horizontale en verticale sprite
			//drawGrid(blockSize, screenWidth, screenHeight);
			dispMap = createNormalGradient(150);
			drawGrid(currentZoom+blockSize, 700, 600);
			
			// Voeg ze daadwerkelijk toe aan de stage
			addChild(gridHorMc);
			addChild(gridVerMc);
			//gridVerMc.x = screenWidth / 2;
			gridVerMc.y = screenHeight / 2;
			
			// En de array voor de explosions op het scherm
			explosions = new Array();
		}
		
		public function zoomOut():void
		{
			mZoomIn = false;
			mZoomOut = true;
		}
		
		public function zoomIn():void
		{
			mZoomOut = false;
			mZoomIn = true;
		}
		
		/// Grid update functie
		public function updateGrid():void
		{		
			//trace(currentZoom);
			if (mZoomOut && mCurrentSize > 1)
				currentZoom -= mZoomSpeed;
			else
				mZoomOut = false;
				
			if (mZoomIn && mCurrentSize < totalZoom)
				currentZoom+= mZoomSpeed;
			else
			{
				mZoomIn = false;
			}
			
			if (currentZoom != mCurrentSize)
			{
				drawGrid(blockSize + currentZoom, 700, 600);
				mCurrentSize = currentZoom;
			}
			
			if (currentZoom == totalZoom)
			{
				mGame.grid.alpha = 0;
			}
			
			mGame.gameZoom = mCurrentSize / 20;
			
			if (mCurrentSize < 5 && mZoomOut == false && mZoomIn == false)
			{
				// Verplaats de grid
				gridVerMc.x -= gridSpeed;
				if (gridVerMc.x < (screenWidth / 2)-blockSize+mCurrentSize)
				{
					// Zet m ff een block terug als hij te ver gaat
					gridVerMc.x += blockSize+mCurrentSize;
				}
			}
			
			// Als er explosies in het scherm zijn
			if (explosions.length > 0)
			{
				// Update de explosies op de grid
				for (var i:Number = 0; i < explosions.length; i++)
				{
					// Als deze entry niet leeg is
					if (explosions[i] != null)
					{
						// En de explosie actief is
						if (explosions[i].activeExp)
						{
							// Update de explosies en teken hem op het scherm
							explosions[i].updateExplosion();
							applyDisplace(i);
						}
						// Verwijder de explosie
						else 
							destroyExplosion(i);
					}
				}
			}
			else {
				parent.filters = new Array();
			}
		}
		
		/// Maak nieuwe explosie
		public function createExplosion(expX:Number, expY:Number,intensity:Number):void
		{
			// Alleen toevoegen als er vrije plekken zijn
			if(explosions.length<maxExplosions)
				explosions.push(new GridExplosion(expX, expY,intensity));
			else 
			{
				// Als het limiet bereikt is, zoek een vrij plekje in de array
				for (var i:Number = 0; i < explosions.length; i++ )
				{
					if (explosions[i] == null)
						explosions.push(new GridExplosion(expX, expY,intensity));
					break;
				}
			}
		}
		
		/// Teken het grid
		private function drawGrid(blockSize:Number,width:Number,height:Number):void
		{
			gridVerMc.graphics.clear();
			gridHorMc.graphics.clear();
			// Teken de verticale strepen op de sprite
			gridVerMc.graphics.lineStyle(1, gridColor);
			for (var i:Number = 0; i < width / blockSize+1; i++ )
			{
				gridVerMc.graphics.moveTo(screenWidth/2-(i * blockSize-blockSize/2), height-screenHeight/2);
				gridVerMc.graphics.lineTo(screenWidth / 2 - (i * blockSize-blockSize / 2), 0 - screenHeight / 2);
				gridVerMc.graphics.moveTo(screenWidth/2+(i * blockSize-blockSize/2), height-screenHeight/2);
				gridVerMc.graphics.lineTo(screenWidth/2+(i * blockSize-blockSize/2), 0-screenHeight/2);
			}
			
			gridHorMc.graphics.lineStyle(1, gridColor);
			
			//gridHorMc.graphics.moveTo(0, screenHeight/2);
			//gridHorMc.graphics.lineTo(width, screenHeight / 2);

			for (var j:Number = 0; j < (height / blockSize); j++ )
			{
				gridHorMc.graphics.moveTo(0, screenHeight/2 - (j * blockSize));
				gridHorMc.graphics.lineTo(width, screenHeight / 2 - (j * blockSize));
				gridHorMc.graphics.moveTo(0, screenHeight/2 + (j * blockSize));
				gridHorMc.graphics.lineTo(width, screenHeight/2 + (j * blockSize));
			}
		}
		
		/// Functie voor het verwijderen van een explosie uit de array en de filters
		private function destroyExplosion(index:Number):void
		{
			// Verwijder uit array en filters
			explosions[index] = null;
			if (gebruikParent)
				parent.filters[index] = null;
			else
				this.filters[index] = null;
			
			
			// Schuif de array en de filters terug zodat er geen lege plekken zijn
			for (var i:Number = index + 1; i < explosions.length; i++)
			{
				explosions[i - 1] = explosions[i];
				
				if (gebruikParent)
					parent.filters[i - 1] = filters[i];
				else
					this.filters[i - 1] = filters[i];
			}
			
			// En verwijder de laatste entry van de array
			explosions.pop();
			
			if (gebruikParent)
				parent.filters.pop();
			else
				this.filters.pop();
		}
		
		/// Deze functie genereert de normal map die wordt gebruikt in de DisplacementMapFilter
		private function createNormalGradient(inRadius:Number):BitmapData
		{
			var radius:Number = inRadius / mapScale;
			
			// Grootte van de BitmapData
			var bitSize:Number = (radius * mapScale) * 0.88;
			
			// Genereer BitmapData met neutrale achtergrondkleur (voor displacement)
			var outData:BitmapData = new BitmapData(bitSize, bitSize, false, 0x8080FF); 
			
			// Maak een nieuwe sprite aan voor het tekenen
			var circleObject:Sprite = new Sprite();
		
			// Transform de circle zodat hij op de gewenste positie staat (voor tijdens het expanden)
			var circleMatrix:Matrix = new Matrix(1, 0, 0, 1, radius / 2, radius / 2);
			
			// Parameters voor de rood/groene gradient
			var type:String = GradientType.LINEAR;
			var kleuren:Array = [0xFF0000, 0x00FF00];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var mode:String = SpreadMethod.PAD;
			
			// Maak een nieuwe matrix aan voor de gradient zelf
			var matr:Matrix = new Matrix();
			
			// Maak de gradient
			matr.createGradientBox(radius * 1.5, radius * 1.5, -20, radius / 2 + 15, 0);
			
			// Teken de cirkel met de rood/groene gradient
			circleObject.graphics.beginGradientFill(type, kleuren, alphas, ratios, matr, mode);  
			circleObject.rotation = 90;
			circleObject.graphics.drawCircle((radius / 4) * 1.5, (radius / 4) * 1.5, radius-blurAmount);
			
			// Teken de cirkel op de BitmapData
			outData.draw(circleObject, circleMatrix);
			
			// Voeg een blur filter toe aan het geheel zodat het blendt in de achtergrond
			var blurFilter:BlurFilter = new BlurFilter(blurAmount, blurAmount);
			outData.applyFilter(outData, new Rectangle(0, 0,outData.width, outData.height), new Point(0,0), blurFilter);
			
			/*var outDataTest:Bitmap = new Bitmap(outData);
			addChild(outDataTest);*/
			
			return outData;
		}
		
		/// Deze functie tekent alle explosies in de array op het scherm
		private function applyDisplace(i:Number):void//inBitmapData:BitmapData,mult:Number,posX:Number,posY:Number,radius:Number):void
		{
			// Variabelen voor het generaten van de explosies
			var targetExplosion:GridExplosion = explosions[i];
			var scaleMatrix:Matrix = new Matrix();
			// Size multiplier
			var scaleMultiplier:Number = 2;
			scaleMatrix.scale((targetExplosion.expRadius / 150)*scaleMultiplier, (targetExplosion.expRadius / 150)*scaleMultiplier);
			var bitmapDataSize:Number = (((targetExplosion.expRadius * 2) * 0.88))+4;
			var inBitmapData:BitmapData = new BitmapData(bitmapDataSize, bitmapDataSize, false, 0x8080FF);
			inBitmapData.draw(dispMap, scaleMatrix);
			var xOffset:Number = (targetExplosion.xPos - inBitmapData.width / 4 + 40) + (this.width-screenWidth) - parent.getBounds(parent).topLeft.x;
			var yOffset:Number = targetExplosion.yPos - inBitmapData.height / 4 + 20 - parent.getBounds(parent).topLeft.y;
			
			// Maak de displacement filter aan
			var displacement:DisplacementMapFilter = new DisplacementMapFilter();
			
			// En de benodigde settings
			displacement.mapBitmap = inBitmapData;
			displacement.mapPoint = new Point(xOffset,yOffset); 
			displacement.componentX = BitmapDataChannel.RED;
			displacement.componentY = BitmapDataChannel.GREEN;
			displacement.scaleX = explosions[i].dispAlpha;
			displacement.scaleY = explosions[i].dispAlpha;
			
			/*var outDataTest:Bitmap = new Bitmap(inBitmapData);
			addChild(outDataTest);*/
			
			// Maak een kopie van de filters van het target object
			var gridFilters:Array = (gebruikParent) ? parent.filters : this.filters;
				
			// Als hij niet in de filters voorkomt, voeg hem toe of update de juiste
			if (explosions[i] == null)
				gridFilters.push(displacement);
			else
				gridFilters[i] = displacement;
					
			// Reapply terug aan de target
			if(gebruikParent)
				parent.filters = gridFilters;
			else
				this.filters = gridFilters;
				
		}
	}
}