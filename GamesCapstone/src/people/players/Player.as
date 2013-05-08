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
	import org.flixel.plugin.photonstorm.FlxBar;
	import people.Actor;
	import people.ActorState;
	import people.PeriodicSound;
	import people.SoundEffect;
	import states.GameState;
	import util.Color;
	import util.Sounds;
	
	/** 
	 * Contains all of the information for a player.
	 */
	public class Player extends Actor
	{	
		/* How long the windup for strong and weak attacks are (respectively), in frames */
		private const STRONG_ATTACK_DELAY_FRAMES : Number = 30;
		private const WEAK_ATTACK_DELAY_FRAMES : Number = 10;
		private const STRONG_ATTACK_DELAY : Number = STRONG_ATTACK_DELAY_FRAMES * 1000 / FlxG.framerate; /* Get the windup delay in ms */
		private const WEAK_ATTACK_DELAY : Number = WEAK_ATTACK_DELAY_FRAMES * 1000 / FlxG.framerate;	 /* Get the windup delay in ms */
		
		private const MAX_STAMINA : Number = 100;
		private const ROLL_STAM_COST : Number = 50;
		private const STRONG_ATTACK_STAM_COST : Number = 40;
		private const WEAK_ATTACK_STAM_COST : Number = 10;
		private const STAM_REGEN : Number = 0.5;
		
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
		
		/** The timers that track when the player can attack again. */
		private var _weakAttackTimer : FlxDelay;
		private var _strongAttackTimer : FlxDelay;
		/** 
		 * True if the player has released the attack button 
		 * from the last time they attacked, false otherwise. 
		 */
		private var _attackReleased : Boolean;
		
		/** The attack type of the current attack. 0 for weak attack, 1 for strong attack. */
		private var _attackType : int;			
		public function get attackType() : int { return _attackType; }
		
		private var _hurtTimer : FlxDelay;
		private var _playedHurtAnimation : Boolean;
		
		private var _rollTimer : FlxDelay;
		
		private var _weakWindupTimer : FlxDelay;
		private var _strongWindupTimer : FlxDelay;
		
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
		
		
		private var _stamina : Number;
		public function get stamina() : Number { return _stamina; }
		public function get maxStamina() : Number { return MAX_STAMINA; }
		
		
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
			width = 24;
			height = 40;
			
			// Offset the sprite image's bounding box.
			offset.x = 20;
			offset.y = 13;
			
			// Create the animations we need.
			addAnimation("idle", [0], 0, false);
			addAnimation("walk", [36, 37, 38, 39, 40, 45, 46, 47, 48, 49], 20, true);
			addAnimation("jump_rising", [19, 20], 10, false);
			addAnimation("jump_falling", [21], 0, false);
			addAnimation("basic_attack_windup", [1, 2, 2], (1000 / WEAK_ATTACK_DELAY) * 3, false);
			addAnimation("basic_attack_hit", [3], 20, false);
			addAnimation("super_attack_windup", [1, 2, 2], (1000 / STRONG_ATTACK_DELAY) * 3, false);
			addAnimation("super_attack_hit", [3, 4, 5, 6], 20, false);
			addAnimation("roll", [27, 28, 29, 30, 31, 32], 12, true);
			addAnimation("hurt_flying", [9], 0, false); 
			addAnimation("hurt_kneeling", [10, 11, 12], 40, false);
			addAnimation("hurt_flashing", [12, 53], 8, true);
			addAnimation("die_falling", [18, 22, 23], 2, false);
			addAnimation("die_flashing", [23, 53], 8, true);
			addAnimation("blocking", [7], 0, false);
			addAnimation("crouching", [13], 0, false);
			
			// Create sound associations with states.
			associatePeriodicSound(new PeriodicSound(Sounds.PLAYER_WALKING, 0.25, 0.5), ActorState.MOVING);
			associateSound(new SoundEffect(Sounds.PLAYER_JUMP), ActorState.JUMPING);
			
			// Set physic constants.
			maxVelocity = new FlxPoint(200, 1000);
			acceleration.y = 1000;
			drag.x = maxVelocity.x * 4;
			
			// Set up the attack variables.
			_weakAttackTimer = new FlxDelay(WEAK_ATTACK_DELAY);
			_weakAttackTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING) state = ActorState.IDLE;
			};
			
			_strongAttackTimer = new FlxDelay(STRONG_ATTACK_DELAY / 2);
			_strongAttackTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING) state = ActorState.IDLE;
			};
			
			
			_attackReleased = true;
			
			_attackType = 0;
			
			_hurtTimer = new FlxDelay(1000);
			_hurtTimer.callback = function() : void
			{
				if (state == ActorState.HURT)
				{
					state = ActorState.IDLE;
				}
			};
			
			_rollTimer = new FlxDelay(500);
			_rollTimer.callback = function() : void 
			{
				velocity.x = 0;
				state = ActorState.IDLE;
			};
			
			_weakWindupTimer = new FlxDelay(WEAK_ATTACK_DELAY);
			_weakWindupTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING)
				{
					attackManager.attack(facing);
					lowerStamina(WEAK_ATTACK_STAM_COST);
					_weakAttackTimer.start();
				}
			};
			
			_strongWindupTimer = new FlxDelay(STRONG_ATTACK_DELAY);
			_strongWindupTimer.callback = function() : void
			{
				if (state == ActorState.ATTACKING)
				{
					attackManager.strongAttack(facing);
					lowerStamina(STRONG_ATTACK_STAM_COST);
					_strongAttackTimer.start();
				}
			};
			
			FlxG.watch(this, "attackType", "AttackType");
			FlxG.watch(this, "stateName", "State");
			FlxG.watch(this, "touching", "Touching");
			FlxG.watch(this.velocity, "y", "yVel");
		}

		override public function initialize(x : Number, y : Number, health : Number = 5) : void
		{
			super.initialize(x, y, health);
			
			_stamina = maxStamina;
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
			
			if (state == ActorState.BLOCKING)
				addStamina(-STAM_REGEN);
			else
				addStamina(STAM_REGEN);
			
			if (state != ActorState.DEAD)
			{
				calculateMovement();
				switchWeapons();
				if (!(state == ActorState.HURT || state == ActorState.ROLLING)) 
				{
					attack();
				}
			}
			
			if (FlxG.keys.justPressed("R"))
			{
				//FlxG.uploadRecording();
				//FlxG.log("Saved replay.");
			}
			
			var colors : Array = [0x00FFFFFF, Color.RED, Color.GREEN, Color.ORANGE, Color.BLUE];
			color = colors[_currentWeapon % colors.length];
			
			//alpha = 1 - (_currentWeapon / _weapons.length);
			
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
					
					//if (velocity.x < 0 && _directionPressed
					
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
					
					if (FlxG.keys.justPressed("L"))
					{
						state = ActorState.BLOCKING;
						acceleration.x = 0;
					}
					else if (FlxG.keys.justPressed("P") && _stamina > ROLL_STAM_COST)
					{
						state = ActorState.ROLLING;
					}
					else if (FlxG.keys.justPressed("S"))
					{
						state = ActorState.CROUCHING;
						acceleration.x = 0;
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
					lowerStamina(ROLL_STAM_COST);
				}
				
				if (facing == FlxObject.RIGHT)
					velocity.x = maxVelocity.x;
				else
					velocity.x = -maxVelocity.x;
			}
			else if (state == ActorState.ATTACKING)
			{
				if (isTouching(FlxObject.FLOOR))
					acceleration.x = 0;
			}
			else if (state == ActorState.BLOCKING)
			{
				if (FlxG.keys.justReleased("L") || stamina <= 0)
				{
					state = ActorState.IDLE;
				}
			}
			else if (state == ActorState.CROUCHING)
			{
				if (FlxG.keys.justReleased("S"))
				{
					state = ActorState.IDLE;
				}
			}
			drag.x = (isTouching(FlxObject.FLOOR) || state != ActorState.HURT) ? maxVelocity.x * 4 : maxVelocity.x;
		}
		
		private function attack() : void
		{
			if (FlxG.keys.justPressed("J"))
			{
				if (attackReady && !_weakWindupTimer.isRunning)
				{
					_weakWindupTimer.start();
					state = ActorState.ATTACKING;
					_attackReleased = false;
					_attackType = 0;
				}
			}
			else if (FlxG.keys.justPressed("K"))
			{
				if (attackReady && !_strongWindupTimer.isRunning)
				{
					_strongWindupTimer.start();
					state = ActorState.ATTACKING;
					_attackReleased = false;
					_attackType = 1;
				}
			}
			
			if (FlxG.keys.justReleased("J") || FlxG.keys.justReleased("K"))
			{
				if (!(FlxG.keys.pressed("J") || FlxG.keys.pressed("K")))
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
					if (_attackType == 1)
						PlaySequence(["super_attack_windup", "super_attack_hit"]);
					else if (_attackType == 0)
						PlaySequence(["basic_attack_windup", "basic_attack_hit"]);
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
				case ActorState.BLOCKING:
					PlayOnce("blocking");
					break;
				case ActorState.CROUCHING:
					PlayOnce("crouching");
					break;
			}
		}
		
		/**
		 * Switches weapons based on which of the numeric keyboard keys have been pressed.
		 */
		private function switchWeapons() : void
		{
			var numbersPressed : Array = new Array(10);
			numbersPressed[0] = FlxG.keys.justPressed("ONE");
			numbersPressed[1] = FlxG.keys.justPressed("TWO");
			numbersPressed[2] = FlxG.keys.justPressed("THREE");
			numbersPressed[3] = FlxG.keys.justPressed("FOUR");
			numbersPressed[4] = FlxG.keys.justPressed("FIVE");
			numbersPressed[5] = FlxG.keys.justPressed("SIX");
			numbersPressed[6] = FlxG.keys.justPressed("SEVEN");
			numbersPressed[7] = FlxG.keys.justPressed("EIGHT");
			numbersPressed[8] = FlxG.keys.justPressed("NINE");
			numbersPressed[9] = FlxG.keys.justPressed("ZERO");
			
			for (var i : uint = 0; i < numbersPressed.length; ++i)
			{
				if (numbersPressed[i] && _weapons[i] != null)
				{
					_currentWeapon = i;
					break;
				}
			}
		}
		
		public function getPlayerBonusDamage() : Number
		{
			return _weapons[_currentWeapon].damageUp;
		}
		
		public function addStamina(stamUp : Number) : void
		{
			_stamina = Math.min(_stamina + stamUp, maxStamina);
		}
		
		public function lowerStamina(stamDown : Number) : void
		{
			_stamina = Math.max(_stamina - stamDown, 0);
		}
		
		public function get isCountering() : Boolean
		{
			return state == ActorState.BLOCKING && currentStateFrame < 5;
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
			return !(_weakWindupTimer.isRunning || _strongWindupTimer.isRunning || _weakAttackTimer.isRunning || _strongAttackTimer.isRunning) && _attackReleased;
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
			_weakAttackTimer.abort();
			_weakAttackTimer.callback = null;
			_weakAttackTimer = null;
			_strongAttackTimer.abort();
			_strongAttackTimer.callback = null;
			_strongAttackTimer = null;
			_attackReleased = false;
			_attackType = 0;
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