package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Crate;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidCrates extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_AcidCrates.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function AcidCrates ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 304);
			// Stores the player start points
			
			backgroundStarts[0] = new FlxPoint(368, 160);
			backgroundTypes[0] = AcidFlow;
			
			objectStarts[0] = new FlxPoint(288, 192);
			objectTypes[0] = Crate;
			
			add(map);
		}
	}
}