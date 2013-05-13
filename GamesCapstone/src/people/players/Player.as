package people.players
{
	import attacks.AttackType;
	import flash.globalization.StringTools;
	import items.Weapons.Fists;
	import items.Weapons.HammerArm;
	import items.Weapons.WeaponUpgrade;
	import managers.PlayerAttackManager;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	import people.Actor;
	import people.PeriodicSound;
	import people.SoundEffect;
	import people.states.ActorAction;
	import people.states.ActorState;
	import people.states.ActorStateGroup;
	import util.Color;
	import util.Convert;
	import util.Sounds;
	import util.StatManager;
	
	/** 
	 * Contains all of the information for a player.
	 */
	public class Player extends Actor
	{	
		/** Strong windup delay in seconds. */
		private static const STRONG_ATTACK_WINDUP : Number = Convert.framesToSeconds(15);
		/** Post-strong-attack delay in seconds. */
		private static const STRONG_ATTACK_DELAY : Number = Convert.framesToSeconds(15);
		/** Weak windup delay in seconds. */
		private static const WEAK_ATTACK_WINDUP : Number = Convert.framesToSeconds(5);
		/** Post-weak-attack delay in seconds. */
		private static const WEAK_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		/** Weak air attack's windup in seconds. */
		private static const WEAK_AIR_ATTACK_WINDUP : Number = Convert.framesToSeconds(10);
		/** Weak air attack's post-attack delay in seconds. */
		private static const WEAK_AIR_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		/** Weak low attack's windup in seconds. */
		private static const WEAK_LOW_ATTACK_WINDUP : Number = Convert.framesToSeconds(5);
		/** Weak low attack's post-attack delay in seconds. */
		private static const WEAK_LOW_ATTACK_DELAY : Number = Convert.framesToSeconds(5);
		/** Duration of a roll in seconds. */
		private static const ROLL_DURATION : Number = .5;
		/** How long the player is knocked down when they get hurt, in seconds. */
		private static const HURT_DURATION : Number = 1;
		/** How long (in seconds) after the player had died before the level resets. */
		private static const RESET_TIME : Number = 5;
		
		/** The amount of stamina to regenerate every frame. */
		private static const STAM_REGEN : Number = 0.5;
		/** The stamina cost of a strong attack. */
		private static const STRONG_ATTACK_STAM_COST : Number = 40;
		/** The stamina cost of a weak attack. */
		private static const WEAK_ATTACK_STAM_COST : Number = 10;
		/** The stamina cost of a roll */
		private static const ROLL_STAM_COST : Number = 25;
		
		/** Max velocity for the player. */
		private static const MAX_VELOCITY : FlxPoint = new FlxPoint(200, 1000);
		/** Max velocity for the player when they are pushing. */
		private static const MAX_PUSHING_VELOCITY : FlxPoint = new FlxPoint(125, 1000);
		
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
		
		public var statManager : StatManager;
		
		/** Whether or not the player has been dead long enough that the level should reset. */
		public var readyToReset : Boolean;
		
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
			addAnimation("idle", [0, 1], 2, true);
			addAnimation("walk", [36, 37, 38, 39, 40, 45, 46, 47, 48, 49], 20, true);
			addAnimation("jump_rising", [19, 20], 10, false);
			addAnimation("jump_falling", [21], 0, false);
			addAnimation("weak_attack_windup", [1, 2, 2], 3 / WEAK_ATTACK_WINDUP, false);
			addAnimation("weak_attack_hit", [3], 20, false);
			addAnimation("weak_air_attack_windup", [63, 64, 65, 66], 4 / WEAK_AIR_ATTACK_WINDUP, false);
			addAnimation("weak_air_attack_hit", [67, 68, 69, 70, 71], 7 / WEAK_AIR_ATTACK_DELAY, false);
			addAnimation("weak_low_attack_windup", [83], 0, false);
			addAnimation("weak_low_attack_hit", [84], 0, false);
			addAnimation("strong_attack_windup", [1, 2, 2], 3 / STRONG_ATTACK_WINDUP, false);
			addAnimation("strong_attack_hit", [3, 4, 5, 6], 20, false);
			addAnimation("roll", [27, 28, 29, 30, 31, 32], 12, true);
			addAnimation("hurt_flying", [9], 0, false); 
			addAnimation("hurt_kneeling", [10, 11, 12], 40, false);
			addAnimation("hurt_flashing", [12, 53], 8, true);
			addAnimation("die_falling", [18, 22, 23], 2, false);
			addAnimation("die_flashing", [23, 53], 8, true);
			addAnimation("blocking", [89], 0, false);
			addAnimation("crouching", [13], 0, false);
			addAnimation("terminal", [76, 77, 78], 9, true);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["idle"], ActorAction.LAND);
			associateAnimation(["walk"], ActorAction.RUN);
			associateAnimation(["jump_rising"], ActorAction.JUMP);
			associateAnimation(["jump_falling"], ActorAction.FALL);
			associateAnimation(["roll"], ActorAction.ROLL);
			associateAnimation(["weak_attack_windup"], ActorAction.WINDUP, 0);
			associateAnimation(["weak_attack_hit"], ActorAction.ATTACK, 0);
			associateAnimation(["strong_attack_windup"], ActorAction.WINDUP, 1);
			associateAnimation(["strong_attack_hit"], ActorAction.ATTACK, 1);
			associateAnimation(["weak_air_attack_windup"], ActorAction.WINDUP, 2);
			associateAnimation(["weak_air_attack_hit"], ActorAction.ATTACK, 2);
			associateAnimation(["weak_low_attack_windup"], ActorAction.WINDUP, 3);
			associateAnimation(["weak_low_attack_hit"], ActorAction.ATTACK, 3);
			associateAnimation(["hurt_kneeling", "hurt_flashing"], ActorAction.HURT, 0);
			associateAnimation(["hurt_flying"], ActorAction.HURT, 1);
			associateAnimation(["die_falling", "die_flashing"], ActorAction.DIE);
			associateAnimation(["blocking"], ActorAction.BLOCK);
			associateAnimation(["crouching"], ActorAction.CROUCH);
			associateAnimation(["terminal"], ActorAction.COMPUTER);
			
			// Create sound associations with states.
			associatePeriodicSound(new PeriodicSound(Sounds.PLAYER_WALKING, 0.25, 0.25), ActorState.RUNNING);
			// Create sound associations with actions.
			associateSound(new SoundEffect(Sounds.PLAYER_JUMP, 0.5), ActorAction.JUMP);
			associateSound(new SoundEffect(Sounds.PLAYER_PUNCH, 0.5), ActorAction.ATTACK);
			associateSound(new SoundEffect(Sounds.PLAYER_LAND, 0.5), ActorAction.LAND);
			associateSound(new SoundEffect(Sounds.PLAYER_HURT, 0.5), ActorAction.HURT);
			
			// Set physic constants.
			maxVelocity = MAX_VELOCITY;
			acceleration.y = 1000;
			drag.x = maxVelocity.x * 4;
			
			// Set up the attack variables.

			_attackReleased = true;
			_attackType = 0;
			
			statManager = new StatManager();
			
			FlxG.watch(this, "stateName", "State");
			FlxG.watch(this, "stamina", "Stamina");
			FlxG.watch(this, "touching", "Touching");
			FlxG.watch(this.velocity, "y", "yVel");
		}

		override public function initialize(x : Number, y : Number, health : Number = 5) : void
		{
			var stats : PlayerStats = new PlayerStats();
			
			super.initialize(x, y, Registry.playerStats.health);
			
			velocity.x = 0;
			velocity.y = 0;
			
			_stamina = Registry.playerStats.stamina;
			facing = FlxObject.RIGHT;
			_jumpReleased = true;
			state = ActorState.IDLE;
			_jumpCount = 0;
			
			readyToReset = false;
			
			acquireWeapon(new Fists());
			//acquireWeapon(new HammerArm());
			_currentWeapon = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (FlxG.cutscene)
			{
				updateCutsceneStates();
				drag.x = 0;
			}
			else
			{
				switch(state)
				{
					case ActorState.PUSHING:
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
							actionTimer.start(ROLL_DURATION, 1, function(timer : FlxTimer) : void
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
						else
						{
							updateMovement();
						}
						break;
					case ActorState.HURT:
						// Start the hurt timeout once the player hits the floor.
						if (onGround && !actionTimer.running)
						{
							executeAction(ActorAction.HURT, ActorState.HURT, 0);
							actionTimer.start(HURT_DURATION, 1, function(timer : FlxTimer) : void
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
						updateAttacking();
						break;
					case ActorState.DEAD:
						actionTimer.start(RESET_TIME, 1, function(timer : FlxTimer) : void
						{
							readyToReset = true;
						});
						break;
				}
				
				switchWeapons();
				updateStamina();
				buttonReleases();
				
				drag.x = (onGround || state != ActorState.HURT) ? maxVelocity.x * 4 : maxVelocity.x;
				
				var colors : Array = [0x00FFFFFF, Color.RED, Color.GREEN, Color.ORANGE, Color.BLUE];
				color = colors[_currentWeapon % colors.length];
			}
		}
		
		private function updateCutsceneStates() : void
		{
			if (onGround)
			{
				// These states can only be triggered when the player is on the ground.
				if (state == ActorState.FALLING)
				{
					executeAction(ActorAction.LAND, ActorState.IDLE);
				}
				else if (velocity.x != 0 && state == ActorState.IDLE)
				{
					executeAction(ActorAction.RUN, ActorState.RUNNING);
				}
				else if (velocity.x == 0 && state == ActorState.RUNNING)
				{
					executeAction(ActorAction.STOP, ActorState.IDLE);
				}
			}
			else
			{
				// These states can only be triggered when the player is in the air.
				if (velocity.y > 0 && (ActorStateGroup.GROUND.contains(state) || state == ActorState.JUMPING))
				{
					executeAction(ActorAction.FALL, ActorState.FALLING);
				}
			}
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
			if (!FlxG.keys.pressed("SPACE") && state == ActorState.PUSHING)
			{
				if (velocity.x == 0)
					executeAction(ActorAction.STOP, ActorState.IDLE);
				else
					executeAction(ActorAction.RUN, ActorState.RUNNING);
			}
		}
		
		/** 
		 * Calculates the movement for the player when he is idle, running, jumping, or falling.
		 */
		private function updateMovement() : void 
		{
			if (state == ActorState.PUSHING)
				maxVelocity = MAX_PUSHING_VELOCITY;
			else
				maxVelocity = MAX_VELOCITY;
			
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
				if (state != ActorState.ATTACKING)
					facing = FlxObject.LEFT;
			}
			else if (FlxG.keys.pressed("D"))
			{
				acceleration.x = maxVelocity.x * 6;
				if (state != ActorState.ATTACKING)
					facing = FlxObject.RIGHT;
			}
			
			// If no directions are being pressed, stop movement.
			if (!FlxG.keys.pressed("D") && !FlxG.keys.pressed("A")) 
			{
				acceleration.x = 0;
			}
			
			// If the player is pressing the jump button and still has jumps left, jump.
			if (state != ActorState.ATTACKING && FlxG.keys.justPressed("W") && _jumpReleased && _jumpCount < 2)
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
			if (FlxG.keys.justPressed("J") && attackReady && stamina > WEAK_ATTACK_STAM_COST)
			{
				if (state == ActorState.JUMPING || state == ActorState.FALLING)
				{
					executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 2);
					actionTimer.start(WEAK_AIR_ATTACK_WINDUP, 1, weakWindupCallback);
				}
				else if (state == ActorState.CROUCHING)
				{
					executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 3);
					actionTimer.start(WEAK_LOW_ATTACK_WINDUP, 1, weakWindupCallback);
				}
				else
				{
					executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 0);
					actionTimer.start(WEAK_ATTACK_WINDUP, 1, weakWindupCallback);
				}
				
				_attackReleased = false;
				_attackType = 0;
			}
			else if (FlxG.keys.justPressed("K") && attackReady && stamina > STRONG_ATTACK_STAM_COST)
			{
				executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 1);
				actionTimer.start(STRONG_ATTACK_WINDUP, 1, strongWindupCallback);
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
				else if (FlxG.keys.pressed("P") && stamina >= ROLL_STAM_COST)
				{
					executeAction(ActorAction.ROLL, ActorState.ROLLING);
					stamina -= ROLL_STAM_COST;
				}
				else if (FlxG.keys.pressed("SPACE"))
				{
					var action : ActorAction = velocity.x != 0 ? ActorAction.RUN : ActorAction.STOP;
					executeAction(action, ActorState.PUSHING);
				}
				else if (FlxG.keys.pressed("S"))
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
				if (velocity.y > 0 && (ActorStateGroup.GROUND.contains(state) || state == ActorState.JUMPING))
				{
					executeAction(ActorAction.FALL, ActorState.FALLING);
				}
			}
		}
		
		/**
		 * Callback for when the weak attack's windup finishes.
		 */
		private function weakWindupCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING)
			{
				if (prevState == ActorState.CROUCHING)
				{
					attackManager.weakAttack(facing, AttackType.LOW);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 3);
					actionTimer.start(WEAK_LOW_ATTACK_DELAY, 1, attackCallback);
				}
				else if (prevState == ActorState.JUMPING || prevState == ActorState.FALLING)
				{
					attackManager.weakAttack(facing, AttackType.AIR);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 2);
					actionTimer.start(WEAK_AIR_ATTACK_DELAY, 1, attackCallback);
				}
				else
				{
					attackManager.weakAttack(facing, AttackType.NORMAL);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 0);
					actionTimer.start(WEAK_ATTACK_DELAY, 1, attackCallback);
				}
				stamina -= WEAK_ATTACK_STAM_COST;
			}
		}
		
		/**
		 * Callback for when the strong windup finishes.
		 */
		private function strongWindupCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING)
			{
				attackManager.strongAttack(facing);
				stamina -= STRONG_ATTACK_STAM_COST;
				executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 1);
				actionTimer.start(STRONG_ATTACK_DELAY, 1, attackCallback);
			}
		}
		
		/**
		 * Callback for when any attack has fully finished.
		 */
		private function attackCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING)
			{
				//if (prevState ==
				executeAction(ActorAction.STOP, ActorState.IDLE);
			}
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
			_stamina = Math.max(Math.min(value, PlayerStats.MAX_STAMINA), 0);
			Registry.playerStats.stamina = value;
		}
		
		override public function executeAction(action : ActorAction, newState : ActorState = null, index : uint = 0) : void
		{
			super.executeAction(action, newState, index);
			Registry.addAction(action, index, 1);
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
		
		override public function hurt(damage:Number):void 
		{
			health -= damage;
			Registry.playerStats.health = health;
			if (health <= 0)
				executeAction(ActorAction.DIE, ActorState.DEAD);
			else
				executeAction(ActorAction.HURT, ActorState.HURT, (onGround) ? 0 : 1);
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}