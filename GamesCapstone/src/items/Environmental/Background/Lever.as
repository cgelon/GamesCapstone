package items.Environmental.Background
{
	import items.Environmental.Background.Circuit.Trigger;
	import org.flixel.FlxG;
	import people.Actor;
	import states.GameState;
	import util.Sounds;

	/**
	 * @author Lydia Duncan
	 */
	public class Lever extends Trigger implements BackgroundInterface
	{
		[Embed(source = '../../../../assets/switch.png')] private var lever: Class;
		
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
	}	
}