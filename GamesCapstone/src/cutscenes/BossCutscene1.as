package cutscenes 
{
	import cutscenes.engine.BossHealthBarAction;
	import cutscenes.engine.Cutscene;
	
	/**
	 * The beginning cutscene in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class BossCutscene1 extends Cutscene
	{
		public function BossCutscene1(callback : Function = null)
		{
			super(callback);
		}
		
		override public function run() : void
		{
			//var player : Player = (Manager.getManager(PlayerManager) as PlayerManager).player;
			//var room : BeginningRoom = (Manager.getManager(LevelManager) as LevelManager).level as BeginningRoom;
			//var computerLocation : FlxPoint = room.computerCoordinates;
			//computerLocation.x += player.width / 6;
			//
			//addAction(new ExistsAction(player, false));
			//addAction(new WaitAction(1));
			//addAction(new ExistsAction(player, true));
			//addAction(new WaitAction(0.3));
			//addAction(new ActorActionAction(player, ActorAction.CROUCH, ActorState.CROUCHING));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "I'm in!", player));
			//addAction(new ActorActionAction(player, ActorAction.STOP, ActorState.IDLE));
			//addAction(new MoveAction(player, computerLocation, 1));
			//addAction(new WaitAction(1));
			//addAction(new ActorActionAction(player, ActorAction.COMPUTER, ActorState.COMPUTER));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "Hacking into the mainframe now...", player));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "And BOOM!", player));
			//addAction(new ActorActionAction(player, ActorAction.STOP, ActorState.IDLE));
			//addAction(new MessageAction(MessageAction.INFORMANT, "???", "Can you hear me?", null));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "Loud and clear.", player));
			//addAction(new MessageAction(MessageAction.INFORMANT, "???", "Great, took you long enough.", null));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "You're professional.", player));
			//addAction(new MessageAction(MessageAction.INFORMANT, "???", "Thank you. Now, before you take out your target, you'll need to transverse through this lair... looks kind of like an evil lab.", null));
			//addAction(new ActorActionAction(player, ActorAction.COMPUTER, ActorState.COMPUTER));
			//addAction(new WaitAction(1));
			//addAction(new ActorActionAction(player, ActorAction.STOP, ActorState.IDLE));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "Belongs to one Wesley McToogle. Sounds like a stand up guy.", player));
			//addAction(new MessageAction(MessageAction.INFORMANT, "???", "Sounds like he's rich.", null));
			//addAction(new MessageAction(MessageAction.INFORMANT, "???", "I'll be helping you throughout this mission. You can call me... The Informant.", null));
			//addAction(new MessageAction(MessageAction.ACTOR, "???", "Well, in that case, call me ???.", player));
			//addAction(new MessageAction(MessageAction.INFORMANT, "The Informant", "Listen here, wisecrack, you might want to move around a little with those WASD keys.", null));
			addAction(new BossHealthBarAction());
			super.run();
		}
	}
}