package cutscenes 
{
	import cutscenes.engine.ActorActionAction;
	import cutscenes.engine.CameraAction;
	import cutscenes.engine.Cutscene;
	import cutscenes.engine.ExistsAction;
	import cutscenes.engine.MessageAction;
	import cutscenes.engine.MoveAction;
	import cutscenes.engine.VisibilityAction;
	import cutscenes.engine.WaitAction;
	import levels.BeginningRoom;
	import managers.LevelManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import people.players.Player;
	import people.states.ActorAction;
	import people.states.ActorState;
	
	/**
	 * The beginning cutscene in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class BeginningCutscene extends Cutscene
	{
		public function BeginningCutscene() 
		{
			super();
			
			var player : Player = (Manager.getManager(PlayerManager) as PlayerManager).player;
			var room : BeginningRoom = (Manager.getManager(LevelManager) as LevelManager).level as BeginningRoom;
			var computerLocation : FlxPoint = room.computerCoordinates;
			computerLocation.x += player.width / 4;
			
			addAction(new ExistsAction(player, false));
			addAction(new WaitAction(1));
			addAction(new ExistsAction(player, true));
			addAction(new WaitAction(0.4));
			addAction(new ActorActionAction(player, ActorAction.CROUCH, ActorState.CROUCHING));
			addAction(new MessageAction(MessageAction.ACTOR, "Dex", "I'm in!", player));
			addAction(new ActorActionAction(player, ActorAction.RUN, ActorState.RUNNING));
			addAction(new MoveAction(player, computerLocation, 1));
			addAction(new WaitAction(1));
			addAction(new MessageAction(MessageAction.ACTOR, "Dex", "Hacking into mainframe now...", player));
			addAction(new MessageAction(MessageAction.ACTOR, "Dex", "And boom!", player));
			addAction(new MessageAction(MessageAction.INFORMANT, null, "Well took you long enough...", null));
			addAction(new MessageAction(MessageAction.ACTOR, "Dex", "So, my correspondant is snarky.", player));
		}
	}
}