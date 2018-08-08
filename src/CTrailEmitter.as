package  
{
	import flash.geom.Point;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.initializers.Position
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CTrailEmitter extends CBaseEmitter
	{
		private var m_enabled:Boolean;
		private var m_image:Dot;
		private var m_dynamicTranslate:Boolean;
		private var m_zone:RectangleZone;
		//private var m_position:Position;
						
		public function CTrailEmitter() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			counter = new Steady( 30 );
			counter.stop();
			
			/* particle initializers */
			m_image = new Dot( 0.5, m_color );
			addInitializer( new SharedImage( m_image ) );
			addInitializer( new Lifetime( 1, 1.5 ) );
			
			m_zone = new RectangleZone( -4, -4, 4, 4);
			addInitializer( new Position( m_zone  ) );
									
			/* particle actions */
			addAction( new Age() );
		}
		
		override public function reset(x:int, y:int, lifeTime:int):void 
		{
			super.reset(x, y, lifeTime);
			
			m_enabled = false;
			m_dynamicTranslate = false;
			setSpawnRadius(8, 8);
			
			m_image.radius = 0.5;
			m_image.color = m_color;
						
			/*start();
			stop();*/
			start();
		}
		
		override public function remove():void 
		{
			stop();
			super.remove();
		}
		
		override public function particleUpdate(elapsedTime:int):void 
		{
			if ( m_decay ) 
			{
				m_decayTime -= elapsedTime;
				m_decay = (m_decayTime > 0);
			}
			
			if ( (m_enabled || m_decay) )
			{
				// scroll particles
				
				if (particles.length > 0)
				{
					for (var i:int = 0; i < particles.length; i++)
					{
						var velocity:Number = GameVars.onStream ? GameVars.currCameraScrollSpeed : 0.15;
						var particle:Particle2D = particles[i];
						
						
						if ( m_dynamicTranslate )
						{
							particle.x -= elapsedTime * velocity;
							
							if (GameVars.scrollingDown)
								particle.y -= elapsedTime * velocity;
												
							if (GameVars.scrollingUp)
								particle.y += elapsedTime * velocity;
						}
						else
						{
							//particle.x = this.x;
							particle.x -= GameVars.currCameraScrollSpeed * elapsedTime;
							particle.y -= elapsedTime * velocity;
						}
					}
				}
			}
		}
		
		public function set enabled(value:Boolean): void
		{
			// enable
			if ( value && !m_enabled )
			{
				counter.resume();
				m_decay = false;
			}
			
			// disable
			if ( !value && m_enabled )
			{
				counter.stop();
				m_decay = true;
				m_decayTime = 5000;
			}
			
			m_enabled = value;
		}
		
		public function get enabled(): Boolean
		{
			return m_enabled;
		}
		
		public function set dynamicTranslation(value:Boolean):void
		{
			m_dynamicTranslate = value;
		}
		
		public function get dynamicTranslation():Boolean
		{
			return m_dynamicTranslate;
		}
		
		public function set dotSize(value:Number):void
		{
			m_image.radius = value;
		}
		
		public function get dotSize():Number
		{
			return m_image.radius;
		}
		
		public function setSpawnRadius(horizontal:Number, vertical:Number):void
		{
			var halfWidth:Number = horizontal / 2;
			var halfHeight:Number = vertical / 2;
			
			m_zone.left = -halfWidth;
			m_zone.right = halfWidth;
			m_zone.top = -halfHeight;
			m_zone.bottom = halfHeight;
			
			/*if( m_position )
				removeInitializer(m_position);
				
			m_position = new Position( new RectangleZone( -halfWidth, -halfHeight, halfWidth, halfHeight) );*/
			
		}
	}

}