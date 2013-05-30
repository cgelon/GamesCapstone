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
		[Embed(source = '../../../assets/forcefield2.png')] private var tileset: Class;
		private var startingX: int;
		private var startingY: int;
		
		public function ForceFieldUnit(X: Number = 0, Y: Number = 0)
		{
			super("forcefieldunit");
			initialize(X, Y);
			loadGraphic(tileset, true, false, 16, 16, false);
			addAnimation("lowerVert", [25], 1, true);
			addAnimation("midVert", [15], 1, true);
			addAnimation("upperVert", [10], 1, true);
			addAnimation("leftHoriz", [11], 1, true);
			addAnimation("midHoriz", [12], 1, true);
			addAnimation("rightHoriz", [14], 1, true);
			
			addAnimation("top", [1], 1, true);
			addAnimation("bottom", [5], 1, true);
			addAnimation("left", [0], 1, true);
			addAnimation("right", [6], 1, true);
			
			addAnimation("upperRight", [3], 1, true);
			addAnimation("upperLeft", [2], 1, true);
			addAnimation("lowerLeft", [7], 1, true);
			addAnimation("lowerRight", [8], 1, true);
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
			height = 16;
			width = 16;
			offset.x = 0;
			offset.y = 0;
			if (startingY != y)
			{
				y = startingY;
			}
			if (startingX != x)
			{
				x = startingX;
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
		
		public function top() : void
		{
			play("top");
			vertical();
		}
		
		public function bottom() : void
		{
			play ("bottom");
			vertical();
		}
		
		public function left() : void
		{
			play ("left");
			horizontal();
		}
		
		public function right() : void
		{
			play ("right");
			horizontal();
		}
		
		public function touchedActor(actor: Actor) : void
		{
			if (_curAnim.name == "lowerVert" || _curAnim.name == "midVert" || _curAnim.name == "upperVert" ||
				_curAnim.name == "leftHoriz" || _curAnim.name == "midHoriz" || _curAnim.name == "rightHoriz")
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
		
		public function turnOff() : void
		{
			if (_curAnim.name == "lowerVert" || _curAnim.name == "midVert" || _curAnim.name == "upperVert" ||
				_curAnim.name == "leftHoriz" || _curAnim.name == "midHoriz" || _curAnim.name == "rightHoriz")
				{
					exists = false;
				}
		}
		
	}
}