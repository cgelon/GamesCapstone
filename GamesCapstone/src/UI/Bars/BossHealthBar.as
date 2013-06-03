package UI.Bars
{
	import managers.EnemyManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import people.enemies.BossEnemy;
	import states.GameState;
	
	/**
	 * Represents the boss' health in the HUD.
	 * 
	 * @author Chris Gelon
	 */
	public class BossHealthBar extends FlxGroup
	{
		/** 
		 * The boss' health in the previous frame. Used to check 
		 * against the current frame to update the bar.
		 */
		private var _previousHealth : Number;
		
		/** The image that represents one health. */
		[Embed(source = '../../../assets/hud/boss_health_block.png')] private var healthBlockPNG : Class;
		
		public function BossHealthBar(x : Number, y : Number) 
		{
			super();
			
			for (var i : int = 0; i < 40; i++)
			{
				var healthBlock : FlxSprite = new FlxSprite(x - i * 4, y, healthBlockPNG);
				healthBlock.scrollFactor = new FlxPoint(0, 0);
				add(healthBlock);
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (health != _previousHealth)
			{
				for (var i : int = 0; i < 40; i++)
				{
					(members[i] as FlxSprite).visible = (i < health) ? true : false;
				}
				_previousHealth = health;
			}
		}
		
		/**
		 * The current health of the boss.
		 */
		private function get health() : Number
		{
			var boss : BossEnemy = ((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).getFirstOfClass(BossEnemy) as BossEnemy;
			return (boss != null) ? boss.health : 0;
		}
	}
}