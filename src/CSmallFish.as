package  
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.display.DisplayObjectContainer;
	
	import soulwire.ai.Boid;
	import gs.TweenMax;
	
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSmallFish extends CBoid
	{
		private var m_point:int;
		
		public function CSmallFish() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new SmallFish();
			m_clip.cacheAsBitmap = true;
			
			m_point = 50;
			
			m_boid.renderData = m_clip;
			m_boid.edgeBehavior = Boid.EDGE_NONE;
			m_boid.maxForce = OpMath.randomRange(1.0, 4.0);
			m_boid.wanderDistance = OpMath.randomRange(100.0, 250.0);
			m_boid.wanderRadius = OpMath.randomRange(50.0, 150.0);
			m_boid.wanderStep = OpMath.randomRange(0.1, 0.9);
			m_boid.maxSpeed = OpMath.randomRange(4, 7);
		}
		
		override public function update(elapsedTime:int):void
		{
			if ( m_boidPosition.x < GameVars.cameraPos.x - 1500 )
			{
				setDead();
			}
			else
			{
				m_boid.wander(0.3);
				m_boid.seek(m_attractor.getPosition(), 0.1);
				m_boid.flock( m_flock );
				flee();
				
				m_boid.update();
				m_boid.render();
				
				m_boidPosition.x = m_clip.x;
				m_boidPosition.y = m_clip.y;
				
				checkCollision();
			}
		}
		
		override public function flee(): void
		{
			var penguin:CBoid = SwarmManager.getInstance().getFirstBoid();
			
			var nearestPenguin:CBoid = null;
			var nearestDistance:int = 1000000;
			
			while ( penguin != null )
			{
				if ( penguin.isAlive() )
				{
					var distance:int = OpMath.distance( getPosition(), penguin.getPosition() );
					if( distance < nearestDistance )
					{
						nearestDistance = distance;
						nearestPenguin = penguin;
					}
				}
				penguin = penguin.next;
			}
				
			if ( nearestPenguin != null )
			{
				m_predatorPosition.x = nearestPenguin.getPosition().x;
				m_predatorPosition.y = nearestPenguin.getPosition().y;
				m_predatorPosition.z = 0;
				m_boid.flee( m_predatorPosition, 300 );
			}
		}
		
		private function checkCollision(): void
		{
			/* check if food is colliding with penguins */
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
						setDead();
						eaten(boid);
					}
				}
				boid = boid.next;
			}
		}
		
		private function eaten(eater:CBoid):void 
		{
			GameVars.currentScore += m_point * GameVars.powerUpPointMultiplier;
			
			/* show floating text */
			var text:String = "+" + String(m_point * GameVars.powerUpPointMultiplier);
			FloatingTextManager.getInstance().add( text, eater.getClip().x, eater.getClip().y, "#00FF33", 3000 );
			
			/* calculate stamina */
			if ( !SwarmManager.getInstance().isPanic() )
			{
				var stamina:int = m_point * 0.035; 
				GameVars.currentStamina += stamina;
				GameVars.currentStamina = Math.min(GameVars.currentStamina, GameVars.maxStamina);
				GameVars.refreshStaminaBar();
			}
			
			/* play sound */
			var dice:int = Math.floor( OpMath.randomNumber( 15 ) );
			switch( dice )
			{
				case 0: SoundManager.getInstance().playSFX( "Water_03" );
						break;
				case 1: SoundManager.getInstance().playSFX( "Water_05" );
						break;
				case 2: SoundManager.getInstance().playSFX( "Water_06" );
						break;		
			}
		}
		
	}
}