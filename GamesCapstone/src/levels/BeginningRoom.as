package levels 
{
	import cutscenes.BeginningCutscene;
	import org.flixel.FlxPoint;
	
	/**
	 * The beginning room in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class BeginningRoom extends Level
	{
		[Embed(source = "../../assets/room_beginning.csv", mimeType = "application/octet-stream")] public var _csv : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var _tilesetPNG : Class;
		
		public function BeginningRoom() 
		{
			super();
			
			map.loadMap(new _csv(), _tilesetPNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			
			// Find the map and set the player start position there.
			// 132 represets the upper left tile of the vent.
			playerStart = map.getTileCoords(132)[0];
			
			add(map);
			
			cutscene = new BeginningCutscene();
			add(cutscene);
		}
		
		public function get computerCoordinates() : FlxPoint
		{
			// Add 24 (a tile and a half) to get to the center of the computer.
			var location : FlxPoint = map.getTileCoords(160)[0];
			location.x += 24;
			return location;
		}
	}
}