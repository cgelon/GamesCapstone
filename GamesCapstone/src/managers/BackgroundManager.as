package managers
{
	
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.BackgroundGroup;
	import items.Environmental.Background.BackgroundItem;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import states.GameState;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class BackgroundManager extends Manager 
	{
		
		public function addObject (location: FlxPoint, object:Class) : void
		{
			var obj : BackgroundItem = new object(location.x, location.y) as BackgroundItem;
			if (obj != null)
			{
				obj.playStart();
				add(obj);
			}
			else 
			{				
				var obj2 : BackgroundGroup = new object(location.x, location.y) as BackgroundGroup;
				if (obj2 != null)
				{
					obj2.playStart();
					
					for (var i : int = 0; i < obj2.members.length; i++)
					{
						add(obj2.members[i]);
					}
				}
			}
		}
	}	
}