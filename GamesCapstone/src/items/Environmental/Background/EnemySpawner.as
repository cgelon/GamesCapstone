package items.Environmental.Background
{
	import items.Environmental.Background.Circuit.Reactor;
	import managers.EnemyManager;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import people.enemies.Enemy;
	import people.enemies.LightningRobot;
	import people.enemies.Robot;
	import states.GameState;
	/**
	 * @author Lydia Duncan
	 */
	public class EnemySpawner extends Reactor implements BackgroundInterface
	{
		private var X : Number;
		private var Y : Number;
		private var counter : Number;
		
		function EnemySpawner(X:Number = 0, Y:Number = 0) : void 
		{	
			super();
			
			this.X = X;
			this.Y = Y;
			this.counter = 0;
			enabled = false;
		}
		
		public function playStart(): void
		{
			
		}
		
		// If the counter has taken a certain amount of time, add another enemy
		override public function update() : void
		{
			counter += FlxG.elapsed;
			if (counter >= 0.25)
			{
				if (enabled)
				{
					add(new LightningRobot());
					(members[length - 1] as Enemy).initialize(X, Y);
					((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).add(members[length - 1]);
					
				}
				counter = 0;
			}
			
			super.update();
		}
		
		// Start adding enemies
		override public function enable() : void
		{ 
			super.enable();
			for (var i : int = 0; i < 10; i++)
			{
				if (i % 2 == 0 || i == 0)
				{
					add(new Robot());
				}
				else
				{
					add(new LightningRobot());
				}
				(members[length - 1] as Enemy).initialize(X + 16 * i, Y);
				((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).add(members[length - 1]);
			}				
		}
		
		// Once enabled, should not be able to disable
		override public function disable() : void
		{ 
			if (enabled)
			{
				add(new LightningRobot());
				(members[length - 1] as Enemy).initialize(X, Y);
				((FlxG.state as GameState).getManager(EnemyManager) as EnemyManager).add(members[length - 1]);
			}
			super.disable();		
		}
		
	}	
}