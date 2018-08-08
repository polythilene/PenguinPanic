package  
{
	import com.shade.geom.CPoint;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSwarmAttractor
	{
		private var m_position:Vector3D;
		
		public function CSwarmAttractor() 
		{
			m_position = new Vector3D();
		}
		
		public function setPosition(value:CPoint):void
		{
			m_position.x = value.x;
			m_position.y = value.y;
			m_position.z = 0;
		}
		
		public function getPosition():Vector3D
		{
			return m_position;
		}
	}
}