package levels
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Chris Gelon
	 */
	public class TestLevel extends FlxGroup 
	{
		[Embed(source = "../../assets/test.csv", mimeType = "application/octet-stream")] public var testCSV : Class;
		[Embed(source = "../../assets/test_tiles.png")] public var testPNG : Class;
		
		public var map : FlxTilemap;
		public var width : int;
		public var height : int;
		
		public function TestLevel() 
		{
			super();
			
			map = new FlxTilemap();
			map.loadMap(new testCSV(), testPNG, 16, 16, 0, 0, 1, 1);
			
			width = map.width;
			height = map.height;
			
			add(map);
		}
	}
}