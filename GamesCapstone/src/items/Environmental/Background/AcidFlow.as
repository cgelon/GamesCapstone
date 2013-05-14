package items.Environmental.Background
{
	import items.Environmental.Background.Circuit.Reactor;
	import items.Environmental.Crate;
	import managers.BackgroundManager;
	import managers.LevelManager;
	import managers.Manager;
	import managers.ObjectManager;
	import managers.PlayerManager;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	import states.GameState;
	import util.Sounds;
	/**
	 * @author Lydia Duncan
	 */
	public class AcidFlow extends Reactor implements BackgroundInterface
	{
		private var X : Number;
		private var Y : Number;
		private var counter : Number;
		private var _acidSound : FlxSound;
		
		function AcidFlow(X:Number = 0, Y:Number = 0) : void 
		{	
			super();
			
			this.X = X;
			this.Y = Y;
			this.counter = 0;
			for (var j: int = 0; j < 1; j++)
			{
				for (var i: int = 0; i < 2; i++)
				{				
					add(new Acid(X + 16 * i, Y + 16 * (j + 1)));
				}
			}
			enabled = true;
			
			_acidSound = FlxG.loadSound(Sounds.ACID, 0.1, true);
			
			// Keeps track of the acid that will flow when the lever is
			// activated	
		}
		
		public function addAcid(X:Number, Y:Number)  : void
		{
			var acid : Acid = recycle( Acid ) as Acid;
			acid.initialize(X, Y);
			add(acid);
			acid.acceleration.y = 2000;
		}
		
		override public function update() : void
		{
			counter += FlxG.elapsed;
			if (counter >= 0.125)
			{
				if (enabled)
				{
					for (var i: int = 0; i < 2; i++)
					{				
						addAcid(X + 16 * i, Y + 24);
					}
				}
				playStart();
				counter = 0;
			}
			
			killMapOverlaps((getManager(LevelManager) as LevelManager).map);
			killCrateOverlaps(getManager(ObjectManager) as ObjectManager as FlxGroup);
			super.update();
			
			if (!_acidSound.playing && enabled)
			{
				_acidSound.proximity(X + 16, Y + 16, (getManager(PlayerManager) as PlayerManager).player, 400).play();
			}
			else if (_acidSound.playing && !enabled)
			{
				_acidSound.stop();
			}
		}
		
		public function killMapOverlaps(map:FlxTilemap) : void 
		{
			var currentAcid : Acid = null;
			for (var i:int; i < length; i++) 
			{
				currentAcid = members[i];
				if (currentAcid != null && (map.overlapsWithCallback(currentAcid, overlapCallback)))
				{
					remove(currentAcid);
					currentAcid.kill();
				}
				
			}
		}
		
		public function killCrateOverlaps(objects: FlxGroup) : void
		{
			var crates : Array = [];
			for (var i: int = 0; i < objects.length ; i++) {
				if (objects.members[i] != null && objects.members[i] is Crate)
				{
					crates.push(objects.members[i]);
				}
			}
			
			var currentAcid : Acid = null;
			var currentCrate : Crate = null;
			for (i = 0; i < length; i++) 
			{
				currentAcid = members[i];
				for (var j: int = 0; j < crates.length; j++) {
					currentCrate = crates[j];
					if (currentAcid != null && currentCrate != null &&
					    (currentCrate.overlaps(currentAcid)))
					{
						remove(currentAcid);
						currentAcid.kill();
					}
				}
			}
		}
		
		public function overlapCallback(tile: FlxTile, object: Acid) : Boolean
		{
			var platformTileTypes : Array = [423, 424, 425, 426];
			//var forcefieldTileTypes : Array = [458, 490, 522, 519, 520, 521];
			var overlapFound : Boolean = false;
			// copied from flixel code
			overlapFound = (object.x + object.width > tile.x) && (object.x < tile.x + tile.width) && (object.y + object.height > tile.y) && (object.y < tile.y + tile.height);
			return (overlapFound && !containsNum(tile.index, platformTileTypes))			
		}
		
		private function containsNum(num: Number, array: Array) : Boolean
		{
			var result : Boolean = false;
			for (var i: int = 0; i < array.length; i++)
			{
				result = result || (num == array[i]);
			}
			return result;
		}
		
		public function playStart():void 
		{
			var currentAcid : Acid = null;
			for (var k: int = 0; k < length; k++)
			{
				currentAcid = members[k];
				if (currentAcid != null) {
					if (k == 0 || k == 1) 
					{
						currentAcid.play("slosh");
					} else {
						currentAcid.play("idle");
					}
				}
			}
		}

		
		override public function enable() : void
		{ 
			super.enable();
			var currentAcid : Acid = null;
			for (var i: int = 0; i < 2; i++) {
				currentAcid = members[i];
				currentAcid.exists = true;
			}
			if (getManager(BackgroundManager) != null)
				getManager(BackgroundManager).add(this);
		}
		
		override public function disable() : void
		{ 
			super.disable();
			//if (getManager(BackgroundManager) != null)
			//	getManager(BackgroundManager).remove(this);
			var currentAcid : Acid = null;
			for (var i: int = 0; i < 2; i++) {
				currentAcid = members[i];
				currentAcid.exists = false;
			}
		}
		
		public function overlaps(Object: FlxBasic): Boolean
		{
			for (var i: int = 0; i < length; i++)
			{
				if (members[i] != null)
				{
					if ((members[i] as Acid).overlaps(Object))
						return true;
				}
			}
			return false;
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class) : Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
	}	
}