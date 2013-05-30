package people 
{
	import flash.utils.Dictionary;
	import managers.Manager;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.system.FlxAnim;
	import people.states.ActorAction;
	import people.states.ActorState;
	import people.states.ActorStateGroup;
	import states.GameState;
	
	/**
	 * Base class for all people in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class Actor extends FlxSprite 
	{
		/** The maximum possible health of this actor. */
		private var _maxHealth : Number;
		/** The maximum possible health of this actor. */
		public function get maxHealth() : Number { return _maxHealth; }
		
		/** The current state of the actor. */
		public var state : ActorState;
		/** The previous state of the actor. */
		public var prevState : ActorState;
		/** The last action this actor took. */
		public var lastAction : ActorAction;
		/** The index of the last action this actor took. */
		public var lastActionIndex : int;
		
		/** True if the actor is on the ground, false otherwise. */
		public function get onGround() : Boolean
		{
			return isTouching(FlxObject.FLOOR);
		}
		
		/**
		 * The amount of frames this actor has been in the same state.
		 */
		protected var currentStateFrame : int;
		
		/** The animation that is currently playing. */
		private var _currentAnimation : Array;
		/** The index of a sequence of animations that are playing. */
		private var _currentAnimationIndex : uint;
		
		/** 
		 * A mapping from ActorState to PeriodicSound, which is used to play a periodic sound 
		 * whenever an actor is in a certain state.
		 */
		private var _periodicSoundsToState : Dictionary;
		/**
		 * A mapping from ActorState to Sound, which is used to play a sound whenever an actor 
		 * switches to a new state.
		 */
		private var _soundsToAction : Dictionary;
		
		/**
		 * A mapping from ActorAction to Array to Animation, which is used to play an animation 
		 * whenever an actor executes a new action.  Each action can have multiple animations 
		 * associated with it.
		 */
		private var _animationsToAction : Dictionary;
		
		protected var actionTimer : FlxTimer;
		
		/** Whether or not the player has been hit by acid this frame. */
		public var touchedAcidThisFrame : Boolean;
		
		private var _actorFlickerTimer : FlxTimer;
		private var _actorFlickerCount : int;
		private var _actorFlickerDuration : int;
		
		public function Actor() : void
		{
			_periodicSoundsToState = new Dictionary();
			_soundsToAction = new Dictionary();
			_animationsToAction = new Dictionary();
			actionTimer = new FlxTimer();
			
			_actorFlickerTimer = new FlxTimer();
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
			
			health = actorHealth;
			_maxHealth = actorHealth;
			currentStateFrame = 0;
			
			_actorFlickerDuration = 8;
		}
		
		override public function update():void 
		{
			super.update();
			currentStateFrame++;
			touchedAcidThisFrame = false;
			
			if (_actorFlickerTimer.running)
			{
				if (_actorFlickerCount % _actorFlickerDuration < _actorFlickerDuration / 2)
				{
					alpha = 0;
				}
				else
				{
					alpha = 1;
				}
				_actorFlickerCount++;
			}
		}
		
		
		public function flickerActor(duration : Number) : void
		{
			if (!_actorFlickerTimer.running)
			{
				_actorFlickerCount = 0;
				_actorFlickerTimer.start(duration, 1, function(timer : FlxTimer) : void {
					alpha = 1;
				});
			}
		}
		
		/**
		 * Associates a sound with a state.  Whenever the actor is in that state, the 
		 * sound will play.
		 * 
		 * @param	sound	The sound to associate a state with.
		 * @param	state	The state to trigger this sound in.
		 */
		public function associateSound(sound : SoundEffect, state : ActorAction) : void
		{
			_soundsToAction[state] = sound;
		}
		
		/**
		 * Associates a periodic sound with a state.  Whenever the actor is in that state, the 
		 * sound will play.
		 * 
		 * @param	sound	The periodic sound to associate a state with.
		 * @param	state	The state to trigger this sound.
		 */
		public function associatePeriodicSound(sound : PeriodicSound, state : ActorState) : void
		{
			_periodicSoundsToState[state] = sound;
		}
		
		/**
		 * Associates an animation with a state.  Whenever the actor is in that state, the 
		 * animation will play.  Each action can have several animations, which are displayed 
		 * based off of an index.
		 * 
		 * @param	names	The names of the animations strings to play.
		 * @param	state	The state to trigger this animation.
		 * @param	index	The index to associate this animation with inside of the action.
		 */
		public function associateAnimation(names : Array, state : ActorAction, index : uint = 0) : void
		{
			if (_animationsToAction[state] == null)
			{
				_animationsToAction[state] = new Array();
			}
			var animations : Array = _animationsToAction[state];
			_animationsToAction[state][index] = names;
		}
		
		/**
		 * Called when the state is changed.
		 */
		private function stateChange(oldState : ActorState, newState : ActorState) : void
		{
			// Stop the previous periodic sound, if there is one.
			if (_periodicSoundsToState[oldState] != null)
			{
				(_periodicSoundsToState[oldState] as PeriodicSound).stop();
			}
			// Start the new periodic sound, if there is one.
			if (_periodicSoundsToState[newState] != null)
			{
				(_periodicSoundsToState[newState] as PeriodicSound).play();
			}
			state = newState;
			currentStateFrame = 0;
		}
		
		/**
		 * Execute an action and change state if necessary.
		 * @param	action	The action to execute.
		 * @param	newState	The new state to move into, or null if the state isn't changing.
		 * @param	index	Specifies which animation to play for the specified action.
		 */
		public function executeAction(action : ActorAction, newState : ActorState = null, index : uint = 0) : void
		{
			// Play the sound associated with the action.
			if (_soundsToAction[action] != null)
			{
				(_soundsToAction[action] as SoundEffect).play();
			}
			// Play the animation associated with the action.
			if (_animationsToAction[action] != null)
			{
				playSequence(_animationsToAction[action][index]);
			}
			lastAction = action;
			lastActionIndex = index;
			
			// If we are transitioning to a new state, do so.
			if (newState != null && newState != state)
			{
				prevState = state;
				stateChange(state, newState);
			}
			
			// Stop the action timer if need be.
			actionTimer.stop();
		}
		
		/**
		 * Play a sequence of animations.
		 * @param	names	The names of the animations in the sequence.
		 */
		private function playSequence(names : Array) : void
		{
			_currentAnimation = names;
			_currentAnimationIndex = 0;
			playAnimation();
		}
		
		/**
		 * Play the animation based on the current animation sequence an index.
		 */
		private function playAnimation() : void
		{
			if (_currentAnimationIndex + 1 < _currentAnimation.length)
			{
				play(_currentAnimation[_currentAnimationIndex], false, playAnimation);
			}
			else
			{
				play(_currentAnimation[_currentAnimationIndex], false);
			}
			_currentAnimationIndex++;
		}
		
		/**
		 * Hurt the actor for the given amount of damage. 
		 * If health down to 0, the player dies.
		 * 
		 * @param	damage	The amount of damage to deal.
		 */
		override public function hurt(damage : Number) : void
		{
			dealDamage(damage);
			if (health > 0)
				executeAction(ActorAction.HURT, ActorState.HURT);
		}
		
		/**
		 * Deals damage to the actor.
		 * 
		 * @param	damage	The amount of damage to deal.
		 */
		public function dealDamage(damage : Number) : void
		{
			health -= damage;
			if (health <= 0)
				executeAction(ActorAction.DIE, ActorState.DEAD);
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
			lastAction = null;
			_currentAnimation = null;
			
			for (var state : Object in _periodicSoundsToState)
			{
				(_periodicSoundsToState[state] as PeriodicSound).destroy();
				delete _periodicSoundsToState[state];
			}
			_periodicSoundsToState = null;
			
			for (var soundAction : Object in _soundsToAction)
			{
				(_soundsToAction[soundAction] as SoundEffect).destroy();
				delete _soundsToAction[soundAction];
			}
			_soundsToAction = null;
			
			for (var animationAction : Object in _animationsToAction)
			{
				for each(var array : Object in _animationsToAction[animationAction])
				{
					(array as Array).length = 0;
				}
				(_animationsToAction[animationAction] as Array).length = 0;
				delete _animationsToAction[animationAction];
			}
			_animationsToAction = null;
			
			actionTimer.destroy();
			actionTimer = null;
		}
	}
}