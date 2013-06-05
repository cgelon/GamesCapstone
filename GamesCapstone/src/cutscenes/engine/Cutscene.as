package cutscenes.engine 
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import util.Color;
	import util.FadingText;
	
	/**
	 * A cutscene controls all of the behind the scene actions.
	 * Add actions to the cutscene, and it will execute them.
	 * 
	 * @author Chris Gelon
	 */
	public class Cutscene extends FlxGroup 
	{
		/** The object that was being tracked by the camera before the cutscene started. */
		private var _trackedObject : FlxObject;
		/** The zoom of the camera before the cutscene started. */
		private var _zoom : Number;
		/** The current number of actions running at any moment. */
		public var numActionsRunning : int;
		/** A list of all the actions that occur in this cutscene. */
		private var _actions : Array;
		/** The index of the current action being executed. */
		private var _index : int;
		/** True if the cutscene has finished, false otherwise. */
		private var _finished : Boolean;
		/** True if the cutscene has finished, false otherwise. */
		public function get finished() : Boolean 
		{
			return _finished;
		}
		/** The function to be called when the cutscene finishes. */
		private var _callback : Function;
		
		/** Fading text that tells the player to press enter to skip the cutscene. */
		private var _fadingText : FadingText;
		
		/**
		 * Creates a cutscene with no actions.
		 */
		public function Cutscene(callback : Function = null)
		{
			_actions = new Array();
			
			// Create the fading text to tell the player what to press.
			_fadingText = new FadingText(FlxG.width / 4, 210, FlxG.width / 2, "Press [ENTER] to skip.", true);
			_fadingText.setFormat(null, 8, Color.WHITE, "center", Color.BLACK);
			_fadingText.scrollFactor.x = _fadingText.scrollFactor.y = 0;
			_fadingText.exists = false;
			add(_fadingText);
			
			_callback = callback;
		}
		
		/**
		 * Add an action to the cutscene.
		 * @param	action	The action to add to the cutscene.
		 */
		protected function addAction(action : Action) : void
		{
			_actions.push(action);
		}
		
		/**
		 * Run the entire cutscene.
		 */
		public function run() : void
		{	
			FlxG.cutscene = true;
			
			_trackedObject = FlxG.camera.target;
			_zoom = FlxG.camera.zoom;
			numActionsRunning = 0;
			_index = 0;
			_fadingText.exists = true;
			
			// Always add a wait for action at the end to ensure that everything gets done before the end.
			add(new WaitForAction());
			nextAction();
		}
		
		/**
		 * Execute the next action.
		 */
		private function nextAction() : void
		{
			if (_index < _actions.length)
			{
				var action : Action = _actions[_index];
				add(action);
				_index++;
				switch(Class(Object(action).constructor))
				{
					case WaitForAction:
						(action as WaitForAction).cutscene = this;
					case WaitAction:
					case MessageAction:
					case BossHealthBarAction:
					case CameraAction:
						action.run(nextAction);
						break;
					default:
						numActionsRunning++;
						add(action);
						action.run(actionFinished);
						nextAction();
						break;
				}
			}
			else
			{
				finish();
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (FlxG.cutscene && !finished && FlxG.keys.pressed("ENTER"))
			{
				skip();
			}
		}
		
		/**
		 * Callback for when an action finishes.
		 */
		private function actionFinished() : void
		{
			numActionsRunning--;
		}
		
		/**
		 * Skip the rest of the cutscene, and finish it off.
		 */
		public function skip() : void
		{
			_index = 0;
			while (_index < _actions.length)
			{
				var action : Action = _actions[_index];
				add(action);
				_index++;
				action.skip();
			}
			
			finish();
		}
		
		/**
		 * Finish the cutscene and return the camera to the original place.
		 */
		protected function finish() : void
		{
			if (!finished)
			{
				FlxG.camera.follow(_trackedObject, FlxCamera.STYLE_PLATFORMER);
				FlxG.camera.zoom = _zoom;
				FlxG.cutscene = false;
				_fadingText.exists = false;
				_finished = true;
				if (_callback != null)
				{
					_callback();
				}
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_actions.length = 0;
			_actions = null;
			_trackedObject = null;
			_zoom = 0;
			_index = 0;
			numActionsRunning = 0;
			_fadingText = null;
		}
	}
}