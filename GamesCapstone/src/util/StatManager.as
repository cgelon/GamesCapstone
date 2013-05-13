package util 
{
	import flash.net.NetGroupReplicationStrategy;
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
		
		public function add(action : ActorAction, index : uint = 0, count : uint = 1) : void
		{
			if (_statCounts[action] == undefined)
			{
				_statCounts[action] = new Array();
			}
			if (_statCounts[action][index] == null)
			{
				_statCounts[action][index] = 0;
			}
			_statCounts[action][index] = _statCounts[action][index] + count;
		}
		
		public function get actions() : Array
		{
			var actions : Array = new Array();
			for (var action : Object in _statCounts)
			{
				actions.push(action);
			}
			return actions;
		}
		
		public function getCounts(action : ActorAction) : Array
		{
			return _statCounts[action] == undefined ? new Array() : _statCounts[action];
		}
		
		public function getCount(action : ActorAction, index : uint) : uint
		{
			return _statCounts[action] == undefined ? 0 : _statCounts[action][index];
		}
	}

}