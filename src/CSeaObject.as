package  
{
	import flash.display.MovieClip;
		
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CSeaObject 
	{
		// linked list
		public var prev:CSeaObject;
		public var next:CSeaObject;
		
		protected var m_active:Boolean;
		protected var m_clip:MovieClip;
		protected var m_scrollSpeed:Number;
		protected var m_collision:Boolean;
			
		public function CSeaObject() 
		{
			initialize();
		}
		
		protected function initialize():void
		{
			/* ABSTRACT METHOD */
		}
		
		public function reset(x:int, y:int):void
		{
			m_clip.x = x;
			m_clip.y = y;
			
			m_active = true;
			GameVars.rootClip.addChild( m_clip );
		}
		
		public function remove():void
		{
			GameVars.rootClip.removeChild(m_clip);
		}
		
		public function isAlive():Boolean
		{
			return m_active;
		}
		
		public function setDead():void
		{
			m_active = false;
		}
		
		public function update(elapsedTime:int):void
		{
			if( m_clip.x < GameVars.cameraPos.x - 320 - 1500 )
			{
				m_active = false;
			}
			else
			{
				m_clip.x -= m_scrollSpeed * elapsedTime;
			}
		}
	}
}