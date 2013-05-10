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
	public class AcidFlow extends BackgroundGroup
	{
		
		function AcidFlow(X:Number = 0, Y:Number = 0) : void 
		{
			super();
			
			for (var j: int = 0; j < 4; j++)
			{
				for (var i: int = 0; i < 2; i++)
				{				
					members[j * 2 + i] = (new Acid(X + 16 * i, Y + 16 * (j + 1)));
				}
			}
			// Keeps track of the acid that will flow when the lever is
			// activated
			
			
		}
		
		override public function playStart():void 
		{
			var k: int;
			for (k = 0; k < 2; k++)
			{
				members[k].play("slosh");
			}
			for (k = 2; k < members.length; k++)
			{
				members[k].play("idle");
			}
		}
		
		
	}	
}