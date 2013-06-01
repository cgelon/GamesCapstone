package people.players
{
	import attacks.AttackType;
	import flash.globalization.StringTools;
	import items.Weapons.Fists;
	import items.Weapons.HammerArm;
	import items.Weapons.WeaponUpgrade;
	import managers.PlayerAttackManager;
	import managers.UIObjectManager;
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
		/** Weak windup delay in seconds. */
		private static const WEAK_NORMAL_ATTACK_WINDUP : Number = Convert.framesToSeconds(5);
		/** Post-weak-attack delay in seconds. */
		private static const WEAK_NORMAL_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		/** Weak air attack's windup in seconds. */
		private static const WEAK_AIR_ATTACK_WINDUP : Number = Convert.framesToSeconds(10);
		/** Weak air attack's post-attack delay in seconds. */
		private static const WEAK_AIR_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		/** Weak low attack's windup in seconds. */
		private static const WEAK_LOW_ATTACK_WINDUP : Number = Convert.framesToSeconds(5);
		/** Weak low attack's post-attack delay in seconds. */
		private static const WEAK_LOW_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		
		/** Strong windup delay in seconds. */
		private static const STRONG_NORMAL_ATTACK_WINDUP : Number = Convert.framesToSeconds(5);
		/** Post-strong-attack delay in seconds. */
		private static const STRONG_NORMAL_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		/** Strong air attack windup delay in seconds. */
		private static const STRONG_AIR_ATTACK_WINDUP : Number = Convert.framesToSeconds(10);
		/** Strong air attack's post-attack delay in seconds. */
		private static const STRONG_AIR_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		/** Strong low attack windup delay in seconds. */
		private static const STRONG_LOW_ATTACK_WINDUP : Number = Convert.framesToSeconds(5);
		/** Strong low attack's post-attack delay in seconds. */
		private static const STRONG_LOW_ATTACK_DELAY : Number = Convert.framesToSeconds(10);
		
		/** Duration of a roll in seconds. */
		private static const ROLL_DURATION : Number = .5;
		/** How long the player is knocked down when they get hurt, in seconds. */
		private static const HURT_DURATION : Number = 1;
		/** How long (in seconds) after the player had died before the level resets. */
		private static const RESET_TIME : Number = 5;
		
		/** The amount of stamina to regenerate every frame. */
		private static const STAM_REGEN : Number = 0.5;
		/** The stamina cost of a strong attack. */
		public static const STRONG_ATTACK_STAM_COST : Number = 40;
		/** The stamina cost of a weak attack. */
		public static const WEAK_ATTACK_STAM_COST : Number = 10;
		/** The stamina cost of a roll */
		public static const ROLL_STAM_COST : Number = 25;
		
		/** Max velocity for the player. */
		private static const MAX_VELOCITY : FlxPoint = new FlxPoint(200, 1000);
		/** Max velocity for the player when they are pushing. */
		private static const MAX_PUSHING_VELOCITY : FlxPoint = new FlxPoint(125, 1000);
		
		/** The normal hitbox for the player. */
		private static const NORMAL_HITBOX : FlxPoint = new FlxPoint(24, 40);
		/** The hitbox for the player when they are crouching. */
		private static const CROUCHING_HITBOX : FlxPoint = new FlxPoint(24, 20);
		
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
		
		/** Whether or not the player is making the transition from crouching to standing this frame. */
		private var _standingUp : Boolean;
		
		/** Whether the player's current state should be be crouching. */
		private var _crouching : Boolean;
		private var _prevCrouching : Boolean;
		
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
			width = NORMAL_HITBOX.x;
			height = NORMAL_HITBOX.y;
			
			// Offset the sprite image's bounding box.
			offset.x = 20;
			offset.y = 13;
			
			// Create the animations we need.
			addAnimation("idle", [0, 1], 2, true);
			addAnimation("walk", [36, 37, 38, 39, 40, 45, 46, 47, 48, 49], 20, true);
			addAnimation("jump_rising", [19, 20], 10, false);
			addAnimation("jump_falling", [21], 0, false);
			addAnimation("weak_normal_attack_windup", [1, 2, 2], 3 / WEAK_NORMAL_ATTACK_WINDUP, false);
			addAnimation("weak_attack_hit", [3], 20, false);
			addAnimation("weak_air_attack_windup", [63, 64, 65, 66], 4 / WEAK_AIR_ATTACK_WINDUP, false);
			addAnimation("weak_air_attack_hit", [67, 68, 69, 70, 71], 7 / WEAK_AIR_ATTACK_DELAY, false);
			addAnimation("weak_low_attack_windup", [83], 0, false);
			addAnimation("weak_low_attack_hit", [84], 0, false);
			addAnimation("strong_normal_attack_windup", [1, 2, 2], 3 / STRONG_NORMAL_ATTACK_WINDUP, false);
			addAnimation("strong_attack_hit", [3, 4, 5, 6], 20, false);
			addAnimation("roll", [27, 28, 29, 30, 31, 32], 12, true);
			addAnimation("hurt_flying", [9], 0, false); 
			addAnimation("hurt_kneeling", [10, 11, 12], 40, false);
			addAnimation("hurt_flashing", [12, 53], 8, true);
			addAnimation("die_falling", [18, 22, 23], 2, false);
			addAnimation("die_flashing", [23, 53], 8, true);
			addAnimation("crouching", [13], 0, false);
			addAnimation("terminal", [76, 77, 78], 9, true);
			
			// Associate animations with actions.
			associateAnimation(["idle"], ActorAction.STOP);
			associateAnimation(["idle"], ActorAction.LAND);
			associateAnimation(["walk"], ActorAction.RUN);
			associateAnimation(["jump_rising"], ActorAction.JUMP);
			associateAnimation(["jump_falling"], ActorAction.FALL);
			associateAnimation(["roll"], ActorAction.ROLL);
			associateAnimation(["weak_normal_attack_windup"], ActorAction.WINDUP, 0);
			associateAnimation(["weak_attack_hit"], ActorAction.ATTACK, 0);
			associateAnimation(["strong_normal_attack_windup"], ActorAction.WINDUP, 3);
			associateAnimation(["strong_attack_hit"], ActorAction.ATTACK, 3);
			associateAnimation(["weak_air_attack_windup"], ActorAction.WINDUP, 1);
			associateAnimation(["weak_air_attack_hit"], ActorAction.ATTACK, 1);
			associateAnimation(["weak_low_attack_windup"], ActorAction.WINDUP, 2);
			associateAnimation(["weak_low_attack_hit"], ActorAction.ATTACK, 2);
			associateAnimation(["hurt_kneeling", "hurt_flashing"], ActorAction.HURT, 0);
			associateAnimation(["hurt_flying"], ActorAction.HURT, 1);
			associateAnimation(["hurt_flying"], ActorAction.REPELLED);
			associateAnimation(["die_falling", "die_flashing"], ActorAction.DIE);
			associateAnimation(["crouching"], ActorAction.CROUCH);
			associateAnimation(["terminal"], ActorAction.COMPUTER);
			
			// Create sound associations with states.
			associatePeriodicSound(new PeriodicSound(Sounds.PLAYER_WALKING, 0.25, 0.25), ActorState.RUNNING);
			associatePeriodicSound(new PeriodicSound(Sounds.CRATE, 0.5, 0.25), ActorState.PUSHING);
			// Create sound associations with actions.
			associateSound(new SoundEffect(Sounds.PLAYER_JUMP, 0.5), ActorAction.JUMP);
			associateSound(new SoundEffect(Sounds.PLAYER_PUNCH, 0.5), ActorAction.ATTACK);
			associateSound(new SoundEffect(Sounds.PLAYER_LAND, 0.75), ActorAction.LAND);
			associateSound(new SoundEffect(Sounds.PLAYER_HURT, 0.5), ActorAction.HURT);
			associateSound(new SoundEffect(Sounds.PLAYER_DEATH, 0.25), ActorAction.DIE);
			
			// Set physic constants.
			maxVelocity = MAX_VELOCITY;
			acceleration.y = 1000;
			
			// Set up the attack variables.
			_attackReleased = true;
			_attackType = 0;
			
			statManager = new StatManager();
			
			FlxG.watch(this, "stateName", "State");
			FlxG.watch(this, "position", "Position");
			FlxG.watch(this, "crouching", "Crouching")
		}
		
		public function get position() : String
		{
			return "(" + Math.floor(x) + ", " + Math.floor(y) + ")";
		}

		override public function initialize(x : Number, y : Number, health : Number = 100) : void
		{
			var stats : PlayerStats = new PlayerStats();
			
			super.initialize(x, y, Registry.playerStats.health);
			
			velocity.x = 0;
			velocity.y = 0;
			
			_stamina = Registry.playerStats.stamina;
			facing = FlxObject.RIGHT;
			_jumpReleased = true;
			executeAction(ActorAction.STOP, ActorState.IDLE);
			_jumpCount = 0;
			
			readyToReset = false;
			
			acquireWeapon(new Fists());
			//acquireWeapon(new HammerArm());
			_currentWeapon = 0;
			
			_standingUp = false;
			_prevCrouching = false;
		}
		
		override public function update():void 
		{
			super.update();
			
			updateStamina();
			buttonReleases();
			
			// Player can only be standin up for the first frame of a new state.
			if (currentStateFrame > 1)
				_standingUp = false;
			
			if (FlxG.cutscene)
			{
				updateCutsceneStates();
				drag.x = 0;
			}
			else
			{
				switch(state)
				{
					case ActorState.IDLE:
					case ActorState.PUSHING:
					case ActorState.RUNNING:
					case ActorState.JUMPING:
					case ActorState.FALLING:
						updateMovement();
						updateNextState();
						updateAttacking();
						drag.x = maxVelocity.x * 4;
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
					case ActorState.CROUCH_ATTACKING:
					case ActorState.ATTACKING:
						if (onGround)
						{
							acceleration.x = 0;
						}
						else
						{
							updateMovement();
						}
						drag.x = maxVelocity.x * 2;
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
									if (_crouching)
										executeAction(ActorAction.CROUCH, ActorState.CROUCHING);
									else
										executeAction(ActorAction.STOP, ActorState.IDLE);
								}
							});
						}
						break;
					case ActorState.CROUCHING:
						updateAttacking();
						break;
					case ActorState.DEAD:
						if (!actionTimer.running)
						{
							velocity.x = 0;
							acceleration.x = 0;
							actionTimer.start(RESET_TIME, 1, function(timer : FlxTimer) : void
							{
								readyToReset = true;
							});
						}
						break;
					case ActorState.REPELLED:
						if (!actionTimer.running)
						{
							executeAction(ActorAction.REPELLED, ActorState.REPELLED, 0);
							actionTimer.start(.25, 1, function(timer : FlxTimer) : void
							{
								if (state == ActorState.REPELLED)
								{
									executeAction(ActorAction.STOP, ActorState.IDLE);
								}
							});
						}
						break;
				}
				
				switchWeapons();
				
				if (!(onGround || state != ActorState.HURT))
					drag.x = maxVelocity.x;
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
			if (!_jumpReleased && !FlxG.keys.pressed("W") && !FlxG.keys.pressed("UP"))
			{
				_jumpReleased = true;
			}
			if (!_attackReleased && !FlxG.keys.pressed("J") && !FlxG.keys.pressed("K"))
			{
				_attackReleased = true;
			}
			
			if (state == ActorState.PUSHING && !(FlxG.keys.pressed("SPACE") && (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT))))
			{
				if (velocity.y == 0)
				{
					if (velocity.x == 0)
						executeAction(ActorAction.STOP, ActorState.IDLE);
					else
						executeAction(ActorAction.RUN, ActorState.RUNNING);
				}
				else
				{
					if (velocity.y < 0)
						executeAction(ActorAction.JUMP, ActorState.JUMPING);
					else
						executeAction(ActorAction.FALL, ActorState.FALLING);
				}
			}
			
			if (_crouching && (FlxG.keys.justReleased("S") || FlxG.keys.justReleased("DOWN")))
			{
				_crouching = false;
				if (state == ActorState.CROUCHING)
					executeAction(ActorAction.STOP, ActorState.IDLE);
			}
		}
		
		/** 
		 * Calculates the movement for the player when he is idle, running, jumping, or falling.
		 */
		private function updateMovement() : void 
		{
			// Update maximum velocity
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
			if (FlxG.keys.pressed("A") || FlxG.keys.pressed("LEFT"))
			{
				acceleration.x = -maxVelocity.x * 10;
				if (state != ActorState.ATTACKING && state != ActorState.CROUCH_ATTACKING)
					facing = FlxObject.LEFT;
			}
			else if (FlxG.keys.pressed("D") || FlxG.keys.pressed("RIGHT"))
			{
				acceleration.x = maxVelocity.x * 10;
				if (state != ActorState.ATTACKING && state != ActorState.CROUCH_ATTACKING)
					facing = FlxObject.RIGHT;
			}
			
			// If no directions are being pressed, stop movement.
			if (!FlxG.keys.pressed("D") && !FlxG.keys.pressed("A") && !FlxG.keys.pressed("LEFT") && !FlxG.keys.pressed("RIGHT")) 
			{
				acceleration.x = 0;
			}
			
			// If the player is pressing the jump button and still has jumps left, jump.
			if (state != ActorState.ATTACKING && state != ActorState.CROUCH_ATTACKING && (FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP")) && _jumpReleased && _jumpCount < 1)
			{
				velocity.y = -maxVelocity.y / 2.5;
				
				_jumpReleased = false;
				_jumpCount++;
				executeAction(ActorAction.JUMP, ActorState.JUMPING);
			}
			
			// Allow the player to end their jump early
			if ((FlxG.keys.justReleased("W") || FlxG.keys.justReleased("UP")) && velocity.y < 0)
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
				if (state == ActorState.JUMPING || state == ActorState.FALLING)
				{
					executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 1);
					actionTimer.start(WEAK_AIR_ATTACK_WINDUP, 1, weakWindupCallback);
				}
				else if (state == ActorState.CROUCHING)
				{
					executeAction(ActorAction.WINDUP, ActorState.CROUCH_ATTACKING, 2);
					actionTimer.start(WEAK_LOW_ATTACK_WINDUP, 1, weakWindupCallback);
				}
				else
				{
					executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 0);
					actionTimer.start(WEAK_NORMAL_ATTACK_WINDUP, 1, weakWindupCallback);
				}
				
				_attackReleased = false;
				_attackType = 0;
				//velocity.x = (facing == FlxObject.LEFT ? -1 : 1) * maxVelocity.x / 2;
			}
			else if (FlxG.keys.justPressed("K") && attackReady)
			{
				if (stamina < STRONG_ATTACK_STAM_COST)
				{
					flashStaminaBar();
				}
				else
				{
					if (state == ActorState.JUMPING || state == ActorState.FALLING)
					{
						executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 3);
						actionTimer.start(STRONG_AIR_ATTACK_WINDUP, 1, strongWindupCallback);
					}
					else if (state == ActorState.CROUCHING)
					{
						executeAction(ActorAction.WINDUP, ActorState.CROUCH_ATTACKING, 3);
						actionTimer.start(STRONG_LOW_ATTACK_WINDUP, 1, strongWindupCallback);
					}
					else
					{
						executeAction(ActorAction.WINDUP, ActorState.ATTACKING, 3);
						actionTimer.start(STRONG_NORMAL_ATTACK_WINDUP, 1, strongWindupCallback);
					}
				
					_attackReleased = false;
					_attackType = 1;
				}
				//velocity.x = (facing == FlxObject.LEFT ? -1 : 1) * maxVelocity.x / 2;
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
				else if (FlxG.keys.pressed("L") )
				{
					if (stamina < ROLL_STAM_COST)
					{
						flashStaminaBar();
					}
					else
					{
						executeAction(ActorAction.ROLL, ActorState.ROLLING);
						stamina -= ROLL_STAM_COST;
					}
				}
				else if (FlxG.keys.pressed("SPACE") && (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)))
				{
					var action : ActorAction = velocity.x != 0 ? ActorAction.RUN : ActorAction.STOP;
					if (state != ActorState.PUSHING || lastAction != action)
					{
						executeAction(action, ActorState.PUSHING);
					}
				}
				else if (FlxG.keys.pressed("S") || FlxG.keys.pressed("DOWN"))
				{
					if (state != ActorState.CROUCHING)
					{
						_crouching = true;
						executeAction(ActorAction.CROUCH, ActorState.CROUCHING);
						acceleration.x = 0;
					}
				}
				else if (velocity.x != 0 && state == ActorState.IDLE)
				{
					executeAction(ActorAction.RUN, ActorState.RUNNING);
				}
				else if (velocity.y == 0 && velocity.x == 0 && state != ActorState.IDLE)
				{
					executeAction(ActorAction.STOP, ActorState.IDLE);
				}
			}
			else
			{
				// These states can only be triggered when the player is in the air.
				if (!_standingUp && velocity.y > 0 && (ActorStateGroup.GROUND.contains(state) || state == ActorState.JUMPING))
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
			if (state == ActorState.ATTACKING || state == ActorState.CROUCH_ATTACKING)
			{
				if (prevState == ActorState.CROUCHING)
				{
					attackManager.weakAttack(facing, AttackType.LOW);
					executeAction(ActorAction.ATTACK, ActorState.CROUCH_ATTACKING, 2);
					actionTimer.start(WEAK_LOW_ATTACK_DELAY, 1, attackCallback);
				}
				else if (prevState == ActorState.JUMPING || prevState == ActorState.FALLING)
				{
					attackManager.weakAttack(facing, AttackType.AIR);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 1);
					actionTimer.start(WEAK_AIR_ATTACK_DELAY, 1, attackCallback);
				}
				else
				{
					attackManager.weakAttack(facing, AttackType.NORMAL);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 0);
					actionTimer.start(WEAK_NORMAL_ATTACK_DELAY, 1, attackCallback);
				}
			}
		}
		
		/**
		 * Callback for when the strong windup finishes.
		 */
		private function strongWindupCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING || state == ActorState.CROUCH_ATTACKING)
			{
				if (prevState == ActorState.CROUCHING)
				{
					attackManager.strongAttack(facing, AttackType.LOW);
					executeAction(ActorAction.ATTACK, ActorState.CROUCH_ATTACKING, 2);
					actionTimer.start(STRONG_LOW_ATTACK_DELAY, 1, attackCallback);
				}
				else if (prevState == ActorState.JUMPING || prevState == ActorState.FALLING)
				{
					attackManager.strongAttack(facing, AttackType.AIR);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 1);
					actionTimer.start(STRONG_AIR_ATTACK_DELAY, 1, attackCallback);
				}
				else
				{
					attackManager.strongAttack(facing, AttackType.NORMAL);
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING, 3);
					actionTimer.start(STRONG_NORMAL_ATTACK_DELAY, 1, attackCallback);
				}
				stamina -= STRONG_ATTACK_STAM_COST;
			}
		}
		
		/**
		 * Callback for when any attack has fully finished.
		 */
		private function attackCallback(timer : FlxTimer) : void
		{
			if (state == ActorState.ATTACKING)
			{
				if (!onGround && (prevState == ActorState.JUMPING || prevState == ActorState.FALLING))
				{
					if (velocity.y > 0)
						executeAction(ActorAction.FALL, ActorState.FALLING);
					else
						executeAction(ActorAction.JUMP, ActorState.JUMPING);
				}
				else
				{
					executeAction(ActorAction.STOP, ActorState.IDLE);
				}
			}
			else if (state == ActorState.CROUCH_ATTACKING)
			{
				if (FlxG.keys.pressed("S") || FlxG.keys.pressed("DOWN"))
					executeAction(ActorAction.CROUCH, ActorState.CROUCHING);
				else
					executeAction(ActorAction.STOP, ActorState.IDLE);
			}
		}
		
		public function flashStaminaBar() : void
		{
			(getManager(UIObjectManager) as UIObjectManager).flashStaminaBar(1);
		}
		
		/**
		 * Update stamina based on state.
		 */
		private function updateStamina() : void
		{
			stamina += STAM_REGEN;
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
			var oldState : ActorState = state;
			super.executeAction(action, newState, index);
			//Registry.addAction(action, index, 1);
			
			// Change the bounding box for the player if they're crouching, or
			// standing up from crouching.
			if (ActorStateGroup.CROUCH.contains(newState) && !ActorStateGroup.CROUCH.contains(oldState))
			{
				width = CROUCHING_HITBOX.x;
				height = CROUCHING_HITBOX.y;
				
				offset.y += NORMAL_HITBOX.y - CROUCHING_HITBOX.y;
				y += NORMAL_HITBOX.y - CROUCHING_HITBOX.y;
			}
			else if (!ActorStateGroup.CROUCH.contains(newState) && ActorStateGroup.CROUCH.contains(oldState))
			{
				width = NORMAL_HITBOX.x;
				height = NORMAL_HITBOX.y;
				
				offset.y -= NORMAL_HITBOX.y - CROUCHING_HITBOX.y;
				y -= NORMAL_HITBOX.y - CROUCHING_HITBOX.y;
				
				_standingUp = true;
			}
			
			_prevCrouching = _crouching;
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
		
		public function get crouching() : Boolean
		{
			return _crouching;
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
			dealDamage(damage);
			if (health > 0)
				executeAction(ActorAction.HURT, ActorState.HURT, (onGround) ? 0 : 1);
		}
		
		override public function dealDamage(damage : Number) : void
		{
			super.dealDamage(damage);
			Registry.playerStats.health = health;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}