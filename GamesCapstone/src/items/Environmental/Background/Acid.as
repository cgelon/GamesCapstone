package items.Environmental.Background
{
	import items.Environmental.Background.BackgroundItem;
	import managers.ObjectManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import people.Actor;
	import people.states.ActorAction;
	import people.states.ActorState;
	import states.GameState;
	import states.State;

	/**
	 * @author Lydia Duncan
	 */
	public class Acid extends BackgroundItem
	{
		[Embed(source = '../../../../assets/lab tile arrange.png')] private var tileset: Class;
		
		private var oldY: Number;
		
		function Acid(X:Number=0,Y:Number=0) : void 
		{
			super("acid");
			initialize(X, Y);
			
			oldY = Y;
			loadGraphic(tileset, true, false, 16, 16, false);
			
			addAnimation("slosh", [454, 455], 1, true);
			addAnimation("idle", [390], 1, true);
			// Need an animation for sideways falling, figure out how to rotate
			
			immovable = true;
			allowCollisions = ANY;
		}
		
		override public function collideWith(actor:Actor, state:GameState):void 
		{
			actor.die();
		}
		
		override public function update():void 
		{
			super.update();
			if (_curAnim.name == "slosh")
			{
				height = 8;
				width = 16;
				offset.x = 0;
				offset.y = 8;
				if (oldY == y)
				{
					y = y + 8;
				}
			}
			else if (_curAnim.name == "idle")
			{
				height = 16;
				width = 16;
				offset.x = 0;
				offset.y = 0;
				if (oldY != y)
				{
					y = oldY;
				}
			}
		}
		
		override public function playStart():void 
		{
			play("slosh");
		}
	}
}