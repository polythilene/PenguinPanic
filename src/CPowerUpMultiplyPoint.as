package  
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CPowerUpMultiplyPoint extends CBasePowerup
	{
		public static var lastSpawn:int;
		
		
		public function CPowerUpMultiplyPoint() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new PowerUp_Multiply();
			m_clip.cacheAsBitmap = true;
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			
			lastSpawn = getTimer();
		}
		
		override public function eaten(eater:CBoid):void 
		{
			super.eaten(eater);
			
			lastSpawn = getTimer();
		
			/* point x3 */
			GameVars.powerUpPointMultiplier = 3;
			
			/* show floating text */
			FloatingTextManager.getInstance().add( "x3", eater.getClip().x, eater.getClip().y, "#00CCCC", 3000, 30 );
			
			/* signal event */
			FoodManager.getInstance().signalPowerUpStart( FOODTYPE.POWERUP_POINT_X3 );
			SoundManager.getInstance().playSFX( "PowerGained" );
		}
	}
}