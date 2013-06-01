package people.states 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BossAction extends ActorAction
	{
		public static const THROW_HAT : BossAction = new BossAction();
		public static const CATCH_HAT : BossAction = new BossAction();
		public static const SHOOT_LASER : BossAction = new BossAction();
		public static const SLAM_GROUND : BossAction = new BossAction();
		
		override public function get name() : String
		{
			switch (this) 
			{
				case THROW_HAT:
					return "throw hat";
				case SHOOT_LASER:
					return "shoot laser"
				case SLAM_GROUND:
					return "slam ground";
			}
			return super.name;
		}
		
	}

}