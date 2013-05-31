package util
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * An overlay used for when the game is paused.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class PauseOverlay extends FlxGroup 
	{
		private var _screen : FlxSprite;
		private var _text : FlxText;
		
		public function PauseOverlay() 
		{
			super();
			_screen = new FlxSprite();
			_screen.makeGraphic(FlxG.width, FlxG.height, Color.BLACK);
			_screen.alpha = 0.6;
			_screen.scrollFactor = new FlxPoint();
			
			_text = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "Paused", true);
			_text.setFormat(null, 24, Color.BLUE, "center", Color.BLACK);
			_text.scrollFactor = new FlxPoint();
			
			add(_screen);
			add(_text);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_screen = null;
			_text = null;
		}
	}
}