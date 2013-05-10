package items.Environmental.Background.Circuit 
{
	import items.Environmental.Background.BackgroundGroup;
	import managers.BackgroundManager;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Reactor extends BackgroundGroup
	{
		public function Reactor(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
		}
		public function enable() : void { }
		public function disable() : void { }
		
		override public function track(manager: BackgroundManager) : void {
			manager.reactors.push(this);
		}
	}
}