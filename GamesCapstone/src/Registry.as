package 
{
	import levels.RoomFlow;
	import people.players.PlayerStats;
	/**
	 * The registry is used to store global information about the game.
	 * 
	 * @author	Chris Gelon (cgelon)
	 */
	public class Registry
	{
		/** The one instance of the registry. */
		private static var s_registry : Registry;
		/** The stats the player needs to carry inbetween rooms. */
		private var _playerStats : PlayerStats;
		/** The flow of rooms in the game. */
		private var _roomFlow : RoomFlow;
		
		public function Registry()
		{
			_playerStats = new PlayerStats();
			_roomFlow = new RoomFlow();
		}
		
		/**
		 * @return an instance of the registry to be used
		 */
		public static function getInstance() : Registry 
		{
			if (s_registry == null) {
				s_registry = new Registry();
			}
			return s_registry;
		}
		
		/**
		 * The stats the player needs to keep track of between rooms.
		 */
		public static function get playerStats() : PlayerStats
		{
			return getInstance()._playerStats;
		}
		
		/**
		 * The flow of rooms in the game.
		 */
		public static function get roomFlow() : RoomFlow
		{
			return getInstance()._roomFlow;
		}
		
		/**
		 * @return a new instance of the registry (should be called when switching states)
		 */
		public static function reset() : Registry
		{
			if ( s_registry != null )
			{
				s_registry.destroy();
			}
			return getInstance();
		}
		
		/**
		 * Clean up memory.
		 */
		public function destroy() : void
		{
			s_registry = null;
			_playerStats.destroy();
			_playerStats = null;
			_roomFlow.destroy();
			_roomFlow = null;
		}
	}
}