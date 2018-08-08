package 
{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
		
	import de.polygonal.core.*;
	import com.shade.math.OpMath;
	
	
	/***
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	*/
	public class SeaManager
	{
		/* active missile list */
		private var m_head:CSeaObject;
		private var m_tail:CSeaObject;
		
		static private var m_instance:SeaManager;
		
		/* object pool */
		private var m_poolManager:CPoolManager;
		
		/* buffers */
		private var m_tickCounter:int;
		private var m_set:int = 0;
		
		public function SeaManager(lock:SingletonLock)	
		{
			initialize();
		}
		
		public function changeSet(set_id:int):void
		{
			m_set = set_id;
		}
		
		protected function initialize():void
		{
			m_poolManager = new CPoolManager();
			m_poolManager.registerPool(CBubbles, 10);
			m_poolManager.registerPool(CObstacleReef, 10);
			m_poolManager.registerPool(CObstacleAnchor, 10);
			m_poolManager.registerPool(CObstacleIcicle, 10);
			m_poolManager.registerPool(CObstacleJellyFish, 10);
			m_poolManager.registerPool(CLonePenguin, 5);
			m_poolManager.registerPool(CMenuBubbles, 20);
			m_poolManager.registerPool(CMenuPenguin, 3);
			m_poolManager.registerPool(CSeaPod, 2);
			m_poolManager.registerPool(CFloatingBoot, 2);
						
			m_tickCounter = 0;
		}
		
		public function clear():void
		{
			var seaObject:CSeaObject = m_head;
			while( seaObject != null ) 
			{
				seaObject.setDead();
				
				var garbage:CSeaObject = seaObject;
				seaObject = seaObject.next;
					
				remove(garbage);
				sendToPool(garbage);
			}
		}

	    /**
	     * 
	     * @param target
	     * @param missile_type
	     */
	    public function add( object_type:int, x:int, y:int ): CSeaObject
	    {
			var seaObject:CSeaObject;
			
			switch( object_type )
			{
				case OBJECTTYPE.BUBBLES:
							seaObject =  m_poolManager.getPoolData(CBubbles);
							break;
				case OBJECTTYPE.REEF:
							seaObject = m_poolManager.getPoolData(CObstacleReef);
							break;
				case OBJECTTYPE.ANCHOR:
							seaObject = m_poolManager.getPoolData(CObstacleAnchor);
							break;
				case OBJECTTYPE.ICICLE:
							seaObject = m_poolManager.getPoolData(CObstacleIcicle);
							break;
				case OBJECTTYPE.JELLYFISH:
							seaObject = m_poolManager.getPoolData(CObstacleJellyFish);
							break;
				case OBJECTTYPE.LONEPENGUIN:
							seaObject = m_poolManager.getPoolData(CLonePenguin);
							break;			
				case OBJECTTYPE.MENUBUBBLES:
							seaObject = m_poolManager.getPoolData(CMenuBubbles);
							break;	
				case OBJECTTYPE.MENUPENGUIN:
							seaObject = m_poolManager.getPoolData(CMenuPenguin);
							break;
				case OBJECTTYPE.SEAPOD:
							seaObject = m_poolManager.getPoolData(CSeaPod);
							break;
				case OBJECTTYPE.FLOATINGBOOT:
							seaObject = m_poolManager.getPoolData(CFloatingBoot);
							break;			
			}
			seaObject.reset(x, y);
			
			// add to list
			if( m_head == null )
			{
				m_head = seaObject;
				m_tail = seaObject;
			}
			else
			{
				m_tail.next = seaObject;
				seaObject.prev = m_tail;
				m_tail = seaObject;
			}
			
			return seaObject;
	    }
		
		public function update(elapsedTime:int):void
		{
			var seaObject:CSeaObject = m_head;
			while( seaObject != null ) 
			{
				if( seaObject.isAlive() )
				{
					seaObject.update(elapsedTime);
					seaObject = seaObject.next;
				}
				else	
				{
					var garbage:CSeaObject = seaObject;
					seaObject = seaObject.next;
					
					remove(garbage);
					sendToPool(garbage);
				}
			}
			
			m_tickCounter += elapsedTime;
			if ( m_tickCounter > 500 )
			{
				m_tickCounter = 0;
				tick();
			}
		}
		
		private function tick(): void
		{
			/* SET 0 -- INGAME */
			
			if ( m_set == 0 )
			{
			
				// randomly spawn new object 
				
				var factor:Number = SwarmManager.getInstance().isStream() ? 1.5 : 1;
				
				/* spawn bubbles */
				if ( OpMath.randomNumber(100) < 30 * factor )
				{
					add( OBJECTTYPE.BUBBLES, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 1000) );
				}
				
				/* spawn reef */
				if ( OpMath.randomNumber(100) < 15 * factor )
				{
					add( OBJECTTYPE.REEF, GameVars.cameraPos.x + 800, 1200 );
				}
				
				/* spawn anchor */
				if( OpMath.randomNumber(100) < GameVars.anchor_spawn_rate * factor && 
					getTimer() - CObstacleAnchor.lastSpawn > GameVars.anchor_interval )
				{
					add( OBJECTTYPE.ANCHOR, GameVars.cameraPos.x + 400, -OpMath.randomRange(200, 400) );
				}
							
				/* spawn icicle */
				if( OpMath.randomNumber(100) < GameVars.shard_spawn_rate * factor && 
					getTimer() - CObstacleIcicle.lastSpawn > GameVars.shard_interval )
				{
					add( OBJECTTYPE.ICICLE, GameVars.cameraPos.x + OpMath.randomNumber(2000), -150 );
				}
				
				/* spawn jellyfish */
				if( OpMath.randomNumber(100) < GameVars.jellyfish_spawn_rate * factor && 
					getTimer() - CObstacleJellyFish.lastSpawn > GameVars.jellyfish_interval )
				{
					add( OBJECTTYPE.JELLYFISH, GameVars.cameraPos.x + OpMath.randomNumber(2500), 1300 );
				}
				
				/* spawn bystanders */
				if( SwarmManager.getInstance().getCount() < 15 && 
					OpMath.randomNumber(100) < GameVars.bystanders_spawn_rate * factor && 
					getTimer() - CLonePenguin.lastSpawn > GameVars.bystanders_interval )
				{
					add( OBJECTTYPE.LONEPENGUIN, GameVars.cameraPos.x + 1000, OpMath.randomRange(100, 1000) );
				}
				
				/* spawn seapod */
				if ( OpMath.randomNumber(100) < 2 * factor &&
					 getTimer() - CSeaPod.lastSpawn > 20000	)
				{
					add( OBJECTTYPE.SEAPOD, GameVars.cameraPos.x + 800, OpMath.randomRange(500, 800) );
				}
				
				/* spawn boot */
				if ( OpMath.randomNumber(100) < 5 * factor &&
					 getTimer() - CFloatingBoot.lastSpawn > 20000 )
				{
					add( OBJECTTYPE.FLOATINGBOOT, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 1000) );
				}
			}
			
			/* SET 1 -- MENU */
			
			else if ( m_set == 1 )
			{
				/* spawn bubbles */
				if ( OpMath.randomNumber(100) < 15 )
				{
					add( OBJECTTYPE.MENUBUBBLES, OpMath.randomRange( 0, 640 ), 700 );
				}
			}
		}
		
		public function remove(seaObject:CSeaObject): void
		{
			/* remove clip */
			seaObject.remove();
			
			/* check if object is a list head */
			if( seaObject.prev == null )
			{
				if( seaObject.next != null )
				{
					m_head = seaObject.next;
					seaObject.next.prev = null;
					seaObject.next = null;
				}
				else 
				{
					m_head = null;
					m_tail = null;
				}
			}
			
			/* check if object is a list body */
			else if( seaObject.prev != null && seaObject.next != null )
			{
				// this is a body
				seaObject.prev.next = seaObject.next;
				seaObject.next.prev = seaObject.prev;
				
				seaObject.prev = null;
				seaObject.next = null;
			}
			
			/* check if object is a list tail */
			else if( seaObject.next == null )
			{
				if(seaObject.prev != null) {
					
					// this is the tail
					m_tail = seaObject.prev;
					seaObject.prev.next = null;
					seaObject.prev = null;
				}
			}
		}
		
		private function sendToPool(seaObject:CSeaObject): void
		{
			/* send object to pool */
			if ( seaObject is CBubbles )				m_poolManager.setPoolData(CBubbles, seaObject);
			else if ( seaObject is CObstacleReef )		m_poolManager.setPoolData(CObstacleReef, seaObject);
			else if ( seaObject is CObstacleAnchor )	m_poolManager.setPoolData(CObstacleAnchor, seaObject);
			else if ( seaObject is CObstacleIcicle )	m_poolManager.setPoolData(CObstacleIcicle, seaObject);
			else if ( seaObject is CObstacleJellyFish )	m_poolManager.setPoolData(CObstacleJellyFish, seaObject);
			else if ( seaObject is CLonePenguin )		m_poolManager.setPoolData(CLonePenguin, seaObject);
			else if ( seaObject is CMenuBubbles )		m_poolManager.setPoolData(CMenuBubbles, seaObject);
			else if ( seaObject is CMenuPenguin )		m_poolManager.setPoolData(CMenuPenguin, seaObject);
			else if ( seaObject is CSeaObject )			m_poolManager.setPoolData(CSeaObject, seaObject);
			else if ( seaObject is CFloatingBoot )		m_poolManager.setPoolData(CFloatingBoot, seaObject);
			else
			{
				trace("Debug: Unknown object are sent to SeaManager pool [", getQualifiedClassName(seaObject), "]");	
			}
		}
		
		static public function getInstance(): SeaManager
	    {
			if( m_instance == null ){
            	m_instance = new SeaManager( new SingletonLock() );
            }
			return m_instance;
	    }

	}
}

class SingletonLock{}