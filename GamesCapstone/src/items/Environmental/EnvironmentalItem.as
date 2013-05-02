package items.Environmental 
{
	import items.Item;
	import people.Actor;
	
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
		
		public function collideWith(actor : Actor) : void
		{
			
		}
	}

}