package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class PredatorEvent extends Event
	{
		public var predator:CBasePredator=null;
		
		public function PredatorEvent(type:String) 
		{
			super(type);
		}
	}
}