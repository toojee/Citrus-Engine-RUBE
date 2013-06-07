/**
 * @author Tungstene
 * @version 1.0.0 - 07/06/2013 15:48
 */

package examples.rube.objects 
{
	import Box2D.Common.Math.b2Vec2;
	import citrus.objects.rube.IRubeObject;
	import citrus.objects.rube.RubeEnemy;
	
	public class BraidEnemy extends RubeEnemy implements IRubeObject
	{
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function BraidEnemy( name:String, params:Object = null, oBody:Object = null ):void 
		{
			//-------------------------------------------------------
			super( name, params, oBody );
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Update toutes les timeDelta
		//-----------------------------------------------------------------------------------------
		override public function update(timeDelta:Number):void
		{			
			var position:b2Vec2 = _body.GetPosition();
			//-------------------------------------------------------
			if ((!_inverted && position.x * _box2D.scale < leftBound) 
			|| (  _inverted && position.x * _box2D.scale > rightBound))
			{
				turnAround();
			}
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			//-------------------------------------------------------
			if ( !_hurt ) velocity.x = _inverted ? speed : -speed;
			else          velocity.x = 0;
			//-------------------------------------------------------
			_body.SetLinearVelocity( velocity )
			//-------------------------------------------------------
			updateAnimation();
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------- Update les animations
		//-----------------------------------------------------------------------------------------
		override protected function updateAnimation():void
		{
			_animation = _hurt ? "monster-dying" : "monster-walking";
		}
	}
}