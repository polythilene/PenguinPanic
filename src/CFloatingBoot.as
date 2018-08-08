package  
{
	import com.shade.math.OpMath;
	import soulwire.ai.Boid;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CFloatingBoot extends CSeaObject
	{
		static public var lastSpawn:int;
		
		public function CFloatingBoot() {}
		
		override protected function initialize():void 
		{
			m_clip = new OldBoot;
			m_clip.alpha = 0.4;
			
			m_scrollSpeed = ( Math.floor( OpMath.randomNumber(10) ) * 100) / 10000;
		}
		
		override public function reset(x:int, y:int):void 
		{
			super.reset(x, y);
			lastSpawn = getTimer();
		}
	}
}