package managers 
{
	import levels.Level;
	import org.flixel.FlxTilemap;
	/**
	 * This manager stores the level.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class LevelManager extends Manager 
	{
		public function addLevel(level : Level) : void
		{
			add(level);
		}
		
		public function get map() : FlxTilemap
		{
			return level.map;
		}
		
		public function get level() : Level
		{
			return members[0] as Level;
		}
	}
}