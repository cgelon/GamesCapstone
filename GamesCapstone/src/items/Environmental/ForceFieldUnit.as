package items.Environmental
{
	import org.flixel.FlxTimer;
	import people.Actor;
	import people.players.Player;
	import people.states.ActorAction;
	import people.states.ActorState;
	import org.flixel.FlxObject;
	/**
	 * Forcefield unit - most basic portion
	 * 
	 * @author Lydia Duncan
	 */
	public class ForceFieldUnit extends EnvironmentalItem
	{
		[Embed(source = '../../../assets/forcefield.png')] private var tileset: Class;
		private var startingX: int;
		private var startingY: int;
		
		public function ForceFieldUnit(X: Number = 0, Y: Number = 0)
		{
			super("forcefieldunit");
			initialize(X, Y);
			loadGraphic(tileset, true, false, 16, 16, false);
			addAnimation("lowerVert", [2], 1, true);
			addAnimation("midVert", [1], 1, true);
			addAnimation("upperVert", [0], 1, true);
			addAnimation("leftHoriz", [4], 1, true);
			addAnimation("midHoriz", [5], 1, true);
			addAnimation("rightHoriz", [6], 1, true);
			addAnimation("upperRight", [8], 1, true);
			addAnimation("upperLeft", [9], 1, true);
			addAnimation("lowerLeft", [10], 1, true);
			addAnimation("lowerRight", [11], 1, true);
			startingX = X;
			startingY = Y;
			
			immovable = true;
		}
		
		// Sets the bounding box depending on which edge this unit belongs on
		private function vertical() : void 
		{			
			height = 16;
			width = 8;
			offset.x = 4;
			offset.y = 0;
			if (startingX == x)
			{
				x = x + 4;
			}
			if (startingY != y)
			{
				y = startingY;
			}
		}
		
		// Sets the bounding box depending on which edge this unit belongs on
		private function horizontal() : void
		{
			height = 8;
			width = 16;
			offset.x = 0;
			offset.y = 4;
			if (startingY == y)
			{
				y = y + 4;
			}
			if (startingX != x)
			{
				x = startingX;
			}
		}
		
		private function corner() : void
		{
			height = 8;
			width = 8;
			offset.x = 4;
			offset.y = 4;
			if (startingY == y)
			{
				y = y + 4;
			}
			if (startingX == x)
			{
				x = x + 4;
			}
		}
		
		// plays the proper animation and sets the bounding box
		public function lowerVert() : void 
		{
			play("lowerVert");
			vertical();
		}
		
		// plays the proper animation and sets the bounding box
		public function midVert() : void
		{
			play("midVert");
			vertical();
		}
		
		// plays the proper animation and sets the bounding box
		public function upperVert() : void
		{
			play("upperVert");
			vertical();
		}
		
		// plays the proper animation and sets the bounding box
		public function leftHoriz() : void
		{
			play("leftHoriz");
			horizontal();
		}
		
		// plays the proper animation and sets the bounding box
		public function midHoriz() : void
		{
			play("midHoriz");
			horizontal();
		}
		
		// plays the proper animation and sets the bounding box
		public function rightHoriz() : void
		{
			play("rightHoriz");
			horizontal();
		}
		
		// plays the proper animation and sets the bounding box
		public function upperRight() : void
		{
			play("upperRight");
			corner();
		}
		
		// plays the proper animation and sets the bounding box
		public function lowerRight() : void
		{
			play("lowerRight");
			corner();
		}
		
		// plays the proper animation and sets the bounding box
		public function lowerLeft() : void
		{
			play("lowerLeft");
			corner();
		}
		
		// plays the proper animation and sets the bounding box
		public function upperLeft() : void
		{
			play("upperLeft");
			corner();
		}
		
		public function touchedActor(actor: Actor) : void
		{
			actor.acceleration.x = 0;
			actor.velocity.x = ((actor.x - x < 0) ? -1 : 1) * actor.maxVelocity.x * 2;
			
			// If the player is pinned against a wall, make the fly the other direction.
			if ((actor.isTouching(FlxObject.RIGHT) && actor.velocity.x > 0)
				|| (actor.isTouching(FlxObject.LEFT) && actor.velocity.x < 0))
			{
				actor.velocity.x = -actor.velocity.x;
			}
			// Currently only animates repelled when the player is the one colliding.  This
			// is bad because without the enemies recognizing that they shouldn't touch the
			// forcefield, they may just run into it over and over again and that would look
			// stupid.
			if (actor is Player) 
			{
				actor.state = ActorState.REPELLED;			
			}
		}
		
	}
}