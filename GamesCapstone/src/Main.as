package
{
	import flash.external.ExternalInterface;
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import states.CreditState;
	import states.MainMenuState;
	import states.GameState;
	import util.SpeedRunTime;
	
	[SWF(width = "640", height = "480")]
	[Frame(factoryClass="Preloader")]
 
	public class Main extends FlxGame
	{
		public function Main()
		{
			FlxG.debug = false;
			super(320, 240, MainMenuState, 2, 30, 30);
			SpeedRunTime.load();
			//if (!FlxG.debug)
			//{
				//FlxG.recordReplay();
			//}
			if (ExternalInterface.available)
			{
				ExternalInterface.call("givemefocus");
			}
		}
	}
}