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
	public class AcidFlow extends BackgroundItem 
	{		
		public var myAcid : FlxGroup;
		
		function AcidFlow(X:Number = 0, Y:Number = 0) : void 
		{
			super("acidflow");
			initialize(X, Y);
			
			immovable = true;
			myAcid = new FlxGroup();
			for (var i: int = 0; i < 2; i++)
			{
				for (var j: int = 0; j < 4; j++)
				{
					myAcid.add(new Acid(X + 16 * i, Y + 16 * (j + 1)));
				}
			}
			// Keeps track of the acid that will flow when the lever is
			// activated
			
			
		}
		
		override public function playStart():void 
		{
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
		
		
	}	
}