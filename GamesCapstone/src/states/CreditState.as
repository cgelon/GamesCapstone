package states 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import util.Color;
	import util.FadingText;
	
	/**
	 * Added a credits screen!
	 * 
	 * @author Chris Gelon
	 */
	public class CreditState extends FlxState 
	{
		private var _reset : Boolean;
		
		public function CreditState() 
		{
			createSuperTitleText("THE TEAM", -10);
			
			// Lydia Duncan
			createTitleText("Lydia Duncan", 20);
			createSubText("Environmental Coder", 40);
			createSubText("Level Designer", 50);
			
			// Chris Gelon
			createTitleText("Chris Gelon", 70);
			createSubText("Systems Coder", 90);
			createSubText("Music Designer", 100);
			createSubText("Sound Designer", 110);
			createSubText("Environmental Spriter", 120);
			
			// Rowan Hale
			createTitleText("Rowan Hale", 140);
			createSubText("Combat Coder", 160);
			createSubText("Enemy Coder", 170);
			
			// Michael Zhou
			createTitleText("Michael Zhou", 190);
			createSubText("Enemy Coder", 210);
			createSubText("Environmental Coder", 220);
			createSubText("Level Designer", 230);
			
			// Michael Gelon
			createTitleText("Special Guest: Michael Gelon", 250);
			createSubText("Character and Enemy Spriter", 270);
			createSubText("Environmental Spriter", 280);
			
			var fadingText : FadingText = new FadingText(0, 220, FlxG.width, "Press [ENTER] for main menu!", true);
			fadingText.setFormat(null, 8, Color.WHITE, "center");
			add(fadingText);
			
			_reset = false;
		}
		
		override public function update():void 
		{
			super.update();
			
			var done : Boolean = true;
			for each(var basic : FlxObject in members)
			{
				if (basic != null && !(basic is FadingText) && basic.onScreen())
				{
					done = false;
				}
			}
			if (!_reset && (done || FlxG.keys.justPressed("ENTER")))
			{
				if (FlxG.music != null)
				{
					FlxG.music.fadeOut(1);
				}
				FlxG.fade(Color.BLACK, 1, function() : void
				{
					FlxG.switchState(new MainMenuState());
				});
				_reset = true;
			}
		}
		
		private function createSuperTitleText(s : String, y : Number) : void
		{
			var text : FlxText = new FlxText(0, y + FlxG.height, FlxG.width, s);
			text.setFormat(null, 16, Color.ORANGE, "center", Color.DARK_GRAY);
			text.moves = true;
			text.velocity.y = -30;
			add(text);
		}
		private function createTitleText(s : String, y : Number) : void
		{
			var text : FlxText = new FlxText(0, y + FlxG.height, FlxG.width, s);
			text.setFormat(null, 16, Color.BLUE, "center", Color.DARK_GRAY);
			text.moves = true;
			text.velocity.y = -30;
			add(text);
		}
		private function createSubText(s : String, y : Number = 0) : void
		{
			var text : FlxText = new FlxText(0, y + FlxG.height, FlxG.width, s);
			text.setFormat(null, 8, Color.WHITE, "center", Color.DARK_GRAY);
			text.moves = true;
			text.velocity.y = -30;
			add(text);
		}
	}
}