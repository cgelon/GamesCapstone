package levels
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Chris Gelon
	 */
	public class EvilLabVatLevel extends Level 
	{
		[Embed(source = "../../assets/mapCSV_Group2_Evil_Lab_Lair_-_Vats.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
			
		
		public function EvilLabVatLevel() 
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			playerStart = new FlxPoint(40, height / 5);
			enemyStarts[0] = new FlxPoint(width / 4, height / 3);
			enemyStarts[1] = new FlxPoint(3 * width / 4 - 170, height / 3);
			
			add(map);
		}
	}
}