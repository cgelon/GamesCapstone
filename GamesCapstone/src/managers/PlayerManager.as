package managers 
{
	import attacks.Attack;
	import people.players.Player;
	import org.flixel.FlxG;
	
	/**
	 * Manages all aspects of the player.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerManager extends Manager 
	{
		/** The current player. */
		public var player : Player;
		
		public function PlayerManager() 
		{
			player = new Player();
			player.initialize(FlxG.width / 2, FlxG.height / 5);
			add(player);
		}
	}
}