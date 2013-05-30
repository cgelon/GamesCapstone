package cutscenes.engine 
{
	import flash.text.Font;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxTimer;
	import util.Color;
	import util.Sounds;
	
	/**
	 * Represents a message box for text to be displayed in a box.
	 * 
	 * @author Chris Gelon
	 */
	public class MessageBox extends FlxGroup
	{
		/** The font to be displayed. */
		private static const FONT : String = null;
		/** The size of the font to be displayed. */
		private static const FONT_SIZE : Number = 8;
		
		/** The FlxTexts that will display the lines. */
		private var _textLines : Array;
		/** The FlxText that displays the name. */
		private var _nameTextLine : FlxText;
		/** The box behind the text. */
		private var _box : FlxSprite;
		
		/** The timer that is used to display text at a certain speed. */
		private var _timer : FlxTimer;
		/** The text is displayed up to the current index. */
		private var _currentIndex : int;
		
		/** The lines, in strings, to be displayed. */
		private var _lines : Array;
		/** The current line that is being displayed. */
		private var _lineIndex : int;
		/** The line index that is the start of this current set of lines. */
		private var _startLineIndex : int;
		
		/** The color of the text. */
		private var _color : uint;
		/** The color of the name. */
		private var _nameColor : uint;
		/** The alignment of the name in the message box. */
		private var _nameAlignment : String;
		/** The number of lines to be displayed at a time. */
		private var _numLines : int;
		/** The width of message box. */
		private var _width : uint;
		/** The x position of the message box. */
		private var _x : Number;
		/** The y position of the message box. */
		private var _y : Number;
		
		/** True if the box will automatically close when displayed, false otherwise. */
		private var _auto : Boolean;
		/** The amount of time, in seconds, before the box closes. */
		private var _autoCloseTime : Number;
		/** The timer for automatically closing the message box. */
		private var _autoTimer : FlxTimer;
		
		/** True if space has been released since the last press, false otherwise. */
		private static var _spaceReleased : Boolean;
		
		/** The function to call when the text is done being displayed. */
		private var _callback : Function;
		
		/**
		 * Creates a one-time use message box with the specified attributes.
		 * @param	x	Where the left-side of the textbox should go.
		 * @param	y	Where the upper-side of the textbox should go.
		 * @param	width	The width of the message box.
		 * @param	color	The color of the text.
		 * @param	nameColor	The color of the name.
		 * @param	numLines	The number of lines to be displayed at one time.
		 * @param	nameAlignment	Where the name is aligned in the message box.
		 */
		public function MessageBox(x : Number = 0, y : Number = 120, width : uint = 160, color : uint = Color.WHITE, nameColor : uint = Color.BLUE, numLines : int = 3, nameAlignment : String = "left")
		{
			// Set up the box graphic.
			_box = new FlxSprite(0, 0);
			_box.scrollFactor = new FlxPoint(0, 0);
			add(_box);
			
			// Set up the lines, and the format!
			_x = x;
			_y = y;
			_color = color;
			_nameColor = nameColor;
			_width = width;
			_numLines = numLines;
			_nameAlignment = nameAlignment;
			createLines();
			
			// Set up the timers.
			_timer = new FlxTimer();
			_autoTimer = new FlxTimer();
			
			_spaceReleased = false;
		}
		
		public static function getHeight(numLines : int = 3) : Number 
		{
			var dummyText : FlxText = new FlxText(0, 0, 320, " ", true);
			dummyText.setFormat(FONT, FONT_SIZE);
			var height : Number = dummyText.height * (numLines + 1);
			dummyText.destroy();
			return height;
		}
		
		/**
		 * Creates the textbox for each line, in addition to the box surrounding the text.
		 */
		private function createLines() : void
		{
			// Get rid of the old text lines if there were any.
			for each(var textLine : FlxText in _textLines)
			{
				remove(textLine, true);
				textLine.destroy();
			}
			_textLines = new Array();
			
			// Create a dummy text to gauge where the other texts should be.
			var dummyText : FlxText = new FlxText(0, 0, _width, " ", true);
			dummyText.setFormat(FONT, FONT_SIZE, _color, "left", Color.BLACK);
			
			// Create the name text.
			if (_nameTextLine != null)
			{
				remove(_nameTextLine, true);
				_nameTextLine.destroy();
			}
			_nameTextLine = new FlxText(_x, _y, _width, "", true);
			_nameTextLine.setFormat(FONT, FONT_SIZE, _nameColor, _nameAlignment, Color.BLACK);
			_nameTextLine.scrollFactor = new FlxPoint(0, 0);
			add(_nameTextLine);
			
			// Create the new lines of text!
			for (var i : int = 0; i < _numLines; i++)
			{
				var text : FlxText = new FlxText(_x, _y + (i + 1) * (dummyText.height - 4), _width, "", true);
				text.setFormat(FONT, FONT_SIZE, _color, "left", Color.BLACK);
				text.scrollFactor = new FlxPoint(0, 0);
				_textLines.push(text);
				add(text);
			}
			
			// Draw the box around the text.
			_box.makeGraphic(_width, (_numLines + 1) * (dummyText.height - 4) + 4, Color.DARK_GRAY, true);
			_box.x = _x;
			_box.y = _y;
			
			dummyText.destroy();
			FlxG.clearBitmapCache();
		}
		
		/**
		 * Starts displaying the text!
		 * @param	name	The name of the person talking.
		 * @param	text	The text to display.
		 * @param	callback	The function to be called after the text is done being displayed.
		 * @param	displaySpeed	The amount of time, in seconds, to wait before displaying the next letter.
		 * @param	auto	If true, the message box will automatically close after a determined time. Player cannot advance text quickly either.
		 * @param	autoCloseTime	The amount of time, in seconds, after the message is fully displayed to close the box.
		 */
		public function displayText(name : String, text : String, callback : Function = null, 
				displaySpeed : Number = 0.01, auto : Boolean = false, autoCloseTime : Number = 2) : void
		{
			_lines = divideText(text);
			_lineIndex = 0;
			_startLineIndex = 0;
			_timer.start(displaySpeed, 0, display);
			_nameTextLine.text = name;
			_callback = callback;
			_auto = auto;
			_autoCloseTime = autoCloseTime;
		}
		
		/**
		 * Divide the text into an array of strings.  Each string is one line of dialogue.
		 * @param	text	The text to divide.
		 * @return	An array of strings, each string being one line of dialogue.
		 */
		private function divideText(text : String) : Array
		{
			var counter : int = 0;
			var start : int = 0;
			var lines : Array = new Array();
			var dummyText : FlxText = new FlxText(0, 0, _width, "", true);
			dummyText.setFormat(FONT, FONT_SIZE, _color, "left");
			
			// Go through the enter text.
			while (counter < text.length)
			{
				dummyText.text = text.substring(start, counter);
				// Once the text goes to more than one line, figure out where the last word is.
				if (dummyText.numLines > 1)
				{
					var lastSpace : int = text.lastIndexOf(" ", counter - 1);
					// Add the line to the array, and then reset the start and counter.
					lines.push(text.substring(start, lastSpace));
					start = lastSpace + 1;
					counter = start;
				}
				counter++;
			}
			// Push the last line to the array.
			lines.push(text.substring(start, text.length));
			
			dummyText.destroy();
			return lines;
		}
		
		/**
		 * Callback function for when we want to display the next letter in the text.
		 */
		private function display(timer : FlxTimer) : void
		{
			FlxG.play(Sounds.MESSAGE_BOX_LETTER, 0.25);
			_currentIndex++;
			_textLines[_lineIndex - _startLineIndex].text = _lines[_lineIndex].substring(0, _currentIndex);
			// Check to see if a line is done.
			if (_currentIndex == (_lines[_lineIndex] as String).length)
			{
				// If it is, go to the next line.
				_currentIndex = 0;
				_lineIndex++;
				if (_lineIndex == _lines.length)
				{
					// Stop the timer if there are no more lines.
					_timer.stop();
					if (_auto)
					{
						_autoTimer.start(_autoCloseTime, 1, autoClose);
					}
				}
				else if (_lineIndex - _startLineIndex == _numLines)
				{
					// If there are already the max number of lines being displayed, wait for user input, 
					// then refresh.
					_startLineIndex = _lineIndex;
					_timer.pause();
					if (_auto)
					{
						_autoTimer.start(_autoCloseTime, 1, autoClose);
					}
				}
			}
		}
		
		/**
		 * Callback function for when we want to automatically want to close a message box.
		 */
		private function autoClose(timer : FlxTimer) : void
		{
			lineAdvancement();
		}
		
		override public function update() : void 
		{
			super.update();
			if (!FlxG.keys.pressed("SPACE"))
			{
				_spaceReleased = true;
			}
			if (FlxG.keys.pressed("SPACE") && _spaceReleased && !_auto)
			{
				lineAdvancement();
				_spaceReleased = false;
			}
		}
		
		/**
		 * Contains logic for when their needs to be a new set of lines.
		 */
		private function lineAdvancement() : void
		{
			if (_timer.finished)
			{
				// If the timer is finished, then the message shouldn't exist anymore.
				kill();
				if (_callback != null)
				{
					_callback();
				}
			}
			else if (_timer.paused)
			{
				// If the timer is paused, then advance to the next set of lines.
				for each (var line : FlxText in _textLines)
				{
					line.text = "";
				}
				_timer.start();
			}
			else
			{
				// If the player presses space during the text being displayed,
				// automatically display the text.
				for (var i : int = 0; i < _numLines; i++)
				{
					if (_startLineIndex + i < _lines.length)
					{
						(_textLines[i] as FlxText).text = _lines[_startLineIndex + i];
					}
				}
				// Advance the line indexes, and then check to see if we should 
				// stop the timer or just pause it.
				_startLineIndex += _numLines;
				_lineIndex = _startLineIndex;
				_currentIndex = 0;
				if (_lineIndex >= _lines.length)
				{
					_timer.stop();
				}
				else
				{
					_timer.pause();
				}
			}
		}
		
		public function get width() : Number
		{
			return (_textLines[0] as FlxText).width;
		}
		
		public function get height() : Number
		{
			return (_textLines[0] as FlxText).height * (_numLines + 1);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			// The FlxTexts and FlxSprite are already destroyed because 
			// they are part of the MessageBox FlxGroup (they were being 
			// displayed).
			_textLines.length = 0;
			_textLines = null;
			_box = null;
			
			_timer.destroy();
			_timer = null;
			
			for each (var line : String in _lines)
			{
				line = null;
			}
			_lines.length = 0;
			_lines = null;
			_lineIndex = 0;
			_startLineIndex = 0;
			
			_nameAlignment = null;
			
			_callback = null;
			
			_auto = false;
			_autoTimer.destroy();
			_autoTimer = null;
		}
	}
}