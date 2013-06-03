/**
 * @author Tungstene
 * @version 1.0.0 - 28/05/2013 14:28
 */

package
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.objectmakers.ObjectMakerStarling2;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class RubeMain extends StarlingCitrusEngine 
	{
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------------------- Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function RubeMain():void 
		{
			//-------------------------------------------------------
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align     = StageAlign.TOP_LEFT;
			//-------------------------------------------------------
			setUpStarling(true);
			//-------------------------------------------------------
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, levelLoaded);
			loader.load(new URLRequest("rube.json"))
		}
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------------- Au chargement complet du JSON
		//-----------------------------------------------------------------------------------------
		private function levelLoaded( e:Event ):void 
		{
			var level:LevelRube = new LevelRube( String (e.target.data) );
			state = level;
		}
	}
}
