package people.enemies 
{
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import managers.EnemyAttackManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	import org.flixel.FlxObject;
	import util.Color;
	import people.states.ActorState
	import people.states.ActorAction;
	import people.states.BossAction;
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
		/** Duration of the laser charge-up, in seconds. */
		private const LASER_WINDUP : Number = .5;
		/** Duration of the hat-throw windup, in seconds. */
		private const HAT_WINDUP : Number = .5;
		/** Duration of the slam attack, in seconds. */
		private const SLAM_HIT_DURATION : Number = .5;
		
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
			addAnimation("walk", [32, 33, 34, 35, 36, 37, 38, 39], 14, true);
			
			addAnimation("attack_windup", [8, 9], 4, false);
			addAnimation("basic_attack", [40, 41, 42], 6, false);
			addAnimation("ground_slam", [10, 11, 12], 3 / SLAM_HIT_DURATION, false);
			
			addAnimation("throw_hat", [16, 17, 18, 19, 20], 5 / HAT_WINDUP, false);
			addAnimation("hat_off", [21], 0, false);
			addAnimation("catch_hat", [20, 19, 18, 17, 16], 5 / HAT_WINDUP, false);
			
			addAnimation("laser_windup", [24, 25, 26, 27, 28, 29, 30], 6 / LASER_WINDUP, false)
			addAnimation("laser_shoot", [30], 0, false);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["hurt_hit", "hurt_flashing"], ActorAction.HURT);
			associateAnimation(["walk"], ActorAction.RUN);
			associateAnimation(["throw_hat", "hat_off"],BossAction.THROW_HAT);
			associateAnimation(["laser_windup"], BossAction.SHOOT_LASER);
			associateAnimation(["attack_windup", "ground_slam"], BossAction.SLAM_GROUND);
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
			_phase = 1;
			
			maxVelocity = new FlxPoint(100, 500);
		}
		
		override public function update():void 
		{
			//immovable = true;
			//moves = true;
			var playerDirection : uint = (player.x - x > 0 ? FlxObject.RIGHT : FlxObject.LEFT);
			switch (state)
			{
				case ActorState.IDLE:
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(3, 1, function(timer : FlxTimer) : void {
							var randNum : Number = Math.random();
							if (randNum < 0.5)
							{
								
								//if (randNum < 0.33)
									//executeAction(BossAction.THROW_HAT, ActorState.ATTACKING);
								//else if (randNum < 0.67)
									//executeAction(BossAction.SHOOT_LASER, ActorState.ATTACKING);
								//else
									executeAction(BossAction.SLAM_GROUND, ActorState.ATTACKING);
									//state = ActorState.COMPUTER;
								//else if (randNum < 0.67)
									
								//else
									//state = ActorState.ATTACKING;
							}
							else
							{
								executeAction(ActorAction.RUN, ActorState.RUNNING);
							}
						});
					}
					break;
				case ActorState.ATTACKING:
					switch(lastAction)
					{
						case BossAction.THROW_HAT:
							if (!actionTimer.running)
							{
								actionTimer.start(HAT_WINDUP, 1, function(timer : FlxTimer) : void {
									attackManager.throwHat(x, y, playerDirection);
									actionTimer.start(2, 1, function(timer : FlxTimer) : void {
										executeAction(ActorAction.STOP, ActorState.IDLE)
									});
								});
							}
							break;
						case BossAction.SHOOT_LASER:
							if (!actionTimer.running)
							{
								actionTimer.start(LASER_WINDUP, 1, function(timer : FlxTimer) : void {
									attackManager.fireLaser(x, y, playerDirection);
									actionTimer.start(2, 1, function(timer : FlxTimer) : void {
										executeAction(ActorAction.STOP, ActorState.IDLE)
									});
								});
							}
							break;
						case BossAction.SLAM_GROUND:
							if (!actionTimer.running)
							{
								actionTimer.start(2 * SLAM_HIT_DURATION, 1, function(timer : FlxTimer) : void {
									attackManager.groundSlam(x, y, playerDirection);
									actionTimer.start(2, 1, function(timer : FlxTimer) : void {
										executeAction(ActorAction.STOP, ActorState.IDLE)
									});
								});
							}
							break;
					}
					//velocity.x = 0;
					//attackManager.groundSlam(x, y + height - GroundSlam.SLAM_HEIGHT, playerDirection);
					//executeAction(ActorAction.STOP, ActorState.IDLE)
					break;
				case ActorState.RUNNING:
					velocity.x = maxVelocity.x * (playerDirection == FlxObject.LEFT ? -1 : 1);
					if (velocity.x < 0)
						facing = FlxObject.RIGHT;
					else
						facing = FlxObject.LEFT;
					
					if (!actionTimer.running)
					{
						actionTimer.start(2 * SLAM_HIT_DURATION, 1, function(timer : FlxTimer) : void {
							executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
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