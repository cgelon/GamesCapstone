package people.states 
{
	/**
	 * Defines a grouping of actor states to be in a specific, overarching group.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class ActorStateGroup
	{
		public static const CONTROL : ActorStateGroup = new ActorStateGroup([ActorState.IDLE, ActorState.JUMPING, ActorState.RUNNING, ActorState.FALLING]);
		public static const GROUND : ActorStateGroup = new ActorStateGroup([ActorState.IDLE, ActorState.RUNNING, ActorState.ROLLING, ActorState.BLOCKING, ActorState.CROUCHING]);
		
		/** Valid crouching state. */
		public static const CROUCH : ActorStateGroup = new ActorStateGroup([ActorState.CROUCHING, ActorState.ATTACKING, ActorState.HURT]);
		
		private var _states : Array;
		
		public function ActorStateGroup(states : Array)
		{
			_states = states;
		}
		
		/**
		 * @return	True if the state is contained within this group, false otherwise.
		 */
		public function contains(state : ActorState) : Boolean
		{
			for each(var s : ActorState in _states)
			{
				if (s == state)
				{
					return true;
				}
			}
			return false;
		}
	}
}