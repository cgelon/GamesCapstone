package states 
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Door;
	import items.Environmental.Crate;
	import items.Environmental.EnvironmentalItem;
	import levels.Level;
	import managers.BackgroundManager;
	import managers.EnemyAttackManager;
	import managers.EnemyManager;
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
	import people.Actor;
	import people.enemies.Enemy;
	import people.players.Player;
	import people.states.ActorState;
	
	/**
	 * Base class for all game states.
	 * 
	 * @author Chris Gelon
	 */
	public class GameState extends FlxState 
	{
		/* Whether the player has been hit by an attack this frame.
		 * This is a workaround that is being used because FlxG.overlap
		 * calls the callback multiple times for a single overlap.
		 */
		private var playerHitThisFrame : Boolean;
		
		/** The level that is displayed in this state. */
		private var _level : Level;
		
		public function GameState(level : Level = null)
		{
			_level = (level != null) ? level : Registry.roomFlow.getFirstRoom();
		}
		
		override public function create() : void
		{
			// Set up all the managers before adding them to the state.
			var levelManager : LevelManager = new LevelManager();
			levelManager.addLevel(_level);
			
			var backgroundManager : BackgroundManager = new BackgroundManager();
			for (var i : int = 0; i < _level.backgroundStarts.length; i++ )
			{
				backgroundManager.addObject(_level.backgroundStarts[i], _level.backgroundTypes[i]);
			}
			for (i = 0; i < _level.doorLocs.length; i++)
			{
				backgroundManager.addObject(_level.doorLocs[i], Door);
			}
			
			var enemyManager : EnemyManager = new EnemyManager();
			for (i = 0; i < _level.enemyStarts.length; i++) 
			{
				enemyManager.addEnemy(_level.enemyStarts[i]);
			}
			
			var playerManager : PlayerManager = new PlayerManager();
			playerManager.addPlayer(_level.playerStart);
			
			var objectManager : ObjectManager = new ObjectManager();

			for (i = 0; i < _level.objectStarts.length; i++)
			{
				objectManager.addObject(_level.objectStarts[i], _level.objectTypes[i]);
			}
			
			var uiObjectManager : UIObjectManager = new UIObjectManager();
			uiObjectManager.createPlayerHud();
			for (i = 0; i < enemyManager.members.length; ++i)
			{
				if (enemyManager.members[i] != null) {
					uiObjectManager.addHealthBar((enemyManager.members[i] as Actor), 10, 10, 25, 5, true, true);
				}
			}
			
			var enemyAttackManager : EnemyAttackManager = new EnemyAttackManager();
			var playerAttackManager : PlayerAttackManager = new PlayerAttackManager();
			
			// Add the managers in this order:
			//	level
			//	background
			//	enemy
			//	player
			//	object
			//	ui
			//	enemy attack
			//	player attack
			active = false;
			addManager(levelManager);
			addManager(backgroundManager);
			addManager(enemyManager);
			addManager(playerManager);
			addManager(objectManager);
			addManager(uiObjectManager);
			addManager(enemyAttackManager);
			addManager(playerAttackManager);
			active = true;
			
			//	Tell flixel how big our game world is
			FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);
			
			//	Don't let the camera wander off the edges of the map
			FlxG.camera.setBounds(0, 0, _level.width, _level.height);
			
			//	The camera will follow the player
			FlxG.camera.follow(playerManager.player, FlxCamera.STYLE_PLATFORMER);
		}
		
		override public function update() : void
		{
			super.update();
			
			playerHitThisFrame = false;
			
			FlxG.collide(getManager(PlayerManager), getManager(LevelManager));
			FlxG.collide(getManager(EnemyManager), getManager(LevelManager));
			FlxG.overlap(getManager(EnemyManager), getManager(PlayerAttackManager), enemyHit);
			FlxG.overlap(getManager(PlayerManager), getManager(BackgroundManager), itemNotifyCallback);
			FlxG.overlap(getManager(EnemyManager), getManager(BackgroundManager), itemNotifyCallback);
			
			collideWithEnvironment(getManager(PlayerManager));
			collideWithEnvironment(getManager(EnemyManager));
			
			// Detect collisions between the player and enemies UNLESS the player is rolling.
			var player : Player = (getManager(PlayerManager) as PlayerManager).player;
			
			//FlxG.overlap(getManager(PlayerManager), getManager(EnemyManager), playerHit);
			FlxG.overlap(getManager(PlayerManager), getManager(EnemyAttackManager), playerAttacked);
			
				
			for each (var enemy : Enemy in getManager(EnemyManager).members)
			{
				//enemy.velocity.x = (enemy.x - player.x < 0) ? enemy.maxVelocity.x / 2 : -enemy.maxVelocity.x / 2;
			}
		}
		
		/**
		 * Collides all of the actors in the given Manager with the environmental
		 * objects.
		 * 
		 * @param	actorManager	Manager whose actors we want to collide with environment.
		 */
		private function collideWithEnvironment(actorManager: Manager) : void
		{
			var objManager : ObjectManager = (getManager(ObjectManager) as ObjectManager);
			
			FlxG.overlap(objManager, actorManager, collideUsingOverlapFix);
			FlxG.overlap(objManager, objManager, collideUsingOverlapFix);
			FlxG.collide(objManager, _level); // Collide objects with the level
		}
		
		private function collideUsingOverlapFix(Object1:FlxObject, Object2:FlxObject) : void
		{
			if (!((Object1.y + Object1.height - 1 < Object2.y) || (Object2.y + Object2.height - 1 < Object1.y)))
			{
				if (FlxObject.separateX(Object1, Object2))
				{
					if (Object1 is Crate && Object2 is Player)
					{
						if ((Object2 as Player).state == ActorState.PUSHING)
							(Object1 as Crate).beingPushed = true;
					}
					else if (Object1 is Crate && Object2 is Crate)
					{
						(Object1 as Crate).beingPushed = true;
						(Object2 as Crate).beingPushed = true;
					}
				}
			}
			
			if (!((Object1.x + Object1.width - 1 < Object2.x) || (Object2.x + Object2.width - 1 < Object1.x)))
			{
				FlxObject.separateY(Object1, Object2);
			}
		}
		
		private function itemNotifyCallback(person: Actor, obj: EnvironmentalItem): void 
		{
			obj.collideWith(person, this);
		}
		
		public function addAcid(flow:AcidFlow) : void
		{ 
			for (var i : int = 0; i < flow.members.length; i++)
			{
				getManager(BackgroundManager).add(flow.members[i]);
			}
			flow.playStart();
		}
		
		public function removeAcid(flow:AcidFlow) : void
		{ 
			for (var i : int = 0; i < flow.members.length; i++)
			{
				getManager(BackgroundManager).remove(flow.members[i]);
			}
		}
		 
		/**
		 * Callback function for when player is hit by an enemy attack
		 * @param	player
		 * @param	enemy
		 */
		private function playerAttacked(player : Player, attack : EnemyAttack) : void
		{
			if (!playerHitThisFrame)
			{
				(getManager(PlayerManager) as PlayerManager).HurtPlayer(attack);
				playerHitThisFrame = true;
			}
		}
		
		/**
		 * Callback function for when the player runs into an enemy.
		 * @param	player	The player in the interaction.
		 * @param	enemy	The enemy in the interaction.
		 */
		private function playerHit(player : Player, enemy : Enemy) : void
		{
			player.acceleration.x = 0;
			player.velocity.y = -player.maxVelocity.y / 6;
			player.velocity.x = ((player.x - enemy.x < 0) ? -1 : 1) * player.maxVelocity.x * 2;
			
			// If the player is pinned against a wall, make the fly the other direction.
			if ((player.isTouching(FlxObject.RIGHT) && player.velocity.x > 0)
				|| (player.isTouching(FlxObject.LEFT) && player.velocity.x < 0))
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
		private function enemyHit(enemy : Enemy, attack : Attack) : void
		{
			enemy.getHit(attack);
		}
		
		protected function moveToNextRoom() : void
		{
			var nextRoom : Level = Registry.roomFlow.getNextRoom(_level);
			if (nextRoom != null)
			{
				FlxG.switchState(new GameState(nextRoom));
			}
		}
		
		protected function moveToPreviousRoom() : void
		{
			var previousRoom : Level = Registry.roomFlow.getPreviousRoom(_level);
			if (previousRoom != null)
			{
				FlxG.switchState(new GameState(previousRoom));
			}
		}
		
		/**
		 * Add a manager to the game state.
		 */
		public function addManager(manager : Manager) : void
		{
			add(manager);
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class) : Manager
		{
			var i : uint = 0;
			for each (var object : Object in members)
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
		}
	}
}