package people.players
{
	import managers.PlayerAttackManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import people.Actor;
	import people.ActorState;
	import states.GameState;
	
	/** 
	 * Contains all of the information for a player.
	 */
	public class Player extends Actor
	{
		/**
		 * Keep track of our previous state so that we can play animations just once.
		 */
		private var _prevState : ActorState;
		
		/** 
		 * An array that keeps hold of what directions are currently being pressed. 
		 * 0 = right, 1 = down, 2 = left, 3 = up
		 */
		private var _directionPressed : Array;
		
		/** The amount of frames inbetween player attacks. */
		private var _attackDelay : Number = 250;
		/** The timer that tracks when the player can attack again. */
		private var _attackTimer : FlxDelay;
		/** 
		 * True if the player has released the attack button 
		 * from the last time they attacked, false otherwise. 
		 */
		private var _attackReleased : Boolean;
		public var _attackCombo : int;
		private var _attackComboDelay : Number = 1000;
		private var _attackComboTimer : FlxDelay;
		
		private var _hurtTimer : FlxDelay;
		private var _playedHurtAnimation : Boolean;
		
		private var _rollTimer : FlxDelay;
		
		/**
		 * True if the player has released the jump button 
		 * from the last time they jumped, false otherwise.
		 */
		public var _jumpReleased : Boolean;
		
		// Number of jumps the player has done in their current state.
		// 0 on the ground, 1 during jump, and 2 during double jump.
		public var _jumpCount : int;
		
		/** The PNG for the player. */
		[Embed(source = '../../../assets/player.png')] private var playerPNG : Class;
		
		/** 
		 * Creates a new player.
		 */
		function Player() : void 
		{
			super();

			// Initialize the directional press array
			_directionPressed = [false, false, false, false];
			
			// Load the player.png into this sprite.
			loadGraphic(playerPNG, true, true, 64, 64, true);
			
			// Set the bounding box for the sprite.
			width = 28;
			height = 40;
			
			// Offset the sprite image's bounding box.
			offset.x = 18;
			offset.y = 13;
			
			// Create the animations we need.
			addAnimation("idle", [0], 0, false);
			addAnimation("walk", [36, 37, 38, 39, 40, 45, 46, 47, 48, 49], 20, true);
			addAnimation("jump", [21], 0, false);
			addAnimation("basic_attack", [1, 2, 3], 20, false);
			addAnimation("super_attack", [1, 2, 3, 4], 20, false);
			addAnimation("roll", [27, 28, 29, 30, 31, 32], 12, true);
			addAnimation("hurt_flying", [18], 0, false); // Hurt animation as player is flying through air
			addAnimation("hurt_kneeling", [11, 12], 10, false); // Hurt animation once player hits the ground.
			addAnimation("die_fall", [18, 22, 23], 3, false);
			addAnimation("die_flash", [23, 53], 2, true);
			
			// Set physic constants.
			maxVelocity = new FlxPoint(200, 1000);
			acceleration.y = 1000;
			drag.x = maxVelocity.x * 4;
			
			// Set up the attack variables.
			_attackTimer = new FlxDelay(_attackDelay);
			_attackTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING) state = ActorState.IDLE;
			}
			_attackReleased = true;
			
			_attackCombo = 0;
			_attackComboTimer = new FlxDelay(_attackComboDelay);
			_attackComboTimer.callback = function() : void
			{
				_attackCombo = 0;
			};
			_hurtTimer = new FlxDelay(1000);
			_hurtTimer.callback = function() : void
			{
				if (state == ActorState.HURT) state = ActorState.IDLE;
			};
			
			_rollTimer = new FlxDelay(500);
			_rollTimer.callback = function() : void 
			{
				velocity.x = 0;
				state = ActorState.IDLE;
			};
			
			state = ActorState.IDLE;
			
			FlxG.watch(this, "_attackCombo", "combo");
			FlxG.watch(this, "touching", "touching");
			FlxG.watch(this, "State", "state");
			FlxG.watch(this, "_jumpReleased", "jumpReleased");
			FlxG.watch(this, "_health", "health");
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 2) : void
		{
			super.initialize(x, y, health);
			facing = FlxObject.RIGHT;
			state = ActorState.IDLE;
			_jumpReleased = true;
			_jumpCount = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (state != ActorState.DEAD)
			{
				calculateMovement();
				if (!(state == ActorState.HURT || state == ActorState.ROLLING)) 
				{
					attack();
				}
			}
			animate();
		}
		
		/** 
		 * Calculates the movement for the player.
		 */
		private function calculateMovement() : void 
		{
			if (state == ActorState.IDLE || 
					state == ActorState.MOVING || 
					state == ActorState.JUMPING)
			{
				// Changes the m_directionPressed array to reflect what keys are currently pressed.
				_directionPressed[0] = FlxG.keys.pressed("D");
				_directionPressed[2] = FlxG.keys.pressed("A");
				_directionPressed[1] = FlxG.keys.pressed("S");
				_directionPressed[3] = FlxG.keys.pressed("W");
				
				// If certain directions are being pressed, move.
				if (_directionPressed[2])
				{
					acceleration.x = -maxVelocity.x * 6;
					facing = FlxObject.LEFT;
				} 
				else if (_directionPressed[0])
				{
					acceleration.x = maxVelocity.x * 6;
					facing = FlxObject.RIGHT;
				}
				
				// If no directions are being pressed, stop movement.
				if (!_directionPressed[0] && !_directionPressed[2]) 
				{
					acceleration.x = 0;
				}
				
				if (_directionPressed[3] && _jumpReleased && _jumpCount < 2)
				{
					velocity.y = -maxVelocity.y / 2.5;
					_jumpReleased = false;
					_jumpCount++;
					state = ActorState.JUMPING;
				}
				
				if (FlxG.keys.justReleased("W"))
				{
					if (velocity.y < 0)
					{
						velocity.y /= 2;
					}
					_jumpReleased = true;
				}
				
				// Update state based on movement.
				if (isTouching(FlxObject.FLOOR) != 0x0 && velocity.y == 0)
				{
					if (_jumpCount > 0)
						_jumpCount = 0;
					
					if (FlxG.keys.pressed("P"))
					{
						state = ActorState.ROLLING;
					}
					else if (velocity.x != 0)
					{
						state = ActorState.MOVING;
					}
					else
					{	
						state = ActorState.IDLE;	
					}
				}
				
			}
			else if (state == ActorState.HURT)
			{
				if (isTouching(FlxObject.FLOOR) && !_hurtTimer.isRunning)
				{
					_hurtTimer.start();
					_jumpReleased = true;
					play("hurt_kneeling");
				}
			}
			else if (state == ActorState.ROLLING)
			{
				if (!_rollTimer.isRunning)
				{
					_rollTimer.start();
					_jumpReleased = true;
				}
					
				if (facing == FlxObject.RIGHT)
					velocity.x = maxVelocity.x;
				else
					velocity.x = -maxVelocity.x;
			}
			drag.x = (isTouching(FlxObject.FLOOR) || state != ActorState.HURT) ? maxVelocity.x * 4 : maxVelocity.x;
		}
		
		private function attack() : void
		{
			if (FlxG.keys.justPressed("J"))
			{
				if (attackReady)
				{
					// Reset attackCombo if we finished a combo.
					if (_attackCombo == 3)
						_attackCombo = 0;
					
					switch(_attackCombo)
					{
						case 0:
							attackManager.attack((facing == FlxObject.LEFT) ? x - 20 : x + width, y);
							break;
						case 1:
							attackManager.attack((facing == FlxObject.LEFT) ? x - 20 : x + width, y);
							break;
						case 2:
							attackManager.superAttack((facing == FlxObject.LEFT) ? x - 40 : x + width, y);
							break;
						default:
							break;
					}
					
					// If the player is on the ground while attacking, make them move forward slightly
					// with the attack.
					if (isTouching(FlxObject.FLOOR))
					{
						//velocity.x = (facing == FlxObject.LEFT) ? -maxVelocity.x : maxVelocity.x;
						acceleration.x = 0;
					}
					state = ActorState.ATTACKING;
					_attackReleased = false;
					_attackTimer.start();
					_attackCombo++;
					_attackComboTimer.start();
				}
				else
				{
					_attackCombo = 0;
				}
			}
			if (FlxG.keys.justReleased("J"))
			{
				_attackReleased = true;
			}
		}
		
		/**
		 * Animate the character based on their current state.
		 */
		private function animate() : void
		{
			// Only animate the player when they change states. Looping
			// is taken care of by play().
			if (state != _prevState)
			{
				switch(state)
				{
					case ActorState.IDLE:
						play("idle");
						break;
					case ActorState.MOVING:
						play("walk");
						break;
					case ActorState.JUMPING:
						play("jump");
						break;
					case ActorState.ROLLING:
						play("roll");
						break;
					case ActorState.ATTACKING:
						if (_attackCombo == 3)
							play("super_attack");
						else
							play("basic_attack");
						break;
					case ActorState.HURT:
						if (touching != FlxObject.FLOOR)
							play("hurt_flying");
						break;
					case ActorState.DEAD:
						play("die_fall");
						play("die_flash");
						break;
				}
				_prevState = state;
			}
		}
		
		public function get State () : String
		{
			return state.name;
		}
		
		/**
		 * True if the player is able to attack, false otherwise.
		 */
		public function get attackReady() : Boolean
		{
			return !_attackTimer.isRunning && _attackReleased;
		}
		
		public function get attackManager() : PlayerAttackManager
		{
			return getManager(PlayerAttackManager) as PlayerAttackManager;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
			
			_prevState = null;
			_directionPressed.length = 0;
			_directionPressed = null;
			_attackDelay = 0;
			_attackTimer.abort();
			_attackTimer.callback = null;
			_attackTimer = null;
			_attackReleased = false;
			_attackCombo = 0;
			_attackComboDelay = 0;
			_attackComboTimer.abort();
			_attackComboTimer.callback = null;
			_attackComboTimer = null;
			_hurtTimer.abort();
			_hurtTimer.callback = null;
			_hurtTimer = null;
			_playedHurtAnimation = false;
			_rollTimer.abort();
			_rollTimer.callback = null;
			_rollTimer = null;
			_jumpReleased = false;
			_jumpCount = 0;
		}
	}
}