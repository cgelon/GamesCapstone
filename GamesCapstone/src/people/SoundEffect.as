package people 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	
	/**
	 * A periodic sound contains logic to start and stop the sound.
	 * 
	 * @author Chris Gelon
	 */
	public class SoundEffect 
	{
		/** The sound that will be played. */
		private var _soundClass : Class;
		/** The current sound being played, or null if there is no sound playing. */
		private var _sound : FlxSound;
		/** The volume of the sound. */
		private var _volume : Number;
		
		/**
		 * A Sound is used to play a soundd.
		 * 
		 * @param	sound	The sound to be played periodically.
		 * @param	volume	A number of 0.0 to 1.0 that represents the volume of the sound, 1.0 being 
		 * the loudest, and 0.0 being silent.
		 */
		public function SoundEffect(sound : Class, volume : Number = 1.0)
		{
			_soundClass = sound;
			_volume = volume;
		}
		
		/** Starts playing this periodic sound. */
		public function play() : void
		{
			_sound = FlxG.play(_soundClass, _volume);
		}
		
		/** Stop the periodic sound. */
		public function stop() : void
		{
			if (_sound != null)
			{
				_sound.stop();
				_sound = null;
			}
		}
		
		/** Cleans up memory. */
		public function destroy() : void
		{
			_soundClass = null;
			if (_sound != null)
			{
				_sound.stop();
				_sound = null;
			}
		}
	}
}