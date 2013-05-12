package levels
{
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldAndAcid extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_ForcefieldsAndAcid.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function ForceFieldAndAcid ()
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
			
			// Add the Forcefields and Generators
			objectStarts[0] = null;
			objectTypes[0] = new ForceField([true, true, false, true], 288, 256, 5, 9);
			
			objectStarts[1] = new FlxPoint(352, 304);
			objectTypes[1] = Generator;
			environmentalCircuits.push(true);
			
			objectStarts[2] = null;
			objectTypes[2] = new ForceField([false, true, true, true], 288, 16, 16, 9);
			
			objectStarts[3] = new FlxPoint(352, 304);
			objectTypes[3] = Generator;
			environmentalCircuits.push(true);
			
			
			// Add the Acidflow and its lever
			backgroundStarts[0] = new FlxPoint(384, 176);
			backgroundTypes[0] = AcidFlow;
			backgroundStarts[1] = new FlxPoint(240, 112);
			backgroundTypes[1] = Lever;
			backgroundCircuits.push(false);
			
			add(map);
		}
	}
}