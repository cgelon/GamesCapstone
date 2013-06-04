package cutscenes.engine 
{
	import items.Environmental.BlastDoor;
	
	/**
	 * Triggers a blast door to open or close.
	 * 
	 * @author Chris Gelon
	 */
	public class TriggerBlastDoorAction extends Action 
	{
		private var _door : BlastDoor;
		private var _open : Boolean;
		
		public function TriggerBlastDoorAction(door : BlastDoor, open : Boolean) 
		{
			_door = door;
			_open = open;
		}
		
		override public function run(callback:Function):void 
		{
			if (_open)
			{
				_door.open();
			}
			else
			{
				_door.close();
			}
			if (callback != null)
			{
				callback();
			}
		}
		
		override public function skip():void 
		{
			run(null);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_door = null;
		}
	}
}