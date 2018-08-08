package  
{
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CMovingPrey extends CGoodFood
	{
		private var m_verticalSpeed:Number;// = 0.05;
		private var m_direction:int = -1;
		private var m_waveLength:int;
		private var m_centerY:int;
		
		public function CMovingPrey() { }
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			m_centerY = y;
			
			m_verticalSpeed = (Math.floor( OpMath.randomRange(7, 10) ) * 100) / 10000;
			m_waveLength = Math.ceil(OpMath.randomRange(250, 350));
			m_direction = (OpMath.randomNumber(100) < 50) ? 1 : -1;
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			m_clip.y += (m_verticalSpeed * elapsedTime) * m_direction;
			
			if ( Math.abs(m_clip.y - m_centerY) > m_waveLength )
			{
				m_direction *= -1;
			}
		}
		
	}

}