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
		[Embed(source = "../../sounds/playerWalk.mp3")] public static const PLAYER_WALKING:Class;
		[Embed(source="../../sounds/playerJump.mp3")] public static const PLAYER_JUMP:Class;
	}
}