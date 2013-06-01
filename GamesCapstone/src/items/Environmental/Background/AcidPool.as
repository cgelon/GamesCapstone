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
		private const baseVelocity: Number = -20;
		private var maxheight: Number;
		public var velocity: Number;
		
		public function AcidPool(X: Number = 0, Y: Number = 0, width: Number = 18 * 16, maxheight: Number = 18 * 16) 
		{
			super(X, Y + 16);
			this.started = false;
			this.width = width;
			this.maxheight = maxheight;
			this.velocity = 0;
			//FlxG.watch(this, "velocity");
		}
		
		public function addAcid(X:Number, Y:Number)  : void
		{
			var acid : Acid = recycle( Acid ) as Acid;
			acid.initialize(X, Y);
			add(acid);
			acid.alpha = 0.85;
			acid.playStart();
		}
		
		override public function update() : void
		{
			super.update();
			if (started) {
				if (members[0].y <= maxheight)
				{
					setVelocity(0);
				}
				else
				{
					var acidDist: Number = (FlxG.camera.height - members[0].getScreenXY().y);
					acidDist = (acidDist < 0) ? acidDist : 0;
					setVelocity(baseVelocity + -Math.pow(1.2, -acidDist));
				}
			}
		}
		
		public function start() : void
		{
			if (!started) {
				started = true;
				var block: AcidBlock = new AcidBlock(x, y, width);
				add(block);
				for (var i: int = 0; i < width; i = i+16)
				{
					addAcid(x + i, y - (16));
				}
				setVelocity(baseVelocity);
			}
		}
		
		private function setVelocity(velocity: Number) : void
		{
			this.velocity = velocity;
			for (var i:int = 0; i < length; i++)
			{
				if (members[i] != null)
				{
					members[i].velocity.y = velocity;
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