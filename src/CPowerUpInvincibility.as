package  
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CPowerUpInvincibility extends CBasePowerup
	{
		public static var lastSpawn:int;
		
		public function CPowerUpInvincibility() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new PowerUp_Invincible();
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
		
			// point x3
			GameVars.powerUpInvincible = true;
			
			/* show floating text */
			FloatingTextManager.getInstance().add( "Invincible", eater.getClip().x, eater.getClip().y, "#00CCCC", 3000, 20 );
			
			FoodManager.getInstance().signalPowerUpStart( FOODTYPE.POWERUP_INVINCIBLE );
			SoundManager.getInstance().playSFX( "PowerGained" );
		}
	}
}