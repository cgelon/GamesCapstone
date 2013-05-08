package util 
{
	/**
	 * Contains all of the sounds for easy access.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class Sounds 
	{
		[Embed(source = "../../sounds/messageBoxCharacter.mp3")] public static const MESSAGE_BOX_LETTER:Class;
		
		/// Player Sounds ///
		
		[Embed(source = "../../sounds/playerWalk.mp3")] public static const PLAYER_WALKING:Class;
		[Embed(source = "../../sounds/playerJump.mp3")] public static const PLAYER_JUMP:Class;
		[Embed(source = "../../sounds/playerPunch.mp3")] public static const PLAYER_PUNCH:Class;
		[Embed(source = "../../sounds/playerPunchConnection.mp3")] public static const PLAYER_PUNCH_CONNECTION:Class;
		[Embed(source = "../../sounds/playerLand.mp3")] public static const PLAYER_LAND:Class;
		[Embed(source = "../../sounds/playerHurt.mp3")] public static const PLAYER_HURT:Class;
	}
}