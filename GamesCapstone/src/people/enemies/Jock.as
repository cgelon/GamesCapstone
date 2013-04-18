package people.enemies 
{
	import managers.EnemyManager;
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
			addAnimation("idle", [0], 0, false);
			addAnimation("drink", [1], 0, false);
			addAnimation("throw", [4, 5, 6, 7, 7, 7, 7, 0], 10, false);
			addAnimation("die", [8, 9], 10, false);
			
			// Set physics constants
			maxVelocity = new FlxPoint(200, 500);
			acceleration.y = 500;
			facing = FlxObject.LEFT;
			drag.x = maxVelocity.x * 4;
			state = ActorState.IDLE;
			
			// Set up the attack variables.
			_attackTimer = new FlxDelay(_attackDelay);
			_attackTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING) {
					state = ActorState.IDLE;
					_prevState = ActorState.ATTACKING;
				}
			}
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			super.initialize(x, y);
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
					case ActorState.IDLE:
						play("idle");
						break;
					case ActorState.ATTACKING:
						play("throw");
						break;
					case ActorState.HURT:
						play("die");
						kill();
						break;
				}
			}
			_prevState = state
		}
		
		private function attack() : void
		{
			state = ActorState.ATTACKING;
			_prevState = ActorState.IDLE;
			_attackTimer.start();
		}
		
		override public function update():void 
		{
			super.update();
			if (state == ActorState.IDLE) {
				attack();
			}
			animate();
		}
	}
}
