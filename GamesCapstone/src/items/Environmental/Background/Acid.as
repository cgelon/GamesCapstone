package items.Environmental.Background
{
	import items.Environmental.Background.BackgroundItem;
	import managers.ObjectManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import people.Actor;
	import states.State;

	/**
	 * @author Lydia Duncan
	 */
	public class Acid extends BackgroundItem
	{
		[Embed(source = '../../../../assets/lab tile arrange.png')] private var tileset: Class;
		
		function Acid(X:Number=0,Y:Number=0) : void 
		{
			super("acid");
			initialize(X, Y);
			
			loadGraphic(tileset, true, false, 16, 16, false);
			
			addAnimation("slosh", [454, 455], 1, true);
			addAnimation("idle", [390], 1, true);
			// Need an animation for sideways falling, figure out how to rotate
			
			immovable = true;
			allowCollisions = ANY;
		}
		
		override public function collideWith(actor:Actor, state:State = null):void 
		{
			actor.touchedAcid();
		}
		
		override public function playStart():void 
		{
			play("slosh");
		}
	}
}