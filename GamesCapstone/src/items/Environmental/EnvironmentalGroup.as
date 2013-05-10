package items.Environmental 
{
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
		
		public function collideWith(actor : Actor, state : GameState) : void
		{
			for (var i: int = 0; i < members.length; i++) 
			{
				members[i].collideWith(actor, state);
			}
		}
		
		
		override public function draw():void 
		{
			for (var i: int = 0; i < members.length; i++)
			{
				(members[i] as EnvironmentalItem).draw();
			}
		}
		
		override public function update():void 
		{
			for (var i: int = 0; i < members.length; i++)
			{
				var mem : EnvironmentalItem = members[i] as EnvironmentalItem;
				mem.preUpdate();
				mem.update();
				mem.postUpdate();
			}
		}
	}

}