package levels 
{
	import flash.utils.getDefinitionByName;
	/**
	 * Describes the room flow of the game.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class RoomFlow 
	{
		/**
		 * An internal tracker for the different rooms in the game.  The rooms are ordered by how 
		 * the player flows through them.
		 */
		private var _rooms : Array;
		
		public function RoomFlow()
		{
			_rooms = new Array();
			_rooms.push(StartingAcidLevel);
			_rooms.push(StartingLevel);
			_rooms.push(StartingEnemiesLevel);
		}
		
		/**
		 * @return	The first room the player appears in.
		 */
		public function getFirstRoom() : Level
		{
			return new _rooms[0]();
		}
		
		/**
		 * Grabs the next room to go to.
		 * @param	room	The current room the player is in.
		 * @return	The next room that the player will go to.  Will return null if the current room 
		 * is the last.
		 */
		public function getNextRoom(room : Level) : Level
		{
			var newIndex : int = _rooms.indexOf(room) + 1;
			if (newIndex < _rooms.length)
			{
				return new _rooms[newIndex]();
			}
			return null;
		}
		
		/**
		 * Grabs the previous room to go to.
		 * @param	room	The current room the player is in.
		 * @return	The previous room that the player will go to.  Will return null if the current 
		 * room is the first.
		 */
		public function getPreviousRoom(room : Level) : Level
		{
			var newIndex : int = _rooms.indexOf(room) - 1;
			if (newIndex >= 0)
			{
				return new _rooms[newIndex]();
			}
			return null;
		}
		
		/**
		 * Cleans up memory.
		 */
		public function destroy() : void
		{
			_rooms.length = 0;
		}
	}
}