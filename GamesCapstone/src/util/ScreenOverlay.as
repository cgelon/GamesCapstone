package util
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class ScreenOverlay extends FlxGroup 
	{
		private var _screen : FlxSprite;
		private var _text : FlxText;
		
		public function ScreenOverlay() 
		{
			super();
			_screen = new FlxSprite();
			_screen.makeGraphic(FlxG.width, FlxG.height, Color.BLACK);
			_screen.alpha = 0;
			_screen.scrollFactor = new FlxPoint();
			
			_text = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "Thanks for playing!", true);
			_text.setFormat(null, 24, Color.WHITE, "center", Color.DARK_GRAY);
			_text.alpha = 0;
			_text.scrollFactor = new FlxPoint();
			
			add(_screen);
			add(_text);
		}
		
		override public function update():void 
		{
			super.update();
			_screen.alpha += 0.015;
			_text.alpha += 0.015;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_screen = null;
			_text = null;
		}
	}
}