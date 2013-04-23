package UI.Bars 
{
	import flash.events.AccelerometerEvent;
	import people.Actor;
	import UI.UIObject;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HealthBar extends UIObject
	{
		// Who the health bar is for.
		private var _owner : Actor;
		
		private var _width : Number;
		private var _height : Number;
		
		public function HealthBar(owner : Actor, width : Number, height : Number) 
		{
			_owner = owner;
			_width = width;
			_height = height;
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
		}
		
		override public function update() : void
		{
			super.update();
			
			//FlxG.clearBitmapCache();
			
			
			makeGraphic(_width * (_owner._health / _owner._maxHealth), _height, Color.GREEN, true);
			
			for (var i : Number = 0; i < _owner._health; ++i)
			{
				drawLine((_width * (i / _owner._maxHealth)), 
						 0,
						 (_width * (i / _owner._maxHealth)), 
						 _height,
						 Color.BLACK);
			}
		}
		
	}

}