package items.Environmental.Background
{
	import managers.ObjectManager;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import people.Actor;
	import states.State;

	/**
	 * @author Lydia Duncan
	 */
	public class Lever extends BackgroundItem 
	{
		[Embed(source = '../../../../assets/switch.png')] private var lever: Class;
		
		public var myAcid : FlxGroup;
		
		function Lever(X:Number = 0, Y:Number = 0) : void 
		{
			super("lever");
			initialize(X, Y);
			loadGraphic(lever, false, false, 32, 32, true);
			
			addAnimation("down", [4, 3, 2, 1, 0], 20, false);
			addAnimation("up", [0, 1, 2, 3, 4], 20, false);
			
			immovable = true;
			myAcid = new FlxGroup();
			for (var i: int = 0; i < 2; i++)
			{
				for (var j: int = 0; j < 4; j++)
				{
					myAcid.add(new Acid(X + 96 + 16 * i, Y + 16 * (j + 1)));
				}
			}
			// Keeps track of the acid that will flow when the lever is
			// activated
			
			for (var k: int = 0; k < myAcid.members.length; k++)
			{
				// Bit hacky at the moment - TODO: generalize
				if (k == 0 || k == 4)
				{
					myAcid.members[k].play("slosh");
				}
				else
				{
					myAcid.members[k].play("idle");
				}
			}
		}
		
		/**
		 * When the "E" key is pressed while the player is overlapping with a lever,
		 * the lever changes positions from up to down, or from down to up
		 * 
		 * TODO: have up cause acid to flow
		 */
		override public function collideWith(actor:Actor, state:State) : void 
		{
			if (FlxG.keys.justPressed("E"))
			{
				if (_curIndex == 4)
				{
					play("down");
					state.removeAcid(myAcid);
				}
				else
				{
					play("up");
					state.addAcid(myAcid);
				}
			}
		}
		
		
	}	
}