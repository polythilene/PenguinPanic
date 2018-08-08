package  
{
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CFoodFish03 extends CMovingPrey /*CGoodFood*/
	{
		public function CFoodFish03() { }
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Krill();
			m_clip.scaleX = 1;
			m_clip.scaleY = 1;
			m_clip.cacheAsBitmap = true;
			
			m_point = 300;
		}
	}
}