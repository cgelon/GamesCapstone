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

			playerStart = new FlxPoint(16, 312);
			playerEnd = new FlxPoint(640, 312);
			
			loadMessage = "Here's a little known fact: crates in this lab resist highly corrosive acid.  Who knew?";
			
			backgroundStarts[0] = new FlxPoint(368, 144);
			backgroundTypes[0] = AcidFlow;
			
			objectStarts[0] = new FlxPoint(288, 192);
			objectTypes[0] = Crate;
			
			add(map);
		}
	}
}