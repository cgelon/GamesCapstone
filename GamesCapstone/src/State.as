package  
{
	import org.flixel.FlxState;
	import player.Player;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxCamera;
	
	public class State extends FlxState 
	{
		/** The current state of the game. */
		private var _state : int;
		
		private var _level : TestLevel;
		private var _player : Player;
		
		override public function create() : void
		{
			super.create();
			_level = new TestLevel();
			add(_level);
			_player = new Player();
			add(_player);
			
			//	Tell flixel how big our game world is
			FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);
			
			//	Don't let the camera wander off the edges of the map
			FlxG.camera.setBounds(0, 0, _level.width, _level.height);
			
			//	The camera will follow the player
			FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
		}
		
		override public function update() : void
		{
			super.update();
			FlxG.collide(_player, _level);
		}
		
		override public function destroy() : void
		{
			
		}
	}
}