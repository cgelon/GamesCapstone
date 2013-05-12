package items.Environmental 
{
	import managers.BackgroundManager;
	import org.flixel.FlxGroup;
	import people.Actor;
	import states.GameState;
	
	/**
	 * Basis for all level item groups the player can interact with
	 * 
	 * Intended only to store EnvironmentalItems
	 * @author Lydia Duncan
	 */
	public class EnvironmentalGroup extends FlxGroup
	{
		public var x: int;
		public var y: int;
		
		public function EnvironmentalGroup(X:Number = 0, Y:Number = 0) 
		{
			super();
			x = X;
			y = Y;
		}
		
		
		public function track(manager: BackgroundManager) : void {
			
		}
		
		public function addTo(manager: BackgroundManager) : void {
			manager.add(this);
		}
	}

}