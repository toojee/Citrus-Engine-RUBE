/**
 * @author Tungstene
 * @version 1.0.0 - 06/06/2013 18:55
 */

package examples.rube.objects 
{
	import Box2D.Common.Math.b2Vec2;
	import citrus.objects.rube.IRubeObject;
	import citrus.objects.rube.RubeHero;
	
	public class BraidHero extends RubeHero implements IRubeObject 
	{
		public var camTarget:Object = { x: 0, y: 0 };
		public var keySlot:Key;
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function BraidHero( name:String, params:Object = null, oBody:Object = null ):void 
		{
			//-------------------------------------------------------
			super( name, params, oBody );
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Update toutes les timeDelta
		//-----------------------------------------------------------------------------------------
		override public function update( timeDelta:Number ):void
		{
			//-------------------------------------------------------
			if ( keySlot )
			{
				keySlot.inverted = _inverted;
				keySlot.x        = _inverted ? this.x - 30: this.x + 30;
				keySlot.y        = this.y + 15;
			}
			//-------------------------------------------------------
			camTarget.x = body.GetPosition().x * _box2D.scale;
			camTarget.y = body.GetPosition().y * _box2D.scale;
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			if (_hurt)
			{
				_animation = "dying";
				return;
			}
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------	
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			//-------------------------------------------------------
			if ( onGround )
			{
				_animation = "idle";
				//---------------------------------------------------
				if ( _ce.input.isDoing( "up", inputChannel ) )
				{
					_animation  = "looking_upward";
					camTarget.y = body.GetPosition().y * _box2D.scale - 200;
				}
				//---------------------------------------------------
				if ( _ce.input.isDoing( "down", inputChannel  ))
				{
					_animation  = "looking_downward";
					camTarget.y = body.GetPosition().y * _box2D.scale + 200;
				}
			}
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			if (_ce.input.isDoing("right", inputChannel))
			{
				if ( _onGround ) _animation = "running";
					
				velocity.Add( getSlopeBasedMoveAngle() );
				_inverted = false;
			}
			//-------------------------------------------------------
			if (_ce.input.isDoing("left", inputChannel))
			{
				if ( _onGround ) _animation = "running";
					
				velocity.Subtract(getSlopeBasedMoveAngle());
				_inverted = true;
			}
			//-------------------------------------------------------
			if ( _ce.input.justDid("jump", inputChannel) && _onGround )
			{
				velocity.y = -jumpHeight;
				onJump.dispatch();
				_animation = "jump_prep_straight";
				_onGround  = false;
			}
			//-------------------------------------------------------
			if (_ce.input.isDoing("jump", inputChannel) && !_onGround && velocity.y < 0)
			{
				velocity.y -= jumpAcceleration;
			}
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			if (      velocity.x > maxVelocity )  velocity.x = maxVelocity;
			else if ( velocity.x < -maxVelocity ) velocity.x = -maxVelocity;
				
				
			/*if (body.interactingBodies().length == 0)
				if(_body.velocity.y > 0)
					_animation = "falling_downward";*/
		}
	}
}