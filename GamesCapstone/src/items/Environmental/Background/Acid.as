package items.Environmental.Background
{
	import items.Environmental.Background.BackgroundItem;
	import org.flixel.FlxG;
	import people.Actor;
	import people.players.Player;
	import people.players.PlayerStats;
	import people.states.ActorState;
	import states.GameState;
	
	
	/**
	 * @author Lydia Duncan
	 */
	public class Acid extends BackgroundItem implements BackgroundInterface
	{
		/** Percent of players health that acid should do every second. */
		private const ACID_DAMAGE_PERCENT : Number = 150;
		/** Damage dealt by acid every frame. */
		private const ACID_DAMAGE : Number = (ACID_DAMAGE_PERCENT / 100)  * PlayerStats.MAX_HEALTH / FlxG.framerate;
		
		[Embed(source = '../../../../assets/acid.png')] private var tileset: Class;
		
		private var oldY: Number;
		private var oldX: Number;
		
		function Acid(X:Number=0,Y:Number=0) : void 
		{
			super("acid");
			initialize(X, Y);
			
			oldY = Y;
			oldX = X;
			loadGraphic(tileset, true, false, 16, 16, false);
			
			addAnimation("slosh", [1, 2], 1, true);
			
			addAnimation("clockwise_slosh1", [3], 5, true);
			addAnimation("counter_slosh1", [5], 5, true);
			addAnimation("clockwise_slosh2", [4], 5, true);
			addAnimation("counter_slosh2", [6], 5, true);
			addAnimation("idle", [0], 1, true);
			addAnimation("flow_left", [7], 5, true);
			addAnimation("flow_right", [8], 5, true);
			// Need an animation for sideways falling, figure out how to rotate
			
			immovable = true;
			allowCollisions = ANY;
		}
		
		override public function collideWith(actor:Actor, state:GameState):void 
		{
			if (actor.state != ActorState.DEAD && !actor.touchedAcidThisFrame)
			{
				actor.touchedAcidThisFrame = true;
				actor.dealDamage(ACID_DAMAGE);
				actor.flickerActor(0.5);
			}
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
			else if (_curAnim.name == "counter_slosh1" || _curAnim.name == "counter_slosh2")
			{
				height = 16;
				width = 14;
				offset.x = 0;
				offset.y = 0;
			}
			else if (_curAnim.name == "clockwise_slosh1" || _curAnim.name == "clockwise_slosh2")
			{
				height = 16;
				width = 14;
				offset.x = 2;
				offset.y = 0;
				if (oldX == x)
				{
					x = x + 2;
				}
			}
			else if (_curAnim.name == "flow_left" || _curAnim.name == "flow_right")
			{
				height = 9;
				width = 13;
				if (_curAnim.name == "flow_left")
				{
					offset.x = 2;
					if (oldX == x)
						x = x + 3;
				}
				else
				{
					offset.x = 0;
					if (oldX != x)
						x = oldX;
				}
				offset.y = 7;
				if (oldY == y)
					y = y + 7;
			}
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			super.initialize(x, y);
			oldY = y;
			oldX = x;
		}
		
		override public function playStart():void 
		{
			play("slosh");
		}
	}
}