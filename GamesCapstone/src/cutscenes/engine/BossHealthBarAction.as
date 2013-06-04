package cutscenes.engine 
{
	import managers.EnemyManager;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import people.enemies.BossEnemy;
	import states.GameState;
	import util.Sounds;
	/**
	 * Fills up the boss health bar.
	 * 
	 * @author Chris Gelon
	 */
	public class BossHealthBarAction extends Action 
	{
		private var _timer : FlxTimer;
		private var _callback : Function;
		
		public function BossHealthBarAction()
		{
			_timer = new FlxTimer;
		}
		
		override public function run(callback : Function) : void
		{
			boss.health = 0;
			_timer.start(0.1, 41, bossTimerCallback);
			_callback = callback;
		}
		
		private function bossTimerCallback(timer : FlxTimer) : void
		{
			if (timer.loopsLeft == 0)
			{
				_callback();
			}
			else
			{
				boss.health++;
				FlxG.play(Sounds.MESSAGE_BOX_LETTER);
			}
		}
		
		override public function skip():void 
		{
			_timer.stop();
			boss.health = 40;
		}
		
		private function get boss() : BossEnemy
		{
			return ((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).getFirstOfClass(BossEnemy) as BossEnemy;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_timer.destroy();
			_timer = null;
			_callback = null;
		}
	}
}