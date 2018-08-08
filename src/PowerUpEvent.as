package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class PowerUpEvent extends Event
	{
		public var powerup:int=0;
		
		public function PowerUpEvent(type:String) 
		{
			super(type);
		}
	}
}