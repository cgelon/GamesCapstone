package items 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Item extends FlxSprite
	{
		private var _name : String;
		public function get name () { return _name; }
		
		public function Item(name : String) 
		{
			_name = name;
		}
		
		public function initialize(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
		}
		
	}

}