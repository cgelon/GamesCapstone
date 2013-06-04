package states
{
	import attacks.Attack;
	import attacks.AttackType;
	import cutscenes.TheInformant;
	import items.Environmental.Background.Door;
	import items.Environmental.Crate;
	import items.Environmental.EnvironmentalItem;
	import items.Environmental.ForceFieldUnit;
	import items.Environmental.Generator;
	import levels.BossLair;
	import levels.EndLevel;
	import levels.Level;
	import managers.BackgroundManager;
	import managers.ControlBlockManager;
	import managers.CutsceneManager;
	import managers.EnemyAttackManager;
	import managers.EnemyManager;
	import managers.GroundSlamManager;
	import managers.LevelManager;
	import managers.Manager;
	import managers.ObjectManager;
	import managers.PlayerAttackManager;
	import managers.PlayerManager;
	import managers.UIObjectManager;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import people.Actor;
	import people.enemies.BossEnemy;
	import people.enemies.Enemy;
	import people.players.Player;
	import people.players.PlayerStats;
	import people.states.ActorState;
	import UI.TimeText;
	import util.Music;
	import util.PauseOverlay;
	import util.ScreenOverlay;
	import util.SpeedRunTime;
	
	/**
	 * Base class for all game states.
	 *
	 * @author Rowan and not Chris
	 */
	public class GameState extends FlxState
	{
		/* Whether the player has been hit by an attack this frame.
		 * This is a workaround that is being used because FlxG.overlap
		 * calls the callback multiple times for a single overlap.
		 */
		private var playerHitThisFrame:Boolean;
		
		/** Whether the player has switched rooms this frame. */
		private var movedRoomsThisFrame:Boolean;
		
		/** The level that is displayed in this state. */
		private var _level:Level;
		
		public function get level():Level
		{
			return _level;
		}
		
		/** True if the player is traveling to this room from the room in front of them, false otherwise. */
		private var _backward:Boolean;
		
		/** Displayed when the game is paused. */
		private var _pauseOverlay:PauseOverlay;
		
		public function GameState(level:Level = null, backward:Boolean = false)
		{
			_level = (level != null) ? level : Registry.roomFlow.getFirstRoom();
			_backward = backward;
		}
		
		override public function create():void
		{
			if (!(_level is BossLair) && (FlxG.music == null || !FlxG.music.active))
			{
				FlxG.playMusic(Music.CREEPY);
			}
			
			// Set up all the managers before adding them to the state.
			var levelManager:LevelManager = new LevelManager();
			levelManager.addLevel(_level);
			
			var backgroundManager:BackgroundManager = new BackgroundManager();
			for (var i:int = 0; i < _level.backgroundStarts.length; i++)
			{
				backgroundManager.addObject(_level.backgroundStarts[i], _level.backgroundTypes[i]);
			}
			for (i = 0; i < _level.doorLocs.length; i++)
			{
				backgroundManager.addObject(_level.doorLocs[i], Door);
			}
			
			for (i = 0; i < _level.backgroundCircuits.length; i++)
			{
				backgroundManager.addCircuit(_level.backgroundCircuits[i]);
			}
			
			var enemyManager:EnemyManager = new EnemyManager();
			for (i = 0; i < _level.enemyStarts.length; i++)
			{
				enemyManager.addEnemy(_level.enemyStarts[i], _level.enemyTypes[i]);
			}
			
			var playerManager:PlayerManager = new PlayerManager();
			playerManager.addPlayer((!_backward) ? _level.playerStart : _level.playerEnd);
			
			var objectManager:ObjectManager = new ObjectManager();
			
			for (i = 0; i < _level.objectStarts.length; i++)
			{
				if (_level.objectStarts[i] == null)
				{
					objectManager.addObjectInstance(_level.objectTypes[i]);
				}
				else
				{
					objectManager.addObject(_level.objectStarts[i], _level.objectTypes[i]);
				}
			}
			
			for (i = 0; i < _level.environmentalCircuits.length; i++)
			{
				objectManager.addCircuit(_level.environmentalCircuits[i]);
			}
			
			var uiObjectManager:UIObjectManager = new UIObjectManager();
			uiObjectManager.createPlayerHud();
			for (i = 0; i < enemyManager.members.length; ++i)
			{
				if (enemyManager.members[i] != null && !(enemyManager.members[i] is BossEnemy))
				{
					uiObjectManager.addHealthBar((enemyManager.members[i] as Actor), 10, 10, 25, 5, true, true);
				}
			}
			if (SpeedRunTime.time > 0)
			{
				uiObjectManager.add(new TimeText());
			}
			
			var enemyAttackManager:EnemyAttackManager = new EnemyAttackManager();
			var groundSlamManager:GroundSlamManager = new GroundSlamManager();
			var playerAttackManager:PlayerAttackManager = new PlayerAttackManager();
			
			var informant:TheInformant = new TheInformant();
			
			_pauseOverlay = new PauseOverlay();
			_pauseOverlay.exists = false;
			
			var controlBlockManager : ControlBlockManager = new ControlBlockManager();
			
			var cutsceneManager : CutsceneManager = new CutsceneManager();
			if (_level.cutscene != null)
			{
				//cutsceneManager.addCutscene(_level.cutscene);
			}
			
			// Add the managers in this order:
			//	level
			//	background
			//	enemy
			//	player
			//	object
			//	ui
			//	enemy attack
			//	player attack
			//	informant
			//	pause overlay
			active = false;
			addManager(levelManager);
			addManager(backgroundManager);
			addManager(enemyManager);
			addManager(playerManager);
			addManager(objectManager);
			addManager(uiObjectManager);
			addManager(enemyAttackManager);
			addManager(groundSlamManager);
			addManager(playerAttackManager);
			addManager(informant);
			addManager(controlBlockManager);
			addManager(cutsceneManager);
			add(_pauseOverlay);
			active = true;
			
			//	Tell flixel how big our game world is
			FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);
			
			//	Don't let the camera wander off the edges of the map
			FlxG.camera.setBounds(0, 0, _level.width, _level.height);
			
			//	The camera will follow the player
			FlxG.camera.follow(playerManager.player, FlxCamera.STYLE_PLATFORMER);
			
			if (levelManager.level.cutscene != null && !_backward)
			{
				levelManager.level.cutscene.run();
			}
		}
		
		override public function preUpdate():void
		{
			if (!FlxG.paused)
			{
				super.preUpdate();
			}
		}
		
		override public function update():void
		{
			if (!FlxG.cutscene && FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.paused = !FlxG.paused;
				_pauseOverlay.exists = FlxG.paused;
			}
			if (FlxG.paused)
			{
				return;
			}
			
			super.update();
			
			// Keep a running total of how much time has passed in the game.
			if (!FlxG.cutscene)
			{
				Registry.getInstance().time += FlxG.elapsed;
			}
			
			if ((getManager(PlayerManager) as PlayerManager).player.x > _level.map.width)
			{
				moveToNextRoom();
			}
			
			if ((getManager(PlayerManager) as PlayerManager).player.x < 0)
			{
				moveToPreviousRoom();
			}
			
			//if (FlxG.keys.justPressed("NINE"))
				//moveToPreviousRoom();
			//else if (FlxG.keys.justPressed("ZERO"))
				//moveToNextRoom();
			
			playerHitThisFrame = false;
			movedRoomsThisFrame = false;
			
			FlxG.collide(getManager(PlayerManager), getManager(LevelManager));
			FlxG.collide(getManager(EnemyManager), getManager(LevelManager));
			FlxG.collide(getManager(PlayerAttackManager), getManager(LevelManager), attackHitLevel);
			FlxG.collide(getManager(EnemyAttackManager), getManager(LevelManager), attackHitLevel);
			FlxG.overlap(getManager(EnemyManager), getManager(PlayerAttackManager), enemyHit);
			FlxG.overlap(getManager(PlayerManager), getManager(BackgroundManager), itemNotifyCallback);
			FlxG.overlap(getManager(EnemyManager), getManager(BackgroundManager), itemNotifyCallback);
			
			if (!FlxG.cutscene && (getManager(PlayerManager) as PlayerManager).player.state != ActorState.ROLLING)
			{
				(getManager(EnemyManager) as EnemyManager).setAllImmovable(true);
				FlxG.overlap(getManager(PlayerManager), getManager(EnemyManager), FlxObject.separateX);
				(getManager(EnemyManager) as EnemyManager).setAllImmovable(false);
			}
			
			collideWithEnvironment(getManager(PlayerManager));
			collideWithEnvironment(getManager(EnemyManager));
			collideWithEnvironment(getManager(PlayerAttackManager));
			
			//FlxG.overlap(getManager(PlayerManager), getManager(EnemyManager), playerHit);
			FlxG.overlap(getManager(PlayerManager), getManager(EnemyAttackManager), playerAttacked);
			FlxG.overlap(getManager(PlayerManager), getManager(GroundSlamManager), playerAttacked);
			
			if ((getManager(PlayerManager) as PlayerManager).player.readyToReset)
			{
				if (_level is EndLevel)
				{
					add(new ScreenOverlay());
					FlxG.cutscene = true;
					(getManager(PlayerManager) as PlayerManager).player.readyToReset = false;
				}
				else
				{
					(getManager(PlayerManager) as PlayerManager).player.health = PlayerStats.MAX_HEALTH;
					Registry.playerStats.health = PlayerStats.MAX_HEALTH;
					resetRoom();
				}
			}
			
			// Special conditions for when The Informant speaks.
			_level.checkInformant();
		}
		
		override public function postUpdate():void
		{
			if (!FlxG.paused)
			{
				super.postUpdate();
			}
		}
		
		/**
		 * Collides all of the actors in the given Manager with the environmental
		 * objects.
		 *
		 * @param	actorManager	Manager whose actors we want to collide with environment.
		 */
		private function collideWithEnvironment(actorManager:Manager):void
		{
			var objManager:ObjectManager = (getManager(ObjectManager) as ObjectManager);
			
			FlxG.overlap(objManager, actorManager, collideUsingOverlapFix);
			FlxG.overlap(objManager, objManager, collideUsingOverlapFix);
			FlxG.collide(objManager, _level); // Collide objects with the level
		}
		
		private function collideUsingOverlapFix(Object1:FlxObject, Object2:FlxObject):void
		{
			if (Object2 is Attack)
			{
				Object1.x = Object1.x;
			}
			if (!((Object1.y + Object1.height - 1 < Object2.y) || (Object2.y + Object2.height - 1 < Object1.y)))
			{
				if (FlxObject.separateX(Object1, Object2))
				{
					if (Object1 is Crate && Object2 is Player)
					{
						if ((Object2 as Player).state == ActorState.PUSHING)
							(Object1 as Crate).beingPushed = true;
						else
							(Object1 as Crate).beingPushed = false;
					}
					else if (Object1 is Crate && Object2 is Crate)
					{
						(Object1 as Crate).beingPushed = true;
						(Object2 as Crate).beingPushed = true;
					}
					else if (Object1 is ForceFieldUnit && Object2 is Actor)
					{
						(Object1 as ForceFieldUnit).touchedActor((Object2 as Actor));
					}
				}
				if (Object1 is Generator && Object2 is Attack)
				{
					(Object1 as Generator).isDestroyed = true;
				}
			}
			
			if (!((Object1.x + Object1.width - 1 < Object2.x) || (Object2.x + Object2.width - 1 < Object1.x)))
			{
				FlxObject.separateY(Object1, Object2);
			}
		}
		
		private function itemNotifyCallback(person:Actor, obj:EnvironmentalItem):void
		{
			obj.collideWith(person, this);
			if (obj is Door && FlxG.keys.justPressed("W") && !movedRoomsThisFrame)
			{
				if (person.x < _level.width / 2)
				{
					movedRoomsThisFrame = true;
					moveToPreviousRoom();
				}
				else
				{
					movedRoomsThisFrame = true;
					moveToNextRoom();
				}
			}
		}
		
		/**
		 * Callback function for when player is hit by an enemy attack
		 * @param	player
		 * @param	enemy
		 */
		private function playerAttacked(player:Player, attack:Attack):void
		{
			(getManager(PlayerManager) as PlayerManager).HurtPlayer(attack);
			playerHitThisFrame = true;
			
			if ((getManager(PlayerManager) as PlayerManager).player.state != ActorState.ROLLING)
			{
				if (attack.killOnHit)
					attack.kill();
			}
		}
		
		/**
		 * Callback function for when the player runs into an enemy.
		 * @param	player	The player in the interaction.
		 * @param	enemy	The enemy in the interaction.
		 */
		private function playerHit(player:Player, enemy:Enemy):void
		{
			player.acceleration.x = 0;
			player.velocity.y = -player.maxVelocity.y / 6;
			player.velocity.x = ((player.x - enemy.x < 0) ? -1 : 1) * player.maxVelocity.x * 2;
			
			// If the player is pinned against a wall, make the fly the other direction.
			if ((player.isTouching(FlxObject.RIGHT) && player.velocity.x > 0) || (player.isTouching(FlxObject.LEFT) && player.velocity.x < 0))
			{
				player.velocity.x = -player.velocity.x;
			}
			
			player.state = ActorState.HURT;
		}
		
		/**
		 * Callback function for when the player hits an enemy.
		 * @param	enemy	The enemy in the interaction.
		 * @param	attack	The attack that hit the enemy.
		 */
		private function enemyHit(enemy:Enemy, attack:Attack):void
		{
			if (!attack.hasHitActor(enemy))
			{
				attack.hitActor(enemy);
				enemy.getHit(attack);
			}
			//attack.kill();
		}
		
		protected function moveToNextRoom():void
		{
			var nextRoom:Level = Registry.roomFlow.getNextRoom();
			if (nextRoom != null)
			{
				FlxG.switchState(new GameState(nextRoom));
			}
		}
		
		protected function moveToPreviousRoom():void
		{
			var previousRoom:Level = Registry.roomFlow.getPreviousRoom();
			if (previousRoom != null)
			{
				FlxG.switchState(new GameState(previousRoom, true));
			}
		}
		
		public function attackHitLevel(attack:Attack, level:FlxTilemap):void
		{
			if (attack.type == AttackType.PROJECTILE)
			{
				attack.kill();
			}
		}
		
		protected function resetRoom():void
		{
			FlxG.switchState(new GameState(Registry.roomFlow.getCurrentRoom()));
		}
		
		/**
		 * Add a manager to the game state.
		 */
		public function addManager(manager:Manager):void
		{
			add(manager);
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c:Class):Manager
		{
			var i:uint = 0;
			for each (var object:Object in members)
			{
				if (object != null && object is c)
				{
					return object as Manager;
				}
			}
			return null;
		}
		
		override public function destroy():void
		{
			super.destroy();
			_level = null;
			_pauseOverlay = null;
		}
	}
}