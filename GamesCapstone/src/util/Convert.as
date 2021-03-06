package util 
{
	import org.flixel.FlxG
	
	/**
	 * Utility class for doing conversions.
	 */
	public class Convert 
	{
		
		public static function framesToSeconds(frames : Number) : Number
		{
			return frames / FlxG.framerate;
		}
		
		public static function secondsToFrames(seconds : Number) : Number
		{
			return FlxG.framerate * seconds;
		}
	}

}