package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import items.Environmental.Crate;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.LightningRobot;
	import states.State;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidSwitches extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_AcidSwitches.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function AcidSwitches ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points

			enemyStarts[0] = new FlxPoint(1093, 250);
			enemyTypes[0] = LightningRobot;
			// Stores the enemy start points
			
			var leverLocs : Array = [new FlxPoint(144, 271), new FlxPoint(624, 161)];
			var acidFlowLocs : Array = [new FlxPoint(240, 226), new FlxPoint(720, 77)];
			for (var i: int = 0; i < leverLocs.length; i++) {
				backgroundCircuits.push(true);
				backgroundStarts[2 * i] = leverLocs[i];
				backgroundTypes[2 * i] = Lever;
				backgroundStarts[2 * i + 1] = acidFlowLocs[i];
				backgroundTypes[2 * i + 1] = AcidFlow;
			}
			var acidLocs : Array = [new FlxPoint(208, 6), new FlxPoint(592, 18)];
			var sum : int = 0;
			for (i = 0; i < acidLocs.length; i++)
			{
				var pair : FlxPoint = acidLocs[i];
				for (var j: int = 0; j < pair.y; j++) {
					backgroundStarts[backgroundCircuits.length * 2 + sum] = new FlxPoint(pair.x + 16 * j, 336);
					backgroundTypes[backgroundCircuits.length * 2 + sum] = Acid;
					sum++;
				}
			}
			add(map);
		}
	}
}