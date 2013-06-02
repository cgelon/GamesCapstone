package people.enemies 
{
	import attacks.EnemyAttack;
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import attacks.HatThrow;
	import managers.EnemyAttackManager;
	import managers.GroundSlamManager;
	import managers.Manager;
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
		/** Duration (in seconds) that boss is idle during his attack cycle before moving/attacking. */
		private const IDLE_DURATION : Number = 1.5;
		/** Duration (in seconds) that boss moves during his attack cycle before attacking. */
		private const MOVE_DURATION : Number = 1.5;
		
		/** Duration that the boss is hurt for when attacked. */
		private const HURT_DURATION : Number = .5;
		/** Windup time (in seconds) before basic attacks and ground slams. */
		private const ATTACK_WINDUP : Number = .5;
		/** Duration (in seconds) of the boss' windup for basic attacks. */
		private const ATTACK_DURATION : Number = .5;
		/** Duration of the laser charge-up, in seconds. */
		private const LASER_WINDUP : Number = .5;
		/** Duration of the hat-throw windup, in seconds. */
		private const HAT_WINDUP : Number = .5;
		/** Duration of the slam attack, in seconds. */
		private const SLAM_HIT_DURATION : Number = .5;
		/** Amount of time (in seconds) that the boss should flash for when it dies. */
		private const FLASH_DURATION : Number = 3;
		
		/** Amount of time (in frames) that the boss must move in a given direction before
		 *  he is willing to turn around. 
		 */
		private const MIN_DIRECTION_FRAMES : Number = Convert.secondsToFrames(.5);
		
		private var _phase : int;
		private var _direction : uint;
		
		/** How many frames the boss has been moving in the current direction. */
		private var _directionCount : int;
		
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
			addAnimation("die", [2, 48, 49], 2, false);
			addAnimation("die_flashing", [49, 50], 10, true);
			
			addAnimation("attack_windup", [8, 9], 2 / ATTACK_WINDUP, false);
			addAnimation("basic_attack", [40, 41, 42], 3 / ATTACK_DURATION, false);
			addAnimation("ground_slam", [10, 11, 12], 3 / SLAM_HIT_DURATION, false);
			
			addAnimation("throw_hat", [16, 17, 18, 19, 20], 5 / HAT_WINDUP, false);
			addAnimation("hat_off", [21], 0, false);
			addAnimation("catch_hat", [20, 19, 18, 17, 16], 5 / HAT_WINDUP, false);
			
			addAnimation("laser_windup", [24, 25, 26, 27, 28, 29, 30, 31], 7 / LASER_WINDUP, false)
			addAnimation("laser_shoot", [30], 0, false);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["hurt_hit", "hurt_flashing"], ActorAction.HURT);
			associateAnimation(["walk"], ActorAction.RUN);
			associateAnimation(["die", "die_flashing"], ActorAction.DIE);
			associateAnimation(["throw_hat", "hat_off"], BossAction.THROW_HAT);
			associateAnimation(["catch_hat"], BossAction.CATCH_HAT);
			associateAnimation(["laser_windup"], BossAction.SHOOT_LASER);
			associateAnimation(["attack_windup", "ground_slam"], BossAction.SLAM_GROUND);
			associateAnimation(["attack_windup", "basic_attack"], ActorAction.ATTACK);
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, 30);
			state = ActorState.IDLE;
			_phase = 1;
			_direction = FlxObject.LEFT;
			_directionCount = 0;
			
			maxVelocity = new FlxPoint(100, 500);
		}
		
		override public function update():void 
		{
			switch (state)
			{
				case ActorState.IDLE:
					velocity.x = 0;
					facing = playerDirection == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
					if (!actionTimer.running)
					{
						actionTimer.start(IDLE_DURATION, 1, function(timer : FlxTimer) : void {
							executeAction(ActorAction.RUN, ActorState.RUNNING);
						});
					}
					break;
				case ActorState.ATTACKING:
					velocity.x = 0;
					
					if (!actionTimer.running)
						facing = playerDirection == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
					
					switch(lastAction)
					{
						/*
						case ActorAction.ATTACK:
							if (!actionTimer.running)
							{
								actionTimer.start(ATTACK_WINDUP, 1, function(timer : FlxTimer) : void {
									var startX : Number = (facing == FlxObject.RIGHT ? x - EnemyAttack.ENEMY_ATTACK_WIDTH: x + width);
									attackManager.attack(startX, y);
									actionTimer.start(ATTACK_DURATION, 1, function(timer : FlxTimer) : void {
										executeAction(ActorAction.STOP, ActorState.IDLE);
									});
								});
							}
							break;
						*/
						case BossAction.THROW_HAT:
							if (!actionTimer.running)
							{
								actionTimer.start(HAT_WINDUP, 1, function(timer : FlxTimer) : void {
									var attackDirection : uint = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
									var startX : Number = (facing == FlxObject.RIGHT ? x - HatThrow.HAT_WIDTH : x + width);
									attackManager.throwHat(startX, y, attackDirection);
									actionTimer.start(3*HatThrow.PHASE_TIME, 1, function(timer : FlxTimer) : void {
										executeAction(BossAction.CATCH_HAT, ActorState.ATTACKING)
									});
								});
							}
							break;
						case BossAction.CATCH_HAT:
							if (finished)
								executeAction(ActorAction.STOP, ActorState.IDLE);
							break;
						case BossAction.SHOOT_LASER:
							if (!actionTimer.running)
							{
								actionTimer.start(LASER_WINDUP, 1, function(timer : FlxTimer) : void {
									var attackDirection : uint = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
									var newX : Number = facing == FlxObject.RIGHT ? x + 2 : x + width - 2;
									attackManager.fireLaser(newX, y + 20, attackDirection);
									actionTimer.start(.25, 1, function(timer : FlxTimer) : void {
										attackManager.fireLaser(newX, y + 20, attackDirection);
										executeAction(ActorAction.STOP, ActorState.IDLE);
									});
								});
							}
							break;
						case BossAction.SLAM_GROUND:
							if (!actionTimer.running)
							{
								actionTimer.start(2 * ATTACK_WINDUP, 1, function(timer : FlxTimer) : void {
									var attackDirection : uint = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
									var attackX : Number = facing == FlxObject.RIGHT ? x : x + width;
									(Manager.getManager(GroundSlamManager) as GroundSlamManager).groundSlam(attackX, y + height, attackDirection);
									actionTimer.start(SLAM_HIT_DURATION, 1, function(timer : FlxTimer) : void {
										executeAction(ActorAction.STOP, ActorState.IDLE)
									});
								});
							}
							break;
					}
					break;
				case ActorState.RUNNING:
					if (isTouching(FlxObject.RIGHT) && isTouching(FlxObject.LEFT))
						velocity.y = -maxVelocity.y / 2;
					else if (isTouching(FlxObject.RIGHT))
					{
						_direction = FlxObject.LEFT;
						if (_directionCount < MIN_DIRECTION_FRAMES)
						{
							if (actionTimer.running)
								actionTimer.stop();
							randomAttack();
							break;
						}
						_directionCount = 0;
					}
					else if (isTouching(FlxObject.LEFT))
					{
						_direction = FlxObject.RIGHT;
						if (_directionCount < MIN_DIRECTION_FRAMES)
						{
							if (actionTimer.running)
								actionTimer.stop();
							randomAttack();
							break;
						}
						_directionCount = 0;
					}
						
					velocity.x = maxVelocity.x * (_direction == FlxObject.LEFT ? -1 : 1);
					
					if (velocity.x < 0)
						facing = FlxObject.RIGHT;
					else
						facing = FlxObject.LEFT;
					
					if (!actionTimer.running)
					{
						actionTimer.start(MOVE_DURATION, 1, function(timer : FlxTimer) : void {
							if (state == ActorState.RUNNING)
								randomAttack();
						});
					}
					
					_directionCount++;
					break;
				case ActorState.HURT:
					if (!actionTimer.running)
					{
						actionTimer.start(HURT_DURATION, 1, function(timer : FlxTimer) : void {
							executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
					break;
				case ActorState.DEAD:
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(FLASH_DURATION, 1, function(timer : FlxTimer) : void {
							kill();
						});
					}
					break;
			}
		}
		
		public function randomAttack() : void
		{
			var randNum : Number = Math.random();
			if (xToPlayer < EnemyAttack.ENEMY_ATTACK_WIDTH)
			{
				if (randNum < 0.5)
					executeAction(BossAction.SLAM_GROUND, ActorState.ATTACKING);
				else
				{
					if (randNum < 0.75)
						executeAction(BossAction.THROW_HAT, ActorState.ATTACKING);
					else
						executeAction(BossAction.SHOOT_LASER, ActorState.ATTACKING);
				}
			}
			else
			{
				if (randNum < 0.33)
					executeAction(BossAction.THROW_HAT, ActorState.ATTACKING);
				else if (randNum < 0.67)
					executeAction(BossAction.SHOOT_LASER, ActorState.ATTACKING);
				else
					executeAction(BossAction.SLAM_GROUND, ActorState.ATTACKING);
			}
		}
		
		public function get xToPlayer() : Number 
		{
			if (player.x < x)
				return x - player.x;
			else
				return player.x - (x + width);
		}
		
		public function get playerDirection() : uint
		{
			return (player.x - x > 0 ? FlxObject.RIGHT : FlxObject.LEFT);
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