package people.players 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import util.StatManager;
	import levels.Level;
	import people.states.ActorAction;
	
	/**
	 * Stores the player stats that are necessary to keep throughout different states.
	 */
	public class PlayerStats 
	{
		/** The maximum amount of health the player can have. */
		public static const MAX_HEALTH : Number = 10;
		/** The maximum amount of stamina the player can have. */
		public static const MAX_STAMINA : Number = 100;
		
		/** Internal tracker for health. */
		private var _health : int;
		/** Internal tracker for stamina. */
		private var  _stamina : Number;
		
		private var _levelToActionsDict : Dictionary;
		
		public function PlayerStats() 
		{
			_health = MAX_HEALTH;
			_stamina = MAX_STAMINA;
			_levelToActionsDict = new Dictionary();
		}
		
		/** The current health of the player. */
		public function get health():int 
		{
			return _health;
		}
		
		/** The current health of the player. */
		public function set health(value:int):void 
		{
			_health = value;
		}
		
		/** The current stamina of the player. */
		public function get stamina():Number 
		{
			return _stamina;
		}
		
		/** The current stamina of the player. */
		public function set stamina(value:Number):void 
		{
			_stamina = value;
		}
		
		public function addActionForLevel(action : ActorAction, count : uint, levelName : String) : void
		{
			if (_levelToActionsDict[levelName] == undefined)
			{
				_levelToActionsDict[levelName] = new StatManager();
			}
			_levelToActionsDict[levelName].add(action, count);
		}
		
		public function getNumberOfAction(action : ActorAction, levelName : String) : uint
		{
			var statManager : StatManager = (_levelToActionsDict[levelName] as StatManager);
			return statManager == null ? 0 : statManager.getCount(action);
		}
		
		public function destroy() : void
		{
			_health = 0;
			_stamina = 0;
		}
	}
}