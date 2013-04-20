package people
{
	/**
	 * The different states an actor can be in.
	 * 
	 * @author Chris Gelon
	 */
	public class ActorState 
	{
		public static const IDLE : ActorState = new ActorState();
		public static const MOVING : ActorState = new ActorState();
		public static const JUMPING : ActorState = new ActorState();
		public static const ROLLING : ActorState = new ActorState();
		public static const ATTACKING : ActorState = new ActorState();
		public static const HURT : ActorState = new ActorState();
		public static const DEAD : ActorState = new ActorState();
		
		public function get name() : String
		{
			switch(this) {
				case IDLE:
					return "idle";
				case MOVING:
					return "moving";
				case JUMPING:
					return "jumping";
				case ATTACKING:
					return "attacking";
				case HURT:
					return "hurt";
				case ROLLING:
					return "rolling";
				case DEAD:
					return "dead";
			}
			return null;
		}
	}
}