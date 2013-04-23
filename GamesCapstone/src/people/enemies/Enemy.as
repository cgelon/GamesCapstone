package people.enemies 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import people.Actor;
	import people.players.Player;
	import states.State;
	import util.Color;
	
	/**
	 * A basic enemy.
	 * 
	 * @author Chris Gelon
	 */
	public class Enemy extends Actor 
	{
		public function Enemy() 
		{
			super();
			
			// Load the player.png into this sprite.
			makeGraphic(20, 40, Color.GREEN, true);
			
			maxVelocity = new FlxPoint(200, 500);
			acceleration.y = 500;
			facing = FlxObject.RIGHT;
			drag.x = maxVelocity.x * 4;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
		
		public function getPlayerXCoord() : Number
		{
			var player : Player = State.playerManager.player;
			return player.x;
		}
		
		public function getPlayerYCoord() : Number
		{
			var player : Player = State.playerManager.player;
			return player.y;
		}
		
		public function distanceToPlayer() : Number
		{
			var player : Player = State.playerManager.player;
			var deltaX : Number = x - player.x;
			var deltaY : Number = y - player.y;
			return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
		}
		
		public function getPlayer() : Player
		{
			return State.playerManager.player;
		}
	}

}