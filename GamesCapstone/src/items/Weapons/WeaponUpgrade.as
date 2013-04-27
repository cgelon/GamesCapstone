package items.Weapons 
{
	import items.Item;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WeaponUpgrade extends Item
	{
		/** How much damage this weapon upgrade adds */
		private var _damageUp : Number;
		public function get damageUp() : Number { return _damageUp; }
		
		/** Which weapon slot this weapon occupies */
		private var _weaponSlot : uint;
		public function get weaponSlot() : uint { return _weaponSlot; }
		
		public function WeaponUpgrade(name : String, damageUp : Number, weaponSlot : uint) 
		{
			super(name);
			_damageUp = damageUp;
			_weaponSlot = weaponSlot;
		}
		
	}

}