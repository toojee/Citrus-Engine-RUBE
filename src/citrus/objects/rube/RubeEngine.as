/**
 * @author Tungstene
 * @version 1.0.0 - 05/06/2013 18:44
 */

package citrus.objects.rube 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	public class RubeEngine 
	{
		private static var instance:RubeEngine;
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function RubeEngine():void 
		{
			//-------------------------------------------------------
			
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public static function getInstance():RubeEngine 
		{
			//-------------------------------------------------------
			return instance ||= new RubeEngine();
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------- Attribut les variables du BODY
		//-----------------------------------------------------------------------------------------
		public function defineBody( bodyDef:b2BodyDef, oBody:Object ):void
		{
			//-------------------------------------------------------
			bodyDef.type = oBody.type;
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------ Création du BODY
		//-----------------------------------------------------------------------------------------
		public function createBody( body:b2Body, oBody:Object ):b2Body
		{
			//-------------------------------------------------------
			if ( oBody["massData-center"] )
			{
				var massData:b2MassData = new b2MassData();
				massData.center         = new b2Vec2( oBody["massData-center"].x, oBody["massData-center"].y );
				massData.I              = oBody["massData-I"];
				massData.mass           = oBody["massData-mass"];
				body.SetMassData( massData );
			}
			//-------------------------------------------------------
			if ( !oBody.awake ) body.SetAwake( false );
			//-------------------------------------------------------
			if ( oBody.active        != undefined ) body.SetActive( false );
			if ( oBody.allowSleep    != undefined ) body.SetSleepingAllowed( false );
			if ( oBody.bullet        != undefined ) body.SetBullet( true );
			if ( oBody.fixedRotation != undefined ) body.SetFixedRotation( true );
			//-------------------------------------------------------
			if ( oBody.linearDamping )       body.SetLinearDamping( oBody.linearDamping );
			if ( oBody.angularDamping )      body.SetAngularDamping( oBody.angularDamping );
			if ( oBody.angle > 0 )           body.SetAngle( -oBody.angle );
			if ( oBody.angularVelocity > 0 ) body.SetAngularVelocity( oBody.angularVelocity );
			//-------------------------------------------------------
			if ( !(oBody.linearVelocity  is Number) ) body.SetLinearVelocity( new b2Vec2( oBody.linearVelocity.x, oBody.linearVelocity.y ) );	
			//-------------------------------------------------------
			return body;
		}
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------- Attribut les variables des FIXTURES
		//-----------------------------------------------------------------------------------------
		public function defineFixture( fixtureDef:b2FixtureDef, body:b2Body, oBody:Object ):void 
		{
			//-------------------------------------------------------
			var oFixture:Object;
			var shape:b2Shape;
			var vFixtures:Vector.<b2FixtureDef> = new Vector.<b2FixtureDef>;
			var max:int = oBody.fixture.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oFixture = oBody.fixture[i];
				//---------------------------------------------------
				fixtureDef.density   = oFixture.density;
				fixtureDef.friction  = oFixture.friction;
				//---------------------------------------------------
				if ( oFixture.restitution ) fixtureDef.restitution = oFixture.restitution;
				if ( oFixture.sensor )      fixtureDef.isSensor    = oFixture.sensor;
				//---------------------------------------------------
				if ( oFixture["filter-categoryBits"] ) fixtureDef.filter.categoryBits = oFixture["filter-categoryBits"];
				if ( oFixture["filter-groupIndex"] )   fixtureDef.filter.groupIndex   = oFixture["filter-groupIndex"];
				if ( oFixture["filter-maskBits"] )     fixtureDef.filter.maskBits     = oFixture["filter-maskBits"];
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
					if( !(oFixture.circle.center is Number) ) (shape as b2CircleShape).SetLocalPosition( new b2Vec2( oFixture.circle.center.x, -oFixture.circle.center.y ) );
				}
				else
				{
					throw( new Error( "Shape not included!" ) );
				}
				//---------------------------------------------------
				fixtureDef.shape = shape;
				body.CreateFixture( fixtureDef );		
			}	
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------- Création des VERTICES
		//-----------------------------------------------------------------------------------------
		public function createVertices( vertices:Object ):Vector.<b2Vec2> 
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
	}
}