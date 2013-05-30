package items.Environmental.Background
{
	import items.Environmental.Background.Circuit.Trigger;
	import managers.ControlBlockManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import people.Actor;
	import people.players.Player;
	import states.GameState;
	import util.Sounds;
	import util.SpaceBlock;

	/**
	 * @author Lydia Duncan
	 */
	public class Lever extends Trigger implements BackgroundInterface
	{
		[Embed(source = '../../../../assets/switch.png')] private var lever: Class;
		
		/** The space displayed above the lever if the player is above it. */
		private var _space : SpaceBlock;
		
		function Lever(X:Number = 0, Y:Number = 0) : void 
		{
			super("lever");
			initialize(X, Y);
			loadGraphic(lever, false, false, 32, 32, true);
			
			addAnimation("down", [4, 3, 2, 1, 0], 20, false);
			addAnimation("up", [0, 1, 2, 3, 4], 20, false);
			
			immovable = true;
		}
		
		/**
		 * When the "E" key is pressed while the player is overlapping with a lever,
		 * the lever changes positions from up to down, or from down to up
		 */
		override public function collideWith(actor:Actor, state:GameState) : void 
		{
			if (FlxG.keys.justPressed("SPACE"))
			{
				if (_curIndex == 4)
				{
					disable();
				}
				else
				{
					enable();
				}
				FlxG.play(Sounds.SWITCH, 0.25);
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (_space == null)
			{
				_space = controlBlockManager.addSpaceBlock(this, new FlxPoint(-5, -20));
				_space.exists = false;
			}
			_space.exists = overlaps(player);
		}
		
		private function get player() : Player
		{
			return (Manager.getManager(PlayerManager) as PlayerManager).player;
		}
		
		private function get controlBlockManager() : ControlBlockManager
		{
			return Manager.getManager(ControlBlockManager) as ControlBlockManager;
		}
		
		public function playStart() : void 
		{
			
		}
		
		override public function enable() : void {
			play("up");
			super.enable();
		}
		
		override public function disable() : void {
			play("down");
			super.disable();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_space = null;
		}
	}	
}