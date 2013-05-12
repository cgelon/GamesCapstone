package levels
{
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.LightningRobot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldSwitches extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_ForcefieldSwitches.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function ForceFieldSwitches ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points
			
			enemyStarts[0] = new FlxPoint(528, 50);
			enemyTypes[0] = LightningRobot;
			
			objectStarts[0] = null;
			objectTypes[0] = new ForceField([false, true, false, false], 160, 288, 3, 1);
			
			objectStarts[1] = new FlxPoint(208, 240);
			objectTypes[1] = Generator;
			environmentalCircuits.push(true);
			
			add(map);
		}
	}
}