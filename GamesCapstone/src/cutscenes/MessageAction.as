package cutscenes 
{
	/**
	 * Displays a message.
	 * 
	 * @author Chris Gelon
	 */
	public class MessageAction extends Action
	{
		private function _message : String;
		
		public function MessageAction(message : String)
		{
			_message = message;
			_callback = callback;
		}
		
		override public function run(callback : Function) : void
		{
			display(_message, callback);
		}
		
		public function display(message : String, callback : Function = null) : void
		{
			var messageBox : MessageBox = new MessageBox();
			add(messageBox);
			messageBox.displayText(message, callback);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_message.length = 0;
			_message = null;
		}
	}
}