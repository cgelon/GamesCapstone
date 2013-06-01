package managers
{
	import items.Environmental.Background.BackgroundInterface;
	import items.Environmental.Background.Circuit.Circuit;
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class BackgroundManager extends Manager 
	{
		public var triggers : Array;
		public var reactors : Array;
		public var numCircuits : Number;
		
		public function BackgroundManager() {
			triggers = new Array();
			reactors = new Array();
			numCircuits = 0;
		}
		
		public function addObject (location: FlxPoint, object:Class) : void
		{
			var obj : BackgroundInterface = new object(location.x, location.y) as BackgroundInterface;
			if (obj != null)
			{
				// If the object provided is a BackgroundItem, add it straight to the level
				obj.playStart();
				obj.track(this);
				obj.addTo(this);
			}
		}
		
		public function addCircuit (activated: Boolean) : void
		{
			var circuit : Circuit = new Circuit(triggers[numCircuits], reactors[numCircuits], activated);
			add(circuit);
			if (activated) {
				add(reactors[numCircuits]);
			} else {
				remove(reactors[numCircuits]);
			}
			numCircuits++;
		}
		
		public function getCircuit(index : int) : Circuit
		{
			var circuitsSeen : int = 0;
			for each (var obj : FlxBasic in members)
			{
				if (obj != null && obj is Circuit)
				{
					if (circuitsSeen == index)
					{
						return obj as Circuit;
					}
					else
					{
						circuitsSeen++;
					}
				}
			}
			return null;
		}
	}	
}