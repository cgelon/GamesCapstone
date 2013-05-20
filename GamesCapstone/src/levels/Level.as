package levels
{
	import cutscenes.engine.Cutscene;
	import items.Environmental.Crate;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.LightningRobot;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class Level extends FlxGroup 
	{
		
		public var map : FlxTilemap;
		public var width : int;
		public var height : int;
		public var playerStart: FlxPoint;
		public var playerEnd : FlxPoint;
		public var enemyStarts: Array;
		public var enemyTypes: Array;
		public var backgroundStarts: Array;
		public var backgroundTypes: Array;
		public var objectStarts: Array;
		public var objectTypes: Array;
		public var doorLocs: Array;
		public var backgroundCircuits: Array;
		public var environmentalCircuits: Array;
		public var cutscene : Cutscene;
		
		public var loadMessage : String;
		
		public function Level() 
		{
			super();
			
			map = new FlxTilemap();
			enemyStarts = new Array();
			enemyTypes = new Array();
			backgroundStarts = new Array();
			backgroundTypes = new Array();
			objectStarts = new Array();
			objectTypes = new Array();
			doorLocs = new Array();
			backgroundCircuits = new Array();
			environmentalCircuits = new Array();
			
			loadMessage = null;
		}
		
		public function parsePlayer(playerCSV: Class, tilePNG: Class) : void
		{
			var playerTilemap : FlxTilemap = new FlxTilemap();
			playerTilemap.loadMap(new playerCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			// top left of player sprite
			var playerLocs : Array = playerTilemap.getTileCoords(544).sortOn("x", Array.NUMERIC)
			playerStart = playerLocs[0];
			playerEnd = playerLocs[1];
		}
		
		// only handles crates for now
		public function parseObjects(objectsCSV: Class,  tilePNG: Class) : void
		{
			var objectsTilemap : FlxTilemap = new FlxTilemap();
			objectsTilemap.loadMap(new objectsCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			// top left of crate sprite
			var crateLocs : Array = objectsTilemap.getTileCoords(162).sortOn("x", Array.NUMERIC)
			for (var i: int = 0; i < crateLocs.length; i++) {
				objectStarts.push(new FlxPoint(crateLocs[i].x - 8, crateLocs[i].y - 8));
				objectTypes.push(Crate);
			}
		}
		
		public function parseEnemies(enemiesCSV: Class,  tilePNG: Class) : void
		{
			var enemiesMap : FlxTilemap = new FlxTilemap();
			enemiesMap.loadMap(new enemiesCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			// top left of robot sprite
			var robotLocs : Array = enemiesMap.getTileCoords(546)
			if (robotLocs != null)
			{
				robotLocs = robotLocs.sortOn("x", Array.NUMERIC);
				for (var i: int = 0; i < robotLocs.length; i++) {
					enemyStarts.push(robotLocs[i]);
					enemyTypes.push(Robot);
				}
			}
			// top left of LightningRobot sprite
			var lightningRobotLocs : Array = enemiesMap.getTileCoords(548)
			if (lightningRobotLocs != null)
			{
				lightningRobotLocs = lightningRobotLocs.sortOn("x", Array.NUMERIC);
				for (i = 0; i < lightningRobotLocs.length; i++) {
					enemyStarts.push(lightningRobotLocs[i]);
					enemyStarts.push(LightningRobot);
				}
			}
		}
	}
}