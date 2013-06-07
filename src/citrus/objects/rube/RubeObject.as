/**
 * @author Tungstene
 * @version 1.0.1 - 05/06/2013 16:12
 */

package citrus.objects.rube 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2EdgeChainDef;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import citrus.objects.Box2DPhysicsObject;
	import starling.display.DisplayObject;
	//---------------------------------------------------------------------------------------------
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.PhysicsCollisionCategories;
	
	public class RubeObject extends Box2DPhysicsObject implements IRubeObject
	{
		private var oBody:Object;
		//-----------------------------------------------------------------------------------------
		private var jointDef:b2MouseJointDef;
		private var joint:b2MouseJoint;
		private var mouseScope:DisplayObject;
		//-----------------------------------------------------------------------------------------
		public static const NAME:String = "RubeObject";
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------------------- Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function RubeObject( name:String, params:Object = null, oBody:Object = null ):void 
		{
			//-------------------------------------------------------
			/*if (      oParams && oParams.registration == undefined ) params.registration = "topLeft";	
			else if ( oParams == null )                             params = { registration:"topLeft" };*/
			//-------------------------------------------------------
			super( name, params );
			//-------------------------------------------------------
			if ( params && params.x ) this.x = params.x * _box2D.scale;
			if ( params && params.y ) this.y = -params.y * _box2D.scale;
			//-------------------------------------------------------
			this.oBody = oBody;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Renvoit le nom de la classe
		//-----------------------------------------------------------------------------------------
		public  function get RUBE_NAME():String 
		{
			return NAME;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------ Destruction de l'objet
		//-----------------------------------------------------------------------------------------
		override public function destroy():void 
		{
			super.destroy();
			
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Update toutes les timeDelta
		//-----------------------------------------------------------------------------------------
		override public function update( timeDelta:Number ):void
		{
			super.update(timeDelta);
			//-------------------------------------------------------
			/*if ( joint ) 
			{
				joint.SetTarget(new b2Vec2( mouseScope.mouseX / _box2D.scale, mouseScope.mouseY / _box2D.scale ) );
			}*/
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Update toutes les timeDelta
		//-----------------------------------------------------------------------------------------
		/*public function enableHolding( mouseScope:DisplayObject ):void 
		{
			if (joint) return;
			//-------------------------------------------------------
			this.mouseScope = mouseScope;
			jointDef.target = new b2Vec2( mouseScope.mouseX / _box2D.scale, mouseScope.mouseY / _box2D.scale );
			joint           = _box2D.world.CreateJoint( jointDef ) as b2MouseJoint;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Update toutes les timeDelta
		//-----------------------------------------------------------------------------------------
		public function disableHolding():void
		{
			if ( !joint ) return;
			//-------------------------------------------------------
			_box2D.world.DestroyJoint( joint );
			joint = null;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------- Update toutes les timeDelta
		//-----------------------------------------------------------------------------------------
		override protected function defineJoint():void 
		{
			super.defineJoint();
			//-------------------------------------------------------
			jointDef              = new b2MouseJointDef();
			jointDef.bodyA        = _box2D.world.GetGroundBody();
			jointDef.bodyB        = _body;
			jointDef.dampingRatio = .2;
			jointDef.frequencyHz  = 100;
			jointDef.maxForce     = 100;
		}*/
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------- Attribut les variables du BODY
		//-----------------------------------------------------------------------------------------
		override protected function defineBody():void
		{
			//-------------------------------------------------------
			super.defineBody();
			//-------------------------------------------------------
			_bodyDef.type = oBody.type;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------ Création du BODY
		//-----------------------------------------------------------------------------------------
		override protected function createBody():void
		{
			//-------------------------------------------------------
			super.createBody();
			//-------------------------------------------------------
			if ( oBody["massData-center"] )
			{
				var massData:b2MassData = new b2MassData();
				massData.center         = new b2Vec2( oBody["massData-center"].x, oBody["massData-center"].y );
				massData.I              = oBody["massData-I"];
				massData.mass           = oBody["massData-mass"];
				_body.SetMassData( massData );
			}
			//-------------------------------------------------------
			if ( !oBody.awake ) _body.SetAwake( false );
			//-------------------------------------------------------
			if ( oBody.active        != undefined ) _body.SetActive( false );
			if ( oBody.allowSleep    != undefined ) _body.SetSleepingAllowed( false );
			if ( oBody.bullet        != undefined ) _body.SetBullet( true );
			if ( oBody.fixedRotation != undefined ) _body.SetFixedRotation( true );
			//-------------------------------------------------------
			if ( oBody.linearDamping )       _body.SetLinearDamping( oBody.linearDamping );
			if ( oBody.angularDamping )      _body.SetAngularDamping( oBody.angularDamping );
			if ( oBody.angle > 0 )           _body.SetAngle( -oBody.angle );
			if ( oBody.angularVelocity > 0 ) _body.SetAngularVelocity( oBody.angularVelocity );
			//-------------------------------------------------------
			if ( !(oBody.linearVelocity  is Number) ) _body.SetLinearVelocity( new b2Vec2( oBody.linearVelocity.x, oBody.linearVelocity.y ) );	
		}
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------- Attribut les variables des FIXTURES
		//-----------------------------------------------------------------------------------------
		override protected function defineFixture():void 
		{
			//-------------------------------------------------------
			super.defineFixture();
			//-------------------------------------------------------
			var oFixture:Object;
			var shape:b2Shape;
			var max:int = oBody.fixture.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oFixture = oBody.fixture[i];
				//---------------------------------------------------
				_fixtureDef.density   = oFixture.density;
				_fixtureDef.friction  = oFixture.friction;
				//---------------------------------------------------
				if ( oFixture.restitution ) _fixtureDef.restitution = oFixture.restitution;
				if ( oFixture.sensor )      _fixtureDef.isSensor    = oFixture.sensor;
				//---------------------------------------------------
				if ( oFixture["filter-categoryBits"] ) _fixtureDef.filter.categoryBits = oFixture["filter-categoryBits"];
				if ( oFixture["filter-groupIndex"] )   _fixtureDef.filter.groupIndex   = oFixture["filter-groupIndex"];
				if ( oFixture["filter-maskBits"] )     _fixtureDef.filter.maskBits     = oFixture["filter-maskBits"];
				//---------------------------------------------------
				if ( oFixture.polygon )
				{
					shape                         = new b2PolygonShape();
					var vVertices:Vector.<b2Vec2> = createVertices( oFixture.polygon.vertices );
					//-----------------------------------------------
					(shape as b2PolygonShape).SetAsVector( vVertices, vVertices.length );
					
				}
				else if ( oFixture.circle )
				{
					shape = new b2CircleShape( oFixture.circle.radius );	
					if( !(oFixture.circle.center is Number) ) (shape as b2CircleShape).SetLocalPosition( new b2Vec2( oFixture.circle.center.x, oFixture.circle.center.y ) );
				}
				else
				{
					throw( new Error( "Shape not included!" ) );
				}
				//---------------------------------------------------
				_fixtureDef.shape = shape;
				_body.CreateFixture( _fixtureDef );				
			}	
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------- Création des VERTICES
		//-----------------------------------------------------------------------------------------
		protected function createVertices( vertices:Object ):Vector.<b2Vec2> 
		{
			var vVertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			var aVerticesX:Array = counterClockWise( vertices.x );
			var aVerticesY:Array = counterClockWise( vertices.y );
			//-------------------------------------------------------
			var max:int = aVerticesX.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				vVertices.push( new b2Vec2( aVerticesX[i], -aVerticesY[i] ) );
			}
			//-------------------------------------------------------
			return vVertices;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------- Change le sens de création des vertices
		//-----------------------------------------------------------------------------------------
		protected function counterClockWise( aRegular:Array ):Array
		{
			var originPoint:Number = aRegular.splice(0, 1 )
			var aReversed:Array    = aRegular.reverse();
			//-------------------------------------------------------
			aReversed.unshift( originPoint );
			//-------------------------------------------------------
			return aReversed;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------ Renvoit une description de l'objet
		//-----------------------------------------------------------------------------------------
		public function toString( ):String
		{
			return "[ RubeObjects " +
					" name:"   + this.name +
					" x:"      + this.x +
					" y:"      + this.y +
					" active:" + (body ? body.IsActive() : "false") +
					" ]";
		}
	}
}