package items.Weapons 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WeaponUpgrade extends Item
	{
		private var _damage : Number;
		
		public function WeaponUpgrade(name : String, damage : Number) 
		{
			super(name);
			_damage = damage;
		}
		
	}

}