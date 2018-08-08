package  
{
	import flash.events.Event;
	import flash.filters.BlurFilter;
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
	public class CMenuPenguin extends CSeaObject
	{
		private var m_boid:Boid;
		private var m_position:CPoint;
		private var m_boidBoundary:Vector3D;
		private var m_centerPoint:CPoint;
				
		public function CMenuPenguin() {}
		
		override protected function initialize():void 
		{
			m_clip = new Penguin();
			m_clip.cacheAsBitmap = true;
			m_scrollSpeed = 0;
			
			m_boid = new Boid();
			m_boid.renderData = m_clip;
			m_boid.edgeBehavior = Boid.EDGE_BOUNCE;
			m_boid.maxForce = OpMath.randomRange(3.0, 6.0);
			m_boid.wanderDistance = OpMath.randomRange(100.0, 200.0);
			m_boid.wanderRadius = OpMath.randomRange(50.0, 150.0);
			m_boid.wanderStep = OpMath.randomRange(0.1, 0.9);
			m_boidBoundary = new Vector3D();
			
			m_centerPoint = new CPoint();
			m_position = new CPoint();
			
			m_clip.filters = [ new BlurFilter(5, 5, 3) ];
		}
		
		override public function reset(x:int, y:int):void 
		{
			m_clip.x = x;
			m_clip.y = y;
			
			m_active = true;
			GameVars.menuBackground.addChild( m_clip );
			
			m_boid.x = x;
			m_boid.y = y;
			m_boid.maxSpeed = OpMath.randomRange(6, 10);
			
			m_boid.boundsRadius = 500;
			m_boidBoundary.x = x;
			m_boidBoundary.y = OpMath.randomRange(200, 1000);	//600;
			m_boidBoundary.z = 0;
			m_boid.boundsCentre = m_boidBoundary;
		}
		
		override public function remove():void 
		{
			GameVars.menuBackground.removeChild(m_clip);
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			m_boid.wander(0.05);
			m_boid.update();
			m_boid.render();
			
			m_position.x = m_boid.x;
			m_position.y = m_boid.y;
		}
	}
}