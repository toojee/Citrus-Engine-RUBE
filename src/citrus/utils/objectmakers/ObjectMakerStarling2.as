/**
 * @author Tungstene
 * @version 1.0.1 - 05/06/2013 16:12
 */

package citrus.utils.objectmakers 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.*;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.rube.*;
	import citrus.physics.box2d.Box2D;
	import flash.utils.getQualifiedClassName;
	//---------------------------------------------------------------------------------------------
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.core.IState;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
	//---------------------------------------------------------------------------------------------
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	//--------------------------.-------------------------------------------------------------------
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ObjectMakerStarling2 
	{
		private static var ce:CitrusEngine = CitrusEngine.getInstance();
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------ Function - constructor
		//-----------------------------------------------------------------------------------------
		public function ObjectMakerStarling2():void 
		{
			//-------------------------------------------------------
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------ Importation RUBE
		//-----------------------------------------------------------------------------------------
		public static function FromRUBE( JSONData:String, vCustomClasses:Vector.<Class> = null ):Vector.<IRubeObject> 
		{
			CitrusObject.hideParamWarnings = true;
			//-------------------------------------------------------
			var vRubeObjects:Vector.<IRubeObject> = new Vector.<IRubeObject>();
			var oLevel:Object                     = JSON.parse( JSONData );
			//-------------------------------------------------------
			setupWorld( oLevel );
			//-------------------------------------------------------
			if ( oLevel.body )  createBodies( oLevel.body, vRubeObjects, vCustomClasses );
			if ( oLevel.joint ) createJoints( oLevel.joint, vRubeObjects );
			//-------------------------------------------------------
			return vRubeObjects;
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------- Setup of world
		//-----------------------------------------------------------------------------------------
		static private function setupWorld( oLevel:Object ):void 
		{
			var box2d:Box2D    = (ce.state.getFirstObjectByType(Box2D) as Box2D);
			var gravity:b2Vec2 = new b2Vec2();
			//-------------------------------------------------------
			if ( oLevel.gravity && oLevel.gravity.x ) gravity.x = oLevel.gravity.x;
			if ( oLevel.gravity && oLevel.gravity.y ) gravity.y = -oLevel.gravity.y;
			//-------------------------------------------------------
			box2d.world.SetGravity( gravity );
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			box2d.velocityIterations = oLevel.velocityIterations;
			box2d.positionIterations = oLevel.positionIterations;
			ce.stage.frameRate       = oLevel.stepsPerSecond;
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------------------- Creation of BODIES
		//-----------------------------------------------------------------------------------------
		private static function createBodies( aBodies:Array, vRubeObjects:Vector.<IRubeObject>, vCustomClasses:Vector.<Class> ):void
		{
			var oBody:Object;
			var rube:IRubeObject;
			var position:Point = new Point();
			var max:int        = aBodies.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oBody       = aBodies[i];
				position.x  = !(oBody.position is Number) && oBody.position.x ? oBody.position.x : 0;
				position.y  = !(oBody.position is Number) && oBody.position.y ? oBody.position.y : 0;
				//---------------------------------------------------
				rube = getRubeObject( oBody, position, vCustomClasses );
				//---------------------------------------------------
				ce.state.add( rube as Box2DPhysicsObject );
				vRubeObjects.push( rube );				
			}
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------- Return the specify rube object
		//-----------------------------------------------------------------------------------------
		private static function getRubeObject( oBody:Object, position:Point, vCustomClasses:Vector.<Class> ):IRubeObject 
		{
			var value:*;
			var oParams:Object          = new Object();
			var aCustomProperties:Array = oBody.customProperties;
			var max:int                 = aCustomProperties ? aCustomProperties.length : 0;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				//---------------------------------------------------
				if (      aCustomProperties[i].string )  value = new String( aCustomProperties[i].string );
				else if ( aCustomProperties[i].vec2 )    value = !(aCustomProperties[i].vec2 is Number) ? new b2Vec2( aCustomProperties[i].vec2.x, aCustomProperties[i].vec2.y ) : new b2Vec2();
				else if ( aCustomProperties[i].int )     value = new int( aCustomProperties[i].int );
				else if ( aCustomProperties[i].float )   value = new Number( aCustomProperties[i].float );
				else if ( aCustomProperties[i].boolean ) value = new Boolean( aCustomProperties[i].boolean );
				else if ( aCustomProperties[i].color )   value = aCustomProperties[i].color;
				else                                     value = "Error";
				//---------------------------------------------------
				oParams[ aCustomProperties[i].name ] = value;
			}
			//-------------------------------------------------------
			oParams.x = position.x;
			oParams.y = position.y;
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			var vRubeClass:Vector.<Class> = vCustomClasses.slice();
			vRubeClass.push( RubeHero, RubePlatform, RubeMovingPlatform, RubeTreadmill, RubeEnemy, RubeCoin, RubeTeleporter, RubeSensor, RubeObject );
			//-------------------------------------------------------
			var RubeClass:Class;
			var className:String;
			var rubeObject:IRubeObject;
			//-------------------------------------------------------
			var citrusClass:String = oParams.citrusClass;
			max                    = vRubeClass.length;
			//-------------------------------------------------------
			for ( i = 0; i < max; i++ ) 
			{
				RubeClass = vRubeClass[i];
				className = getQualifiedClassName( RubeClass )
				className = className.substr( className.lastIndexOf("::") + 2, className.length );
				//---------------------------------------------------
				if ( className == citrusClass 
				||   className == "Rube" + citrusClass )
				{
					rubeObject = new RubeClass( oBody.name, oParams, oBody );
				}
			}
			//-------------------------------------------------------
			if( !rubeObject ) rubeObject = new RubeObject( oBody.name, oParams, oBody );
			//-------------------------------------------------------
			return rubeObject;
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------------------- Creation of JOINTS
		//-----------------------------------------------------------------------------------------
		private static function createJoints( aJoints:Array, vRubeObjects:Vector.<IRubeObject> ):void
		{
			if ( vRubeObjects.length == 0 ) return;
			//-------------------------------------------------------
			var joint:b2JointDef;
			var oJoint:Object;
			var max:int       = aJoints.length;
			var world:b2World = (ce.state.getFirstObjectByType(Box2D) as Box2D).world;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oJoint = aJoints[i];
				//---------------------------------------------------
				if (      oJoint.type == "revolute" )  joint = createRevoluteJoint( oJoint, vRubeObjects ); 
				else if ( oJoint.type == "distance" )  joint = createDistanceJoint( oJoint, vRubeObjects ); 
				else if ( oJoint.type == "prismatic" ) joint = createPrismaticJoint( oJoint, vRubeObjects ); 
				else if ( oJoint.type == "weld" )      joint = createWeldJoint( oJoint, vRubeObjects ); 
				else if ( oJoint.type == "friction" )  joint = createFrictionJoint( oJoint, vRubeObjects ); 
				else                                   throw new Error( "The joint :" + oJoint.type + " is not implemented!" ); 
				//---------------------------------------------------
				world.CreateJoint( joint );
			}
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------- Revolute Joint
		//-----------------------------------------------------------------------------------------
		private static function createRevoluteJoint( oJoint:Object, vRubeObjects:Vector.<IRubeObject> ):b2RevoluteJointDef
		{
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (vRubeObjects[ oJoint.bodyA ] as RubeObject).body;
			jointDef.bodyB    = (vRubeObjects[ oJoint.bodyB ] as RubeObject).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			if ( !( oJoint.anchorA is Number) ) jointDef.localAnchorA.Set( oJoint.anchorA.x, -oJoint.anchorA.y );
			if ( !( oJoint.anchorB is Number) ) jointDef.localAnchorB.Set( oJoint.anchorB.x, -oJoint.anchorB.y );
			//-------------------------------------------------------	
			jointDef.enableLimit    = oJoint.enableLimit;
			jointDef.enableMotor    = oJoint.enableMotor;
			jointDef.lowerAngle     = - oJoint.upperLimit;
			jointDef.upperAngle     = - oJoint.lowerLimit;
			jointDef.maxMotorTorque = oJoint.maxMotorTorque;
			jointDef.motorSpeed     = oJoint.motorSpeed;
			jointDef.referenceAngle = oJoint.refAngle;
			//-------------------------------------------------------
			return jointDef;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------- Prismatic Joint
		//-----------------------------------------------------------------------------------------
		private static function createDistanceJoint( oJoint:Object, vRubeObjects:Vector.<IRubeObject> ):b2DistanceJointDef
		{
			var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (vRubeObjects[ oJoint.bodyA ] as RubeObject).body;
			jointDef.bodyB    = (vRubeObjects[ oJoint.bodyB ] as RubeObject).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			if ( !( oJoint.anchorA is Number) ) jointDef.localAnchorA.Set( oJoint.anchorA.x, -oJoint.anchorA.y );
			if ( !( oJoint.anchorB is Number) ) jointDef.localAnchorB.Set( oJoint.anchorB.x, -oJoint.anchorB.y );
			//-------------------------------------------------------	
			jointDef.dampingRatio = oJoint.dampingRatio;		
			jointDef.frequencyHz  = oJoint.frequencyHz;		
			jointDef.length       = oJoint.length;		
			//-------------------------------------------------------
			return jointDef;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------- Prismatic Joint
		//-----------------------------------------------------------------------------------------
		private static function createPrismaticJoint( oJoint:Object, vRubeObjects:Vector.<IRubeObject> ):b2PrismaticJointDef
		{
			var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (vRubeObjects[ oJoint.bodyA ] as RubeObject).body;
			jointDef.bodyB    = (vRubeObjects[ oJoint.bodyB ] as RubeObject).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			if ( !( oJoint.anchorA is Number) ) jointDef.localAnchorA.Set( oJoint.anchorA.x, -oJoint.anchorA.y );
			if ( !( oJoint.anchorB is Number) ) jointDef.localAnchorB.Set( oJoint.anchorB.x, -oJoint.anchorB.y );
			//-------------------------------------------------------	
			jointDef.localAxisA       = new b2Vec2( oJoint.localAxisA.x, -oJoint.localAxisA.y );				
			jointDef.enableLimit      = oJoint.enableLimit;
			jointDef.enableMotor      = oJoint.enableMotor;
			jointDef.lowerTranslation = oJoint.lowerLimit;
			jointDef.upperTranslation = oJoint.upperLimit;
			jointDef.maxMotorForce    = oJoint.maxMotorForce;
			jointDef.motorSpeed       = oJoint.motorSpeed;
			jointDef.referenceAngle   = oJoint.refAngle;
			//-------------------------------------------------------
			return jointDef;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------ Weld Joint
		//-----------------------------------------------------------------------------------------
		private static function createWeldJoint( oJoint:Object, vRubeObjects:Vector.<IRubeObject> ):b2WeldJointDef
		{
			var jointDef:b2WeldJointDef = new b2WeldJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (vRubeObjects[ oJoint.bodyA ] as RubeObject).body;
			jointDef.bodyB    = (vRubeObjects[ oJoint.bodyB ] as RubeObject).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			if ( !( oJoint.anchorA is Number) ) jointDef.localAnchorA.Set( oJoint.anchorA.x, -oJoint.anchorA.y );
			if ( !( oJoint.anchorB is Number) ) jointDef.localAnchorB.Set( oJoint.anchorB.x, -oJoint.anchorB.y );
			//-------------------------------------------------------
			jointDef.referenceAngle = oJoint.refAngle;
			//-------------------------------------------------------
			return jointDef;
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------- Friction Joint
		//-----------------------------------------------------------------------------------------
		private static function createFrictionJoint( oJoint:Object, vRubeObjects:Vector.<IRubeObject> ):b2FrictionJointDef
		{
			var jointDef:b2FrictionJointDef = new b2FrictionJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (vRubeObjects[ oJoint.bodyA ] as RubeObject).body;
			jointDef.bodyB    = (vRubeObjects[ oJoint.bodyB ] as RubeObject).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			if ( !( oJoint.anchorA is Number) ) jointDef.localAnchorA.Set( oJoint.anchorA.x, -oJoint.anchorA.y );
			if ( !( oJoint.anchorB is Number) ) jointDef.localAnchorB.Set( oJoint.anchorB.x, -oJoint.anchorB.y );
			//-------------------------------------------------------
			jointDef.maxForce  = oJoint.maxForce;
			jointDef.maxTorque = oJoint.maxTorque;
			//-------------------------------------------------------
			return jointDef;
		}
	}
}