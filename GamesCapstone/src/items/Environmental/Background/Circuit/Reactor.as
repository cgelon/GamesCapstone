package items.Environmental.Background.Circuit 
{
	import items.Environmental.EnvironmentalGroup;
	import managers.BackgroundManager;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Reactor extends EnvironmentalGroup
	{
		protected var enabled : Boolean;
		
		public function Reactor(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			this.enabled = false;
		}
		
		public function enable() : void
		{
			this.enabled = true;
		}
		
		public function disable() : void
		{
			this.enabled = false;
		}
		
		override public function track(manager: BackgroundManager) : void {
			manager.reactors.push(this);
		}
	}
}