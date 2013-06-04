package cutscenes 
{
	import cutscenes.engine.BossHealthBarAction;
	import cutscenes.engine.Cutscene;
	import cutscenes.engine.MessageAction;
	import cutscenes.engine.MoveAction;
	import cutscenes.engine.WaitAction;
	import cutscenes.engine.WaitForAction;
	import managers.EnemyManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import people.enemies.BossEnemy;
	import people.players.Player;
	import states.GameState;
	import util.Color;
	import util.Music;
	import util.ScreenOverlay;
	
	/**
	 * The first cutscene in the boss room. Some witty banter.
	 * 
	 * @author Chris Gelon
	 */
	public class BossCutscene1 extends Cutscene
	{
		private static var bossMusic : Boolean = false;
		
		public function BossCutscene1(callback : Function = null)
		{
			super(callback);
		}
		
		override public function run() : void
		{
			var player : Player = (Manager.getManager(PlayerManager) as PlayerManager).player;
			var boss : BossEnemy = ((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).getFirstOfClass(BossEnemy) as BossEnemy;
			
			if (!bossMusic && FlxG.music != null)
			{
				FlxG.music.fadeOut(2);
			}
			addAction(new WaitAction(0.5));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "You've finally arrived! I'm suprised.", boss, Color.RED));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Well, you could have made it a little harder.", player));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "Even if my fine estate did not defeat you, my arm... my robot arm will!", boss, Color.RED));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Hilarious.", player));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "Enough! We fight!", boss, Color.RED));
			addAction(new MoveAction(boss, new FlxPoint(boss.x + 130, boss.y), 1));
			addAction(new WaitForAction());
			addAction(new MoveAction(boss, new FlxPoint(boss.x + 100, boss.y), 0.2));
			addAction(new BossHealthBarAction());
			super.run();
		}
		
		override protected function finish():void 
		{
			super.finish();
			if (!bossMusic)
			{
				FlxG.playMusic(Music.BOSS, 0.6);
				bossMusic = true;
			}
		}
	}
}