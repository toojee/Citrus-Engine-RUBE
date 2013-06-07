/**
 * @author Tungstene
 * @version 1.0.0 - 06/06/2013 22:15
 */

package examples.rube 
{
	
	public class Assets 
	{
		[Embed(source="../../assets/images/atlas/Braid.png")]
		public static const braid:Class;
		
		[Embed(source = "../../assets/data/Braid.xml", mimeType="application/octet-stream")]
		public static const braidXML:Class;
	}
}