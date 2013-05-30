package levels 
{
	import cutscenes.BeginningCutscene;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import people.players.Player;
	import people.states.ActorState;
	import util.LearningBlock;
	
	/**
	 * The beginning room in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class BeginningRoom extends Level
	{
		[Embed(source = "../../assets/room_beginning.csv", mimeType = "application/octet-stream")] public var _csv : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var _tilesetPNG : Class;
		
		/** The learning blocks needed to learn how to move. */
		private var _blocks : FlxGroup;
		
		public function BeginningRoom() 
		{
			super();
			
			map.loadMap(new _csv(), _tilesetPNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			
			// Find the map and set the player start position there.
			// 132 represets the upper left tile of the vent.
			playerStart = map.getTileCoords(132)[0];
			playerEnd = new FlxPoint(368, 168);
			
			
			add(map);
			
			cutscene = new BeginningCutscene(initializeBlocks);
			add(cutscene);
		}
		
		/**
		 * Initializes the learning blocks for player movement.
		 */
		private function initializeBlocks() : void
		{
			_blocks = new FlxGroup();
			var blockW : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 - 8, -39), LearningBlock.W);
			var blockA : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 - 23, -24), LearningBlock.A);
			var blockS : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 - 8, -24), LearningBlock.S);
			var blockD : LearningBlock = new LearningBlock(player, new FlxPoint(player.width / 2 + 7, -24), LearningBlock.D);
			_blocks.add(blockW);
			_blocks.add(blockA);
			_blocks.add(blockS);
			_blocks.add(blockD);
			add(_blocks);
		}
		
		override public function update():void 
		{
			super.update();
			if (cutscene.finished && _blocks.exists == true)
			{
				if (player.state == ActorState.JUMPING)
				{
					(_blocks.members[0] as LearningBlock).complete();
				}
				if (FlxG.keys.justPressed("A") || FlxG.keys.justPressed("LEFT"))
				{
					(_blocks.members[1] as LearningBlock).complete();
				}
				if (player.state == ActorState.CROUCHING)
				{
					(_blocks.members[2] as LearningBlock).complete();
				}
				if (FlxG.keys.justPressed("D") || FlxG.keys.justPressed("RIGHT"))
				{
					(_blocks.members[3] as LearningBlock).complete();
				}
				if ((_blocks.members[0] as LearningBlock).completed &&
						(_blocks.members[1] as LearningBlock).completed &&
						(_blocks.members[2] as LearningBlock).completed &&
						(_blocks.members[3] as LearningBlock).completed)
				{
					_blocks.exists = false;
				}
			}
		}
		
		private function get player() : Player
		{
			return (Manager.getManager(PlayerManager) as PlayerManager).player;
		}
		
		public function get computerCoordinates() : FlxPoint
		{
			// Subtract some to get the position the player should be at.
			// 160 represents the upper left tile of the computer.
			var location : FlxPoint = map.getTileCoords(160)[0];
			location.x -= 5;
			location.y -= 16;
			return location;
		}
		
		override public function destroy():void 
		{
			super.destroy();
		
			_blocks = null;
		}
	}
}