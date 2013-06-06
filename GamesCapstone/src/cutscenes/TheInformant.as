package cutscenes 
{
	import cutscenes.engine.MessageBox;
	import org.flixel.FlxGroup;
	import org.flixel.FlxTimer;
	import util.Color;
	import managers.Manager;
	
	/**
	 * Creates dialogue speeches for The Informant.
	 * 
	 * @author cgelon
	 */
	public class TheInformant extends Manager
	{
		public function talk(message : String) : void
		{
			var messageBox : MessageBox = new MessageBox(160, 0, 160, Color.WHITE, Color.BLUE, 4, "right");
			messageBox.displayText("The Informant", message, null, 0.02, true, 5);
			add(messageBox);
		}
	}
}