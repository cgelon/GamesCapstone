package managers
{
	
	import items.Environmental.Background.AcidFlow;
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
			obj.playStart();
			if ((obj) as AcidFlow)
			{
				var flow : AcidFlow = (obj) as AcidFlow;
				for (var i: int = 0; i < flow.myAcid.members.length; i++)
				{
					add(flow.myAcid.members[i]);
				}
			}
			else
			{
				add(obj);
			}
		}
	}	
}