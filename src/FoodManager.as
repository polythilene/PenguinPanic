package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
		
	import de.polygonal.core.*;
	import com.shade.math.OpMath;
	
	
	/***
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	*/
	public class FoodManager extends EventDispatcher
	{
		/* active missile list */
		private var m_head:CBaseFood;
		private var m_tail:CBaseFood;
		
		static private var m_instance:FoodManager;
		
		/* event */
		public static var POWERUP_START:String 		= "powerup_start";
		public static var POWERUP_END:String 		= "powerup_end";
		public static var GOOD_FOOD_EATEN:String 	= "good_food_eaten";
		public static var BAD_FOOD_EATEN:String 	= "bad_food_eaten";
		
		/* object pool */
		private var m_poolManager:CPoolManager;
		
		/* buffer */
		private var m_tickCount:int;
		private var m_spawnCountdown:int;
		
		public function FoodManager(lock:SingletonLock)	
		{
			initialize();
		}
		
		protected function initialize():void
		{
			m_poolManager = new CPoolManager();
			m_poolManager.registerPool(CFoodFish01, 10);
			m_poolManager.registerPool(CFoodFish02, 10);
			m_poolManager.registerPool(CFoodFish03, 10);
			m_poolManager.registerPool(CBadFish01, 10);
			m_poolManager.registerPool(CBadFish02, 10);
			m_poolManager.registerPool(CPowerUpRapidStream, 3);
			m_poolManager.registerPool(CPowerUpMultiplyPoint, 1);
			m_poolManager.registerPool(CPowerUpInvincibility, 1);
			m_poolManager.registerPool(CSchoolOfFish, 2);
			
			reset();
		}
		
		public function reset():void
		{
			m_tickCount = 0;
			m_spawnCountdown = 10000;	// spawn in 10 seconds		
			
			CPowerUpInvincibility.lastSpawn = getTimer();
			CPowerUpMultiplyPoint.lastSpawn = getTimer();
			
			GameVars.resetPowerUps();
		}
		
		public function clear():void
		{
			var food:CBaseFood = m_head;
			while( food != null ) 
			{
				food.setDead();
				
				var garbage:CBaseFood = food;
				food = food.next;
					
				remove(garbage);
				sendToPool(garbage);
			}
		}

	    public function add( food_type:int, x:int, y:int ): CBaseFood
	    {
			var food:CBaseFood;
			
			switch( food_type )
			{
				case FOODTYPE.FISH_01:
							food = m_poolManager.getPoolData(CFoodFish01);
							break;
				case FOODTYPE.FISH_02:
							food = m_poolManager.getPoolData(CFoodFish02);
							break;
				case FOODTYPE.FISH_03:
							food = m_poolManager.getPoolData(CFoodFish03);
							break;			
				case FOODTYPE.BADFISH_01:
							food = m_poolManager.getPoolData(CBadFish01);
							break;
				case FOODTYPE.BADFISH_02:
							food = m_poolManager.getPoolData(CBadFish02);
							break;
				case FOODTYPE.POWERUP_RAPIDSTREAM:
							food = m_poolManager.getPoolData(CPowerUpRapidStream);
							break;			
				case FOODTYPE.POWERUP_POINT_X3:
							food = m_poolManager.getPoolData(CPowerUpMultiplyPoint);
							break;
				case FOODTYPE.POWERUP_INVINCIBLE:
							food = m_poolManager.getPoolData(CPowerUpInvincibility);
							break;
				case FOODTYPE.SCHOOLOFFISH:
							food = m_poolManager.getPoolData(CSchoolOfFish);
							break;			
			}
			
			// assign 
			food.reset(x, y);
												
			// add to list
			if( m_head == null )
			{
				m_head = food;
				m_tail = food;
			}
			else
			{
				m_tail.next = food;
				food.prev = m_tail;
				m_tail = food;
			}
			
			return food;
	    }
		
		public function update(elapsedTime:int):void
		{
			var food:CBaseFood = m_head;
			
			while( food != null ) 
			{
				if( food.isAlive() )
				{
					food.update(elapsedTime);
					food = food.next;
				}
				else	
				{
					var garbage:CBaseFood = food;
					food = food.next;
					
					remove(garbage);
					sendToPool(garbage);
				}
			}
			
			/* update power up */
			GameVars.updatePowerUps(elapsedTime);
			
			/* spawn rapid stream */	
			m_spawnCountdown -= elapsedTime;
			if ( m_spawnCountdown <= 0 && 
				 ( GameVars.stream_tier_one > 0 || 
				   GameVars.stream_tier_two > 0 || 
				   GameVars.stream_tier_three > 0) )
			{
				var dice:int = Math.round( OpMath.randomNumber(100) );
				
				var count:int;
				var pos:int;
				
				if( dice < GameVars.stream_tier_one )
					count = 1;	
				else if (dice >= GameVars.stream_tier_one && dice < GameVars.stream_tier_one + GameVars.stream_tier_two)
					count = 2;
				else
					count = 3;
				
				switch( count )
				{
					case 1: pos = Math.floor( OpMath.randomRange(100, 600) );
							break;
					case 2:	pos = Math.floor( OpMath.randomRange(300, 400) );	//pos = Math.floor( 1200 / 3);
							break;
					case 3:	pos = Math.floor( OpMath.randomRange(200, 400) );	//Math.floor( 1200 / 4);
							break;		
				}
				
				for ( var i:int = 0; i < count; i++ ) 
					add( FOODTYPE.POWERUP_RAPIDSTREAM, GameVars.cameraPos.x + 800, pos * (i+1) );
								
				m_spawnCountdown = GameVars.stream_interval;
			}	
			
			
			/* update tick */
			m_tickCount += elapsedTime;
			if ( m_tickCount > 500 && !GameVars.gameOver )
			{
				m_tickCount = 0;
				tick();
			}
		}
		
		private function tick(): void
		{
			
			// do not spawn food on last 10 seconds
			
			if ( GameVars.minute > 0 || GameVars.second > 10 )
			{
			
				// randomly spawn new food
				var factor:Number = SwarmManager.getInstance().isStream() ? 1.5 : 1;
							
				if( OpMath.randomNumber(100) < GameVars.krill_tier_one * factor )
					add( FOODTYPE.FISH_01, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 1000) );
				
				if( OpMath.randomNumber(100) < GameVars.krill_tier_two * factor )
					add( FOODTYPE.FISH_02, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 1000) );
					
				if( OpMath.randomNumber(100) < GameVars.krill_tier_three * factor )
					add( FOODTYPE.FISH_03, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 1000) );
					
				if( OpMath.randomNumber(100) < GameVars.toxic_tier_one * factor )
					add( FOODTYPE.BADFISH_01, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 800) );
					
				if( OpMath.randomNumber(100) < GameVars.toxic_tier_two * factor )
					add( FOODTYPE.BADFISH_02, GameVars.cameraPos.x + 800, OpMath.randomRange(600, 1200) );
					
				if( OpMath.randomNumber(100) * GameVars.luckFactor < GameVars.multiplier_spawn_rate * factor && 
					getTimer() - CPowerUpMultiplyPoint.lastSpawn  > GameVars.multiplier_interval )
					add( FOODTYPE.POWERUP_POINT_X3, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 600) );
				
				if( OpMath.randomNumber(100) * GameVars.luckFactor < GameVars.invincible_spawn_rate * factor && 
					getTimer() - CPowerUpInvincibility.lastSpawn  > GameVars.invincible_interval )
					add( FOODTYPE.POWERUP_INVINCIBLE, GameVars.cameraPos.x + 800, OpMath.randomRange(200, 600) );
					
				if( OpMath.randomNumber(100) < GameVars.smallfish_spawn_rate * factor && 
					getTimer() - CSchoolOfFish.lastSpawn > GameVars.smallfish_interval )
				{
					add( FOODTYPE.SCHOOLOFFISH, GameVars.cameraPos.x + 800, OpMath.randomRange(400, 1000) );	
				}
			}
		}
		
		public function remove(food:CBaseFood): void
		{
			/* remove clip */
			food.remove();
						
			/* check if object is a list head */
			if( food.prev == null )
			{
				if( food.next != null )
				{
					m_head = food.next;
					food.next.prev = null;
					food.next = null;
				}
				else 
				{
					m_head = null;
					m_tail = null;
				}
			}
			
			/* check if object is a list body */
			else if( food.prev != null && food.next != null )
			{
				// this is a body
				food.prev.next = food.next;
				food.next.prev = food.prev;
				
				food.prev = null;
				food.next = null;
			}
			
			/* check if object is a list tail */
			else if( food.next == null )
			{
				if(food.prev != null) {
					
					// this is the tail
					m_tail = food.prev;
					food.prev.next = null;
					food.prev = null;
				}
			}
		}
		
		private function sendToPool(food:CBaseFood): void
		{
			/* send object to pool */
			
			if ( food is CFoodFish01 )	m_poolManager.setPoolData(CFoodFish01, food);
			else if ( food is CFoodFish02 )	m_poolManager.setPoolData(CFoodFish02, food);
			else if ( food is CFoodFish03 )	m_poolManager.setPoolData(CFoodFish03, food);
			else if ( food is CBadFish01 )	m_poolManager.setPoolData(CBadFish01, food);
			else if ( food is CBadFish02 )	m_poolManager.setPoolData(CBadFish02, food);
			else if ( food is CPowerUpRapidStream )		m_poolManager.setPoolData(CPowerUpRapidStream, food);
			else if ( food is CPowerUpMultiplyPoint ) 	m_poolManager.setPoolData(CPowerUpMultiplyPoint, food);
			else if ( food is CPowerUpInvincibility ) 	m_poolManager.setPoolData(CPowerUpInvincibility, food);
			else if ( food is CSchoolOfFish ) 	m_poolManager.setPoolData(CSchoolOfFish, food);
			else
			{
				trace("Debug: Unknown object are sent to FoodManager pool [", getQualifiedClassName(food), "]");	
			}
		}
		
		public function signalPowerUpStart(powerUp:int): void
		{
			var event:PowerUpEvent = new PowerUpEvent(POWERUP_START);
			event.powerup = powerUp;
			
			dispatchEvent( event );
		}
		
		public function signalPowerUpEnd(powerUp:int): void
		{
			var event:PowerUpEvent = new PowerUpEvent(POWERUP_END);
			event.powerup = powerUp;
			
			dispatchEvent( event );
		}
		
		public function signalBadFoodEatenEnd(): void
		{
			dispatchEvent( new Event(BAD_FOOD_EATEN) );
		}
		
		public function signalGoodFoodEatenEnd(): void
		{
			dispatchEvent( new Event(GOOD_FOOD_EATEN) );
		}
		
		static public function getInstance(): FoodManager
	    {
			if( m_instance == null ){
            	m_instance = new FoodManager( new SingletonLock() );
            }
			return m_instance;
	    }
	}
}

class SingletonLock{}