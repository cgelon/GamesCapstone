package people.enemies 
{
	import managers.EnemyManager;
	import managers.EnemyAttackManager;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import people.Actor;
	import people.states.ActorAction;
	import people.states.ActorState;
	import states.State;
	import levels.Level;
	import util.Color;
	
	/**
	 * A jock enemy.
	 * 
	 * @author Michael Zhou
	 */
	public class Jock extends Enemy 
	{
		/** The PNG for the jock. */
		[Embed(source = '../../../assets/jock.png')] private var jockPNG : Class;
		
		/** The amount of seconds inbetween enemy attacks. */
		private var _attackDelay : Number = 15 / FlxG.framerate;
		/** The amount of seconds the enemy takes to windup. */
		private var _windupDelay : Number = 20 / FlxG.framerate;
		
		private var _attackRange : Number = 40;
		private var _seekRange : Number = 200;
		
		public function Jock() 
		{
			super();
			
			// Load the jock.png into this sprite.
			loadGraphic(jockPNG, true, true, 64, 64, true);

			// Set the bounding box for the sprite.
			width = 20;
			height = 60;
			
			// Offset the sprite image's bounding box.
			offset.x = 22;
			offset.y = 2;
			
			// Create the animations we need.
			addAnimation("idle", [3], 0, false);
			addAnimation("drink", [1], 0, false);
			addAnimation("throw", [7, 6, 5, 4, 4, 4, 4, 3], 10, false);
			addAnimation("windup", [5], 0, false);
			addAnimation("punch", [4, 4, 3], 10, false);
			addAnimation("hurt", [10], 10, false);
			addAnimation("die", [10, 11, 9, 11, 9], 10, true);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["windup"], ActorAction.WINDUP);
			associateAnimation(["punch"], ActorAction.ATTACK);
			associateAnimation(["hurt"], ActorAction.HURT);
			associateAnimation(["die"], ActorAction.DIE);
			
			// Set physics constants
			maxVelocity = new FlxPoint(100, 1000);
			acceleration.y = 500;
			facing = FlxObject.LEFT;
			drag.x = maxVelocity.x * 4;
			state = ActorState.IDLE;
			
			FlxG.watch(this, "stateName", "State");
		}
		
		public function get stateName() : String
		{
			return state.name;
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
		}
		
		private function attack() : void
		{
			executeAction(ActorAction.WINDUP, ActorState.ATTACKING);
			actionTimer.start(_windupDelay, 1, function(timer : FlxTimer) : void
			{
				if (state == ActorState.ATTACKING) {
					attackManager.attack((facing == FlxObject.LEFT) ? x - 20 : x + width, y);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING);
					actionTimer.start(_attackDelay, 1, function(timer : FlxTimer) : void
					{
						if (state == ActorState.ATTACKING) executeAction(ActorAction.STOP, ActorState.IDLE);
					});
				}
			});
		}
		
		override public function update():void 
		{
			super.update();
			switch(state)
			{
				case ActorState.IDLE:
					acceleration.x = 0;
					velocity.x = 0;
					if (distanceToPlayer() <= _attackRange) 
					{
						facePlayer();
						attack();
					} 
					else if (distanceToPlayer() < _seekRange) 
					{
						executeAction(ActorAction.RUN, ActorState.RUNNING);
					}
					break;
				case ActorState.HURT:
					if (!actionTimer.running)
					{
						actionTimer.start(0.2, 1, function() : void
						{
							executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
					break;
				case ActorState.RUNNING:
					if (distanceToPlayer() <= _attackRange)
					{
						attack();
					}
					move();
					if (distanceToPlayer() > _seekRange) 
					{
						executeAction(ActorAction.STOP, ActorState.IDLE);
					}
					break;
				case ActorState.ATTACKING:
					acceleration.x = 0;
					velocity.x = 0;
					break;
				case ActorState.DEAD:
					acceleration.x = 0;
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(0.5, 1, function() : void
						{
							kill();
						});
					}
					break;
			}
		}
		
		private function move() : void 
		{
			if (!aboutToFall() && Math.abs(getPlayerYCoord() - y) < 50) {
				moveToPlayer();
			} else {
				acceleration.x = 0;
				velocity.x = 0;
				facePlayer();
			}
		}
		
		private function facePlayer() : void 
		{
			if (x - getPlayerXCoord() >= 0) {
				facing = FlxObject.LEFT;
			} else {
				facing = FlxObject.RIGHT;
			}
		}
		
		private function moveToPlayer() : void
		{
			var playerX : Number = getPlayerXCoord();
			if (distanceToPlayer() >= _attackRange) {
				
				if (x - playerX >= 0) {
					acceleration.x = -maxVelocity.x * 6;
					facing = FlxObject.LEFT;
				} else {
					acceleration.x = maxVelocity.x * 6;
					facing = FlxObject.RIGHT;
				}
			} else {
				acceleration.x = 0;
				facePlayer();
			}
		}
		
		private function aboutToFall() : Boolean
		{
			var facing_sign : Number = (facing == FlxObject.LEFT) ? -1 : 1;
			return (!overlapsAt(x + facing_sign * width, y + 1, State.level.map))
		}
		
		public function get attackManager() : EnemyAttackManager
		{
			return getManager(EnemyAttackManager) as EnemyAttackManager;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}
