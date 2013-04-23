package states
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import levels.EvilLabVatLevel;
	import levels.TestLevel;
	import levels.Level;
	import managers.PlayerAttackManager;
	import managers.EnemyAttackManager;
	import managers.EnemyManager;
	import managers.PlayerManager;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxObject;
	import people.ActorState;
	import people.enemies.Enemy;
	import people.players.Player;
	
	public class State extends GameState 
	{
		private var _level : Level;
		
		override public function create() : void
		{
			super.create();
			
			//_level = new EvilLabVatLevel();
			_level = new TestLevel();
			
			add(_level);
			var enemyManager : EnemyManager = new EnemyManager();
			for (var i: int = 0; i < _level.enemyStarts.length; i++) {
				enemyManager.addEnemy(_level.enemyStarts[i]);
			}
			addManager(enemyManager);
			var playerManager : PlayerManager = new PlayerManager(_level.playerStart);
			addManager(playerManager);
			var playerAttackManager : PlayerAttackManager = new PlayerAttackManager();
			addManager(playerAttackManager);
			var enemyAttackManager : EnemyAttackManager = new EnemyAttackManager();
			addManager(enemyAttackManager);
			
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
			FlxG.collide(getManager(PlayerManager), _level);
			FlxG.collide(getManager(EnemyManager), _level);
			FlxG.overlap(getManager(EnemyManager), getManager(PlayerAttackManager), enemyHit);
			
			// Detect collisions between the player and enemies UNLESS the player is rolling.
			var player : Player = (getManager(PlayerManager) as PlayerManager).player;
			if (!(player.state == ActorState.ROLLING || player.state == ActorState.HURT || player.state == ActorState.DEAD))
			{
				//FlxG.overlap(getManager(PlayerManager), getManager(EnemyManager), playerHit);
				FlxG.overlap(getManager(PlayerManager), getManager(EnemyAttackManager), playerAttacked);
			}
				
			for each (var enemy : Enemy in getManager(EnemyManager).members)
			{
				//enemy.velocity.x = (enemy.x - _player.x < 0) ? enemy.maxVelocity.x / 2 : -enemy.maxVelocity.x / 2;
			}
		}
		
		/**
		 * Callback function for when player is hit by an enemy attack
		 * @param	player
		 * @param	enemy
		 */
		private function playerAttacked(player : Player, attack : EnemyAttack) : void
		{
			player.acceleration.x = 0;
			//player.velocity.y = -player.maxVelocity.y / 6;
			player.velocity.x = ((player.x - attack.x < 0) ? -1 : 1) * player.maxVelocity.x * 2;
			
			// If the player is pinned against a wall, make the fly the other direction.
			if ((player.isTouching(FlxObject.RIGHT) && player.velocity.x > 0)
				|| (player.isTouching(FlxObject.LEFT) && player.velocity.x < 0))
			{
				player.velocity.x = -player.velocity.x;
			}
			
			// Check that the player can be hit, because this function will get called multiple times as the player is
			// moving out of the attack's hitbox.
			if (!(player.state == ActorState.ROLLING || player.state == ActorState.HURT || player.state == ActorState.DEAD))
			{
				player._health--;
			}
			
			if (player._health == 0)
				player.state = ActorState.DEAD;
			else
				player.state = ActorState.HURT;
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
			var player : Player = (getManager(PlayerManager) as PlayerManager).player;
			enemy.velocity.x = ((enemy.x - player.x < 0) ? -1 : 1) * enemy.maxVelocity.x;
			
			if (!(enemy.state == ActorState.HURT || enemy.state == ActorState.DEAD))
				enemy._health--;
				
			if (enemy._health == 0)
				enemy.state = ActorState.DEAD;
			else
				enemy.state = ActorState.HURT;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_level = null;
		}
	}
}