package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;
		
	import com.shade.geom.CPoint;
	import com.shade.math.OpMath;
	import soulwire.ai.Boid;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBoid 
	{
		// linked list
		public var prev:CBoid;
		public var next:CBoid;
		
		protected var m_active:Boolean;
		protected var m_boid:Boid;
		protected var m_clip:MovieClip;
		protected var m_attractor:CSwarmAttractor;
		protected var m_flock:Vector.<Boid>;
		
		protected var m_boidPosition:CPoint;
		protected var m_predatorPosition:Vector3D;
				
		
		public function CBoid() 
		{
			initialize();
		}
		
		protected function initialize():void 
		{
			m_boid = new Boid();
			m_boidPosition = new CPoint();
			m_predatorPosition = new Vector3D();
			
			m_active = false;
		}
		
		public function reset(source:CPoint, attractor:CSwarmAttractor, flock:Vector.<Boid>): void
		{
			m_attractor = attractor;
			m_active = true;
			m_flock = flock;
			
			m_boidPosition.x = m_boid.x = m_clip.x = source.x;
			m_boidPosition.y = m_boid.y = m_clip.y = source.y;
			
			GameVars.rootClip.addChild( m_clip );	
		}
		
		public function remove(): void 
		{
			GameVars.rootClip.removeChild( m_clip );
		}
		
		public function isAlive():Boolean
		{
			return m_active;
		}
		
		public function getBoid():Boid
		{
			return m_boid;
		}
		
		public function update(elapsedTime:int):void
		{
			// TO BE INHERITED
		}
		
		public function getClip():MovieClip
		{
			return m_clip;
		}
		
		public function flee(): void
		{
			var predator:CBasePredator = PredatorManager.getInstance().getFirstPredator();
			
			var nearestPredator:CBasePredator = null;
			var nearestDistance:int = 1000000;
			
			while ( predator != null )
			{
				if ( predator.isAlive() )
				{
					var distance:int = OpMath.distance( getPosition(), predator.getPosition() );
					if( distance < nearestDistance )
					{
						nearestDistance = distance;
						nearestPredator = predator;
					}
				}
				predator = predator.next;
			}
				
			if ( nearestPredator != null )
			{
				m_predatorPosition.x = nearestPredator.getPosition().x;
				m_predatorPosition.y = nearestPredator.getPosition().y;
				m_predatorPosition.z = 0;
				m_boid.flee( m_predatorPosition, GameVars.disperseDistance );
			}
		}
		
		public function getPosition(): CPoint
		{
			return m_boidPosition;
		}
		
		public function setDead(): void
		{
			m_active = false;
		}
	}
}