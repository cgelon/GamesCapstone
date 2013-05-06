package people 
{
	import flash.utils.Dictionary;
	import managers.Manager;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.system.FlxAnim;
	import states.GameState;
	
	/**
	 * Base class for all people in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class Actor extends FlxSprite 
	{
		private var _maxHealth : Number; // The maximum possible health of the actor.
		public function get maxHealth() : Number { return _maxHealth; }
		
		/**
		 * The current state of the actor.
		 */
		public var state : ActorState;
		
		// The previous state of the actor.
		private var _prevState : ActorState;
		
		// Keeps track of the frame number in the current state.
		private var _currentStateFrame : uint;
		public function get currentStateFrame() : uint { return _currentStateFrame; }

		// The frame that the current animation or animation sequence was started at.
		private var _animationStartFrame : int;
		
		// Array of names of the current animations in the current animation sequence.
		private var _currentAnimationSequence : Array;
		
		/** 
		 * A mapping from ActorState to PeriodicSound, which is used to play a periodic sound 
		 * whenever an actor is in a certain state.
		 */
		private var _periodicSounds : Dictionary;
		
		public function Actor() : void
		{
			_periodicSounds = new Dictionary();
		}
		
		/**
		 * Initialize the actor, readying it to enter the game world.
		 * @param	x	The x coordinate to start the actor at.
		 * @param	y	The y coordinate to start the actor at.
		 */
		public function initialize(x : Number, y : Number, actorHealth : Number = 5) : void
		{
			this.x = x;
			this.y = y;
			
			health = actorHealth
			_maxHealth = actorHealth;
			
			_currentStateFrame = 1;
			_animationStartFrame = -1; // Make sure that this number is invalid to begin, since we haven't started playing animations.
		}
		
		override public function update() : void
		{
			super.update();
			
			_currentStateFrame++;
			
			// Reset the current state frame number if we changed states.
			if (state != _prevState)
			{
				for (var s : Object in _periodicSounds)
				{
					if (s == state)
					{
						(_periodicSounds[s] as PeriodicSound).play();
					}
					else
					{
						(_periodicSounds[s] as PeriodicSound).stop();
					}
				}
				_currentStateFrame = 1;
				_prevState = state;
				_currentAnimationSequence = null;
			}
		}
		
		public function touchedAcid(): void
		{
			_prevState = state;
			state = ActorState.DEAD;
			health = 0;
			velocity.x = 0;
			acceleration.x = 0;
		}
		
		/**
		 * Play the given animation once, even if this function is called more than
		 * once. This property holds as long as no other animation is played.
		 * 
		 * @param 	name	The name of the animation to play.
		 */
		public function PlayOnce(name : String) : void
		{
			if (_curAnim == null || name != _curAnim.name)
			{
				play(name);
			}
		}
		
		/**
		 * Plays the list of animations in sequence, once each.
		 * Looping animations have their looping ignored unless
		 * it is the last animation in the sequence. Animation 
		 * sequence is broken if state is changed.
		 * 
		 * @param	names	An array of names of animations to play.
		 */
		public function PlaySequence(names : Array) : void
		{
			var sameSequence : Boolean = false; // Are we contiuing playing the same sequence?
			if (_currentAnimationSequence == null)
			{
				sameSequence = false;
			}
			else if (_currentAnimationSequence.length != names.length)
			{
				sameSequence = false;
			}
			else
			{
				// If any of the names don't match, it's not the same sequence.
				// If they all match, then it's the same sequence.
				for (var i : int = 0; i < names.length; ++i)
				{
					if (names[i] != _currentAnimationSequence[i])
					{
						sameSequence = false;
						break;
					}
				}
				sameSequence = true;
			}
			
			if (!sameSequence)
			{
				_currentAnimationSequence = names;
				
				_animationStartFrame = _currentStateFrame;
				PlayOnce(names[0]);
			}
			else
			{
				var animFrame : uint = _currentStateFrame - _animationStartFrame;
				var frameSum : uint = 0; // Keep track of sum of frames in animations that we've looped over.
				
				// Loop over the animations in this animation sequence, looking for any animation
				// that needs to be played starting at this frame. If we find one, play it.
				for each (var animName : String in names)
				{
					var anim : FlxAnim = getAnimation(animName);
					
					if (anim == null)
						FlxG.log("ERROR: Invalid animation name: " + animName);
					
					// If we found an animation ew need to play, play it.
					// Otherwise keep looking.
					if (animFrame == frameSum)
					{
						PlayOnce(animName);
						break;
					}
					else
					{
						frameSum += anim.frames.length * (FlxG.framerate * anim.delay);
					}
				}
			}	
		}
		
		/**
		 * Hurt the actor for the given amount of damage. 
		 * If health down to 0, the player dies.
		 * 
		 * @param	damage	The amount of damage to deal.
		 */
		override public function hurt(damage : Number) : void
		{
			health = health - damage;
			if (health <= 0)
				state = ActorState.DEAD;
			else
				state = ActorState.HURT;
		}
		
		/**
		 * Associates a periodic sound with a state.  Whenever the actor is in that state, the 
		 * sound will play.
		 * 
		 * @param	sound	The periodic sound to associate a state with.
		 * @param	state	The state to trigger this sound in.
		 */
		public function associatePeriodicSound(sound : PeriodicSound, state : ActorState) : void
		{
			_periodicSounds[state] = sound;
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class) : Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			state = null;
		}
	}
}