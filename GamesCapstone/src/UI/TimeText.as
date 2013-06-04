package UI 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import util.Color;
	
	/**
	 * UI element for speed running time.
	 * 
	 * @author Chris Gelon
	 */
	public class TimeText extends FlxGroup 
	{
		private var _text : FlxText;
		
		public function TimeText() 
		{
			var backing : FlxSprite = new FlxSprite(95, 2);
			backing.makeGraphic(50, 10, Color.DARK_GRAY, true);
			backing.scrollFactor.x = backing.scrollFactor.y = 0;
			add(backing);
			
			_text = new FlxText(100, 0, 220, "", true);
			_text.setFormat(null, 8, Color.WHITE, "left", Color.GRAY);
			_text.scrollFactor.x = _text.scrollFactor.y = 0;
			add(_text);
		}
		
		override public function update() : void
		{
			super.update();
			
			var minutes : uint = Registry.getInstance().time / 60;
			var seconds : uint = Registry.getInstance().time % 60;
			var milliseconds : uint = (Registry.getInstance().time * 100) % 100;
			_text.text = minutes + ":" + ((seconds < 10) ? "0" : "") + seconds + ":" + (milliseconds < 10 ? "0" : "") + milliseconds;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_text = null;
		}
	}
}