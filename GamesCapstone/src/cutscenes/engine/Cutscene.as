package cutscenes.engine 
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	/**
	 * A cutscene controls all of the behind the scene actions.
	 * Add actions to the cutscene, and it will execute them.
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
		
		public function Cutscene()
		{
			_actions = new Array();
		}
		
		protected function addAction(action : Action) : void
		{
			_actions.push(action);
		}
		
		public function run() : void
		{
			FlxG.cutscene = true;
			
			_trackedObject = FlxG.camera.target;
			_zoom = FlxG.camera.zoom;
			numActionsRunning = 0;
			_index = 0;
			
			nextAction();
		}
		
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
		
		private function actionFinished() : void
		{
			numActionsRunning--;
		}
		
		public function finish() : void
		{
			FlxG.camera.follow(_trackedObject, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.zoom = _zoom;
			FlxG.cutscene = false;
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
		}
	}
}