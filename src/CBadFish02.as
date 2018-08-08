package  
{
	import com.shade.math.OpMath;
	import com.shade.geom.CPoint;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBadFish02 extends CBadFood
	{
		public function CBadFish02() { }
		
		override protected function initialize():void 
		{
			super.initialize();
			
			m_clip = new Bubble_Toxic();
			m_clip.scaleX = 1.5;
			m_clip.scaleY = 1.5;
			m_clip.cacheAsBitmap = true;
			
			m_point = -300;
		}
	}
}