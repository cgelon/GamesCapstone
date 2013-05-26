package levels
{
	import cutscenes.engine.Cutscene;
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import items.Environmental.Crate;
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.LightningRobot;
	import people.enemies.Robot;
	import people.enemies.BossEnemy;
	
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
			var crateLocs : Array = objectsTilemap.getTileCoords(162);
			if (crateLocs != null)
			{
				crateLocs = crateLocs.sortOn("x", Array.NUMERIC);
				for (var i: int = 0; i < crateLocs.length; i++)
				{
					objectStarts.push(new FlxPoint(crateLocs[i].x - 8, crateLocs[i].y - 8));
					objectTypes.push(Crate);
				}
			}
			
			var generatorLocs : Array = objectsTilemap.getTileCoords(550);
			if (generatorLocs != null)
			{
				generatorLocs = generatorLocs.sortOn("x", Array.NUMERIC);
				for (var j: int = 0; j < generatorLocs.length; j++)
				{
					objectStarts.push(new FlxPoint(generatorLocs[j].x - 8, generatorLocs[j].y - 8));
					objectTypes.push(Generator);
				}
			}
			
			// Gets the top forcefield source
			var topVert : Array = objectsTilemap.getTileCoords(457);
			// Gets the bottom forcefield source (these should always be paired)
			var bottomVert : Array = objectsTilemap.getTileCoords(488);
			
			// Gets the left forcefield source
			var leftHoriz : Array = objectsTilemap.getTileCoords(456);
			// Gets the right forcefield source (these should always be paired)
			var rightHoriz : Array = objectsTilemap.getTileCoords(489);
			
			// Checks if corners are even possible
			if (topVert != null && leftHoriz != null)
			{
				// Gets the corners of the forcefield, if they exist.  They may not
				var upperLeftCorner : Array = objectsTilemap.getTileCoords(363);
				var upperRightCorner : Array = objectsTilemap.getTileCoords(364);
				var lowerLeftCorner : Array = objectsTilemap.getTileCoords(395);
				var lowerRightCorner : Array = objectsTilemap.getTileCoords(396);
				
				// Sorts the values based on the x coordinate
				topVert = topVert.sortOn("x", Array.NUMERIC);
				bottomVert = bottomVert.sortOn("x", Array.NUMERIC);
				leftHoriz = leftHoriz.sortOn("x", Array.NUMERIC);
				rightHoriz = rightHoriz.sortOn("x", Array.NUMERIC);
				
				// Sorts the values based on the x coordinate if they exist
				if (upperLeftCorner != null)
				{
					upperLeftCorner = upperLeftCorner.sortOn("x", Array.NUMERIC);
				}
				if (upperRightCorner != null)
				{
					upperRightCorner = upperRightCorner.sortOn("x", Array.NUMERIC);
				}
				if (lowerLeftCorner != null)
				{
					lowerLeftCorner = lowerLeftCorner.sortOn("x", Array.NUMERIC);
				}
				if (lowerRightCorner != null)
				{
					lowerRightCorner = lowerRightCorner.sortOn("x", Array.NUMERIC);
				}
			}
			else
			{
				// There may only be vertical bars, or only horizontal bars, or none at all
				
				if (topVert != null)
				{
					// Since all top verts must be paired with a bottom vert, it is
					// fine not to test if the bottom vert array exists when we know the top does
					topVert = topVert.sortOn("x", Array.NUMERIC);
					bottomVert = bottomVert.sortOn("x", Array.NUMERIC);	
					
					var s1: Array = [false, true, false, false]; 
					// We only have one side, call it the right one
					for (var k: int = 0; k < topVert.length; k++)
					{
						var h1: int = bottomVert[k].y - topVert[k].y;
						h1 = h1 / 16;
						var w1: int = 1;
						objectStarts[objectStarts.length] = null;
						objectTypes[objectTypes.length] = new ForceField(s1, topVert[k].x, topVert[k].y, h1, w1);
					}
					
				}
				if (leftHoriz != null)
				{
					// Since all left horizs must be paired with a right horiz, it is
					// fine not to test if the right horiz array exists when we know the left does
					leftHoriz = leftHoriz.sortOn("x", Array.NUMERIC);
					rightHoriz = rightHoriz.sortOn("x", Array.NUMERIC);
					
					var s2: Array = [true, false, false, false]; 
					// We only have one side, call it the top one
					for (var l: int = 0; l < topVert.length; l++)
					{
						var h2: int = 1;
						var w2: int = rightHoriz[l].x - leftHoriz[l].x;
						w2 = w2 / 16;
						objectStarts[l * 2] = null;
						objectTypes[l * 2] = new ForceField(s2, leftHoriz[l].x, leftHoriz[l].y, h2, w2);
					}
				}
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
				for (var i: int = 0; i < robotLocs.length; i++)
				{
					enemyStarts.push(robotLocs[i]);
					enemyTypes.push(Robot);
				}
			}
			// top left of LightningRobot sprite
			var lightningRobotLocs : Array = enemiesMap.getTileCoords(548)
			if (lightningRobotLocs != null)
			{
				lightningRobotLocs = lightningRobotLocs.sortOn("x", Array.NUMERIC);
				for (i = 0; i < lightningRobotLocs.length; i++)
				{
					enemyStarts.push(lightningRobotLocs[i]);
					enemyTypes.push(LightningRobot);
				}
			}
		}
		
		public function parseBackground(backgroundCSV: Class, tilePNG: Class) : void
		{
			var backgroundTilemap : FlxTilemap = new FlxTilemap();
			backgroundTilemap.loadMap(new backgroundCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			var acidLocs : Array = backgroundTilemap.getTileCoords(454)
			if (acidLocs != null)
			{
				for (var i: int = 0; i < acidLocs.length; i++)
				{
					backgroundStarts.push(new FlxPoint(acidLocs[i].x - 8, acidLocs[i].y - 8));
					backgroundTypes.push(Acid);
				}
			}
			acidLocs = backgroundTilemap.getTileCoords(455)
			if (acidLocs != null)
			{
				for (i = 0; i < acidLocs.length; i++)
				{
					backgroundStarts.push(new FlxPoint(acidLocs[i].x - 8, acidLocs[i].y - 8));
					backgroundTypes.push(Acid);
				}
			}

			var acidFlowLocs : Array = backgroundTilemap.getTileCoords(486);
			if (acidFlowLocs != null)
			{
				acidFlowLocs = acidFlowLocs.sortOn("x", Array.NUMERIC);
				for (i = 0; i < acidFlowLocs.length; i++)
				{
					backgroundStarts.push(new FlxPoint(acidFlowLocs[i].x - 8, acidFlowLocs[i].y - 24));
					backgroundTypes.push(AcidFlow);
				}
			}
			
			var leverLocs : Array = backgroundTilemap.getTileCoords(196);
			if (leverLocs != null)
			{
				leverLocs = leverLocs.sortOn("x", Array.NUMERIC);
				for (i = 0; i < leverLocs.length; i++)
				{
					backgroundStarts.push(new FlxPoint(leverLocs[i].x - 8, leverLocs[i].y - 8));
					backgroundTypes.push(Lever);
				}
			}
		}
	}
}