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
		protected var enabled : Boolean;
		
		public function Trigger(name: String) 
		{
			super(name);
			enabled = false;
		}
		
		public function enable() : void
		{
			enabled = true;
			circuit_callback(true);
		}
		
		public function disable() : void
		{
			enabled = false;
			circuit_callback(false);
		}
		
		override public function track(manager: BackgroundManager) : void {
			manager.triggers.push(this);
		}
	}
}