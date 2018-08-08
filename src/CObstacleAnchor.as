package  
{
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	
	import com.shade.math.OpMath;
	
	import soulwire.ai.Boid;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CObstacleAnchor extends CSeaObject
	{
		public static var lastSpawn:int;
		
		private var m_maxDrown:int;
		private var m_drownSpeed:Number;
		
		public function CObstacleAnchor() { }
				
		override protected function initialize():void 
		{
			m_clip = new ObstacleAnchor();
			m_clip.cacheAsBitmap = true;
			
			m_scrollSpeed = 0;
			lastSpawn = getTimer();
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			
			m_maxDrown = -OpMath.randomRange(70, 200);
			m_drownSpeed = ( Math.floor( OpMath.randomRange(5, 10) ) * 100) / 10000;
			
			if( OpMath.randomNumber(100) < 40 )
				SoundManager.getInstance().playSFX("Bubble_03");
			else if( OpMath.numberInRange( OpMath.randomNumber(100), 40, 80 ) )
				SoundManager.getInstance().playSFX("Bubble_04");
				
			lastSpawn = getTimer();	
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			if ( m_clip.y < m_maxDrown )
			{
				m_clip.y += m_drownSpeed * elapsedTime;	
			}
						
			if( m_active && !SwarmManager.getInstance().isPanic() && !GameVars.powerUpInvincible )
				checkCollision();
		}
		
		private function checkCollision():void
		{
			/* check if object is colliding with penguins */
			var boid:CBoid = SwarmManager.getInstance().getFirstBoid();
						
			/* check collision with the penguins */
			while( boid != null ) 
			{
				if( boid.isAlive() && !GameVars.gameOver )
				{
					if( ObstacleAnchor( m_clip ).chainDummyHit.hitTestObject( boid.getClip() ) ||
						ObstacleAnchor( m_clip ).anchorDummyHit.hitTestObject( boid.getClip() ) )
					{
						var cheathDeath:Boolean = false;
						
						/* try to cheat death (upgrade only) */
						if ( GameVars.upgradeLuckObtained )
						{
							if( Math.floor(OpMath.randomNumber(100)) < GameVars.CHEATH_DEATH_FACTOR )
								cheathDeath = true;
						}
					
						if ( !cheathDeath )
						{
							SoundManager.getInstance().playSFX("Crash_Generic");
							SoundManager.getInstance().playSFX("Crash_Death1");
							boid.setDead();
						}
					}
				}
				boid = boid.next;
			}
		}
	}
}