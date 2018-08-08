package  
{
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	
	import com.shade.geom.CPoint;
	import com.shade.math.OpMath;
	
	import soulwire.ai.Boid;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSchoolOfFish extends CBaseFood
	{
		public static var lastSpawn:int;
		
		private var m_poolManager:CPoolManager;
		private var m_flock: Vector.<Boid>;
		private var m_swarmAttractor:CSwarmAttractor;
		private var m_count:int;
		private var m_buffPoint:CPoint;
		
		private var m_head:CBoid;
		private var m_tail:CBoid;
				
		public function CSchoolOfFish() { }
		
		override protected function initialize():void 
		{
			m_swarmAttractor = new CSwarmAttractor();
			m_flock = new Vector.<Boid>();
			
			m_poolManager = new CPoolManager();
			m_poolManager.registerPool(CSmallFish, 30);
			
			m_buffPoint = new CPoint();
		}
		
		override public function reset(x:int, y:int):void 
		{
			lastSpawn = getTimer();
			m_active = true;
			
			m_buffPoint.x = x;
			m_buffPoint.y = y;
			
			m_swarmAttractor.setPosition(m_buffPoint);
			
			var frame:int = Math.round( OpMath.randomRange(1, 3) );
			for( var i:int = 0; i < Math.round(OpMath.randomRange(20, 30)); i++ )
				addFish( x, y, frame );
		}
		
		override public function remove():void
		{
			clear();
		}
		
		private function addFish(x:int, y:int, frame:int): CBoid
	    {
			var boid:CBoid;
			
			m_count++;
			boid = m_poolManager.getPoolData(CSmallFish);
			
			// assign 
			m_buffPoint.x += OpMath.randomRange( -20, 20 );
			m_buffPoint.y += OpMath.randomRange( -20, 20 );
			
			boid.reset( m_buffPoint, m_swarmAttractor, m_flock );
			boid.getClip().gotoAndStop( frame );
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
			
			return boid;
	    }
		
		override public function update(elapsedTime:int):void 
		{
			if ( m_swarmAttractor.getPosition().x < GameVars.cameraPos.x - 1500 )
			{
				setDead();
			}
			else
			{
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
					
						removeFish(garbage);
						sendToPool(garbage);
					}
				}
			}
		}
		
		public function removeFish(boid:CBoid): void
		{
			m_count--;
			
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
		
		private function sendToPool(boid:CBoid): void
		{
			/* send boid to pool */
			m_poolManager.setPoolData(CSmallFish, boid);
		}
		
		public function clear(): void
		{
			var boid:CBoid = m_head;
			while( boid != null ) 
			{
				boid.setDead();
				
				var garbage:CBoid = boid;
				boid = boid.next;
					
				removeFish(garbage);
				sendToPool(garbage);
			}
		}
		
		public function getCount(): int
		{
			return m_count;
		}
	}
}