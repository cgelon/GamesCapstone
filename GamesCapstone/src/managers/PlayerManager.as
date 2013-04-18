package managers 
{
	import attacks.Attack;
	import people.players.Player;
	import org.flixel.FlxPoint;
	
	/**
	 * Manages all aspects of the player.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerManager extends Manager 
	{
		/** The current player. */
		public var player : Player;
		
		public function PlayerManager(location : FlxPoint) 
		{
			player = new Player();
			player.initialize(location.x, location.y);
			add(player);
		}
	}
}