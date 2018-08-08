package  
{
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBadFish01 extends CBadFood
	{
		public function CBadFish01() { }
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Bubble_Toxic();
			m_clip.scaleX = 1;
			m_clip.scaleY = 1;
			m_clip.cacheAsBitmap = true;
			
			m_point = -150;
		}
	}
}