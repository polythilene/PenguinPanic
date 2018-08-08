package  
{
	import flash.display.MovieClip;
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	import soulwire.ai.Boid;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBaseFood 
	{
		// linked list
		public var prev:CBaseFood;
		public var next:CBaseFood;
		
		protected var m_active:Boolean;
		protected var m_clip:MovieClip;
		
		protected var m_point:int;
		protected var m_scrollSpeed:Number;
				
		public function CBaseFood() 
		{
			initialize();
		}
		
		protected function initialize():void
		{
			m_point = 0;
		}
		
		public function reset(x:int, y:int):void
		{
			m_clip.x = x;
			m_clip.y = y;
			m_scrollSpeed = (Math.floor( OpMath.randomRange(3, 10) ) * 100) / 10000;
			
						
			m_active = true;
			GameVars.rootClip.addChild( m_clip );
		}
		
		public function setDead():void
		{
			m_active = false;
		}
		
		public function remove():void
		{
			GameVars.rootClip.removeChild(m_clip);
		}
		
		public function isAlive():Boolean
		{
			return m_active;
		}
		
		public function eaten(eater:CBoid): void
		{
			// TO BE INHERITED
		}
		
		public function update(elapsedTime:int):void
		{
			if ( m_clip.x < GameVars.cameraPos.x - 1000 )
			{
				m_active = false;
			}
			else
			{
				// scroll
				m_clip.x -= m_scrollSpeed * elapsedTime;
				
				// check if food is colliding with penguins
				var boid:CBoid = SwarmManager.getInstance().getFirstBoid();
				var isEaten:Boolean = false;
			
				
				/* check collision with the penguins */
				
				while( boid != null && !isEaten ) 
				{
					if( boid.isAlive() )
					{
						if ( m_clip.hitTestObject( boid.getClip() ) )
						{
							isEaten = true;
							m_active = false;
						
							eaten(boid);
						}
					}
					boid = boid.next;
				}
			}
		}
	}
}