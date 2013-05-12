package cutscenes.engine 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import util.Color;
	
	/**
	 * Displays a message.
	 * 
	 * @author Chris Gelon
	 */
	public class MessageAction extends Action
	{
		private var _message : String;
		private var _object : FlxObject;
		
		public function MessageAction(message : String, object : FlxObject)
		{
			_message = message;
			_object = object;
		}
		
		override public function run(callback : Function) : void
		{
			display(_message, callback);
		}
		
		public function display(message : String, callback : Function = null) : void
		{
			var messageBox : MessageBox = new MessageBox();
			messageBox = new MessageBox();
			messageBox.setFormat(null, 8, Color.WHITE, Color.GREEN, 160, 3);
			// Set the position of the box to be right above the object.
			var position : FlxPoint = new FlxPoint();
			_object.getScreenXY(position, FlxG.camera);
			messageBox.setPosition(Math.max(position.x + _object.width / 2 - messageBox.width / 2, 0),
					Math.max(position.y - messageBox.height, 0));
			add(messageBox);
			messageBox.displayText("Player", message, callback);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_message = null;
			_object = null;
		}
	}
}