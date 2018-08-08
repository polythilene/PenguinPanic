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
	public class CObstacleIcicle extends CSeaObject
	{
		public static var lastSpawn:int;
		
		private var m_drownSpeed:Number;
		private var m_bubbleEmitter:CBaseEmitter;
		private var m_crash:Boolean;
		
		public function CObstacleIcicle() { }
		
		override protected function initialize():void 
		{
			m_clip = new ObstacleIcicle();
			m_scrollSpeed = 0;
			
			lastSpawn = getTimer();
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			
			m_clip.gotoAndStop( Math.round( OpMath.randomRange(1, 3) ) );
			if( ParticleManager.getInstance().enable )
			{
				m_bubbleEmitter = ParticleManager.getInstance().add( EMITTERTYPE.PIXEL_WHITE, x, y );
				CTrailEmitter(m_bubbleEmitter).dotSize = 1;	
				CTrailEmitter(m_bubbleEmitter).dynamicTranslation = false;	
				CTrailEmitter(m_bubbleEmitter).setSpawnRadius(15, 15);	
				CTrailEmitter(m_bubbleEmitter).enabled = true;	
				
			}
				
			m_drownSpeed = ( Math.floor( OpMath.randomRange(10, 15) ) * 100) / 10000;
			m_crash = false;
			
			if( OpMath.randomNumber(100) < 40 )
				SoundManager.getInstance().playSFX("Bubble_01");
			else if( OpMath.numberInRange( OpMath.randomNumber(100), 40, 80 ) )
				SoundManager.getInstance().playSFX("Bubble_02");	
			
			
			/* add listeners */
			ParticleManager.getInstance().addEventListener( ParticleManager.PARTICLE_ENABLED, enableParticle );
			ParticleManager.getInstance().addEventListener( ParticleManager.PARTICLE_DISABLED, disableParticle );
			
			lastSpawn = getTimer();	
		}
		
		override public function remove():void 
		{
			ParticleManager.getInstance().removeEventListener( ParticleManager.PARTICLE_ENABLED, enableParticle );
			ParticleManager.getInstance().removeEventListener( ParticleManager.PARTICLE_DISABLED, disableParticle );
			
			if( ParticleManager.getInstance().enable )
			{
				CTrailEmitter(m_bubbleEmitter).enabled = false;
				m_bubbleEmitter.setDead();
				m_bubbleEmitter = null;
			}
					
			super.remove();
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			m_clip.y += m_drownSpeed * elapsedTime;	
									
			if( ParticleManager.getInstance().enable )
			{
				m_bubbleEmitter.setPosition( m_clip.x, m_clip.y );
			}
			
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
					if( m_clip.hitTestObject( boid.getClip() ) )
					{
						var cheathDeath:Boolean = false;
						
						/* try to cheat death (upgrade only) */
						if ( GameVars.upgradeLuckObtained )
						{
							if( Math.floor(OpMath.randomNumber(100)) < GameVars.CHEATH_DEATH_FACTOR )
								cheathDeath = true;
						}
					
						if( !cheathDeath )
						{
							/* achievement */
							if( !GameVars.achievementDidSomeoneOrderFrozenPenguinObtained &&
								GameVars.gameMode == 0 )
							{
								GameVars.achievementDidSomeoneOrderFrozenPenguinObtained = true;
								GameLoop.getInstance().showAchievement( "Did Someone Order Frozen Penguin?.", "A Penguin Collided with Icicle.", 100 );
							}
							
							/* state */
							boid.setDead();
							m_crash = true;
							setDead();
							SoundManager.getInstance().playSFX("Crash_Generic");
							SoundManager.getInstance().playSFX("Crash_Death2");
						}
						
						break;
					}
				}
				boid = boid.next;
			}
		}
		
		private function enableParticle(event:Event): void
		{
			m_bubbleEmitter = ParticleManager.getInstance().add( EMITTERTYPE.PIXEL_WHITE, m_clip.x, m_clip.y );
			CTrailEmitter(m_bubbleEmitter).dotSize = 1;	
			CTrailEmitter(m_bubbleEmitter).dynamicTranslation = false;	
			CTrailEmitter(m_bubbleEmitter).setSpawnRadius(15, 15);	
			CTrailEmitter(m_bubbleEmitter).enabled = true;	
		}
		
		private function disableParticle(event:Event): void
		{
			CTrailEmitter(m_bubbleEmitter).enabled = false;
			m_bubbleEmitter.setDead();
			m_bubbleEmitter = null;
		}
	}
}