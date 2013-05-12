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
		public static const ACTOR : String = "actor";
		public static const INFORMANT : String = "informant";
		
		private var _type : String;
		private var _title : String;
		private var _message : String;
		private var _object : FlxObject;
		
		public function MessageAction(type : String, title : String, message : String, object : FlxObject)
		{
			_type = type;
			_title = title;
			_message = message;
			_object = object;
		}
		
		override public function run(callback : Function) : void
		{
			switch(_type)
			{
				case ACTOR:
					displayAboveActor(callback);
					break;
				case INFORMANT:
					displayInformant(callback);
					break;
			}
		}
		
		private function displayAboveActor(callback : Function = null) : void
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
			messageBox.displayText(_title, _message, callback);
		}
		
		private function displayInformant(callback : Function = null) : void
		{
			var messageBox : MessageBox = new MessageBox();
			messageBox = new MessageBox();
			messageBox.setFormat(null, 8, Color.WHITE, Color.BLUE, 160, 3);
			messageBox.setPosition(160, 0);
			add(messageBox);
			messageBox.displayText("The Informant", _message, callback);
		}
		
		override public function destroy() : void
		{
			super.destroy();
						_message = null;
			_object = null;
		}
	}
}