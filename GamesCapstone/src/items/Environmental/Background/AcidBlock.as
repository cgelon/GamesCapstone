package items.Environmental.Background 
{
	import org.flixel.*;
	import people.*;
	import people.players.*;
	import people.states.*;
	import states.*;
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidBlock extends BackgroundItem implements BackgroundInterface
	{
		/** Percent of players health that acid should do every second. */
		private const ACID_DAMAGE_PERCENT : Number = 150;
		/** Damage dealt by acid every frame. */
		private const ACID_DAMAGE : Number = (ACID_DAMAGE_PERCENT / 100)  * PlayerStats.MAX_HEALTH / FlxG.framerate;

		public function AcidBlock(X: Number, Y: Number, width: Number) 
		{
			super("AcidBlock");
			this.x = X;
			this.y = Y;
			this.width = width;
			this.height = 1;
			immovable = true;
			
			makeGraphic(width, height, 0xFF98ED67, true);
			FlxG.clearBitmapCache();
		}
		
		override public function update() : void
		{
			super.update();
			height++;
			this.y--;
			makeGraphic(width, height, 0xFF98ED67, true);
			FlxG.clearBitmapCache();
		}
		
		override public function collideWith(actor:Actor, state:GameState):void 
		{
			if (actor.state != ActorState.DEAD && !actor.touchedAcidThisFrame)
			{
				actor.touchedAcidThisFrame = true;
				actor.dealDamage(ACID_DAMAGE);
				actor.flickerActor(0.5);
			}
		}
	}

}