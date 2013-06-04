package managers 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxBar;
	import people.players.Player;
	import people.players.PlayerStats;
	import UI.Bars.HealthBar;
	import UI.BossHud;
	import UI.PlayerHud;
	import UI.UIObject;
	import people.Actor;
	import org.flixel.FlxPoint;
	
	/**
	 * Handles all of the interactions with UIObjects.
	 * 
	 * @author ...
	 */
	public class UIObjectManager extends Manager
	{
		private var _hud : PlayerHud;
		private var _flashTimer : FlxTimer;
		private var _flashingCount : int;
		
		private var _bossHud : BossHud;
		
		public function UIObjectManager()
		{
			_flashTimer = new FlxTimer();
		}
		
		override public function update() : void
		{
			super.update();
			
			if (_flashTimer.running)
			{
				if (_flashingCount % 8 < 8 / 2)
				{
					_hud.staminaBar.color = 0x7F7F7F7F;
				}
				else
				{
					_hud.staminaBar.color = 0xFFFFFFFF;
				}
				_flashingCount++;
			}
		}
		
		public function createPlayerHud() : void
		{
			var hud : PlayerHud = new PlayerHud();
			add(hud);
			_hud = hud;
		}
		
		public function createBossHud() : void
		{
			var hud : BossHud = new BossHud();
			add(hud);
			_bossHud = hud;
		}
		
		public function toggleBossHud() : void
		{
			_bossHud.visible = !_bossHud.visible;
		}
		
		public function flashStaminaBar(duration : Number) : void
		{
			if (_flashTimer == null)
				_flashTimer = new FlxTimer();
				
			if (!_flashTimer.running)
			{
				_flashingCount = 0;
				_flashTimer.start(duration, 1, function(timer : FlxTimer) : void
				{
					_hud.staminaBar.color = 0xFFFFFFFF;
				});
			}
		}
		
		/**
		 * Add a health bar that monitors the health attribute of the given actor.
		 * 
		 * @param	owner		The Actor that the health bar is monitoring.
		 * @param	x			The x-coordinate of the health bar. Ignored if onParent is true.
		 * @param	y			The y-coordinate of the health bar. Ignored if onParent is true.
		 * @param	width		The width of the health bar.
		 * @param	height		The height of the health bar.
		 * @param	onParent	Whether or not the health bar should be above the Actor in question. 
		 * 						If true, centers itself right on top of the Actor.
		 */
		public function addHealthBar(owner : Actor, x : Number, y : Number, width : Number, height : Number, onParent : Boolean, fadeBar : Boolean) : void
		{
			var healthBar : HealthBar = new HealthBar(owner, x, y, width, height, onParent, fadeBar);
			
			add(healthBar);
		}
		
		public function addStaminaBar(owner : Player, x : Number, y : Number, width : Number, height : Number, onParent : Boolean) : void
		{
			var staminaBar : FlxBar = new FlxBar(x, y, FlxBar.FILL_LEFT_TO_RIGHT, width, height, owner, "stamina", 0, PlayerStats.MAX_STAMINA, false);
			
			if (onParent)
			{
				staminaBar.trackParent((owner.width - width) / 2, -(height + 1));
			}
			else
			{
				staminaBar.scrollFactor.x = 0;
				staminaBar.scrollFactor.y = 0;
			}
			
			staminaBar.createFilledBar(0x7F005100, 0xFF00F400, true);
			
			add(staminaBar);
		}
	}
}