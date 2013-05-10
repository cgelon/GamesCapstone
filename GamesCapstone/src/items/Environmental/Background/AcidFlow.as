package items.Environmental.Background
{
	import items.Environmental.Background.Circuit.Reactor;
	import managers.BackgroundManager;
	import managers.LevelManager;
	import managers.Manager;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxTilemap;
	import states.GameState;
	/**
	 * @author Lydia Duncan
	 */
	public class AcidFlow extends Reactor implements BackgroundInterface
	{
		private var acidheight : Number;
		private var X : Number;
		private var Y : Number;
		
		function AcidFlow(X:Number = 0, Y:Number = 0) : void 
		{	
			super();
			
			this.acidheight = 1;
			this.X = X;
			this.Y = Y;
			for (var j: int = 0; j < acidheight; j++)
			{
				for (var i: int = 0; i < 2; i++)
				{				
					add(new Acid(X + 16 * i, Y + 16 * (j + 1)));
				}
			}
			// Keeps track of the acid that will flow when the lever is
			// activated	
		}
		
		override public function update() : void
		{ 
			
			if (!overlaps((getManager(LevelManager) as LevelManager).map)) 
			{
				for (var i: int = 0; i < 2; i++)
				{				
					add(new Acid(X + 16 * i, Y + 16 * (acidheight + 1)));
				}
				acidheight++;
				playStart();
			}
			super.update();
		}
		
		public function overlaps(group:FlxTilemap) : Boolean 
		{
			var result : Boolean = false;
			for (var i:int; i < length; i++) 
			{
				if (members[i] != null) {
					result = result || (members[i].overlaps(group));
				}
			}
			return result;
		}
		
		override public function playStart():void 
		{
			var k: int;
			for (k = 0; k < 2; k++)
			{
				members[k].play("slosh");
			}
			for (k = 2; k < members.length; k++)
			{
				if (members[k] != null) {
					members[k].play("idle");
				}
			}
		}

		
		override public function enable() : void
		{ 
			if (getManager(BackgroundManager) != null)
				getManager(BackgroundManager).add(this);
			playStart();
		}
		
		override public function disable() : void
		{ 
			if (getManager(BackgroundManager) != null)
				getManager(BackgroundManager).remove(this);
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