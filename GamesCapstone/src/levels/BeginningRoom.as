package levels 
{
	import cutscenes.BeginningCutscene;
	import managers.ControlBlockManager;
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
			
			cutscene = new BeginningCutscene();
			add(cutscene);
			
			name = "BeginningRoom";
		}
		
		/**
		 * Initializes the learning blocks for player movement.
		 */
		private function initializeBlocks() : void
		{
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 - 8, -39), LearningBlock.W);
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 - 23, -24), LearningBlock.A);
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 - 8, -24), LearningBlock.S);
			controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 + 7, -24), LearningBlock.D);
		}
		
		override public function update():void 
		{
			super.update();

			var wBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.W);
			if (cutscene.finished && wBlock == null)
			{
				initializeBlocks();
				wBlock = controlBlockManager.getLearningBlock(LearningBlock.W);
			}
			if (cutscene.finished && wBlock.exists == true)
			{
				var aBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.A);
				var sBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.S);
				var dBlock : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.D);
				if (player.state == ActorState.JUMPING)
				{
					wBlock.complete();
				}
				if (FlxG.keys.justPressed("A") || FlxG.keys.justPressed("LEFT"))
				{
					aBlock.complete();
				}
				if (player.state == ActorState.CROUCHING)
				{
					sBlock.complete();
				}
				if (FlxG.keys.justPressed("D") || FlxG.keys.justPressed("RIGHT"))
				{
					dBlock.complete();
				}
				if (wBlock.completed && aBlock.completed && sBlock.completed && dBlock.completed)
				{
					wBlock.exists = false;
					aBlock.exists = false;
					sBlock.exists = false;
					dBlock.exists = false;
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
		
		public function get computerCoordinates() : FlxPoint
		{
			// Subtract some to get the position the player should be at.
			// 160 represents the upper left tile of the computer.
			var location : FlxPoint = map.getTileCoords(160)[0];
			location.x -= 5;
			location.y -= 16;
			return location;
		}
	}
}