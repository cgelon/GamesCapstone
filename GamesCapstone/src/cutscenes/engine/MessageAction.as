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
		private var _messageBox : MessageBox;
		private var _color : uint;
		
		public function MessageAction(type : String, title : String, message : String, object : FlxObject, color : uint = Color.GREEN)
		{
			_type = type;
			_title = title;
			_message = message;
			_object = object;
			_color = color;
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
			// Set the position of the box to be right above the object.
			var position : FlxPoint = new FlxPoint();
			_object.getScreenXY(position, FlxG.camera);
			_messageBox = new MessageBox(Math.max(position.x + _object.width / 2 - 80, 0),
					Math.max(position.y - MessageBox.getHeight(), 0), 160, Color.WHITE, _color);
			add(_messageBox);
			_messageBox.displayText(_title, _message, callback);
		}
		
		private function displayInformant(callback : Function = null) : void
		{
			_messageBox = new MessageBox(160, 0, 160, Color.WHITE, Color.BLUE);
			add(_messageBox);
			_messageBox.displayText(_title, _message, callback);
		}
		
		override public function skip():void 
		{
			if (_messageBox != null) 
			{
				_messageBox.kill();
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_message = null;
			_object = null;
			_title = null;
			_type = null;
		}
	}
}