package cutscenes 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	/**
	 * A cutscene controls all of the behind the scene actions.
	 * For a cutscene, you should be able to just pass in a list of actions, and it should 
	 * playout in sequence.
	 * 
	 * @author Chris Gelon
	 */
	public class Cutscene extends FlxGroup 
	{
		private var _trackedObject : FlxObject;
		private var _zoom : Number;
		public var numActionsRunning : int;
		private var _actions : Array;
		private var _index : int;
		
		public function run(actions : Array)
		{
			_trackedObject = FlxG.camera.target;
			_zoom = FlxG.camera.zoom;
			_actions = actions;
			_numActionsRunning = 0;
			_index = 0;
			
			nextAction();
		}
		
		private function nextAction() : void
		{
			var action : Action = _actions[_index];
			add(action);
			switch(Class(action))
			{
				case WaitForAction:
					(action as WaitForAction).cutscene = this;
				case WaitAction:
				case MessageAction:
					action.run(nextAction);
					break;
				default:
					_numActionsRunning++;
					add(action);
					action.run(actionFinished);
					_index++;
					nextAction();
					break;
			}
			_index++;
		}
		
		private function actionFinished() : void
		{
			_numActionsRunning--;
		}
		
		public function finish()
		{
			FlxG.camera.follow(_trackedObject, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.zoom = _zoom;
		}
		
		override public function destroy()
		{
			super.destroy();
			
			_actions.length = 0;
			_actions = null;
			_trackedObject = null;
			_zoom = 0;
			_index = 0;
			_numActionsRunning = 0;
		}
	}
}