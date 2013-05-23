package items.Environmental
{
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.BackgroundInterface;
	import items.Environmental.Background.Circuit.Trigger;
	import managers.BackgroundManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.system.FlxAnim;
	import states.GameState;

	/**
	 * @author Lydia Duncan
	 */
	public class Generator extends Trigger implements BackgroundInterface
	{
		[Embed(source = '../../../assets/Generator.png')] private var generator: Class;
		public var isDestroyed: Boolean;
		
		private static const DESTROYED_COLOR : uint = 0x444444;
		
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
				color = DESTROYED_COLOR;
				disable();
			}
			isDestroyed = false;
			killAcidOverlaps((FlxG.state as GameState).getManager(BackgroundManager) as BackgroundManager as FlxGroup);
			super.update();
		}
		
		public function killAcidOverlaps(objects: FlxGroup) : void
		{
			var acid : Array = [];
			for (var i: int = 0; i < objects.length ; i++) {
				if (objects.members[i] != null && objects.members[i] is AcidFlow 
					&& ((objects.members[i] as AcidFlow).overlaps(this)))
				{
					isDestroyed = true;
					return;
				}
			}	
			
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