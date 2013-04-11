package states
{
	import attacks.Attack;
	import levels.TestLevel;
	import managers.AttackManager;
	import managers.EnemyManager;
	import managers.PlayerManager;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import people.ActorState;
	import people.enemies.Enemy;
	import people.players.Player;
	
	public class State extends GameState 
	{
		private var _level : TestLevel;
		
		override public function create() : void
		{
			super.create();
			_level = new TestLevel();
			add(_level);
			var enemyManager : EnemyManager = new EnemyManager();
			addManager(enemyManager);
			var playerManager : PlayerManager = new PlayerManager();
			addManager(playerManager);
			var attackManager : AttackManager = new AttackManager();
			addManager(attackManager);
			
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
			FlxG.overlap(getManager(EnemyManager), getManager(AttackManager), enemyHit);
			FlxG.overlap(getManager(PlayerManager), getManager(EnemyManager), playerHit);
			for each (var enemy : Enemy in getManager(EnemyManager).members)
			{
				//enemy.velocity.x = (enemy.x - _player.x < 0) ? enemy.maxVelocity.x / 2 : -enemy.maxVelocity.x / 2;
			}
		}
		
		/**
		 * Callback function for when the player is hit by an enemy.
		 * @param	player	The player in the interaction.
		 * @param	enemy	The enemy in the interaction.
		 */
		private function playerHit(player : Player, enemy : Enemy) : void
		{
			player.acceleration.x = 0;
			player.velocity.y = -player.maxVelocity.y / 6;
			player.velocity.x = ((player.x - enemy.x < 0) ? -1 : 1) * player.maxVelocity.x * 2;
			player.state = ActorState.HURT;
		}
		
		/**
		 * Callback function for when the player hits an enemy.
		 * @param	enemy	The enemy in the interaction.
		 * @param	attack	The attack that hit the enemy.
		 */
		private function enemyHit(enemy : Enemy, attack : Attack) : void
		{
			enemy.velocity.x = ((enemy.x - attack.x < 0) ? -1 : 1) * enemy.maxVelocity.x;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_level = null;
		}
	}
}