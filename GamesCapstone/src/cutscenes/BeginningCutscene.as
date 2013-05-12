package cutscenes 
{
	import cutscenes.engine.ActorActionAction;
	import cutscenes.engine.CameraAction;
	import cutscenes.engine.Cutscene;
	import cutscenes.engine.ExistsAction;
	import cutscenes.engine.MessageAction;
	import cutscenes.engine.VisibilityAction;
	import cutscenes.engine.WaitAction;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
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
			
			addAction(new ExistsAction(player, false));
			addAction(new WaitAction(1));
			addAction(new ExistsAction(player, true));
			addAction(new WaitAction(0.4));
			addAction(new ActorActionAction(player, ActorAction.CROUCH, ActorState.CROUCHING));
			addAction(new MessageAction("I'm in!", player));
			run();
		}
	}
}