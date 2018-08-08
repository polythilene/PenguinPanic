package  
{
	import flash.geom.Point;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.counters.Counter;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.initializers.Position
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.zones.DiscZone;
	
	import belugerin.math.OpMath;
	
	import gs.TweenMax;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBlastEmitter extends CBaseEmitter
	{
		private var m_image:Dot;
		private var m_counter:Counter;
		private var m_bloodVector:Point;
		
		public function CBlastEmitter() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			
			/* particle initializers */
			m_image = new Dot( 2, m_color );
			m_bloodVector = new Point();
			
			addInitializer( new SharedImage( m_image ) );
			addInitializer( new Lifetime( 1, 2 ) );
			//addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 200, 120 ) ) );
			addInitializer( new Velocity( new LineZone( new Point(0, 0), m_bloodVector ) ) );
			addInitializer( new Position( new DiscZone(null, 50) ) );
			
			/* particle actions */
			addAction( new Age() );
			addAction( new Move() );
			addAction( new Fade() );
			addAction( new Accelerate( 0, -50 ) );
			addAction( new LinearDrag( 0.5 ) );
			
			
			m_counter = new Blast(100);
		}
		
		override public function reset(x:int, y:int, lifeTime:int):void 
		{
			super.reset(x, y, lifeTime);
			
			// set color
			m_image.color = m_color;
			
			m_bloodVector.x = OpMath.randomRange( -100, 100);
			m_bloodVector.y = -OpMath.randomNumber(100);
		}
		
		override public function remove():void 
		{
			TweenMax.killTweensOf(this);	
			stop();
			
			super.remove();
		}
		
		public function blast(): void
		{
			stop();
			counter = m_counter;
			m_counter.startEmitter(this);
			start();
		}
		
		override public function particleUpdate(elapsedTime:int):void 
		{
			// DO NOTHING
		}
	}
}