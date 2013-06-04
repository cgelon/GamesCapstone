package levels
{
	import managers.ControlBlockManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import people.players.Player;
	import people.states.ActorAction;
	import people.states.ActorState;
	import people.states.ActorStateGroup;
	import util.LearningBlock;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class StartingEnemiesLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function StartingEnemiesLevel ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map

			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV, tilePNG);
			parseObjects(objectsCSV, tilePNG);
			
			add(map);
		}
		
		/**
		 * Initializes the learning blocks for player attacks and rolling.
		 */
		private function initializeBlocks() : void
		{
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 - 23, -24), LearningBlock.J);
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 - 8, -24), LearningBlock.K);
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 + 7, -24), LearningBlock.L);
		}
		
		override public function update():void 
		{
			super.update();
			var jBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.J);
			if (jBlock == null)
			{
				initializeBlocks();
				jBlock = controlBlockManager.getLearningBlock(LearningBlock.J);
			}
			if (jBlock.exists == true)
			{
				var kBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.K);
				var lBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.L);
				if (player.lastAction == ActorAction.WINDUP && (player.lastActionIndex == 0 || player.lastActionIndex == 1 || player.lastActionIndex == 2))
				{
					jBlock.complete();
				}
				if (player.lastAction == ActorAction.WINDUP && player.lastActionIndex == 3)
				{
					kBlock.complete();
				}
				if (player.state == ActorState.ROLLING)
				{
					lBlock.complete();
				}
				if (jBlock.completed && kBlock.completed && lBlock.completed)
				{
					jBlock.exists = false;
					kBlock.exists = false;
					lBlock.exists = false;
				}
			}
		}
		
		private function get player() : Player
		{
			return (Manager.getManager(PlayerManager) as PlayerManager).player;
		}
		
		private function get controlBlockManager() : ControlBlockManager
		{
			return Manager.getManager(ControlBlockManager) as ControlBlockManager;
		}
		
		override public function checkInformant():void 
		{
			if (_informantTalked[0] == null) {
				informant.talk("Robots... such a buzzkill!  Have fun!");
				_informantTalked[0] = true;
			}
		}
	}
}