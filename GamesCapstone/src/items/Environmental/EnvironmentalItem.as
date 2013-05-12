package items.Environmental 
{
	import items.Item;
	import managers.BackgroundManager;
	import org.flixel.FlxObject;
	import people.Actor;
	import states.GameState;
	import states.State;
	
	/**
	 * Basis for all level items the player can interact with
	 * @author Lydia Duncan
	 */
	public class EnvironmentalItem extends Item
	{
		
		
		public function EnvironmentalItem(name : String) 
		{
			super(name);
		}
		
		public function collideWith(actor : Actor, state : GameState) : void
		{
			
		}
		
		
		public function track(manager: BackgroundManager) : void {
			
		}
		
		
		public function addTo(manager: BackgroundManager) : void {
			manager.add(this);
		}
	}

}