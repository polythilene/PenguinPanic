package  
{
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CPredatorSeal extends CBasePredator
	{
		
		public function CPredatorSeal() { }
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Predator_Seal();
			m_clip.cacheAsBitmap = true;
			m_dummy = Predator_Seal(m_clip).testDummy;
			
			m_agressive = true;
			m_attackTime = 3000;
			
			m_swimSpeed = m_normalSpeed = 0.15;
			m_attackSpeed = 0.3;
		}
	}
}