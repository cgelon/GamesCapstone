package managers 
{
	import cutscenes.engine.Cutscene;
	
	/**
	 * Deals with cutscenes.
	 * 
	 * @author Chris Gelon
	 */
	public class CutsceneManager extends Manager 
	{
		public function addCutscene(cutscene : Cutscene) : void
		{
			add(cutscene);
		}
	}
}