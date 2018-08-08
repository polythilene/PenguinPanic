package  
{
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CPowerUpRapidStream extends CBasePowerup
	{
		
		public function CPowerUpRapidStream() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new SpeedUp();
			m_clip.cacheAsBitmap = true;
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			
			m_scrollSpeed = (5 * 100) / 10000;
		}
		
		override public function eaten(eater:CBoid):void 
		{
			super.eaten(eater);
		
			// SIGNAL SPEED
			SoundManager.getInstance().playSFX( "Stream_Surf" );
			SwarmManager.getInstance().signalRapidStream();
		}
	}
}