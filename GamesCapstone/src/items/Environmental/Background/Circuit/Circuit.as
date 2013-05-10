package items.Environmental.Background.Circuit 
{
	import org.flixel.FlxBasic;
	/**
	 * A circuit connecting two background objects
	 * @author Michael Zhou
	 */
	public class Circuit extends FlxBasic
	{
		public var trigger : Trigger;
		public var reactor : Reactor;
		
		public function Circuit(trigger:Trigger, reactor:Reactor, activated:Boolean) 
		{
			this.trigger = trigger;
			this.trigger.circuit_callback = callback;
			this.reactor = reactor;
			if (activated) {
				trigger.enable();
			} else {
				trigger.disable();
			}
		}
		
		public function callback(enabled : Boolean) : void
		{
			if (enabled) {
				this.reactor.enable();
			} else {
				this.reactor.disable();
			}
		}
		
	}
}