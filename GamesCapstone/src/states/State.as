package states
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import levels.EvilLabVatLevel;
	import levels.TestLevel;
	import levels.Level;
	import managers.ObjectManager;
	import managers.PlayerAttackManager;
	import managers.EnemyAttackManager;
	import managers.EnemyManager;
	import managers.PlayerManager;
	import managers.UIObjectManager;
	import objects.Acid;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxObject;
	import people.ActorState;
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
		public static var objectManager : ObjectManager;
		
		override public function create() : void
		{
			super.create();
			
			level = new EvilLabVatLevel();
			//level = new TestLevel();
			
			add(level);
			
			objectManager = new ObjectManager();
			for (var k : int = 0; k < level.objectStarts.length; k++ )
			{
				objectManager.addObject(level.objectStarts[k], level.objectTypes[k]);
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
			uiObjectManager.addHealthBar(playerManager.player, 10, 10, 50, 10, false, false);
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
			FlxG.collide(getManager(PlayerManager), level);
			FlxG.collide(getManager(EnemyManager), level);
			FlxG.overlap(getManager(EnemyManager), getManager(PlayerAttackManager), enemyHit);
			FlxG.overlap(getManager(PlayerManager), getManager(ObjectManager), touchedSomething);
			FlxG.overlap(getManager(EnemyManager), getManager(ObjectManager), touchedSomething);
			
			// Detect collisions between the player and enemies UNLESS the player is rolling.
			var player : Player = (getManager(PlayerManager) as PlayerManager).player;
			
				//FlxG.overlap(getManager(PlayerManager), getManager(EnemyManager), playerHit);
				FlxG.overlap(getManager(PlayerManager), getManager(EnemyAttackManager), playerAttacked);
			
				
			for each (var enemy : Enemy in getManager(EnemyManager).members)
			{
				//enemy.velocity.x = (enemy.x - _player.x < 0) ? enemy.maxVelocity.x / 2 : -enemy.maxVelocity.x / 2;
			}
		}
		
		private function touchedSomething(person: Actor, obj: FlxObject): void 
		{
			if ((obj) as Acid) 
			{
				touchedAcid(person);
			}
		}
		
		/**
		 * Callback function for when a player or enemy runs into acid
		 * @param	person
		 */
		private function touchedAcid(person: Actor): void
		{
			person.touchedAcid();
		}
		 
		/**
		 * Callback function for when player is hit by an enemy attack
		 * @param	player
		 * @param	enemy
		 */
		private function playerAttacked(player : Player, attack : EnemyAttack) : void
		{
			(getManager(PlayerManager) as PlayerManager).HurtPlayer(attack);
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
			(getManager(EnemyManager) as EnemyManager).HurtEnemy(enemy, attack);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			level = null;
		}
	}
}