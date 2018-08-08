package  
{
	import com.shade.math.OpMath;
	import flash.filters.BlurFilter;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CMenuBubbles extends CSeaObject 
	{
		public function CMenuBubbles() { }
		
		override public function reset(x:int, y:int):void
		{
			m_clip.x = x;
			m_clip.y = y;
			
			m_active = true;
			GameVars.menuBackground.addChild( m_clip );
			
			m_clip.filters = [ new BlurFilter(5, 5, 3) ];
		}
		
		override public function remove():void
		{
			m_clip.filters = null;
			GameVars.menuBackground.removeChild(m_clip);
		}
		
		override protected function initialize():void 
		{
			m_clip = new Bubbles_1;
			m_clip.scaleX = m_clip.scaleY = (Math.floor( OpMath.randomRange(3, 10) ) * 100) / 1000;	//OpMath.randomRange(0.25, 0.55);
			m_clip.rotation = OpMath.randomRange(0, 180);
			m_clip.cacheAsBitmap = true;
			
			m_scrollSpeed = ( Math.floor( OpMath.randomRange(1, 10) ) * 100) / 10000;
		}
		
		override public function update(elapsedTime:int):void 
		{
			if( m_clip.y <  -200 )
			{
				m_active = false;
			}
			else
			{
				m_clip.y -= m_scrollSpeed * elapsedTime;
			}
		}
	}
}