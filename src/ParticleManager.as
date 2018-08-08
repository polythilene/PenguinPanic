package  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Rectangle;
	import flash.filters.ColorMatrixFilter;
	
	
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class ParticleManager extends EventDispatcher
	{
		static private var m_instance:ParticleManager;
		
		static public const PARTICLE_ENABLED:String = "particle_enabled";
		static public const PARTICLE_DISABLED:String = "particle_disabled";
					
		private var m_head:CBaseEmitter;
		private var m_tail:CBaseEmitter;
			
		private var m_owner:DisplayObjectContainer;
		private var m_renderer:BitmapRenderer;
		private var m_stageWidth:int;
		private var m_stageHeight:int;
		
		private var m_emitterCount:int = 0;
		private var m_enable:Boolean = true;
		
		/*
		private var m_blurFilter:BlurFilter;
		private var m_colorFilter:ColorMatrixFilter;
		*/
		
		
		/* object pool */
		private var m_poolManager:CPoolManager;
			
		public function ParticleManager(lock:SingletonLock)	
		{
		}
			
		public function initialize(stageWidth:int, stageHeight:int):void
		{
			if ( m_enable )
			{
				m_poolManager = new CPoolManager();
				m_poolManager.registerPool(CTrailEmitter, 10);
				m_poolManager.registerPool(CSnowEmitter, 2);
				
				//m_poolManager.registerPool(CBlastEmitter, 5);
				
				m_stageWidth = stageWidth;
				m_stageHeight = stageHeight;
				
				m_renderer = new BitmapRenderer( new Rectangle( 0, 0, m_stageWidth, m_stageHeight ) );
				
				/*
				m_blurFilter = new BlurFilter( 3, 3, 1 );
				m_colorFilter = new ColorMatrixFilter( [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.95, 0 ] );
				
				m_renderer.addFilter( m_blurFilter );
				m_renderer.addFilter( m_colorFilter );
				*/
				
				//GameVars.rootClip.addChildAt( m_renderer, GameVars.rootClip.getChildIndex(GameVars.seaWater) + 1 );
				//GameVars.effectLayer = m_renderer;
			}
		}
		
		public function attach(owner:DisplayObjectContainer, index:int=-1):void
		{
			if( index != -1 )
				owner.addChildAt( m_renderer, index );
			else
				owner.addChild( m_renderer );
				
			m_owner = owner;	
			m_renderer.x = m_renderer.y = 0;
		}
		
		public function detach():void
		{
			m_owner.removeChild( m_renderer );
			m_owner = null;
		}
		
		public function clear(): void
		{
			if ( m_enable )
			{
				/*
				m_renderer.removeFilter( m_blurFilter );
				m_renderer.removeFilter( m_colorFilter );
				*/
				
				/* send all particles to pool */
				var emitter:CBaseEmitter = m_head;
				while( emitter != null ) 
				{
					emitter.setDead();
					
					var garbage:CBaseEmitter = emitter;
					emitter = emitter.next;
						
					remove(garbage);
					sendToPool(garbage);
				}
			}
		}
		
		public function add(emitter_type:int, x:int, y:int, lifeTime:int=0): CBaseEmitter
		{
			var emitter:CBaseEmitter;
			
			m_emitterCount++;
				
			switch( emitter_type )
			{
				case EMITTERTYPE.PIXEL_WHITE:
					emitter = m_poolManager.getPoolData(CTrailEmitter);
					emitter.color = 0xFFFFFF;
					break;
				case EMITTERTYPE.PIXEL_LIGHTBLUE:
					emitter = m_poolManager.getPoolData(CTrailEmitter);
					emitter.color = 0x33CCFF;
					break;	
				case EMITTERTYPE.SNOW:
					emitter = m_poolManager.getPoolData(CSnowEmitter);
					break;
				/*	
				case EMITTERTYPE.PIXEL_BLOODRED:
					emitter = m_poolManager.getPoolData(CBlastEmitter);
					emitter.color = 0xFF0000;
					break;		
				*/	
			}		
			emitter.reset(x, y, lifeTime);
			m_renderer.addEmitter(emitter);
							
			// add to list
			if( m_head == null )
			{
				m_head = emitter;
				m_tail = emitter;
			}
			else
			{
				m_tail.next = emitter;
				emitter.prev = m_tail;
				m_tail = emitter;
			}
			
			return emitter;
		}
		
		public function update(elapsedTime:int):void
		{
			if ( m_enable )
			{
				// align sprite container with camera
				m_renderer.x = GameVars.cameraPos.x - 320;
				m_renderer.y = GameVars.cameraPos.y - 240;
						
				var emitter:CBaseEmitter = m_head;
			
				while( emitter != null ) 
				{
					if( emitter.isAlive() )
					{
						emitter.particleUpdate(elapsedTime);
						emitter = emitter.next;
					}
					else	
					{
						var garbage:CBaseEmitter = emitter;
						emitter = emitter.next;
						
						remove(garbage);
						sendToPool(garbage);
					}
				}
			}
		}
			
		public function remove(emitter:CBaseEmitter): void
		{
			m_emitterCount--;
			emitter.remove();
			
			m_renderer.removeEmitter(emitter);
			
			/* check if object is a list head */
			if( emitter.prev == null )
			{
				if( emitter.next != null )
				{
					m_head = emitter.next;
					emitter.next.prev = null;
					emitter.next = null;
				}
				else 
				{
					m_head = null;
					m_tail = null;
				}
			}
			
			/* check if object is a list body */
			else if( emitter.prev != null && emitter.next != null )
			{
				// this is a body
				emitter.prev.next = emitter.next;
				emitter.next.prev = emitter.prev;
				
				emitter.prev = null;
				emitter.next = null;
			}
			
			/* check if object is a list tail */
			else if( emitter.next == null )
			{
				if (emitter.prev != null) 
				{
					// this is the tail
					m_tail = emitter.prev;
					emitter.prev.next = null;
					emitter.prev = null;
				}
			}
		}
		
		private function sendToPool(emitter:CBaseEmitter): void
		{
			/* send object to pool */
			if ( emitter is CTrailEmitter )			m_poolManager.setPoolData(CTrailEmitter, emitter);
			else if ( emitter is CSnowEmitter )		m_poolManager.setPoolData(CSnowEmitter, emitter);
			//else if ( emitter is CBlastEmitter )	m_poolManager.setPoolData(CBlastEmitter, emitter);
			else
			{
				trace("Debug: Unknown object are sent to ParticleManager pool [", getQualifiedClassName(emitter), "]");	
			}
		}
		
		public function get stageWidth():int 
		{
			return m_stageWidth;
		}
			
		public function get stageHeight():int 
		{
			return m_stageHeight;
		}
		
		public function set enable(value:Boolean):void
		{
			if( value != m_enable )
			{
				var eventId:String;
			
				m_enable = value;
				switch(m_enable)
				{
					case true: 
						eventId = PARTICLE_ENABLED;
						break;
					case false:
						eventId = PARTICLE_DISABLED;
						break;
				}
				trace(m_enable);
				dispatchEvent(new Event(eventId));
			}
		}
		
		public function get enable():Boolean
		{
			return m_enable;
		}
		
		public function toggleParticle():void
		{
			enable = !m_enable;
		}
			
		static public function getInstance(): ParticleManager
		{
			if( m_instance == null ){
				m_instance = new ParticleManager( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}