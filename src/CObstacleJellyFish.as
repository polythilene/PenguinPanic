package  
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	import com.shade.math.OpMath;
	import soulwire.ai.Boid;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CObstacleJellyFish extends CSeaObject
	{
		public static var lastSpawn:int;
		
		private var m_moveSpeed:Number;
		private var m_crash:Boolean;
		
		public function CObstacleJellyFish() { }
				
		override protected function initialize():void 
		{
			m_clip = new ObstacleJellyfish();
			m_clip.cacheAsBitmap = true;
			m_scrollSpeed = 0;
			
			lastSpawn = getTimer();
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			
			m_moveSpeed = ( Math.floor( OpMath.randomRange(10, 20) ) * 100) / 10000;
			m_crash = false;
			m_clip.rotation = -20;
			
			lastSpawn = getTimer();
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			m_clip.x += OpMath.cos(m_clip.rotation-90) * (m_moveSpeed * elapsedTime);
			m_clip.y += OpMath.sin(m_clip.rotation - 90) * (m_moveSpeed * elapsedTime);
			
			if( m_active && !SwarmManager.getInstance().isPanic() && !GameVars.powerUpInvincible && !m_crash )
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
					if( m_clip.dummyHit.hitTestObject( boid.getClip() ) )
					{
						var cheathDeath:Boolean = false;
						
						/* try to cheat death (upgrade only) */
						if( GameVars.upgradeLuckObtained )
						{
							if( Math.floor(OpMath.randomNumber(100)) < GameVars.CHEATH_DEATH_FACTOR )
								cheathDeath = true;
						}
					
						if( !cheathDeath )
						{			
							GameVars.stingCounter++;
							
							if( GameVars.stingCounter == 1 &&
								!GameVars.achievementElectrifiedObtained &&
								GameVars.gameMode == 0 )
							{
								GameVars.achievementElectrifiedObtained = true;
								GameLoop.getInstance().showAchievement( "That Tingles.", "Got Stung By Jellyfish.", 100 );
							}
							else
							if( GameVars.stingCounter == 10 &&
								!GameVars.achievementLetsDoItAgainObtained &&
								GameVars.gameMode == 0 )
							{
								GameVars.achievementLetsDoItAgainObtained = true;
								GameLoop.getInstance().showAchievement( "Let's Do That Again!.", "10x Stung By Jellyfishes.", 300 );
							}
							
							boid.setDead();
							m_crash = true;
							SoundManager.getInstance().playSFX("JellyFishStung");
						}
						
						break;
					}
				}
				boid = boid.next;
			}
		}
	}
}