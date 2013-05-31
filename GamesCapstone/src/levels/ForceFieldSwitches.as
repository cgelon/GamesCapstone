package levels
{
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import managers.ControlBlockManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.players.Player;
	import people.states.ActorAction;
	import util.LearningBlock;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldSwitches extends Level
	{
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Objects.csv", mimeType = "application/octet-stream")] public var objectCSV : Class;		
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function ForceFieldSwitches ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseObjects(objectCSV, tilePNG);	
			environmentalCircuits.push(true);
			environmentalCircuits.push(true);
			
			add(map);
		}
		
		override public function update():void 
		{
			super.update();
			var block : LearningBlock = controlBlockManager.getLearningBlock(LearningBlock.J);
			if (block == null)
			{
				block = controlBlockManager.addLearningBlock(player, new FlxPoint(player.width / 2 - 8, -24), LearningBlock.J);
			}
			if (block.exists == true)
			{
				if (player.lastAction == ActorAction.ATTACK && (player.lastActionIndex == 0 || player.lastActionIndex == 1 || player.lastActionIndex == 2))
				{
					block.complete();
					block.exists = false;
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
				informant.talk("That generator seems to be powering the forcefield, maybe your fists could break it... Actually, that's a ridiculous notion.");
				_informantTalked[0] = true;
			}
		}
	}
}