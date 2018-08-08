package  
{
	import com.shade.geom.CPoint;
	
	import org.flintparticles.common.counters.Counter;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.PointZone;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBaseEmitter extends Emitter2D
	{
		public var prev:CBaseEmitter;
		public var next:CBaseEmitter;
		
		protected var m_active:Boolean;
		
		protected var m_lifeTime:int;
		protected var m_decay:Boolean;
		protected var m_decayTime:int;
		protected var m_color:int;
		
		public function CBaseEmitter() 
		{
			initialize();
		}
		
		protected function initialize(): void
		{
			m_color = 0xFFFFFF;
		}
		
		public function reset(x:int, y:int, lifeTime:int): void
		{
			m_lifeTime = lifeTime;
			
			m_active = true;
			m_decay = false;
			m_decayTime = 5000;
		}
		
		public function remove(): void
		{
			// ABSTRACT METHOD
		}
						
		public function setDead(): void
		{
			m_active = false;
		}
		
		public function setPosition(x:int, y:int): void
		{
			// translate to local coordinate
			var screen_x:int = x - (GameVars.cameraPos.x - 320);
			var screen_y:int = y - (GameVars.cameraPos.y - 240);
			
			this.x = screen_x;
			this.y = screen_y;
		}
		
		public function particleUpdate(elapsedTime:int): void
		{
			m_lifeTime -= elapsedTime;
			m_decay = (m_lifeTime <= 0);
				
			if ( m_decay ) 
			{
				m_decayTime -= elapsedTime;
				if ( m_decayTime <= 0 )
					m_active = false;
			}
		}
		
		public function isAlive():Boolean
		{
			return m_active;
		}
		
		public function isDecay():Boolean
		{
			return m_decay;
		}
		
		public function set color(value:int):void
		{
			m_color = value;
		}
		
		public function get color():int
		{
			return m_color;
		}
	}

}