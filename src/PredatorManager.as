package 
{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.events.EventDispatcher;
		
	import de.polygonal.core.*;
	
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	
	
	/***
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	*/
	public class PredatorManager extends EventDispatcher
	{
		static private var m_instance:PredatorManager;
		
		/* active missile list */
		private var m_head:CBasePredator;
		private var m_tail:CBasePredator;
			
		/* events */
		public static var PREDATOR_SPAWNED:String = "predator_spawned";
		
		/* object pool */
		private var m_poolManager:CPoolManager;
		
		/* buffer */
		private var m_spawnCountdown:int;
		
		public function PredatorManager(lock:SingletonLock)	
		{
			initialize();
		}
		
		protected function initialize():void
		{
			m_poolManager = new CPoolManager();
			m_poolManager.registerPool(CPredatorShark, 1);
			m_poolManager.registerPool(CPredatorSeal, 1);
			
			reset();
		}
		
		public function reset():void
		{
			m_spawnCountdown = 10000;		// spawn in 10 seconds
		}
		
		public function clear():void
		{
			var predator:CBasePredator = m_head;
			while( predator != null ) 
			{
				predator.setDead();
				
				var garbage:CBasePredator = predator;
				predator = predator.next;
					
				remove(garbage);
				sendToPool(garbage);
			}
		}

	    /**
	     * 
	     * @param target
	     * @param missile_type
	     */
	    public function add( predator_type:int, x:int, y:int ): CBasePredator
	    {
			var predator:CBasePredator;
			
			switch( predator_type )
			{
				case PREDATORTYPE.SHARK:
							predator = m_poolManager.getPoolData(CPredatorShark);
							break;
				case PREDATORTYPE.SEAL:
							predator = m_poolManager.getPoolData(CPredatorSeal);
							break;
			}
			
			predator.reset(x, y);
												
			// add to list
			if( m_head == null )
			{
				m_head = predator;
				m_tail = predator;
			}
			else
			{
				m_tail.next = predator;
				predator.prev = m_tail;
				m_tail = predator;
			}
			
			return predator;
	    }
		
		public function update(elapsedTime:int):void
		{
			var predator:CBasePredator = m_head;
			while( predator != null ) 
			{
				if( predator.isAlive() )
				{
					predator.update(elapsedTime);
					predator = predator.next;
				}
				else	
				{
					var garbage:CBasePredator = predator;
					predator = predator.next;
					
					remove(garbage);
					sendToPool(garbage);
				}
			}
			// check spawn time
			
			m_spawnCountdown -= elapsedTime;
			
			if ( m_spawnCountdown <= 0 && !GameVars.gameOver && (GameVars.minute > 0 || GameVars.second > 10) )
			{
				var spawning:CBasePredator = null;
				
				var sharkFactorMin:int = 0
				var sharkFactorMax:int = sharkFactorMin + GameVars.shark_spawn_rate;
				
				var sealFactorMin:int = sharkFactorMax; 
				var sealFactorMax:int = sealFactorMin + GameVars.seal_spawn_rate;
				
				var dice:int = Math.round( OpMath.randomNumber(100) );
				
				
				if( dice >= sharkFactorMin && dice <= sharkFactorMax ) 
					spawning = add( PREDATORTYPE.SHARK, GameVars.cameraPos.x + 800, GameVars.cameraPos.y + OpMath.randomRange( -300, 300) );
				else if ( dice > sealFactorMin && dice <= sealFactorMax) 
					spawning = add( PREDATORTYPE.SEAL, GameVars.cameraPos.x + 800, GameVars.cameraPos.y + OpMath.randomRange( -300, 300) );
				
				if( spawning )
				{
					signalPredatorSpawned( spawning );
					m_spawnCountdown = Math.floor( OpMath.randomRange( GameVars.predator_interval_min, GameVars.predator_interval_max ) );
				}
				
			}
		}
		
		public function remove(predator:CBasePredator): void
		{
			predator.remove();
			
			/* check if object is a list head */
			if( predator.prev == null )
			{
				if( predator.next != null )
				{
					m_head = predator.next;
					predator.next.prev = null;
					predator.next = null;
				}
				else 
				{
					m_head = null;
					m_tail = null;
				}
			}
			
			/* check if object is a list body */
			else if( predator.prev != null && predator.next != null )
			{
				// this is a body
				predator.prev.next = predator.next;
				predator.next.prev = predator.prev;
				
				predator.prev = null;
				predator.next = null;
			}
			
			/* check if object is a list tail */
			else if( predator.next == null )
			{
				if(predator.prev != null) {
					
					// this is the tail
					m_tail = predator.prev;
					predator.prev.next = null;
					predator.prev = null;
				}
			}
		}
		
		private function sendToPool(predator:CBasePredator): void
		{
			if ( predator is CPredatorShark )	m_poolManager.setPoolData(CPredatorShark, predator);
			else if( predator is CPredatorSeal )	m_poolManager.setPoolData(CPredatorSeal, predator);
			else
			{
				trace("Debug: Unknown object are sent to PredatorManager pool [", getQualifiedClassName(predator), "]");	
			}
		}
		
		public function getFirstPredator() : CBasePredator
		{
			return m_head;
		}
		
		public function getLastPredator() : CBasePredator
		{
			return m_tail;
		}
		
		public function signalPredatorSpawned(predator:CBasePredator): void
		{
			var event:PredatorEvent = new PredatorEvent(PREDATOR_SPAWNED);
			event.predator = predator;
									
			dispatchEvent( event );
		}
		
		static public function getInstance(): PredatorManager
	    {
			if( m_instance == null ){
            	m_instance = new PredatorManager( new SingletonLock() );
            }
			return m_instance;
	    }
	}
}

class SingletonLock{}