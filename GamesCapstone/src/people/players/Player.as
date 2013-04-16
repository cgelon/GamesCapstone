package people.players
{
	import managers.AttackManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import people.Actor;
	import people.ActorState;
	
	/** 
	 * Contains all of the information for a player.
	 */
	public class Player extends Actor
	{
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
		
		private var _rollTimer : FlxDelay;
		
		/**
		 * True if the player has released the jump button 
		 * from the last time they jumped, false otherwise.
		 */
		private var _jumpReleased : Boolean;
		
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
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
			addAnimation("jump", [1], 0, false);
			
			// Set physic constants.
			maxVelocity = new FlxPoint(200, 1000);
			acceleration.y = 1000;
			facing = FlxObject.RIGHT;
			drag.x = maxVelocity.x * 4;
			state = ActorState.IDLE;
			_jumpReleased = true;
			
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
			
			_rollTimer = new FlxDelay(1000);
			_rollTimer.callback = function() : void 
			{
				velocity.x = 0;
				state = ActorState.IDLE;
			};
			
			FlxG.watch(this, "_attackCombo");
		}
		
		override public function update():void 
		{
			super.update();
			
			calculateMovement();
			if (state != ActorState.HURT) 
			{
				attack();
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
				
				if (_directionPressed[3] && isTouching(FlxObject.FLOOR) && _jumpReleased)
				{
					velocity.y = -maxVelocity.y / 2.5;
					_jumpReleased = false;
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
				if (touching == FlxObject.FLOOR)
				{
					if (velocity.x != 0)
					{
						state = ActorState.MOVING;
					}
					else
					{
						if (FlxG.keys.pressed("P"))
						{
							state = ActorState.ROLLING;
						}
						else
						{
							state = ActorState.IDLE;
						}
					}
				}
				else if (velocity.y < 0)
				{
					state = ActorState.JUMPING;
				}
				
			}
			else if (state == ActorState.HURT)
			{
				if (touching == FlxObject.FLOOR && !_hurtTimer.isRunning)
				{
					_hurtTimer.start();
				}
			}
			else if (state == ActorState.ROLLING)
			{
				if (!_rollTimer.isRunning)
					_rollTimer.start();
					
				velocity.x = maxVelocity.x / 3;
			}
			drag.x = (touching == FlxObject.FLOOR || state != ActorState.HURT) ? maxVelocity.x * 4 : maxVelocity.x;
		}
		
		private function attack() : void
		{
			if (FlxG.keys.justPressed("J"))
			{
				if (attackReady)
				{
					switch(_attackCombo)
					{
						case 0:
							attackManager.attack((facing == FlxObject.LEFT) ? x - 20 : x + width, y);
							velocity.x = (facing == FlxObject.LEFT) ? -maxVelocity.x : maxVelocity.x;
							break;
						case 1:
							attackManager.attack((facing == FlxObject.LEFT) ? x - 20 : x + width, y);
							velocity.x = (facing == FlxObject.LEFT) ? -maxVelocity.x : maxVelocity.x;
							break;
						case 2:
							attackManager.superAttack((facing == FlxObject.LEFT) ? x - 40 : x + width, y);
							velocity.x = (facing == FlxObject.LEFT) ? -maxVelocity.x : maxVelocity.x;
							_attackCombo = -1;
							break;
						default:
							break;
					}
					acceleration.x = 0;
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
			}
		}
		
		/**
		 * True if the player is able to attack, false otherwise.
		 */
		public function get attackReady() : Boolean
		{
			return !_attackTimer.isRunning && _attackReleased;
		}
		
		public function get attackManager() : AttackManager
		{
			return getManager(AttackManager) as AttackManager;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
			
			_directionPressed.length = 0;
			_directionPressed = null;
			_attackDelay = 0;
			_attackTimer.abort();
			_attackTimer.callback = null;
			_attackTimer = null;
			_attackReleased = false;
			_jumpReleased = false;
			_attackCombo = 0;
			_attackComboDelay = 0;
			_attackComboTimer.abort();
			_attackComboTimer.callback = null;
			_attackComboTimer = null;
			_hurtTimer.abort();
			_hurtTimer.callback = null;
			_hurtTimer = null;
		}
	}
}