package items.Environmental.Background
{
	import items.Environmental.EnvironmentalGroup;
	import managers.BackgroundManager;
	import org.flixel.FlxBasic;
	
	/**
	 * Provides the playStart function, a function only background group items utilize
	 * 
	 * Intended only to store BackgroundItems
	 * @author Lydia Duncan
	 */
	public class BackgroundGroup extends EnvironmentalGroup implements BackgroundInterface
	{
		
		
		public function BackgroundGroup(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
		}
		
		public function playStart() : void
		{
			for (var i: int = 0; i < members.length; i++)
			{
				members[i].playStart();
			}
		}
		
	}

}