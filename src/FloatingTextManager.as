package 
{
	import de.polygonal.core.*;
	import com.shade.geom.CPoint;
	
	
	/**
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	*/
	public class FloatingTextManager
	{
		static private var m_instance:FloatingTextManager;
		
		/* active missile list */
		private var m_head:CFloatingText;
		private var m_tail:CFloatingText;
		
		/* object pool */
		private var m_poolManager:CPoolManager;
		
		public function FloatingTextManager(lock:SingletonLock)	
		{
			initialize();
		}
		
		protected function initialize():void
		{
			m_poolManager = new CPoolManager();
			m_poolManager.registerPool(CFloatingText, 5);
		}

		public function clear():void
		{
			var floatingText:CFloatingText = m_head;
			while( floatingText != null ) 
			{
				var garbage:CFloatingText = floatingText;
				floatingText = floatingText.next;
					
				remove(garbage);
				sendToPool(garbage);
			}
		}
		
		/**
	     * 
	     * @param target
	     * @param missile_type
	     */
	    public function add( text:String, x:int, y:int, color:String, lifeTime:int, size:int=14 ): CFloatingText
	    {
			var floatingText:CFloatingText = m_poolManager.getPoolData(CFloatingText);
							
			// assign 
			floatingText.reset( text, x, y, color, lifeTime, size );
			GameVars.rootClip.addChild(floatingText);
												
			// add to list
			if( m_head == null )
			{
				m_head = floatingText;
				m_tail = floatingText;
			}
			else
			{
				m_tail.next = floatingText;
				floatingText.prev = m_tail;
				m_tail = floatingText;
			}
									
			return floatingText;
	    }
		
		public function update(elapsedTime:int):void
		{
			var floatingText:CFloatingText = m_head;
			
			while( floatingText != null ) 
			{
				if( floatingText.isAlive() )
				{
					floatingText.update(elapsedTime);
					floatingText = floatingText.next;
				}
				else	
				{
					var garbage:CFloatingText = floatingText;
					floatingText = floatingText.next;
					
					remove(garbage);
					sendToPool(garbage);
				}
			}
		}
		
		public function remove(floatingText:CFloatingText): void
		{
			GameVars.rootClip.removeChild(floatingText);
			
			/* check if object is a list head */
			if( floatingText.prev == null )
			{
				if( floatingText.next != null )
				{
					m_head = floatingText.next;
					floatingText.next.prev = null;
					floatingText.next = null;
				}
				else 
				{
					m_head = null;
					m_tail = null;
				}
			}
			
			/* check if object is a list body */
			else if( floatingText.prev != null && floatingText.next != null )
			{
				// this is a body
				floatingText.prev.next = floatingText.next;
				floatingText.next.prev = floatingText.prev;
				
				floatingText.prev = null;
				floatingText.next = null;
			}
			
			/* check if object is a list tail */
			else if( floatingText.next == null )
			{
				if(floatingText.prev != null) {
					
					// this is the tail
					m_tail = floatingText.prev;
					floatingText.prev.next = null;
					floatingText.prev = null;
				}
			}
		}
		
		private function sendToPool(floatingText:CFloatingText): void
		{
			/* send boids to pool */
		
			m_poolManager.setPoolData(CFloatingText, floatingText);
		}
		
		static public function getInstance(): FloatingTextManager
	    {
			if( m_instance == null ){
            	m_instance = new FloatingTextManager( new SingletonLock() );
            }
			return m_instance;
	    }

	}
}

class SingletonLock{}