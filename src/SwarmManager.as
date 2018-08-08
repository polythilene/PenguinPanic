package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
		
	import de.polygonal.core.*;
	import soulwire.ai.Boid;
	
	import com.shade.geom.CPoint;
	import com.shade.math.OpMath;
	
	
	/**
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	*/
	public class SwarmManager extends EventDispatcher
	{
		// instance
		static private var m_instance:SwarmManager;
		
		// events
		public static var RAPID_STREAM:String = "rapid_stream";
		public static var BOID_ADDED:String = "boid_added";
		public static var BOID_REMOVED:String = "boid_removed";
		
		/* active boid list */
		private var m_head:CBoid;
		private var m_tail:CBoid;
		
		/* object pool */
		private var m_poolManager:CPoolManager;
		
		private var m_flock: Vector.<Boid>;
		private var m_panic:Boolean;
		private var m_stream:Boolean;
		private var m_streamAge:int;
		private var m_count:int;
		
		public function SwarmManager(lock:SingletonLock)	
		{
			initialize();
		}
		
		protected function initialize():void
		{
			m_flock = new Vector.<Boid>();
						
			m_poolManager = new CPoolManager();
			m_poolManager.registerPool(CPenguin, 30);
			
			reset();
		}
		
		public function clear(): void
		{
			var boid:CBoid = m_head;
			while( boid != null ) 
			{
				boid.setDead();
				
				var garbage:CBoid = boid;
				boid = boid.next;
					
				remove(garbage);
				sendToPool(garbage);
			}
		}
		
		protected function reset():void
		{
			m_panic = false;
			m_count = 0;
			m_stream = false;
		}

	    /**
	     * 
	     * @param target
	     * @param missile_type
	     */
	    public function add( boid_type:int, source:CPoint, attractor:CSwarmAttractor ): CBoid
	    {
			var boid:CBoid;
			
			m_count++;
			
			switch( boid_type )
			{
				case BOIDTYPE.PENGUIN:
							boid = m_poolManager.getPoolData(CPenguin);
							break;
			}
			
			// assign 
			boid.reset(source, attractor, m_flock);
			m_flock.push( boid.getBoid() );
									
			// add to list
			if( m_head == null )
			{
				m_head = boid;
				m_tail = boid;
			}
			else
			{
				m_tail.next = boid;
				boid.prev = m_tail;
				m_tail = boid;
			}
			
			signalBoidAdded(boid);
									
			return boid;
	    }
		
		public function update(elapsedTime:int):void
		{
			// update panic
			
			if ( m_panic )
			{
				if ( GameVars.currentStamina > 0 )
					GameVars.currentStamina -= 0.03 * elapsedTime;
				
				if ( GameVars.currentStamina <= 0 )
				{
					GameVars.currentStamina = 0;
					GameVars.gameUI.staminaBar.indicator.bar.gotoAndPlay(1);
					m_panic = false;
				}
				GameVars.refreshStaminaBar();
			}
			
			// update boid
			
			var boid:CBoid = m_head;
			while( boid != null ) 
			{
				if( boid.isAlive() )
				{
					boid.update(elapsedTime);
					boid = boid.next;
				}
				else	
				{
					var garbage:CBoid = boid;
					boid = boid.next;
					
					remove(garbage);
					sendToPool(garbage);
				}
			}
			
			if ( m_stream )
			{
				m_streamAge -= elapsedTime;
				m_stream = ( m_streamAge > 0 );
			}		
		}
		
		public function remove(boid:CBoid): void
		{
			m_count--;
			
			signalBoidRemoved(boid);
			
			var index:int = m_flock.indexOf( boid.getBoid() );
			m_flock.splice(index, 1);
								
			boid.remove();
			
			/* check if object is a list head */
			if( boid.prev == null )
			{
				if( boid.next != null )
				{
					m_head = boid.next;
					boid.next.prev = null;
					boid.next = null;
				}
				else 
				{
					m_head = null;
					m_tail = null;
				}
			}
			
			/* check if object is a list body */
			else if( boid.prev != null && boid.next != null )
			{
				// this is a body
				boid.prev.next = boid.next;
				boid.next.prev = boid.prev;
				
				boid.prev = null;
				boid.next = null;
			}
			
			/* check if object is a list tail */
			else if( boid.next == null )
			{
				if(boid.prev != null) {
					
					// this is the tail
					m_tail = boid.prev;
					boid.prev.next = null;
					boid.prev = null;
				}
			}
		}
		
		public function getCount(): int
		{
			return m_count;
		}
		
		private function sendToPool(boid:CBoid): void
		{
			/* send boids to pool */
		
			if( boid is CPenguin )	m_poolManager.setPoolData(CPenguin, boid);
			else
			{
				trace("Debug: Unknown object are sent to SwarmManager pool [", getQualifiedClassName(boid), "]");	
			}
		}
		
		public function signalPanic(): void
		{
			GameVars.panicCounter++;
			
			if( GameVars.panicCounter == 50 && 
				!GameVars.achievementTotalParanoidObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementTotalParanoidObtained = true;
				GameLoop.getInstance().showAchievement( "Total Paranoid.", "50x Using Panic Ability.", 300 );
			}
			
			if( GameVars.currentStamina > 0 && !m_panic )
			{
				m_panic = true;
				GameVars.gameUI.staminaBar.indicator.bar.gotoAndPlay(2);
			}
		}
		
		public function isPanic(): Boolean
		{
			return m_panic;
		}
	
		public function getFirstBoid():CBoid
		{
			return m_head;
		}
		
		public function getLastBoid():CBoid
		{
			return m_tail;
		}
		
		public function signalRapidStream(): void
		{
			GameVars.surfCounter++;
			
			if( GameVars.surfCounter == 20 &&
				!GameVars.achievementSurfFreakObtained &&
				GameVars.gameMode == 0 )
			{
				GameVars.achievementSurfFreakObtained = true;
				GameLoop.getInstance().showAchievement("Surf Freak.", "20x Rapid Stream Surfing.", 300);
			}
			
			
			var event:SwarmEvent = new SwarmEvent(RAPID_STREAM);
			m_streamAge = event.lifeTime = 10000;
			m_stream = true;
						
			dispatchEvent( event );
		}
		
		public function signalBoidAdded(boid:CBoid): void
		{
			var event:SwarmEvent = new SwarmEvent(BOID_ADDED);
			event.boid = boid;
									
			dispatchEvent( event );
		}
		
		public function signalBoidRemoved(boid:CBoid): void
		{
			var event:SwarmEvent = new SwarmEvent(BOID_REMOVED);
			event.boid = boid;
									
			dispatchEvent( event );
		}
		
		public function isStream(): Boolean
		{
			return m_stream;
		}
		
		public function getNearestBoid(from:CPoint): CBoid
		{
			var boid:CBoid = m_head;
			var nearestDistance:int = 1000000000;
			var nearestBoid:CBoid = null;
						
			while ( boid != null )
			{
				var boidPos:CPoint = boid.getPosition();
				var distance:int = OpMath.distance( from, boidPos );
				if ( distance < nearestDistance )
				{
					nearestDistance = distance;
					nearestBoid = boid;
				}
				boid = boid.next;
			}
			return nearestBoid;
		}
		
		static public function getInstance(): SwarmManager
	    {
			if( m_instance == null ){
            	m_instance = new SwarmManager( new SingletonLock() );
            }
			return m_instance;
	    }

	}
}

class SingletonLock{}