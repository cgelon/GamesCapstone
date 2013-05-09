package states
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import flash.events.AccelerometerEvent;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.EnvironmentalItem;
	import levels.AcidPlatformLevel;
	import levels.CrateJumpLevel;
	import levels.EnemyPlatforms;
	import levels.EvilLabVatLevel;
	import levels.PlatformLevel;
	import levels.StartingAcidLevel;
	import levels.StartingEnemiesLevel;
	import levels.StartingLevel;
	import levels.TestLevel;
	import levels.Level;
	import managers.BackgroundManager;
	import managers.Manager;
	import managers.ObjectManager;
	import managers.PlayerAttackManager;
	import managers.EnemyAttackManager;
	import managers.EnemyManager;
	import managers.PlayerManager;
	import managers.UIObjectManager;
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.Door;
	import items.Environmental.Crate;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxObject;
	import people.states.ActorState;
	import people.enemies.Enemy;
	import people.players.Player;
	import people.Actor;
	
	public class State extends GameState 
	{	
		
		public static var level : Level;
		public static var playerManager : PlayerManager;
		public static var playerAttackManager : PlayerAttackManager;
		public static var enemyManager : EnemyManager;
		public static var enemyAttackManager : EnemyAttackManager;
		public static var uiObjectManager : UIObjectManager;
		public static var backgroundManager: BackgroundManager;
		public static var objectManager : ObjectManager;
		
		/* Whether the player has been hit by an attack this frame.
		 * This is a workaround that is being used because FlxG.overlap
		 * calls the callback multiple times for a single overlap.
		 */
		private var playerHitThisFame : Boolean;
		
		override public function create() : void
		{
			super.create();

			//level = new StartingLevel();
			//level = new PlatformLevel();
			//level = new CrateJumpLevel();
			level = new AcidPlatformLevel();
			//level = new StartingEnemiesLevel();
			//level = new EnemyPlatforms();
			//level = new EvilLabVatLevel();
			//level = new TestLevel();
			
			add(level);
			
			playerHitThisFame = false;
			
			backgroundManager = new BackgroundManager();
			for (var k : int = 0; k < level.backgroundStarts.length; k++ )
			{
				backgroundManager.addObject(level.backgroundStarts[k], level.backgroundTypes[k]);
			}
			for (var l : int = 0; l < level.doorLocs.length; l++)
			{
				backgroundManager.addObject(level.doorLocs[l], Door);
			}
			addManager(backgroundManager);
			
			objectManager = new ObjectManager();
			for (var m : int = 0; m < level.objectStarts.length; m++)
			{
				objectManager.addObject(level.objectStarts[m], level.objectTypes[m]);
			}
			addManager(objectManager);
			
			enemyManager = new EnemyManager();
			for (var i: int = 0; i < level.enemyStarts.length; i++) 
			{
				enemyManager.addEnemy(level.enemyStarts[i]);
			}
			addManager(enemyManager);
			
			
			
			playerManager = new PlayerManager(level.playerStart);
			addManager(playerManager);
			
			uiObjectManager = new UIObjectManager();
			//uiObjectManager.addHealthBar(playerManager.player, 10, 10, 50, 10, false, false);
			//uiObjectManager.addStaminaBar(playerManager.player, 10, 25, 50, 10, false);
			uiObjectManager.createPlayerHud();
			for (var j : int = 0; j < enemyManager.members.length; ++j)
			{
				if (enemyManager.members[j] != null)
					uiObjectManager.addHealthBar((enemyManager.members[j] as Actor), 10, 10, 25, 5, true, true);
			}
			addManager(uiObjectManager);
			
			playerAttackManager = new PlayerAttackManager();
			addManager(playerAttackManager);
			
			enemyAttackManager = new EnemyAttackManager();
			addManager(enemyAttackManager);
			
			//	Tell flixel how big our game world is
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			
			//	Don't let the camera wander off the edges of the map
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			
			//	The camera will follow the player
			FlxG.camera.follow(playerManager.player, FlxCamera.STYLE_PLATFORMER);
		}
		
		override public function update() : void
		{
			super.update();
			
			playerHitThisFame = false;
			
			FlxG.collide(getManager(PlayerManager), level);
			FlxG.collide(getManager(EnemyManager), level);
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
				//enemy.velocity.x = (enemy.x - _player.x < 0) ? enemy.maxVelocity.x / 2 : -enemy.maxVelocity.x / 2;
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
			
			// Set all environmental objects to be movable so that they can properly collide with the level.
			(getManager(ObjectManager) as ObjectManager).setImmovable(false, Crate);
			FlxG.collide(objManager, level); // Collide objects with the level
			
			// Perform pre-collisions to make sure that if the player and any objects are touching,
			// they are fully separated.
			for each (var actor : Actor in actorManager.members)
			{
				if (actor != null)
					objManager.preCollide(actor, Crate);
			}
			
			FlxG.collide(getManager(ObjectManager), getManager(ObjectManager)); // Means the crates interact with each other
			FlxG.collide(actorManager, getManager(ObjectManager), itemNotifyCallback);
		}
		
		private function itemNotifyCallback(person: Actor, obj: EnvironmentalItem): void 
		{
			obj.collideWith(person, this);
		}
		
		public function addAcid(flow:AcidFlow) : void
		{
			for (var i : int = 0; i < flow.myAcid.members.length; i++)
			{
				backgroundManager.add(flow.myAcid.members[i]);
			}
			flow.playStart();
		}
		
		public function removeAcid(flow:AcidFlow) : void
		{
			for (var i : int = 0; i < flow.myAcid.members.length; i++)
			{
				backgroundManager.remove(flow.myAcid.members[i]);
			}
		}
		 
		/**
		 * Callback function for when player is hit by an enemy attack
		 * @param	player
		 * @param	enemy
		 */
		private function playerAttacked(player : Player, attack : EnemyAttack) : void
		{
			if (!playerHitThisFame)
			{
				(getManager(PlayerManager) as PlayerManager).HurtPlayer(attack);
				playerHitThisFame = true;
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
		
		override public function destroy() : void
		{
			super.destroy();
			
			level = null;
		}
	}
}