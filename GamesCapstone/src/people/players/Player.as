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
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxBar;
	import people.Actor;
	import people.PeriodicSound;
	import people.SoundEffect;
	import people.states.ActorAction;
	import people.states.ActorState;
	import people.states.ActorStateGroup;
	import states.GameState;
	import util.Color;
	import util.Sounds;
	
	/** 
	 * Contains all of the information for a player.
	 */
	public class Player extends Actor
	{	
		/** The amount of frames of windup for a strong attack. */
		private static const STRONG_ATTACK_DELAY_FRAMES : Number = 30;
		/** The amount of frames of windup for a weak attack. */
		private static const WEAK_ATTACK_DELAY_FRAMES : Number = 15;
		
		/** Strong windup delay in seconds. */
		private static const STRONG_ATTACK_DELAY : Number = STRONG_ATTACK_DELAY_FRAMES / 60;
		/** Weak windup delay in seconds. */
		private static const WEAK_ATTACK_DELAY : Number = WEAK_ATTACK_DELAY_FRAMES / 60;
		
		/** The maximum amount of stamina the player can have. */
		public static const MAX_STAMINA : Number = 100;
		/** The amount of stamina to regenerate every frame. */
		private static const STAM_REGEN : Number = 0.5;
		/** The stamina cost of a strong attack. */
		private static const STRONG_ATTACK_STAM_COST : Number = 40;
		/** The stamina cost of a weak attack. */
		private static const WEAK_ATTACK_STAM_COST : Number = 10;
		
		/** All of the weapons/items that the player has collected. **/
		private var _weapons : Array = new Array(10);
		
		/** Index of the weapon that is currently being used **/
		private var _currentWeapon : int;
		
		/** 
		 * True if the player has released the attack button 
		 * from the last time they attacked, false otherwise.
		 */
		private var _attackReleased : Boolean;
		
		/** The attack type of the current attack. 0 for weak attack, 1 for strong attack. */
		private var _attackType : int;
		/**
		 * True if the player has released the jump button 
		 * from the last time they jumped, false otherwise.
		 */
		private var _jumpReleased : Boolean;
		
		/**
		 * Number of jumps the player has done in their current state.
		 * 0 on the ground, 1 during jump, and 2 during double jump.
		 */
		private var _jumpCount : uint;
		
		/** Internal tracking for how much stamina the player currently has. */
		private var _stamina : Number;
		
		/** The PNG for the player. */
		[Embed(source = '../../../assets/player.png')] private var playerPNG : Class;
		
		/** 
		 * Creates a new player.
		 */
		function Player() : void 
		{
			super();
			
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
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["idle"], ActorAction.LAND);
			associateAnimation(["walk"], ActorAction.RUN);
			associateAnimation(["jump_rising"], ActorAction.JUMP);
			associateAnimation(["jump_falling"], ActorAction.FALL);
			associateAnimation(["roll"], ActorAction.ROLL);
			associateAnimation(["basic_attack_windup"], ActorAction.WINDUP, 0);
			associateAnimation(["super_attack_windup"], ActorAction.WINDUP, 1);
			associateAnimation(["basic_attack_hit"], ActorAction.ATTACK, 0);
			associateAnimation(["super_attack_hit"], ActorAction.ATTACK, 1);
			associateAnimation(["hurt_kneeling", "hurt_flashing"], ActorAction.HURT, 0);
			associateAnimation(["hurt_flying"], ActorAction.HURT, 1);
			associateAnimation(["die_falling", "die_flashing"], ActorAction.DIE);
			associateAnimation(["blocking"], ActorAction.BLOCK);
			associateAnimation(["crouching"], ActorAction.CROUCH);
			
			// Create sound associations with states.
			associatePeriodicSound(new PeriodicSound(Sounds.PLAYER_WALKING, 0.25, 0.25), ActorState.RUNNING);
			// Create sound associations with actions.
			associateSound(new SoundEffect(Sounds.PLAYER_JUMP, 0.5), ActorAction.JUMP);
			associateSound(new SoundEffect(Sounds.PLAYER_PUNCH, 0.5), ActorAction.ATTACK);
			associateSound(new SoundEffect(Sounds.PLAYER_LAND, 0.5), ActorAction.LAND);
			associateSound(new SoundEffect(Sounds.PLAYER_HURT, 0.5), ActorAction.HURT);
			
			// Set physic constants.
			maxVelocity = new FlxPoint(200, 1000);
			acceleration.y = 1000;
			drag.x = maxVelocity.x * 4;
			
			// Set up the attack variables.
			_attackReleased = true;
			_attackType = 0;
			
			//FlxG.watch(this, "attackType", "AttackType");
			FlxG.watch(this, "stateName", "State");
			FlxG.watch(this, "stamina", "Stamina");
			FlxG.watch(this, "touching", "Touching");
			//FlxG.watch(this, "isCountering", "Countering");
		}

		override public function initialize(x : Number, y : Number, health : Number = 5) : void
		{
			super.initialize(x, y, health);
			
			_stamina = MAX_STAMINA;
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
			switch(state)
			{
				case ActorState.IDLE:
				case ActorState.RUNNING:
				case ActorState.JUMPING:
				case ActorState.FALLING:
					updateMovement();
					updateNextState();
					updateAttacking();
					break;
				case ActorState.ROLLING:
					// If the player has pressed the roll button, roll them
					// in their current direction for a set duration.
					if (!actionTimer.running)
					{
						actionTimer.start(0.5, 1, function(timer : FlxTimer) : void
						{
							velocity.x = 0;
							executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
					
					velocity.x = ((facing == FlxObject.RIGHT) ? 1 : -1) * maxVelocity.x;
					break;
				case ActorState.ATTACKING:
					if (onGround)
					{
						acceleration.x = 0;
					}
					break;
				case ActorState.HURT:
					// Start the hurt timeout once the player hits the floor.
					if (onGround && !actionTimer.running)
					{
						actionTimer.start(1, 1, function(timer : FlxTimer) : void
						{
							if (state == ActorState.HURT)
							{
								executeAction(ActorAction.STOP, ActorState.IDLE);
							}
						});
					}
					break;
				case ActorState.BLOCKING:
					if (FlxG.keys.justReleased("L") || stamina <= 0)
					{
						executeAction(ActorAction.STOP, ActorState.IDLE);
					}
					break;
				case ActorState.CROUCHING:
					if (FlxG.keys.justReleased("S"))
					{
						executeAction(ActorAction.STOP, ActorState.IDLE);
					}
					break;
				case ActorState.DEAD:
					break;
			}
			
			switchWeapons();
			updateStamina();
			buttonReleases();
			drag.x = (onGround || state != ActorState.HURT) ? maxVelocity.x * 4 : maxVelocity.x;
			
			var colors : Array = [0x00FFFFFF, Color.RED, Color.GREEN, Color.ORANGE, Color.BLUE];
			color = colors[_currentWeapon % colors.length];
		}
		
		/**
		 * Keep track whether or not certain buttons are released.
		 */
		private function buttonReleases() : void
		{
			if (!_jumpReleased && !FlxG.keys.pressed("W"))
			{
				_jumpReleased = true;
			}
			if (!_attackReleased && !FlxG.keys.pressed("J") && !FlxG.keys.pressed("K"))
			{
				_attackReleased = true;
			}
		}
		
		/** 
		 * Calculates the movement for the player when he is idle, running, jumping, or falling.
		 */
		private function updateMovement() : void 
		{
			// Falling off a platform counts as a jump.
			if (velocity.y > 0 && _jumpCount == 0)
			{
				_jumpCount++;
			} 
			else if (onGround)
			{
				_jumpCount = 0;
			}
			
			// If certain directions are being pressed, move.
			if (FlxG.keys.pressed("A"))
			{
				acceleration.x = -maxVelocity.x * 6;
				facing = FlxObject.LEFT;
			} 
			else if (FlxG.keys.pressed("D"))
			{
				acceleration.x = maxVelocity.x * 6;
				facing = FlxObject.RIGHT;
			}
			
			// If no directions are being pressed, stop movement.
			if (!FlxG.keys.pressed("D") && !FlxG.keys.pressed("A")) 
			{
				acceleration.x = 0;
			}
			
			// If the player is pressing the jump button and still has jumps left, jump.
			if (FlxG.keys.justPressed("W") && _jumpReleased && _jumpCount < 2)
			{
				velocity.y = -maxVelocity.y / 2.5;
				
				_jumpReleased = false;
				_jumpCount++;
				executeAction(ActorAction.JUMP, ActorState.JUMPING);
			}
			
			// Allow the player to end their jump early
			if (FlxG.keys.justReleased("W") && velocity.y < 0)
			{
				velocity.y /= 2;
			}
		}
		
		/**
		 * Updates if the player can attack or not.
		 */
		private function updateAttacking() : void
		{
			if (FlxG.keys.justPressed("J") && attackReady)
			{
				executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 0);
				actionTimer.start(WEAK_ATTACK_DELAY, 1, weakWindupCallback);
				_attackReleased = false;
				_attackType = 0;
			}
			else if (FlxG.keys.justPressed("K") && attackReady)
			{
				executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 1);
				actionTimer.start(STRONG_ATTACK_DELAY / 2, 1, strongWindupCallback);
				_attackReleased = false;
				_attackType = 1;
			}
		}
		
		/**
		 * If the player is in control, check to see if certain states should be triggered.
		 */
		private function updateNextState() : void
		{
			if (onGround)
			{
				// These states can only be triggered when the player is on the ground.
				if (state == ActorState.FALLING)
				{
					executeAction(ActorAction.LAND, ActorState.IDLE);
				}
				if (FlxG.keys.justPressed("L"))
				{
					executeAction(ActorAction.BLOCK, ActorState.BLOCKING);
					acceleration.x = 0;
				}
				else if (FlxG.keys.pressed("P"))
				{
					executeAction(ActorAction.ROLL, ActorState.ROLLING);
					stamina -= 10;
				}
				else if (FlxG.keys.justPressed("S"))
				{
					executeAction(ActorAction.CROUCH, ActorState.CROUCHING);
					acceleration.x = 0;
				}
				else if (velocity.x != 0 && state == ActorState.IDLE)
				{
					executeAction(ActorAction.RUN, ActorState.RUNNING);
				}
				else if (velocity.x == 0 && state != ActorState.IDLE)
				{
					executeAction(ActorAction.STOP, ActorState.IDLE);
				}
			}
			else
			{
				// These states can only be triggered when the player is in the air.
				if (ActorStateGroup.GROUND.contains(state) || (velocity.y > 0 && state == ActorState.JUMPING))
				{
						executeAction(ActorAction.FALL, ActorState.FALLING);
				}
			}
		}
		
		/**
		 * Callback for when the weak windup finishes.
		 */
		private function weakWindupCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING)
			{
				attackManager.attack((facing == FlxObject.LEFT) ? x - 20 : x + width, y);
				stamina -= WEAK_ATTACK_STAM_COST;
				executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 0);
				actionTimer.start(WEAK_ATTACK_DELAY / 2, 1, attackCallback);
			}
		}
		
		/**
		 * Callback for when the strong windup finishes.
		 */
		private function strongWindupCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING)
			{
				attackManager.strongAttack((facing == FlxObject.LEFT) ? x - 40 : x + width, y);
				stamina -= STRONG_ATTACK_STAM_COST;
				executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 1);
				actionTimer.start(STRONG_ATTACK_DELAY / 2, 1, attackCallback);
			}
		}
		
		/**
		 * Callback for when any attack has fully finished.
		 */
		private function attackCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING) executeAction(ActorAction.STOP, ActorState.IDLE);
		}
		
		/**
		 * Update stamina based on state.
		 */
		private function updateStamina() : void
		{
			if (state == ActorState.BLOCKING)
			{
				stamina -= STAM_REGEN;
			}
			else
			{
				stamina += STAM_REGEN;
			}
		}
		
		/** The amount of stamina the player currently has. */
		public function get stamina():Number 
		{
			return _stamina;
		}
		
		/** The amount of stamina the player currently has. */
		public function set stamina(value:Number):void 
		{
			_stamina = Math.max(Math.min(value, MAX_STAMINA), 0);
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
		
		public function get damageBonus() : Number
		{
			return _weapons[_currentWeapon].damageUp;
		}
		
		public function get isCountering() : Boolean
		{
			return false; // state == ActorState.BLOCKING && currentStateFrame < 5;
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
		
		/**
		 * A string representing the current state the player is in.
		 */
		public function get stateName () : String
		{
			return (state == null) ? "null" : state.name;
		}
		
		/**
		 * True if the player is able to attack, false otherwise.
		 */
		private function get attackReady() : Boolean
		{
			return !actionTimer.running && _attackReleased;
		}
		
		/**
		 * The manager that deals with all player attacks.
		 */
		private function get attackManager() : PlayerAttackManager
		{
			return getManager(PlayerAttackManager) as PlayerAttackManager;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}