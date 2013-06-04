package util 
{
	import org.flixel.FlxSave;
	/**
	 * The mechanism to save the time it takes for a player to beat a game.
	 * 
	 * @author Chris Gelon
	 */
	public class SpeedRunTime 
	{
		private static var _save : FlxSave;
		private static var _temp : Number;
		private static var _loaded : Boolean;
		
		/**
		 * Returns the amount of time it took the player to beat the game.
		 */
		public static function get time() : Number
		{
			if (_loaded)
			{
				return _save.data.time;
			}
			else
			{
				return _temp;
			}
		}
		
		/**
		 * Sets the time it too for the player to beat the game.
		 */
		public static function set time(value : Number) : void
		{
			if (_loaded)
			{
				if (_save.data.time == 0 || value < _save.data.time)
				{
					_save.data.time = value;
				}
			}
			else
			{
				if (_save.data.time > 0 && value < _save.data.time)
				{
					_temp = value;
				}
			}
		}
 
		public static function load() : void
		{
			_save = new FlxSave();
			_loaded = _save.bind("timeData");
			if (_loaded && _save.data.time == null)
			{
				_save.data.time = 0;
			}
		}
	}
}