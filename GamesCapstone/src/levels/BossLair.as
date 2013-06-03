package levels
{
	import cutscenes.BossCutscene1;
	import items.Environmental.Background.AcidPool;
	import items.Environmental.BlastDoor;
	import managers.BackgroundManager;
	import managers.Manager;
	import managers.ObjectManager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import people.players.Player;
	import states.GameState;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class BossLair extends Level
	{
		[Embed(source = "../../assets/mapCSV_BossLair_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_BossLair_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_BossLair_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/mapCSV_BossLair_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/mapCSV_BossLair_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function BossLair ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV, tilePNG);
			parseBackground(backgroundCSV, tilePNG);
			backgroundStarts.push(new FlxPoint(38 * 16, 76 * 16));
			backgroundTypes.push(AcidPool);
			parseObjects(objectsCSV, tilePNG);
			
			add(map);
			
			cutscene = new BossCutscene1();
			add(cutscene);
		}
		
		override public function update(): void
		{
			super.update();
			var player: Player = (getManager(PlayerManager) as PlayerManager).player;
			if (player.x > 16 * 38)
			{
				getBlastDoor(0).close();
			}
			if (player.x > 16 * 38 && player.y < 73 * 16)
			{
				startAcid();
			}
		}
		
		private function startAcid(): void
		{
			var objects: Array = (getManager(BackgroundManager) as BackgroundManager).members;
			for (var i: int = 0; i < objects.length; i++)
			{
				var acidPool: AcidPool = (objects[i] as AcidPool);
				if (acidPool != null)
				{
					acidPool.start();
				}
			}
		}
		
		public function getBlastDoor(index: Number): BlastDoor
		{
			var blastDoors: Array = [];
			var objects: Array = (getManager(ObjectManager) as ObjectManager).members;
			for (var i: int = 0; i < objects.length; i++)
			{
				var blastDoor: BlastDoor = (objects[i] as BlastDoor);
				if (blastDoor != null)
				{
					blastDoors.push(blastDoor);
				}
			}
			return blastDoors.sortOn("X", Array.NUMERIC)[index];
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class): Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
	}
}