package levels
{
	import managers.Manager;
	import managers.ObjectManager;
	import managers.PlayerManager;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldClimb extends Level
	{
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Objects.csv", mimeType = "application/octet-stream")] public var ObjectsCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Enemies.csv", mimeType = "application/octet-stream")] public var EnemiesCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function ForceFieldClimb ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			parsePlayer(playerCSV, tilePNG);
			// Stores the player start points
			parseEnemies(EnemiesCSV, tilePNG);
			parseObjects(ObjectsCSV, tilePNG);
			// Add the Forcefields and Generators 
			environmentalCircuits.push(true);
			environmentalCircuits.push(true);
			
			add(map);
		}
		
		override public function checkInformant():void 
		{
			if (_informantTalked[0] == null 
					&& (Manager.getManager(PlayerManager) as PlayerManager).player.x >  224
					&& (Manager.getManager(ObjectManager) as ObjectManager).getCircuit(1).enabled)
			{
				informant.talk("That generator is in a tricky spot... do you have any soccer skills? Try attacking when you are low to the ground.");
				_informantTalked[0] = true;
			} 
			else if (_informantTalked[1] == null && 
					 (Manager.getManager(PlayerManager) as PlayerManager).player.x < 512 &&
					 (Manager.getManager(PlayerManager) as PlayerManager).player.y < 256) 
			{
				informant.talk("More generators placed in awkward spots. If you have a fancy air kick, you might be able to get at it.");
				_informantTalked[1] = true;
			}
		}
	}
}