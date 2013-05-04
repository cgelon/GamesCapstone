package UI.Bars 
{
	import flash.events.AccelerometerEvent;
	import org.flixel.plugin.photonstorm.FlxBar;
	import people.Actor;
	import UI.UIObject;
	import org.flixel.FlxG;
	import util.Color;
	import Math;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HealthBar extends FlxBar
	{	
		private var _framesSinceChange : int;
		private var _previousHealth : Number;
		private var _owner : Actor;
		private var _fadeBar : Boolean;
		
		
		/**
		 * Create a health bar that monitors the health attribute of the given actor.
		 * 
		 * @param	owner		The Actor that the health bar is monitoring.
		 * @param	x			The x-coordinate of the health bar. Ignored if onParent is true.
		 * @param	y			The y-coordinate of the health bar. Ignored if onParent is true.
		 * @param	width		The width of the health bar.
		 * @param	height		The height of the health bar.
		 * @param	onParent	Whether or not the health bar should be above the Actor in question. 
		 * 						If true, centers itself right on top of the Actor.
		 * @param 	faceBar		If true, makes the health bar fade when no there has been no change
		 * 						recently.
		 */
		public function HealthBar(owner : Actor, x : Number, y : Number, width : Number, height : Number, onParent : Boolean, fadeBar : Boolean) 
		{
			super(x, y, FlxBar.FILL_LEFT_TO_RIGHT, width, height, owner, "health", 0, owner.maxHealth, false);
			
			_owner = owner;
			_fadeBar = fadeBar;
			
			if (onParent)
			{
				trackParent((owner.width - width) / 2, -(height + 1));
			}
			else
			{
				scrollFactor.x = 0;
				scrollFactor.y = 0;
			}
				
			createFilledBar(0x7F510000, 0xFFF40000, true); 
			killOnEmpty = true;
			
			if (_fadeBar)
			{
				_framesSinceChange = -FlxG.framerate * 5; // Initially set _framesSinceChange to INFINITY
				_previousHealth = owner.health;
			}
		}
		
		override public function update() : void
		{
			super.update();
			
			if (_fadeBar)
			{
				if (_previousHealth != _owner.health)
				{
					_previousHealth = _owner.health;
					alpha = 1;
					_framesSinceChange = 0;
				}
				else if (_framesSinceChange > FlxG.framerate)
				{
					var fadeFrames : Number = _framesSinceChange - FlxG.framerate;
					alpha = Math.max(1 - (fadeFrames / FlxG.framerate), 0);
				}
				
				_framesSinceChange++;
			}
		}
		
	}

}