package items.Environmental 
{
	import items.Item;
	import people.Actor;
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
		
		public function collideWith(actor : Actor, state : State = null) : void
		{
			
		}
	}

}