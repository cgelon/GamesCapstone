package levels
{
	import items.Environmental.ForceField;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldIntro extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_EnemyPlatforms.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function ForceFieldIntro ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 296);
			playerEnd = new FlxPoint(1344, 168);
			// Stores the player start points
			
			enemyStarts[0] = new FlxPoint(528, 50);
			enemyTypes[0] = Robot;
			
			
			objectStarts[0] = null;
			objectTypes[0] = new ForceField([false, true, false, false], 160, 16, 16, 1);
			
			add(map);
		}
	}
}