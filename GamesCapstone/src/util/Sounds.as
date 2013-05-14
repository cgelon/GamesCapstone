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
		[Embed(source = "../../sounds/menu.mp3")] public static const MENU:Class;
		
		/// Player Sounds ///
		
		[Embed(source = "../../sounds/playerWalk.mp3")] public static const PLAYER_WALKING:Class;
		[Embed(source = "../../sounds/playerJump.mp3")] public static const PLAYER_JUMP:Class;
		[Embed(source = "../../sounds/playerPunch.mp3")] public static const PLAYER_PUNCH:Class;
		[Embed(source = "../../sounds/playerPunchConnection.mp3")] public static const PLAYER_PUNCH_CONNECTION:Class;
		[Embed(source = "../../sounds/playerLand.mp3")] public static const PLAYER_LAND:Class;
		[Embed(source = "../../sounds/playerHurt.mp3")] public static const PLAYER_HURT:Class;
		[Embed(source = "../../sounds/playerBlock.mp3")] public static const PLAYER_BLOCK:Class;
		[Embed(source = "../../sounds/playerDeath.mp3")] public static const PLAYER_DEATH:Class;
		
		/// Robot Sounds ///
		
		[Embed(source = "../../sounds/robotAttack.mp3")] public static const ROBOT_ATTACK:Class;
		[Embed(source = "../../sounds/robotDeath.mp3")] public static const ROBOT_DEATH:Class;
		[Embed(source = "../../sounds/robotHurt.mp3")] public static const ROBOT_HURT:Class;
		[Embed(source = "../../sounds/robotLightningAttack.mp3")] public static const ROBOT_LIGHTNING_ATTACK:Class;
		[Embed(source = "../../sounds/robotWalk.mp3")] public static const ROBOT_WALK:Class;
		
		/// Environment Sounds ///
		[Embed(source = "../../sounds/crate.mp3")] public static const CRATE:Class;
		[Embed(source = "../../sounds/acid.mp3")] public static const ACID:Class;
		[Embed(source = "../../sounds/switch.mp3")] public static const SWITCH:Class;
	}
}