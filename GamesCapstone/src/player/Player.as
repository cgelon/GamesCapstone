package player
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite
	import Color;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	/** 
	 * Contains all of the information for a player.
	 */
	public class Player extends FlxSprite
	{
		/** 
		 * An array that keeps hold of what directions are currently being pressed. 
		 * 0 = right, 1 = down, 2 = left, 3 = up
		 */
		private var m_directionPressed:Array;
		
		/** The PNG for the player. */
		[Embed(source = '../../assets/player.png')] private var playerPNG : Class;
		
		/** 
		 * Creates a new player.
		 */
		function Player() : void 
		{
			super(FlxG.width / 2, FlxG.height / 5);

			// Initialize the directional press array
			m_directionPressed = [false, false, false, false];
			
			// Load the player.png into this sprite.
			loadGraphic(playerPNG, true, true, 64, 64, true);
			
			// Set the bounding box for the sprite.
			width = 28;
			height = 40;
			
			// Offset the sprite image's bounding box.
			offset.x = 18;
			offset.y = 13;
			
			// Create the animations we need.
			addAnimation("idle", [0], 0, false);
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
			addAnimation("jump", [1], 0, false);
			
			maxVelocity = new FlxPoint(200, 400);
			acceleration.y = 400;
			facing = FlxObject.RIGHT;
		}
		
		override public function update():void 
		{
			super.update();
			
			calculateMovement();
			animate();
		}
		
		/** 
		 * Calculates the movement for the player .
		 */
		private function calculateMovement() : void 
		{
			// Changes the m_directionPressed array to reflect what keys are currently pressed.
			m_directionPressed[0] = FlxG.keys.pressed("D");
			m_directionPressed[2] = FlxG.keys.pressed("A");
            m_directionPressed[1] = FlxG.keys.pressed("S");
			m_directionPressed[3] = FlxG.keys.pressed("W");
			
			// TODO: REDO MOVEMENT
			// If certain directions are being pressed, move.
			if (m_directionPressed[2]) {
                velocity.x = -speed;
				facing = FlxObject.LEFT;
            } else if (m_directionPressed[0]) {
                velocity.x = speed;
				facing = FlxObject.RIGHT;
			}
			
			// If no directions are being pressed, stop movement.
            if ( !m_directionPressed[0] && !m_directionPressed[2] ) {
                velocity.x = 0;
			}
			
			if (m_directionPressed[3] && isTouching(FlxObject.FLOOR))
			{
				velocity.y = -maxVelocity.y / 2;
			}
		}
		
		private function animate() : void
		{
			if (touching == FlxObject.FLOOR)
			{
				if (velocity.x != 0)
				{
					play("walk");
				}
				else
				{
					play("idle");
				}
			}
			else if (velocity.y < 0)
			{
				play("jump");
			}
		}
		
		/**
		 * The speed of the player.
		 */
		public function get speed() : Number
		{
			return maxVelocity.x;
		}
		
		override public function kill() : void
		{
			super.kill();
			m_directionPressed = [false, false, false, false];
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
			
			m_directionPressed.length = 0;
			m_directionPressed = null;
		}
	}
}