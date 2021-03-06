package managers 
{
	import cutscenes.engine.Cutscene;
	import cutscenes.engine.MessageBox;
	
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
		
		public function addMessageBox(message : MessageBox) : void
		{
			add(message);
		}
	}
}