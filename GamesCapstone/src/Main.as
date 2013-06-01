package
{
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import states.MainMenuState;
	import states.GameState;
	
	[SWF(width = "640", height = "480")]
	[Frame(factoryClass="Preloader")]
 
	public class Main extends FlxGame
	{
		public function Main()
		{
			FlxG.debug = true;
			super( 320, 240, MainMenuState, 2, 30, 30 );
			//if (!FlxG.debug)
			//{
				//FlxG.recordReplay();
			//}
		}
	}
}