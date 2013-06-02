package items.Environmental
{
	import items.Environmental.EnvironmentalGroup;
	import managers.EnemyManager;
	import managers.LevelManager;
	import managers.Manager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import states.GameState;
	/**
	 * @author Michael Zhou
	 */
	public class BlastDoor extends EnvironmentalGroup
	{
		private var X : Number;
		private var Y : Number;
		private var height : Number;
		private var endDoor : Boolean;
		public var state: String;
		
		function BlastDoor(X:Number = 0, Y:Number = 0, Height:Number = 1, endDoor:Boolean = false) : void 
		{	
			super();
			
			this.X = X;
			this.Y = Y;
			this.height = Height;
			this.endDoor = endDoor;
			for (var i: int = 0; i < height; i = i + 16)
			{
				add(new Wall(X, Y + i - height));
			}
			close();
		}
		
		public function open() : void
		{
			for (var i: int = 0; i < length; i++)
			{
				FlxVelocity.moveTowardsPoint(members[i], new FlxPoint(X + 8, Y + 16 * i + 8 - height), 100, 200);
				if (members[i].velocity.y == 0)
				{
					state = "open";
				} else
				{
					state = "opening";
				}
			}
		}
		
		public function close() : void
		{
			for (var i: int = 0; i < length; i++)
			{
				FlxVelocity.moveTowardsPoint(members[i], new FlxPoint(X + 8, Y + 16 * i + 8), 100, 250);
				if (members[i].velocity.y == 0)
				{
					state = "closed";
				} else
				{
					state = "closing";
				}
			}
		}
		
		override public function update() : void
		{
			super.update();
			if ((getManager(EnemyManager) as EnemyManager).allEnemiesDead() && endDoor)
			{
				state = "opening";
			}
			
			if (state == "closing")
			{
				close();
			}
			else if (state == "opening")
			{
				open();
			}
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class) : Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
	}	
}