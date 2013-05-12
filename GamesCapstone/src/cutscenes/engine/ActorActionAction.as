package cutscenes.engine 
{
	import people.Actor;
	import people.states.ActorAction;
	import people.states.ActorState;
	
	/**
	 * Makes an actor perform an action.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class ActorActionAction extends Action
	{
		private var _actor : Actor;
		private var _action : ActorAction;
		private var _state : ActorState;
		
		public function ActorActionAction(actor : Actor, action : ActorAction, state : ActorState)
		{
			_actor = actor;
			_action = action;
			_state = state;
		}
		
		override public function run(callback:Function):void 
		{
			_actor.executeAction(_action, _state);
			callback();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_actor = null;
			_action = null;
			_state = null;
		}
	}
}