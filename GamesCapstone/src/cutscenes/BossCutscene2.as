package cutscenes 
{
	import cutscenes.engine.BossHealthBarAction;
	import cutscenes.engine.CameraAction;
	import cutscenes.engine.Cutscene;
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
	
	/**
	 * The second cutscene in the boss room. This one has the boss retreating from the first area and 
	 * then disappearing into the stairwell.
	 * 
	 * @author Chris Gelon
	 */
	public class BossCutscene2 extends Cutscene
	{
		public function BossCutscene2(callback : Function = null)
		{
			super(callback);
		}
		
		override public function run() : void
		{
			var player : Player = (Manager.getManager(PlayerManager) as PlayerManager).player;
			player.velocity.x = player.velocity.y = 0;
			player.executeAction(ActorAction.STOP, ActorState.IDLE);
			var boss : BossEnemy = ((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).getFirstOfClass(BossEnemy) as BossEnemy;
			var door1 : BlastDoor = ((FlxG.state as GameState).level as BossLair).getBlastDoor(0);
			var door2 : BlastDoor =	((FlxG.state as GameState).level as BossLair).getBlastDoor(1);
			
			addAction(new WaitAction(0.1));
			addAction(new CameraAction(CameraAction.FOLLOW, boss, 0.1, null, 0));
			addAction(new MessageAction(MessageAction.ACTOR, "Wesley McToogle", "You are stronger than I thought... no matter!", boss, Color.RED));
			addAction(new MoveAction(boss, new FlxPoint(door1.X - 40, boss.y), (door1.X - boss.x) / 100));
			addAction(new WaitForAction());
			addAction(new TriggerBlastDoorAction(door1, true));
			addAction(new TriggerBlastDoorAction(door2, true));
			addAction(new MoveAction(boss, new FlxPoint(door1.X + 100, boss.y), 2));
			addAction(new WaitAction(2));
			addAction(new CameraAction(CameraAction.FOLLOW, player, 1, null, 0));
			super.run();
		}
	}
}