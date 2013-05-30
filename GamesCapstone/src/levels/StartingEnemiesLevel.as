package levels
{
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import people.players.Player;
	import people.states.ActorAction;
	import people.states.ActorState;
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
		
		/** The learning blocks needed to learn how to attack and roll. */
		private var _blocks : FlxGroup;
		
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
			_blocks = new FlxGroup();
			var blockJ : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 - 23, -24), LearningBlock.J);
			var blockK : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 - 8, -24), LearningBlock.K);
			var blockL : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 + 7, -24), LearningBlock.L);
			_blocks.add(blockJ);
			_blocks.add(blockK);
			_blocks.add(blockL);
			add(_blocks);
		}
		
		override public function update():void 
		{
			super.update();
			if (_blocks == null)
			{
				initializeBlocks();
			}
			if (_blocks.exists == true)
			{
				if (player.lastAction == ActorAction.ATTACK && player.lastActionIndex == 0)
				{
					(_blocks.members[0] as LearningBlock).complete();
				}
				if (player.lastAction == ActorAction.ATTACK && player.lastActionIndex == 3)
				{
					(_blocks.members[1] as LearningBlock).complete();
				}
				if (player.state == ActorState.ROLLING)
				{
					(_blocks.members[2] as LearningBlock).complete();
				}
				if ((_blocks.members[0] as LearningBlock).completed &&
						(_blocks.members[1] as LearningBlock).completed &&
						(_blocks.members[2] as LearningBlock).completed)
				{
					_blocks.exists = false;
				}
			}
		}
		
		private function get player() : Player
		{
			return (Manager.getManager(PlayerManager) as PlayerManager).player;
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