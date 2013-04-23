package people.enemies 
{
	import managers.EnemyManager;
	import managers.EnemyAttackManager;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import people.Actor;
	import people.ActorState;
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
		/** The amount of frames inbetween enemy attacks. */
		private var _attackDelay : Number = 60 * 50;
		/** The timer that tracks when the enemy can attack again. */
		private var _attackTimer : FlxDelay;
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
			addAnimation("punch", [4, 4, 4, 3], 10, false);
			addAnimation("hurt", [10], 10, false);
			addAnimation("die", [10, 11, 9, 11, 9], 10, true);
			
			// Set physics constants
			maxVelocity = new FlxPoint(100, 1000);
			acceleration.y = 500;
			facing = FlxObject.LEFT;
			drag.x = maxVelocity.x * 4;
			state = ActorState.IDLE;
			
			// Set up the attack variables.
			_attackTimer = new FlxDelay(_attackDelay);
			_attackTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING)
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
			
			FlxG.watch(this, "_health", "enemyHealth");
			FlxG.watch(this, "State", "enemystate");
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
						play("idle");
						break;
					case ActorState.IDLE:
						play("idle");
						break;
					case ActorState.ATTACKING:
						play("punch");
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
			state = ActorState.ATTACKING;
			_prevState = ActorState.IDLE;
			attackManager.attack((facing == FlxObject.LEFT) ? x - 30 : x + width, y);
			_attackTimer.start();
		}
		
		override public function update():void 
		{
			super.update();
			switch(state)
			{
				case ActorState.IDLE:
					if (distanceToPlayer() <= 30 && !_attackTimer.isRunning)
						attack();
					break;
				case ActorState.HURT:
					if (!_hurtTimer.isRunning)
						_hurtTimer.start();
					break;
				case ActorState.MOVING:
					if (distanceToPlayer() <= 30 && !_attackTimer.isRunning)
						attack();
					break;
			}
			moveToPlayer();
			animate();
		}
		
		private function moveToPlayer() : void
		{
			if (distanceToPlayer() > 30) {
				var playerX : Number = getPlayerXCoord();
				if (x - playerX > 0)
				{
					acceleration.x = -maxVelocity.x * 6;
					facing = FlxObject.LEFT;
				}
				else
				{
					acceleration.x = maxVelocity.x * 6;
					facing = FlxObject.RIGHT;
				}
			} else {
				acceleration.x = 0;
			}
		}
		
		public function get attackManager() : EnemyAttackManager
		{
			return getManager(EnemyAttackManager) as EnemyAttackManager;
		}
		
		public function get State () : String
		{
			return state.name;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
			
			_prevState = null;
			_attackDelay = 0;
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
