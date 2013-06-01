package items.Environmental.Background 
{
	import items.Environmental.Background.*;
	import managers.*;
	import org.flixel.*;
	import states.*;
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidPool extends BackgroundGroup implements BackgroundInterface
	{
		private var started: Boolean;
		private var width: Number;
		
		public function AcidPool(X: Number = 0, Y: Number = 0, width: Number = 18 * 16) 
		{
			super(X, Y + 16);
			this.started = false;
			this.width = width;
		}
		
		public function addAcid(X:Number, Y:Number)  : void
		{
			var acid : Acid = recycle( Acid ) as Acid;
			acid.initialize(X, Y);
			add(acid);
			acid.velocity.y = -30;
			acid.playStart();
		}
		
		public function start() : void
		{
			if (!started) {
				started = true;
				add(new AcidBlock(x, y, width));
				for (var i: int = 0; i < width; i = i+16)
				{
					addAcid(x + i, y - (16));
				}
			}
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class): Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
	}
}