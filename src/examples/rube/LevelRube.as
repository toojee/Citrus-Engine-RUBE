/**
 * @author Tungstene
 * @version 1.0.1 - 05/06/2013 16:12
 */

package examples.rube 
{
	import citrus.core.starling.StarlingState;
	import citrus.math.MathVector;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.rube.IRubeObject;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling2;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;
	import examples.rube.objects.BraidEnemy;
	import examples.rube.objects.BraidHero;
	import examples.rube.objects.Key;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
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
			box2d.visible = true;
			add( box2d );
			//-------------------------------------------------------
			var vCustomClass:Vector.<Class> = new Vector.<Class>();
			vCustomClass.push( Key, BraidHero, BraidEnemy );
			//-------------------------------------------------------
			var vRubeObjects:Vector.<IRubeObject> = ObjectMakerStarling2.FromRUBE( JSONData, vCustomClass );
			//-------------------------------------------------------
			//-------------------------------------------------------
			//-------------------------------------------------------
			var atlas:TextureAtlas = new TextureAtlas( Texture.fromBitmap(new Assets.braid()), new XML(new Assets.braidXML()) );
			//-------------------------------------------------------
			var braid:BraidHero            = getObjectByName( "braid" ) as BraidHero;	
			braid.maxVelocity              = 15
			var heroAnim:AnimationSequence = new AnimationSequence( atlas, ["idle", "jump_prep_straight", "running", "fidget", "falling_downward", "looking_downward", "looking_upward", "dying", "dying_loop"], "idle", 30, true);
			heroAnim.scaleX                = 0.6;
			heroAnim.scaleY                = 0.6;
			braid.view                     = heroAnim;
			//-------------------------------------------------------
			view.camera.setUp( braid.camTarget, new MathVector( stage.stageWidth >> 1, stage.stageHeight >> 1 ), new Rectangle(0, 0, 2400, 1200), new MathVector(.25, .25));
			//-------------------------------------------------------
			var enemy:BraidEnemy            = getObjectByName( "enemy" ) as BraidEnemy;	
			var enemyAnim:AnimationSequence = new AnimationSequence( atlas, ["monster-walking", "monster-dying"], "monster-walking", 30, true);
			enemyAnim.scaleX                = 0.6;
			enemyAnim.scaleY                = 0.6;
			enemy.view                      = enemyAnim;
			//-------------------------------------------------------
			var key:Key      = getObjectByName( "key" ) as Key;	
			var keyImg:Image = new Image( atlas.getTexture("key1") );
			keyImg.scaleX    = 0.6;
			keyImg.scaleY    = 0.4;
			key.view         = keyImg
			//-------------------------------------------------------
			StarlingArt.setLoopAnimations(["idle", "running", "monster-walking", "dying_loop"]);			
		}
	}
}