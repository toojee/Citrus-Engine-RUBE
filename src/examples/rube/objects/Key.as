/**
 * @author Tungstene
 * @version 1.0.0 - 06/06/2013 14:15
 */

package examples.rube.objects 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.rube.IRubeObject;
	import citrus.objects.rube.RubeCoin;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	public class Key extends RubeCoin implements IRubeObject 
	{
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function Key( name:String, params:Object = null, oBody:Object = null ):void 
		{
			//-------------------------------------------------------
			super( name, params, oBody );
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------- Quand la clé rentre en collision
		//-----------------------------------------------------------------------------------------
		override public function handleBeginContact( contact:b2Contact ):void
		{
			//-------------------------------------------------------
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther( this, contact );
			//-------------------------------------------------------
			if (_collectorClass && collider is _collectorClass) (collider as BraidHero).keySlot = this;
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------------- Permet d'inversé l'objet
		//-----------------------------------------------------------------------------------------
		public function set inverted( value:Boolean ):void
		{
			_inverted = value;
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------ Renvoit une description de l'objet
		//-----------------------------------------------------------------------------------------
		override public function toString( ):String
		{
			return "[ Key " +
					" name:"   + this.name +
					" x:"      + this.x +
					" y:"      + this.y +
					" active:" + (body ? body.IsActive() : "false") +
					" ]";
		}
	}
}