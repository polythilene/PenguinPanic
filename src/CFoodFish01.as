package  
{
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CFoodFish01 extends CMovingPrey /*CGoodFood*/
	{
		public function CFoodFish01() { }
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Krill();
			m_clip.scaleX = 0.5;
			m_clip.scaleY = 0.5;
			m_clip.cacheAsBitmap = true;
			
			m_point = 100;
		}
	}
}