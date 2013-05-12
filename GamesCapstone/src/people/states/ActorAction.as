package people.states
{
	/**
	 * The different actions an actor takes.
	 * 
	 * @author Chris Gelon
	 */
	public class ActorAction 
	{
		public static const STOP : ActorAction = new ActorAction();
		public static const JUMP : ActorAction = new ActorAction();
		public static const FALL : ActorAction = new ActorAction();
		public static const RUN : ActorAction = new ActorAction();
		public static const LAND : ActorAction = new ActorAction();
		public static const ATTACK : ActorAction = new ActorAction();
		public static const WINDUP : ActorAction = new ActorAction();
		public static const ROLL : ActorAction = new ActorAction();
		public static const BLOCK : ActorAction = new ActorAction();
		public static const HURT : ActorAction = new ActorAction();
		public static const DIE : ActorAction = new ActorAction();
		public static const CROUCH : ActorAction = new ActorAction();
		public static const COMPUTER : ActorAction = new ActorAction();
		
		public function get name() : String
		{
			switch(this) {
				case STOP:
					return "stop";
				case JUMP:
					return "jump";
				case FALL:
					return "fall";
				case RUN:
					return "run";
				case LAND:
					return "land";
				case ATTACK:
					return "attack";
				case WINDUP:
					return "windup";
				case ROLL:
					return "roll";
				case BLOCK:
					return "block";
				case HURT:
					return "hurt";
				case DIE:
					return "die";
				case CROUCH:
					return "crouch";
				case COMPUTER:
					return "computer";
			}
			return "NAME THIS ACTION PLEASE";
		}
	}
}