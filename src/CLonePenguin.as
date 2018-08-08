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
	public class CLonePenguin extends CSeaObject
	{
		
		
		public static var lastSpawn:int;
		
		private var m_crash:Boolean;
		private var m_boid:Boid;
		private var m_position:CPoint;
		private var m_gps:FriendLocator;
		private var m_boidBoundary:Vector3D;
		
		
		private var m_centerPoint:CPoint;
		
		public function CLonePenguin() {}
		
		override protected function initialize():void 
		{
			m_clip = new Penguin();
			m_clip.cacheAsBitmap = true;
			m_scrollSpeed = 0;
			
			m_boid = new Boid();
			m_boid.renderData = m_clip;
			m_boid.edgeBehavior = Boid.EDGE_BOUNCE;
			m_boid.maxForce = OpMath.randomRange(3.0, 6.0);
			m_boid.wanderDistance = OpMath.randomRange(400.0, 600.0);
			m_boid.wanderRadius = OpMath.randomRange(150.0, 450.0);
			m_boid.wanderStep = OpMath.randomRange(0.1, 0.9);
			m_boidBoundary = new Vector3D();
			
			m_gps = new FriendLocator();
			m_gps.cacheAsBitmap = true;
			m_gps.alpha = 0.7;
			
			m_centerPoint = new CPoint();
			m_position = new CPoint();
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			m_crash = false;
			lastSpawn = getTimer();
			
			m_boid.x = x;
			m_boid.y = y;
			m_boid.maxSpeed = OpMath.randomRange(6, 10);
			
			m_boid.boundsRadius = 600;
			m_boidBoundary.x = x;
			m_boidBoundary.y = 600;
			m_boidBoundary.z = 0;
			m_boid.boundsCentre = m_boidBoundary;

			
			if ( GameVars.upgradeFriendFinderObtained )
			{
				m_gps.x = GameVars.cameraPos.x;
				m_gps.y = GameVars.cameraPos.y;
				
				GameVars.rootClip.addChild( m_gps );
				SoundManager.getInstance().playSFX("Friend_Alert");
			}
		}
		
		override public function remove():void 
		{
			super.remove();
			
			if ( GameVars.upgradeFriendFinderObtained )
			{
				GameVars.rootClip.removeChild( m_gps );
			}
		}
		
		override public function update(elapsedTime:int):void 
		{
			if( m_clip.x < GameVars.cameraPos.x - 320 - 500 )
			{
				m_active = false;
			}
			else
			{
				m_clip.x -= m_scrollSpeed * elapsedTime;
			}
			
			m_boid.wander(0.25);
			//m_boid.seek(m_boid.boundsCentre, 0.05);
			//m_boid.arrive(m_boid.boundsCentre, 100, 0.5);
			m_boid.update();
			m_boid.render();
			
			m_position.x = m_boid.x;
			m_position.y = m_boid.y;
			
			if ( GameVars.upgradeFriendFinderObtained )
			{
				m_gps.x = m_centerPoint.x = GameVars.cameraPos.x;
				m_gps.y = m_centerPoint.y = GameVars.cameraPos.y;
				
				var angle:Number = OpMath.angleBetweenPos(m_centerPoint, m_position);
				m_gps.rotation = angle;
			}
			
			if( m_active && !m_crash )
				checkCollision();
		}
		
		private function checkCollision():void
		{
			/* check if object is colliding with penguins */
			var boid:CBoid = SwarmManager.getInstance().getFirstBoid();
			
			/* check collision with the penguins */
			while( boid != null ) 
			{
				if( boid.isAlive() && !GameVars.gameOver )
				{
					if( m_clip.hitTestObject( boid.getClip() ) )
					{
						var newBoid:CBoid = SwarmManager.getInstance().add( BOIDTYPE.PENGUIN, m_position, GameVars.defaultAttractor );
						
						m_crash = true;
						setDead();
						
						SoundManager.getInstance().playSFX("Friend_Get");
						
						break;
					}
				}
				boid = boid.next;
			}
		}
	}
}