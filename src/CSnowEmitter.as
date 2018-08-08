package  
{
	import flash.geom.Point;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.initializers.Position
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.common.initializers.ScaleImageInit;
	import org.flintparticles.common.initializers.ImageClass
	import org.flintparticles.twoD.zones.LineZone;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSnowEmitter extends CBaseEmitter
	{
		public function CSnowEmitter() 
		{
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			counter = new Steady( 15 );
			
			/* particle initializers */
			addInitializer( new ImageClass( RadialDot, 2 ) );
			addInitializer( new Position( new LineZone( new Point( -5, -5 ), new Point( 670, -5 ) ) ) );
			addInitializer( new Velocity( new PointZone( new Point( -25, 85 ) ) ) );
			addInitializer( new ScaleImageInit( 0.75, 2 ) );

			/* actions */
			addAction( new Move() );
			addAction( new DeathZone( new RectangleZone( -10, -10, 670, 480 ), true ) );
			addAction( new RandomDrift( 200, 50 ) );
		}
		
		override public function reset(x:int, y:int, lifeTime:int):void 
		{
			super.reset(x, y, lifeTime);
			
			start();
		}
		
		override public function remove():void 
		{
			stop();
		}
		
		override public function particleUpdate(elapsedTime:int): void
		{
			// do nothing
		}
	}

}