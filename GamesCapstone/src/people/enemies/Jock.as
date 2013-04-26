package people.enemies 
{
	import managers.EnemyManager;
	import managers.EnemyAttackManager;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import people.Actor;
	import people.ActorState;
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
	
		/** The previous state of the actor */
		private var _prevState : ActorState;
		
		/** If the enemy can attack or not */
		private var _canAttack : Boolean;
		/** The amount of frames inbetween enemy attacks. */
		private var _attackDelay : Number = 60 * 25;
		/** The timer that tracks when the enemy can attack again. */
		private var _attackTimer : FlxDelay;
		/** The amount of frames the enemy takes to windup. */
		private var _windupDelay : Number = 60 * 10;
		/** The timer that handles attack animation windup */
		private var _windupTimer : FlxDelay;
		
		/** The timer that tracks how long before the enemy can be hurt again */
		private var _hurtTimer : FlxDelay;
		/** The timer that delays death so the animation can play */
		private var _deathTimer : FlxDelay;
		
		
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
			
			// Set physics constants
			maxVelocity = new FlxPoint(100, 1000);
			acceleration.y = 500;
			facing = FlxObject.LEFT;
			drag.x = maxVelocity.x * 4;
			state = ActorState.IDLE;
			_canAttack = true;
			
			// Set up the attack variables.
			_attackTimer = new FlxDelay(_attackDelay);
			_attackTimer.callback = function() : void
			{
				_canAttack = true;
			};
			
			_windupTimer = new FlxDelay(_windupDelay);
			_windupTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING) {
					PlayOnce("punch");
					attackManager.attack((facing == FlxObject.LEFT) ? x - 30 : x + width, y);
				}
				state = ActorState.IDLE;
			};
			
			_hurtTimer = new FlxDelay(200);
			_hurtTimer.callback = function() : void
			{
				if (state == ActorState.HURT)
					state = ActorState.IDLE;
			};
			
			_deathTimer = new FlxDelay(500);
			_deathTimer.callback = function() : void
			{
				if (state == ActorState.DEAD)
					kill();
			};
			
			FlxG.watch(this, "health", "enemyHealth");
			FlxG.watch(this, "enemyState", "enemystate");
			FlxG.watch(this, "playerDist", "dist");
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
		}
		
		/**
		 * Animate the character based on their current state.
		 */
		private function animate() : void
		{
			if (state != _prevState) {
				switch(state)
				{
					case ActorState.MOVING:
						if (finished)
							play("idle");
						break;
					case ActorState.IDLE:
						if (finished)
							play("idle");
						break;
					case ActorState.ATTACKING:
						play("windup");
						break;
					case ActorState.HURT:
						play("hurt");
						break;
					case ActorState.DEAD:
						play("die");
						if (!_deathTimer.isRunning)
							_deathTimer.start();
						break;
				}
			}
			_prevState = state
		}
		
		private function attack() : void
		{
			if (_canAttack) {
				state = ActorState.ATTACKING;
				_prevState = ActorState.IDLE;
				_attackTimer.start();
				_windupTimer.start();
				_canAttack = false;
			}
		}
		
		override public function update():void 
		{
			super.update();
			switch(state)
			{
				case ActorState.IDLE:
					if (distanceToPlayer() <= 50 && !_attackTimer.isRunning) {
						attack();
					} else  if (distanceToPlayer() < 100) {
						state = ActorState.MOVING;
					}
					break;
				case ActorState.HURT:
					if (!_hurtTimer.isRunning)
						_hurtTimer.start();
					break;
				case ActorState.MOVING:
					if (distanceToPlayer() <= 50 && !_attackTimer.isRunning)
						attack();
					move();
					if (distanceToPlayer() > 100) {
						state = ActorState.IDLE;
					}
					break;
				case ActorState.DEAD:
					_windupTimer.abort();
					_attackTimer.abort();
			}
			animate();
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
			if (state != ActorState.ATTACKING) {
				if (distanceToPlayer() >= 50) {
					
					if (x - playerX >= 0) {
						acceleration.x = -maxVelocity.x * 6;
						facing = FlxObject.LEFT;
					} else {
						acceleration.x = maxVelocity.x * 6;
						facing = FlxObject.RIGHT;
					}
				} else {
					acceleration.x = 0;
					if (x - playerX >= 0)
						facing = FlxObject.LEFT;
					else
						facing = FlxObject.RIGHT;
				}
			} else {
				acceleration.x = 0;
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
		
		public function get enemyState() : String
		{
			return state.name;
		}
		
		public function get playerDist() : Number
		{
			return distanceToPlayer();
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
			
			_prevState = null;
			_attackDelay = 0;
			_windupDelay = 0;
			_windupTimer.abort();
			_windupTimer.callback = null;
			_windupTimer = null;
			_attackTimer.abort();
			_attackTimer.callback = null;
			_attackTimer = null;
			_hurtTimer.abort();
			_hurtTimer.callback = null;
			_hurtTimer = null;
			_deathTimer.abort();
			_deathTimer.callback = null;
			_deathTimer = null;
		}
	}
}
