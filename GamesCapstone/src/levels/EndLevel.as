package levels
{
	import items.Environmental.Background.EnemySpawner;
	import items.Environmental.Background.Lever;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class EndLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_EndLevel.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function EndLevel ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points
			
			
			// Add the Acidflow and its lever
			backgroundStarts[0] = new FlxPoint(288, 128);
			backgroundTypes[0] = EnemySpawner;
			backgroundStarts[1] = new FlxPoint(240, 192);
			backgroundTypes[1] = Lever;
			backgroundCircuits.push(false);
			
			add(map);
		}
	}
}