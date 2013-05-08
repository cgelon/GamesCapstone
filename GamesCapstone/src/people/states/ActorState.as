package people.states
{
	/**
	 * The different states an actor is in.
	 * 
	 * @author Chris Gelon
	 */
	public class ActorState 
	{
		public static const IDLE : ActorState = new ActorState();
		public static const RUNNING : ActorState = new ActorState();
		public static const JUMPING : ActorState = new ActorState();
		public static const FALLING : ActorState = new ActorState();
		public static const ROLLING : ActorState = new ActorState();
		public static const ATTACKING : ActorState = new ActorState();
		public static const HURT : ActorState = new ActorState();
		public static const DEAD : ActorState = new ActorState();
		public static const BLOCKING : ActorState = new ActorState();
		public static const CROUCHING : ActorState = new ActorState();
		
		public function get name() : String
		{
			switch(this) {
				case IDLE:
					return "idle";
				case RUNNING:
					return "running";
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
				case BLOCKING:
					return "blocking";
				case CROUCHING:
					return "crouching";
				case FALLING:
					return "falling";
			}
			return "NAME THIS FREAKING STATE";
		}
	}
}