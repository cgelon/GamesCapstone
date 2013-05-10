package items.Environmental.Background.Circuit 
{
	import items.Environmental.Background.BackgroundItem;
	import managers.BackgroundManager;
	/**
	 * ...
	 * @author ...
	 */
	public class Trigger extends BackgroundItem
	{
		public var circuit_callback : Function;
		
		public function Trigger(name: String) 
		{
			super(name);
		}
		
		public function enable() : void
		{
			circuit_callback(true);
		}
		
		public function disable() : void
		{
			circuit_callback(false);
		}
		
		override public function track(manager: BackgroundManager) : void {
			manager.triggers.push(this);
		}
	}
}