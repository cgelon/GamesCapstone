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
		
		/**
		 * The number of stars the player has, based on their speed run time.
		 */
		public static function get stars() : uint
		{
			if (time < 220)
			{
				// 3 minutes 40 seconds
				return 5;
			}
			else if (time < 300)
			{
				// 5 mintues
				return 4;
			}
			else if (time < 480)
			{
				// 8 minutes
				return 3;
			}
			else if (time < 600)
			{
				// 10 minutes
				return 2;
			}
			else if (time < 900)
			{
				// 15 minutes
				return 1;
			}
			return 0;
		}
		
		/**
		 * The amount of seconds needed to achieve the next star, or 0 if the player already has 
		 * 5 stars.
		 */
		public static function get secondsUntilNextStar() : Number
		{
			switch(stars)
			{
				case 4:
					return 220;
				case 3:
					return 300;
				case 2:
					return 480;
				case 1:
					return 600;
				case 0:
					return 900;
				default:
					return 0;
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