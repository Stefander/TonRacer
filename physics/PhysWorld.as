package physics
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import physics.PhysConvexObject;
	import math.CustomMath;
	import game.TonGame;

	public class PhysWorld
	{
		public var bodyList:Array = new Array();	// De array waar alle bodies ingegooid worden op het moment dat deze worden aangemaakt
		public var mDebugSprite:Sprite = new Sprite();
		public var mGame:TonGame;
		
		private var removed:Array = new Array();
		private var addedAmount:Number = 0;
		
		public function PhysWorld(game:TonGame):void
		{
			mGame = game;
		}
		
		public function getRemovedAmount():Number	{	return removed.length;	}
		public function getRemovedBodies():Array	{	return removed;			}
		public function getAddedAmount():Number		{	return addedAmount;		}
		
		public function getDebugSprite():Sprite { return mDebugSprite; }
		
		/// Voeg een convex object toe met een x aantal punten
		/// @warning Is zwaarder dan een 'normale' body!
		public function addConvexBody(name:String,points:Array, mass:Number, x:Number, y:Number):void
		{
			var targetBody:PhysConvexObject = new PhysConvexObject(this, name, points, mass, x, y);
			bodyList.push(targetBody);
			targetBody.drawDebug();
			addedAmount++;
		}
		
		/// Deze functie vindt aan de hand van de inputstring de gevraagde body
		public function getConvexBody(bodyName:String):PhysConvexObject
		{
			for (var i:Number = 0; i < bodyList.length; i++)
			{
				if (bodyList[i].bodyName == bodyName)
				{
					return bodyList[i];
					break;
				}
			}
			return null;
		}
		
		public function getStringBodyAmount(bodyName:String):Number
		{
			var outAmount:Number = 0;
			for (var i:Number = 0; i < bodyList.length; i++)
			{
				if (bodyList[i].bodyName.indexOf(bodyName) != -1)
				{
					outAmount++;
				}
			}
			return outAmount;
		}
		
		public function removeConvexBody(bodyName:String):void
		{
			// Bereken de index van de betreffende body
			for (var i:Number = 0; i < bodyList.length; i++)
			{
				if (bodyList[i].bodyName == bodyName)
				{
					mGame.gameState.removedArray.push(bodyList[i].bodyName);
					bodyList[i] = null;
					bodyList.splice(i, 1);
				}
				
				// Cleanup the array
				break;
			}
		}
		
		public function updateScore(impX:Number,impY:Number,targetName:String,angle:Number,velocity:Number,value:Number):void
		{
			mGame.updateScore(impX,impY,targetName,angle,velocity,value);
		}
		
		public function createExplosion(inX:Number, inY:Number, intensity:Number):void
		{
			mGame.createExplosion(inX, inY, intensity);
		}
		
		public function triggerAchievement():void
		{
			mGame.triggerAchievement();
		}
		
		/// Updatefunctie voor de PhysWorld, met een waarde t (als s/fps)
		public function update():void
		{
			// Clear de debug sprite zodat er weer op getekend kan worden
			mDebugSprite.graphics.clear();
			
			// Remove unnecessary bodies
			for (var r:Number = 0; r < bodyList.length; r++ )
			{
				if (bodyList[r].getPosition().x < -50)
				{
					mGame.gameState.removedArray.push(bodyList[r].bodyName);
					bodyList.splice(r, 1);
				}
			}
			
			for (var i:Number = 0; i < bodyList.length; i++)
			{
				// Handle movement
				bodyList[i].updateBody();
			}
			
			// Nadat alle objecten van positie zijn veranderd, check om te zien of er collisions zijn
			for (var j:Number = 0; j < bodyList.length; j++)
			{
				for (var k:Number = 0; k < bodyList.length; k++)
				{
					if (j != k && bodyList[j].getPosition().x > -20 && bodyList[k].getPosition().x > -20)
					{
						if (CustomMath.doBoundsIntersect(bodyList[j].getBoundingBox(), bodyList[k].getBoundingBox()))
						{
							bodyList[j].handlePreciseCollision(bodyList[k],bodyList[k].getBoundingBox().intersection(bodyList[j].getBoundingBox()));
							bodyList[k].handlePreciseCollision(bodyList[j],bodyList[j].getBoundingBox().intersection(bodyList[k].getBoundingBox()));
						}
					}
				}
			}
		}
	}
}