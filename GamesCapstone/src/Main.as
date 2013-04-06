package
{
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	[SWF(width="640", height="480", backgroundColor="#000000")]
 
	public class Main extends FlxGame
	{
		public function Main()
		{
			FlxG.debug = true;
			super( 640, 480, State, 1, 60, 60 );
		}
	}
}