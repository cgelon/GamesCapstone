package people.enemies 
{
	import managers.EnemyAttackManager;
	import managers.LevelManager;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	import people.PeriodicSound;
	import people.players.Player;
	import people.SoundEffect;
	import people.states.ActorAction;
	import people.states.ActorState;
	import util.Sounds;
	
	/**
	 * A robot enemy.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class Robot extends Enemy 
	{
		/** The PNG for the robot. */
		[Embed(source = '../../../assets/robot sheet.png')] private var robotPNG : Class;
		
		/** The amount of seconds the enemy takes to windup. */
		protected var _windupDelay : Number = 15 / FlxG.framerate;
		/** The amount of seconds inbetween enemy attacks. */
		protected var _attackDelay : Number = 10 / FlxG.framerate;
		
		
		protected var _attackRange : Number = 40;
		protected var _seekRange : Number = 200;
		
		public function Robot() 
		{
			super();
			
			// Load the jock.png into this sprite.
			loadGraphic(robotPNG, true, true, 64, 64, true);

			// Set the bounding box for the sprite.
			width = 20;
			height = 40;
			
			// Offset the sprite image's bounding box.
			offset.x = 22;
			offset.y = 12;
			
			// Create the animations we need.
			addAnimation("idle", [6, 7], 2, true);
			addAnimation("windup", [0], 0, false);
			addAnimation("attack", [1, 2, 3], 15, false);
			addAnimation("hurt", [8], 0, false);
			addAnimation("die", [8, 10, 9, 10, 9], 10, false);
			addAnimation("run", [12, 13, 14, 15], 5, true);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["windup"], ActorAction.WINDUP);
			associateAnimation(["attack"], ActorAction.ATTACK);
			associateAnimation(["run"], ActorAction.RUN);
			associateAnimation(["hurt"], ActorAction.HURT);
			associateAnimation(["die"], ActorAction.DIE);
			
			// Create sound associations with states.
			associatePeriodicSound(new PeriodicSound(Sounds.ROBOT_WALK, 0.25, 0.25), ActorState.RUNNING);
			// Set sounds
			associateSound(new SoundEffect(Sounds.ROBOT_ATTACK, 0.5), ActorAction.ATTACK);
			associateSound(new SoundEffect(Sounds.ROBOT_HURT, 0.5), ActorAction.HURT);
			associateSound(new SoundEffect(Sounds.ROBOT_DEATH, 0.5), ActorAction.DIE);
			
			// Set physics constants
			maxVelocity = new FlxPoint(100, 1000);
			acceleration.y = 500;
			facing = FlxObject.LEFT;
			drag.x = maxVelocity.x * 4;
			state = ActorState.IDLE;
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
		
		protected function attack() : void
		{
			if (!(player.state == ActorState.HURT || player.state == ActorState.DEAD))
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
		}
		
		override public function update():void 
		{
			super.update();
			if (player.state == ActorState.DEAD)
			{
				if (state != ActorState.IDLE)
				{
					executeAction(ActorAction.STOP, ActorState.IDLE);
					acceleration.x = 0;
					velocity.x = 0;
				}
			}
			else
			{
				switch(state)
				{
					case ActorState.IDLE:
						//acceleration.x = 0;
						//velocity.x = 0;
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
						//acceleration.x = 0;
						//velocity.x = 0;
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
		}
		
		protected function move() : void 
		{
			if (!aboutToFall() && Math.abs(player.y - y) < 50) {
				moveToPlayer();
			} else {
				acceleration.x = 0;
				velocity.x = 0;
				facePlayer();
			}
		}
		
		protected function facePlayer() : void 
		{
			if (x - player.x >= 0) {
				facing = FlxObject.LEFT;
			} else {
				facing = FlxObject.RIGHT;
			}
		}
		
		protected function moveToPlayer() : void
		{		
			if (distanceToPlayer() >= _attackRange) {
				
				if (x - player.x >= 0) {
					acceleration.x = -maxVelocity.x * 10;
					facing = FlxObject.LEFT;
				} else {
					acceleration.x = maxVelocity.x * 10;
					facing = FlxObject.RIGHT;
				}
			} else {
				acceleration.x = 0;
				facePlayer();
			}
		}
		
		protected function aboutToFall() : Boolean
		{
			var facing_sign : Number = (facing == FlxObject.LEFT) ? -1 : 1;
			return (!overlapsAt(x + facing_sign * width, y + 1, (getManager(LevelManager) as LevelManager).map))
		}
		
		protected function get attackManager() : EnemyAttackManager
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
