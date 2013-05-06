package
{
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import states.State;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
 
	public class Main extends FlxGame
	{
		public function Main()
		{
			FlxG.debug = true;
			super( 320, 240, State, 2, 30, 30 );
			//FlxG.startRecording();
		}
	}
}