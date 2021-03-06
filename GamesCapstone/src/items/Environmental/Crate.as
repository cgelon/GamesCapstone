package items.Environmental
{
	import managers.ControlBlockManager;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import people.players.Player;
	import util.SpaceBlock;

	/**
	 * @author Lydia Duncan
	 */
	public class Crate extends EnvironmentalItem
	{
		[Embed(source = '../../../assets/crate.png')] private var tileset: Class;
		
		private const GRAVITY:int = 500;
		private const MIN_FRICTION:int = 20; 
		
		//private const 
		
		public var isLocked:Boolean;
		public var beingPushed:Boolean = false;
		
		private const STOP_VEL:Number = 10000000;	// stop & lock if moving slower than this
		private const ANTI_SLIDE:Number = 0.25;	// factor to reduce slide by (multiplied by velocity and added to friction)
		// 0 means slippery (just use MIN_FRICTION). 0.5-1 is "normal" slide.  2+ is very little slide
		
		private var _space : SpaceBlock;
		
		public function Crate(X:Number,Y:Number):void
		{
			super("crate");
			initialize(X, Y);
			
			loadGraphic(tileset, true, false, 32, 32, false);
			drag.x = maxVelocity.x / 10;
			lock();
			color = 0x77FFFFFF;
			
			FlxG.watch(this, "immovable", "Immovable");
		}
		
		override public function update():void
		{
			if (beingPushed)
			{
				if (isLocked) unlock();
			}
			else // not being pushed
			{
				if (!isLocked && isTouching(FLOOR)) lock();
				
				if (FlxG.keys.pressed("Z"))
					FlxG.log("NOT BEING PUSHED!");
			}
			
			if (_space == null)
			{
				_space = (Manager.getManager(ControlBlockManager) as ControlBlockManager).addSpaceBlock(this, new FlxPoint(-5, -20));
			}
			var player : Player = (Manager.getManager(PlayerManager) as PlayerManager).player;
			_space.exists = isLocked && overlaps(player) 
					&& !((y + height - 1 < player.y) || (player.y + player.height - height / 2 < y));
			
			// post update (reset flags)
			beingPushed = false;
			super.update();
		}
		
		// make sure that blocks stop moving when not being pushed or falling
		public function lock():void
		{
			var player : Player = (Manager.getManager(PlayerManager) as PlayerManager) != null ? 
									(Manager.getManager(PlayerManager) as PlayerManager).player : null;
			
			// move player out of block if still overlapping
			// otherwise, player will be able to move "into" the block.
			if (player != null && overlaps(player))
			{
				/*
				// only happens when at high velocity...
				if (player.isCharging)
				{
					if (PlayState.player.facing == RIGHT) PlayState.player.x -= width;
					else PlayState.player.x += width;
				}
				*/
			}
			
			// lock the block.
			isLocked = true;
			immovable = true;
			moves = false;
			velocity.x = 0;
			velocity.y = 0;
			acceleration.y = 0;
		}
		
		// make pushable again
		public function unlock():void
		{
			isLocked = false;
			immovable = false;
			moves = true;
			acceleration.y = GRAVITY;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_space = null;
		}
	}
}