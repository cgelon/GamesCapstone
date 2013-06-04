package people.enemies 
{
	import attacks.EnemyAttack;
	import attacks.LaserAttack;
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import attacks.HatThrow;
	import cutscenes.BossCutscene3;
	import cutscenes.engine.Cutscene;
	import levels.BossLair;
	import managers.EnemyAttackManager;
	import managers.GroundSlamManager;
	import managers.LevelManager;
	import managers.Manager;
	import managers.UIObjectManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	import org.flixel.FlxObject;
	import people.Actor;
	import util.Color;
	import people.states.ActorState
	import people.states.ActorAction;
	import people.states.BossAction;
	import states.GameState;
	import attacks.Attack;
	import attacks.GroundSlam;
	import util.Convert;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossEnemyPhase2 extends BossEnemy
	{
		private var _enrageMultiplier : Number;
		private var _enrageSet : Boolean;
		
		public function BossEnemyPhase2()
		{
			super();
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			
			this.health = maxHealth / 2;
			_enrageMultiplier = 1;
			_enrageSet = false;
		}
		
		override public function update() : void
		{
			
			if (FlxG.cutscene)
			{
				updateCutsceneStates();
				drag.x = 0;
			}
			else
			{
				if (!_enrageSet && health <= maxHealth / 4)
				{
					_enrageMultiplier = .5;
					
					//color = 0x3FFF0000;
					replaceColor(0xFFCCAE9D, 0xFFFF0000);
					addAnimation("walk_enraged", [32, 33, 34, 35, 36, 37, 38, 39], (1/_enrageMultiplier) * 14, true);
					
					addAnimation("attack_windup_enraged", [8, 9], (1/_enrageMultiplier) * 2 / ATTACK_WINDUP, false);
					addAnimation("ground_slam_enraged", [10, 11, 12], (1/_enrageMultiplier) * 3 / SLAM_HIT_DURATION, false);
					
					addAnimation("throw_hat_enraged", [16, 17, 18, 19, 20], (1/_enrageMultiplier) * 5 / HAT_WINDUP, false);
					addAnimation("hat_off_enraged", [21], 0, false);
					addAnimation("catch_hat_enraged", [20, 19, 18, 17, 16], (1/_enrageMultiplier) * 5 / HAT_WINDUP, false);
					
					addAnimation("laser_windup_enraged", [24, 25, 26, 27, 28, 29, 30, 31], (1/_enrageMultiplier) * 7 / LASER_WINDUP, false)
					addAnimation("laser_shoot_enraged", [30], 0, false);
					
					// Associate animations with actions.
					associateAnimation(["walk_enraged"], ActorAction.RUN);
					associateAnimation(["throw_hat_enraged", "hat_off_enraged"], BossAction.THROW_HAT);
					associateAnimation(["catch_hat_enraged"], BossAction.CATCH_HAT);
					associateAnimation(["laser_windup_enraged"], BossAction.SHOOT_LASER);
					associateAnimation(["attack_windup_enraged", "ground_slam_enraged"], BossAction.SLAM_GROUND);
					_enrageSet = true;
				}
					
				switch (state)
				{
					case ActorState.IDLE:
						velocity.x = 0;
						facing = playerDirection == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
						if (!actionTimer.running)
						{
							actionTimer.start(_enrageMultiplier * IDLE_DURATION, 1, function(timer : FlxTimer) : void {
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
							case BossAction.THROW_HAT:
								if (!actionTimer.running)
								{
									actionTimer.start(_enrageMultiplier * HAT_WINDUP, 1, function(timer : FlxTimer) : void {
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
									actionTimer.start(_enrageMultiplier * LASER_WINDUP, 1, function(timer : FlxTimer) : void {
										var attackDirection : uint = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
										var newX : Number = facing == FlxObject.RIGHT ? x + 2 : x + width - 2;
										attackManager.fireLaser(newX, y + 20, attackDirection);
										
										if (_enrageMultiplier == 1)
										{
											actionTimer.start(.25, 1, function(timer : FlxTimer) : void {
												attackManager.fireLaser(newX, y + 20, attackDirection);
												executeAction(ActorAction.STOP, ActorState.IDLE);
											});
										}
										else
										{
											attackManager.fireLaser(newX, y + 20 - LaserAttack.LASER_HEIGHT, attackDirection);
											
											actionTimer.start(.25, 1, function(timer : FlxTimer) : void {
												attackManager.fireLaser(newX, y + 20, attackDirection);
												attackManager.fireLaser(newX, y + 20 - LaserAttack.LASER_HEIGHT, attackDirection);
												executeAction(ActorAction.STOP, ActorState.IDLE);
											});
										}
										
									});
								}
								break;
							case BossAction.SLAM_GROUND:
								if (!actionTimer.running)
								{
									actionTimer.start(_enrageMultiplier * 2 * ATTACK_WINDUP, 1, function(timer : FlxTimer) : void {
										var attackDirection : uint = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
										var attackX : Number = facing == FlxObject.RIGHT ? x : x + width;
										(Manager.getManager(GroundSlamManager) as GroundSlamManager).groundSlam(attackX, y + height, attackDirection);
										(Manager.getManager(GroundSlamManager) as GroundSlamManager).groundSlam(attackX, y + height, facing);
										actionTimer.start(SLAM_HIT_DURATION, 1, function(timer : FlxTimer) : void {
											executeAction(ActorAction.STOP, ActorState.IDLE)
										});
									});
								}
								break;
						}
						break;
					case ActorState.RUNNING:
						if (isTouching(FlxObject.RIGHT))
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
							actionTimer.start(_enrageMultiplier * MOVE_DURATION, 1, function(timer : FlxTimer) : void {
								if (state == ActorState.RUNNING)
									randomAttack();
							});
						}
						
						_directionCount++;
						break;
					case ActorState.HURT:
						if (!actionTimer.running)
						{
							actionTimer.start(_enrageMultiplier * HURT_DURATION, 1, function(timer : FlxTimer) : void {
								executeAction(ActorAction.STOP, ActorState.IDLE);
							});
						}
						break;
					case ActorState.DEAD:
						velocity.x = 0;
						(Manager.getManager(UIObjectManager) as UIObjectManager).toggleBossHud();
						var cutscene : Cutscene = new BossCutscene3(function() : void
							{
								kill();
							});
						(Manager.getManager(LevelManager) as LevelManager).level.add(cutscene);
						cutscene.run();
						break;
				}
			}
		}
	}

}