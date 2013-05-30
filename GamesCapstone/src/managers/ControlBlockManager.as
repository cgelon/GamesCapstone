package managers 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import util.LearningBlock;
	import util.SpaceBlock;
	
	/**
	 * This manager controls all of the blocks that are displayed when we want the player to press 
	 * a certain button.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class ControlBlockManager extends Manager 
	{
		/**
		 * Adds a learning block.
		 * @param	target	The target for the block to follow.
		 * @param	offset	The offset from the target to follow at.
		 * @param	type	The type of learning block.
		 * @return	The learning block created (useful for chaining).
		 */
		public function addLearningBlock(target : FlxSprite, offset : FlxPoint, type : int) : LearningBlock
		{
			var block : LearningBlock = new LearningBlock(target, offset, type);
			add(block);
			return block;
		}
		
		/**
		 * Returns the learning block of the specified type, or null if it doesn't exist in this manager.
		 */
		public function getLearningBlock(type : int) : LearningBlock
		{
			for each(var obj : FlxObject in members)
			{
				if (obj != null && obj is LearningBlock)
				{
					var block : LearningBlock = obj as LearningBlock;
					if (block.type == type)
					{
						return block;
					}
				}
			}
			return null;
		}
		
		public function addSpaceBlock(target : FlxSprite, offset : FlxPoint) : SpaceBlock
		{
			var block : SpaceBlock = new SpaceBlock(target, offset);
			add(block);
			return block;
		}
	}
}