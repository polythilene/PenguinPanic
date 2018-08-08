package  
{
	import com.shade.math.OpMath;
	import soulwire.ai.Boid;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CObstacleReef extends CSeaObject
	{
		public function CObstacleReef() {}
		
		override protected function initialize():void 
		{
			m_clip = new Reef;
			m_clip.alpha = 0.8;
			
			m_scrollSpeed = 0;
		}
		
		override public function reset(x:int, y:int):void
		{
			m_clip.x = x;
			m_clip.y = y;
			
			m_active = true;
			
			var index:int = GameVars.rootClip.getChildIndex(GameVars.seaWater);
			GameVars.rootClip.addChildAt( m_clip, index + 1 );
			
			m_clip.gotoAndStop( Math.round( OpMath.randomRange(1, 4) ) );
		}
	}
}