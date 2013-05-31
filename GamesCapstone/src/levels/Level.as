package levels
{
	import cutscenes.engine.Cutscene;
	import cutscenes.TheInformant;
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import items.Environmental.BlastDoor;
	import items.Environmental.Crate;
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import managers.Manager;
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
		
		protected var _informantTalked : Array;
		
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
			_informantTalked = new Array();
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
				
				// Initializes all the traversal ints I will need.  ulc - upperLeftCorner,
				// urc - upperRightCorner, llc - lowerLeftCorner, lrc - lowerRightCorner
				var verts: int = 0;
				var horizs: int = 0;
				var ulc: int = 0;
				var urc: int = 0;
				var llc: int = 0;
				var lrc: int = 0;
				// fill these with dummy values for now
				var sides: Array = [false, false, false, false]; 
				var height: int = 1;
				var width: int = 1;
				
				// Watch out, this is going to get complicated.  
				while (verts < topVert.length && horizs < leftHoriz.length)
				{
					objectStarts.push(null);
					if (topVert[verts].x < leftHoriz[horizs].x) 
					{
						if (upperLeftCorner != null && 
							upperLeftCorner[ulc].x == topVert[verts].x &&
							upperLeftCorner[ulc].y == topVert[verts].y - 16)
						{
							// This means that the vertical edge we have is the left edge
							sides[3] = true;
							// And that we should have a top edge, too
							sides[0] = true;
							height = bottomVert[verts].y - topVert[verts].y;
							height = height / 16;
							width = rightHoriz[horizs].x - leftHoriz[horizs].x;
							width = width / 16;
							ulc++;
						}
						if (lowerLeftCorner != null &&
							lowerLeftCorner[llc].x == topVert[verts].x &&
							(lowerLeftCorner[llc].y == leftHoriz[horizs].y ||
							 lowerLeftCorner[llc].y == leftHoriz[horizs + 1].y)) 
						{
							// We know the vertical edge is the left edge.  There are two
							// possibilities for the first horizontal edge, though: it
							// could be the top edge (which means we've already taken care of it
							// and need to look at the next horizontal edge) or it could be the
							// bottom edge, in which case we are taking care of it now
							// Either way, we take the same action
							
							sides[3] = true;
							// The presence of the corner means we have both a left and a bottom edge
							sides[2] = true;
							// Determine the height and width (note: even if these were set before by
							// the check for the upper left corner, setting it again should be fine)
							height = bottomVert[verts].y - topVert[verts].y;
							height = height / 16;
							width = rightHoriz[horizs].x - leftHoriz[horizs].x;
							width = width / 16;
							llc++;
						}
						if (upperRightCorner != null &&
							upperRightCorner[urc].x == topVert[verts + 1].x &&
							(upperRightCorner[urc].y == leftHoriz[horizs].y ||
							 upperRightCorner[urc].y == leftHoriz[horizs + 1].y))
						{
							// Because topVert[verts].x < leftHoriz[horizs].x, we know that if the right side
							// exists, it must be found at topVert[verts + 1], so we only need to compare that
							// x coordinate.  We also know that at least one of leftHoriz[horizs] or leftHoriz[horizs+1]
							// is on the top and the other is on the bottom or nonexistant.  Which one it is doesn't matter
							// because matching at least one means that we have an upper right corner
							sides[1] = true;
							sides[0] = true;
							// Because topVert[verts].x < leftHoriz[horizs].x, we know that the height and width must
							// be set already because we would have encountered the upperLeftCorner (having both a right
							// side and because we know we have a top side)
							urc++;
						}
						if (lowerRightCorner != null &&
							lowerRightCorner[lrc].x == topVert[verts + 1].x &&
							(lowerRightCorner[lrc].y == leftHoriz[horizs].y ||
							 lowerRightCorner[lrc].y == leftHoriz[horizs + 1].y))
						{
							// Because topVert[verts].x < leftHoriz[horizs].x, we know that if the right side
							// exists, it must be found at topVert[verts + 1], so we only need to compare that
							// x coordinate.  We also know that at least one of leftHoriz[horizs] or leftHoriz[horizs+1]
							// is on the top or nonexistant and the other is on the bottom.  Which one it is doesn't matter
							// because matching at least one means that we have an lower right corner
							sides[1] = true;
							sides[2] = true;
							// Because topVert[verts].x < leftHoriz[horizs].x, we know that the height and width must
							// be set already because we would have encountered the lowerLeftCorner (having both a right
							// side and because we know we have a bottom side)
							lrc++;
						}
						
						
						if (!sides[0] && !sides[2])
						{
							// In this case, we have not found a corner block, meaning that we have a single vertical forcefield.
							// We're going to pretend it is on the right side
							sides[1] = true;
							height = bottomVert[verts].y - topVert[verts].y;
							height = height / 16;
							width = 1;
							// The -8 is because DAME is a bitch, not a dame.  Same with the + 1
							objectTypes.push(new ForceField(sides, topVert[verts].x - 8, topVert[verts].y - 8, height + 1, width));
							verts++;
						}
						else
						{
							// There exists at least one corner block
							// To account for corner offset
							if (sides[1])
							{
								width = width + 2;
							}
							else
							{
								width = width + 1;
							}
							if (sides[0] && sides[2])
							{
								height = height + 2;
								// Need to offset the y coordinate from topVert[verts].y because it is not the actual corner
								// The -8 is because DAME is a bitch, not a dame.
								objectTypes.push(new ForceField(sides, topVert[verts].x - 8, leftHoriz[horizs].y - 8, height + 1, width + 1));
							}
							else
							{
								height = height + 1;
								if (sides[0])
								{
									// The -8 is because DAME is a bitch, not a dame.
									objectTypes.push(new ForceField(sides, topVert[verts].x - 8, leftHoriz[horizs].y - 8, height + 1, width + 1));
								}
								else 
								{
									// The -8 is because DAME is a bitch, not a dame.
									objectTypes.push(new ForceField(sides, topVert[verts].x - 8, topVert[verts].y - 8, height + 1, width + 1));
								}
							}							
							// We know that the left side exists, so utilize its starting x and y coordinate
							if (sides[1])
							{
								// The right side also exists, so must increment verts by 2 instead of just 1
								verts = verts + 2;
							}
							else
							{
								verts++;
							}
							
							if (sides[0] && sides[2])
							{
								// Both a top and a bottom exist, so increment horizs by 2
								horizs = horizs + 2;
							}
							else
							{
								// Because we know one corner block exists, and not both a top and a bottom exist,
								// there must be one of them, so increment horizs by 1
								horizs++;
							}							
						}
					}
					else
					{
						// Means we have a horizontal forcefield before a vertical one.  This occurs in one of four
						// cases out of eleven.
						if (upperRightCorner != null &&
							upperRightCorner[urc].x == topVert[verts].x &&
							(upperRightCorner[urc].y == leftHoriz[horizs].y ||
							 upperRightCorner[urc].y == leftHoriz[horizs + 1].y))
						{
							// Because topVert[verts].x >= leftHoriz[horizs].x, we know that if the right side
							// exists, it must be found at topVert[verts], so we only need to compare that
							// x coordinate.  We also know that at least one of leftHoriz[horizs] or leftHoriz[horizs+1]
							// is on the top and the other is on the bottom or nonexistant.  Which one it is doesn't matter
							// because matching at least one means that we have an upper right corner
							sides[1] = true;
							sides[0] = true;
							height = bottomVert[verts].y - topVert[verts].y;
							height = height / 16;
							width = rightHoriz[horizs].x - leftHoriz[horizs].x;
							width = width / 16;
							urc++;
						}
						
						if (lowerRightCorner != null &&
							lowerRightCorner[lrc].x == topVert[verts].x &&
							(lowerRightCorner[lrc].y == leftHoriz[horizs].y ||
							 lowerRightCorner[lrc].y == leftHoriz[horizs + 1].y))
						{
							// Because topVert[verts].x >= leftHoriz[horizs].x, we know that if the right side
							// exists, it must be found at topVert[verts], so we only need to compare that
							// x coordinate.  We also know that at least one of leftHoriz[horizs] or leftHoriz[horizs+1]
							// is on the top or nonexistant and the other is on the bottom.  Which one it is doesn't matter
							// because matching at least one means that we have an lower right corner
							sides[1] = true;
							sides[2] = true;
							height = bottomVert[verts].y - topVert[verts].y;
							height = height / 16;
							width = rightHoriz[horizs].x - leftHoriz[horizs].x;
							width = width / 16;
							lrc++;
						}
						
						if (!sides[1])
						{
							// In this case, we have not found a corner block, meaning that we have a single horizontal forcefield.
							// We're going to pretend it is on the top side
							sides[0] = true;
							height = 1;
							width = rightHoriz[horizs].x - leftHoriz[horizs].x;
							width = width / 16;
							// The -8 is because DAME is a bitch, not a dame.
							objectTypes.push(new ForceField(sides, leftHoriz[horizs].x - 8, leftHoriz[horizs].y - 8, height, width + 1));
							horizs++;
						}
						else
						{
							// The width must increase by 1, since we have a corner block
							width++;
							if (sides[0] && sides[2])
							{
								// We have both a top and a bottom, so increase the height by 2
								height = height + 2;
							}
							else
							{
								// We only have one, so increase the height by 1 for the corner
								height++;
							}
							if (sides[0])
							{
								// Since we can't assume that leftHoriz[horizs] is the top side, we must utilize the right side we know
								// we have for the y coordinate.
								// The -8 is because DAME is a bitch, not a dame.
								objectTypes.push(new ForceField(sides, leftHoriz[horizs].x - 8, topVert[verts].y - 24, height + 1, width + 1));
							}
							else
							{
								// We don't have a top side, so no need to modify verts' y coordinate								
								// The -8 is because DAME is a bitch, not a dame.
								objectTypes.push(new ForceField(sides, leftHoriz[horizs].x - 8, topVert[verts].y - 8, height + 1, width + 1));
							}
							verts++;
							if (sides[0] && sides[2])
							{
								// We have both a top and a bottom, so increase horizs by 2
								horizs = horizs + 2;
							}
							else
							{
								// We only have one, so increase horizs by 1
								horizs++;
							}
						}
					}
					sides = [false, false, false, false];
				}
				// Handles the case where the last forcefield is isolated rather than part of a box
				if (verts < topVert.length)
				{
					// We have a single vertical forcefield.
					// We're going to pretend it is on the right side
					objectStarts.push(null);					
					sides[1] = true;
					height = bottomVert[verts].y - topVert[verts].y;
					height = height / 16;
					width = 1;
					// The -8 is because DAME is a bitch, not a dame.  Same with the + 1
					objectTypes.push(new ForceField(sides, topVert[verts].x - 8, topVert[verts].y - 8, height + 1, width));
				}
				else if (horizs < leftHoriz.length)
				{
					// We have a single horizontal forcefield. We're going to pretend it is on the top side
					objectStarts.push(null);					
					sides[0] = true;
					height = 1;
					width = rightHoriz[horizs].x - leftHoriz[horizs].x;
					width = width / 16;
					objectTypes.push(new ForceField(sides, leftHoriz[horizs].x, leftHoriz[horizs].y, height, width + 1));
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
						objectStarts.push(null);					
						var h1: int = bottomVert[k].y - topVert[k].y;
						h1 = h1 / 16;
						var w1: int = 1;
						
						// The -8 is because DAME is a bitch, not a dame.
						objectTypes.push(new ForceField(s1, topVert[k].x - 8, topVert[k].y - 8, h1 + 1, w1));
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
					for (var l: int = 0; l < leftHoriz.length; l++)
					{
						objectStarts.push(null);					
						var h2: int = 1;
						var w2: int = rightHoriz[l].x - leftHoriz[l].x;
						w2 = w2 / 16;
						// The -8 is because DAME is a bitch, not a dame.
						objectTypes.push(new ForceField(s2, leftHoriz[l].x - 8, leftHoriz[l].y - 8, h2 + 1, w2 + 1));
					}
				}
			}
			
			// Gets the blastdoor source for entry doors
			var entryLocs : Array = objectsTilemap.getTileCoords(453);
			
			if (entryLocs != null)
			{
				// there should always be two, on the same x coordinate
				entryLocs = entryLocs.sortOn("y", Array.NUMERIC);
				var top : FlxPoint = entryLocs[0];
				var bottom : FlxPoint = entryLocs[1];
				var doorheight : Number = bottom.y - top.y;
				objectStarts.push(null);
				objectTypes.push(new BlastDoor(top.x - 8, top.y - 8, doorheight + 16));
			}
			
			// Gets the top blastdoor source for entry doors
			var exitLocs : Array = objectsTilemap.getTileCoords(485);
			
			if (exitLocs != null)
			{
				// there should always be two, on the same x coordinate
				exitLocs = exitLocs.sortOn("y", Array.NUMERIC);
				top = exitLocs[0];
				bottom = exitLocs[1];
				doorheight = bottom.y - top.y;
				objectStarts.push(null);
				objectTypes.push(new BlastDoor(top.x - 8, top.y - 8, doorheight + 16, true));
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
		
		/**
		 * Check to see if an informant speech should be triggered.
		 */
		public function checkInformant() : void { }
		
		public function get informant() : TheInformant
		{
			return (Manager.getManager(TheInformant) as TheInformant);
		}
	}
}