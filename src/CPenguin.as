package  
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.display.DisplayObjectContainer;
	
	import soulwire.ai.Boid;
	import gs.TweenMax;
	
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CPenguin extends CBoid
	{
		private var buffPoint1:CPoint;
		private var buffPoint2:CPoint;
		
		private var m_panicEmitter:CBaseEmitter;
		private var m_rapidStreamEmitter:CBaseEmitter;
		
		private var m_normalSpeed:Number;	// normal speed
		private var m_streamSpeed:Number;	// speed when the penguin hit fast stream
		
		private var m_outOfZone:Boolean;
		
		
		public function CPenguin() 
		{
			buffPoint1 = new CPoint();
			buffPoint2 = new CPoint();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Penguin();
			m_clip.cacheAsBitmap = true;
			
			m_boid.x = m_clip.x = -100;
			m_boid.y = m_clip.y = 320;
			
			m_boid.renderData = m_clip;
			m_boid.edgeBehavior = Boid.EDGE_NONE;
			m_boid.maxForce = OpMath.randomRange(3.0, 6.0);
			m_boid.wanderDistance = OpMath.randomRange(10.0, 50.0);
			m_boid.wanderRadius = OpMath.randomRange(5.0, 50.0);
			m_boid.wanderStep = OpMath.randomRange(0.1, 0.9);
		}
		
		override public function reset(source:CPoint, attractor:CSwarmAttractor, flock:Vector.<Boid>):void 
		{
			super.reset(source, attractor, flock);
			
			/* set speed */
			m_boid.maxSpeed = m_normalSpeed = OpMath.randomRange(8, 12.0) * GameVars.speedMultiplier;
			m_streamSpeed = m_normalSpeed * 1.5;
			
			m_outOfZone = false;
			
			/* get emitters */
			if ( ParticleManager.getInstance().enable )
			{
				m_panicEmitter = ParticleManager.getInstance().add(EMITTERTYPE.PIXEL_WHITE, source.x, source.y);
				m_rapidStreamEmitter = ParticleManager.getInstance().add(EMITTERTYPE.PIXEL_LIGHTBLUE, source.x, source.y);
				
				CTrailEmitter(m_panicEmitter).dynamicTranslation = true;
				CTrailEmitter(m_rapidStreamEmitter).dynamicTranslation = true;
				
				CTrailEmitter(m_panicEmitter).enabled = false;
				CTrailEmitter(m_rapidStreamEmitter).enabled = false;
			}
			
			/* add listener */
			SwarmManager.getInstance().addEventListener(SwarmManager.RAPID_STREAM, hitStream);
			ParticleManager.getInstance().addEventListener( ParticleManager.PARTICLE_ENABLED, enableParticle );
			ParticleManager.getInstance().addEventListener( ParticleManager.PARTICLE_DISABLED, disableParticle );
			PredatorManager.getInstance().addEventListener( PredatorManager.PREDATOR_SPAWNED, predatorSpawned );
		}
		
		override public function remove():void 
		{
			super.remove();
			
			if ( ParticleManager.getInstance().enable )
			{
				CTrailEmitter(m_panicEmitter).enabled = false;
				m_panicEmitter.setDead();
				m_panicEmitter = null;
								
				CTrailEmitter(m_rapidStreamEmitter).enabled = false;
				m_rapidStreamEmitter.setDead();
				m_rapidStreamEmitter = null;
			}
			
			/* remove listener */
			ParticleManager.getInstance().removeEventListener( ParticleManager.PARTICLE_ENABLED, enableParticle );
			ParticleManager.getInstance().removeEventListener( ParticleManager.PARTICLE_DISABLED, disableParticle );
			SwarmManager.getInstance().removeEventListener(SwarmManager.RAPID_STREAM, hitStream);
			PredatorManager.getInstance().removeEventListener( PredatorManager.PREDATOR_SPAWNED, predatorSpawned );
		}
		
		public function set speed(value:Number): void
		{
			m_boid.maxSpeed = value;
		}
		
		public function get speed(): Number
		{
			return m_boid.maxSpeed;
		}
		
		public function hitStream(event: SwarmEvent ): void
		{
			m_boid.maxSpeed = m_streamSpeed;
									
			TweenMax.killTweensOf(this);			
			TweenMax.to(	this, event.lifeTime / 1000, 
							{ onComplete:function():void 
								{ 
									speed = m_normalSpeed;
									
									if( ParticleManager.getInstance().enable )
										CTrailEmitter(m_rapidStreamEmitter).enabled = false;
								} 
							}	
						);
						
			if( ParticleManager.getInstance().enable )
				CTrailEmitter(m_rapidStreamEmitter).enabled = true;			
		}
		
		override public function update(elapsedTime:int):void
		{
			
			/* check distance with attractor to control swarm behaviour */
			buffPoint1.x = m_boid.x;
			buffPoint1.y = m_boid.y;
			
			buffPoint2.x = m_attractor.getPosition().x;
			buffPoint2.y = m_attractor.getPosition().y;
						
			var distance:Number = OpMath.distance(buffPoint1, buffPoint2);
			
			if ( distance > 30 )
			{
				m_boid.wander(0.3);
				m_boid.seek(m_attractor.getPosition(), 0.5);
				
				m_boid.wanderDistance = OpMath.randomRange(10.0, 20.0) * GameVars.wanderOverride;
				m_boid.wanderRadius = OpMath.randomRange(5.0, 20.0) * GameVars.wanderOverride;
				
				if ( distance > 400 && !m_outOfZone )
				{
					m_outOfZone = true;
					m_boid.maxSpeed = m_normalSpeed = 13  * GameVars.speedMultiplier;
					m_streamSpeed = m_normalSpeed * 1.5;
					
					if( SwarmManager.getInstance().isStream() )
						m_boid.maxSpeed = m_streamSpeed;
				}
				else if ( distance < 300 && m_outOfZone)
				{
					m_outOfZone = false;
					m_boid.maxSpeed = m_normalSpeed = OpMath.randomRange(8, 12.0) * GameVars.speedMultiplier;
					m_streamSpeed = m_normalSpeed * 1.5;
					
					if( SwarmManager.getInstance().isStream() )
						m_boid.maxSpeed = m_streamSpeed;
				}
			}
			else
			{
				m_boid.wander(1);
				m_boid.seek(m_attractor.getPosition(), 0.1);
				
				m_boid.wanderDistance = 100 * GameVars.wanderOverride;
				m_boid.wanderRadius = 50 * GameVars.wanderOverride; 
			}
			
			if ( SwarmManager.getInstance().isPanic() )
				flee();
			else	
			{
				if( GameVars.upgradeFollowTheLeader2Obtained )
					m_boid.flock( m_flock );
			}
			
			m_boid.update();
			m_boid.render();
			
			
			/* update emitter */
			
			if( ParticleManager.getInstance().enable )
			{
				if ( SwarmManager.getInstance().isPanic()  )
					CTrailEmitter(m_panicEmitter).enabled = (!CTrailEmitter(m_rapidStreamEmitter).enabled);
				else
					CTrailEmitter(m_panicEmitter).enabled = false;
						
						
				if( CTrailEmitter(m_panicEmitter).enabled )
					m_panicEmitter.setPosition(m_boid.x, m_boid.y);
				
				if( CTrailEmitter(m_rapidStreamEmitter).enabled )
					m_rapidStreamEmitter.setPosition(m_boid.x, m_boid.y);	
			}
			
			m_boidPosition.x = m_clip.x;
			m_boidPosition.y = m_clip.y;
		}
		
		private function enableParticle(event:Event): void
		{
			var source:CPoint = getPosition();
			
			m_panicEmitter = ParticleManager.getInstance().add(EMITTERTYPE.PIXEL_WHITE, source.x, source.y);
			m_rapidStreamEmitter = ParticleManager.getInstance().add(EMITTERTYPE.PIXEL_LIGHTBLUE, source.x, source.y);
				
			CTrailEmitter(m_panicEmitter).dynamicTranslation = true;
			CTrailEmitter(m_rapidStreamEmitter).dynamicTranslation = true;
		}
		
		private function disableParticle(event:Event): void
		{
			CTrailEmitter(m_panicEmitter).enabled = false;
			m_panicEmitter.setDead();
			m_panicEmitter = null;
								
			CTrailEmitter(m_rapidStreamEmitter).enabled = false;
			m_rapidStreamEmitter.setDead();
			m_rapidStreamEmitter = null;
		}
		
		override public function setDead():void 
		{
			super.setDead();
			
			TweenMax.killTweensOf(this);
		}
		
		private function predatorSpawned(event:PredatorEvent): void 
		{
			if( Math.floor(OpMath.randomNumber(100)) < 50 )
				FloatingTextManager.getInstance().add( "!", m_boidPosition.x+100, m_boidPosition.y, "#CCCC00", 3000, 20 );
		}
	}
}