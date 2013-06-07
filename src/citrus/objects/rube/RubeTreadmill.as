/**
 * @author Tungstene
 * @version 1.0.0 - 05/06/2013 23:08
 */

package citrus.objects.rube 
{
	import citrus.objects.platformer.box2d.Treadmill;
	
	public class RubeTreadmill extends Treadmill implements IRubeObject 
	{
		protected var oBody:Object;
		//-----------------------------------------------------------------------------------------
		protected var engine:RubeEngine = RubeEngine.getInstance();
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function RubeTreadmill( name:String, params:Object = null, oBody:Object = null ):void 
		{
			//-------------------------------------------------------
			super( name, params );
			//-------------------------------------------------------
			if ( params && params.x ) this.x = params.x * _box2D.scale;
			if ( params && params.y ) this.y = -params.y * _box2D.scale;
			//-------------------------------------------------------
			if ( params && params.startX ) startX = params.startX * _box2D.scale;
			if ( params && params.endX )   endX   = params.endX * _box2D.scale;
			if ( params && params.startY ) startY = -params.startY * _box2D.scale;
			if ( params && params.endY )   endY   = -params.endY * _box2D.scale;
			//-------------------------------------------------------
			this.oBody = oBody;
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
		}
		//-----------------------------------------------------------------------------------------
		//---------------------------------------------------------- Attribut les variables du BODY
		//-----------------------------------------------------------------------------------------
		override protected function defineBody():void
		{
			//-------------------------------------------------------
			super.defineBody();
			//-------------------------------------------------------
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------------------------ Création du BODY
		//-----------------------------------------------------------------------------------------
		override protected function createBody():void
		{
			//-------------------------------------------------------
			super.createBody();
			//-------------------------------------------------------
			engine.createBody( body, oBody );	
		}
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------- Attribut les variables des FIXTURES
		//-----------------------------------------------------------------------------------------
		override protected function defineFixture():void 
		{
			//-------------------------------------------------------
			super.defineFixture();
			//-------------------------------------------------------
			engine.defineFixture( _fixtureDef, body, oBody );
		}
		//-----------------------------------------------------------------------------------------
		//------------------------------------------------------ Renvoit une description de l'objet
		//-----------------------------------------------------------------------------------------
		public function toString( ):String
		{
			return "[ RubeTreadmill " +
					" name:"   + this.name +
					" x:"      + this.x +
					" y:"      + this.y +
					" active:" + (body ? body.IsActive() : "false") +
					" ]";
		}
	}
}