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
		
		public function add(action : ActorAction, count : uint = 1) : void
		{
			if (_statCounts[action] == undefined) 
				_statCounts[action] = count;
			else
				_statCounts[action] += count;
		}
		
		public function getCount(action : ActorAction) : uint
		{
			return _statCounts[action] == undefined ? 0 : _statCounts[action];
		}
	}

}