/**
 * @author Tungstene
 * @version 1.0.2 - 07/06/2013 14:28
 */

package examples.rube
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import starling.core.Starling;
	
	public class Rube extends StarlingCitrusEngine 
	{
		//-----------------------------------------------------------------------------------------
		//----------------------------------------------------------------- Fonction - constructeur
		//-----------------------------------------------------------------------------------------
		public function Rube():void 
		{
			//-------------------------------------------------------
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align     = StageAlign.TOP_LEFT;
			//-------------------------------------------------------
			setUpStarling(true);
			//-------------------------------------------------------
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, levelLoaded);
			loader.load( new URLRequest("assets/levels/level_01.json") )
		}
		//-----------------------------------------------------------------------------------------
		//-------------------------------------------------------------- Chargement complet du JSON
		//-----------------------------------------------------------------------------------------
		private function levelLoaded( e:Event ):void 
		{
			//-------------------------------------------------------
			var level:LevelRube = new LevelRube( String (e.target.data) );
			state               = level;
			//-------------------------------------------------------
		}
	}
}
