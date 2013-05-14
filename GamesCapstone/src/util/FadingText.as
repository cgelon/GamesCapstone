package util
{
	import org.flixel.FlxText;
	/**
	 * Text that fades in and out.
	 * @author cgelon
	 */
	public class FadingText extends FlxText
	{
		/** True if the text is currently fading, false otherwise. */
		private var m_fading : Boolean;
		
		/**
		 * Creates a new <code>FlxText</code> object at the specified position.
		 * 
		 * @param	a_x				The X position of the text.
		 * @param	a_y				The Y position of the text.
		 * @param	a_width			The width of the text object (height is determined automatically).
		 * @param	a_text			The actual text you would like to display initially.
		 * @param	a_embeddedFont	Whether this text field uses embedded fonts or nto
		 */
		public function FadingText( a_x : Number, a_y : Number, a_width : uint, a_text : String = null, a_embeddedFont : Boolean = true)
		{
			super( a_x, a_y, a_width, a_text, a_embeddedFont );
		}
		
		override public function update() : void
		{
			super.update();
			
			alpha += m_fading ? -0.02 : 0.02;
			if ( alpha <= 0 )
			{
				m_fading = false;
			}
			else if ( alpha >= 1 )
			{
				m_fading = true;
			}
		}
	}
}