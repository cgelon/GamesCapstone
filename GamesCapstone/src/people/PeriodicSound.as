package people 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxTimer;
	
	/**
	 * A periodic sound contains logic to start and stop the sound, which plays at a specific interval.
	 * 
	 * @author Chris Gelon
	 */
	public class PeriodicSound 
	{
		/** The timer for playing the sound periodically. */
		private var _timer : FlxTimer;
		/** The amount of time inbetween plays of the sound. */
		private var _time : Number;
		/** The sound that will be played. */
		private var _soundClass : Class;
		/** The current sound being played, or null if there is no sound playing. */
		private var _sound : FlxSound;
		/** The volume of the sound. */
		private var _volume : Number;
		
		/**
		 * A PeriodicSound is used to play a sound periodically (every once in a while).
		 * 
		 * @param	sound	The sound to be played periodically.
		 * @param	time	The amount of time, in seconds, inbetween plays.
		 * @param	volume	A number of 0.0 to 1.0 that represents the volume of the sound, 1.0 being 
		 * the loudest, and 0.0 being silent.
		 */
		public function PeriodicSound(sound : Class, time : Number, volume : Number = 1.0)
		{
			_timer = new FlxTimer();
			_soundClass = sound;
			_time = time;
			_volume = volume;
		}
		
		/** Starts playing this periodic sound. */
		public function play() : void
		{
			_timer.start(_time, 0, playCallback, true);
		}
		
		/** Callback for when the periodic sound should be played. */
		private function playCallback(timer : FlxTimer) : void
		{
			_sound = FlxG.play(_soundClass, _volume);
		}
		
		/** Stop the periodic sound. */
		public function stop() : void
		{
			_timer.stop();
			if (_sound != null)
			{
				_sound.stop();
				_sound = null;
			}
		}
		
		/** Cleans up memory. */
		public function destroy() : void
		{
			_timer.destroy();
			_timer = null;
			_soundClass = null;
			if (_sound != null)
			{
				_sound.destroy();
				_sound = null;
			}
		}
	}
}