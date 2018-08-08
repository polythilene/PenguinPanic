package  
{
	import com.shade.math.OpMath;
	import flash.display.MovieClip;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBubbles extends CSeaObject 
	{
		public function CBubbles() { }
		
		private var bubbles_01:MovieClip = new Bubbles_1();
		private var bubbles_02:MovieClip = new Bubbles_2();
		private var bubbles_03:MovieClip = new Bubbles_3();
		
		override protected function initialize():void 
		{
			
		}
		
		override public function reset(x:int, y:int):void 
		{
			var dice:int = OpMath.randomNumber(100);
			
			if ( OpMath.numberInRange(dice, 0, 20 ) )
				m_clip = bubbles_03;
			else if ( OpMath.numberInRange(dice, 21, 40 ) )
				m_clip = bubbles_02;
			else
				m_clip = bubbles_01;
			
			m_clip.scaleX = m_clip.scaleY = (Math.floor( OpMath.randomRange(3, 10) ) * 100) / 1000;	//OpMath.randomRange(0.5, 1.0);
			m_clip.cacheAsBitmap = true;
			m_clip.alpha = 0.8;
			//m_clip.rotation = OpMath.randomRange(0, 180);
			m_scrollSpeed = ( Math.floor( OpMath.randomNumber(10) ) * 100) / 10000;
			
			super.reset(x, y);
		}
	}
}