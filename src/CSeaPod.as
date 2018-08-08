package  
{
	import com.shade.math.OpMath;
	import soulwire.ai.Boid;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSeaPod extends CSeaObject
	{
		static public var lastSpawn:int;
		
		public function CSeaPod() {}
		
		override protected function initialize():void 
		{
			m_clip = new Seapod;
			m_clip.alpha = 0.3;
			
			m_scrollSpeed = 0;
		}
		
		override public function reset(x:int, y:int):void
		{
			lastSpawn = getTimer();
			
			m_clip.x = x;
			m_clip.y = y;
			
			m_active = true;
			
			var index:int = GameVars.rootClip.getChildIndex(GameVars.seaWater);
			GameVars.rootClip.addChildAt( m_clip, index + 1 );
		}
	}
}