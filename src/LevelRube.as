/**
 * @author Tungstene
 * @version 1.0.0 - 30/05/2013 09:56
 */

package 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.utils.objectmakers.ObjectMakerStarling2;
	import starling.display.DisplayObject;
	
	public class LevelRube extends StarlingState
	{		
		private var JSONData:String;
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function LevelRube( JSONData:String ):void 
		{
			//-------------------------------------------------------
			super();
			//-------------------------------------------------------
			this.JSONData = JSONData;
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------- Initialisation
		//-----------------------------------------------------------------------------------------
		override public function initialize():void 
		{
			//-------------------------------------------------------
			super.initialize();
			//-------------------------------------------------------
			var box2d:Box2D = new Box2D("physics");
			box2d.world.SetGravity( new b2Vec2( 0, 10 ) );
			box2d.visible = true;
			add( box2d );
			//-------------------------------------------------------
			var hero:Hero = new Hero( "hero", { x:400, y:100, width:50, height: 50 } ); 
			hero.acceleration = 0.1
			hero.touchable = true;
			add( hero );
			//-------------------------------------------------------
			var bar:Platform = new Platform( "bar", { x:1024*0.5, y:760, width:1024, height: 20 } ); 
			bar.touchable = true;
			add( bar );
			//-------------------------------------------------------
			ObjectMakerStarling2.FromRUBE( JSONData );
		}
	}
}