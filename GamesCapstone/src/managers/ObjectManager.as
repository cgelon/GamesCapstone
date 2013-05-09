package managers
{
	import items.Environmental.EnvironmentalItem;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import states.GameState;

	import people.Actor;
	import people.players.Player;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class ObjectManager extends Manager 
	{
		
		public function addObject (location: FlxPoint, object:Class) : void
		{
			var obj : EnvironmentalItem = new object(location.x, location.y) as EnvironmentalItem;
			add(obj);
		}
		
		/**
		 * Takes all the items in this manager of type itemClass
		 * and sets their immovable attribute to the given flag.
		 * 
		 * @param	flag		What immovable should be set to.
		 * @param	itemClass	The class of items to set immovable for.
		 */
		public function setImmovable(flag : Boolean, itemClass : Class) : void
		{	
			for each (var item : EnvironmentalItem in members)
			{
				if (item != null && item is itemClass)
				{
					item.immovable = flag;
				}
			}
		}
		
		/**
		 * Goes through all items of type itemClass, and makes
		 * them immovable if the player is standing on them.
		 * Should be called before colliding the player
		 * with items of itemClass to avoid nonzero
		 * collision velocities.
		 * 
		 * @param	player		The player
		 * @param	itemClass	The class of items to make immovable.
		 */
		public function preCollide(actor : Actor, itemClass : Class) : void
		{
			for each (var item : EnvironmentalItem in members)
			{
				if (item != null && item is itemClass)
				{
					item.immovable = true;
					
					// Y-distance from item to actor
					var yDist : Number = (item.y - (actor.y + actor.height)); 
					
					// If the actor is "just above" the item, or if the actor will arrive on top within
					// the next frame, separate the actor and item (if they were overlapping) or slow
					// the actor down so that it will arrive just on top (if the actor hasn't reached
					// the item yet). Then set the item to immovable so that the actor can stand on
					// top of the item without having a nonzero collision velocity.
					if (((FlxG.overlap(item, actor) && yDist <= 0 && yDist >= -2) 		 // if actor is "just above" item
							|| yDist >= 0 && yDist <= FlxG.elapsed * actor.velocity.y)  // if actor will arrive on top within the next frame
						&& (actor.x + actor.width) > item.x 
						&& actor.x < (item.x + item.width))
					{
						item.immovable = false; // Item must be movable so that it and the player can be separated.
						FlxObject.separateY(item, actor);
						item.immovable = true;  // Item must be immovable so that the player can stand on it.
						
						// If the actor is going to get to *AT LEAST* the top of the item in the next frame,
						// slow it down so that it reaches *EXACTLY* the top of the item during the next frame.
						actor.velocity.y *= actor.velocity.y == 0 ? 0 : (item.y - (actor.y + actor.height)) / (FlxG.elapsed * actor.velocity.y);
					}
					else
					{
						// Actor isn't going to be trying to stand on the item?
						// Make sure that the item can move, then.
						item.immovable = false;
					}
				}				
			}
		}
		
	}	
}