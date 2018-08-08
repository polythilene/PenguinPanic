package  
{
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CPredatorShark extends CBasePredator
	{
		
		public function CPredatorShark() { }
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Predator_Shark();
			m_clip.cacheAsBitmap = true;
			m_dummy = Predator_Shark(m_clip).testDummy;
			
			m_agressive = false;
			m_attackTime = 5000;
			
			m_swimSpeed = m_normalSpeed = 0.20;
			m_attackSpeed =  (OpMath.randomRange(4, 5) * 100) / 1000;
		}
	}
}