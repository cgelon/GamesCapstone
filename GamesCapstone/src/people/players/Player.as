package people.players
{
	import items.Item;
	import items.Weapons.Fists;
	import items.Weapons.HammerArm;
	import items.Weapons.WeaponUpgrade;
	import managers.PlayerAttackManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import people.Actor;
	import people.ActorState;
	import states.GameState;
	import util.Color;
	
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
		
		/** All of the weapons/items that the player has collected. **/
		private var _weapons : Array = new Array(10);
		
		private var _weaponText : FlxText;
		
		/** Index of the weapon that is currently being used **/
		private var _currentWeapon : int;
		public function get currentWeapon() : int { return _currentWeapon; }
		
		/** The amount of frames inbetween player attacks. */
		private var _attackDelay : Number = 250;
		/** The timer that tracks when the player can attack again. */
		private var _attackTimer : FlxDelay;
		/** 
		 * True if the player has released the attack button 
		 * from the last time they attacked, false otherwise. 
		 */
		private var _attackReleased : Boolean;
		private var _attackComboDelay : Number = 1000;
		private var _attackComboTimer : FlxDelay;
		
		/** Keeps track of how far into the combo the player is. 1 = first hit, 0 = second, etc. */
		private var _attackCombo : int;			
		public function get attackCombo() : int { return _attackCombo; }
		
		private var _hurtTimer : FlxDelay;
		private var _playedHurtAnimation : Boolean;
		
		private var _rollTimer : FlxDelay;
		
		/**
		 * True if the player has released the jump button 
		 * from the last time they jumped, false otherwise.
		 */
		private var _jumpReleased : Boolean; 		
		public function get jumpReleased() : Boolean { return _jumpReleased; }
		
		/**
		 * Number of jumps the player has done in their current state.
		 * 0 on the ground, 1 during jump, and 2 during double jump.
		 */
		private var _jumpCount : uint;
		
		/** The number of frames that have passed in the current state. */
		private var _currentStateFrame : uint;
		
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
			addAnimation("jump_rising", [19, 20], 10, false);
			addAnimation("jump_falling", [21], 0, false);
			addAnimation("basic_attack", [1, 2, 3], 20, false);
			addAnimation("super_attack", [1, 2, 3, 4], 20, false);
			addAnimation("roll", [27, 28, 29, 30, 31, 32], 12, true);
			addAnimation("hurt_flying", [9], 0, false); 
			addAnimation("hurt_kneeling", [10, 11, 12], 40, false);
			addAnimation("hurt_flashing", [12, 53], 8, true);
			addAnimation("die_falling", [18, 22, 23], 2, false);
			addAnimation("die_flashing", [23, 53], 8, true);
			
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
			
			FlxG.watch(this, "currentWeapon", "CurrentWeapon");
			FlxG.watch(_weapons, "length", "Color");
		}
		

		override public function initialize(x : Number, y : Number, health : Number = 5) : void
		{
			super.initialize(x, y, health);
			
			_currentStateFrame = 0;
			facing = FlxObject.RIGHT;
			_jumpReleased = true;
			state = ActorState.IDLE;
			_jumpCount = 0;
			
			acquireWeapon(new Fists());
			acquireWeapon(new HammerArm());
			_currentWeapon = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (state != ActorState.DEAD)
			{
				calculateMovement();
				switchWeapons();
				if (!(state == ActorState.HURT || state == ActorState.ROLLING)) 
				{
					attack();
				}
			}
			
			
			var colors : Array = [0x00FFFFFF, Color.RED, Color.GREEN, Color.ORANGE, Color.BLUE];
			color = colors[_currentWeapon % colors.length];
			
			alpha = 1 - (_currentWeapon / _weapons.length);
			
			animate();
		}
		
		/** 
		 * Calculates the movement for the player.
		 */
		private function calculateMovement() : void 
		{
			// Keep track of whether or not the jump button has been released.
			if (FlxG.keys.justReleased("W"))
			{
				_jumpReleased = true;
			}
			
			if (state == ActorState.IDLE || 
					state == ActorState.MOVING || 
					state == ActorState.JUMPING)
			{
				// Changes the m_directionPressed array to reflect what keys are currently pressed.
				_directionPressed[0] = FlxG.keys.pressed("D");
				_directionPressed[2] = FlxG.keys.pressed("A");
				_directionPressed[1] = FlxG.keys.pressed("S");
				_directionPressed[3] = FlxG.keys.justPressed("W");
				
				// Falling off a platform counts as a jump.
				if (velocity.y > 0 && _jumpCount == 0)
					_jumpCount++;
				
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
				
				// If the player is pressing the jump button and still has jumps left, jump.
				if (_directionPressed[3] && _jumpReleased && _jumpCount < 2)
				{
					velocity.y = -maxVelocity.y / 2.5;
					_jumpReleased = false;
					_jumpCount++;
					state = ActorState.JUMPING;
				}
				
				// Allow the player to end their jump early
				if (FlxG.keys.justReleased("W") && velocity.y < 0)
				{
					velocity.y /= 2;
				}
				
				// Update state based on movement.
				if (isTouching(FlxObject.FLOOR) && velocity.y == 0)
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
				// Start the hurt timeout once the player hits the floor.
				if (isTouching(FlxObject.FLOOR) && !_hurtTimer.isRunning)
				{
					_hurtTimer.start();
				}
			}
			else if (state == ActorState.ROLLING)
			{
				// If the player has pressed the roll button, roll them
				// in their current direction for a set duration.
				if (!_rollTimer.isRunning)
				{
					_rollTimer.start();
				}
				
				if (facing == FlxObject.RIGHT)
					velocity.x = maxVelocity.x;
				else
					velocity.x = -maxVelocity.x;
			}
			//drag.x = (isTouching(FlxObject.FLOOR) || state != ActorState.HURT) ? maxVelocity.x * 4 : maxVelocity.x;
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
			switch(state)
			{
				case ActorState.IDLE:
					PlayOnce("idle");
					break;
				case ActorState.MOVING:
					PlayOnce("walk");
					break;
				case ActorState.JUMPING:
					if (velocity.y < 0)
						PlayOnce("jump_rising");
					else
						PlayOnce("jump_falling");
					break;
				case ActorState.ROLLING:
					PlayOnce("roll");
					break;
				case ActorState.ATTACKING:
					if (_attackCombo == 3)
						PlayOnce("super_attack");
					else if (_attackCombo == 1 || _attackCombo == 2)
						PlayOnce("basic_attack");
					break;
				case ActorState.HURT:
					if (!isTouching(FlxObject.FLOOR))
						PlayOnce("hurt_flying");
					else
						PlaySequence(["hurt_kneeling", "hurt_flashing"]);
					break;
				case ActorState.DEAD:
					PlaySequence(["die_falling", "die_flashing"]);
					break;
			}
		}
		
		/**
		 * Switches weapons based on which of the numeric keyboard keys have been pressed.
		 */
		private function switchWeapons() : void
		{
			if (FlxG.keys.justPressed("ONE") && _weapons[0] != null)
			{
				_currentWeapon = 0;
			}
			else if (FlxG.keys.justPressed("TWO") && _weapons[1] != null)
			{
				_currentWeapon = 1;
			}
			else if (FlxG.keys.justPressed("THREE") && _weapons[2] != null)
			{
				_currentWeapon = 2;
			}
			else if (FlxG.keys.justPressed("FOUR") && _weapons[3] != null)
			{
				_currentWeapon = 3;
			}
			else if (FlxG.keys.justPressed("FIVE") && _weapons[4] != null)
			{
				_currentWeapon = 4;
			}
		}
		
		public function getPlayerBonusDamage() : Number
		{
			return _weapons[_currentWeapon].damageUp;
		}
		
		/**
		 * Gives the player the given weaponUpgrade.
		 * 
		 * @param	weaponUpgrade	The weapon upgrade to give the player.
		 */
		public function acquireWeapon(weaponUpgrade : WeaponUpgrade) : void
		{
			_weapons[weaponUpgrade.weaponSlot] = weaponUpgrade;
		}
		
		public function get stateName () : String
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