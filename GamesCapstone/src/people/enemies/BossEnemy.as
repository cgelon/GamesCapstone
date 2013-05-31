package people.enemies 
{
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import managers.EnemyAttackManager;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import org.flixel.FlxObject;
	import util.Color;
	import people.states.ActorState
	import people.states.ActorAction;
	import attacks.Attack;
	import attacks.GroundSlam;
	import util.Convert;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossEnemy extends Enemy
	{
		/** Duration that the boss is hurt for when attacked. */
		private const HURT_DURATION : Number = .5;
		
		private var _phase : int;
		
		/** The PNG for the player. */
		[Embed(source = '../../../assets/boss.png')] private var bossPNG : Class;
		
		public function BossEnemy() 
		{
			super();
			
			loadGraphic(bossPNG, true, true, 64, 64, true);
			
			// Set the bounding box for the sprite.
			width = 24;
			height = 46;
			
			// Offset the sprite image's bounding box.
			offset.x = 20;
			offset.y = 16;
			
			// Create the animations we need.
			addAnimation("idle", [0, 1], 2, true);
			addAnimation("hurt_hit", [2], 8, false);
			addAnimation("hurt_flashing", [3, 7], 8, true);
			addAnimation("attack_windup", [8, 9], 20, true);
			addAnimation("basic_attack", [40, 41, 42], 6, false);
			
			addAnimation("throw_hat", [16, 17, 18, 19, 20], 10, false);
			addAnimation("hat_off", [21], 0, false);
			addAnimation("catch_hat", [20, 19, 18, 17, 16], 10, false);
			
			addAnimation("laser_windup", [24, 25, 26, 27, 28, 29, 30], 12, false)
			addAnimation("laser_shoot", [30], 0, false);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["hurt_hit", "hurt_flashing"], ActorAction.HURT);
			associateAnimation(["throw_hat", "hat_off"], ActorAction.BLOCK);
			associateAnimation(["laser_windup"], ActorAction.COMPUTER);
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
			_phase = 1;
		}
		
		override public function update():void 
		{
			velocity.x = -20;
			velocity.y = 0;
			//immovable = true;
			//moves = true;
			var playerDirection : uint = (player.x - x > 0 ? FlxObject.RIGHT : FlxObject.LEFT);
			switch (state)
			{
				case ActorState.IDLE:
					velocity.x = -10;
					if (!actionTimer.running)
					{
						actionTimer.start(3, 1, function(timer : FlxTimer) : void {
							if (state == ActorState.IDLE)
							{
								var randNum : Number = Math.random();
								if (randNum < 0.5)
									executeAction(ActorAction.BLOCK, ActorState.BLOCKING);
								else
									executeAction(ActorAction.COMPUTER, ActorState.COMPUTER);
									//state = ActorState.COMPUTER;
								//else if (randNum < 0.67)
									
								//else
									//state = ActorState.ATTACKING;
							}
						});
					}
					break;
				case ActorState.BLOCKING:
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(.5, 1, function(timer : FlxTimer) : void {
							attackManager.throwHat(x, y, playerDirection);
							actionTimer.start(2, 1, function(timer : FlxTimer) : void {
								executeAction(ActorAction.STOP, ActorState.IDLE)
							});
						});
					}
					
					break;
				case ActorState.COMPUTER:
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(.5, 1, function(timer : FlxTimer) : void {
							attackManager.fireLaser(x, y, playerDirection);
							actionTimer.start(2, 1, function(timer : FlxTimer) : void {
								executeAction(ActorAction.STOP, ActorState.IDLE)
							});
						});
					}
					break;
				case ActorState.ATTACKING:
					velocity.x = 0;
					attackManager.groundSlam(x, y + height - GroundSlam.SLAM_HEIGHT, playerDirection);
					executeAction(ActorAction.STOP, ActorState.IDLE)
					break;
				case ActorState.HURT:
					if (!actionTimer.running)
					{
						actionTimer.start(HURT_DURATION, 1, function(timer : FlxTimer) : void {
							executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
			}
		}
		
		override public function getHit(attack : Attack) : void
		{
			// Bosses don't get knocked back.
			dealDamage(attack.damage);
			
			/*
			if (state != ActorState.DEAD && state != ActorState.HURT)
				hurt(attack.damage);
			*/
		}
		
	}

}