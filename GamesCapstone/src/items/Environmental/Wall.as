package items.Environmental
{
	import items.Environmental.Background.BackgroundItem;
	import org.flixel.FlxG;
	import people.Actor;
	import people.players.PlayerStats;
	import people.states.ActorState;
	import states.GameState;
	
	
	/**
	 * @author Michael Zhou
	 */
	public class Wall extends EnvironmentalItem
	{	
		[Embed(source = '../../../assets/wall.png')] private var tileset: Class;

		function Wall(X:Number=0,Y:Number=0) : void 
		{
			super("wall");
			initialize(X, Y);
			
			loadGraphic(tileset, false, false, 16, 16, true);
			
			addAnimation("idle", [0], 1, false);
			
			immovable = true;
			play("idle");
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			super.initialize(x, y);
		}
	}
}