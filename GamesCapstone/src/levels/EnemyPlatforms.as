package levels
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class EnemyPlatforms extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_EnemyPlatforms.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function EnemyPlatforms ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points
			
			enemyStarts[0] = new FlxPoint(528, 50);
			enemyTypes[0] = Robot;
			
			add(map);
		}
	}
}