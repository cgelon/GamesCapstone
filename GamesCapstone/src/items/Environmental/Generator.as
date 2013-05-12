package items.Environmental
{
	import items.Environmental.Background.BackgroundInterface;
	import items.Environmental.Background.Circuit.Trigger;
	import managers.BackgroundManager;
	import managers.ObjectManager;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.system.FlxAnim;
	import people.Actor;
	import states.GameState;
	import states.State;

	/**
	 * @author Lydia Duncan
	 */
	public class Generator extends Trigger implements BackgroundInterface
	{
		[Embed(source = '../../../assets/Generator.png')] private var generator: Class;
		public var isDestroyed: Boolean;
		
		function Generator(X:Number = 0, Y:Number = 0) : void 
		{
			super("generator");
			initialize(X, Y);
			loadGraphic(generator, true, false, 64, 32, true);
			
			addAnimation("whir", [0, 1], 5, true);
			
			immovable = true;
			isDestroyed = false;
			playStart();
		}
		
		public function playStart() : void
		{
			play("whir");
		}
		
		override public function update():void 
		{
			if (isDestroyed)
			{
				disable();
			}
			isDestroyed = false;
			super.update();
		}
		
		override public function enable() : void {
			
			super.enable();
		}
		
		override public function disable() : void {
			var anim : FlxAnim = getAnimation("whir");
			anim.looped = false;
			super.disable();
		}
	}	
}