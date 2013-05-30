package util 
{
	import mx.core.FlexApplicationBootstrap;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * The learning blocks are used to demonstrate what button needs to be pressed when learning 
	 * a new action.
	 * 
	 * @author Chris Gelon
	 */
	public class LearningBlock extends FlxSprite 
	{
		/** Controls how quickly the block changes colors. */
		private static const MULTIPLIER : uint = 16;
		
		public static const W : int = 0;
		public static const A : int = 1;
		public static const S : int = 2;
		public static const D : int = 3;
		public static const J : int = 4;
		public static const K : int = 5;
		public static const L : int = 6;
		
		/** The PNG for W. */
		[Embed(source = '../../assets/letters/W.png')] private static var wPNG : Class;
		/** The PNG for A. */
		[Embed(source = '../../assets/letters/A.png')] private static var aPNG : Class;
		/** The PNG for S. */
		[Embed(source = '../../assets/letters/S.png')] private static var sPNG : Class;
		/** The PNG for D. */
		[Embed(source = '../../assets/letters/D.png')] private static var dPNG : Class;
		
		/** The PNG for J. */
		[Embed(source = '../../assets/letters/J.png')] private static var jPNG : Class;
		/** The PNG for K. */
		[Embed(source = '../../assets/letters/K.png')] private static var kPNG : Class;
		/** The PNG for L. */
		[Embed(source = '../../assets/letters/L.png')] private static var lPNG : Class;
		
		/** True if the player has executed this block, false otherwise. */
		public var completed : Boolean;
		
		/** True if we are increasing the color of the block, false otherwise. */
		private var increasingColor : Boolean;
		
		/** The target to follow. */
		private var _target : FlxSprite;
		
		/** The offset from the target that this block will be placed. */
		private var _offset : FlxPoint;
		
		public function LearningBlock(target : FlxSprite, offset : FlxPoint, type : int) 
		{
			super();
			
			switch(type)
			{
				case W:
					loadGraphic(wPNG);
					break;
				case A:
					loadGraphic(aPNG);
					break;
				case S:
					loadGraphic(sPNG);
					break;
				case D:
					loadGraphic(dPNG);
					break;
				case J:
					loadGraphic(jPNG);
					break;
				case K:
					loadGraphic(kPNG);
					break;
				case L:
					loadGraphic(lPNG);
					break;
			}
			
			increasingColor = false;
			
			_target = target;
			_offset = offset;
			
			allowCollisions = FlxObject.NONE;
		}
		
		override public function update():void 
		{
			super.update();
			
			x = _target.x + _offset.x;
			y = _target.y + _offset.y;
			
			if (increasingColor)
			{
				if ((color & 0x0000FF) != 0x0000FF)
				{
					color = Math.min(color + 0x000001 * MULTIPLIER, 0x0000FF);
				}
				else if ((color & 0x00FF00) != 0x00FF00)
				{
					color = Math.min(color + 0x000100 * MULTIPLIER, 0x00FFFF);
				}
				else if ((color & 0xFF0000) != 0xFF0000)
				{
					color = Math.min(color + 0x010000 * MULTIPLIER, 0xFFFFFF);
				}
				else
				{
					increasingColor = false;
				}
			}
			else
			{
				if ((color & 0x0000FF) != 0x000000)
				{
					color = Math.max(color - 0x000001 * MULTIPLIER, 0xFFFF00);
				}
				else if ((color & 0x00FF00) != 0x000000)
				{
					color = Math.max(color - 0x000100 * MULTIPLIER, 0xFF0000);
				}
				else if ((color & 0xFF0000) != 0xAA0000)
				{
					color = Math.max(color - 0x010000 * MULTIPLIER, 0xAA0000);
				}
				else
				{
					increasingColor = true;
				}
			}
		}
		
		/**
		 * Complete this learning block, making it slightly transparent to show the player has done it.
		 */
		public function complete() : void
		{
			if (!completed)
			{
				FlxG.play(Sounds.MAIN_MENU_LONG, 0.5);
				completed = true;
				alpha = 0.5;
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_target = null;
			_offset = null;
		}
	}
}