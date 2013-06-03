/**
 * @author Tungstene
 * @version 1.0.0 - 31/05/2013 15:22
 */

package citrus.utils.objectmakers 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	//---------------------------------------------------------------------------------------------
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.core.IState;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
	import citrus.objects.RubeObjects;
	//---------------------------------------------------------------------------------------------
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	//---------------------------------------------------------------------------------------------
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
		public static function FromRUBE( JSONData:String, addToCurrentState:Boolean = true ):Array 
		{
			var aItems:Array    = [];
			var oLevel:Object   = JSON.parse( JSONData );
			//-------------------------------------------------------
			if ( oLevel.body )   createBodies( oLevel.body, aItems );
			
			// Comment avoir le world autrement?
			var world:b2World = (aItems[0] as RubeObjects).body.GetWorld();
			if ( oLevel.joint ) createJoints( oLevel.joint, aItems, world );
			//if ( oLevel.image )  createImages( oLevel.image, aItems );
			//-------------------------------------------------------
			return aItems;
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------------------- Creation of BODIES
		//-----------------------------------------------------------------------------------------
		private static function createBodies( aBodies:Array, aItems:Array ):void
		{
			var oBody:Object;
			var rube:RubeObjects;
			var position:Point = new Point();
			var max:int        = aBodies.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oBody       = aBodies[i];
				position.x  = !(oBody.position is Number) && oBody.position.x ? oBody.position.x : 0;
				position.y  = !(oBody.position is Number) && oBody.position.y ? oBody.position.y : 0;
				//---------------------------------------------------
				rube = new RubeObjects( oBody.name, { x: position.x, y: position.y }, oBody );
				ce.state.add( rube );
				aItems.push( rube );				
			}
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------------------- Creation of JOINTS
		//-----------------------------------------------------------------------------------------
		private static function createJoints( aJoints:Array, aItems:Array, world:b2World ):void
		{
			var joint:b2JointDef;
			var oJoint:Object;
			var max:int = aJoints.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oJoint = aJoints[i];
				//---------------------------------------------------
				if (      oJoint.type == "revolute" )  joint = createRevoluteJoint( oJoint, aItems ); 
				else if ( oJoint.type == "distance" )  joint = createDistanceJoint( oJoint, aItems ); 
				else if ( oJoint.type == "prismatic" ) joint = createPrismaticJoint( oJoint, aItems ); 
				else if ( oJoint.type == "weld" )      joint = createWeldJoint( oJoint, aItems ); 
				else if ( oJoint.type == "friction" )  joint = createFrictionJoint( oJoint, aItems ); 
				else                                   throw new Error( "The joint :" + oJoint.type + " is not implemented!" ); 
				//---------------------------------------------------
				world.CreateJoint( joint );
			}
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------------------- Creation of IMAGES
		//-----------------------------------------------------------------------------------------
		private static function createImages( aImages:Array, aItems:Array ):void
		{
			/*var texture:Texture;
			var img:Image;
			var bmdData:BitmapData;
			var oImage:Object;
			var max:int = aImages.length;
			//-------------------------------------------------------
			for ( var i:int = 0; i < max; i++ ) 
			{
				oImage  = aImages[i];
				bmdData = new BitmapData(
				texture = Texture.fromBitmapData( bmpData, false, false );
				img     = new Image( texture );
				background = new CitrusSprite("background", { view:Image.fromBitmap(new Assets.bg1()) } );
			}*/
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------- Revolute Joint
		//-----------------------------------------------------------------------------------------
		private static function createRevoluteJoint( oJoint:Object, aItems:Array ):b2RevoluteJointDef
		{
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (aItems[ oJoint.bodyA ] as RubeObjects).body;
			jointDef.bodyB    = (aItems[ oJoint.bodyB ] as RubeObjects).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			jointDef.localAnchorA.Set( oJoint.anchorA.x, oJoint.anchorA.y );
			jointDef.localAnchorB.Set( oJoint.anchorB.x, oJoint.anchorB.y );
			//-------------------------------------------------------	
			jointDef.enableLimit    = oJoint.enableLimit;
			jointDef.enableMotor    = oJoint.enableMotor;
			jointDef.lowerAngle     = oJoint.lowerLimit;
			jointDef.upperAngle     = oJoint.upperLimit;
			jointDef.maxMotorTorque = oJoint.maxMotorTorque;
			jointDef.motorSpeed     = oJoint.motorSpeed;
			jointDef.referenceAngle = oJoint.refAngle;
			//-------------------------------------------------------
			return jointDef;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------- Prismatic Joint
		//-----------------------------------------------------------------------------------------
		private static function createDistanceJoint( oJoint:Object, aItems:Array ):b2DistanceJointDef
		{
			var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (aItems[ oJoint.bodyA ] as RubeObjects).body;
			jointDef.bodyB    = (aItems[ oJoint.bodyB ] as RubeObjects).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			jointDef.localAnchorA.Set( oJoint.anchorA.x, oJoint.anchorA.y );
			jointDef.localAnchorB.Set( oJoint.anchorB.x, oJoint.anchorB.y );
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
		private static function createPrismaticJoint( oJoint:Object, aItems:Array ):b2PrismaticJointDef
		{
			var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (aItems[ oJoint.bodyA ] as RubeObjects).body;
			jointDef.bodyB    = (aItems[ oJoint.bodyB ] as RubeObjects).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			jointDef.localAnchorA.Set( oJoint.anchorA.x, oJoint.anchorA.y );
			jointDef.localAnchorB.Set( oJoint.anchorB.x, oJoint.anchorB.y );
			//-------------------------------------------------------	
			jointDef.localAxisA     = new b2Vec2( oJoint.localAxisA.x, oJoint.localAxisA.y );				
			jointDef.enableLimit    = oJoint.enableLimit;
			jointDef.enableMotor    = oJoint.enableMotor;
			jointDef.maxMotorForce  = oJoint.maxMotorForce;
			jointDef.motorSpeed     = oJoint.motorSpeed;
			jointDef.referenceAngle = oJoint.refAngle;
			//-------------------------------------------------------
			return jointDef;
		}
		
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------ Weld Joint
		//-----------------------------------------------------------------------------------------
		private static function createWeldJoint( oJoint:Object, aItems:Array ):b2WeldJointDef
		{
			var jointDef:b2WeldJointDef = new b2WeldJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (aItems[ oJoint.bodyA ] as RubeObjects).body;
			jointDef.bodyB    = (aItems[ oJoint.bodyB ] as RubeObjects).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			jointDef.localAnchorA.Set( oJoint.anchorA.x, oJoint.anchorA.y );
			jointDef.localAnchorB.Set( oJoint.anchorB.x, oJoint.anchorB.y );
			//-------------------------------------------------------
			jointDef.referenceAngle = oJoint.refAngle;
			//-------------------------------------------------------
			return jointDef;
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------- Friction Joint
		//-----------------------------------------------------------------------------------------
		private static function createFrictionJoint( oJoint:Object, aItems:Array ):b2FrictionJointDef
		{
			var jointDef:b2FrictionJointDef = new b2FrictionJointDef();
			//-------------------------------------------------------
			jointDef.bodyA    = (aItems[ oJoint.bodyA ] as RubeObjects).body;
			jointDef.bodyB    = (aItems[ oJoint.bodyB ] as RubeObjects).body;
			jointDef.userData = { name: oJoint.name };
			//-------------------------------------------------------
			if ( oJoint.collideConnected ) jointDef.collideConnected = oJoint.collideConnected;
			//-------------------------------------------------------
			jointDef.localAnchorA.Set( oJoint.anchorA.x, oJoint.anchorA.y );
			jointDef.localAnchorB.Set( oJoint.anchorB.x, oJoint.anchorB.y );
			//-------------------------------------------------------
			jointDef.maxForce  = oJoint.maxForce;
			jointDef.maxTorque = oJoint.maxTorque;
			//-------------------------------------------------------
			return jointDef;
		}
	}
}