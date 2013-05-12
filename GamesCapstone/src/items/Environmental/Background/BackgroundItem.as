package items.Environmental.Background
{
	import items.Environmental.EnvironmentalItem;
	import items.Item;
	import managers.BackgroundManager;
	import org.flixel.FlxBasic;
	import people.Actor;
	
	/**
	 * Provides the playStart function, a function only background items utilize
	 * @author Lydia Duncan
	 */
	public class BackgroundItem extends EnvironmentalItem implements BackgroundInterface
	{
		
		
		public function BackgroundItem(name : String) 
		{
			super(name);
		}
		
		public function playStart() : void
		{
			
		}
	}

}