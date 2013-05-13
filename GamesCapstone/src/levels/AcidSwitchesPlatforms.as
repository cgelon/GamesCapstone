package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidSwitchesPlatforms extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_AcidSwitchesPlatforms.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function AcidSwitchesPlatforms ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 312);
			// Stores the player start points
			
			var leverLocs : Array = [new FlxPoint(720, 304)];
			var acidFlowLocs : Array = [new FlxPoint(864, 241)];
			for (var i: int = 0; i < leverLocs.length; i++) {
				backgroundStarts.push(leverLocs[i]);
				backgroundTypes.push(Lever);
				backgroundStarts.push(acidFlowLocs[i]);
				backgroundTypes.push(AcidFlow);
				backgroundCircuits.push(true);
			}
			
			var acidLocs : Array = [new FlxPoint(240, 26)];
			var sum : int = 0;
			for (i = 0; i < acidLocs.length; i++)
			{
				var pair : FlxPoint = acidLocs[i];
				for (var j: int = 0; j < pair.y; j++) {
					backgroundStarts[backgroundCircuits.length * 2 + sum] = new FlxPoint(pair.x + 16 * j, 352);
					backgroundTypes[backgroundCircuits.length * 2 + sum] = Acid;
					sum++;
				}
			}
			add(map);
		}
	}
}