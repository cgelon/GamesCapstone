package levels 
{
	
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
		
		private var _currentRoomIndex : uint;
		
		public function RoomFlow()
		{
			_rooms = new Array();
			_rooms.push(BeginningRoom);
			_rooms.push(StartingLevel);
			_rooms.push(PlatformLevel);
			_rooms.push(CrateJumpLevel); 
			_rooms.push(StartingEnemiesLevel);
			_rooms.push(EnemyPlatforms);
			_rooms.push(StartingAcidLevel);
			_rooms.push(AcidPlatformLevel); 
			_rooms.push(AcidSwitchesPlatforms);
			_rooms.push(AcidSwitches);
			_rooms.push(EvilLabVatLevel);
			_rooms.push(AcidCrates);
			_rooms.push(ForceFieldIntro);
			_rooms.push(ForceFieldSwitches);
			_rooms.push(ForceFieldAndAcid);
			_rooms.push(EndLevel);
			
			_currentRoomIndex = 0;
		}
		
		/**
		 * @return	The first room the player appears in.
		 */
		public function getFirstRoom() : Level
		{
			_currentRoomIndex = 0;
			return new _rooms[0]();
		}
		
		/**
		 * Grabs the next room to go to.
		 * @param	room	The current room the player is in.
		 * @return	The next room that the player will go to.  Will return null if the current room 
		 * is the last.
		 */
		public function getNextRoom() : Level
		{
			var newIndex : int = _currentRoomIndex + 1;
			if (newIndex != 0 && newIndex < _rooms.length)
			{
				_currentRoomIndex = newIndex;
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
		public function getPreviousRoom() : Level
		{
			var newIndex : int = _currentRoomIndex - 1;
			if (newIndex >= 0)
			{
				_currentRoomIndex = newIndex;
				return new _rooms[newIndex]();
			}
			return null;
		}
		
		/**
		 * @return	A copy of the current room that the player is in.
		 */
		public function getCurrentRoom() : Level
		{
			return new _rooms[_currentRoomIndex]();
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