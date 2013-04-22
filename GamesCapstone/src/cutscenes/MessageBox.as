package cutscenes 
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
	
	/**
	 * Represents a message box for text to be displayed in a box.
	 * 
	 * @author Chris Gelon
	 */
	public class MessageBox extends FlxGroup
	{
		/** The FlxTexts that will display the lines. */
		private var _textLines : Array;
		/** The box behind the text. */
		private var _box : FlxSprite;
		
		/** The amount of time in seconds before each letter is displayed. **/
		private var _displaySpeed : Number;
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
		
		/** The font used for the text. */
		private var _font : String;
		/** The size of the font. */
		private var _size : Number;
		/** The color of the text. */
		private var _color : uint;
		/** The number of lines to be displayed at a time. */
		private var _numLines : int;
		/** The width of message box. */
		private var _width : uint;
		/** The x position of the message box. */
		private var _x : Number;
		/** The y position of the message box. */
		private var _y : Number;
		
		/** The function to call when the text is done being displayed. */
		private var _callback : Function;
		
		public function MessageBox()
		{
			// Set up the box graphic.
			_box = new FlxSprite(0, 0);
			_box.scrollFactor = new FlxPoint(0, 0);
			add(_box);
			
			// Set up the lines, and the format!
			_x = 0;
			_y = 120;
			setFormat();
			
			// Set up the timer for displaying the text.
			_timer = new FlxTimer();
		}
		
		/**
		 * Sets the format for the text.
		 * @param	font	The font to be displayed.
		 * @param	size	The size of the font.
		 * @param	color	The color of the text.
		 * @param	width	The width of the message box.
		 * @param	numLines	The number of lines to be displayed at one time.
		 */
		public function setFormat(font : String = null, size : Number = 16, color : uint = 0xFFFFFFFF, width : uint = 320, numLines : int = 4) : void
		{
			_font = font;
			_size = size;
			_color = color;
			_width = width;
			_numLines = numLines;
			
			recreateLines();
		}
		
		/**
		 * Sets the position of the message box to the specified x and y coordinates.
		 */
		public function setPosition(x : Number = 0, y : Number = 120) : void
		{
			_x = x;
			_y = y;
			
			recreateLines();
		}
		
		/**
		 * Recreates the textbox for each line, in addition to the box surrounding the text.
		 */
		private function recreateLines() : void
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
			dummyText.setFormat(_font, _size, _color, "left");
			// Create the new lines of text!
			for (var i : int = 0; i < _numLines; i++)
			{
				var text : FlxText = new FlxText(_x, _y + i * (dummyText.height - 4), _width, "", true);
				text.setFormat(_font, _size, _color, "left");
				text.scrollFactor = new FlxPoint(0, 0);
				_textLines.push(text);
				add(text);
			}
			
			// Draw the box around the text.
			_box.makeGraphic(_width, (_numLines) * (dummyText.height - 4) + 4, Color.GRAY, true);
			_box.x = _x;
			_box.y = _y;
			FlxG.clearBitmapCache();
		}
		
		/**
		 * Starts displaying the text!
		 * @param	text	The text to display.
		 * @param	callback	The function to be called after the text is done being displayed.
		 * @param	displaySpeed	The amount of time, in seconds, to wait before displaying the next letter.
		 */
		public function displayText(text : String, callback : Function = null, displaySpeed : Number = 0.01) : void
		{
			_lines = divideText(text);
			_lineIndex = 0;
			_startLineIndex = 0;
			_timer.start(displaySpeed, 0, display);
			_callback = callback;
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
			dummyText.setFormat(_font, _size, _color, "left");
			
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
			return lines;
		}
		
		/**
		 * Callback function for when we want to display the next letter in the text.
		 */
		private function display(timer : FlxTimer) : void
		{
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
				}
				else if (_lineIndex - _startLineIndex == _numLines)
				{
					// If there are already four lines being displayed, wait for user input, 
					// then refresh.
					_startLineIndex = _lineIndex;
					_timer.pause();
				}
			}
		}
		
		override public function update() : void 
		{
			super.update();
			if (FlxG.keys.justPressed("SPACE"))
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
			
			_displaySpeed = 0;
			_timer.destroy();
			_timer = null;
			_currentIndex = 0;
			
			for each (var line : String in _lines)
			{
				line = null;
			}
			_lines.length = 0;
			_lines = null;
			_lineIndex = 0;
			_startLineIndex = 0;
			
			_font = null;
			_size = 0;
			_color = 0;
			_numLines = 0;
			_width = 0;
			_x = 0;
			_y = 0;
			
			_callback = null;
		}
	}
}