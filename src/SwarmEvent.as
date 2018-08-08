package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class SwarmEvent extends Event
	{
		public var lifeTime:int=0;
		public var boid:CBoid=null;
		
		public function SwarmEvent(type:String) 
		{
			super(type);
		}
	}
}