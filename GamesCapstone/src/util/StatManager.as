package util 
{
	import flash.utils.Dictionary;
	import people.states.ActorAction;
	/**
	 * ...
	 * @author ...
	 */
	public class StatManager 
	{
		private var _statCounts : Dictionary;
		
		public function StatManager() 
		{
			_statCounts = new Dictionary();
		}
		
		public function add(action : ActorAction) : void
		{
			if (_statCounts[action] == undefined) 
				_statCounts[action] = 0;
			else
				_statCounts[action]++;
		}
		
		public function getCount(action : ActorAction) : uint
		{
			return _statCounts[action] == undefined ? 0 : _statCounts[action];
		}
	}

}