package cutscenes 
{
	import cutscenes.engine.BossHealthBarAction;
	import cutscenes.engine.CameraAction;
	import cutscenes.engine.Cutscene;
	import cutscenes.engine.ExistsAction;
	import cutscenes.engine.MessageAction;
	import cutscenes.engine.MoveAction;
	import cutscenes.engine.TriggerBlastDoorAction;
	import cutscenes.engine.WaitAction;
	import cutscenes.engine.WaitForAction;
	import flash.media.Camera;
	import items.Environmental.BlastDoor;
	import levels.BossLair;
	import managers.EnemyManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import people.enemies.BossEnemy;
	import people.players.Player;
	import people.states.ActorAction;
	import people.states.ActorState;
	import states.GameState;
	import util.Color;
	import util.Music;
	import util.ScreenOverlay;
	
	/**
	 * The third cutscene in the boss room. This one has the boss saying his last breaths, and then 
	 * a victory message!
	 * 
	 * @author Chris Gelon
	 */
	public class BossCutscene3 extends Cutscene
	{
		public function BossCutscene3(callback : Function = null)
		{
			super(callback);
		}
		
		override public function run() : void
		{
			FlxG.music.fadeOut(3);
			var player : Player = (Manager.getManager(PlayerManager) as PlayerManager).player;
			player.velocity.x = player.velocity.y = 0;
			player.executeAction(ActorAction.STOP, ActorState.IDLE);
			var boss : BossEnemy = ((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).getFirstOfClass(BossEnemy) as BossEnemy;
			
			addAction(new WaitAction(0.1));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "But... my robot arm.", boss, Color.RED));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Still making excuses?", player));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "Whoever you are... they'll be after you.", boss, Color.RED));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Wait a second, who are they?", player));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "They... they... th-", boss, Color.RED));
			addAction(new ExistsAction(boss, false));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Well, that isn't good...", player));
			addAction(new MessageAction(MessageAction.INFORMANT, "Informant", "Good job!", null));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Oh, it's you again.", player));
			addAction(new MessageAction(MessageAction.INFORMANT, "Informant", "I just got some more intel, and it seems like you have another mission.", null));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Really?", player));
			addAction(new MessageAction(MessageAction.INFORMANT, "Informant", "Nope. Just kidding. Go home and get some rest.", null));
			addAction(new MessageAction(MessageAction.ACTOR, "???", "Real funny...", player));
			super.run();
		}
		
		override protected function finish():void 
		{
			super.finish();
			
			FlxG.state.add(new ScreenOverlay());
			FlxG.cutscene = true;
		}
	}
}