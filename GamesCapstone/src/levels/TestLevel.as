package levels
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Chris Gelon
	 */
	public class TestLevel extends Level 
	{
		[Embed(source = "../../assets/test.csv", mimeType = "application/octet-stream")] public var testCSV : Class;
		[Embed(source = "../../assets/test_tiles.png")] public var testPNG : Class;
		
		
		public function TestLevel() 
		{
			super();
			
			map.loadMap(new testCSV(), testPNG, 16, 16, 0, 0, 1, 1);
			
			width = map.width;
			height = map.height;
			playerStart = new FlxPoint(40, height / 3);
			enemyStarts[0] = new FlxPoint(width / 3, height / 5);
			
			add(map);
		}
	}
}