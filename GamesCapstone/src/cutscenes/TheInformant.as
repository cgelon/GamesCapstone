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
		private var _messageBox : MessageBox;
		
		public function talk(message : String) : void
		{
			_messageBox = new MessageBox();
			_messageBox.setFormat(null, 8, Color.WHITE, Color.BLUE, 160, 3, "right");
			_messageBox.setPosition(160, 0);
			_messageBox.displayText("The Informant", message, destroyMessage, 0.02, true, 2);
			add(_messageBox);
		}
		
		private function destroyMessage() : void
		{
			remove(_messageBox, true);
			_messageBox.destroy();
			_messageBox = null;
		}
		
		override public function destroy() : void 
		{
			super.destroy();
		}
	}
}